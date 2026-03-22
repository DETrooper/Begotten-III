--[[
	BEGOTTEN III: Developed by DETrooper, cash wednesday, gabs & alyousha35
--]]

library.New("limb", Clockwork)

Clockwork.limb.bones = {
	["ValveBiped.Bip01_R_UpperArm"] = HITGROUP_RIGHTARM,
	["ValveBiped.Bip01_R_Forearm"] = HITGROUP_RIGHTARM,
	["ValveBiped.Bip01_L_UpperArm"] = HITGROUP_LEFTARM,
	["ValveBiped.Bip01_L_Forearm"] = HITGROUP_LEFTARM,
	["ValveBiped.Bip01_R_Thigh"] = HITGROUP_RIGHTLEG,
	["ValveBiped.Bip01_R_Calf"] = HITGROUP_RIGHTLEG,
	["ValveBiped.Bip01_R_Foot"] = HITGROUP_RIGHTLEG,
	["ValveBiped.Bip01_R_Hand"] = HITGROUP_RIGHTARM,
	["ValveBiped.Bip01_L_Thigh"] = HITGROUP_LEFTLEG,
	["ValveBiped.Bip01_L_Calf"] = HITGROUP_LEFTLEG,
	["ValveBiped.Bip01_L_Foot"] = HITGROUP_LEFTLEG,
	["ValveBiped.Bip01_L_Hand"] = HITGROUP_LEFTARM,
	["ValveBiped.Bip01_Pelvis"] = HITGROUP_STOMACH,
	["ValveBiped.Bip01_Spine2"] = HITGROUP_CHEST,
	["ValveBiped.Bip01_Spine1"] = HITGROUP_CHEST,
	["ValveBiped.Bip01_Head1"] = HITGROUP_HEAD,
	["ValveBiped.Bip01_Neck1"] = HITGROUP_HEAD
}

Clockwork.limb.hitgroupToString = {
	[HITGROUP_CHEST] = "chest",
	[HITGROUP_HEAD] = "head",
	[HITGROUP_STOMACH] = "stomach",
	[HITGROUP_LEFTARM] = "left arm",
	[HITGROUP_RIGHTARM] = "right arm",
	[HITGROUP_LEFTLEG] = "left leg",
	[HITGROUP_RIGHTLEG] = "right leg",
	[HITGROUP_GENERIC] = "generic",
}

-- A function to convert a bone to a hit group.
function Clockwork.limb:BoneToHitGroup(bone)
	return self.bones[bone] or HITGROUP_CHEST
end

-- A function to get whether limb damage is active.
function Clockwork.limb:IsActive()
	return config.Get("limb_damage_system"):Get()
end

