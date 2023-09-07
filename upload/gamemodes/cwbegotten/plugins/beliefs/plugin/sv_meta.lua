--[[
	Begotten 3
	Created by cash wednesday, gabs, DETrooper and alyousha35
--]]

local playerMeta = FindMetaTable("Player");

-- A function to add to a player's experience count.
function playerMeta:HandleXP(amount, bIgnoreModifiers)
	if (!self:GetCharacterData("experience")) then
		self:SetCharacterData("experience", 0)
	end
	
	local faith = self:GetFaith();
	local subfaction = self:GetSubfaction();
	local level = self:GetCharacterData("level", 1);
	local xp = self:GetCharacterData("experience", 0);
	local newAmount = amount;
	
	--print("Base XP: "..amount);
	
	if !bIgnoreModifiers then
		if self.opponent then
			return;
		end
		
		if amount > 0 then
			-- Belief gain bonuses.
			if self:HasBelief("gifted") then
				newAmount = newAmount + (amount * 0.25);
			elseif self:HasBelief("talented") then
				newAmount = newAmount + (amount * 0.15);
			end
			
			if self:HasBelief("aptitude_finisher") then
				newAmount = newAmount + (amount * 0.75);
			end
			
			if subfaction == "Auxiliary" or subfaction == "Rekh-khet-sa" then
				newAmount = newAmount + (amount * 0.25);
			elseif subfaction == "Inquisition" then
				newAmount = newAmount + (amount * 0.5);
			end
			
			if self.bgCharmData and self.HasCharmEquipped then
				if faith == "Faith of the Light" and self:HasCharmEquipped("skull_saint") then
					newAmount = newAmount + (amount * 0.25);
				elseif faith == "Faith of the Family" and self:HasCharmEquipped("skull_animal") then
					newAmount = newAmount + (amount * 0.25);
				elseif faith == "Faith of the Dark" and self:HasCharmEquipped("skull_demon") then
					newAmount = newAmount + (amount * 0.25);
				end
			end
			
			-- Faith gain loss because of high corruption.
			if cwCharacterNeeds then
				local corruption = self:GetNeed("corruption");
				
				if corruption > 50 then
					newAmount = math.Round(newAmount / ((corruption * 0.01) * 2));
				end
			end
		end
	end
	
	--print("Giving XP: "..newAmount);
	
	local newXP = math.Round(xp + newAmount);
	
	self:SetCharacterData("experience", newXP);
	
	if newXP >= (cwBeliefs.sacramentCosts[level + 1] or 666) then
		cwBeliefs:LevelUp(self);
	end;
end

function playerMeta:SetSacramentLevel(level)
	cwBeliefs:SetSacramentLevel(self, level);
end

function playerMeta:ResetBeliefs()
	self:SetCharacterData("beliefs", {});
	self:SetCharacterData("experience", 0);
	--self:SetCharacterData("subfaith", nil);
	self:SetSharedVar("subfaith", nil);
	self:SetSacramentLevel(1);
	self:GetCharacter().subfaith = nil;

	local max_poise = self:GetMaxPoise();
	local poise = self:GetNWInt("meleeStamina");
	local max_stamina = self:GetMaxStamina();
	local max_stability = self:GetMaxStability();
	local stability = self:GetNWInt("stability");
	local stamina = self:GetNWInt("Stamina", 100);
	
	self:SetMaxHealth(self:GetMaxHealth());
	self:SetLocalVar("maxStability", max_stability);
	self:SetLocalVar("maxMeleeStamina", max_poise);
	self:SetNWInt("stability", math.min(stability, max_stability));
	self:SetCharacterData("stability", self:GetNWInt("stability"));
	self:SetNWInt("meleeStamina", math.min(poise, max_poise));
	self:SetLocalVar("Max_Stamina", max_stamina);
	self:SetCharacterData("Max_Stamina", max_stamina);
	self:SetNWInt("Stamina", math.min(stamina, max_stamina));
	self:SetCharacterData("Stamina", math.min(stamina, max_stamina));
	cwBeliefs:ResetBeliefSharedVars(self);
	
	hook.Run("RunModifyPlayerSpeed", self, self.cwInfoTable, true)
	
	self:SaveCharacter();
end

-- A function to get if a player has a belief or not.
function playerMeta:HasBelief(uniqueID)
	if (!uniqueID) then
		return;
	end;
	
	if cwPossession and IsValid(self.possessor) then
		if uniqueID == "parrying" or uniqueID == "halfsword_sway" or uniqueID == "deflection" or uniqueID == "strength" then
			return true;
		end
	end
	
	local beliefs = self:GetCharacterData("beliefs", {});
	
	if (beliefs[uniqueID]) then
		return true;
	end
	
	return false;
end

function playerMeta:Cloak()
	local activeWeapon = self:GetActiveWeapon();
	
	if IsValid(activeWeapon) then
		activeWeapon:SetNoDraw(true);
	end
	
	if !self.cloaked then
		Clockwork.chatBox:AddInTargetRadius(self, "me", "'s very flesh begins to fade until they are completely invisible!", self:GetPos(), Clockwork.config:Get("talk_radius"):Get());
	end
	
	self:SetRenderMode(RENDERMODE_TRANSALPHA);
	self:SetColor(Color(255, 255, 255, 0));
	self.cloaked = true;
	self:SetNWBool("Cloaked", true);
end

function playerMeta:Uncloak()
	local activeWeapon = self:GetActiveWeapon();
	
	if IsValid(activeWeapon) then
		activeWeapon:SetNoDraw(false);
	end
	
	if self.cloaked then
		Clockwork.chatBox:AddInTargetRadius(self, "me", "begins to materialize and become visible!", self:GetPos(), Clockwork.config:Get("talk_radius"):Get());
	end

	self:SetRenderMode(RENDERMODE_TRANSALPHA);
	self:SetColor(Color(255, 255, 255, 255));
	self.cloaked = false;
	self:SetNWBool("Cloaked", false);
end