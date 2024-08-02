--[[
	Begotten III: Jesus Wept
--]]

-- Todo: Detect character changing, disconnects, players leaving the dueling arena somehow (maybe teleported by admin by mistake?).

local map = game.GetMap() == "rp_begotten3" or game.GetMap() == "rp_begotten_redux" or game.GetMap() == "rp_scraptown";

-- Called when Clockwork has loaded all of the entities.
function cwDueling:ClockworkInitPostEntity()
	if (map) and self.statues then
		for k, v in pairs(self.statues) do
			local statueEnt = ents.Create("cw_duelstatue");
			
			statueEnt:SetPos(self.statues[k]["spawnPosition"]);
			statueEnt:SetAngles(self.statues[k]["spawnAngles"]);
			statueEnt:Spawn();
		end
	end;
end

-- Called when a player dies.
function cwDueling:PlayerDeath(player, inflictor, attacker, damageInfo)
	if (!map) then
		return;
	end;
	
	if self:PlayerIsDueling(player) then
		--[[if IsValid(attacker) and attacker:IsPlayer() then
			if self:PlayersAreDueling(player, attacker) then
				-- Attacker is winner, player (dead person) is loser.
				self:DuelCompleted(attacker, player)
			end
		else]]--
			local winner = player.opponent;
			
			if winner then
				self:DuelCompleted(winner, player);
			else
				self:DuelAborted(player);
			end
		--end
		
		local ragdoll = player:GetRagdollEntity()

		if (ragdoll) then		
			timer.Simple(5, function()
				if IsValid(ragdoll) then
					ragdoll:Remove();
				end
			end);
		end
	elseif player.opponent then
		local ragdoll = player:GetRagdollEntity()

		if (ragdoll) then		
			timer.Simple(0.1, function()
				if IsValid(ragdoll) then
					ragdoll:Remove();
				end
			end);
		end
	end
end;

function cwDueling:PlayerDisconnected(player)
	if self:PlayerIsDueling(player) then
		if IsValid(player.opponent) and (!player.duelData or !player.duelData.duelStatue) then
			--self:DuelAborted(player.opponent, player);
			self:DuelCompleted(player.opponent, player);
		end
	elseif self:PlayerIsInMatchmaking(player) then
		self:PlayerExitsMatchmaking(player);
	end
end;

-- Called when a player wants to fallover.
function cwDueling:PlayerCanFallover(player)
	if player.opponent or self:PlayerIsInMatchmaking(player) then
		return false;
	end
end

function cwDueling:PlayerCanTakeLimbDamage(player, hitGroup)
	--[[if player.opponent then
		return false;
	end]]--
end;

function cwDueling:PlayerCanSwitchCharacter(player, character)
	if --[[self:PlayerIsDueling(player)]] player.opponent or self:PlayerIsInMatchmaking(player) then
		return false
	end
end;

-- Called when a player attempts to use an item.
function cwDueling:PlayerCanUseItem(player, itemTable, noMessage)
	if self:PlayerIsInMatchmaking(player) then
		Schema:EasyText(player, "firebrick", "You cannot use items while matchmaking for a duel!");
		return false;
	--elseif self:PlayerIsDueling(player) then
	elseif player.opponent then
		Schema:EasyText(player, "firebrick", "You cannot use items while in a duel!");
		return false;
	end;
end;

-- Called when a player attempts to drop an item.
function cwDueling:PlayerCanDropItem(player, itemTable, noMessage)
	if self:PlayerIsInMatchmaking(player) then
		Schema:EasyText(player, "firebrick", "You cannot drop items while matchmaking for a duel!");
		return false;
	--elseif self:PlayerIsDueling(player) then
	elseif player.opponent then
		Schema:EasyText(player, "firebrick", "You cannot drop items while in a duel!");
		return false;
	end;
end;

function cwDueling:PlayerUse(player, entity)
	if player.opponent then
		return false;
	end
end;

function cwDueling:PlayerEnteredDuel(player, arena, spawnPos, spawnAngles)
	Clockwork.datastream:Start(player, "SetPlayerDueling", true);
	Clockwork.limb:CacheLimbs(player, true);
	
	local duelData = {};
	
	duelData.cachedPos = player:GetPos();
	duelData.cachedAngles = player:GetAngles();
	duelData.cachedHP = player:Health();
	
	player.duelData = duelData;
	
	player:Spawn();	
	player:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255), 5, 0);
	player:SetPos(spawnPos);
	player:SetEyeAngles(spawnAngles);
	player:SetHealth(player:GetMaxHealth());

	if player:GetLocalVar("Hatred") then
		player:SetLocalVar("Hatred", 0);
	end
	
	-- Start battle music after players have faded in.
	timer.Simple(5, function()
		Clockwork.datastream:Start(player, "StartBattleMusicNoLimit");
	end);
end

function cwDueling:PlayerExitedDuel(player)
	player:Freeze(false);
	player:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255 ), 5, 0);
	player:SetNWInt("freeze", 0);
	
	local duelData = player.duelData;

	if duelData then
		player:Spawn();
		player:SetPos(duelData.cachedPos + Vector(0, 0, 8));
		player:SetEyeAngles(duelData.cachedAngles);
		
		Clockwork.limb:RestoreLimbsFromCache(player);
		
		timer.Simple(0.1, function()
			if IsValid(player) then
				player:SetPos(duelData.cachedPos + Vector(0, 0, 8));
				player:SetEyeAngles(duelData.cachedAngles);
			end
		end);
		
		player:SetHealth(player.duelData.cachedHP);
	end
	
	if player.distortedRingFiredDuel then
		player.distortedRingFiredDuel = nil;
	end
	
	if player:GetCharacterData("Hatred") then
		player:SetLocalVar("Hatred", player:GetCharacterData("Hatred"));
	end
	
	player.opponent = nil;
	
	Clockwork.datastream:Start(player, "SetPlayerDueling", false);
end