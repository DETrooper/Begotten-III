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

function cwPickupObjects:ActionStopped(player, action)
	if player.PickingUpObject then
		if (IsValid(player.PickingUpObject)) then
			player.PickingUpObject:SetNetVar("IsBeingPickedUp", false);
			player.PickingUpObject.BeingPickedUp = nil;
		end;
		
		player.PickingUpObject = nil;
	end
end;

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
						local class = entity:GetClass();
						
						if (class == "prop_ragdoll") then
							if (Clockwork.player:GetAction(player) != "pickupragdoll") then
								local ragdollPlayer = Clockwork.entity:GetPlayer(entity)

								if (ragdollPlayer) and !ragdollPlayer:GetNetVar("IsDragged") and !ragdollPlayer.BeingPickedUp then
									if ragdollPlayer:Alive() then
										if ragdollPlayer.possessor then
											Schema:EasyText(player, "chocolate", "No matter how hard you try you can't seem to hold this person down!");
											return;
										end
									
										if ragdollPlayer.stabilityStunned and !player:HasBelief("wrestle_subdue") then
											if ragdollPlayer:GetNetVar("tied") == 0 then
												Schema:EasyText(player, "chocolate", "You cannot pick up this person while they are knocked over from low stability unless they are tied up or you have the 'Wrestle and Subdue' belief!");
												return;
											end
										end
									end
									
									ragdollPlayer:SetNetVar("IsBeingPickedUp", true);
									player.PickingUpObject = ragdollPlayer;
									ragdollPlayer.BeingPickedUp = true;
									ragdollPlayer.PickedUpBy = player;
									
									if Clockwork.player:GetAction(ragdollPlayer) == "unragdoll" and (ragdollPlayer:GetRagdollState() ~= RAGDOLL_KNOCKEDOUT or ragdollPlayer.sleepData) then
										if ragdollPlayer.sleepData then
											ragdollPlayer.sleepData = nil;
										end
									
										hook.Run("PlayerCancelGetUp", ragdollPlayer);
										Clockwork.player:SetUnragdollTime(ragdollPlayer, nil);
									end
									
									if player.cloaked then
										player:Uncloak();
									end
									
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
											player.PickingUpObject = nil;
										end
										
										if (IsValid(ragdollPlayer)) then
											ragdollPlayer:SetNetVar("IsBeingPickedUp", false);
											ragdollPlayer.BeingPickedUp = nil;
										end;
									end);
								elseif !ragdollPlayer and entity:GetPhysicsObject():IsMoveable() and !IsValid(entity.cwHoldingGrab) and !entity.BeingPickedUp then
									entity:SetNetVar("IsBeingPickedUp", true);
									player.PickingUpObject = entity;
									entity.BeingPickedUp = true;
									entity.PickedUpBy = player;
									
									Clockwork.chatBox:AddInTargetRadius(player, "me", "starts picking up the body before them.", player:GetPos(), config.Get("talk_radius"):Get() * 2);
									
									local pickupTime = 5;
									
									if player.HasBelief and player:HasBelief("dexterity") then
										pickupTime = 3;
									end
									
									if player.cloaked then
										player:Uncloak();
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
											player.PickingUpObject = nil;
										end
										
										if (IsValid(entity)) then
											entity:SetNetVar("IsBeingPickedUp", false);
											entity.BeingPickedUp = nil;
										end;
									end);
								end;
							end;
						elseif !entity.BeingPickedUp then
							if !entity.instantPickupOverride and entity:GetPhysicsObject():IsMoveable() and entity:GetPhysicsObject():GetMass() > 15 and !IsValid(entity.cwHoldingGrab) and !entity.BeingPickedUp then
								entity:SetNetVar("IsBeingPickedUp", true);
								player.PickingUpObject = entity;
								entity.BeingPickedUp = true;
								entity.PickedUpBy = player;
								
								local objectName = "object";
								local customName = entity:GetNetworkedString("Name");

								if (customName and customName != "") then
									objectName = customName;
								elseif cwStorage and cwStorage.containerList[entity:GetModel()] then
									objectName = cwStorage.containerList[entity:GetModel()][2] or "object";
								end
								
								Clockwork.chatBox:AddInTargetRadius(player, "me", "starts picking up the "..objectName.." before them.", player:GetPos(), config.Get("talk_radius"):Get() * 2);
								
								local pickupTime = math.min(10, entity:GetPhysicsObject():GetMass() / 5);
								
								if player.HasBelief and player:HasBelief("dexterity") then
									pickupTime = pickupTime * 0.67;
								end
								
								if player.cloaked then
									player:Uncloak();
								end
								
								Clockwork.player:SetAction(player, "pickupobject", pickupTime, 5, function()
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
										player.PickingUpObject = nil;
									end
									
									if (IsValid(entity)) then
										entity:SetNetVar("IsBeingPickedUp", false);
										entity.BeingPickedUp = nil;
									end;
								end);
							else
								self:ForcePickup(player, entity, trace);
							end;
						end
					elseif (bIsDoor) then
						local hands = player:GetActiveWeapon();
						hands:SecondaryAttack();
					end;
				end;
			elseif (key == IN_ATTACK) then
				local action = Clockwork.player:GetAction(player);
				
				if (action == "pickupragdoll" or action == "pickupobject") then
					if (IsValid(player.PickingUpObject)) then
						player.PickingUpObject:SetNetVar("IsDragged", false);
						player.PickingUpObject:SetNetVar("IsBeingPickedUp", false);
						player.PickingUpObject.BeingPickedUp = nil;
						player.PickingUpObject.PickedUpBy = nil;
						
						if player.PickingUpObject:GetClass() == "prop_ragdoll" then
							Clockwork.chatBox:AddInTargetRadius(player, "me", "releases their grip on the body before them.", player:GetPos(), config.Get("talk_radius"):Get() * 2);
						else
							Clockwork.chatBox:AddInTargetRadius(player, "me", "releases their grip on the object before them.", player:GetPos(), config.Get("talk_radius"):Get() * 2);
						end
					end;
					
					player.NextPickup = CurTime() + 1;
					player.PickingUpObject = nil;
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
	
	if player.teleporting then
		Schema:EasyText(player, "grey", "You cannot interact with entities while in the process of teleporting!");
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