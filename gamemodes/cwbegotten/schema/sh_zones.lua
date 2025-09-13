--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

plugin.Remove("zones");
local playerMeta = FindMetaTable("Player");
zones = {};
zones.totalZones = 0;
zones.stored = {};
zones.supraZones = {};

local ZONE_TABLE = {__index = ZONE_TABLE};

-- Called when the item is converted to a string.
function ZONE_TABLE:__tostring()
	return self.uniqueID;
end;

-- Called when the meta table is called like a function.
function ZONE_TABLE:__call()
	print(self.uniqueID);
end;

-- A function to register a new zone.
function ZONE_TABLE:Register()
	zones:Register(self);
end;

-- A function to get all the registered zones on the server.
function zones:GetAll()
	return self.stored;
end;

-- A function to get a new zone object.
function zones:New(uniqueID, supraZone)
	if (!uniqueID) then
		return;
	end;
	
	if supraZone then
		if !self.supraZones[supraZone] then
			self.supraZones[supraZone] = {};
		end
		
		if !table.HasValue(self.supraZones[supraZone], uniqueID) then
			table.insert(self.supraZones[supraZone], uniqueID);
		end
	end
	
	local object = Clockwork.kernel:NewMetaTable(ZONE_TABLE);
		object.uniqueID = self:SafeName(uniqueID);
		object.supraZone = supraZone;
	return object;
end;

-- A function to convert a string to a safe name.
function zones:SafeName(uniqueID)
	return string.lower(string.gsub(uniqueID, "['%.]", ""));
end;

local map = string.lower(game.GetMap());

-- A function to register a new zone.
function zones:Register(zoneTable)
	if (!zoneTable.map or string.lower(zoneTable.map) != map) then
		return;
	end;
	
	zoneTable.priority = zoneTable.priority or 1;

	if (zoneTable.default and !self.cwDefaultZone) then
		self.cwDefaultZone = zoneTable;
		
		if CLIENT then
			if !self.cwCurrentZone then
				self.cwCurrentZone = self.cwDefaultZone.uniqueID;
			end
			
			if !self.cwPreviousZone then
				self.cwPreviousZone = self.cwDefaultZone.uniqueID;
			end
			
			self.recheckTable = nil;
		end
	end;
		
	if CLIENT then
		if (zoneTable.fogColors) then
			for k, v in pairs (zoneTable.fogColors) do
				zoneTable.fogColors[k] = math.Clamp(zoneTable.fogColors[k], 1, 255);
			end;
		end;
		
		if (zoneTable.fogColorsNight) then
			for k, v in pairs (zoneTable.fogColorsNight) do
				zoneTable.fogColorsNight[k] = math.Clamp(zoneTable.fogColorsNight[k], 1, 255);
			end;
		end;
		
		if (!zoneTable.fogStart) then
			zoneTable.fogStart = self.cwDefaultZone.fogStart;
		end;
		
		if (!zoneTable.fogEnd) then
			zoneTable.fogEnd = self.cwDefaultZone.fogEnd;
		end;
		
		if (!zoneTable.RenderCallback) then
			if !zoneTable.bloomDisabled then
				zoneTable.RenderCallback = self.cwDefaultZone.RenderCallback;
			end
		end;
	end
	
	if (!zoneTable.default and !table.IsEmpty(zoneTable.bounds)) then
		self.totalZones = self.totalZones + 1;
		self.stored[zoneTable.uniqueID] = zoneTable;
	end;
end;

-- A function to find a zone using an identifier.
function zones:FindByID(identifier)
	if !identifier then return end;
	local identifier = string.lower(identifier);
	
	if (identifier == self.cwDefaultZone.uniqueID) then
		return self.cwDefaultZone;
	end;	
	
	if (self.stored[identifier]) then
		return self.stored[identifier];
	else
		for k, v in pairs (self.stored) do
			if (string.find(string.lower(v.name), identifier)) then
				return self.stored[k];
			end;
		end;
	end;
end;

-- A function to get the uniqueID of the zone the player is currently in.
function zones:GetZone()
	return self.cwCurrentZone;
end;

-- A function to get whether the player is in the wasteland or not.
function zones:InWasteland()
	return self:IsDefault(self.cwCurrentZone);
end;

-- A function to get the uniqueID of the zone the player is currently in.
function playerMeta:GetZone()
	return zones:GetZone();
end;

-- A function to get whether the player is in the wasteland or not.
function playerMeta:InWasteland()
	return zones:InWasteland();
end;

-- A function to get whether a zone is the default zone or not.
function zones:IsDefault(identifier)
	if (type(identifier) == "string") then
		return string.lower(identifier) == string.lower(self.cwDefaultZone.uniqueID);
	elseif (type(identifier) == "table") then
		return string.lower(identifier.uniqueID) == string.lower(self.cwDefaultZone.uniqueID);
	end;
end;

