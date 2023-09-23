--[[
	Begotten III: Jesus Wept
--]]

local playerMeta = FindMetaTable("Player")

cwCharacterNeeds.Needs = {"corruption", "hunger", "thirst", "sleep"};

if (game.GetMap() == "rp_begotten3") then
	cwCharacterNeeds.bedZones = {
		["gatekeeper"] = {pos1 = Vector(7.321299, 11894.544922, -894.334839), pos2 = Vector(-411.470306, 11735.828125, -1083.374146)},
		["gores"] = {pos1 = Vector(-832.345764, -9334.505859, 11725.469727), pos2 = Vector(865.71228, -8200, 11906.510742)},
		["gorehut"] = {pos1 = Vector(-5495.212891, -12411.369141, 11660.045898), pos2 = Vector(-5270.462891, -12857.296875, 11883.424805)},
		["hierarchy"] = {pos1 = Vector(1262.145874, 12378.849609, -1082.730469), pos2 = Vector(1411.662598, 12989.326172, -868.509827)},
		["ministers"] = {pos1 = Vector(2462.500732, 14163.791992, -932.533142), pos2 = Vector(2191.804932, 13323.184570, -1085.815063)},
		["satanists"] = {pos1 = Vector(-971.700928, -9710.587891, -6210.654297), pos2 = Vector(-379.956238, -9465.206055, -6339.781738)}, -- manor
		["castle"] = {pos1 = Vector(-13781, -12473, -1325), pos2 = Vector(-13067, -13311, -1134)}, -- castle
	};
elseif (game.GetMap() == "rp_begotten_redux") then
	cwCharacterNeeds.bedZones = {
		["gatekeeper"] = {pos1 = Vector(-12349.285156, -3916.933350, 634.704895), pos2 = Vector(-11888.666992, -3587.417969, 506.941895)},
		["hierarchy"] = {pos1 = Vector(-13746.707031, -8013.333984, -1691.198730), pos2 = Vector(-13199.692383, -7632.799316, -1543.273315)},
		["satanists"] = {pos1 = Vector(-971.700928, -9710.587891, -6210.654297), pos2 = Vector(-379.956238, -9465.206055, -6339.781738)}, -- manor
	};
elseif (game.GetMap() == "rp_scraptown") then
	cwCharacterNeeds.bedZones = {
		["castle"] = {pos1 = Vector(-5716.331055, -1955.981934, 116.951614), pos2 = Vector(-4663.074219, -514.475952, 350.913727)},
		["satanists"] = {pos1 = Vector(-971.700928, -9710.587891, -6210.654297), pos2 = Vector(-379.956238, -9465.206055, -6339.781738)},
		["scrapper1"] = {pos1 = Vector(-6277.276367, -3928.885742, 129.020355), pos2 = Vector(-5655.393555, -4494.678711, 383.889038)},
		["scrapper2"] = {pos1 = Vector(-5383.849121, -3927.990479, 144.067154), pos2 = Vector(-4756.870605, -4496.703613, 475.793884)},
		["third_inquisiton"] = {pos1 = Vector(8645.833008, 8760.555664, 1118.296631), pos2 = Vector(-8412.388672, 8572.348633, 1243.590088)},
	};
else
	cwCharacterNeeds.bedZones = {};
end

