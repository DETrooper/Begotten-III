local pillarsBounds = {
	["min"] = Vector(13132, -1394, 26),
	["max"] = Vector(9247, -4288, -913),
};
local temperature_interval = 5;

function cwWarmth:ClockworkInitialized()
	-- Make sure items get the freezing data.
	Clockwork.item:Initialize();
end

function cwWarmth:PostPlayerCharacterLoaded(player)
	player:SetLocalVar("warmth", player:GetCharacterData("warmth", 100));
end

-- Called at an interval for every active item entity.
function cwWarmth:ItemEntityThink(entity, itemTable)	
	local freezing = itemTable:GetData("freezing");
	
	if freezing then
		local ents = ents.FindInSphere(entity:GetPos(), 320);
		
		for i, v in ipairs(ents) do
			if v:GetClass() == "env_fire" then
				if freezing > 0 then
					itemTable:SetData("freezing", math.max(freezing - 5, 0));
				end
				
				return;
			end
		end
		
		if freezing < 100 then
			itemTable:SetData("freezing", math.min(freezing + 1, 100));
		end
	end
end

-- Called at an interval while the player is connected to the server.
function cwWarmth:PlayerThink(player, curTime, infoTable, alive, initialized, plyTable)
	if !plyTable.nextTempDecay then
		plyTable.nextTempDecay = curTime + temperature_interval;
		
		return;
	end
	
	if plyTable.nextTempDecay <= curTime then
		plyTable.nextTempDecay = curTime + temperature_interval;
	
		if Clockwork.player:HasFlags(player, "E") or !initialized or (!alive or player:GetMoveType() == MOVETYPE_NOCLIP or player.opponent or player.cwWakingUp or (player.possessor and IsValid(player.possessor)) or (player.victim and IsValid(player.victim))) then
			return;
		end;

		if cwPowerArmor and player:IsWearingPowerArmor() then
			player:HandleTemperature(5);
			
			return;
		end
		
		if player:IsOnFire() then
			player:HandleTemperature(50);
			
			return;
		end

		local lastZone = player:GetCharacterData("LastZone", "wasteland");
		local waterLevel = player:WaterLevel();
		
		if waterLevel > 0 then
			if !cwBeliefs or !player:HasBelief("the_black_sea") then
				if !string.find(lastZone, "gore") then
					if waterLevel == 1 then
						player:HandleTemperature(-2);
					elseif waterLevel == 2 then
						player:HandleTemperature(-25);
					elseif waterLevel > 2 then
						player:HandleTemperature(-50);
					end
					
					return;
				end
			end
		end

		if game.GetMap() == "rp_district21" and player:GetPos():WithinAABox(pillarsBounds["min"], pillarsBounds["max"]) then
			player:HandleTemperature(3);
			
			return;
		end

		local temperatureDecay = -0.75;
		local outside = true;

		if cwWeather then
			outside = cwWeather:IsOutside(player:GetPos());
		end

		if outside then
			temperatureDecay = -1;
		end

		-- Zones aren't shared so I'll just have to do this sloppily.
		if string.find(lastZone, "sea") or string.find(lastZone, "gore") then
			temperatureDecay = 1;
		elseif lastZone == "hell" or lastZone == "manor" then
			temperatureDecay = 50;
		elseif player:InTower() or lastZone == "hillbunker" or player:GetPos():WithinAABox(Vector(-4765, 9246, 838), Vector(-8075, 10488, 489)) or player:GetPos():WithinAABox(Vector(-4912, 12882, 119), Vector(-7787, 13492, 681)) then
			temperatureDecay = 0;
		elseif cwDayNight and cwDayNight.currentCycle == "night" then
			temperatureDecay = -1;
		end

		if temperatureDecay < 0 and player:IsRunning() then
			temperatureDecay = temperatureDecay + 0.5;
		end

		if cwWeather then
			if lastZone == "wasteland" or player:InTower() then
				local weather = cwWeather.weather;
				
				if weather == "blizzard" then
					if outside then
						temperatureDecay = temperatureDecay - 2;
					end
				elseif weather == "snow" then
					if outside then
						temperatureDecay = temperatureDecay - 1;
					end
				end
			end
		end

		for k, v in pairs (ents.FindInSphere(player:GetPos(), 128)) do
			if v:GetClass() == "env_fire" or v:GetClass() == "army_fireplace" then
				temperatureDecay = 3;
				break;
			elseif v:IsPlayer() and v:Alive() then
				local activeWeapon = v:GetActiveWeapon();
				
				if IsValid(activeWeapon) and ((activeWeapon:GetClass() == "cw_lantern" and Clockwork.player:GetWeaponRaised(v)) or activeWeapon.IgniteTime) then
					local weaponItemTable = item.GetByWeapon(v:GetActiveWeapon());
					
					if weaponItemTable then
						local currentOil = weaponItemTable:GetData("oil") or 0;
						
						if currentOil > 0 then
							temperatureDecay = 1;
							break;
						end
					end
				elseif v:GetSharedVar("lanternOnHip") then
					temperatureDecay = 1;
					break;
				end
			end;
		end;
		
		if temperatureDecay < 0 then
			local insulation = 0;
			local clothesItem = player:GetClothesEquipped();
			local helmetItem = player:GetHelmetEquipped();
			
			if cwBeliefs and player:HasBelief("unyielding") then
				insulation = insulation + 20;
			end
			
			if clothesItem then
				if clothesItem.hasHelmet then
					insulation = insulation + (clothesItem.insulation or 20);
				else
					insulation = insulation + ((clothesItem.insulation or 20) * 0.8);
				end
			end
			
			if helmetItem then
				insulation = insulation + ((helmetItem.insulation or 20) * 0.2);
			end
			
			-- Gores get 50% temperature resistance decay.
			if player:GetFaction() == "Goreic Warrior" then
				temperatureDecay = temperatureDecay / 2;
			end

			if player:GetFaction() == "Hillkeeper" then
				temperatureDecay = temperatureDecay * 0.7;
			end
			
			temperatureDecay = Lerp(math.Clamp(insulation / 100, 0, 1), temperatureDecay, 0);
		end

		//temperatureDecay = temperatureDecay * 0.55;
		
		if temperatureDecay ~= 0 then
			player:HandleTemperature(temperatureDecay);
		end
		
		if cwCharacterNeeds then
			local temperature = player:GetCharacterData("warmth", 100);
			
			-- If character has hypothermia, give a moderate chance to add hunger and fatigue.
			if temperature <= 50 then
				if math.random(1, 3) == 1 then
					player:HandleNeed("hunger", -1);
				end
				
				if math.random(1, 5) == 1 then
					player:HandleNeed("sleep", 1);
				end
			end
		end
	end;
