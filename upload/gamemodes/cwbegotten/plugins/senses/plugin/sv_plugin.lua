--[[
	Begotten III: Jesus Wept
--]]

local playerMeta = FindMetaTable("Player");

-- A function to handle a player's implants.
function playerMeta:HandleSenses()
--[[	local senses = self:GetWeapon("cw_senses");

	if (IsValid(senses) and !self.sensesOn and self:Alive() and !self:IsRagdolled()) then
		self:SetNWBool("senses", true);
self.sensesOn = true
		Clockwork.datastream:Start(self, "Stunned", 1.5);
		Clockwork.datastream:Start(self, "PlaySound", table.Random({"ambient/machines/teleport1.wav", "ambient/machines/teleport3.wav", "ambient/machines/teleport4.wav"}));
	else
		self:SetNWBool("senses", false);
self.sensesOn = nil
		Clockwork.datastream:Start(self, "Stunned", 1.5);
		Clockwork.datastream:Start(self, "PlaySound", table.Random({"ambient/machines/teleport1.wav", "ambient/machines/teleport3.wav", "ambient/machines/teleport4.wav"}));
	end;--]]
end;

-- A function to handle a player's senses.
function playerMeta:SensesOn(bRightClick)
	local senses = self:GetWeapon("cw_senses");

	if (IsValid(senses) and self:Alive() and !self:IsRagdolled()) then
		local clothesItem = self:GetClothesEquipped();
		local nightVision = bRightClick and clothesItem and clothesItem.attributes and table.HasValue(clothesItem.attributes, "night_vision");
		local thermalVision = !bRightClick and clothesItem and clothesItem.attributes and table.HasValue(clothesItem.attributes, "thermal_vision");
		
		if self:GetCharmEquipped("thermal_implant") then
			if bRightClick then
				nightVision = true;
			else
				thermalVision = true;
			end
		end
		
		if (nightVision or thermalVision) then
			if (nightVision) then
				if self:GetNWBool("hasThermal") then
					self:SetNWBool("hasThermal", false);
				end
			
				self:SetNWBool("hasNV", true);
			elseif (thermalVision) then
				if self:GetNWBool("hasNV") then
					self:SetNWBool("hasNV", false);
				end
			
				self:SetNWBool("hasThermal", true);
			end
			
			if !self.cwObserverMode then
				self:EmitSound("items/nvg_on.wav");
				
				if !self.opponent and cwBeliefs and cwCharacterNeeds and self:HasBelief("yellow_and_black") then
					self:HandleNeed("sleep", 1);
				end
			end
			
			self:SetNWBool("senses", true);
		else
			Clockwork.datastream:Start(self, "BlackStunned", 1);
			--Clockwork.datastream:Start(self, "PlaySound", table.Random({"ambient/machines/teleport1.wav", "ambient/machines/teleport3.wav", "ambient/machines/teleport4.wav"}));
			
			timer.Simple(1, function()
				if IsValid(self) then
					Clockwork.datastream:Start(self, "PlaySound", "begotten/ambient/req/whoosh_02.wav");
					self:SetNWBool("senses", true);
					self:SetDSP(114);
				end
			end);
		end
		
		self.sensesOn = true;
	end
end;

-- A function to handle a player's senses.
function playerMeta:SensesOff()
	if self:GetNWBool("hasThermal") or self:GetNWBool("hasNV") then
		if self:GetNWBool("hasThermal") then
			self:SetNWBool("hasThermal", false);
		end
		
		if self:GetNWBool("hasNV") then
			self:SetNWBool("hasNV", false);
		end
		
		if !self.cwObserverMode and self:Alive() then
			self:EmitSound("items/nvg_off.wav");
		end
		
		self:SetNWBool("senses", false);
		self:SetDSP(0);
	elseif self:GetNWBool("senses") then
		if self:Alive() then
			Clockwork.datastream:Start(self, "BlackStunned", 1);
			
			timer.Simple(1, function()
				if IsValid(self) then
					Clockwork.datastream:Start(self, "PlaySound", "begotten/ambient/hits/disappear.mp3");
					self:SetNWBool("senses", false);
					self:SetDSP(0);
				end
			end);
		else
			self:SetNWBool("senses", false);
			self:SetDSP(0);
		end
	end
		
	self.sensesOn = nil;
end;
