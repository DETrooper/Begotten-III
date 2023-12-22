--[[
	Begotten III: Jesus Wept
--]]

function cwDayNight:ClockworkInitialized()
	self.currentCycle = "day";
	self.nextCycleTime = CurTime() + self.cycles["day"].length + self.launchExtraLength;
end

function cwDayNight:PlayerCharacterInitialized(player)
	Clockwork.datastream:Start(player, "SetCurrentCycle", self.currentCycle);
	Clockwork.datastream:Start(player, "SetNightWeight", self.nightWeight);
end;

local map = game.GetMap() == "rp_begotten3" or game.GetMap() == "rp_begotten_redux" or game.GetMap() == "rp_scraptown";

if !cwDayNight.nightWeight then
	cwDayNight.nightWeight = 0;
end

function cwDayNight:Think()
	if (!map) then
		return;
	end;

	local curTime = CurTime();
	
	if self.nextCycleTime then
		if (curTime > self.nextCycleTime) then
			if (!self.currentCycle) then
				self:ChangeCycle("day", false);
			else
				self:ChangeCycle(cwDayNight.cycles[self.currentCycle].nextCycle, true);
			end
		end;
		
		if !self.nextWeightTick or self.nextWeightTick <= curTime then
			if self.currentCycle == "night" then
				self.nightWeight = 1;
				--printp("Serverside nightweight: "..tostring(self.nightWeight));
			elseif self.currentCycle == "daytonight" then
				self.nightWeight = math.Clamp(self.nightWeight + 0.003333333, 0, 1);
				--printp("Serverside nightweight: "..tostring(self.nightWeight));
			elseif self.currentCycle == "nighttoday" then
				self.nightWeight = math.Clamp(self.nightWeight - 0.003333333, 0, 1);
				--printp("Serverside nightweight: "..tostring(self.nightWeight));
			else
				self.nightWeight = 0;
				--printp("Serverside nightweight: "..tostring(self.nightWeight));
			end
			
			self.nextWeightTick = curTime + 1;
		end
	else
		if self.currentCycle then
			local cycleTable = cwDayNight.cycles[self.currentCycle];
			
			self.nextCycleTime = CurTime() + cwDayNight.cycles[cycleTable.nextCycle].length;
		else
			self:ChangeCycle("day", false);
		end
	end
end;

-- Called at an interval while the player is connected to the server.
function cwDayNight:PlayerThink(player, curTime, infoTable, alive, initialized, plyTab)
	if (!map) then
		return;
	end;
	
	if initialized and alive then
		if self.currentCycle == "night" then
			if !plyTab.nextMoonCheck or plyTab.nextMoonCheck < curTime then
				plyTab.nextMoonCheck = curTime + 1;

				if not plyTab.opponent and not plyTab.cwObserverMode then
					local lastZone = player:GetCharacterData("LastZone");
					
					if lastZone == "wasteland" then
						if !cwBeliefs or !player:HasBelief("lunar_repudiation") then
							if player:EyeAngles().p < -55 then
								local helmetItem = player:GetHelmetEquipped();
								
								if helmetItem and helmetItem.overlay and helmetItem and player:EyeAngles().p > -70 then
									return;
								end
									
								if player:GetEyeTrace().HitSky then
									if plyTab.moonCooldown then
										if curTime < plyTab.moonCooldown then
											return;
										end
									end
									
									player:HandleSanity(-50);
									
									if --[[!player:HasBelief("lunar_repudiation") and]] player:GetSanity() <= 0 then
										Schema:EasyText(player, "maroon", "The moon is everything. There is no point anymore.");
										player:CommitSuicide();
									end
									
									Clockwork.datastream:Start(player, "MoonTrigger");
									
									plyTab.moonCooldown = curTime + 5;
								end
							end
						end
					end
				end
			end
		elseif self.currentCycle == "day" then
			if !plyTab.dayVampireCheck or plyTab.dayVampireCheck < curTime then
				plyTab.dayVampireCheck = curTime + 5;
				
				if player:GetSubfaction() == "Rekh-khet-sa" then
					if !plyTab.opponent and !plyTab.cwObserverMode and !plyTab.ritualOfShadow and !plyTab.cwWakingUp then
						local lastZone = player:GetCharacterData("LastZone");
						
						if lastZone == "wasteland" then
							if util.TraceLine(util.GetPlayerTrace(player, player:GetUp())).HitSky then
								--player:TakeDamage(3, player, player);
								
								local d = DamageInfo()
								d:SetDamage(3);
								d:SetDamageType(DMG_BURN);
								d:SetDamagePosition(player:GetPos() + Vector(0, 0, 48));
								
								player:TakeDamageInfo(d);
								player:EmitSound("player/pl_burnpain"..math.random(1, 3)..".wav");
								
								Clockwork.kernel:PrintLog(LOGTYPE_MAJOR, player:Name().." has taken 3 damage from the sun, leaving them at "..player:Health().." health.");
					
								Clockwork.datastream:Start(player, "Stunned", 3);
							end
						end
					end
				end
			end
		end
	end
end

function cwDayNight:PlayerExitedDuel(player)
	if player:GetSubfaction() == "Rekh-khet-sa" then
		player.dayVampireCheck = CurTime() + 10;
	end
end

netstream.Hook("ShadowDamage", function(player, data)
	local playerPos = player:GetPos();
	local radius = config.Get("talk_radius"):Get() * 2;
	local weapon = player:GetActiveWeapon();
	
	if weapon and weapon.IsABegottenMelee then
		local attackTable = GetTable(weapon.AttackTable);
		
		if attackTable and attackTable.primarydamage then
			player:TakeDamage(attackTable.primarydamage, player, weapon);
		else
			player:TakeDamage(10, player, player);
		end
	else
		player:TakeDamage(10, player, player);
	end
	
	player:HandleSanity(-5);
	
	local listeners = {};
	local selfless = "himself";
	
	if (player:GetGender() == GENDER_FEMALE) then
		selfless = "herself";
	end
	
	local playerCount = _player.GetCount();
	local players = _player.GetAll();

	for i = 1, playerCount do
		local v, k = players[i], i;
		if v ~= player and (playerPos:DistToSqr(v:GetPos()) <= (radius * radius)) then
			listeners[#listeners + 1] = v;
		end;
	end
	
	Clockwork.chatBox:Add(listeners, player, "me", "begins screaming and attacking "..selfless.."!", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
end)