end;

function cwWarmth:ModifyPlayerSpeed(player, infoTable, action)
	local currentTemp = player:GetCharacterData("warmth", 100);
	
	if currentTemp <= 50 then
		infoTable.runSpeed = infoTable.walkSpeed * 0.8;
		infoTable.walkSpeed = infoTable.walkSpeed * 0.8;
	end
end

function cwWarmth:PlayerHealedFull(player)
	player:SetLocalVar("warmth", 100);
	player:SetCharacterData("warmth", 100);
end

local playerMeta = FindMetaTable("Player")

-- A function to handle a player's warmth value.
function playerMeta:HandleTemperature(amount)
	if (!amount or type(amount) != "number" or amount == 0) then
		return
	end

	if(self:GetCharacterData("isThrall", false) or self.opponent or self.adyssaCutscene) then return; end
	
	local currentTemp = self:GetCharacterData("warmth", 100);
	local newTemp = math.Clamp(currentTemp + amount, 0, 100);
	
	if newTemp <= 0 then
		if !self:IsRagdolled() then
			Clockwork.player:SetRagdollState(self, RAGDOLL_KNOCKEDOUT, 20);
		end;

		local health = self:Health();
		local maxHealth = self:GetMaxHealth();
		
		if health > health - (maxHealth / 4) then
			self:SetHealth(health - (maxHealth / 4));
		else
			self:DeathCauseOverride("Froze to death.");
			self:Kill();
		end
	elseif newTemp <= 10 and currentTemp > 10 then
		Clockwork.chatBox:Add(self, nil, "itnofake", "So... cold...");
	elseif newTemp <= 25 and currentTemp > 25 then
		if math.random(1, 2) == 1 then
			Clockwork.chatBox:Add(self, nil, "itnofake", "I can't feel my hands...");
			
			if cwMedicalSystem then
				self:AddInjury(HITGROUP_LEFTARM, "frostbite");
				self:AddInjury(HITGROUP_RIGHTARM, "frostbite");
			end
		else
			Clockwork.chatBox:Add(self, nil, "itnofake", "I can't feel my feet...");
			
			if cwMedicalSystem then
				self:AddInjury(HITGROUP_LEFTLEG, "frostbite");
				self:AddInjury(HITGROUP_RIGHTLEG, "frostbite");
			end
		end
	elseif newTemp <= 50 and currentTemp > 50 then
		Clockwork.chatBox:Add(self, nil, "itnofake", "I have to get warm soon...");
	elseif newTemp <= 75 and currentTemp > 75 then
		Clockwork.chatBox:Add(self, nil, "itnofake", "I'm getting cold...");
	end
	
	self:SetLocalVar("warmth", newTemp);
	self:SetCharacterData("warmth", newTemp);
	
	hook.Run("RunModifyPlayerSpeed", self, self.cwInfoTable, true)
end
