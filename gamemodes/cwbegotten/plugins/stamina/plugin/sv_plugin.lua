--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

local playerMeta = FindMetaTable("Player");

config.Add("stam_regen_scale", 0.1, true);
config.Add("stam_drain_scale", 0.2, true);
config.Add("breathing_volume", 1, true);

cwStamina.drainScale = Clockwork.config:Get("stam_drain_scale"):Get();
cwStamina.regenScale = Clockwork.config:Get("stam_regen_scale"):Get();

function cwStamina:GetMaxStaminaPlugin(player)
	if player:GetCharacterData("isDemon", false) then
		return 1000;
	else
		local max_stamina = hook.Run("GetMaxStamina", player, 90);
		local faction = player:GetFaction();
		local subfaction = player:GetSubfaction();
		
		if player:GetCharacterData("isDemon", false) then
			return 1000;
		end
		
		if subfaction == "Watchman" then
			max_stamina = max_stamina + 10;
		elseif subfaction == "Legionary" or player:GetFaction() == "Pope Adyssa's Gatekeepers" or subfaction == "Varazdat" or subfaction == "Philimaxio" then
			max_stamina = max_stamina + 15;
		elseif subfaction == "Knights of Sol" then
			max_stamina = max_stamina + 25;
		end
		
		if cwBeliefs and player.HasBelief then
			if player:HasBelief("fighter") then
				max_stamina = max_stamina + 10;
				
				if player:HasBelief("warrior") then
					max_stamina = max_stamina + 10;
					
					if player:HasBelief("master_at_arms") then
						max_stamina = max_stamina + 15;
					end
				end
			end
			
			if player:HasBelief("man_become_beast") then
				max_stamina = max_stamina + 10;
			end
		end
		
		if Schema.RanksToBuffs[faction] then
			local rankName = Schema.Ranks[faction][player:GetCharacterData("rank", 1)];
			
			if rankName and Schema.RanksToBuffs[faction][rankName] and Schema.RanksToBuffs[faction][rankName].stamina then
				max_stamina = max_stamina + Schema.RanksToBuffs[faction][rankName].stamina;
			end
		end
		
		if cwPossession and IsValid(player.possessor) then
			max_stamina = max_stamina * 2;
		end

		return max_stamina;
	end
end;

function cwStamina:ModifyStaminaDrain(player, drainTab)
	local subfaction = player:GetSubfaction();
	
	if subfaction == "Praeventor" or subfaction == "Outrider" then
		drainTab.decrease = drainTab.decrease * 0.75;
	end
end

function playerMeta:GetMaxStamina()
	return cwStamina:GetMaxStaminaPlugin(self);
end;

function playerMeta:SetStamina(amount)
	local max_stamina = self:GetMaxStamina();
	local new_stamina = math.Clamp(amount, 0, max_stamina);
	
	self:SetCharacterData("Stamina", new_stamina);
	self:SetNWInt("Stamina", new_stamina);
	
	if new_stamina <= 0 and self:GetNetVar("Guardening", false) == true then
		self:CancelGuardening();
		self.nextStamina = CurTime() + 3;
	end
	
	hook.Run("RunModifyPlayerSpeed", self, self.cwInfoTable);
end

function playerMeta:HandleStamina(amount)
	if math.Round(amount) == 0 then return; end
	
	local max_stamina = self:GetMaxStamina();
	local stamina = self:GetCharacterData("Stamina", max_stamina);
	
	if stamina == max_stamina and amount > 0 then return end;
	
	local new_stamina = math.Clamp(stamina + amount, 0, max_stamina);
	
	self:SetCharacterData("Stamina", new_stamina);
	self:SetNWInt("Stamina", new_stamina);
	
	if new_stamina <= 0 and self:GetNetVar("Guardening", false) == true then
		self:CancelGuardening();
		self.nextStamina = CurTime() + 3;
	end
	
	hook.Run("RunModifyPlayerSpeed", self, self.cwInfoTable);
end