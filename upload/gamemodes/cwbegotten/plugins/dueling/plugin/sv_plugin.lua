--[[
	Begotten III: Jesus Wept
--]]
	
if !cwDueling.playersInMatchmaking then
	cwDueling.playersInMatchmaking = {};
end

local bMap = game.GetMap() == "rp_begotten3" or game.GetMap() == "rp_begotten_redux" or game.GetMap() == "rp_scraptown";

function cwDueling:Think()
	if (!bMap) then
		return;
	end;
	
	local curTime = CurTime()

	if (!self.MatchmakingCheckCooldown or self.MatchmakingCheckCooldown < curTime) then
		self.MatchmakingCheckCooldown = curTime + 3;
		
		for i = 1, #self.playersInMatchmaking do
			local duelStatueFound = false;
			local player = self.playersInMatchmaking[i];
			
			if IsValid(player) and player:Alive() then
				if IsValid(player.duelStatue) then
					if player:GetPos():DistToSqr(player.duelStatue:GetPos()) <= (256 * 256) then
						duelStatueFound = true;

						break;
					end
				end
			end
			
			if !duelStatueFound then
				self:PlayerExitsMatchmaking(player);

				if IsValid(player) then
					Schema:EasyText(player, "icon16/door_out.png", "orange", "Exited Duel Matchmaking");
				end
			end
		end

		if #self.playersInMatchmaking > 1 then
			self:MatchmakingCheck();
		end
	end
end;

