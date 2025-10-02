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
function cwStamina:PostPlayerCharacterInitialized(player)
	local max_stamina = player:GetMaxStamina();

	player:SetCharacterData("Max_Stamina", max_stamina);
	player:SetLocalVar("Max_Stamina", max_stamina);
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
	local plyTab = player:GetTable();
	local stamina = math.floor(player:GetCharacterData("Stamina") or player:GetMaxStamina());
	
	if !plyTab.lastStamina or plyTab.lastStamina ~= stamina then
		player:SetNWInt("Stamina", stamina);
		
		plyTab.lastStamina = stamina;
	end
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
function cwStamina:PlayerThink(player, curTime, infoTable, alive, initialized, plyTab)
	--[[if (!self.regenScale or !self.regenScaleCooldown or self.regenScaleCooldown < curTime) then
		self.regenScaleCooldown = curTime + 1;
		self.regenScale = Clockwork.config:Get("stam_regen_scale"):Get();
	end;]]--
	
	--[[if (!self.drainScale or !self.drainScaleCooldown or self.drainScaleCooldown < curTime) then
		self.drainScaleCooldown = curTime + 1;
		self.drainScale = Clockwork.config:Get("stam_drain_scale"):Get();
	end;]]--
	
	if (!plyTab.nextStamina or curTime > plyTab.nextStamina) then
		plyTab.nextStamina = curTime + 0.5;

		if initialized and alive then
			if (Clockwork.player:HasFlags(player, "4")) then
				player:SetCharacterData("Stamina", player:GetMaxStamina());
				--player:SetNWInt("meleeStamina", player:GetMaxPoise());
				player:SetCharacterData("stability", player:GetMaxStability());
				player:SetHealth(player:GetMaxHealth());
				
				return;
			end;
		
			if (player:GetMoveType() == MOVETYPE_NOCLIP) then
				player:HandleStamina(1);
				
				return;
			end;
			
			local onGround = player:IsOnGround();
			
			if (!onGround and infoTable.waterLevel < 1) then
				if (!player:IsRagdolled()) then
					return;
				end
			end;
			
			local regeneration = 0;
			
			if (!Clockwork.player:HasFlags(player, "E")) then
				if (infoTable.isRunning) or (!onGround and infoTable.waterLevel >= 1 and !plyTab.drownedKingActive) then
					local drainTab = {decrease = -2};

					if (hook.Run("PlayerShouldStaminaDrain", player) != false) then
						hook.Run("ModifyStaminaDrain", player, drainTab);
						
						player:HandleStamina(drainTab.decrease);
						
						return;
					else
						hook.Run("RunModifyPlayerSpeed", player, infoTable, true);
					end;
				else
					regeneration = 3;
				end;
			else
				player:HandleStamina(100);
				
				return;
			end
			
			if regeneration > 0 and (player:GetNetVar("Guardening") or (plyTab.blockStaminaRegen and curTime <= plyTab.blockStaminaRegen)) then
				return;
			end

			if plyTab.banners then
				local playerFaction = player:GetFaction();
				
				for k, v in pairs(plyTab.banners) do
					if v == "glazic" then
						if playerFaction == "Gatekeeper" or playerFaction == "Holy Hierarchy" or playerFaction == "Hillkeeper" or playerFaction == "Pope Adyssa's Gatekeepers" or playerFaction == "Militant Orders of the Villa" or playerFaction == "Aristocracy Of Light" then
							regeneration = 3.75;

							break;
						end
					end
				end
			end
			
			if plyTab.perseveranceActive then
				regeneration = regeneration * 2;
			end;
			
			if player:HasBelief("prowess_finisher") then
				regeneration = regeneration * 1.35;
			end;
		
			if (regeneration > 0 and hook.Run("PlayerShouldStaminaRegenerate", player) != false) then
				local max_stamina = player:GetMaxStamina();
				local stamina = player:GetCharacterData("Stamina", 100);
				
				player:HandleStamina(regeneration);
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

function cwStamina:PlayerExitedDuel(player)
	player:SetStamina(player:GetMaxStamina());
end