--[[
	Begotten III: Jesus Wept
--]]

-- Called when the local player's item functions should be adjusted.
function cwLantern:PlayerAdjustItemFunctions(itemTable, itemFunctions)
	--[[
	if (itemTable.lantern) then
		if (itemTable:GetData("IsWorn", false) == true) then
			itemFunctions[#itemFunctions + 1] = {
				title = "Remove From Hip",
				name = "wearlantern"
			};
		elseif (itemTable:GetData("IsWorn") == false) then
			itemFunctions[#itemFunctions + 1] = {
				title = "Wear On Hip",
				name = "unwearlantern"
			};
		end;
	end;
	--]]
end;

-- Called every frame.
function cwLantern:Think()
	local curTime = CurTime();
	
	if (!self.lanternPlayers) then
		self.lanternPlayers = {};
	end;
	
	if (!self.nextLanternPlayers or self.nextLanternPlayers < curTime) then
		self.nextLanternPlayers = curTime + 1;
		self.lanternPlayers = {};
		
		local playerCount = _player.GetCount();
		local players = _player.GetAll();
		local clientPosition = Clockwork.Client:GetPos();
		local reqDistance = (2000 * 2000);
		
		if (zones and zones.currentFogEnd) then
			reqDistance = (zones.currentFogEnd * zones.currentFogEnd);
		end;

		for i = 1, playerCount do
			local v, k = players[i], i;
			
			if (v:Alive()) then
				local activeWeapon = v:GetActiveWeapon();
				
				if (IsValid(activeWeapon) and activeWeapon:GetClass() == "cw_lantern") or v:GetSharedVar("lanternOnHip") then
					local position = v:GetPos();
					
					if (position:DistToSqr(clientPosition) <= reqDistance) then
						self.lanternPlayers[v] = true;
					end;
				end;
			end;
		end;
	end;
	
	for k, v in pairs (self.lanternPlayers) do
		if !IsValid(k) or (!k:Alive()) then
			self.lanternPlayers[k] = nil;
			continue;
		end;
		
		local isRaised, activeWeapon = k:IsWeaponRaised();
		
		if !k:GetSharedVar("lanternOnHip") and (!isRaised or (IsValid(activeWeapon) and activeWeapon:GetClass() != "cw_lantern")) then
			self.lanternPlayers[k] = nil;
			continue;
		end;
		
		if k:GetSharedVar("hidden") then
			self.lanternPlayers[k] = nil;
			continue;
		end;
		
		local currentOil = k:GetSharedVar("oil", 0);
		local handIndex = k:GetSharedVar("lanternOnHip", false) and k:LookupBone("ValveBiped.Bip01_R_Thigh") or k:LookupBone("ValveBiped.Bip01_R_Hand");

		if (!handIndex) then 
			continue;
		end;

		local originalSize = 666;

		if (currentOil < 25) then
			if currentOil <= 0 then
				continue;
			end
		
			originalSize = Lerp(currentOil, originalSize / 2, originalSize);
		end;
		
		local entIndex = k:EntIndex();
		local dynamicLight = DynamicLight(entIndex);
		local bonePositon = k:GetBonePosition(handIndex);
		
		if (dynamicLight) then
			dynamicLight.Pos = bonePositon - Vector(0, 0, 20); 
			dynamicLight.r = 255;
			dynamicLight.g = 200;
			dynamicLight.b = 115;
			dynamicLight.Brightness = 1;
			dynamicLight.Size = originalSize;
			dynamicLight.DieTime = curTime + 0.1;
			dynamicLight.Style = 6;
		end;
	end;
end;

-- Called when the bars are needed.
function cwLantern:GetBars(bars)
	local activeWeapon = Clockwork.Client:GetActiveWeapon();
	
	if (IsValid(activeWeapon)) then
		local activeClass = activeWeapon:GetClass();
		
		if (activeClass == "cw_lantern" or Clockwork.Client:GetSharedVar("lanternOnHip", false)) then
			local oil = Clockwork.Client:GetSharedVar("oil", 0);
			
			--if (oil < 50) then
				local oilColor = oil / 100;
				local color = Color(255 * oilColor, 200 * oilColor, 50 * oilColor);
				local oilText = self:GetOilText();
				
				if (oil) then
					if (!self.oil) then
						self.oil = oil;
					else
						self.oil = math.Approach(self.oil, oil, 1);
					end;
					
					bars:Add("OIL", color, oilText, self.oil, 100, self.oil < 10);
				end;
			--end;
		end;
	end;
end;