function cwDueling:MatchmakingCheck()
	local player1 = self.playersInMatchmaking[1];
	local player2 = self.playersInMatchmaking[2];
	
	if IsValid(player1) and player1:Alive() and IsValid(player2) and player2:Alive() then
		local available_arenas = {};
		
		for k, v in pairs(self.arenas) do
			if (!v.duelingPlayer1) and (!v.duelingPlayer2) then
				table.insert(available_arenas, k);
			end
		end
		
		if (#available_arenas <= 0) then
			-- All available arenas are occupied, so refuse the match.
			return;
		end
	
		-- Remove players from matchmaking.
		self:PlayerExitsMatchmaking(player1);
		self:PlayerExitsMatchmaking(player2);
		self:SetupDuel(player1, player2, available_arenas);
	end
end

function cwDueling:PlayerIsInMatchmaking(player)
	for i = 1, #self.playersInMatchmaking do
		if player == self.playersInMatchmaking[i] then
			return true;
		end
	end
	
	return false;
end

function cwDueling:PlayerEntersMatchmaking(player)
--[[
	I think it'd be better to redesign the PlayersInMatchmaking table by indexing players based on their EntIndex (https://wiki.facepunch.com/gmod/Entity:EntIndex) and to use that as a key to look for in the table rather than starting a loop every time we want to find a player.
	
	local index = player:EntIndex();
	self.playersInMatchmaking[index] = true -- maybe set the value to the player's opponent instead of a boolean
	
	This could also be used to more easily check if the player is currently in matchmaking 
	
	function cwDueling:PlayerIsInMatchmaking(player)
		local index = player:EntIndex();
		return tobool(self.playersInMatchmaking[index]); -- i believe any value other than nil will become true using this. 
	end;
--]]

	if (IsValid(player.cwHoldingEnt)) then
		cwPickupObjects:ForceDropEntity(player);
	end;
	
	if (Clockwork.player:GetAction(player) == "pickupragdoll") then
		if (IsValid(player.PickingUpRagdoll)) then
			player.PickingUpRagdoll:SetNetVar("IsDragged", false);
			player.PickingUpRagdoll:SetNetVar("IsBeingPickedUp", false);
			player.PickingUpRagdoll.BeingPickedUp = nil;
			player.PickingUpRagdoll.PickedUpBy = nil;
		end;
		
		Clockwork.chatBox:AddInTargetRadius(player, "me", "releases their grip on the body before them.", player:GetPos(), config.Get("talk_radius"):Get() * 2);
		
		player.NextPickup = CurTime() + 1;
		player.PickingUpRagdoll = nil;
		player:SetNWBool("PickingUpRagdoll", false);
		Clockwork.player:SetAction(player, nil);
	end

	for i = 1, #self.playersInMatchmaking do
		if self.playersInMatchmaking[i] == player then
			return;
		end
	end
	
	if player.opponent == nil then -- If both players spam really hard they can have multiple duels trigger at once.
		table.insert(self.playersInMatchmaking, player);

		Schema:EasyText(player, "icon16/door_in.png", "orange", "Entered Duel Matchmaking")
		
		if #self.playersInMatchmaking > 1 then
			self:MatchmakingCheck();
		end
	end
end

function cwDueling:PlayerExitsMatchmaking(player)
	--[[
		same deal here, if the players are placed in the playersInMatchmaking table based on a unique identifier such as their ent index, removing them is as simple as self.playersInMatchmaking[index] = nil
	--]]
	for i = 1, #self.playersInMatchmaking do
		if player == self.playersInMatchmaking[i] then
			table.remove(self.playersInMatchmaking, i);
			break;
		end
	end
end

function cwDueling:SetupDuel(player1, player2, available_arenas)
	if (!map) then
		return;
	end;

	local random_arena = available_arenas[math.random(1, #available_arenas)];
	
	self.arenas[random_arena].duelingPlayer1 = player1;
	self.arenas[random_arena].duelingPlayer2 = player2;
	player1.opponent = player2;
	player2.opponent = player1;
	
	Schema:EasyText({player1, player2}, "icon16/shield_go.png", "forestgreen", "Duel Found!");
	
	player1:ScreenFade(SCREENFADE.OUT, Color(0, 0, 0, 255 ), 4, 1.2);
	player2:ScreenFade(SCREENFADE.OUT, Color(0, 0, 0, 255 ), 4, 1.2);
	
	Clockwork.datastream:Start(player1, "FadeAmbientMusic");
	Clockwork.datastream:Start(player2, "FadeAmbientMusic");
	
	-- Save positions.
	if cwSpawnSaver then
		cwSpawnSaver:PrePlayerCharacterUnloaded(player1);
		cwSpawnSaver:PrePlayerCharacterUnloaded(player2);
	end
	
	timer.Simple(5, function()
		if IsValid(player1) and player1:Alive() and IsValid(player2) and player2:Alive() then
			Clockwork.datastream:Start(player1, "SetPlayerDueling", true);
			Clockwork.datastream:Start(player2, "SetPlayerDueling", true);
		
			Clockwork.limb:CacheLimbs(player1, true);
			Clockwork.limb:CacheLimbs(player2, true);
		
			player1:Spawn();	
			player1:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255 ), 5, 0);
			player1:SetPos(self.arenas[random_arena].spawnPosition1);
			player1:SetEyeAngles(self.arenas[random_arena].spawnAngles1);
			player1:SetHealth(player1:GetMaxHealth());
			
			if player1:GetLocalVar("Hatred") then
				player1:SetLocalVar("Hatred", 0);
			end

			player2:Spawn();	
			player2:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255 ), 5, 0);
			player2:SetPos(self.arenas[random_arena].spawnPosition2);
			player2:SetEyeAngles(self.arenas[random_arena].spawnAngles2);
			player2:SetHealth(player2:GetMaxHealth());
			
			if player2:GetLocalVar("Hatred") then
				player2:SetLocalVar("Hatred", 0);
			end
			
			player1.duelStatue = nil;
			player2.duelStatue = nil;
			
			-- Start battle music after players have faded in.
			timer.Simple(5, function()
				Clockwork.datastream:Start(player1, "StartBattleMusicNoLimit");
				Clockwork.datastream:Start(player2, "StartBattleMusicNoLimit");
			end);
			
			hook.Run("PlayerEnteredDuel", player1);
			hook.Run("PlayerEnteredDuel", player2);
			
			timer.Create("DuelTimer_"..random_arena, self.arenas[random_arena].timeLimit, 1, function()
				if IsValid(player1) and IsValid(player2) then
					self:DuelAborted(player1, player2);
				end
			end)
		else
			-- One of the players disconnected or some shit after finding a match.
			self.arenas[random_arena].duelingPlayer1 = nil;
			self.arenas[random_arena].duelingPlayer2 = nil;
			
			if IsValid(player1) then
				Schema:EasyText(player1, "icon16/shield_go.png", "orangered", "Duel Aborted!")
				player1:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255 ), 5, 0);
				player1.opponent = nil;
				
				Clockwork.datastream:Start(player1, "SetPlayerDueling", false);
			elseif IsValid(player2) then
				Schema:EasyText(player2, "icon16/shield_go.png", "orangered", "Duel Aborted!")
				player2:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255 ), 5, 0);
				player2.opponent = nil;
				
				Clockwork.datastream:Start(player2, "SetPlayerDueling", false);
			end
		end
	end);
