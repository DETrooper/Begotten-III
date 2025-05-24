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
			newAmount = newAmount * config.Get("xp_modifier"):Get();
		
			-- Belief gain bonuses.
			if self:HasBelief("gifted") then
				newAmount = newAmount + (amount * 0.25);
			elseif self:HasBelief("talented") then
				newAmount = newAmount + (amount * 0.15);
			end
			
			if self:HasBelief("aptitude_finisher") then
				newAmount = newAmount + (amount * 0.75);
			end
			
			if subfaction == "Auxiliary" or subfaction == "Rekh-khet-sa" or subfaction == "Servus" then
				newAmount = newAmount + (amount * 0.25);
			elseif subfaction == "Inquisition" then
				newAmount = newAmount + (amount * 0.5);
			elseif subfaction == "Low Ministry" then
				newAmount = newAmount + (amount * 0.15);
			end
			
			if self:HasBelief("sol_orthodoxy") then
				if cwCharacterNeeds then
					local hunger = self:GetNeed("hunger");
					local thirst = self:GetNeed("thirst");
					
					if hunger >= 40 or thirst >= 40 then
						if hunger >= 40 and thirst >= 40 then
							newAmount = newAmount + (amount * 0.3);
						else
							newAmount = newAmount + (amount * 0.15);
						end
					end
				end
			end
			
			if self.GetCharmEquipped then
				if faith == "Faith of the Light" and self:GetCharmEquipped("skull_saint") then
					newAmount = newAmount + (amount * 0.25);
				elseif faith == "Faith of the Family" and self:GetCharmEquipped("skull_animal") then
					newAmount = newAmount + (amount * 0.25);
				elseif faith == "Faith of the Dark" and self:GetCharmEquipped("skull_demon") then
					newAmount = newAmount + (amount * 0.25);
				end
				
				if self:GetCharmEquipped("holy_sigils") or self:GetCharmEquipped("codex_solis") then
					newAmount = newAmount + (amount * 0.15);
				end
			end
			
			-- Faith gain loss because of high corruption.
			if cwCharacterNeeds then
				local corruption = self:GetNeed("corruption");
				
				--[[if corruption > 50 then
					newAmount = math.Round(newAmount / ((corruption * 0.01) * 2));
				end]]--
				
				if corruption > 1 then
					newAmount = math.Round(Lerp(corruption * 0.01, newAmount, 0));
				end
			end
		end
	end
	
	--print("Giving XP: "..newAmount);
	
	local newXP = math.max(0, math.Round(xp + newAmount));
	
	self:SetCharacterData("experience", newXP);
	self:SetLocalVar("experience", newXP);
	
	if newXP >= (cwBeliefs.sacramentCosts[level + 1] or 666) then
		cwBeliefs:LevelUp(self);
	end;
end

function playerMeta:SetSacramentLevel(level)
	cwBeliefs:SetSacramentLevel(self, level);
end

function playerMeta:ResetBeliefs()
	self:SetCharacterData("beliefs", {});
	--self:SetCharacterData("subfaith", nil);
	self:SetNetVar("subfaith", nil);
	self.cwCharacter.subfaith = nil;
	self:SetSacramentLevel(1);

	--local max_poise = self:GetMaxPoise();
	--local poise = self:GetNWInt("meleeStamina");
	local max_stamina = self:GetMaxStamina();
	local max_stability = self:GetMaxStability();
	local stability = self:GetNWInt("stability");
	local stamina = self:GetNWInt("Stamina", 100);
	
	self:SetMaxHealth(self:GetMaxHealth());
	self:SetLocalVar("maxStability", max_stability);
	--self:SetLocalVar("maxMeleeStamina", max_poise);
	self:SetNWInt("stability", math.min(stability, max_stability));
	self:SetCharacterData("stability", self:GetNWInt("stability"));
	--self:SetNWInt("meleeStamina", math.min(poise, max_poise));
	self:SetLocalVar("Max_Stamina", max_stamina);
	self:SetCharacterData("Max_Stamina", max_stamina);
	self:SetNWInt("Stamina", math.min(stamina, max_stamina));
	self:SetCharacterData("Stamina", math.min(stamina, max_stamina));
	self:NetworkBeliefs();
	
	hook.Run("RunModifyPlayerSpeed", self, self.cwInfoTable, true)
	
	self:SaveCharacter();
end

-- A function to get if a player has a belief or not.
function playerMeta:HasBelief(uniqueID, bHasAny)
	if (!uniqueID) then
		return;
	end;
	
	if hook.Run("PlayerHasBelief", self, uniqueID) then
		return true;
	end
	
	local beliefs = self:GetCharacterData("beliefs", {});
	
	if istable(uniqueID) then
		if bHasAny then
			for i, v in ipairs(uniqueID) do
				if beliefs[v] then
					return true;
				end
			end
		else
			for i, v in ipairs(uniqueID) do
				if !beliefs[v] then
					return false;
				end
			end
			
			return true;
		end
	else
		if (beliefs[uniqueID]) then
			return true
		end
	end
	
	return false;
end

function playerMeta:Cloak()
	local activeWeapon = self:GetActiveWeapon();
	
	if activeWeapon:IsValid() then
		activeWeapon:SetNoDraw(true);
	end
	
	if !self.cloaked then
		Clockwork.chatBox:AddInTargetRadius(self, "me", "'s very flesh begins to fade until they are completely invisible!", self:GetPos(), Clockwork.config:Get("talk_radius"):Get());
	end
	
	self:SetRenderMode(RENDERMODE_TRANSALPHA);
	self:SetColor(Color(255, 255, 255, 0));
	self.cloaked = true;
	self:SetNW2Bool("Cloaked", true);
end

function playerMeta:Uncloak()
	local activeWeapon = self:GetActiveWeapon();
	
	if activeWeapon:IsValid() then
		activeWeapon:SetNoDraw(false);
	end
	
	if self.cloaked then
		Clockwork.chatBox:AddInTargetRadius(self, "me", "begins to materialize and become visible!", self:GetPos(), Clockwork.config:Get("talk_radius"):Get());
	end

	self:SetRenderMode(RENDERMODE_TRANSALPHA);
	self:SetColor(Color(255, 255, 255, 255));
	self.cloaked = false;
	self:SetNW2Bool("Cloaked", false);
end

function playerMeta:NetworkBeliefs()
	cwBeliefs:ResetBeliefSharedVars(self);

	netstream.Start(self, "BeliefSync", self:GetCharacterData("beliefs", {}));
end