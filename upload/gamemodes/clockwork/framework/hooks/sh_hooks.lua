--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

do
	local playerMeta = FindMetaTable("Player")
	local entMeta = FindMetaTable("Entity")
	entMeta.oldSetModel = entMeta.oldSetModel or entMeta.SetModel

	function entMeta:IsStuck()
		return util.TraceEntity({
			start = self:GetPos(),
			endpos = self:GetPos(),
			filter = self
		}, self).StartSolid
	end

	function playerMeta:SetModel(strPath)
		local oldModel = self:GetModel()

		hook.Run("PlayerModelChanged", self, strPath, oldModel)

		if (SERVER) then
			netstream.Start(nil, "PlayerModelChanged", self:EntIndex(), strPath, oldModel)
		end

		return self:oldSetModel(strPath)
	end

	local animCache = {}
	
	function GM:EntityEmitSound(soundData)
		if (!soundData.Entity:IsPlayer()) then
			return;
		end;
		
		local soundName = soundData.OriginalSoundName;
		local blockedSuffixes = {".stepleft", ".stepright"};
		
		for k, v in pairs(blockedSuffixes) do
			if (soundName:sub(-#v) == v) then
				return false;
			end;
		end;
	end

	function GM:PlayerModelChanged(player, strNewModel, strOldModel)
		if (CLIENT) then
			player:SetIK(false)
		end

		if (!animCache[strNewModel]) then
			animCache[strNewModel] = Clockwork.animation:GetTable(strNewModel)
		end

		player.cwAnimTable = animCache[strNewModel]
		
		if (SERVER) then
			local hands = player:GetHands()
			
			if (IsValid(hands) and hands:IsValid()) then
				self:PlayerSetHandsModel(player, player:GetHands())
			end
		end
	end

	local vectorAngle = FindMetaTable("Vector").Angle
	local normalizeAngle = math.NormalizeAngle
	
	-- Called when the player's jumping animation should be handled.
	function GM:HandlePlayerJumping(player, velocity, plyTable)
		if (player:GetMoveType() == MOVETYPE_NOCLIP) then
			plyTable.m_bJumping = false;
			return;
		end;
		
		local curTime = CurTime();

		if (!plyTable.m_bJumping && !player:OnGround() && player:WaterLevel() <= 0) then
			if (!plyTable.m_fGroundTime) then
				plyTable.m_fGroundTime = curTime;
			elseif (curTime - plyTable.m_fGroundTime) > 0 then
				plyTable.m_bJumping = true;
				plyTable.m_bFirstJumpFrame = false;
				plyTable.m_flJumpStartTime = 0;
			end;
		end;
		
		if (plyTable.m_bJumping) then
			if (plyTable.m_bFirstJumpFrame) then
				plyTable.m_bFirstJumpFrame = false;
				player:AnimRestartMainSequence();
			end;
			
			if (player:WaterLevel() >= 2 ) ||	((curTime - plyTable.m_flJumpStartTime) > 0.2 && player:OnGround()) then
				plyTable.m_bJumping = false;
				plyTable.m_fGroundTime = nil;
				player:AnimRestartMainSequence();
			end;
			
			if (plyTable.m_bJumping) then
				plyTable.CalcIdeal = Clockwork.animation:GetForModel(player:GetModel(), "normal", "glide");
				return true;
			end;
		end;
		
		return false;
	end;

	-- Called when the player's ducking animation should be handled.
	function GM:HandlePlayerDucking(player, velocity, plyTable)
		if (player:Crouching()) then
			local model = player:GetModel();
			local weapon = player:GetActiveWeapon();
			local velLength = velocity:Length2D();
			local weaponHoldType = "pistol";
			
			if (IsValid(weapon)) then
				weaponHoldType = Clockwork.animation:GetWeaponHoldType(player, weapon);
			end;

			if (velLength > 0.5) then
				plyTable.CalcIdeal = Clockwork.animation:GetForModel(model, weaponHoldType, "walk_crouch");
			else
				plyTable.CalcIdeal = Clockwork.animation:GetForModel(model, weaponHoldType, "idle_crouch");
			end;

			return true;
		end;
		
		return false;
	end;

	-- Called when the player's swimming animation should be handled.
	function GM:HandlePlayerSwimming(player, velocity, plyTable)
		if (player:WaterLevel() >= 2) then
			if (plyTable.m_bFirstSwimFrame) then
				player:AnimRestartMainSequence();
				plyTable.m_bFirstSwimFrame = false;
			end;
			
			plyTable.m_bInSwim = true;
		else
			plyTable.m_bInSwim = false;
			
			if (!plyTable.m_bFirstSwimFrame) then
				plyTable.m_bFirstSwimFrame = true;
			end;
		end;
		
		return false;
	end;

	-- Called when the player's driving animation should be handled.
	function GM:HandlePlayerDriving(player, plyTable)
		if (player:InVehicle()) then
			plyTable.CalcIdeal = Clockwork.animation:GetForModel(player:GetModel(), "normal", "idle_crouch")[1];
			return true;
		end;
		
		return false;
	end;
		
	-- Called when a player's animation is updated.
	function GM:UpdateAnimation(player, velocity, maxSeqGroundSpeed)
		local velLength = velocity:Length2D();
		local rate = 1.0;
		
		if (velLength > 0.5) then
			rate = ((velLength * 0.8) / maxSeqGroundSpeed);
		end

		player.cwPlaybackRate = math.Clamp(rate, 0, 1.5);
		player:SetPlaybackRate(player.cwPlaybackRate);

		if (player:InVehicle() and CLIENT) then
			local vehicle = player:GetVehicle();
			
			if (IsValid(vehicle)) then
				local velocity = vehicle:GetVelocity();
				local steer = (vehicle:GetPoseParameter("vehicle_steer") * 2) - 1;
				
				player:SetPoseParameter("vertical_velocity", velocity.z * 0.01);
				player:SetPoseParameter("vehicle_steer", steer);
			end;
		end;
	end;

	local IdleActivity = ACT_HL2MP_IDLE;
	local IdleActivityTranslate = {
		[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] = IdleActivity + 5,
		[ACT_MP_ATTACK_STAND_PRIMARYFIRE] = IdleActivity + 5,
		[ACT_MP_RELOAD_CROUCH] = IdleActivity + 6,
		[ACT_MP_RELOAD_STAND] = IdleActivity + 6,
		[ACT_MP_CROUCH_IDLE] = IdleActivity + 3,
		[ACT_MP_STAND_IDLE] = IdleActivity,
		[ACT_MP_CROUCHWALK] = IdleActivity + 4,
		[ACT_MP_JUMP] = ACT_HL2MP_JUMP_SLAM,
		[ACT_MP_WALK] = IdleActivity + 1,
		[ACT_MP_RUN] = IdleActivity + 2,
	};
		-- Called when a player's activity is supposed to be translated.
	function GM:TranslateActivity(player, act)
		--[[local model = player:GetModel();
		local bIsRaised = Clockwork.player:GetWeaponRaised(player, true);
		
		if (string.find(model, "/player/")) then
			local activeWeapon = player:GetActiveWeapon();
			local newAct = player:TranslateWeaponActivity(act);
			local weaponClass;
			
			if IsValid(activeWeapon) then
				weaponClass = activeWeapon:GetClass();
			end
			
			if (!bIsRaised or act == newAct or weaponClass == "cw_adminasstool" or weaponClass == "cw_senses" or weaponClass == "cw_keys") then
				return IdleActivityTranslate[act];
			else
				return newAct;
			end;
		end;]]--
		
		return act;
	end;

	-- Called when the main activity should be calculated.
	function GM:CalcMainActivity(player, velocity)
		local model = player:GetModel();
		local plyTable = player:GetTable();
		
		--if (string.find(model, "/player/")) then
			--return self.BaseClass:CalcMainActivity(player, velocity);
		--end;
		
		local weapon = player:GetActiveWeapon();
		local weaponClass;
		local bIsRaised = Clockwork.player:GetWeaponRaised(player, true);
		local weaponHoldType = "normal";
		local forcedAnimation = player:GetForcedAnimation();

		if (IsValid(weapon)) then
			weaponHoldType = Clockwork.animation:GetWeaponHoldType(player, weapon);
			weaponClass = weapon:GetClass();
		end;
		
		local act = Clockwork.animation:GetForModel(model, weaponHoldType, "idle") or ACT_IDLE;
		local oldact = plyTable.CalcIdeal;
		local seq = -1;
		
		if (!self:HandlePlayerDriving(player, plyTable)
		and !self:HandlePlayerJumping(player, velocity, plyTable)
		and !self:HandlePlayerDucking(player, velocity, plyTable)
		and !self:HandlePlayerSwimming(player, velocity, plyTable)
		and !self:HandlePlayerNoClipping(player, velocity, plyTable)
		and !self:HandlePlayerVaulting(player, velocity, plyTable)) then
			if (player:IsRunning()) then
				act = Clockwork.animation:GetForModel(model, weaponHoldType, "run");
			elseif (velocity:Length2DSqr() > 0.25) then
				act = Clockwork.animation:GetForModel(model, weaponHoldType, "walk");
			end;
		else
			act = plyTable.CalcIdeal;
		end;
		
		if (type(act) == "table") then
			if (bIsRaised and weaponClass ~= "cw_senses" and weaponClass ~= "cw_keys" and weaponClass ~= "cw_adminasstool") then
				act = act[2];
			else
				act = act[1];
			end;
		end;

		if (type(seq) == "string") then
			seq = player:LookupSequence(seq);
		end;
		
		if (type(act) == "string") then
			seq = player:LookupSequence(act);
		end;

		if (forcedAnimation) then
			seq = forcedAnimation.animation;
			
			if (forcedAnimation.OnAnimate) then
				forcedAnimation.OnAnimate(player);
				forcedAnimation.OnAnimate = nil;
			end;
		end;
		
		local newIdeal, newCalcSeqOverride = hook.Run("ModifyCalcMainActivity", player, velocity);
		
		if newCalcSeqOverride then
			return newIdeal, newCalcSeqOverride;
		end

		if (CLIENT) then
			player:SetIK(false);
		end;
		
		local eyeAngles = player:EyeAngles();
		local yaw = velocity:Angle().yaw;
		local normalized = math.NormalizeAngle(yaw - eyeAngles.y);

		player:SetPoseParameter("move_yaw", normalized);
		
		if !player:InVehicle() then
			-- part of wOS, moved here for optimization purposes
			if wOS then
				local translation = wOS.AnimExtension.TranslateHoldType[weaponHoldType];

				if translation then
					--local ATTACK_DATA = translation:GetActData(act)
					local ATTACK_DATA;
					local base = translation.Translations[act]
					
					if base then
						ATTACK_DATA = {}
						
						if istable( base ) then
							if base.Sequence then
								ATTACK_DATA.Sequence = base.Sequence
								ATTACK_DATA.Weight = base.Weight or 1
							else
								local key = math.Round( util.SharedRandom( "wOS.AnimExtension." .. translation:GetName() .. "[" .. act .. "]", 1, #base ) )
								local innerbase = base[key]
								if istable( innerbase ) then
									ATTACK_DATA = innerbase
								elseif isstring( innerbase ) then
									ATTACK_DATA.Sequence = innerbase
									ATTACK_DATA.Weight = 1
								end
							end
						elseif isstring( base ) then
							ATTACK_DATA.Sequence = base
						end
					end
					
					if ATTACK_DATA then
						seq = player:LookupSequence(ATTACK_DATA.Sequence)
					end
				end
			end
		end
		
		if act != oldact then
			player:SetCycle(0)
		end
		
		plyTable.CalcIdeal = act;
		plyTable.CalcSeqOverride = seq;
		
		return act, seq;
	end;

	-- Called when the animation event is supposed to be done.
	function GM:DoAnimationEvent(player, event, data)
		local model = player:GetModel();
		
		--[[if (string.find(model, "/player/")) then
			return self.BaseClass:DoAnimationEvent(player, event, data);
		end;]]--
		
		local weapon = player:GetActiveWeapon();
		local weaponHoldType = "normal";
		
		if (IsValid(weapon)) then
			weaponHoldType = Clockwork.animation:GetWeaponHoldType(player, weapon);
		end;

		if (event == PLAYERANIMEVENT_ATTACK_PRIMARY) then
			local attackAnimation = Clockwork.animation:GetForModel(model, weaponHoldType, "attack", true);

			if (!attackAnimation) then
				attackAnimation = ACT_GESTURE_RANGE_ATTACK_SMG1;
			end;

			player:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, attackAnimation, true);
			return ACT_VM_PRIMARYATTACK;
		elseif (event == PLAYERANIMEVENT_ATTACK_SECONDARY) then
			local attackAnimation = Clockwork.animation:GetForModel(model, weaponHoldType, "attack", true);

			if (!attackAnimation) then
				attackAnimation = ACT_GESTURE_RANGE_ATTACK_SMG1;
			end;

			player:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, attackAnimation, true);
			return ACT_VM_SECONDARYATTACK;
		elseif (event == PLAYERANIMEVENT_RELOAD) then
			local reloadAnimation = Clockwork.animation:GetForModel(model, weaponHoldType, "reload", true);

			if (!reloadAnimation) then
				reloadAnimation = ACT_GESTURE_RELOAD_SMG1;
			end;

			player:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, reloadAnimation, true);
			return ACT_INVALID;
		elseif (event == PLAYERANIMEVENT_JUMP) then
			player:AnimRestartMainSequence();
			return ACT_INVALID;
		elseif (event == PLAYERANIMEVENT_CANCEL_RELOAD) then
			player:AnimResetGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD);
			return ACT_INVALID;
		end;

		return nil;
	end;

	function GM:MouthMoveAnimation(player)
		return;
	end

	-- Called when the gamemode has been reloaded by AutoRefresh.
	function GM:OnReloaded()
		Clockwork.Reloaded = true

		if (SERVER) then
			if (!self.nextDatabaseConnect or self.nextDatabaseConnect <= CurTime()) then
				self.nextDatabaseConnect = CurTime() + 1;
				Clockwork.database:OnConnected()
			end;
			
			MsgC(Color(0, 0, 255), "[Clockwork]", Color(192, 192, 192), " OnReloaded hook called serverside!\n")
		else
			Clockwork.kernel:PrintColoredText(Clockwork.kernel:GetLogTypeColor(LOGTYPE_MINOR), "Clockwork has AutoRefreshed clientside!")
			printp("Clockwork has AutoRefreshed!")
		end
	end
end;