end

function cwDueling:PlayerIsDueling(player)
	if self.arenas then
		for k, v in pairs(self.arenas) do
			if v.duelingPlayer1 == player or v.duelingPlayer2 == player then
				return true;
			end
		end
	end
	
	return false;
end

function cwDueling:PlayersAreDueling(player1, player2)
	if self.arenas then
		for k, v in pairs(self.arenas) do
			if v.duelingPlayer1 == player1 and v.duelingPlayer2 == player2 then
				return true;
			elseif v.duelingPlayer2 == player1 and v.duelingPlayer1 == player2 then
				return true;
			end
		end
	end
	
	return false;
end

function cwDueling:GetPlayerDuelOpponent(player)
	--[[for k, v in pairs(self.arenas) do
		if v.duelingPlayer1 == player then
			if v.duelingPlayer2 then
				return v.duelingPlayer2;
			end
		elseif v.duelingPlayer2 == player then
			if v.duelingPlayer1 then
				return v.duelingPlayer1;
			end
		end
	end]]--
	
	if IsValid(player.opponent) then
		return player.opponent;
	end
	
	return;
end

function cwDueling:DuelAborted(player1, player2)
	local curTime = CurTime();

	if IsValid(player1) and IsValid(player2) then
		for k, v in pairs(self.arenas) do
			if (v.duelingPlayer1 == player1 or v.duelingPlayer2 == player1) and (v.duelingPlayer1 == player2 or v.duelingPlayer2 == player2) then
				-- There was probably a tie or something.
				self.arenas[k].duelingPlayer1 = nil;
				self.arenas[k].duelingPlayer2 = nil;
				
				if timer.Exists("DuelTimer_"..k) then
					timer.Remove("DuelTimer_"..k)
				end
				
				player1:Freeze(true);
				player1:ScreenFade(SCREENFADE.OUT, Color(0, 0, 0, 255 ), 4, 1.1);
				player2:Freeze(true);
				player2:ScreenFade(SCREENFADE.OUT, Color(0, 0, 0, 255 ), 4, 1.1);
				
				Clockwork.datastream:Start(player1, "FadeBattleMusic");
				Clockwork.datastream:Start(player2, "FadeBattleMusic");
				
				timer.Simple(5, function()
					if IsValid(player1) then
						player1:Freeze(false);
						player1:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255 ), 5, 0);
						
						if player1.cachedPos and player1.cachedAngles then
							player1:Spawn();
							player1:SetPos(player1.cachedPos + Vector(0, 0, 8));
							player1:SetEyeAngles(player1.cachedAngles);
							
							Clockwork.limb:RestoreLimbsFromCache(player1);
							
							timer.Simple(0.1, function()
								if IsValid(player1) then
									player1:SetPos(player1.cachedPos + Vector(0, 0, 8));
									player1:SetEyeAngles(player1.cachedAngles);
								end
							end);
						end
						
						if player1.cachedHP then
							player1:SetHealth(player1.cachedHP);
							player1:SetNWInt("freeze", 0);
						end

						if player1:GetCharacterData("Hatred") then
							player1:SetLocalVar("Hatred", player1:GetCharacterData("Hatred"));
						end
						
						player1.opponent = nil;
						
						Clockwork.datastream:Start(player1, "SetPlayerDueling", false);
						
						hook.Run("PlayerExitedDuel", player1);
					end
					
					if IsValid(player2) then
						player2:Freeze(false);
						player2:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255 ), 5, 0);
						
						if player2.cachedPos and player2.cachedAngles then
							player2:Spawn();
							player2:SetPos(player2.cachedPos + Vector(0, 0, 8));
							player2:SetEyeAngles(player2.cachedAngles);
							
							Clockwork.limb:RestoreLimbsFromCache(player2);
							
							timer.Simple(0.1, function()
								if IsValid(player2) then
									player2:SetPos(player2.cachedPos + Vector(0, 0, 8));
									player2:SetEyeAngles(player2.cachedAngles);
								end
							end);
						end
						
						if player2.cachedHP then
							player2:SetHealth(player2.cachedHP);
							player2:SetNWInt("freeze", 0);
						end
						
						if player2:GetCharacterData("Hatred") then
							player2:SetLocalVar("Hatred", player2:GetCharacterData("Hatred"));
						end
						
						player2.opponent = nil;
						
						Clockwork.datastream:Start(player2, "SetPlayerDueling", false);
						
						hook.Run("PlayerExitedDuel", player2);
					end
				end);

				Schema:EasyText({player1, player2}, "icon16/shield.png", "orange", "Draw!");
			end
		end
	elseif IsValid(player1) then
		for k, v in pairs(self.arenas) do
			if v.duelingPlayer1 == player1 or v.duelingPlayer2 == player1 then
				-- player2 dropped
				for k, v in pairs (_player.GetAll()) do
					if v:IsAdmin() then
						Schema:EasyText(v, "orangered","[DUELLING] Player: "..player1:Name().." dropped from an in progress duel.");
					end;
				end;
				
				self.arenas[k].duelingPlayer1 = nil;
				self.arenas[k].duelingPlayer2 = nil;
				
				if timer.Exists("DuelTimer_"..k) then
					timer.Remove("DuelTimer_"..k)
				end
				
				player1:Freeze(true);
				player1:ScreenFade(SCREENFADE.OUT, Color(0, 0, 0, 255 ), 4, 1.1);
				
				Clockwork.datastream:Start(player1, "FadeBattleMusic");
				
				timer.Simple(5, function()
					if IsValid(player1) then
						player1:Freeze(false);
						player1:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255 ), 5, 0);
						
						if player1.cachedPos and player1.cachedAngles then
							player1:Spawn();
							player1:SetPos(player1.cachedPos + Vector(0, 0, 8));
							player1:SetEyeAngles(player1.cachedAngles);
							
							Clockwork.limb:RestoreLimbsFromCache(player1);
							
							timer.Simple(0.1, function()
								if IsValid(player1) then
									player1:SetPos(player1.cachedPos + Vector(0, 0, 8));
									player1:SetEyeAngles(player1.cachedAngles);
								end
							end);
						end
						
						if player1.cachedHP then
							player1:SetHealth(player1.cachedHP);
							player1:SetNWInt("freeze", 0);
						end
						
						if player1:GetCharacterData("Hatred") then
							player1:SetLocalVar("Hatred", player1:GetCharacterData("Hatred"));
						end
						
						player1.opponent = nil;
						
						Clockwork.datastream:Start(player1, "SetPlayerDueling", false);
						
						hook.Run("PlayerExitedDuel", player1);
					end
				end);
				
				Schema:EasyText(player1, "icon16/shield.png", "orange", "Draw!");
			end
		end
	elseif IsValid(player2) then 
		for k, v in pairs(self.arenas) do
			if v.duelingPlayer1 == player2 or v.duelingPlayer2 == player2 then
				-- player1 dropped
				for k, v in pairs (_player.GetAll()) do
					if v:IsAdmin() then
						Schema:EasyText(v, "orange","[DUELLING] Player: "..player2:Name().." dropped from an in progress duel.");
					end;
				end;
				
				self.arenas[k].duelingPlayer1 = nil;
				self.arenas[k].duelingPlayer2 = nil;
				
				if timer.Exists("DuelTimer_"..k) then
					timer.Remove("DuelTimer_"..k)
				end
				
				player2:Freeze(true);
				player2:ScreenFade(SCREENFADE.OUT, Color(0, 0, 0, 255 ), 4, 1.1);
				
				Clockwork.datastream:Start(player2, "FadeBattleMusic");
				
				timer.Simple(5, function()
					if IsValid(player2) then
						player2:Freeze(false);
						player2:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255 ), 5, 0);
						
						if player2.cachedPos and player2.cachedAngles then
							player2:Spawn();
							player2:SetPos(player2.cachedPos + Vector(0, 0, 8));
							player2:SetEyeAngles(player2.cachedAngles);
							
							Clockwork.limb:RestoreLimbsFromCache(player2);
							
							timer.Simple(0.1, function()
								if IsValid(player2) then
									player2:SetPos(player2.cachedPos + Vector(0, 0, 8));
									player2:SetEyeAngles(player2.cachedAngles);
								end
							end);
						end
						
						if player2.cachedHP then
							player2:SetHealth(player2.cachedHP);
							player2:SetNWInt("freeze", 0);
						end
						
						if player2:GetCharacterData("Hatred") then
							player2:SetLocalVar("Hatred", player2:GetCharacterData("Hatred"));
						end
						
						player2.opponent = nil;
						
						Clockwork.datastream:Start(player2, "SetPlayerDueling", false);
						
						hook.Run("PlayerExitedDuel", player2);
					end
				end);

				Schema:EasyText(player2, "icon16/shield.png", "orangered", "Draw!");
			end
		end
	end
