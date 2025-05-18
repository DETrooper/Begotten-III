local PLUGIN = PLUGIN

function PLUGIN:Move(player, cmovedata)
    if (player:Alive() and player:GetMoveType() != MOVETYPE_NOCLIP) then
		if player:IsOnGround() then
			if bit.band(cmovedata:GetButtons(), IN_JUMP) != 0 and bit.band(cmovedata:GetOldButtons(), IN_JUMP) == 0 then
				local jumpPower = player.cwJumpPower or player:GetJumpPower()
				
				if not (jumpPower <= 10) then
					local jumpCost = 15;
					
					if player.GetCharmEquipped and player:GetCharmEquipped("boot_contortionist") then
						jumpCost = math.Round(jumpCost * 0.333);
					end
					
					local stamina = player:GetCharacterData("Stamina") or player:GetNWInt("Stamina", 100)

					if stamina >= jumpCost then
						if CLIENT then return end

						player:SetCharacterData("Stamina", math.Clamp(stamina - jumpCost, 0, cwStamina:GetMaxStaminaPlugin(player)))
						player:SetNWInt("Stamina", player:GetCharacterData("Stamina"));
					else
						cmovedata:SetButtons(bit.band(cmovedata:GetButtons(), bit.bnot(IN_JUMP)))
					end
				end
			end
		end
	end;
end