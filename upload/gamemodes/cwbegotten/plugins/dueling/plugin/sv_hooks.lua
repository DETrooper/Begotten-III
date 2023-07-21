--[[
	Begotten III: Jesus Wept
--]]

-- Todo: Detect character changing, disconnects, players leaving the dueling arena somehow (maybe teleported by admin by mistake?).

local map = game.GetMap() == "rp_begotten3" or game.GetMap() == "rp_begotten_redux" or game.GetMap() == "rp_scraptown";

-- Called when Clockwork has loaded all of the entities.
function cwDueling:ClockworkInitPostEntity()
	if (map) then
		for k, v in pairs(DUELING_STATUES) do
			local statueEnt = ents.Create("cw_duelstatue");
			
			statueEnt:SetPos(DUELING_STATUES[k]["spawnPosition"]);
			statueEnt:SetAngles(DUELING_STATUES[k]["spawnAngles"]);
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
		if IsValid(player.opponent) and !player.duelStatue then
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