end

function cwDueling:DuelCompleted(winner, loser)
	local curTime = CurTime();

	if IsValid(winner) and IsValid(loser) then
		for k, v in pairs(self.arenas) do
			if (v.duelingPlayer1 == winner or v.duelingPlayer2 == winner) and (v.duelingPlayer1 == loser or v.duelingPlayer2 == loser) then
				local wins = winner:GetCharacterData("DuelWins") or 0;
				local losses = loser:GetCharacterData("DuelLosses") or 0;
				
				winner:SetCharacterData("DuelWins", wins + 1);
				loser:SetCharacterData("DuelLosses", losses + 1);
				
				self.arenas[k].duelingPlayer1 = nil;
				self.arenas[k].duelingPlayer2 = nil;
					
				if timer.Exists("DuelTimer_"..k) then
					timer.Remove("DuelTimer_"..k)
				end

				winner:Freeze(true);
				winner:ScreenFade(SCREENFADE.OUT, Color(0, 0, 0, 255 ), 4, 1.1);
				loser:ScreenFade(SCREENFADE.OUT, Color(0, 0, 0, 255 ), 4, 1.1);
				
				Clockwork.datastream:Start(winner, "FadeBattleMusic");
				--Clockwork.datastream:Start(loser, "FadeBattleMusic"); -- This should already happen if the loser is dead.
					
				timer.Simple(5, function()
					if IsValid(winner) then
						winner:Freeze(false);
						winner:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255 ), 5, 0);

						if winner.cachedPos and winner.cachedAngles then
							winner:Spawn();
							winner:SetPos(winner.cachedPos + Vector(0, 0, 8));
							winner:SetEyeAngles(winner.cachedAngles);
							
							Clockwork.limb:RestoreLimbsFromCache(winner);
							
							timer.Simple(0.1, function()
								if IsValid(winner) then
									winner:SetPos(winner.cachedPos + Vector(0, 0, 8));
									winner:SetEyeAngles(winner.cachedAngles);
								end
							end);
						end
						
						if winner.cachedHP then
							winner:SetHealth(winner.cachedHP);
							winner:SetNWInt("freeze", 0);
						end
						
						if winner:GetCharacterData("Hatred") then
							winner:SetLocalVar("Hatred", winner:GetCharacterData("Hatred"));
						end
						
						winner.opponent = nil;
						
						Clockwork.datastream:Start(winner, "SetPlayerDueling", false);
						
						hook.Run("PlayerExitedDuel", winner);
					end
					
					if IsValid(loser) then
						loser:Freeze(false);
						loser:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255 ), 5, 0);

						if loser.cachedPos and loser.cachedAngles then
							loser:Spawn();
							loser:SetPos(loser.cachedPos + Vector(0, 0, 8));
							loser:SetEyeAngles(loser.cachedAngles);
							
							Clockwork.limb:RestoreLimbsFromCache(loser);
							
							timer.Simple(0.1, function()
								if IsValid(loser) then
									loser:SetPos(loser.cachedPos + Vector(0, 0, 8));
									loser:SetEyeAngles(loser.cachedAngles);
								end
							end);
						end
						
						if loser.cachedHP then
							loser:SetHealth(loser.cachedHP);
							loser:SetNWInt("freeze", 0);
						end
						
						if loser:GetCharacterData("Hatred") then
							loser:SetLocalVar("Hatred", loser:GetCharacterData("Hatred"));
						end
						
						loser.opponent = nil;
						
						Clockwork.datastream:Start(loser, "SetPlayerDueling", false);
						
						hook.Run("PlayerExitedDuel", loser);
					end
				end);

				if cwBeliefs then
					local level = winner:GetCharacterData("level", 1);
					local kinisgerOverride = winner:GetSharedVar("kinisgerOverride");
					
					if winner:GetSubfaction() == "Kinisger" and kinisgerOverride then
						if kinisgerOverride ~= "Children of Satan" and winner:GetSharedVar("kinisgerOverrideSubfaction") ~= "Clan Reaver" then
							if level > cwBeliefs.sacramentLevelCap and winner:HasBelief("sorcerer") then
								if winner:HasBelief("loremaster") then
									if level > (cwBeliefs.sacramentLevelCap + 10) then
										level = 50;
									end
								else
									level = 40;
								end
							end
						end
					end
					
					Schema:EasyText({winner, loser}, "icon16/shield_add.png", "forestgreen", winner:Name().." ("..level..") was the winner with "..winner:Health().." out of "..winner:GetMaxHealth().." health left!");
				else
					Schema:EasyText({winner, loser}, "icon16/shield_add.png", "forestgreen", winner:Name().." was the winner with "..winner:Health().." out of "..winner:GetMaxHealth().." health left!");
				end
			end
		end
	elseif IsValid(winner) then
		-- This shouldn't happen but I'd rather handle it if it does.
		for k, v in pairs(self.arenas) do
			if v.duelingPlayer1 == winner or v.duelingPlayer2 == winner then
				local wins = winner:GetCharacterData("DuelWins") or 0;
				
				winner:SetCharacterData("DuelWins", wins + 1);
			
				for k, v in pairs (_player.GetAll()) do
					if v:IsAdmin() then
						Schema:EasyText(v, "orangered","[DUELLING] Player: "..loser:Name().." dropped from an in progress duel.");
					end;
				end;
				
				self.arenas[k].duelingPlayer1 = nil;
				self.arenas[k].duelingPlayer2 = nil;
				
				if timer.Exists("DuelTimer_"..k) then
					timer.Remove("DuelTimer_"..k)
				end
				
				winner:Freeze(true);
				winner:ScreenFade(SCREENFADE.OUT, Color(0, 0, 0, 255 ), 4, 1.1);
				
				Clockwork.datastream:Start(winner, "FadeBattleMusic");
					
				timer.Simple(5, function()
					if IsValid(winner) then
						winner:Freeze(false);
						winner:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255 ), 5, 0);

						if winner.cachedPos and winner.cachedAngles then
							winner:Spawn();
							winner:SetPos(winner.cachedPos + Vector(0, 0, 8));
							winner:SetEyeAngles(winner.cachedAngles);
							
							Clockwork.limb:RestoreLimbsFromCache(winner);
							
							timer.Simple(0.1, function()
								if IsValid(winner) then
									winner:SetPos(winner.cachedPos + Vector(0, 0, 8));
									winner:SetEyeAngles(winner.cachedAngles);
								end
							end);
						end
						
						if winner.cachedHP then
							winner:SetHealth(winner.cachedHP);
							winner:SetNWInt("freeze", 0);
						end
						
						if winner:GetCharacterData("Hatred") then
							winner:SetLocalVar("Hatred", winner:GetCharacterData("Hatred"));
						end
						
						winner.opponent = nil;
						
						Clockwork.datastream:Start(winner, "SetPlayerDueling", false);
						
						hook.Run("PlayerExitedDuel", winner);
					end
				end);
				
				if cwBeliefs then
					local level = winner:GetCharacterData("level", 1);
					local kinisgerOverride = winner:GetSharedVar("kinisgerOverride");
					
					if winner:GetSubfaction() == "Kinisger" and kinisgerOverride then
						if kinisgerOverride ~= "Children of Satan" and winner:GetSharedVar("kinisgerOverrideSubfaction") ~= "Clan Reaver" then
							if level > cwBeliefs.sacramentLevelCap and winner:HasBelief("sorcerer") then
								if winner:HasBelief("loremaster") then
									if level > (cwBeliefs.sacramentLevelCap + 10) then
										level = 50;
									end
								else
									level = 40;
								end
							end
						end
					end
				
					Schema:EasyText(winner, "icon16/shield_add.png", "forestgreen", winner:Name().." ("..level..") was the winner with "..winner:Health().." out of "..winner:GetMaxHealth().." health left!");
				else
					Schema:EasyText(winner, "icon16/shield_add.png", "forestgreen", winner:Name().." was the winner with "..winner:Health().." out of "..winner:GetMaxHealth().." health left!");
				end
			end
		end
	elseif IsValid(loser) then
		-- IDK how this would happen.
		for k, v in pairs(self.arenas) do
			if v.duelingPlayer1 == loser or v.duelingPlayer2 == loser then
				local losses = loser:GetCharacterData("DuelLosses") or 0;

				loser:SetCharacterData("DuelLosses", losses + 1);

				for k, v in pairs (_player.GetAll()) do
					if v:IsAdmin() then
						Schema:EasyText(v, "orangered","[DUELLING] Player: "..winner:Name().." dropped from an in progress duel.");
					end;
				end;
				
				self.arenas[k].duelingPlayer1 = nil;
				self.arenas[k].duelingPlayer2 = nil;
				
				if timer.Exists("DuelTimer_"..k) then
					timer.Remove("DuelTimer_"..k)
				end
				
				--Clockwork.datastream:Start(loser, "FadeBattleMusic"); -- This should already happen if the loser is dead.
				
				timer.Simple(5, function()
					if IsValid(loser) then
						loser:Freeze(false);
						loser:ScreenFade(SCREENFADE.IN, Color(0, 0, 0, 255 ), 5, 0);

						if loser.cachedPos and loser.cachedAngles then
							loser:Spawn();
							loser:SetPos(loser.cachedPos + Vector(0, 0, 8));
							loser:SetEyeAngles(loser.cachedAngles);
							
							Clockwork.limb:RestoreLimbsFromCache(loser);
							
							timer.Simple(0.1, function()
								if IsValid(loser) then
									loser:SetPos(loser.cachedPos + Vector(0, 0, 8));
									loser:SetEyeAngles(loser.cachedAngles);
								end
							end);
						end
						
						if loser.cachedHP then
							loser:SetHealth(loser.cachedHP);
							loser:SetNWInt("freeze", 0);
						end
						
						if loser:GetCharacterData("Hatred") then
							loser:SetLocalVar("Hatred", loser:GetCharacterData("Hatred"));
						end
						
						loser.opponent = nil;
						
						Clockwork.datastream:Start(loser, "SetPlayerDueling", false);
						
						hook.Run("PlayerExitedDuel", loser);
					end
				end);

				Schema:EasyText(loser, "icon16/shield_delete.png", "orangered", loser:Name().." loses!");
			end
		end
	end
end