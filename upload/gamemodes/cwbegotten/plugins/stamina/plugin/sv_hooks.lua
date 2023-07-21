--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

-- Called when a player's character data should be saved.
function cwStamina:PlayerSaveCharacterData(player, data)
	if (data["Max_Stamina"]) then
		data["Max_Stamina"] = data["Max_Stamina"];
	end

	if (data["Stamina"]) then
		data["Stamina"] = math.Round(data["Stamina"]);
	end;
end;

-- Called when a player's character data should be restored.
function cwStamina:PlayerRestoreCharacterData(player, data)
	if (!data["Max_Stamina"]) then
		data["Max_Stamina"] = player:GetMaxStamina();
	end;

	if (!data["Stamina"]) then
		data["Stamina"] = player:GetMaxStamina();
	end;
end;

-- Called just after a player spawns.
function cwStamina:PostPlayerSpawn(player, lightSpawn, changeClass, firstSpawn)
	if (!lightSpawn) then
		player:SetCharacterData("Max_Stamina", player:GetMaxStamina());
		player:SetNetVar("Max_Stamina", player:GetCharacterData("Max_Stamina"));
		player:SetCharacterData("Stamina", player:GetMaxStamina());
		player:SetNetVar("Stamina", player:GetCharacterData("Stamina"));
	end;
end;

-- Called when a player attempts to throw a punch.
--[[function cwStamina:PlayerCanThrowPunch(player)
	if (player:GetCharacterData("Stamina") <= 10) then
		return false;
	end;
end;]]--

-- Called when a player throws a punch.
--[[function cwStamina:PlayerPunchThrown(player)
	local attribute = Clockwork.attributes:Fraction(player, ATB_STAMINA, 1.5, 0.25);
	local decrease = 5 / (1 + attribute);
	
	player:SetCharacterData("Stamina", math.Clamp(player:GetCharacterData("Stamina") - decrease, 0, player:GetMaxStamina()));
end;]]--

-- Called when a player's shared variables should be set.
function cwStamina:OnePlayerHalfSecond(player, curTime)
	player:SetNetVar("Stamina", math.floor(player:GetCharacterData("Stamina")));
end;

-- Called when a player's stamina should regenerate.
function cwStamina:PlayerShouldStaminaRegenerate(player)
	--return true;
end;

-- Called when a player's stamina should drain.
function cwStamina:PlayerShouldStaminaDrain(player)
	--return true;
end;

-- Called at an interval while a player is connected.
function cwStamina:PlayerThink(player, curTime, infoTable, alive, initialized)
	--[[if (!self.regenScale or !self.regenScaleCooldown or self.regenScaleCooldown < curTime) then
		self.regenScaleCooldown = curTime + 1;
		self.regenScale = Clockwork.config:Get("stam_regen_scale"):Get();
	end;]]--
	
	--[[if (!self.drainScale or !self.drainScaleCooldown or self.drainScaleCooldown < curTime) then
		self.drainScaleCooldown = curTime + 1;
		self.drainScale = Clockwork.config:Get("stam_drain_scale"):Get();
	end;]]--
	
	if (!player.nextStamina or curTime > player.nextStamina) then
		player.nextStamina = curTime + 0.4;
		
		if (Clockwork.player:HasFlags(player, "4")) then
			player:SetCharacterData("Stamina", player:GetMaxStamina());
			player:SetNWInt("meleeStamina", player:GetMaxPoise());
			player:SetCharacterData("stability", player:GetMaxStability());
			player:SetHealth(player:GetMaxHealth());
			
			return;
		end;
		
		if initialized and alive then
			if (player:GetMoveType() == MOVETYPE_NOCLIP) then
				local max_stamina = player:GetMaxStamina();
				
				player:SetCharacterData("Stamina", math.Clamp(player:GetCharacterData("Stamina", max_stamina) + 1, 0, max_stamina));
				
				return;
			end;
			
			if (!player:IsOnGround()) then
				if (!player:IsRagdolled()) then
					return;
				end
			end;
			
			--local regenScale = self.regenScale;
			--local drainScale = self.drainScale;
			--local attribute = 0.25;
			local regeneration = 0;
			
			if (!Clockwork.player:HasFlags(player, "E")) then
				if (infoTable.isRunning) then
					--[[local maxHealth = player:GetMaxHealth();
					local healthScale = (drainScale * (math.Clamp(player:Health(), maxHealth * 0.1, maxHealth) / maxHealth));
					local decrease = (drainScale + (drainScale - healthScale)) - ((drainScale * 0.5) * attribute);]]--
					
					local decrease = 1;
					
					hook.Run("RunModifyPlayerSpeed", player, infoTable);
					
					--if (!player:IsNoClipping() and player:IsOnGround()) then
						if (hook.Run("PlayerShouldStaminaDrain", player) != false) then
							player:SetCharacterData("Stamina", math.Clamp(player:GetCharacterData("Stamina") - decrease, 0, player:GetMaxStamina()));
							return;
						end;
					--end;
				--[[elseif (player:GetVelocity():Length() <= 0) then
					regeneration = (regenScale + attribute) * 1.5;]]--
				else
					regeneration = 1;
				end;
			else
				regeneration = 100;
			end
			
			if player.perseveranceActive then
				regeneration = regeneration * 2;
			end;
		
			if (regeneration > 0 and hook.Run("PlayerShouldStaminaRegenerate", player) != false) then
				local max_stamina = player:GetMaxStamina();
				local stamina = player:GetCharacterData("Stamina", 100);

				if isnumber(stamina) and stamina < max_stamina then
					player:SetCharacterData("Stamina", math.Clamp(stamina + regeneration, 0, max_stamina));
				
					--hook.Run("RunModifyPlayerSpeed", player, infoTable);
					cwStamina:ModifyPlayerSpeed(player, infoTable, stamina, max_stamina);
				end
			end;
		end;
	end;
end;

function cwStamina:ModifyPlayerSpeed(player, infoTable, action, stamina, max_stamina)
	if (player:KeyDown(IN_BACK)) then
		infoTable.runSpeed = infoTable.walkSpeed;
	else
		local newRunSpeed = infoTable.runSpeed * 2;
		local diffRunSpeed = newRunSpeed - infoTable.walkSpeed;
		local maxRunSpeed = infoTable.runSpeed;
		
		infoTable.runSpeed = math.Clamp(newRunSpeed - (diffRunSpeed - ((diffRunSpeed / (max_stamina or player:GetMaxStamina())) * (stamina or player:GetCharacterData("Stamina", 100)))), infoTable.walkSpeed, maxRunSpeed);
	end
end
