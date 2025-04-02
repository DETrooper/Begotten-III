-- Called when Clockwork has loaded all of the entities.
function cwPowerArmor:ClockworkInitPostEntity()
	self:LoadPowerArmors();
end;

-- Called just after data should be saved.
function cwPowerArmor:PostSaveData()
	self:SavePowerArmors();
end

local servoSounds = {
	"npc/dog/dog_idle1.wav",
	"npc/dog/dog_idle2.wav",
	"npc/dog/dog_idle4.wav",
	"npc/dog/dog_idle5.wav"
}

local jumpServoSounds = {
	"npc/dog/dog_servo1.wav",
	"npc/dog/dog_servo10.wav",
	"npc/dog/dog_servo12.wav",
	"npc/dog/dog_servo2.wav",
	"npc/dog/dog_servo6.wav"
};

-- Called at an interval while a player is connected.
function cwPowerArmor:PlayerThink(player, curTime, infoTable, alive, initialized, plyTab)
	if (alive and initialized) then
		if (!plyTab.nextWearingPowerArmor or plyTab.nextWearingPowerArmor < curTime) then
			plyTab.nextWearingPowerArmor = curTime + 2.5;
			plyTab.wearingPowerArmor = player:IsWearingPowerArmor();
		end;

		if (!plyTab.cwObserverMode) then
			if (plyTab.wearingPowerArmor) then
				if (!plyTab.nextServo or plyTab.nextServo < curTime) then
					player:EmitSound(servoSounds[math.random(1, #servoSounds)]);
					plyTab.nextServo = curTime + math.random(5, 15);
				end;
				
				if (!plyTab.nextChargeDepleted) then
					plyTab.nextChargeDepleted = curTime + 120;
				elseif (plyTab.nextChargeDepleted < curTime) then
					local currentCharge = player:GetCharacterData("battery", 0);
						player:SetCharacterData("battery", math.Clamp(currentCharge - 1, 0, 100));
						player:SetNetVar("battery", math.Round(player:GetCharacterData("battery", 0), 0));
					plyTab.nextChargeDepleted = curTime + 120;
				end

				if (!plyTab.nextFireCheck or plyTab.nextFireCheck < curTime) then
					plyTab.nextFireCheck = curTime + 0.5;
					
					if (player:IsOnFire()) then
						player:Extinguish();
					end;
				end;
			end;
		end;
	end;
end;

function cwPowerArmor:KeyRelease(player, key)
	if (key == IN_DUCK) then
		local curTime = CurTime();
		
		if (!player.nextCrouchOut or player.nextCrouchOut < curTime) then
			if (player.wearingPowerArmor and !player.cwObserverMode) then
				player.nextCrouchOut = curTime + 0.25;
				player:EmitSound("npc/dog/dog_pneumatic2.wav");
			end;
		end;
	end;
end;

function cwPowerArmor:PostPlayerSpawn(player)	
	if (player:HasInitialized()) then
		local powerArmor = player:GetCharacterData("powerArmor");

		if powerArmor then
			local clothesItem = player:GetClothesEquipped();
			
			if clothesItem then
				clothesItem:OnPlayerUnequipped(player, nil, true);
			end;
			
			local helmetItem = player:GetHelmetEquipped();
			
			if helmetItem then
				helmetItem:OnPlayerUnequipped(player);
			end
		
			player.wearingPowerArmor = true;
			player:SetModel(powerArmor);
			player.nextChargeDepleted = CurTime() + 120;
			player:SetNetVar("battery", math.Round(player:GetCharacterData("battery", 0), 0));
		elseif player.wearingPowerArmor then
			player.wearingPowerArmor = false;
		end
	end
end

function cwPowerArmor:PostPlayerDeath(player)
	if not player.opponent then
		if (player.wearingPowerArmor) then
			local ragCorpse = player:GetRagdollEntity();
			
			if IsValid(ragCorpse) then
				Clockwork.plugin:Call("BuildUp", ragCorpse, true);
			end
			
			player.wearingPowerArmor = false;
			player:SetCharacterData("battery", 0);
			player:SetNetVar("battery", 0);
			player:SetCharacterData("powerArmor", nil);
		end;
	end;
end;

-- Called whenever a player presses a key.
function cwPowerArmor:KeyPress(player, key)
	if (key == IN_DUCK) then
		local curTime = CurTime();
		
		if (!player.nextCrouchIn or player.nextCrouchIn < curTime) then
			player.nextCrouchIn = curTime + 0.25;
			
			if (player:Alive() and player:HasInitialized() and !player.cwObserverMode) then
				if (player.wearingPowerArmor) then
					player:EmitSound("npc/dog/dog_pneumatic1.wav");
				end;
			end;
		end;
	end;
	
	if (key == IN_JUMP) then
		if (player.wearingPowerArmor or Clockwork.player:HasFlags(player, "T")) and !player:IsOnGround() and player.FirstJump >= 1 and player:GetMoveType() != MOVETYPE_NOCLIP then
			if player.FirstJump == 1 then
				player:SetVelocity(Vector(0,0,500) + Vector(0,0,-1*player:GetVelocity().z));
				player:EmitSound("weapons/grenade_launcher1.wav");
				player.FirstJump = 2;

				local vPoint = player:GetPos();
				local effectdata = EffectData();
				effectdata:SetOrigin( vPoint );
				effectdata:SetMagnitude(1);
				effectdata:SetNormal(Vector(0,0,-1));
				effectdata:SetRadius(50);
				effectdata:SetScale(15);
				util.Effect( "AR2Explosion", effectdata, true, true );

				local vPoint = player:GetPos();
				local effectdata = EffectData();
				effectdata:SetOrigin( vPoint );
				effectdata:SetMagnitude(1);
				effectdata:SetNormal(Vector(0,0,-1));
				effectdata:SetRadius(30);
				effectdata:SetScale(150);
				util.Effect( "ThumperDust", effectdata, true, true );
			elseif player.FirstJump == 2 and Clockwork.player:HasFlags(player, "?") then
				player:SetVelocity(Vector(0,0,1000) + Vector(0,0,-1*player:GetVelocity().z));
				player:EmitSound("weapons/grenade_launcher1.wav");
				player.FirstJump = 2;

				local vPoint = player:GetPos();
				local effectdata = EffectData();
				effectdata:SetOrigin( vPoint );
				effectdata:SetMagnitude(1);
				effectdata:SetNormal(Vector(0,0,-1));
				effectdata:SetRadius(50);
				effectdata:SetScale(15);
				util.Effect( "AR2Explosion", effectdata, true, true );

				local vPoint = player:GetPos();
				local effectdata = EffectData();
				effectdata:SetOrigin( vPoint );
				effectdata:SetMagnitude(1);
				effectdata:SetNormal(Vector(0,0,-1));
				effectdata:SetRadius(30);
				effectdata:SetScale(150);
				util.Effect( "ThumperDust", effectdata, true, true );
			end;

		else
			player.FirstJump = 1;

		end

		local curTime = CurTime();
		
		if (!player.nextJumpServo or player.nextJumpServo < curTime) then
			player.nextJumpServo = curTime + 1;
			
			if (player:Alive() and player:HasInitialized() and !player.cwObserverMode) then
				if (player:IsOnGround() and player:GetMoveType() != MOVETYPE_NOCLIP) then
					if (player.wearingPowerArmor) then
						player:EmitSound(jumpServoSounds[math.random(1, #jumpServoSounds)]);
						util.ScreenShake(player:GetPos(), 2, 1, 0.5, 750)
					end;
				end;
			end;
		end;
	end;
end;

-- Called when a player makes contact with the ground.
function cwPowerArmor:OnPlayerHitGround(player, inWater, onFloater, speed)
	if (player:Alive() and player:HasInitialized() and !player.cwObserverMode) then
		if (player.wearingPowerArmor) then
			player:EmitSound("npc/dog/dog_footstep_run"..math.random(1, 8)..".wav");
			
			local position = player:GetPos();
			
			if (isnumber(speed) and (speed > 500)) then
				player:EmitSound("physics/concrete/boulder_impact_hard"..math.random(1, 4)..".wav");
				util.ScreenShake(position, 5, 5, 2, 750)
				
				Clockwork.plugin:Call("DoPowerArmorTesla", player, false, true);
				
				timer.Create(player:EntIndex().."_fallSpark", 1, math.random(2, 5), function()
					Clockwork.plugin:Call("DoPowerArmorTesla", player, false, true);
				end);
				
				local groundEntity = player:GetGroundEntity();
				
				if (groundEntity and IsValid(groundEntity) and !groundEntity:IsWorld()) then
					local damageInfo = DamageInfo(); 
						damageInfo:SetDamage(math.random(20, 40)); 
						damageInfo:SetDamageType(DMG_CRUSH);
						damageInfo:SetAttacker(player);
						damageInfo:SetInflictor(player);
						damageInfo:SetDamageForce(Vector(0, 0, speed * - 100) + (player:GetVelocity()));
					groundEntity:TakeDamageInfo(damageInfo);
				end;
				
				if (!groundEntity:IsWorld()) then
					groundEntity:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav");
				end;
			else
				local curTime = CurTime();
				
				if (!player.nextHitGroundShake or curTime > player.nextHitGroundShake) then
					player.nextHitGroundShake = curTime + 1;
					
					timer.Simple(1, function()
						player:EmitSound("npc/dog/dog_idle5.wav");
					end);
					
					util.ScreenShake(position, 2, 1, 0.5, 750)
				end;
			end;
		end;
	end;
end;

-- Called when a player needs to fall over from fall damage.
function cwPowerArmor:PlayerCanFallOverFromFallDamage(player)
	if (player.wearingPowerArmor) then
		return false;
	end;
end;

-- Called when a player has been unragdolled.
function cwPowerArmor:PlayerUnragdolled(player, state, ragdoll)
	if (player.wearingPowerArmor) then
		player:EmitSound("npc/dog/dog_servo7.wav")
	end;
end;

-- Called when a player has been ragdolled.
function cwPowerArmor:PlayerRagdolled(player, state, ragdoll)
	if (player.wearingPowerArmor) then
		player:EmitSound("npc/dog/dog_straining"..math.random(1, 3)..".wav")
	end;
end;

-- Called when a player takes damage.
function cwPowerArmor:EntityTakeDamageArmor(player, damageInfo)
	local bIsPlayer = player:IsPlayer() and player:HasInitialized();
	
	if (bIsPlayer) then
		if (player.wearingPowerArmor and not player.cwObserverMode) then
			local currentCharge = player:GetCharacterData("battery", 0);
			
			if (currentCharge > 0) then
				if (!player.nextPainServo or player.nextPainServo < CurTime()) then
					player:EmitSound("npc/dog/dog_servo"..math.random(1, 8)..".wav");
					
					player.nextPainServo = CurTime() + 5;
				end;
				
				local newBattery = math.Clamp(currentCharge - math.Round((damageInfo:GetDamage() / 25)), 0, 100);
				
				player:SetCharacterData("battery", newBattery);
				player:SetNetVar("battery", newBattery);
				
				damageInfo:ScaleDamage(0);
			end
		end;
	end
end;

-- A function to scale damage by hit group.
function cwPowerArmor:PlayerScaleDamageByHitGroup(player, attacker, hitGroup, damageInfo, baseDamage)
	if (player.wearingPowerArmor and !player.cwObserverMode) then
		local currentCharge = player:GetCharacterData("battery", 0);
		
		if currentCharge > 0 then
			if (damageInfo:GetDamageType() == DMG_FALL) then
				damageInfo:ScaleDamage(0);
			end;
		end
	end;
end;

function cwPowerArmor:ModifyPlayerSpeed(player, infoTable)
	if (player.wearingPowerArmor and !player.cwObserverMode) then
		local currentCharge = player:GetCharacterData("battery", 0);
		
		if currentCharge > 0 then
			infoTable.jumpPower = infoTable.jumpPower * 2.5;
			infoTable.runSpeed = infoTable.runSpeed * 0.70;
		else
			infoTable.jumpPower = 1;
			infoTable.runSpeed = infoTable.walkSpeed;
		end
	end
end;

-- Called when a player's character screen info should be adjusted.
function cwPowerArmor:PlayerAdjustCharacterScreenInfo(player, character, info)
	if character.data["powerArmor"] then
		info.model = character.data["powerArmor"];
	end
end