if (SERVER) then
	function Clockwork.limb:TakeDamage(player, hitGroup, damage)
		if (hook.Run("PlayerCanTakeLimbDamage", player, hitGroup)) ~= false then
			local newDamage = math.ceil(damage)
			local limbData = player:GetCharacterData("LimbData", {})

			if (limbData) then
				if (!limbData[hitGroup]) then
					limbData[hitGroup] = 0;
				end;
				
				limbData[hitGroup] = math.min((limbData[hitGroup] or 0) + newDamage, player:GetMaxHealth())

				netstream.Start(player, "TakeLimbDamage", {
					hitGroup = hitGroup, damage = newDamage
				})
				
				player:SetCharacterData("LimbData", limbData);

				hook.Run("PlayerLimbTakeDamage", player, hitGroup, newDamage)
			end
		end
	end
	
	-- A function to cache a player's limbs.
	function Clockwork.limb:CacheLimbs(player, bReset)
		local limbData = player:GetCharacterData("LimbData", {})

		if (limbData) then
			player.cachedLimbData = limbData;
		end

		if bReset then
			Clockwork.limb:ResetDamage(player);
		end
	end
	
	-- A function to restore a player's limbs from a cache.
	function Clockwork.limb:RestoreLimbsFromCache(player)
		if player.cachedLimbData then
			player:SetCharacterData("LimbData", player.cachedLimbData);
			netstream.Start(player, "ReceiveLimbDamage", player:GetCharacterData("LimbData", {}))
			player.cachedLimbData = nil;
			
			hook.Run("RunModifyPlayerSpeed", player, player.cwInfoTable, true);
		end
	end

	-- A function to heal a player's body.
	function Clockwork.limb:HealBody(player, amount)
		local limbData = player:GetCharacterData("LimbData", {})

		if (limbData) then
			for k, v in pairs(limbData) do
				self:HealDamage(player, k, amount)
			end
		end
	end

	-- A function to heal a player's limb damage.
	function Clockwork.limb:HealDamage(player, hitGroup, amount)
		local newAmount = math.ceil(amount)
		local limbData = player:GetCharacterData("LimbData", {})

		if (limbData and limbData[hitGroup]) then
			if (hook.Run("PlayerCanHealLimb", player, hitGroup)) ~= false then
				limbData[hitGroup] = math.max(limbData[hitGroup] - newAmount, 0)

				if (limbData[hitGroup] == 0) then
					limbData[hitGroup] = nil
				end

				netstream.Start(player, "HealLimbDamage", {
					hitGroup = hitGroup, amount = newAmount
				})
				
				player:SetCharacterData("LimbData", limbData);

				hook.Run("PlayerLimbDamageHealed", player, hitGroup, newAmount)
			end
		end
	end

	-- A function to reset a player's limb damage.
	function Clockwork.limb:ResetDamage(player)
		player:SetCharacterData("LimbData", {})

		netstream.Start(player, "ResetLimbDamage", true)

		hook.Run("PlayerLimbDamageReset", player)
	end

	-- A function to get whether any of a player's limbs are damaged.
	function Clockwork.limb:IsAnyDamaged(player)
		local limbData = player:GetCharacterData("LimbData", {})

		if (limbData and !table.IsEmpty(limbData)) then
			return true
		else
			return false
		end
	end

	-- A function to get a player's limb health.
	function Clockwork.limb:GetHealth(player, hitGroup, asFraction)
		return 100 - self:GetDamage(player, hitGroup, asFraction)
	end

	-- A function to get a player's limb damage.
	function Clockwork.limb:GetDamage(player, hitGroup, asFraction)
		if (!config.Get("limb_damage_system"):Get()) then
			return 0
		end

		local limbData = player:GetCharacterData("LimbData", {})

		if (type(limbData) == "table") then
			if (limbData and limbData[hitGroup]) then
				if (asFraction) then
					return limbData[hitGroup] / 100
				else
					return limbData[hitGroup]
				end
			end
		end

		return 0
	end
