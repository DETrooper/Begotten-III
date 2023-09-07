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
		local max_stamina = hook.Run("GetMaxStamina", player, 100);
		local subfaction = player:GetSubfaction();
		
		if subfaction == "Praeventor" then
			max_stamina = max_stamina + 25;
		end

		return max_stamina;
	end
end;

function playerMeta:GetMaxStamina()
	return cwStamina:GetMaxStaminaPlugin(self);
end;

function playerMeta:HandleStamina(amount)
	local max_stamina = self:GetMaxStamina();
	local new_stamina = math.Clamp(self:GetCharacterData("Stamina", max_stamina) + amount, 0, max_stamina);
	
	self:SetCharacterData("Stamina", new_stamina);
	self:SetNWInt("Stamina", new_stamina);
end

netstream.Hook("PlayerJump", function(player)
	if (player:Alive() and player:GetMoveType() != MOVETYPE_NOCLIP) then
		if not (player.cwJumpPower <= 10) then
			player:SetCharacterData("Stamina", math.Clamp((player:GetCharacterData("Stamina") or player:GetMaxStamina()) - 15, 0, cwStamina:GetMaxStaminaPlugin(player)))
			player:SetNWInt("Stamina", player:GetCharacterData("Stamina"));
		end
	end;
end);