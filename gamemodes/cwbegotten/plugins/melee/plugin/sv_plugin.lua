--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

-- Freeze code from SciFi Weapons.
function cwMelee:DoFreezeEffect(target, attacker, duration)
	if (target:GetNWBool("bliz_frozen")) then return end

	if (target:IsNPC() or target:IsPlayer()) then
		target:SetNWBool( "bliz_frozen", true )
		
		local dps = ents.Create( "dmg_freezing" )
		dps:SetPos( target:EyePos() + Vector( 0, 0, 1024 ) )
		dps:SetOwner( attacker )
		dps:SetParent( target )
		
		target.freezeEnt = dps;

		if (duration) then
			dps.LifeTime = duration
		end
		
		dps:Spawn()
		dps:Activate()
		return
	end
	
	return
end

local playerMeta = FindMetaTable("Player");

-- A function to handle a player's stability value.
function cwMelee:HandleStability(player, amount, cooldown)
	if (!amount or !IsValid(player) or !player:IsPlayer()) then
		return;
	end;

	--[[if (!cooldown or !isnumber(cooldown)) then
		cooldown = 10;
	end;

	player.stabilityCooldown = CurTime() + cooldown;]]--
	player:SetCharacterData("stability", math.Clamp(player:GetCharacterData("stability", player:GetMaxStability()) + amount, 0, player:GetMaxStability()));
	player:SetNWInt(player:GetCharacterData("stability"));
end;

--function playerMeta:TakePoise(amount)
function playerMeta:TakeStamina(amount)
	if (Clockwork.player:HasFlags(self, "E")) then
		return;
	end

	local newAmount = amount;
	local leftArm = Clockwork.limb:GetHealth(self, HITGROUP_LEFTARM, false)
	local rightArm = Clockwork.limb:GetHealth(self, HITGROUP_RIGHTARM, false)
	local armHealth = math.min(leftArm, rightArm)
	local max_stamina = self:GetMaxStamina() or 100;
	
	if (armHealth <= 75) then
		if armHealth > 50 then
			newAmount = math.floor(newAmount * 1.2);
		elseif armHealth <= 50 and armHealth > 25 then
			newAmount = math.floor(newAmount * 1.5);
		elseif armHealth <= 25 and armHealth > 10 then
			newAmount = math.floor(newAmount * 2);
		else
			newAmount = math.floor(newAmount * 3);
		end
	end
	
	if newAmount > 0 then
		newAmount = 0 - newAmount;
	end

	--self:SetNWInt("meleeStamina", math.Clamp(self:GetNWInt("meleeStamina", 90) + newAmount, 0, self:GetMaxPoise() or 90));
	self:HandleStamina(newAmount);
	
	--[[if self:GetNWInt("meleeStamina", 90) <= 0 and self:GetNetVar("Guardening", false) == true then
		self:CancelGuardening();
		self.nextStas = CurTime() + 3;
	end]]--
end

--function playerMeta:GivePoise(amount)
function playerMeta:GiveStamina(amount)
	local max_stamina = self:GetMaxStamina() or 100;
	
	--self:SetNWInt("meleeStamina", math.Clamp(self:GetNWInt("meleeStamina", 90) + amount, 0, self:GetMaxPoise() or 90));
	self:HandleStamina(math.Clamp(self:GetNWInt("Stamina", max_stamina) + amount, 0, max_stamina));
end

-- A function to take from a player's stability.
function playerMeta:TakeStability(amount, cooldown, bNoMe)
	--printp("Taking stability - Initial Amount: "..amount);
	
	if (Clockwork.player:HasFlags(self, "E") or !self:Alive() or self:IsRagdolled() or self:GetNWBool("bliz_frozen")) then
		return;
	end

	if not self:IsInGodMode() and (!cwPowerArmor or (cwPowerArmor and --[[!self:IsWearingPowerArmor()]] !self.wearingPowerArmor)) then
		if self:GetNetVar("tied") ~= 0 then
			self.nextStability = CurTime() + 3;
			
			cwMelee:HandleStability(self, -100, cooldown);
			
			if !self:IsRagdolled() then
				cwMelee:PlayerStabilityFallover(self, 30);
			end
			
			return;
		end
		
		if self.GetCharmEquipped then
			if self:GetFaith() == "Faith of the Family" and self:GetCharmEquipped("effigy_earthing") then
				amount = math.floor(amount * 0.75);
				--printp("Earthing Effigy Reduction: "..amount);
			end

			if(self:GetCharmEquipped("ring_protection_gold")) then amount = math.floor(amount * 0.80)
			elseif(self:GetCharmEquipped("ring_protection_silver")) then amount = math.floor(amount * 0.85)
			elseif(self:GetCharmEquipped("ring_protection_bronze")) then amount = math.floor(amount * 0.92)
			end

		end
		
		if cwBeliefs and self:HasBelief("fortitude_finisher") then
			amount = math.floor(amount * 0.75);
		end
	
		local armorClass;
		local armorTable = self:GetClothesEquipped();
		
		if armorTable then
			armorClass = armorTable.weightclass;

			if armorTable.stabilityScale then
				amount = math.floor(amount * armorTable.stabilityScale);
			elseif armorClass then
				if armorClass == "Heavy" then
					amount = math.floor(amount * 0.6);
				elseif armorClass == "Medium" then
					amount = math.floor(amount * 0.7);
				elseif armorClass == "Light" then
					amount = math.floor(amount * 0.75);
				end
			end
		end
		
		local leftLeg = Clockwork.limb:GetHealth(self, HITGROUP_LEFTLEG, false)
		local rightLeg = Clockwork.limb:GetHealth(self, HITGROUP_RIGHTLEG, false)
		local legDamage = math.min(leftLeg, rightLeg)

		if (legDamage <= 90) then
			if legDamage > 75 then
				amount = math.floor(amount * 1.2);
				--printp("Leg Damage Modifier: "..amount);
			elseif legDamage <= 75 and legDamage > 50 then
				amount = math.floor(amount * 1.5);
				--printp("Leg Damage Modifier: "..amount);
			elseif legDamage <= 50 and legDamage > 25 then
				amount = math.floor(amount * 2);
				--printp("Leg Damage Modifier: "..amount);
			elseif legDamage <= 25 and legDamage > 10 then
				amount = math.floor(amount * 3);
				--printp("Leg Damage Modifier: "..amount);
			else
				amount = math.floor(amount * 4);
				--printp("Leg Damage Modifier: "..amount);
			end
		end
		
		if self.nobleStatureActive then
			if self:GetVelocity():Length() == 0 then
				amount = math.floor(amount / 2);
			end
		end
		
		if cwPossession and IsValid(self.possessor) then
			amount = math.floor(amount / 4);
		end
		
		cwMelee:HandleStability(self, -math.abs(amount), cooldown);
		self.nextStability = CurTime() + 3;
		
		if (self:GetCharacterData("stability", self:GetMaxStability()) <= 0 and !self:IsRagdolled() and !self:GetNWBool("bliz_frozen")) then
			local stabilityDelay = 2.5;
			local falloverTime = 3;

			if armorClass then
				if (armorClass == "Medium") then
					stabilityDelay = 5;
					falloverTime = 4;
				elseif (armorClass == "Heavy") then
					stabilityDelay = 7.5;
					falloverTime = 6;
				end;
			end;

			cwMelee:PlayerStabilityFallover(self, falloverTime, nil, bNoMe);
		end;
	end
