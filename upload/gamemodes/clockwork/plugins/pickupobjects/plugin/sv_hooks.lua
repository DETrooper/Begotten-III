--[[
	Begotten III: Jesus Wept
--]]

-- Called when a player's character has unloaded.
function cwPickupObjects:PlayerCharacterUnloaded(player)
	self:ForceDropEntity(player);
end;

-- Called to get the entity that a player is holding.
function cwPickupObjects:PlayerGetHoldingEntity(player)
	if (IsValid(player.cwHoldingEnt)) then
		return player.cwHoldingEnt;
	end;
end;

-- Called when a player attempts to throw a punch.
function cwPickupObjects:PlayerCanThrowPunch(player)
	if (IsValid(player.cwHoldingEnt) or (player.nextPunchTime
	and player.nextPunchTime >= CurTime())) then
		return false;
	end;
end;

-- Called when a player's weapons should be given.
function cwPickupObjects:PlayerGiveWeapons(player)
	--[[if (Clockwork.config:Get("take_physcannon"):Get()) then
		Clockwork.player:TakeSpawnWeapon(player, "weapon_physcannon");
	end;]]--
end;

-- Called to get whether an entity is being held.
function cwPickupObjects:GetEntityBeingHeld(entity)
	if (IsValid(entity.cwHoldingGrab) and !entity:IsPlayer()) then
		return true;
	end;
end;

-- Called when Clockwork config has changed.
function cwPickupObjects:ClockworkConfigChanged(key, data, previousValue, newValue)
	--[[if (key == "take_physcannon") then
		for k, v in pairs(cwPlayer.GetAll()) do
			if (newValue) then
				Clockwork.player:TakeSpawnWeapon(v, "weapon_physcannon");
			else
				Clockwork.player:GiveSpawnWeapon(v, "weapon_physcannon");
			end;
		end;
	end;]]--
end;

-- Called just after a player spawns.
function cwPickupObjects:PostPlayerSpawn(player, lightSpawn, changeClass, firstSpawn)
	Clockwork.player:SetAction(player, "pickupragdoll", false);
	
	if player.PickingUpRagdoll then
		player:SetNWBool("PickingUpRagdoll", false);
		
		if (IsValid(player.PickingUpRagdoll)) then
			player.PickingUpRagdoll:SetNetVar("IsBeingPickedUp", false);
			player.PickingUpRagdoll.BeingPickedUp = nil;
		end;
		
		player.PickingUpRagdoll = nil;
	end
end

-- Called when a player dies.
function cwPickupObjects:PlayerDeath(player, inflictor, attacker, damageInfo)
	Clockwork.player:SetAction(player, "pickupragdoll", false);
	
	if player.PickingUpRagdoll then
		player:SetNWBool("PickingUpRagdoll", false);
		
		if (IsValid(player.PickingUpRagdoll)) then
			player.PickingUpRagdoll:SetNetVar("IsBeingPickedUp", false);
			player.PickingUpRagdoll.BeingPickedUp = nil;
		end;
		
		player.PickingUpRagdoll = nil;
	end
end

-- Called when a player enters a vehicle.
function cwPickupObjects:PlayerEnteredVehicle(player, vehicle, class)
	if (IsValid(player.cwHoldingEnt) and player.cwHoldingEnt == vehicle) then
		self:ForceDropEntity(player);
	end;
end;

-- Called when a player attempts to get up.
function cwPickupObjects:PlayerCanGetUp(player)
	if (player:GetNetVar("IsDragged")) or (player:GetNetVar("IsBeingPickedUp")) then
		return false;
	end;
end;

function cwPickupObjects:PlayerStartGetUp(player)
	if (player.BeingPickedUp) then
		local attacker = player.PickedUpBy;
		
		if (IsValid(attacker)) then
			Clockwork.player:SetAction(attacker, nil);
			attacker:SetNWBool("PickingUpRagdoll", false);
		end;

		player:SetNetVar("IsDragged", false);
		player:SetNetVar("IsBeingPickedUp", false);
		player.BeingPickedUp = nil;
	end;
end;