else
	Clockwork.limb.bodyTexture = Material("begotten/limbs/body.png")
	Clockwork.limb.stored = Clockwork.limb.stored or {}
	Clockwork.limb.hitGroups = {
		[HITGROUP_RIGHTARM] = Material("begotten/limbs/rarm.png"),
		[HITGROUP_RIGHTLEG] = Material("begotten/limbs/rleg.png"),
		[HITGROUP_LEFTARM] = Material("begotten/limbs/larm.png"),
		[HITGROUP_LEFTLEG] = Material("begotten/limbs/lleg.png"),
		[HITGROUP_STOMACH] = Material("begotten/limbs/stomach.png"),
		[HITGROUP_CHEST] = Material("begotten/limbs/chest.png"),
		[HITGROUP_HEAD] = Material("begotten/limbs/head.png")
	}
	Clockwork.limb.names = {
		[HITGROUP_RIGHTARM] = "Right Arm",
		[HITGROUP_RIGHTLEG] = "Right Leg",
		[HITGROUP_LEFTARM] = "Left Arm",
		[HITGROUP_LEFTLEG] = "Left Leg",
		[HITGROUP_STOMACH] = "Stomach",
		[HITGROUP_CHEST] = "Chest",
		[HITGROUP_HEAD] = "Head"
	}
	Clockwork.limb.hitGroupsToLimbStateKeys = {
		[HITGROUP_RIGHTARM] = "arms",
		[HITGROUP_RIGHTLEG] = "legs",
		[HITGROUP_LEFTARM] = "arms",
		[HITGROUP_LEFTLEG] = "legs",
		[HITGROUP_STOMACH] = "stomach",
		[HITGROUP_CHEST] = "torso",
		[HITGROUP_HEAD] = "head"
	}

	-- A function to get a limb's texture.
	function Clockwork.limb:GetTexture(hitGroup)
		if (hitGroup == "body") then
			return self.bodyTexture
		else
			return self.hitGroups[hitGroup]
		end
	end

	-- A function to get a limb's name.
	function Clockwork.limb:GetName(hitGroup)
		return self.names[hitGroup] or "Generic"
	end
	
	function Clockwork.limb:BuildTooltip(hitGroup, x, y, width, height, frame)
		local limbStateTable = cwLimbs.limbStates[Clockwork.limb.hitGroupsToLimbStateKeys[hitGroup]];
		local name = Clockwork.limb:GetName(hitGroup);
		local health = Clockwork.limb:GetHealth(hitGroup);
		local bleeding = Clockwork.Client.cwLimbs[self.hitgroupToString[hitGroup]].bleeding;
		local infected = Clockwork.Client.cwLimbs[self.hitgroupToString[hitGroup]].infected;
		local injuries = Clockwork.Client.cwInjuries[hitGroup];
		local color = Clockwork.limb:GetColor(health);
		local status = "fine";
		
		if health then
			if health <= 90 and health > 75 then
				status = "slightly_damaged";
			elseif health <= 75 and health > 50 then
				status = "damaged";
			elseif health <= 50 and health > 25 then
				status = "heavily_damaged";
			elseif health <= 25 and health > 10 then
				status = "severely_damaged";
			elseif health <= 10 then
				status = "mangled";
			end
		end
		
		local effects = limbStateTable[status].effects;
		local statusNiceText = limbStateTable[status].name;
		
		frame:AddText(name.." - "..statusNiceText, color, "nov_IntroTextSmallDETrooper", 1);
		
		if bleeding then
			frame:AddText("Bleeding", Color(200, 40, 40), "nov_IntroTextSmallDETrooper", 1);
		end
		
		if infected then
			if infected == 1 then
				frame:AddText("Minor Infection", Color(200, 40, 40), "nov_IntroTextSmallDETrooper", 1);
			elseif infected == 2 then
				frame:AddText("Infection", Color(200, 40, 40), "nov_IntroTextSmallDETrooper", 1);
			elseif infected == 3 then
				frame:AddText("Major Infection", Color(200, 40, 40), "nov_IntroTextSmallDETrooper", 1);
			end
		end
		
		if injuries and #injuries > 0 then
			frame:AddText("Injuries:", Color(180, 170, 170), "nov_IntroTextSmallDETrooper", 1);
			
			for i = 1, #injuries do
				local injury = cwMedicalSystem.cwInjuryTable[injuries[i]];
				
				frame:AddText(injury.name, Color(200, 40, 40), "nov_IntroTextSmallDETrooper", 0.8);
			end
		end
		
		frame:AddText("Effects:", Color(180, 170, 170), "nov_IntroTextSmallDETrooper", 1);
		frame:AddText(effects, Color(200, 170, 170), "nov_IntroTextSmallDETrooper", 0.8);
	end

	-- A function to get a limb color.
	function Clockwork.limb:GetColor(health)
		if health > 90 then
			return Color(100, 250, 76, 255)
		elseif health <= 90 and health > 75 then
			return Color(180, 230, 76, 255)
		elseif health <= 75 and health > 50 then
			return Color(233, 225, 94, 255)
		elseif health <= 50 and health > 25 then
			return Color(233, 173, 94, 255)
		else
			return Color(222, 57, 57, 255)
		end
	end

	-- A function to get the local player's limb health.
	function Clockwork.limb:GetHealth(hitGroup, asFraction)
		return 100 - self:GetDamage(hitGroup, asFraction)
	end

	-- A function to get the local player's limb damage.
	function Clockwork.limb:GetDamage(hitGroup, asFraction)
		if (!config.Get("limb_damage_system"):Get()) then
			return 0
		end

		if (type(self.stored) == "table") then
			if (self.stored[hitGroup]) then
				if (asFraction) then
					return self.stored[hitGroup] / 100
				else
					return self.stored[hitGroup]
				end
			end
		end

		return 0
	end

	-- A function to get whether any of the local player's limbs are damaged.
	function Clockwork.limb:IsAnyDamaged()
		return !table.IsEmpty(self.stored)
	end

	netstream.Hook("ReceiveLimbDamage", function(data)
		Clockwork.limb.stored = data
		hook.Run("PlayerLimbDamageReceived")
	end)

	netstream.Hook("ResetLimbDamage", function(data)
		Clockwork.limb.stored = {}
		hook.Run("PlayerLimbDamageReset")
	end)

	netstream.Hook("TakeLimbDamage", function(data)
		local hitGroup = data.hitGroup
		local damage = data.damage or 0; -- This is nil sometimes, no idea why.

		Clockwork.limb.stored[hitGroup] = math.min((Clockwork.limb.stored[hitGroup] or 0) + damage, 100)
		hook.Run("PlayerLimbTakeDamage", hitGroup, damage)
	end)

	netstream.Hook("HealLimbDamage", function(data)
		local hitGroup = data.hitGroup
		local amount = data.amount

		if (Clockwork.limb.stored[hitGroup]) then
			Clockwork.limb.stored[hitGroup] = math.max(Clockwork.limb.stored[hitGroup] - amount, 0)

			if (Clockwork.limb.stored[hitGroup] == 100) then
				Clockwork.limb.stored[hitGroup] = nil
			end

			hook.Run("PlayerLimbDamageHealed", hitGroup, amount)
		end
	end)
end