end;

-- A function to give player's stability.
function playerMeta:GiveStability(amount, cooldown)
	cwMelee:HandleStability(self, math.abs(amount), cooldown);
end;

function playerMeta:AddFreeze(amount, attacker)
	local model = self:GetModel();
	
	if IsValid(attacker) and (!cwPowerArmor or (cwPowerArmor and --[[!self:IsWearingPowerArmor()]] !self.wearingPowerArmor)) and !self.cloakBurningActive then
		local freeze = self:GetNetVar("freeze", 0);
		
		self:SetLocalVar("freeze", math.Clamp(math.Round(freeze + amount), 0, 100));
		
		if self:GetNetVar("freeze") >= 100 then
			cwMelee:DoFreezeEffect(self, attacker, 15);
		end
		
		hook.Run("RunModifyPlayerSpeed", self, self.cwInfoTable, true);
	end
end

function playerMeta:TakeFreeze(amount)
	local freeze = self:GetNetVar("freeze", 0);
	
	self:SetLocalVar("freeze", math.Clamp(math.Round(freeze - amount), 0, 100));
	
	hook.Run("RunModifyPlayerSpeed", self, self.cwInfoTable, true);
end

-- A function to get a player's maximum poise.
--[[function playerMeta:GetMaxPoise()
	local max_poise = 90;
	local subfaction = self:GetSubfaction();
	
	if self:GetCharacterData("isDemon", false) then
		max_poise = 1000
		
		return max_poise;
	end
	
	if cwBeliefs and self.HasBelief then
		if self:HasBelief("fighter") then
			max_poise = max_poise + 10;
			
			if self:HasBelief("warrior") then
				max_poise = max_poise + 10;
				
				if self:HasBelief("master_at_arms") then
					max_poise = max_poise + 15;
				end
			end
		end
		
		if self:HasBelief("man_become_beast") then
			max_poise = max_poise + 10;
		end
	end
	
	if subfaction == "Legionary" then
		max_poise = max_poise + 15;
	elseif subfaction == "Knights of Sol" then
		max_poise = max_poise + 25;
	end
	
	if cwPossession and IsValid(self.possessor) then
		max_poise = max_poise * 2;
	end
	
	return max_poise;
end;]]--

-- A function to get a player's maximum stability.
function playerMeta:GetMaxStability()
	local max_stability = 100;
	local subfaction = self:GetSubfaction();
	
	if self:GetCharacterData("isDemon", false) then
		max_stability = 1000
		
		return max_stability;
	end
	
	--[[local boost = self:GetNetVar("loyaltypoints", 0)
	
	if boost > 0 then
		max_stability = tonumber(max_stability + boost);
	end]]--
	
	if subfaction == "Knights of Sol" or subfaction == "House Herrera" or subfaction == "House Caelvora" then
		max_stability = max_stability + 25;
	elseif subfaction == "Philimaxio" then
		max_stability = max_stability + 15;
	end
	
	if cwBeliefs and self.HasBelief then
		if self:HasBelief("litheness_finisher") then
			max_stability = max_stability + 15;
		end
		
		if self:HasBelief("enduring_bear") then
			max_stability = max_stability + 25;
		end
	end
	
	if cwMedicalSystem then
		local symptoms = self:GetNetVar("symptoms", {});
		
		if table.HasValue(symptoms, "Fatigue") then
			max_stability = max_stability - 20;
		end
	end
	
	return max_stability;
end;

function playerMeta:GetArmorClass()
	local armorTable = self:GetClothesEquipped();
	
	if armorTable then
		if (armorTable.weightclass) then
			return armorTable.weightclass;
		end;
	end
end;

function playerMeta:Disorient(blurAmount)
	netstream.Start(self, "Disorient", blurAmount);
end;