-- Called when a player's shared variables should be set.
function cwPickupObjects:OnePlayerHalfSecond(player, curTime)
	if (player:IsRagdolled() and Clockwork.player:GetUnragdollTime(player)) then
		local entity = player:GetRagdollEntity();
		
		if (IsValid(entity)) then
			if (IsValid(entity.cwHoldingGrab) or entity:IsBeingHeld()) then
				Clockwork.player:PauseUnragdollTime(player);
				
				player:SetNetVar("IsDragged", true);
			elseif (player:GetNetVar("IsDragged")) then
				Clockwork.player:StartUnragdollTime(player);
				
				player:SetNetVar("IsDragged", false);
			end;
		else
			player:SetNetVar("IsDragged", false);
			player:SetNetVar("IsBeingPickedUp", false);
		end;
	elseif (player:GetNetVar("IsDragged")) then
		player:SetNetVar("IsDragged", false);
		player:SetNetVar("IsBeingPickedUp", false);
	end;
end;

local sex = (96 * 96)

-- Called when a player presses a key.
function cwPickupObjects:KeyPress(player, key)
	if (player:IsUsingHands() and !player:IsRagdolled()) then
		if (!IsValid(player.cwHoldingEnt)) then
			if (key == IN_ATTACK2) then
				local trace = player:GetEyeTraceNoCursor();
				local entity = trace.Entity;
				local bCanPickup = nil;

				if (IsValid(entity) and trace.HitPos:DistToSqr(player:GetShootPos()) <= sex and !entity:IsPlayer() and !entity:IsNPC() and !entity:IsNextBot()) then
					if (Clockwork.plugin:Call("CanHandsPickupEntity", player, entity, trace)) and (!player.NextPickup or player.NextPickup < CurTime()) then
						bCanPickup = true;
					end;

					local bIsDoor = Clockwork.entity:IsDoor(entity);

					if (bCanPickup and !bIsDoor and !player:InVehicle()) then
						if (entity:GetClass() == "prop_ragdoll") then
							if (Clockwork.player:GetAction(player) != "pickupragdoll") then
								local ragdollPlayer = Clockwork.entity:GetPlayer(entity)

								if (ragdollPlayer) and !ragdollPlayer:GetNetVar("IsDragged") and !ragdollPlayer.BeingPickedUp then
									if ragdollPlayer:Alive() then
										if ragdollPlayer.possessor then
											Schema:EasyText(player, "chocolate", "No matter how hard you try you can't seem to hold this person down!");
											return;
										end
									
										if ragdollPlayer.stabilityStunned and !player:HasBelief("wrestle_subdue") then
											Schema:EasyText(player, "chocolate", "You cannot pick up this person while they are knocked over from low stability unless you have the 'Wrestle and Subdue' belief!");
											return;
										end
									end
									
									--if (Clockwork.player:GetUnragdollTime(ragdollPlayer) != 0) or !ragdollPlayer:Alive() then
										ragdollPlayer:SetNetVar("IsBeingPickedUp", true);
										player.PickingUpRagdoll = ragdollPlayer;
										ragdollPlayer.BeingPickedUp = true;
										ragdollPlayer.PickedUpBy = player;
										
										if Clockwork.player:GetAction(ragdollPlayer) == "unragdoll" and (ragdollPlayer:GetRagdollState() ~= RAGDOLL_KNOCKEDOUT or ragdollPlayer.sleepData) then
											if ragdollPlayer.sleepData then
												ragdollPlayer.sleepData = nil;
											end
										
											hook.Run("PlayerCancelGetUp", ragdollPlayer);
											Clockwork.player:SetUnragdollTime(ragdollPlayer, nil);
										end
										
										player:SetNWBool("PickingUpRagdoll", true);
										Clockwork.chatBox:AddInTargetRadius(player, "me", "starts picking up the body before them.", player:GetPos(), config.Get("talk_radius"):Get() * 2);
										
										local pickupTime = 5;
										
										if player.HasBelief and player:HasBelief("dexterity") then
											pickupTime = 3;
										end

										Clockwork.player:SetAction(player, "pickupragdoll", pickupTime, 5, function()
											if (IsValid(player) and IsValid(entity)) and IsValid(player:GetActiveWeapon()) and player:GetActiveWeapon():GetClass() == "begotten_fists" and (!cwDueling or (cwDueling and !cwDueling:PlayerIsInMatchmaking(player))) then
												self:ForcePickup(player, entity, trace);
												
												if (IsValid(ragdollPlayer)) then
													ragdollPlayer.PickedUpBy = nil;
													ragdollPlayer:SetNetVar("IsDragged", true);
												end
											else
												if (IsValid(ragdollPlayer)) then
													ragdollPlayer.PickedUpBy = nil;
													ragdollPlayer:SetNetVar("IsDragged", false);
												end
											end;
											
											if IsValid(player) then
												player.PickingUpRagdoll = nil;
												player:SetNWBool("PickingUpRagdoll", false);
											end
											
											if (IsValid(ragdollPlayer)) then
												ragdollPlayer:SetNetVar("IsBeingPickedUp", false);
												ragdollPlayer.BeingPickedUp = nil;
											end;
										end);
									--[[else
										Schema:EasyText(player, "peru", "You can't get a grip on this person as they are getting up!")
										return;
									end;]]--
								elseif !ragdollPlayer and entity:GetPhysicsObject():IsMoveable() and !IsValid(entity.cwHoldingGrab) and !entity.BeingPickedUp then
									entity:SetNetVar("IsBeingPickedUp", true);
									player.PickingUpRagdoll = entity;
									entity.BeingPickedUp = true;
									entity.PickedUpBy = player;
									
									player:SetNWBool("PickingUpRagdoll", true);
									Clockwork.chatBox:AddInTargetRadius(player, "me", "starts picking up the body before them.", player:GetPos(), config.Get("talk_radius"):Get() * 2);
									
									local pickupTime = 5;
									
									if player.HasBelief and player:HasBelief("dexterity") then
										pickupTime = 3;
									end
									
									Clockwork.player:SetAction(player, "pickupragdoll", pickupTime, 5, function()
										if (IsValid(player) and IsValid(entity)) then
											self:ForcePickup(player, entity, trace);
											
											if (IsValid(entity)) then
												entity:SetNetVar("IsDragged", true);
											end
										else
											if (IsValid(entity)) then
												entity.PickedUpBy = nil;
												entity:SetNetVar("IsDragged", false);
											end
										end;
										
										if IsValid(player) then
											player.PickingUpRagdoll = nil;
											player:SetNWBool("PickingUpRagdoll", false);
										end
										
										if (IsValid(entity)) then
											entity:SetNetVar("IsBeingPickedUp", false);
											entity.BeingPickedUp = nil;
										end;
									end);
								end;
							end;
						else
							self:ForcePickup(player, entity, trace);
						end;
					elseif (bIsDoor) then
						local hands = player:GetActiveWeapon();
						hands:SecondaryAttack();
					end;
				end;
			elseif (key == IN_ATTACK) then
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
				end;
			end;
		elseif (key == IN_ATTACK) then
			self:ForceThrowEntity(player);
		elseif (key == IN_RELOAD) then
			self:ForceDropEntity(player);
		end;
	end;
end;

-- Called when a player attempts to pickup an object.
function cwPickupObjects:CanHandsPickupEntity(player, entity, trace)
	if (!player:IsAdmin() and player.cwObserverMode) then
		Schema:EasyText(player, "grey", "You cannot interact with entities while in spectator mode!");
		return false;
	end
	
	if cwDueling and cwDueling:PlayerIsInMatchmaking(player) then
		Schema:EasyText(player, "grey", "You cannot interact with entities while in matchmaking for a duel!");
		return false;
	end
	
	if (IsValid(entity:GetPhysicsObject()) and entity:GetSolid() == SOLID_VPHYSICS) then
		if (entity:GetClass() == "prop_ragdoll" or entity:GetPhysicsObject():GetMass() <= 100) then
			if (entity:GetPhysicsObject():IsMoveable() and !IsValid(entity.cwHoldingGrab)) then
				if (!entity.noHandsPickup) then
					if (!Clockwork.player:GetWeaponRaised(player)) then
						return true;
					end;
				end;
			end;
		end;
	end;
end;