if CLIENT then
	-- A function to set the new active zone.
	function zones:SetActiveZone(zoneTable)
		local uniqueID = zoneTable.uniqueID;
		--print("SetActiveZone called for zone: "..uniqueID);
		
		-- If Cash is reading this, contact me about this. Had to add this line to fix day/night fog.
		self.recheckTable = nil;
		
		if (!self.cwCurrentZone) then
			self.cwCurrentZone = self.cwDefaultZone;
		elseif (zoneTable.uniqueID != self.cwCurrentZone) then
			self.cwPreviousZone = self.cwCurrentZone;
			self.cwCurrentZone = zoneTable.uniqueID;
			
			if (zoneTable.OnEnter) then
				zoneTable:OnEnter();
			end;
			
			local previousZoneTable = self:FindByID(self.cwPreviousZone);
			
			if (previousZoneTable and previousZoneTable.OnExit) then
				previousZoneTable:OnExit();
			end;
			
			hook.Run("PlayerChangedZones", self.cwCurrentZone, self.cwPreviousZone)
			
			--print("Setting active zone: "..uniqueID);
			
			if !Clockwork.kernel:IsChoosingCharacter() then
				--print("Sending the active zone to the server!");
				netstream.Start("EnteredZone", uniqueID);
			end
		end;
	end;

	function zones:RefreshCurrentZone()
		self.recheckTable = nil;
	end

	function zones:RefreshZoneVFX()
		local zoneTable = self.currentZoneTable or self.cwDefaultZone;
		
		if (zoneTable) then
			if (self:FogEnabled()) then
				local zoneFogColors = zoneTable.fogColors or {r = 255, g = 255, b = 255};
				
				if (!self.currentFogColors) then self.currentFogColors = {r = 255, g = 255, b = 255}; end;
				if (!self.targetFogColors) then self.targetFogColors = {r = 255, g = 255, b = 255}; end;
				
				local targetFogColorOverride = hook.Run("OverrideZoneFogColors", zoneTable);
				
				for k, v in pairs (self.targetFogColors) do
					if targetFogColorOverride then self.targetFogColors = targetFogColorOverride
					elseif (self.targetFogColors[k] != zoneFogColors[k]) then self.targetFogColors[k] = zoneFogColors[k] end;
					
					if (self.currentFogColors[k] != self.targetFogColors[k]) then
						self.currentFogColors[k] = self.targetFogColors[k];
					end;
				end;
				
				if (zoneTable.fogStart and zoneTable.fogEnd) then
					local fogStart, fogEnd = zoneTable.fogStart, zoneTable.fogEnd;
					local overrideStart, overrideEnd = hook.Run("OverrideZoneFogDistance", zoneTable, fogStart, fogEnd);
					
					if overrideStart and overrideEnd then
						self.targetStart = overrideStart;
						self.targetEnd = overrideEnd;
					else
						if zoneTable.hasNight and !Clockwork.Client.dueling and !Clockwork.kernel:IsChoosingCharacter() then
							if (zoneTable.fogStartNight and zoneTable.fogEndNight) then
								self.targetStart = Lerp(cwDayNight.nightWeight, fogStart, zoneTable.fogStartNight);
								self.targetEnd = Lerp(cwDayNight.nightWeight, fogEnd, zoneTable.fogEndNight);
							else
								self.targetStart = fogStart;
								self.targetEnd = fogEnd;
							end
						else
							self.targetStart = fogStart;
							self.targetEnd = fogEnd;
						end
					end

					self.currentFogStart = self.targetStart;
					self.currentFogEnd = self.targetEnd;
				end
			end
			
			if (self:ColorModEnabled()) then
				if (zoneTable.colorModify) then
					if (!self.currentColorModify) then
						self.currentColorModify = {
							["$pp_colour_brightness"] = 0,
							["$pp_colour_contrast"] = 1,
							["$pp_colour_colour"] = 1,
						};
					end;
				
					if (!self.targetColorModify) then
						self.targetColorModify = {
							["$pp_colour_brightness"] = 0,
							["$pp_colour_contrast"] = 1,
							["$pp_colour_colour"] = 1,
						};
					end
					
					local zoneModify = zoneTable.colorModify;
					
					if zoneTable.hasNight and zoneTable.colorModifyNight and cwDayNight and cwDayNight.nightWeight and !Clockwork.Client.dueling and !Clockwork.kernel:IsChoosingCharacter() then
						local zoneModifyNight = zoneTable.colorModifyNight;
						local newBrightness = Lerp(cwDayNight.nightWeight, zoneModify["$pp_colour_brightness"], zoneModifyNight["$pp_colour_brightness"]);
						local newContrast = Lerp(cwDayNight.nightWeight, zoneModify["$pp_colour_contrast"], zoneModifyNight["$pp_colour_contrast"]);
						local newColour = Lerp(cwDayNight.nightWeight, zoneModify["$pp_colour_colour"], zoneModifyNight["$pp_colour_colour"]);
						
						zoneModify = {["$pp_colour_brightness"] = newBrightness, ["$pp_colour_contrast"] = newContrast, ["$pp_colour_colour"] = newColour};
					end
					
					for k, v in pairs (self.targetColorModify) do
						if (self.targetColorModify[k] != zoneModify[k]) then
							self.targetColorModify[k] = zoneModify[k];
						end;
					end;

					for k, v in pairs (self.currentColorModify) do
						self.currentColorModify[k] = self.targetColorModify[k];
					end;
				end
			end
		end
	end

	function zones:OnReloaded()
		self:RefreshCurrentZone();
		self:RefreshZoneVFX();
	end

	do
		Clockwork.ConVars.ZONES = Clockwork.kernel:CreateClientConVar("cwZones", 1, true, true);
		Clockwork.ConVars.ZONES_DEBUG = Clockwork.kernel:CreateClientConVar("cwZonesDebug", 0, false, true);
		Clockwork.ConVars.ZONES_BLOOM = Clockwork.kernel:CreateClientConVar("cwZonesBloom", 1, true, true);
		Clockwork.ConVars.ZONES_FOG = Clockwork.kernel:CreateClientConVar("cwZonesFog", 1, true, true);
		Clockwork.ConVars.ZONES_COLORMOD = Clockwork.kernel:CreateClientConVar("cwZonesColorMod", 1, true, true);
		
		Clockwork.setting:AddCheckBox("Zones", "Whether or not zones are enabled.", "cwZones", "Completely enable or disable zones and all zone-related effects.", function()
			return Clockwork.player:IsAdmin(Clockwork.Client)
		end);
		
		Clockwork.setting:AddCheckBox("Zones", "Whether or not zone debug information is enabled.", "cwZonesDebug", "Enable or disable zones and all zone debug information.", function()
			return Clockwork.player:IsAdmin(Clockwork.Client)
		end);
		
		Clockwork.setting:AddCheckBox("Zones", "Show bloom effects.", "cwZonesBloom", "Enable or disable bloom effects produced by zones.", function()
			return Clockwork.player:IsAdmin(Clockwork.Client)
		end)

		Clockwork.setting:AddCheckBox("Zones", "Show fog effects.", "cwZonesFog", "Enable or disable fog. (disabled = default map fog)", function()
			return Clockwork.player:IsAdmin(Clockwork.Client)
		end)
		
		Clockwork.setting:AddCheckBox("Zones", "Show color modify effects.", "cwZonesColorMod", "Enable or disable zone-related color modify effects.", function()
			return Clockwork.player:IsAdmin(Clockwork.Client)
		end)

		-- A function to get whether the zones are enabled or not.
		function zones:Enabled()
			if not Clockwork.Client:IsAdmin() then
				return true;
			else
				return Clockwork.ConVars.ZONES:GetBool();
			end
		end;

		-- A function to get whether the zone debug information is enabled or not.
		function zones:DebugEnabled()
			if not Clockwork.Client:IsAdmin() then
				return false;
			else
				return Clockwork.ConVars.ZONES_DEBUG:GetBool();
			end
		end;

		-- A function to get whether zone bloom effects are enabled or not.
		function zones:BloomEnabled()
			if not Clockwork.Client:IsAdmin() then
				return true;
			else
				return Clockwork.ConVars.ZONES_BLOOM:GetBool();
			end
		end;

		-- A function to get whether zone fog effects are enabled or not.
		function zones:FogEnabled()
			if not Clockwork.Client:IsAdmin() then
				return true;
			else
				return Clockwork.ConVars.ZONES_FOG:GetBool();
			end
		end;

		-- A function to get whether zone color modify effects are enabled or not.
		function zones:ColorModEnabled()
			if not Clockwork.Client:IsAdmin() then
				return true;
			else
				return Clockwork.ConVars.ZONES_COLORMOD:GetBool();
			end
		end;
	end;

	-- Called when the player changes zones.
	function zones:PlayerChangedZones(newZone, previousZone)
		if (!self:Enabled()) then
			return;
		end;
		
		if (newZone == previousZone) then
			return;
		end;

		self.recheckTable = nil;
	end;

	-- Called every frame.
	function zones:Think()
		local curTime = CurTime();
		
		if (!self:Enabled()) then
			return;
		end;
			
		if (!self.nextZoneTick or self.nextZoneTick < curTime) then
			self.nextZoneTick = curTime + 0.25;

			local client = Clockwork.Client;
			local clientPosition = client:GetPos();
			local mapscenePosition = Clockwork.Client.MenuVector;
			local zone = 0;

			self.lastActiveZone = nil;
			
			for k, v in pairs (self.stored) do
				local boundsTable = v.bounds;
				
				if (boundsTable) then
					local position = mapscenePosition or clientPosition;
					local bInZone;
					
					if table.IsSequential(boundsTable) then
						for i, subTable in ipairs(boundsTable) do
							if Schema:IsInBox(subTable.min, subTable.max, position) then
								bInZone = true;
								break;
							end
						end
					else
						bInZone = Schema:IsInBox(boundsTable.min, boundsTable.max, position);
					end

					if (bInZone) then
						if (self.lastActiveZone) then
							if (self.stored[self.lastActiveZone].priority > self.stored[k].priority) then
								self:SetActiveZone(self.stored[k]); break;
							end;
						else
							self:SetActiveZone(self.stored[k]);
							self.lastActiveZone = k;
							break;
						end;
					else
						zone = zone + 1;
						
						if (zone == self.totalZones) then
							self:SetActiveZone(self.cwDefaultZone);
						end;
					end;
				end;
			end;
		end;
	end;

	-- Called when the screen space effects are rendered.
	function zones:RenderScreenspaceEffects()
		if (!self:Enabled()) then
			return;
		end;
		
		local mapscenePosition = Clockwork.Client.MenuVector;
		local defaultZone = self.cwDefaultZone;
		local frameTime = FrameTime();
		local zoneTable = self.currentZoneTable or defaultZone;

		if (!self.currentFogColors) then self.currentFogColors = {r = 255, g = 255, b = 255}; end;
		if (!self.recheckTable) then self.recheckTable = {}; end;
		
		if (!self.currentFogStart or !self.currentFogEnd) and defaultZone then
			self.currentFogStart = defaultZone.fogStart;
			self.currentFogEnd = defaultZone.fogEnd;
		end;

		if (!self.currentColorModify) then
			self.currentColorModify = {
				["$pp_colour_brightness"] = 0,
				["$pp_colour_contrast"] = 1,
				["$pp_colour_colour"] = 1,
			};
		end;
		
		if (self:ColorModEnabled()) then
			if (self.currentColorModify) then
				if (Clockwork.Client.Wakeup) then
					local curTime = CurTime()
					local ratio = (1 - ((1 / (Clockwork.Client.WakeupDuration or 10)) * (Clockwork.Client.FUCKMYLIFETIME - curTime))) * 2
					local colorModify = zoneTable.colorModify;
					local brightness = 0 - math.Clamp(Lerp(ratio, 1, 0), 0, 1);
					local tab = table.Copy(self.currentColorModify);
					
					tab["$pp_colour_brightness"] = tab["$pp_colour_brightness"] + brightness;
					
					if cwMedicalSystem and Clockwork.Client:HasInitialized() and Clockwork.Client:Alive() and !Clockwork.kernel:IsChoosingCharacter() then
						local bloodLevel = Clockwork.Client:GetNWInt("bloodLevel", 5000) or cwMedicalSystem.maxBloodLevel;
						local lethalBloodLoss = cwMedicalSystem.lethalBloodLoss;
						
						if bloodLevel < cwMedicalSystem.maxBloodLevel then
							if zoneTable and zoneTable.colorModify then
								tab["$pp_colour_colour"] = zoneTable.colorModify["$pp_colour_colour"] * math.Clamp((bloodLevel - lethalBloodLoss) / lethalBloodLoss, 0, 1);
							else
								tab["$pp_colour_colour"] = math.Clamp((bloodLevel - lethalBloodLoss) / lethalBloodLoss, 0, 1);
							end
						end
					end
					
					DrawColorModify(tab);
				else
					local tab = table.Copy(self.currentColorModify);
					
					if cwMedicalSystem and Clockwork.Client:HasInitialized() and Clockwork.Client:Alive() and !Clockwork.kernel:IsChoosingCharacter() then
						local bloodLevel = Clockwork.Client:GetNWInt("bloodLevel", 5000) or cwMedicalSystem.maxBloodLevel;
						local lethalBloodLoss = cwMedicalSystem.lethalBloodLoss;
						
						if bloodLevel < cwMedicalSystem.maxBloodLevel then
							if zoneTable and zoneTable.colorModify then
								tab["$pp_colour_colour"] = zoneTable.colorModify["$pp_colour_colour"] * math.Clamp((bloodLevel - lethalBloodLoss) / lethalBloodLoss, 0, 1);
							else
								tab["$pp_colour_colour"] = math.Clamp((bloodLevel - lethalBloodLoss) / lethalBloodLoss, 0, 1);
							end
						end
					end
				
					DrawColorModify(tab);
				end;
			end;
		end;
		
		if (!self.currentZoneTable or self.currentZoneTable.uniqueID != self:GetZone()) then
			if (self:IsDefault(self.cwCurrentZone)) then
				self.currentZoneTable = defaultZone;
			else
				self.currentZoneTable = self.stored[self.cwCurrentZone];
			end;
			
			return;
		end;
		
		local mapscene
		
		if (self.currentZoneTable) then
			local uniqueID = self.currentZoneTable.uniqueID;
			local recheckTable = self.recheckTable;
			local fogColorsUpdated = tobool(recheckTable.r and recheckTable.g and recheckTable.b);
			local zoneTable = self.currentZoneTable;
			
			if (self:BloomEnabled()) then
				if (zoneTable.RenderCallback) then
					zoneTable:RenderCallback();
				end;
			end;
			
			if (self:FogEnabled()) then
				if (zoneTable.fogColors and self.currentFogColors) then
					if (!fogColorsUpdated) then
						local zoneFogColors;
						local targetFogColorOverride = hook.Run("OverrideZoneFogColors", zoneTable);
						local interval = zoneTable.colorInterval or 64;
						local bNoFade = false;
						
						if targetFogColorOverride then zoneFogColors = targetFogColorOverride else zoneFogColors = zoneTable.fogColors end;
						
						if !targetFogColorOverride and zoneTable.hasNight and cwDayNight and cwDayNight.nightWeight then 
							if !Clockwork.Client.dueling and !Clockwork.kernel:IsChoosingCharacter() then
								if zoneTable.fogColorsNight then
									local fogColorsNight = zoneTable.fogColorsNight;
									
									zoneFogColors = {r = Lerp(cwDayNight.nightWeight, zoneFogColors.r, fogColorsNight.r), g = Lerp(cwDayNight.nightWeight, zoneFogColors.g, fogColorsNight.g), b = Lerp(cwDayNight.nightWeight, zoneFogColors.b, fogColorsNight.b)};
								end
							end
						end
						
						if (!self.targetFogColors) then self.targetFogColors = {r = 255, g = 255, b = 255}; end;
						if (interval == 0) then bNoFade = true end;
						
						local prevZone = zones:FindByID(self.cwPreviousZone);
						
						if prevZone and prevZone.supraZone ~= zoneTable.supraZone then
							bNoFade = true;
						end

						if (!bNoFade) then
							local frameTime = frameTime * interval;

							if (mapscenePosition != nil) then
								frameTime = 99999;
							end;
							
							for k, v in pairs (self.targetFogColors) do
								if (self.targetFogColors[k] != zoneFogColors[k]) then self.targetFogColors[k] = zoneFogColors[k] end;
								
								if (self.currentFogColors[k] and self.targetFogColors[k] and frameTime and self.currentFogColors[k] != self.targetFogColors[k]) then
									self.currentFogColors[k] = math.Approach(self.currentFogColors[k], self.targetFogColors[k], frameTime);
								else
									self.recheckTable[k] = true
								end;
							end;
						else
							for k, v in pairs (self.targetFogColors) do
								if (self.targetFogColors[k] != zoneFogColors[k]) then self.targetFogColors[k] = zoneFogColors[k] end;
								
								if (self.currentFogColors[k] != self.targetFogColors[k]) then
									self.currentFogColors[k] = self.targetFogColors[k];
								else
									self.recheckTable[k] = true;
								end;
							end;
						end;
					end;
				end;

				if (zoneTable.fogStart and zoneTable.fogEnd) then
					local recheckTable = self.recheckTable;
					local fogDistanceUpdated = tobool(recheckTable.fogStart and recheckTable.fogEnd);
					
					if (!fogDistanceUpdated) then
						if (self.currentFogStart and self.currentFogEnd) then
							local fogStart, fogEnd = zoneTable.fogStart, zoneTable.fogEnd;
							local overrideStart, overrideEnd = hook.Run("OverrideZoneFogDistance", zoneTable, fogStart, fogEnd);
							local interval = zoneTable.distanceInterval or 128;
							local frameTime = frameTime * interval;
							
							if overrideStart and overrideEnd then
								self.targetStart = overrideStart;
								self.targetEnd = overrideEnd;
							else
								if (!self.targetStart or !self.targetEnd) then
									if zoneTable.hasNight and !Clockwork.Client.dueling and !Clockwork.kernel:IsChoosingCharacter() then
										if (zoneTable.fogStartNight and zoneTable.fogEndNight) then
											self.targetStart = Lerp(cwDayNight.nightWeight, zoneTable.fogStart, zoneTable.fogStartNight);
											self.targetEnd = Lerp(cwDayNight.nightWeight, zoneTable.fogEnd, zoneTable.fogEndNight);
										else
											if (zoneTable.fogStart and zoneTable.fogEnd) then
												self.targetStart = zoneTable.fogStart;
												self.targetEnd = zoneTable.fogEnd;
											else
												self.targetStart = defaultZone.fogStart;
												self.targetEnd = defaultZone.fogEnd;
											end;
										end;
									else
										if (zoneTable.fogStart and zoneTable.fogEnd) then
											self.targetStart = zoneTable.fogStart;
											self.targetEnd = zoneTable.fogEnd;
										else
											self.targetStart = defaultZone.fogStart;
											self.targetEnd = defaultZone.fogEnd;
										end;
									end
								elseif (zoneTable.fogStart != self.targetStart or zoneTable.fogEnd != self.targetEnd) then
									if zoneTable.hasNight and !Clockwork.Client.dueling and !Clockwork.kernel:IsChoosingCharacter() then
										if (zoneTable.fogStartNight and zoneTable.fogEndNight) then
											self.targetStart = Lerp(cwDayNight.nightWeight, zoneTable.fogStart, zoneTable.fogStartNight);
											self.targetEnd = Lerp(cwDayNight.nightWeight, zoneTable.fogEnd, zoneTable.fogEndNight);
										else
											self.targetStart = zoneTable.fogStart;
											self.targetEnd = zoneTable.fogEnd;
										end
									else
										self.targetStart = zoneTable.fogStart;
										self.targetEnd = zoneTable.fogEnd;
									end
								end;
							end
							
							if (mapscenePosition != nil) then
								frameTime = 999999;
							end;
							
							if (self.currentFogStart and self.targetStart and frameTime and self.currentFogStart != self.targetStart) then
								self.currentFogStart = math.Approach(self.currentFogStart, self.targetStart, frameTime);
							else
								self.recheckTable.fogStart = true;
							end;
							
							if (self.targetEndOverride and self.targetEndOverride[uniqueID] and isnumber(self.targetEndOverride[uniqueID])) then
								self.targetEnd = self.targetEndOverride[uniqueID];
							elseif (!self.targetEndOverride or table.IsEmpty(self.targetEndOverride)) then
								self.targetEndOverride = {};
								
								for k, v in pairs (self.stored) do
									self.targetEndOverride[k] = false;
								end;
							end;
							
							if (self.currentFogStart and self.targetStart and frameTime and self.currentFogEnd != self.targetEnd) then
								self.currentFogEnd = math.Approach(self.currentFogEnd, self.targetEnd, frameTime);
							else
								self.recheckTable.fogEnd = true;
							end;
						end;
					end;
				end;
			end;
			
			if (self:ColorModEnabled()) then
				if (zoneTable.colorModify) then
					local recheckTable = self.recheckTable;
					local colorModifyUpdated = tobool(recheckTable["$pp_colour_brightness"] and recheckTable["$pp_colour_contrast"] and recheckTable["$pp_colour_colour"]);

					if (!colorModifyUpdated) then
						if (!self.targetColorModify) then
							self.targetColorModify = {
								["$pp_colour_brightness"] = 0,
								["$pp_colour_contrast"] = 1,
								["$pp_colour_colour"] = 1,
							};
						else
							local zoneModify = zoneTable.colorModify;
							
							if zoneTable.hasNight and zoneTable.colorModifyNight and cwDayNight and cwDayNight.nightWeight and !Clockwork.Client.dueling and !Clockwork.kernel:IsChoosingCharacter() then
								local zoneModifyNight = zoneTable.colorModifyNight;
								local newBrightness = Lerp(cwDayNight.nightWeight, zoneModify["$pp_colour_brightness"], zoneModifyNight["$pp_colour_brightness"]);
								local newContrast = Lerp(cwDayNight.nightWeight, zoneModify["$pp_colour_contrast"], zoneModifyNight["$pp_colour_contrast"]);
								local newColour = Lerp(cwDayNight.nightWeight, zoneModify["$pp_colour_colour"], zoneModifyNight["$pp_colour_colour"]);
								
								zoneModify = {["$pp_colour_brightness"] = newBrightness, ["$pp_colour_contrast"] = newContrast, ["$pp_colour_colour"] = newColour};
							end
							
							for k, v in pairs (self.targetColorModify) do
								if (self.targetColorModify[k] != zoneModify[k]) then
									self.targetColorModify[k] = zoneModify[k];
								end;
							end;
						end;

						local frameTime = FrameTime();
						
						if (!zoneTable.intervalMult) then
							frameTime = frameTime / ((zoneTable.colorInterval and zoneTable.colorInterval / 4) or 8);
						else
							frameTime = frameTime * (zoneTable.colorInterval or 64)
						end;
						
						if (mapscenePosition != nil) then
							frameTime = 99999;
						end;

						for k, v in pairs (self.currentColorModify) do
							if (self.currentColorModify[k] and self.targetColorModify[k] and frameTime and self.currentColorModify[k] != self.targetColorModify[k]) then
								self.currentColorModify[k] = math.Approach(self.currentColorModify[k], self.targetColorModify[k], frameTime)
							elseif (self.currentColorModify["$pp_colour_brightness"] != 0 and self.currentColorModify["$pp_colour_contrast"] != 1 and self.currentColorModify["$pp_colour_colour"] != 1) then
								self.recheckTable[k] = true;
							end;
						end;
					end;
				end;
			end;
		end;
	end;

	function zones:CharacterPanelClosed()
		if (!self:Enabled()) then
			return;
		end;
		
		local client = Clockwork.Client;
		local clientPosition = client:GetPos();
		local zone = 0;

		self.lastActiveZone = nil;
		
		for k, v in pairs (self.stored) do
			local boundsTable = v.bounds;
			
			if (boundsTable) then
				local position = clientPosition;
				local bInZone;
				
				if table.IsSequential(boundsTable) then
					for i, subTable in ipairs(boundsTable) do
						if Schema:IsInBox(subTable.min, subTable.max, position) then
							bInZone = true;
							break;
						end
					end
				else
					bInZone = Schema:IsInBox(boundsTable.min, boundsTable.max, position);
				end
				
				if (bInZone) then
					if (self.lastActiveZone) then
						if (self.stored[self.lastActiveZone].priority > self.stored[k].priority) then
							self:SetActiveZone(self.stored[k]); break;
						end;
					else
						self:SetActiveZone(self.stored[k]);
						self.lastActiveZone = k;
						break;
					end;
				else
					zone = zone + 1;
					
					if (zone == self.totalZones) then
						self:SetActiveZone(self.cwDefaultZone);
					end;
				end;
			end;
		end;

		timer.Simple(FrameTime(), function()
			self:RefreshCurrentZone();
			self:RefreshZoneVFX();
		end);
	end

	netstream.Hook("OverrideFogDistance", function(data)
		if (!zones.targetEndOverride or table.IsEmpty(zones.targetEndOverride)) then
			zones.targetEndOverride = {};

			for k, v in pairs (zones.stored) do
				zones.targetEndOverride[k] = false;
			end;
		end;

		if (zones and data and data.zone and (data.fogEnd or data.fogEnd == false)) then
			zones.targetEndOverride[data.zone] = data.fogEnd;
		end;
		
		zones:RefreshCurrentZone();
	end);

	-- Called after all translucent entities are drawn.
	function zones:PostDrawTranslucentRenderables(bDrawDepth, bDrawSkybox)
		if (bDrawSkybox or bDrawDepth or !self:Enabled()) then
			return;
		end

		if self:DebugEnabled() then
			local boxColor = Color(0, 0, 150, 20);
			local textColor = Color(20, 20, 255)
			local redColor = Color(150, 0, 0, 20);
			local redText = Color(255, 0, 0);

			for k, v in pairs (self.stored) do
				local boxColor = boxColor;
				local textColor = textColor; 

				if (v.bounds) then
					if table.IsSequential(v.bounds) then
						for i, v2 in ipairs(v.bounds) do
							local position = v2.min:ToScreen()
							
							render.SetColorMaterial()
								local max = v2.max - v2.min
							render.DrawBox(v2.min, Angle(0, 0, 0), Vector(0, 0, 0), max, boxColor)

							cam.Start2D()
								draw.WordBox(4, position.x, position.y, k, "Default", Color(0, 0, 0), textColor)
							cam.End2D()
						end
					else
						local position = v.bounds.min:ToScreen()
						
						render.SetColorMaterial()
							local max = v.bounds.max - v.bounds.min
						render.DrawBox(v.bounds.min, Angle(0, 0, 0), Vector(0, 0, 0), max, boxColor)

						cam.Start2D()
							draw.WordBox(4, position.x, position.y, k, "Default", Color(0, 0, 0), textColor)
						cam.End2D()
					end
				elseif (v.origin and v.radius) then
					local origin = v.origin:ToScreen()
					
					render.SetColorMaterial()
					render.DrawSphere(v.origin, v.radius, 30, 30, boxColor)

					cam.Start2D()
						draw.WordBox(4, origin.x, origin.y, k.." - Radius: "..v.radius, "Default", Color(0, 0, 0), textColor)
					cam.End2D()
				end;
			end
		end
	end

	function zones:ModifyTargetIDDistance(fadeDistance)
		local fogEnd = self.currentFogEnd;
		
		if fogEnd then
			if fadeDistance > fogEnd then
				return fogEnd;
			end
		end
	end

	-- Called just after the date & time is drawn.
	function zones:PostDrawDateTime(info)
		if (!self:Enabled() or !self:DebugEnabled()) then
			return false;
		end;
		
		if (!self.allZones) then
			self.allZones = {};
				for k, v in SortedPairsByMemberValue(self.stored, "name") do
					self.allZones[#self.allZones + 1] = v.name;
				end;
			self.allZones[#self.allZones + 1] = "Wasteland";
		end;
		
		info.y = info.y + 8

		Clockwork.kernel:OverrideMainFont("DebugFixedSmall")
			if (self:GetZone()) then
				info.y = Clockwork.kernel:DrawInfo("TOTAL ZONES: "..table.concat(self.allZones, ", "), info.x, info.y, Color(255, 255, 200), nil, true)
				info.y = Clockwork.kernel:DrawInfo("CURRENT ZONE: "..self:GetZone(), info.x, info.y, Color(255, 255, 200), nil, true)
			end
		Clockwork.kernel:OverrideMainFont(nil)
	end;

	-- Called when the world fog should be set up.
	function zones:SetupWorldFog()
		if ((!Clockwork.kernel:IsChoosingCharacter() and !Clockwork.Client:GetNetVar("senses")) or Clockwork.Client.MenuVector) then
			if (self:Enabled() and self:FogEnabled() and self.currentFogColors) then
				local r, g, b = self.currentFogColors.r, self.currentFogColors.g, self.currentFogColors.b;
				local fogStart = self.currentFogStart;
				local fogEnd = self.currentFogEnd;
				local zoneTable = self.currentZoneTable;
			
				if (r and g and b and fogStart and fogEnd) then
					render.FogMode(1)
					render.FogStart(fogStart)
					render.FogEnd(fogEnd)
					render.FogColor(r, g, b, 255)
					render.FogMaxDensity(1)
					
					return true
				end;
			end;
		else
			if Clockwork.Client:GetNetVar("senses") then
				render.FogMode(1)
				render.FogStart(0)
				render.FogEnd(600)
				render.FogColor(0, 0, 0, 255)
				render.FogMaxDensity(1)
			else
				render.FogMode(1)
				render.FogStart(512)
				render.FogEnd(2048)
				render.FogColor(0, 0, 0, 255)
				render.FogMaxDensity(1)
			end

			return true
		end;

		return false
	end

	-- Called when the skybox fog should be set up.
	function zones:SetupSkyboxFog(scale)
		if (self:Enabled() and self:FogEnabled() and self.currentFogColors) then
			local r, g, b = self.currentFogColors.r, self.currentFogColors.g, self.currentFogColors.b;
			local fogStart = self.currentFogStart;
			local fogEnd = self.currentFogEnd;

			if (r and g and b) then
				render.FogMode(1)
				render.FogStart(fogStart * scale)
				render.FogEnd(fogEnd * scale)
				render.FogColor(r, g, b, 255)
				render.FogMaxDensity(1)
				
				return true
			end;
		end;

		return false
	end
	
	local maxs = Vector(512, 512, 512)
	local mins = -maxs
	
	function zones:PostDraw2DSkyBox()
		if self.currentFogColors then
			render.OverrideDepthEnable(true, false)
		
			cam.Start3D(Vector(0, 0, 0), Angle(0, 0, 0))
				render.SetColorMaterial()
				-- Swapped mins and maxs so that the box will render inside out
				render.DrawBox(Vector(0, 0, 0), Angle(0, 0, 0), maxs, mins, self.currentFogColors)
			cam.End3D()
			
			render.OverrideDepthEnable(false, false)
		end
	end
else
	if map == "rp_begotten3" then
		function zones:ClockworkInitPostEntity()
			for i, v in ipairs(ents.FindByClass("env_fog_controller")) do
				v:SetKeyValue("farz", 3500);
			end
		end
	end

	function zones:GetPlayerSupraZone(player)
		local zone = player:GetCharacterData("LastZone", "wasteland");
		
		for k, v in pairs(self.supraZones) do
			if table.HasValue(v, zone) then
				return k;
			end
		end
		
		return zone;
	end
	
	function zones:IsPlayerInSupraZone(player, supraZone)
		local zone = player:GetCharacterData("LastZone", "wasteland");
		
		if table.HasValue(self.supraZones[supraZone], zone) then
			return true;
		end
		
		return false;
	end
	
	function zones:IsSupraZone(supraZone)
		if self.supraZones[supraZone] then
			return true;
		end
		
		return false;
	end
	
	function zones:GetSupraZoneFromZone(zone)
		for k, v in pairs(self.supraZones) do
			if table.HasValue(v, zone) then
				return k;
			end
		end
		
		return zone;
	end

	function zones:GetPlayersInZone(zone)
		local playersInZone = {};
	
		if istable(zone) then
			for _, v in _player.Iterator() do
				local vZone = v:GetCharacterData("LastZone", "wasteland");
				
				if table.HasValue(zone, vZone) then
					table.insert(playersInZone, v);
				end
			end
		else
			for _, v in _player.Iterator() do
				if v:GetCharacterData("LastZone", "wasteland") == zone then
					table.insert(playersInZone, v);
				end
			end
		end
		
		return playersInZone;
	end
	
	function zones:GetPlayersInSupraZone(supraZone)
		local playersInSupraZone = {};
	
		if istable(supraZone) then
			for _, v in _player.Iterator() do
				local vZone = v:GetCharacterData("LastZone", "wasteland");
				
				if !supraZone or !self.supraZones[supraZone] then
					if vZone == supraZone then
						table.insert(playersInSupraZone, v);
				
						continue;
					end
				end
				
				for i2, v2 in ipairs(self.supraZones[supraZone]) do
					if table.HasValue(v2, vZone) then
						table.insert(playersInSupraZone, v);
						
						break;
					end
				end
			end
		else
			for _, v in _player.Iterator() do
				local vZone = v:GetCharacterData("LastZone", "wasteland");
				
				if !supraZone or !self.supraZones[supraZone] then
					if vZone == supraZone then
						table.insert(playersInSupraZone, v);
					end
				elseif table.HasValue(self.supraZones[supraZone], vZone) then
					table.insert(playersInSupraZone, v);
				end
			end
		end
		
		return playersInSupraZone;
	end
end

if map == "rp_begotten3" then
	local WASTELAND = zones:New("wasteland", "suprawasteland")
		WASTELAND.default = true;
		WASTELAND.hasNight = true;
		WASTELAND.name = "Wasteland";
		WASTELAND.map = "rp_begotten3";
		WASTELAND.fogColors = {r = 96, g = 47, b = 0};
		WASTELAND.fogColorsNight = {r = 32, g = 12, b = 4};
		WASTELAND.fogStart = 256;
		WASTELAND.fogStartNight = 256;
		WASTELAND.fogEnd = 1536;
		WASTELAND.fogEndNight = 1024;
		WASTELAND.colorModify = {["$pp_colour_brightness"] = -0.03, ["$pp_colour_contrast"] = 1.15, ["$pp_colour_colour"] = 0.85};
		WASTELAND.colorModifyNight = {["$pp_colour_brightness"] = -0.1, ["$pp_colour_contrast"] = 0.9, ["$pp_colour_colour"] = 0.75};
		WASTELAND.hasWeather = true;
		
		-- Called every frame.
		function WASTELAND:RenderCallback()
			DrawBloom(0.1, 1.4, 5, 5, 0.1, 0.5, 1, 0.8, 0.8);
		end;
	WASTELAND:Register()

	local DUEL = zones:New("duel")
		DUEL.name = "Duel Zone";
		DUEL.map = "rp_begotten3";
		DUEL.colorModify = {["$pp_colour_brightness"] = -0.025, ["$pp_colour_contrast"] = 1.1, ["$pp_colour_colour"] = 1.1};
		DUEL.fogStart = 4096;
		DUEL.fogEnd = 4096;
		DUEL.distanceInterval = 1000
		DUEL.bounds = {
			min = Vector(7679, -13741, -6952),
			max = Vector(12784, -11125, -5490),
		};
		
		-- Why did this get added? - DETrooper
		--[[function DUEL:OnEnter()
			Schema:WhiteFlash(1)
		end;
		
		function DUEL:OnExit()
			Schema:WhiteFlash(1)
		end;]]--
	DUEL:Register()

	local DREAMS = zones:New("dreams")
		DREAMS.name = "Dreams Zone";
		DREAMS.map = "rp_begotten3";
		DREAMS.colorModify = {["$pp_colour_brightness"] = -0.05, ["$pp_colour_contrast"] = 1.1, ["$pp_colour_colour"] = 0.8};
		DREAMS.fogStart = 4096;
		DREAMS.fogEnd = 4096;
		DREAMS.distanceInterval = 1000
		DREAMS.bounds = {
			min = Vector(419, 4789, -10305),
			max = Vector(-323, 6097, -11257),
		};
	DREAMS:Register()

	local SCRAPPER = zones:New("scrapper")
		SCRAPPER.name = "Scrapper";
		SCRAPPER.map = "rp_begotten3";
		SCRAPPER.fogColors = {r = 0, g = 0, b = 0};
		SCRAPPER.fogStart = 0;
		SCRAPPER.fogEnd = 2048;
		SCRAPPER.colorModify = {["$pp_colour_brightness"] = -0.05, ["$pp_colour_contrast"] = 1.5, ["$pp_colour_colour"] = 1.5, ["$pp_colour_mulr"] = 1.5};
		SCRAPPER.bounds = {
			min = Vector(454, -12393, -2189),
			max = Vector(-4214, -11057, -703),
		};
	SCRAPPER:Register()

	local TOWER = zones:New("tower", "suprawasteland")
		TOWER.hasNight = true;
		TOWER.name = "Tower of Light";
		TOWER.map = "rp_begotten3";
		TOWER.fogColors = {r = 96, g = 47, b = 0};
		TOWER.fogColorsNight = {r = 18, g = 6, b = 1};
		TOWER.fogStart = 1536;
		TOWER.fogEnd = 3200;
		TOWER.colorModify = {["$pp_colour_brightness"] = -0.035, ["$pp_colour_contrast"] = 1.22, ["$pp_colour_colour"] = 1};
		TOWER.colorModifyNight = {["$pp_colour_brightness"] = -0.045, ["$pp_colour_contrast"] = 1.05, ["$pp_colour_colour"] = 0.95};
		TOWER.hasWeather = true;
		TOWER.bounds = {
			{
				min = Vector(2400, 15147, -2778),
				max = Vector(-2532, 12022, 2048),
			},
			{
				min = Vector(-831, 12023, -883),
				max = Vector(6, 11736, -1073),
			},
		};
	TOWER:Register()

	local THEATER = zones:New("theater")
		THEATER.hasNight = true;
		THEATER.name = "Tower Theater";
		THEATER.map = "rp_begotten3";
		THEATER.fogColors = {r = 96, g = 47, b = 0};
		THEATER.fogColorsNight = {r = 18, g = 6, b = 1};
		THEATER.fogStart = 1536;
		THEATER.fogEnd = 3200;
		THEATER.bloomDisabled = true;
		THEATER.colorModify = {["$pp_colour_brightness"] = -0.035, ["$pp_colour_contrast"] = 1.05, ["$pp_colour_colour"] = 1};
		THEATER.colorModifyNight = {["$pp_colour_brightness"] = -0.035, ["$pp_colour_contrast"] = 1.05, ["$pp_colour_colour"] = 1};
		THEATER.bounds = {
			min = Vector(1448, 14585, 554),
			max = Vector(648, 13774, 298),
		};
		THEATER.priority = 2;
	THEATER:Register()

	local CAVES = zones:New("caves")
		CAVES.name = "Caves";
		CAVES.map = "rp_begotten3";
		CAVES.fogColors = {r = 0, g = 0, b = 0};
		CAVES.fogStart = 0;
		CAVES.fogEnd = 768;
		CAVES.colorModify = {["$pp_colour_brightness"] = -0.03, ["$pp_colour_contrast"] = 1.15, ["$pp_colour_colour"] = 0.85};
		CAVES.bounds = {
			min = Vector(6975, 9000, -3000),
			max = Vector(-6920, -7353, -2173),
		};
	CAVES:Register()

	local HELL = zones:New("hell", "suprahell")
		HELL.name = "Hell";
		HELL.map = "rp_begotten3";
		HELL.fogColors = {r = 80, g = 10, b = 10};
		HELL.fogStart = 0;
		HELL.fogEnd = 1024;
		HELL.colorModify = {["$pp_colour_brightness"] = -0.2, ["$pp_colour_contrast"] = 1, ["$pp_colour_colour"] = 1}
		HELL.bounds = {
			min = Vector(-16069, -15314, -16119),
			max = Vector(5637, -3537, -4757),
		};
		
		-- Called every frame.
		function HELL:RenderCallback()
			DrawBloom(0.05, 0.8, 1, 1, 0.1, 0.5, 5, 1, 1);
		end;
	HELL:Register()

	local MANOR = zones:New("manor", "suprahell")
		MANOR.name = "Manor";
		MANOR.map = "rp_begotten3";
		MANOR.fogColors = {r = 80, g = 10, b = 10};
		MANOR.fogStart = 1024;
		MANOR.fogEnd = 3072;
		MANOR.colorModify = {["$pp_colour_brightness"] = -0.05, ["$pp_colour_contrast"] = 1, ["$pp_colour_colour"] = 1}
		MANOR.bounds = {
			min = Vector(-1079, -8472, -6505),
			max = Vector(261, -9704, -6163),
		};

		-- Called every frame.
		function MANOR:RenderCallback()
			DrawBloom(0.05, 0.2, 1, 1, 0.1, 0.5, 3.5, 1, 1);
		end;
	MANOR:Register()

	local TOOTHBOY = zones:New("toothboy")
		TOOTHBOY.name = "Toothboy";
		TOOTHBOY.map = "rp_begotten3";
		TOOTHBOY.fogColors = {r = 0, g = 0, b = 0};
		TOOTHBOY.fogStart = 0;
		TOOTHBOY.fogEnd = 3200;
		TOOTHBOY.colorModify = {["$pp_colour_brightness"] = -0.05, ["$pp_colour_contrast"] = 1, ["$pp_colour_colour"] = 1}
		TOOTHBOY.bounds = {
			min = Vector(12250, -9968, -2182),
			max = Vector(12992, -14144, -1262),
		};
	TOOTHBOY:Register()

	local GORE_TREE = zones:New("gore_tree", "supragore")
		GORE_TREE.name = "Gore Tree";
		GORE_TREE.map = "rp_begotten3";
		GORE_TREE.fogColors = {r = 255, g = 255, b = 255};
		GORE_TREE.fogStart = 3200;
		GORE_TREE.fogEnd = 6000;
		GORE_TREE.colorModify = {["$pp_colour_brightness"] = 0, ["$pp_colour_contrast"] = 1.2, ["$pp_colour_colour"] = 0};
		GORE_TREE.bounds = {
			min = Vector(11713, -6746, 10673),
			max = Vector(5600, -11005, 15544),
		};
		GORE_TREE.colorInterval = 1024
		GORE_TREE.distanceInterval = 2048
		GORE_TREE.intervalMult = true;
		function GORE_TREE:RenderCallback() end;
	GORE_TREE:Register()

	local GORE_HALLWAY = zones:New("gore_hallway", "supragore")
		GORE_HALLWAY.name = "Gore Hallway";
		GORE_HALLWAY.map = "rp_begotten3";
		GORE_HALLWAY.fogColors = {r = 0, g = 0, b = 0};
		GORE_HALLWAY.fogStart = 1024;
		GORE_HALLWAY.fogEnd = 2048;
		GORE_HALLWAY.colorModify = {["$pp_colour_brightness"] = -0.1, ["$pp_colour_contrast"] = 2, ["$pp_colour_colour"] = 1};
		GORE_HALLWAY.bounds = {
			min = Vector(5600, -6800, 11685),
			max = Vector(2199, -8997, 12118),
		};
		GORE_HALLWAY.colorInterval = 64
		GORE_HALLWAY.distanceInterval = 2048
		GORE_HALLWAY.intervalMult = true;
		
		-- Called when the client enters the zone.
		function GORE_HALLWAY:OnEnter()
			if (cwViewBlockers) then
				for k, v in pairs (cwViewBlockers) do
					v:Remove();
				end;
			end;
			
			cwViewBlockers = {};
			cwViewBlockers["tree"] = ClientsideModel("models/hunter/plates/plate16x16.mdl", RENDERGROUP_BOTH);
			cwViewBlockers["tree"]:SetPos(Vector(6149, -8655, 11960));
			cwViewBlockers["forest"] = ClientsideModel("models/hunter/plates/plate16x16.mdl", RENDERGROUP_BOTH);
			cwViewBlockers["forest"]:SetPos(Vector(1604, -8745, 11959));

			for k, v in pairs (cwViewBlockers) do
				if (IsValid(v)) then
					v:SetAngles(Angle(90, 0, 180));
					v:SetRenderMode(RENDERMODE_TRANSALPHA);
					v:SetColor(Color(0, 0, 0, 255));
				end;
			end;

			timer.Create("ViewBlockerRemove", 5, 1, function()
				if (cwViewBlockers and !table.IsEmpty(cwViewBlockers)) then
					for k, v in pairs (cwViewBlockers) do
						v:Remove();
					end;
				end;
			end);
		end;
		
		-- Called when the client exits the zone.
		function GORE_HALLWAY:OnExit()
			if (cwViewBlockers and !table.IsEmpty(cwViewBlockers)) then
				for k, v in pairs (cwViewBlockers) do
					if (IsValid(v)) then
						v:Remove();
					end;
				end;
			end;
		end;
	GORE_HALLWAY:Register()

	local GORE = zones:New("gore", "supragore")
		GORE.name = "Gore Forest";
		GORE.map = "rp_begotten3";
		GORE.fogColors = {r = 100, g = 100, b = 100};
		GORE.fogStart = 0;
		GORE.fogEnd = 1024
		GORE.colorModify = {["$pp_colour_brightness"] = -0.05, ["$pp_colour_contrast"] = 1, ["$pp_colour_colour"] = 0.2};
		GORE.bounds = {
			min = Vector(2199, 4478, 10673),
			max = Vector(-15045, -15158, 15544),
		};
		GORE.colorInterval = 64
		GORE.distanceInterval = 2048
		GORE.intervalMult = true;
		
		-- Called every frame.
		function GORE:RenderCallback()
			DrawBloom(0.1, 1.4, 5, 5, 0.1, 0.5, 0.8, 0.8, 1);
		end;
	GORE:Register()

	local SEA1 = zones:New("sea_rough")
		SEA1.weatherOverride = "rain";
		SEA1.name = "Sea (Rough)";
		SEA1.map = "rp_begotten3";
		SEA1.fogColors = {r = 0, g = 30, b = 90};
		SEA1.fogStart = 0;
		SEA1.fogEnd = 1024;
		SEA1.colorModify = {["$pp_colour_brightness"] = -0.05, ["$pp_colour_contrast"] = 1, ["$pp_colour_colour"] = 0.15};
		SEA1.bounds = {
			min = Vector(15392, 14700, -5400),
			max = Vector(5158, 4500, -6500),
		};

		-- Called every frame.
		function SEA1:RenderCallback()
			DrawBloom(0.1, 1.4, 5, 5, 0.1, 0.5, 1, 0.8, 0.8);
		end;
	SEA1:Register()

	local SEA2 = zones:New("sea_calm")
		SEA2.name = "Sea (Calm)";
		SEA2.map = "rp_begotten3";
		SEA2.fogColors = {r = 66, g = 66, b = 66};
		SEA2.fogStart = 0;
		SEA2.fogEnd = 1024;
		SEA2.colorModify = {["$pp_colour_brightness"] = -0.05, ["$pp_colour_contrast"] = 1, ["$pp_colour_colour"] = 0.15};
		SEA2.bounds = {
			min = Vector(5110, 14700, -5400),
			max = Vector(-5095, 4500, -6500),
		};
		
		-- Called every frame.
		function SEA2:RenderCallback()
			DrawBloom(0.1, 1.4, 5, 5, 0.1, 0.5, 0.8, 0.8, 1);
		end;
	SEA2:Register()

	local SEA3 = zones:New("sea_styx")
		SEA3.weatherOverride = "ash";
		SEA3.name = "River Styx";
		SEA3.map = "rp_begotten3";
		SEA3.fogColors = {r = 80, g = 10, b = 10};
		SEA3.fogStart = 0;
		SEA3.fogEnd = 1024;
		SEA3.colorModify = {["$pp_colour_brightness"] = -0.2, ["$pp_colour_contrast"] = 1, ["$pp_colour_colour"] = 1}
		SEA3.bounds = {
			min = Vector(-5110, 14700, -5400),
			max = Vector(-15349, 4500, -6500),
		};
		
		-- Called every frame.
		function SEA3:RenderCallback()
			DrawBloom(0.05, 0.8, 1, 1, 0.1, 0.5, 5, 1, 1);
		end;
	SEA3:Register()
elseif map == "rp_begotten_redux" then
	local WASTELAND = zones:New("wasteland", "suprawasteland")
		WASTELAND.default = true;
		WASTELAND.hasNight = true;
		WASTELAND.name = "Wasteland";
		WASTELAND.map = "rp_begotten_redux";
		WASTELAND.fogColors = {r = 96, g = 47, b = 0};
		WASTELAND.fogColorsNight = {r = 32, g = 12, b = 4};
		WASTELAND.fogStart = 256;
		WASTELAND.fogStartNight = 256;
		WASTELAND.fogEnd = 1536;
		WASTELAND.fogEndNight = 1024;
		WASTELAND.colorModify = {["$pp_colour_brightness"] = -0.03, ["$pp_colour_contrast"] = 1.15, ["$pp_colour_colour"] = 0.85};
		WASTELAND.colorModifyNight = {["$pp_colour_brightness"] = -0.1, ["$pp_colour_contrast"] = 0.9, ["$pp_colour_colour"] = 0.75};
		
		-- Called every frame.
		function WASTELAND:RenderCallback()
			DrawBloom(0.1, 1.4, 5, 5, 0.1, 0.5, 1, 0.8, 0.8);
		end;
	WASTELAND:Register()
	
	local TOWER = zones:New("tower", "suprawasteland")
		TOWER.hasNight = true;
		TOWER.name = "Town of Light";
		TOWER.map = "rp_begotten_redux";
		TOWER.fogColors = {r = 96, g = 47, b = 0};
		TOWER.fogColorsNight = {r = 32, g = 12, b = 4};
		TOWER.fogStart = 256;
		TOWER.fogStartNight = 256;
		TOWER.fogEnd = 1536;
		TOWER.fogEndNight = 1024;
		TOWER.colorModify = {["$pp_colour_brightness"] = -0.03, ["$pp_colour_contrast"] = 1.15, ["$pp_colour_colour"] = 0.85};
		TOWER.colorModifyNight = {["$pp_colour_brightness"] = -0.1, ["$pp_colour_contrast"] = 0.9, ["$pp_colour_colour"] = 0.75};
		TOWER.bounds = {
			min = Vector(-12420, -7793, 646),
			max = Vector(-13674, -8453, 55),
		};
		
		-- Called every frame.
		function TOWER:RenderCallback()
			DrawBloom(0.1, 1.4, 5, 5, 0.1, 0.5, 1, 0.8, 0.8);
		end;
	TOWER:Register()
	
	local CAVES = zones:New("caves")
		CAVES.name = "Caves";
		CAVES.map = "rp_begotten_redux";
		CAVES.fogColors = {r = 0, g = 0, b = 0};
		CAVES.fogStart = 0;
		CAVES.fogEnd = 768;
		CAVES.colorModify = {["$pp_colour_brightness"] = -0.03, ["$pp_colour_contrast"] = 1.15, ["$pp_colour_colour"] = 0.85};
		CAVES.bounds = {
			min = Vector(-12818, -8894, -62),
			max = Vector(-10391, -10661, -255),
		};
	CAVES:Register()
	
	local CARTUNNELS = zones:New("car_tunnels")
		CARTUNNELS.name = "Car Tunnels";
		CARTUNNELS.map = "rp_begotten_redux";
		CARTUNNELS.fogColors = {r = 0, g = 0, b = 0};
		CARTUNNELS.fogStart = 0;
		CARTUNNELS.fogEnd = 768;
		CARTUNNELS.colorModify = {["$pp_colour_brightness"] = -0.03, ["$pp_colour_contrast"] = 1.15, ["$pp_colour_colour"] = 0.85};
		CARTUNNELS.bounds = {
			min = Vector(-12119, -5624, 20),
			max = Vector(-4815, -2656, -202),
		};
	CARTUNNELS:Register()
	
	local TUNNELS1 = zones:New("tunnels1")
		TUNNELS1.name = "Tunnels";
		TUNNELS1.map = "rp_begotten_redux";
		TUNNELS1.fogColors = {r = 0, g = 0, b = 0};
		TUNNELS1.fogStart = 0;
		TUNNELS1.fogEnd = 768;
		TUNNELS1.colorModify = {["$pp_colour_brightness"] = -0.03, ["$pp_colour_contrast"] = 1.15, ["$pp_colour_colour"] = 0.85};
		TUNNELS1.bounds = {
			min = Vector(-8500, -8449, -127),
			max = Vector(-10037, -9402, -346),
		};
	TUNNELS1:Register()
	
	local TUNNELS2 = zones:New("tunnels2")
		TUNNELS2.name = "Tunnels";
		TUNNELS2.map = "rp_begotten_redux";
		TUNNELS2.fogColors = {r = 0, g = 0, b = 0};
		TUNNELS2.fogStart = 0;
		TUNNELS2.fogEnd = 768;
		TUNNELS2.colorModify = {["$pp_colour_brightness"] = -0.03, ["$pp_colour_contrast"] = 1.15, ["$pp_colour_colour"] = 0.85};
		TUNNELS2.bounds = {
			min = Vector(-9167, -8637, -155),
			max = Vector(-13804, -8530, -16),
		};
	TUNNELS2:Register()
	
	local TUNNELS3 = zones:New("tunnels3")
		TUNNELS3.name = "Tunnels";
		TUNNELS3.map = "rp_begotten_redux";
		TUNNELS3.fogColors = {r = 0, g = 0, b = 0};
		TUNNELS3.fogStart = 0;
		TUNNELS3.fogEnd = 768;
		TUNNELS3.colorModify = {["$pp_colour_brightness"] = -0.03, ["$pp_colour_contrast"] = 1.15, ["$pp_colour_colour"] = 0.85};
		TUNNELS3.bounds = {
			min = Vector(-13804, -8530, -16),
			max = Vector(-13655, -5382, -142),
		};
	TUNNELS3:Register()

	local DUEL = zones:New("duel")
		DUEL.name = "Duel Zone";
		DUEL.map = "rp_begotten_redux";
		DUEL.colorModify = {["$pp_colour_brightness"] = -0.025, ["$pp_colour_contrast"] = 1.1, ["$pp_colour_colour"] = 1.1};
		DUEL.fogStart = 4096;
		DUEL.fogEnd = 4096;
		DUEL.distanceInterval = 1000
		DUEL.bounds = {
			min = Vector(7679, -13741, -6952),
			max = Vector(12784, -11125, -5490),
		};
		
		-- Why did this get added? - DETrooper
		--[[function DUEL:OnEnter()
			Schema:WhiteFlash(1)
		end;
		
		function DUEL:OnExit()
			Schema:WhiteFlash(1)
		end;]]--
	DUEL:Register()
	
	local HELL = zones:New("hell", "suprahell")
		HELL.name = "Hell";
		HELL.map = "rp_begotten_redux";
		HELL.fogColors = {r = 80, g = 10, b = 10};
		HELL.fogStart = 0;
		HELL.fogEnd = 1024;
		HELL.colorModify = {["$pp_colour_brightness"] = -0.2, ["$pp_colour_contrast"] = 1, ["$pp_colour_colour"] = 1}
		HELL.bounds = {
			min = Vector(-16069, -15314, -16119),
			max = Vector(5637, -3537, -4757),
		};
		
		-- Called every frame.
		function HELL:RenderCallback()
			DrawBloom(0.05, 0.8, 1, 1, 0.1, 0.5, 5, 1, 1);
		end;
	HELL:Register()

	local MANOR = zones:New("manor", "suprahell")
		MANOR.name = "Manor";
		MANOR.map = "rp_begotten_redux";
		MANOR.fogColors = {r = 80, g = 10, b = 10};
		MANOR.fogStart = 1024;
		MANOR.fogEnd = 3072;
		MANOR.colorModify = {["$pp_colour_brightness"] = -0.05, ["$pp_colour_contrast"] = 1, ["$pp_colour_colour"] = 1}
		MANOR.bounds = {
			min = Vector(-1079, -8472, -6505),
			max = Vector(261, -9704, -6163),
		};
		MANOR.priority = 2;

		-- Called every frame.
		function MANOR:RenderCallback()
			DrawBloom(0.05, 0.2, 1, 1, 0.1, 0.5, 3.5, 1, 1);
		end;
	MANOR:Register()
elseif map == "rp_scraptown" then
	local WASTELAND = zones:New("wasteland", "suprawasteland")
		WASTELAND.default = true;
		WASTELAND.hasNight = true;
		WASTELAND.name = "Wasteland";
		WASTELAND.map = "rp_scraptown";
		WASTELAND.fogColors = {r = 96, g = 47, b = 0};
		WASTELAND.fogColorsNight = {r = 32, g = 12, b = 4};
		WASTELAND.fogStart = 256;
		WASTELAND.fogStartNight = 256;
		WASTELAND.fogEnd = 1536;
		WASTELAND.fogEndNight = 1024;
		WASTELAND.colorModify = {["$pp_colour_brightness"] = -0.03, ["$pp_colour_contrast"] = 1.15, ["$pp_colour_colour"] = 0.85};
		WASTELAND.colorModifyNight = {["$pp_colour_brightness"] = -0.1, ["$pp_colour_contrast"] = 0.9, ["$pp_colour_colour"] = 0.75};
		
		-- Called every frame.
		function WASTELAND:RenderCallback()
			DrawBloom(0.1, 1.4, 5, 5, 0.1, 0.5, 1, 0.8, 0.8);
		end;
	WASTELAND:Register()
	
	local TOWER = zones:New("tower", "suprawasteland")
		TOWER.hasNight = true;
		TOWER.name = "Scrap Town";
		TOWER.map = "rp_scraptown";
		TOWER.fogColors = {r = 96, g = 47, b = 0};
		TOWER.fogColorsNight = {r = 32, g = 12, b = 4};
		TOWER.fogStart = 256;
		TOWER.fogStartNight = 256;
		TOWER.fogEnd = 1536;
		TOWER.fogEndNight = 1024;
		TOWER.colorModify = {["$pp_colour_brightness"] = -0.03, ["$pp_colour_contrast"] = 1.15, ["$pp_colour_colour"] = 0.85};
		TOWER.colorModifyNight = {["$pp_colour_brightness"] = -0.1, ["$pp_colour_contrast"] = 0.9, ["$pp_colour_colour"] = 0.75};
		TOWER.bounds = {
			min = Vector(-2446, -7, -262),
			max = Vector(-8792, -8935, 2110),
		};
		
		-- Called every frame.
		function TOWER:RenderCallback()
			DrawBloom(0.1, 1.4, 5, 5, 0.1, 0.5, 1, 0.8, 0.8);
		end;
	TOWER:Register()
	
	local SCRAPPER = zones:New("scrapper")
		SCRAPPER.name = "Scrapper";
		SCRAPPER.map = "rp_scraptown";
		SCRAPPER.fogColors = {r = 0, g = 0, b = 0};
		SCRAPPER.fogStart = 0;
		SCRAPPER.fogEnd = 2048;
		SCRAPPER.colorModify = {["$pp_colour_brightness"] = -0.05, ["$pp_colour_contrast"] = 1.5, ["$pp_colour_colour"] = 1.5, ["$pp_colour_mulr"] = 1.5};
		SCRAPPER.bounds = {
			min = Vector(-5279, -6466, 6),
			max = Vector(-9740, -7616, -2139),
		};
	SCRAPPER:Register()
	
	local DUEL = zones:New("duel")
		DUEL.name = "Duel Zone";
		DUEL.map = "rp_scraptown";
		DUEL.colorModify = {["$pp_colour_brightness"] = -0.025, ["$pp_colour_contrast"] = 1.1, ["$pp_colour_colour"] = 1.1};
		DUEL.fogStart = 4096;
		DUEL.fogEnd = 4096;
		DUEL.distanceInterval = 1000
		DUEL.bounds = {
			min = Vector(7679, -13741, -6952),
			max = Vector(12784, -11125, -5490),
		};
		
		-- Why did this get added? - DETrooper
		--[[function DUEL:OnEnter()
			Schema:WhiteFlash(1)
		end;
		
		function DUEL:OnExit()
			Schema:WhiteFlash(1)
		end;]]--
	DUEL:Register()
	
	local HELL = zones:New("hell", "suprahell")
		HELL.name = "Hell";
		HELL.map = "rp_scraptown";
		HELL.fogColors = {r = 80, g = 10, b = 10};
		HELL.fogStart = 0;
		HELL.fogEnd = 1024;
		HELL.colorModify = {["$pp_colour_brightness"] = -0.2, ["$pp_colour_contrast"] = 1, ["$pp_colour_colour"] = 1}
		HELL.bounds = {
			min = Vector(-16069, -15314, -16119),
			max = Vector(5637, -3537, -4757),
		};
		
		-- Called every frame.
		function HELL:RenderCallback()
			DrawBloom(0.05, 0.8, 1, 1, 0.1, 0.5, 5, 1, 1);
		end;
	HELL:Register()

	local MANOR = zones:New("manor", "suprahell")
		MANOR.name = "Manor";
		MANOR.map = "rp_scraptown";
		MANOR.fogColors = {r = 80, g = 10, b = 10};
		MANOR.fogStart = 1024;
		MANOR.fogEnd = 3072;
		MANOR.colorModify = {["$pp_colour_brightness"] = -0.05, ["$pp_colour_contrast"] = 1, ["$pp_colour_colour"] = 1}
		MANOR.bounds = {
			min = Vector(-1079, -8472, -6505),
			max = Vector(261, -9704, -6163),
		};
		MANOR.priority = 2;

		-- Called every frame.
		function MANOR:RenderCallback()
			DrawBloom(0.05, 0.2, 1, 1, 0.1, 0.5, 3.5, 1, 1);
		end;
	MANOR:Register()
elseif map == "rp_temple" then
		local TEMPLE = zones:New("temple", "temple")
		TEMPLE.default = true;
		TEMPLE.hasNight = false;
		TEMPLE.name = "Temple";
		TEMPLE.map = "rp_temple";
		TEMPLE.fogColors = {r = 255, g = 255, b = 255};
		TEMPLE.fogStart = 200;
		TEMPLE.fogEnd = 2800
		TEMPLE.bloomDisabled = true;
		TEMPLE.colorModify = {["$pp_colour_brightness"] = -0.035, ["$pp_colour_contrast"] = 1.05, ["$pp_colour_colour"] = 0.67};
		TEMPLE.colorModifyNight = {["$pp_colour_brightness"] = -0.035, ["$pp_colour_contrast"] = 1.05, ["$pp_colour_colour"] = 1};
	TEMPLE:Register()
	
		local TEMPLE_INDOOR = zones:New("temple_indoor", "temple")
		TEMPLE_INDOOR.hasNight = false;
		TEMPLE_INDOOR.name = "Temple Indoor";
		TEMPLE_INDOOR.map = "rp_temple";
		TEMPLE_INDOOR.fogColors = {r = 0, g = 0, b = 0};
		TEMPLE_INDOOR.fogStart = 0;
		TEMPLE_INDOOR.bounds = {min = Vector(2858.443604, 15497.877930, 76.334213), max = Vector(-2148.454346, 10316.474609, 861.943604)}
		TEMPLE_INDOOR.fogEnd = 2000
		TEMPLE_INDOOR.bloomDisabled = true;
		TEMPLE_INDOOR.colorModify = {["$pp_colour_brightness"] = -0.05, ["$pp_colour_contrast"] = 1.2, ["$pp_colour_colour"] = 0.7};
		TEMPLE_INDOOR.colorModifyNight = {["$pp_colour_brightness"] = -0.035, ["$pp_colour_contrast"] = 1.05, ["$pp_colour_colour"] = 1};
	TEMPLE_INDOOR:Register()
		local TEMPLE_TREE = zones:New("temple_tree", "temple")
		TEMPLE_TREE.hasNight = false;
		TEMPLE_TREE.name = "Temple Tree";
		TEMPLE_TREE.map = "rp_temple";
		TEMPLE_TREE.fogColors = {r = 245, g = 255, b = 245};
		TEMPLE_TREE.fogStart = 5000;
		TEMPLE_TREE.bounds = {min = Vector(2858.443604, 15497.877930, 76.334213), max = Vector(6982.742676, 11108.919922, 1697.103027)}
		TEMPLE_TREE.fogEnd = 7500
		TEMPLE_TREE.bloomDisabled = true;
		TEMPLE_TREE.colorModify = {["$pp_colour_brightness"] = -0.04, ["$pp_colour_contrast"] = 1.25, ["$pp_colour_colour"] = 1.25};
		TEMPLE_TREE.colorModifyNight = {["$pp_colour_brightness"] = -0.035, ["$pp_colour_contrast"] = 1.05, ["$pp_colour_colour"] = 1};
	TEMPLE_TREE:Register()
elseif map == "rp_district21" then
	local WASTELAND = zones:New("wasteland", "suprawasteland")
		WASTELAND.default = true;
		WASTELAND.hasNight = true;
		WASTELAND.hasWeather = true;
		WASTELAND.hasWarmth = true;
		WASTELAND.mapScene = true;
		WASTELAND.name = "Wasteland";
		WASTELAND.map = "rp_district21";
		WASTELAND.colorModify = {["$pp_colour_brightness"] = -0.1, ["$pp_colour_contrast"] = 1.2, ["$pp_colour_colour"] = 1.25, ["$pp_colour_mulb"] = 0.1};
		WASTELAND.colorModifyNight = {["$pp_colour_brightness"] = -0.1, ["$pp_colour_contrast"] = 0.9, ["$pp_colour_colour"] = 1, ["$pp_colour_mulb"] = 0.1};
		WASTELAND.fogColors = {r = 38, g = 54, b = 76};
		WASTELAND.fogColorsNight = {r = 4, g = 12, b = 32};
		WASTELAND.fogStart = 128;
		WASTELAND.fogStartNight = 128;
		WASTELAND.fogEnd = 2048;
		WASTELAND.fogEndNight = 1024;
	WASTELAND:Register()

	local HOTSPRING = zones:New("hotspring", "suprawasteland")
		HOTSPRING.name = "Hot Spring";
		HOTSPRING.map = "rp_district21";
		HOTSPRING.colorModify = {["$pp_colour_brightness"] = -0.1, ["$pp_colour_contrast"] = 1.2, ["$pp_colour_colour"] = 1.25, ["$pp_colour_mulb"] = 0.1};
		HOTSPRING.fogStart = 128;
		HOTSPRING.fogEnd = 1268;
		HOTSPRING.fogColors = {r = 91, g = 103, b = 119};
		HOTSPRING.fogColorsNight = {r = 56, g = 63, b = 73};
		HOTSPRING.bounds = {
			min = Vector(2860, -4117, -828),
			max = Vector(1306, -5199, 333),
		};
	HOTSPRING:Register()

	local DUEL = zones:New("duel")
		DUEL.name = "Duel Zone";
		DUEL.map = "rp_district21";
		DUEL.colorModify = {["$pp_colour_brightness"] = -0.025, ["$pp_colour_contrast"] = 1.1, ["$pp_colour_colour"] = 1.1};
		DUEL.fogStart = 4096;
		DUEL.fogEnd = 4096;
		DUEL.distanceInterval = 1000
		DUEL.bounds = {
			min = Vector(7679, -13741, -6952),
			max = Vector(12784, -11125, -5490),
		};
		
		-- Why did this get added? - DETrooper
		--[[function DUEL:OnEnter()
			Schema:WhiteFlash(1)
		end;
		
		function DUEL:OnExit()
			Schema:WhiteFlash(1)
		end;]]--
	DUEL:Register()

	local DREAMS = zones:New("dreams")
		DREAMS.name = "Dreams Zone";
		DREAMS.map = "rp_district21";
		DREAMS.colorModify = {["$pp_colour_brightness"] = -0.05, ["$pp_colour_contrast"] = 1.1, ["$pp_colour_colour"] = 0.8};
		DREAMS.fogStart = 4096;
		DREAMS.fogEnd = 4096;
		DREAMS.distanceInterval = 1000
		DREAMS.bounds = {
			min = Vector(419, 4789, -10305),
			max = Vector(-323, 6097, -11257),
		};
	DREAMS:Register()

	local SCRAPPER = zones:New("scrapper")
		SCRAPPER.name = "Scrapper";
		SCRAPPER.map = "rp_district21";
		SCRAPPER.fogColors = {r = 0, g = 0, b = 0};
		SCRAPPER.fogStart = 0;
		SCRAPPER.fogEnd = 2048;
		SCRAPPER.colorModify = {["$pp_colour_brightness"] = -0.05, ["$pp_colour_contrast"] = 1.5, ["$pp_colour_colour"] = 1.5, ["$pp_colour_mulr"] = 1.5};
		SCRAPPER.bounds = {
			min = Vector(7462, 14976, -600),
			max = Vector(12190, 12956, -2277),
		};
	SCRAPPER:Register()
	
	local CAVES = zones:New("caves")
		CAVES.name = "Caves";
		CAVES.map = "rp_district21";
		CAVES.hasWarmth = true;
		CAVES.fogColors = {r = 0, g = 0, b = 0};
		CAVES.fogStart = 0;
		CAVES.fogEnd = 768;
		CAVES.colorModify = {["$pp_colour_brightness"] = -0.03, ["$pp_colour_contrast"] = 1.15, ["$pp_colour_colour"] = 0.85};
		CAVES.bounds = {
			min = Vector(-11600, 4800, -1080),
			max = Vector(1834, -11573, -2100),
		};
	CAVES:Register()

	local TOWER = zones:New("tower", "suprawasteland")
		TOWER.name = "Hill of Light";
		TOWER.map = "rp_district21";
		TOWER.hasNight = true;
		TOWER.hasWeather = true;
		TOWER.hasWarmth = true;
		TOWER.colorModify = {["$pp_colour_brightness"] = -0.1, ["$pp_colour_contrast"] = 1.2, ["$pp_colour_colour"] = 1.25, ["$pp_colour_mulb"] = 0.1};
		TOWER.colorModifyNight = {["$pp_colour_brightness"] = -0.1, ["$pp_colour_contrast"] = 0.9, ["$pp_colour_colour"] = 1, ["$pp_colour_mulb"] = 0.1};
		TOWER.fogColors = {r = 38, g = 54, b = 76};
		TOWER.fogColorsNight = {r = 4, g = 12, b = 32};
		TOWER.fogStart = 128;
		TOWER.fogStartNight = 128;
		TOWER.fogEnd = 2048;
		TOWER.fogEndNight = 1024;
		TOWER.bounds = {
			{
				min = Vector(-4861, 13313, 0),
				max = Vector(-7600, 9407, 476),
			},
			{
				min = Vector(-10622, 12500, 476),
				max = Vector(-7600, 10368, 0),
			},
		};
	TOWER:Register()

	local HILLBUNKER = zones:New("hillbunker")
		HILLBUNKER.name = "Hill of Light Bunker";
		HILLBUNKER.map = "rp_district21";
		HILLBUNKER.colorModify = {["$pp_colour_brightness"] = -0.06, ["$pp_colour_contrast"] = 1.2, ["$pp_colour_colour"] = 1.25};
		HILLBUNKER.fogStart = 4096;
		HILLBUNKER.fogEnd = 4096;
		HILLBUNKER.bounds = {
			min = Vector(-9713, 8613, -1873),
			max = Vector(-7127, 12080, -1279),
		};
	HILLBUNKER:Register();

	local HELL = zones:New("hell", "suprahell")
		HELL.name = "Hell";
		HELL.map = "rp_district21";
		HELL.fogColors = {r = 80, g = 10, b = 10};
		HELL.fogStart = 0;
		HELL.fogEnd = 1024;
		HELL.colorModify = {["$pp_colour_brightness"] = -0.2, ["$pp_colour_contrast"] = 1, ["$pp_colour_colour"] = 1}
		HELL.bounds = {
			min = Vector(-16069, -15314, -16119),
			max = Vector(5637, -3537, -4757),
		};
		
		-- Called every frame.
		function HELL:RenderCallback()
			DrawBloom(0.05, 0.8, 1, 1, 0.1, 0.5, 5, 1, 1);
		end;
	HELL:Register()

	local MANOR = zones:New("manor", "suprahell")
		MANOR.name = "Manor";
		MANOR.map = "rp_district21";
		MANOR.fogColors = {r = 80, g = 10, b = 10};
		MANOR.fogStart = 1024;
		MANOR.fogEnd = 3072;
		MANOR.colorModify = {["$pp_colour_brightness"] = -0.05, ["$pp_colour_contrast"] = 1, ["$pp_colour_colour"] = 1}
		MANOR.bounds = {
			min = Vector(-1079, -8472, -6505),
			max = Vector(261, -9704, -6163),
		};
		MANOR.priority = 2;

		-- Called every frame.
		function MANOR:RenderCallback()
			DrawBloom(0.05, 0.2, 1, 1, 0.1, 0.5, 3.5, 1, 1);
		end;
	MANOR:Register()

	local GORE_TREE = zones:New("gore_tree", "supragore")
		GORE_TREE.name = "Gore Tree";
		GORE_TREE.map = "rp_district21";
		GORE_TREE.fogColors = {r = 255, g = 255, b = 255};
		GORE_TREE.fogStart = 0;
		GORE_TREE.fogEnd = 10240;
		GORE_TREE.colorModify = {["$pp_colour_brightness"] = 0, ["$pp_colour_contrast"] = 1.2, ["$pp_colour_colour"] = 0};
		GORE_TREE.bounds = {
			min = Vector(11713, -6746, 10673),
			max = Vector(5600, -11005, 15544),
		};
		GORE_TREE.colorInterval = 1024
		GORE_TREE.distanceInterval = 2048
		GORE_TREE.intervalMult = true;
		function GORE_TREE:RenderCallback() end;
	GORE_TREE:Register()

	local GORE_SOIL = zones:New("gore_soil", "supragore")
		GORE_SOIL.name = "Gore Soil";
		GORE_SOIL.map = "rp_district21";
		GORE_SOIL.fogColors = {r = 255, g = 255, b = 255};
		GORE_SOIL.fogStart = 0;
		GORE_SOIL.fogEnd = 10240;
		GORE_SOIL.colorModify = {["$pp_colour_brightness"] = 0, ["$pp_colour_contrast"] = 1.2, ["$pp_colour_colour"] = 0};
		GORE_SOIL.bounds = {
			min = Vector(11622, -6836, 12500),
			max = Vector(8744, -10586, 11180),
		};
		GORE_SOIL.colorInterval = 1024
		GORE_SOIL.distanceInterval = 2048
		GORE_SOIL.intervalMult = true;
		function GORE_SOIL:RenderCallback() end;
	GORE_SOIL:Register()

	local GORE_HALLWAY = zones:New("gore_hallway", "supragore")
		GORE_HALLWAY.name = "Gore Hallway";
		GORE_HALLWAY.map = "rp_district21";
		GORE_HALLWAY.fogColors = {r = 0, g = 0, b = 0};
		GORE_HALLWAY.fogStart = 1024;
		GORE_HALLWAY.fogEnd = 2048;
		GORE_HALLWAY.colorModify = {["$pp_colour_brightness"] = -0.1, ["$pp_colour_contrast"] = 2, ["$pp_colour_colour"] = 1};
		GORE_HALLWAY.bounds = {
			min = Vector(5600, -6800, 11685),
			max = Vector(2199, -8997, 12118),
		};
		GORE_HALLWAY.colorInterval = 64
		GORE_HALLWAY.distanceInterval = 2048
		GORE_HALLWAY.intervalMult = true;
		
		-- Called when the client enters the zone.
		function GORE_HALLWAY:OnEnter()
			if (cwViewBlockers) then
				for k, v in pairs (cwViewBlockers) do
					v:Remove();
				end;
			end;
			
			cwViewBlockers = {};
			cwViewBlockers["tree"] = ClientsideModel("models/hunter/plates/plate16x16.mdl", RENDERGROUP_BOTH);
			cwViewBlockers["tree"]:SetPos(Vector(6149, -8655, 11960));
			cwViewBlockers["forest"] = ClientsideModel("models/hunter/plates/plate16x16.mdl", RENDERGROUP_BOTH);
			cwViewBlockers["forest"]:SetPos(Vector(1604, -8745, 11959));

			for k, v in pairs (cwViewBlockers) do
				if (IsValid(v)) then
					v:SetAngles(Angle(90, 0, 180));
					v:SetRenderMode(RENDERMODE_TRANSALPHA);
					v:SetColor(Color(0, 0, 0, 255));
				end;
			end;

			timer.Create("ViewBlockerRemove", 5, 1, function()
				if (cwViewBlockers and !table.IsEmpty(cwViewBlockers)) then
					for k, v in pairs (cwViewBlockers) do
						v:Remove();
					end;
				end;
			end);
		end;
		
		-- Called when the client exits the zone.
		function GORE_HALLWAY:OnExit()
			if (cwViewBlockers and !table.IsEmpty(cwViewBlockers)) then
				for k, v in pairs (cwViewBlockers) do
					if (IsValid(v)) then
						v:Remove();
					end;
				end;
			end;
		end;
	GORE_HALLWAY:Register()

	local GORE = zones:New("gore", "supragore")
		GORE.name = "Gore Forest";
		GORE.map = "rp_district21";
		GORE.fogColors = {r = 100, g = 100, b = 100};
		GORE.fogStart = 0;
		GORE.fogEnd = 1024
		GORE.colorModify = {["$pp_colour_brightness"] = -0.05, ["$pp_colour_contrast"] = 1, ["$pp_colour_colour"] = 0.2};
		GORE.bounds = {
			min = Vector(2199, 4478, 10673),
			max = Vector(-15045, -15158, 15544),
		};
		GORE.colorInterval = 64
		GORE.distanceInterval = 2048
		GORE.intervalMult = true;
		
		-- Called every frame.
		function GORE:RenderCallback()
			DrawBloom(0.2, 1, 5, 5, 0.1, 0.5, 0.8, 0.8, 1);
		end;
	GORE:Register()

	local SEA1 = zones:New("sea_rough")
		SEA1.name = "Sea (Rough)";
		SEA1.map = "rp_district21";
		SEA1.fogColors = {r = 0, g = 30, b = 90};
		SEA1.fogStart = 0;
		SEA1.fogEnd = 1024;
		SEA1.colorModify = {["$pp_colour_brightness"] = -0.05, ["$pp_colour_contrast"] = 1, ["$pp_colour_colour"] = 0.15};
		SEA1.bounds = {
			min = Vector(15392, 14700, -5400),
			max = Vector(5158, 4500, -6500),
		};

		-- Called every frame.
		function SEA1:RenderCallback()
			DrawBloom(0.1, 1.4, 5, 5, 0.1, 0.5, 1, 0.8, 0.8);
		end;
	SEA1:Register()

	local SEA2 = zones:New("sea_calm")
		SEA2.name = "Sea (Calm)";
		SEA2.map = "rp_district21";
		SEA2.fogColors = {r = 66, g = 66, b = 66};
		SEA2.fogStart = 0;
		SEA2.fogEnd = 1024;
		SEA2.colorModify = {["$pp_colour_brightness"] = -0.05, ["$pp_colour_contrast"] = 1, ["$pp_colour_colour"] = 0.15};
		SEA2.bounds = {
			min = Vector(5110, 14700, -5400),
			max = Vector(-5095, 4500, -6500),
		};
		
		-- Called every frame.
		function SEA2:RenderCallback()
			DrawBloom(0.1, 1.4, 5, 5, 0.1, 0.5, 0.8, 0.8, 1);
		end;
	SEA2:Register()

	local SEA3 = zones:New("sea_styx")
		SEA3.name = "River Styx";
		SEA3.map = "rp_district21";
		SEA3.fogColors = {r = 80, g = 10, b = 10};
		SEA3.fogStart = 0;
		SEA3.fogEnd = 1024;
		SEA3.colorModify = {["$pp_colour_brightness"] = -0.2, ["$pp_colour_contrast"] = 1, ["$pp_colour_colour"] = 1}
		SEA3.bounds = {
			min = Vector(-5110, 14700, -5400),
			max = Vector(-15349, 4500, -6500),
		};
		
		-- Called every frame.
		function SEA3:RenderCallback()
			DrawBloom(0.05, 0.8, 1, 1, 0.1, 0.5, 5, 1, 1);
		end;
	SEA3:Register()

elseif map == "bg_district34" then
	local WASTELAND = zones:New("wasteland", "suprawasteland")
		WASTELAND.default = true;
		WASTELAND.hasNight = true;
		WASTELAND.hasWeather = true;
		WASTELAND.mapScene = true;
		WASTELAND.name = "Wasteland";
		WASTELAND.map = "bg_district34";
		WASTELAND.fogColors = {r = 61, g = 48, b = 41};
		WASTELAND.fogColorsNight = {r = 45, g = 36, b = 31};
		WASTELAND.fogStart = 256;
		WASTELAND.fogStartNight = 256;
		WASTELAND.fogEnd = 1536;
		WASTELAND.fogEndNight = 1024;
		WASTELAND.colorModify = {["$pp_colour_brightness"] = -0.03, ["$pp_colour_contrast"] = 1.15, ["$pp_colour_colour"] = 0.85};
		WASTELAND.colorModifyNight = {["$pp_colour_brightness"] = -0.15, ["$pp_colour_contrast"] = 0.85, ["$pp_colour_colour"] = 0.75};
	WASTELAND:Register()

	local SCRAPPER = zones:New("scrapper")
		SCRAPPER.name = "Scrapper";
		SCRAPPER.map = "bg_district34";
		SCRAPPER.fogColors = {r = 0, g = 0, b = 0};
		SCRAPPER.fogStart = 0;
		SCRAPPER.fogEnd = 2048;
		SCRAPPER.colorModify = {["$pp_colour_brightness"] = -0.05, ["$pp_colour_contrast"] = 1.5, ["$pp_colour_colour"] = 1.5, ["$pp_colour_mulr"] = 1.5};
		SCRAPPER.bounds = {
			min = Vector(-5017, 6830, -677),
			max = Vector(-9480, 5470, -2559),
		};
	SCRAPPER:Register()

		local TOWER = zones:New("tower", "suprawasteland")
		TOWER.name = "Villa of Light";
		TOWER.map = "bg_district34";
		TOWER.hasNight = true;
		TOWER.fogColors = {r = 61, g = 48, b = 41};
		TOWER.fogColorsNight = {r = 46, g = 36, b = 31};
		TOWER.fogStart = 1536;
		TOWER.fogEnd = 3200;
		TOWER.colorModify = {["$pp_colour_brightness"] = -0.02, ["$pp_colour_contrast"] = 1.22, ["$pp_colour_colour"] = 1};
		TOWER.colorModifyNight = {["$pp_colour_brightness"] = -0.045, ["$pp_colour_contrast"] = 1.05, ["$pp_colour_colour"] = 0.95};
		TOWER.hasWeather = true;
		TOWER.bounds = {
			{
				min = Vector(1579, -9720, 904),
				max = Vector(-720, -7680, 2480),
			},
			{
				min = Vector(1579, -9182, 904),
				max = Vector(2013, -8105, 2480),
			},
			{
				min = Vector(1579, -9182, 1188),
				max = Vector(2013, -9520, 2480),
			},
			{
				min = Vector(2013, -7680, 540),
				max = Vector(4395, -9720, 2480),
			},
			
		};
	TOWER:Register()

local CAVES = zones:New("caves")
		CAVES.name = "Mines";
		CAVES.map = "bg_district34";
		CAVES.fogColors = {r = 0, g = 0, b = 0};
		CAVES.fogStart = 0;
		CAVES.fogEnd = 768;
		CAVES.colorModify = {["$pp_colour_brightness"] = -0.03, ["$pp_colour_contrast"] = 1.15, ["$pp_colour_colour"] = 0.85};
		CAVES.bounds = {
			{
			min = Vector(-4301, 444, -216),
			max = Vector(7016, 7680, -904),
			},
			{
			min = Vector(6887, 6243, 303),
			max = Vector(1907, 5098, -216),
			},
			{
			min = Vector(4180, 5914, 182),	
			max = Vector(4706, 6615, -460),
			},
		};
	CAVES:Register()

	local HELL = zones:New("hell", "suprahell")
		HELL.name = "Hell";
		HELL.map = "bg_district34";
		HELL.fogColors = {r = 80, g = 10, b = 10};
		HELL.fogStart = 0;
		HELL.fogEnd = 1024;
		HELL.colorModify = {["$pp_colour_brightness"] = -0.2, ["$pp_colour_contrast"] = 1, ["$pp_colour_colour"] = 1}
		HELL.bounds = {
			min = Vector(-9444, -14956, -12878),
			max = Vector(12199, -3098, -1476),
		};
		
		-- Called every frame.
		function HELL:RenderCallback()
			DrawBloom(0.05, 0.8, 1, 1, 0.1, 0.5, 5, 1, 1);
		end;
	HELL:Register()

	local MANOR = zones:New("manor", "suprahell")
		MANOR.name = "Office";
		MANOR.map = "bg_district34";
		MANOR.fogColors = {r = 80, g = 10, b = 10};
		MANOR.fogStart = 1024;
		MANOR.fogEnd = 3072;
		MANOR.colorModify = {["$pp_colour_brightness"] = -0.05, ["$pp_colour_contrast"] = 1, ["$pp_colour_colour"] = 1}
		MANOR.bounds = {
			{
			min = Vector(852, -7859, -4881),
			max = Vector(2321, -9681, -2300),
			},
			{
			min = Vector(-6541, -8594, -9349),
			max = Vector(-5460, -9222, -9157),
			},
		};

		-- Called every frame.
		function MANOR:RenderCallback()
			DrawBloom(0.05, 0.2, 1, 1, 0.1, 0.5, 3.5, 1, 1);
		end;
	MANOR:Register()

local GORE = zones:New("gore", "supragore")
		GORE.name = "Gore Forest";
		GORE.map = "bg_district34";
		GORE.fogColors = {r = 112.2, g = 145.4, b = 154};
		GORE.fogStart = 0;
		GORE.fogEnd = 2448
		GORE.colorModify = {["$pp_colour_brightness"] = -0.05, ["$pp_colour_contrast"] = 1, ["$pp_colour_colour"] = 0.4};
		GORE.bounds = {
			min = Vector(-14233, -12473, 9822),
			max = Vector(14861, 2686, 13011),
		};
		GORE.colorInterval = 64
		GORE.distanceInterval = 2448
		GORE.intervalMult = true;
		
		-- Called every frame.
		function GORE:RenderCallback()
			DrawBloom(0.1, 1.4, 5, 5, 0.1, 0.5, 0.8, 0.8, 1);
		end;
	GORE:Register()

	local GORE_TREE = zones:New("gore_tree", "supragore")
		GORE_TREE.name = "Gore Tree";
		GORE_TREE.map = "bg_district34";
		GORE_TREE.fogColors = {r = 112.2, g = 145.4, b = 154};
		GORE_TREE.fogStart = 3200;
		GORE_TREE.fogEnd = 6000;
		GORE_TREE.colorModify = {["$pp_colour_brightness"] = 0, ["$pp_colour_contrast"] = 1.2, ["$pp_colour_colour"] = 0.1};
		GORE_TREE.bounds = {
			min = Vector(-13602, -12473, 9822),
			max = Vector(-9226, -15964, 13011),
		};
		GORE_TREE.colorInterval = 1024
		GORE_TREE.distanceInterval = 2048
		GORE_TREE.intervalMult = true;
		function GORE_TREE:RenderCallback() end;
	GORE_TREE:Register()

	local SEA1 = zones:New("sea_rough")
		SEA1.weatherOverride = "rain";
		SEA1.name = "Sea (Rough)";
		SEA1.map = "bg_district34";
		SEA1.fogColors = {r = 0, g = 30, b = 90};
		SEA1.fogStart = 0;
		SEA1.fogEnd = 1024;
		SEA1.colorModify = {["$pp_colour_brightness"] = -0.05, ["$pp_colour_contrast"] = 1, ["$pp_colour_colour"] = 0.15};
		SEA1.bounds = {
			min = Vector(15552, 2899, -8442),
			max = Vector(5306, 13120, -5209),
		};

		-- Called every frame.
		function SEA1:RenderCallback()
			DrawBloom(0.1, 1.4, 5, 5, 0.1, 0.5, 1, 0.8, 0.8);
		end;
	SEA1:Register()

	local SEA2 = zones:New("sea_calm")
		SEA2.name = "Sea (Calm)";
		SEA2.map = "bg_district34";
		SEA2.fogColors = {r = 66, g = 66, b = 66};
		SEA2.fogStart = 0;
		SEA2.fogEnd = 1024;
		SEA2.colorModify = {["$pp_colour_brightness"] = -0.05, ["$pp_colour_contrast"] = 1, ["$pp_colour_colour"] = 0.15};
		SEA2.bounds = {
			min = Vector(5302, 2899, -8442),
			max = Vector(-4944, 13120, -5209),
		};
		
		-- Called every frame.
		function SEA2:RenderCallback()
			DrawBloom(0.1, 1.4, 5, 5, 0.1, 0.5, 0.8, 0.8, 1);
		end;
	SEA2:Register()

	local SEA3 = zones:New("sea_styx")
		SEA3.weatherOverride = "ash";
		SEA3.name = "River Styx";
		SEA3.map = "bg_district34";
		SEA3.fogColors = {r = 80, g = 10, b = 10};
		SEA3.fogStart = 0;
		SEA3.fogEnd = 1024;
		SEA3.colorModify = {["$pp_colour_brightness"] = -0.2, ["$pp_colour_contrast"] = 1, ["$pp_colour_colour"] = 1}
		SEA3.bounds = {
			min = Vector(-4949, 2899, -8442),
			max = Vector(-15194, 13120, -5209),
		};
		
		-- Called every frame.
		function SEA3:RenderCallback()
			DrawBloom(0.05, 0.8, 1, 1, 0.1, 0.5, 5, 1, 1);
		end;
	SEA3:Register()

else
	local WASTELAND = zones:New("wasteland", "suprawasteland")
		WASTELAND.default = true;
		WASTELAND.hasNight = true;
		WASTELAND.name = "Wasteland";
		WASTELAND.map = game.GetMap();
		WASTELAND.fogColors = {r = 96, g = 47, b = 0};
		WASTELAND.fogColorsNight = {r = 32, g = 12, b = 4};
		WASTELAND.fogStart = 256;
		WASTELAND.fogStartNight = 256;
		WASTELAND.fogEnd = 1536;
		WASTELAND.fogEndNight = 1024;
		WASTELAND.colorModify = {["$pp_colour_brightness"] = -0.03, ["$pp_colour_contrast"] = 1.15, ["$pp_colour_colour"] = 0.85};
		WASTELAND.colorModifyNight = {["$pp_colour_brightness"] = -0.1, ["$pp_colour_contrast"] = 0.9, ["$pp_colour_colour"] = 0.75};
		
		-- Called every frame.
		function WASTELAND:RenderCallback()
			DrawBloom(0.1, 1.4, 5, 5, 0.1, 0.5, 1, 0.8, 0.8);
		end;
	WASTELAND:Register()
end

netstream.Hook("GetZone", function(data)
	--print("GetZone called, sending the active zone "..tostring(zones.cwCurrentZone).." to the server!");
	if data then
		zones:RefreshCurrentZone();
		zones:RefreshZoneVFX();
	end
	
	netstream.Start("EnteredZone", zones.cwCurrentZone);
end)

netstream.Hook("RefreshCurrentZone", function(data)
	zones:RefreshCurrentZone();
end)

Clockwork.plugin:Add("zones", zones);