-- A function to handle a player's sanity value.
function playerMeta:HandleNeed(need, amount)
	if self.opponent then
		return;
	end

	if need and table.HasValue(cwCharacterNeeds.Needs, need) then
		if (!amount or type(amount) != "number") then
			return
		end
		
		if amount > 0 then
			if need == "sleep" then
				if cwBeliefs and self:HasBelief("enduring_bear") then
					amount = (amount / 2);
				end
			elseif need == "corruption" then
				local clothesItem = self:GetClothesItem();
				
				if clothesItem and clothesItem.attributes and table.HasValue(clothesItem.attributes, "mothers_blessing") then
					amount = amount * 0.5;
				end
			
				if self.HasCharmEquipped then
					if self:HasCharmEquipped("crucifix") then
						amount = amount * 0.75;
					end
					
					if self:HasCharmEquipped("warding_talisman") then
						amount = amount * 0.5;
					end
				end
				
				--[[if self:GetSubfaction() == "Philimaxio" then
						amount = amounth * 1.5;
					end]]--
				--[[elseif self:GetSubfaction() == "Philimaxio" then
						amount = amount * 2;
				end]]--
			end
		end
		
		local currentAmount = self:GetCharacterData(need, 0);
		local newAmount = currentAmount + amount;
		
		if newAmount > currentAmount then
			if Clockwork.player:HasFlags(self, "I") then
				return;
			end
		
			if need == "hunger" then
				if cwBeliefs and self:HasBelief("yellow_and_black") and amount > 0 then
					return;
				end
				
				if newAmount >= 100 then
					if !self:IsRagdolled() then
						Clockwork.chatBox:Add(self, nil, "itnofake", "I can't go on like this for much longer...");
						Clockwork.player:SetRagdollState(self, RAGDOLL_KNOCKEDOUT, 20);
						
						local health = self:Health();
						local maxHealth = self:GetMaxHealth();

						--self:TakeDamage(maxHealth / 4, self, self);
						
						if health > health - (maxHealth / 4) then
							self:SetHealth(health - (maxHealth / 4));
						else
							self:DeathCauseOverride("Died of starvation.");
							self:Kill();
						end
						
						--[[if self:Health() <= 0 then
							self:DeathCauseOverride("Died of starvation.");
						end]]--
					end;
				elseif newAmount >= 90 and currentAmount < 90 then
					Clockwork.chatBox:Add(self, nil, "itnofake", "I am starving. How long can I go on for?");
				elseif newAmount >= 75 and currentAmount < 75 then
					Clockwork.chatBox:Add(self, nil, "itnofake", "I am very hungry.");
				elseif newAmount >= 50 and currentAmount < 50 then
					Clockwork.chatBox:Add(self, nil, "itnofake", "I feel hungry.");
				end;
			elseif need == "thirst" then
				if cwBeliefs and self:HasBelief("yellow_and_black") and amount > 0 then
					return;
				end
			
				if newAmount >= 100 then
					if !self:IsRagdolled() then
						Clockwork.chatBox:Add(self, nil, "itnofake", "I can't go on like this for much longer...");
						Clockwork.player:SetRagdollState(self, RAGDOLL_KNOCKEDOUT, 20);

						local health = self:Health();
						local maxHealth = self:GetMaxHealth();

						--self:TakeDamage(maxHealth / 4, self, self);
						
						if health > health - (maxHealth / 4) then
							self:SetHealth(health - (maxHealth / 4));
						else
							self:DeathCauseOverride("Died of dehydration.");
							self:Kill();
						end
						
						--[[if self:Health() <= 0 then
							self:DeathCauseOverride("Died of dehydration.");
						end]]--
					end;
				elseif newAmount >= 90 and currentAmount < 90 then
					Clockwork.chatBox:Add(self, nil, "itnofake", "This thirst will be the death of me. I need to find water SOON!");
				elseif newAmount >= 75 and currentAmount < 75 then
					Clockwork.chatBox:Add(self, nil, "itnofake", "My mouth is dry and I feel very parched.");
				elseif newAmount >= 50 and currentAmount < 50 then
					Clockwork.chatBox:Add(self, nil, "itnofake", "This thirst is getting to me. I must find clean water soon.");
				end;
			elseif need == "sleep" then
				if amount > 0 then
					if self:GetRagdollState() == RAGDOLL_KNOCKEDOUT then
						return;
					end
				end
			
				if newAmount >= 100 then
					if cwBeliefs and self:HasBelief("yellow_and_black") then
						self:DeathCauseOverride("Ran out of battery.");
						self:Kill();
						
						return;
					end

					self.sleepData = {health = 10, hunger = 15, thirst = 30, rest = -30};
					Clockwork.player:SetRagdollState(self, RAGDOLL_KNOCKEDOUT, 300);
					Schema:EasyText(self, "olive", "You finally collapse from exhaustion.");
				elseif newAmount >= 90 and currentAmount < 90 then
					if cwBeliefs and self:HasBelief("yellow_and_black") then
						Clockwork.chatBox:Add(self, nil, "itnofake", "My systems are starting to shut down, I NEED TECH!");
					else
						Clockwork.chatBox:Add(self, nil, "itnofake", "I'm gonna pass out soon if I can't find somewhere to go to bed...");
					end
				elseif newAmount >= 75 and currentAmount < 75 then
					if cwBeliefs and self:HasBelief("yellow_and_black") then
						Clockwork.chatBox:Add(self, nil, "itnofake", "My battery is getting very low, I must find tech and soon!");
					else
						Clockwork.chatBox:Add(self, nil, "itnofake", "I'm feeling very tired...");
					end
				elseif newAmount >= 50 and currentAmount < 50 then
					if cwBeliefs and self:HasBelief("yellow_and_black") then
						Clockwork.chatBox:Add(self, nil, "itnofake", "My battery is at 50%, I must be mindful of it.");
					else
						Clockwork.chatBox:Add(self, nil, "itnofake", "I'm starting to get a bit drowsy.");
					end
				end;
			elseif need == "corruption" then
				if amount > 0 then
					if self:GetSubfaction() == "Rekh-khet-sa" then
						return;
					end
				end
				
				if newAmount >= 100 then
					-- todo: spawn begotten NPC
					if cwPossession then
						self:SetCharacterData("permakilled", true);
						self:DeathCauseOverride("Had their soul corrupted by a Demon.");
						self:PossessionFreakout();
						
						timer.Simple(20, function()
							if IsValid(self) then
								self:SetSharedVar("possessionFreakout", false);
								self:Freeze(false);
								
								if self:Alive() then
									local lastZone = self:GetCharacterData("LastZone");
									local playerPos = self:GetPos();
									
									if lastZone ~= "tower" and lastZone ~= "theather" and lastZone ~= "manor" then 
										Clockwork.chatBox:AddInTargetRadius(self, "me", "abruptly explodes into a shower of fire and gore as a fucking demon bursts from their very flesh!", playerPos, config.Get("talk_radius"):Get() * 2);
										Schema:EasyText(GetAdmins(), "icon16/bomb.png", "tomato", self:Name().." exploded from high corruption and a demon has spawned in their stead!", nil);
										
										self:Kill();
										
										if cwGore then
											if (self:GetRagdollEntity()) then
												cwGore:SplatCorpse(self:GetRagdollEntity(), 60);
											end;
										end
										
										local entity = ents.Create("npc_bgt_brute");

										ParticleEffect("teleport_fx",playerPos,Angle(0,0,0),entity)
										sound.Play("misc/summon.wav",playerPos,100,100)
										
										--[[timer.Simple(0.75, function()
											if IsValid(entity) then]]--
												entity:CustomInitialize();
												entity:SetPos(playerPos);
												entity:Spawn();
												entity:Activate();
											--end
										--end
									else
										self:Kill();
										
										if cwGore then
											if (self:GetRagdollEntity()) then
												cwGore:SplatCorpse(self:GetRagdollEntity(), 60);
											end;
										end
									
										Clockwork.chatBox:AddInTargetRadius(self, "me", "abruptly explodes into a shower of gore!", playerPos, config.Get("talk_radius"):Get() * 2);
										Schema:EasyText(GetAdmins(), "icon16/bomb.png", "tomato", self:Name().." exploded from high corruption!", nil);
									end
								end
							end
						end);
					else
						self:SetCharacterData("permakilled", true);
						self:DeathCauseOverride("Had their soul corrupted by a Demon.");
						
						if lastZone ~= "tower" and lastZone ~= "theather" and lastZone ~= "manor" then 		
							local lastZone = self:GetCharacterData("LastZone");
							local playerPos = self:GetPos();
							
							Clockwork.chatBox:AddInTargetRadius(self, "me", "explodes into a shower of fire and gore as a fucking demon bursts from their very flesh!", playerPos, config.Get("talk_radius"):Get() * 2);
							Schema:EasyText(GetAdmins(), "icon16/bomb.png", "tomato", self:Name().." exploded from high corruption and a demon has spawned in their stead!", nil);
							
							self:Kill();
							
							if cwGore then
								if (self:GetRagdollEntity()) then
									cwGore:SplatCorpse(self:GetRagdollEntity(), 60);
								end;
							end
							
							local entity = ents.Create("cw_brute");
							
							ParticleEffect("teleport_fx",playerPos,Angle(0,0,0),entity)
							sound.Play("misc/summon.wav",playerPos,100,100)
							
							--[[timer.Simple(0.75, function()
								if IsValid(entity) then]]--
									entity:CustomInitialize();
									entity:SetPos(playerPos);
									entity:Spawn();
									entity:Activate();
								--end
							--end
						else
							self:Kill();
							
							if cwGore then
								if (self:GetRagdollEntity()) then
									cwGore:SplatCorpse(self:GetRagdollEntity(), 60);
								end;
							end
						
							Clockwork.chatBox:AddInTargetRadius(self, "me", "abruptly explodes into a shower of gore!", playerPos, config.Get("talk_radius"):Get() * 2);
							Schema:EasyText(GetAdmins(), "icon16/bomb.png", "tomato", self:Name().." exploded from high corruption!");
						end
					end
				elseif newAmount >= 90 and currentAmount < 90 then
					Clockwork.chatBox:Add(self, nil, "itnofake", "You can feel claws DIGGING INTO YOUR MIND!!! You must pray for holy salvation as soon as possible!");
					
					if not self:HasTrait("possessed") then
						Clockwork.datastream:Start(self, "Stunned", 5);
						Clockwork.datastream:Start(self, "PlaySound", "possession/1shot_creep_01.wav");
						self:GiveTrait("possessed");
					end
				elseif newAmount >= 66 and currentAmount < 66 then
					Clockwork.chatBox:Add(self, nil, "itnofake", "You cannot help but feel as though the lands are corrupting your soul.");
				end;
			end
		end
		
		if !self:GetCharacterData(need) then
			self:SetCharacterData(need, 0);
		end
			
		self:SetCharacterData(need, math.Clamp(newAmount, 0, 100));
		self:SetSharedVar(need, math.Clamp(math.Round(newAmount), 0, 100));
	end
end

-- A function to get the player's need level.
function playerMeta:GetNeed(need)
	if need and table.HasValue(cwCharacterNeeds.Needs, need) then
		return tonumber(self:GetCharacterData(need, 0));
	end
end

-- A function to get the player's need level.
function playerMeta:SetNeed(need, value)
	if need and table.HasValue(cwCharacterNeeds.Needs, need) then
		self:SetCharacterData(need, math.Clamp(value, 0, 100));
		self:SetSharedVar(need, math.Clamp(value, 0, 100));
	end
end