if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = "drgbase_nextbot" -- DO NOT TOUCH (obviously)
-- Misc --
ENT.PrintName = "Ironclad"
ENT.Category = "Begotten DRG"
ENT.Models = {"models/begotten/thralls/ironclad.mdl"}
ENT.BloodColor = BLOOD_COLOR_RED
ENT.RagdollOnDeath = true;
-- Sounds --
ENT.OnDamageSounds = {"begotten/npc/grunt/attack_claw01.mp3", "begotten/npc/grunt/attack_claw02.mp3", "begotten/npc/grunt/attack_claw03.mp3"}
ENT.OnDeathSounds = {"begotten/npc/grunt/amb_idle_scratch01.mp3", "begotten/npc/grunt/amb_idle_scratch02.mp3", "begotten/npc/grunt/amb_idle_scratch03.mp3"}
ENT.PainSounds = {"begotten/npc/grunt/attack_launch01.mp3", "begotten/npc/grunt/attack_launch02.mp3"};
-- Stats --
ENT.SpawnHealth = 500
ENT.SpotDuration = 20
ENT.Armor = 90;
ENT.ArmorMaterial = "plate"
-- AI --
ENT.RangeAttackRange = 0
ENT.MeleeAttackRange = 120
ENT.ReachEnemyRange = 90
ENT.AvoidEnemyRange = 0
ENT.HearingCoefficient = 0.5
ENT.SightFOV = 300
ENT.SightRange = 1024
ENT.XPValue = 60;
-- Relationships --
ENT.Factions = {FACTION_ZOMBIES}
-- Movements/animations --
ENT.UseWalkframes = true
ENT.RunAnimation = ACT_WALK
ENT.JumpAnimation = "releasecrab"
ENT.RunAnimRate = 0
-- Climbing --
ENT.ClimbLedges = true
ENT.ClimbProps = true
ENT.ClimbLedgesMaxHeight = 300
ENT.ClimbLadders = true
ENT.ClimbSpeed = 100
ENT.ClimbUpAnimation = "run_all_grenade"--ACT_ZOMBIE_CLIMB_UP --pull_grenade
ENT.ClimbOffset = Vector(-14, 0, 0)
ENT.ArmorPiercing = 60;
ENT.Damage = 60;
-- Detection --
ENT.EyeBone = "ValveBiped.Bip01_Spine4"
ENT.EyeOffset = Vector(7.5, 0, 5)
-- Possession --
ENT.PossessionEnabled = true
ENT.PossessionMovement = POSSESSION_MOVE_8DIR
ENT.PossessionViews = {
	{
		offset = Vector(0, 30, 20),
		distance = 100
	},
	{
		offset = Vector(7.5, 0, 0),
		distance = 0,
		eyepos = true
	}
}

ENT.WalkSpeed = 35;
ENT.RunSpeed = 135;

ENT.Attacks = {
	Standard = 1,
	Rotor = 2,

};

local printTarget = Clockwork.player:FindByID("Manoros");

ENT.AttackFunctions = {
	[ENT.Attacks.Standard] = function(self)
		if self.angry then
			self.MeleeAttackRange = 125;
			self:EmitSound("begotten/npc/grunt/attack_claw0"..math.random(1, 3)..".mp3", 100, self.pitch)
			self:PlaySequenceAndMove("fastattack", 0.6, self.FaceEnemy)
		else
			self.MeleeAttackRange = 120;
			self:EmitSound("begotten/npc/grunt/attack_launch0"..math.random(1, 3)..".mp3", 100, self.pitch)
			self:PlayActivityAndMove(ACT_MELEE_ATTACK1, 1, self.FaceEnemy)
		end

	end,

	[ENT.Attacks.Rotor] = function(self)
		--[[if(SERVER) then printTarget:ChatPrint("Attempting attack...") end

		local success, err = pcall(function()]]
		self.MeleeAttackRange = 45;
		self:SetDesiredSpeed(self.angry and self.RunSpeed or self.WalkSpeed);
		self:EmitSound("begotten/npc/grunt/amb_idle_scratch0"..math.random(1, 3)..".mp3", 100, self.pitch);
		self:PlaySequenceAndMove((self.angry and "RotorAttackRun" or "RotorAttack"), 1, self.HandleRotor);
		--[[end);

		if(SERVER) then
			if(!success and IsValid(printTarget)) then
				printTarget:ChatPrint("NPC error:")
				printTarget:ChatPrint(err)

			end

		end]]

	end,

}

ENT.AttackChances = {
	[ENT.Attacks.Rotor] = 3,

}

ENT.PossessionBinds = {
	[IN_JUMP] = {{
		coroutine = true,
		onkeydown = function(self)
			if(!self:IsOnGround()) then return; end

			self:LeaveGround();
			self:SetVelocity(self:GetVelocity() + Vector(0,0,700) + self:GetForward() * 100);

			self:EmitSound("begotten/npc/grunt/attack_launch0"..math.random(1, 3)..".mp3", 100, self.pitch)

		end

	}},

	[IN_ATTACK] = {{
		coroutine = true,
		onkeydown = function(self)
			if !self.nextMeleeAttack or self.nextMeleeAttack < CurTime() then
				self.AttackFunctions[self.nextAttack](self);
				self:GetNextAttack();
	
				return true;
	
			else return false; end
		end
	}}
}
if (CLIENT) then
	
end;
if SERVER then
	function ENT:OnSpotted()
		local curTime = CurTime();
		if (!self.nextNotice or self.nextNotice < curTime) then
			self.nextNotice = curTime + 20
			self:EmitSound("begotten/npc/grunt/enabled0"..math.random(1, 4)..".mp3", 100, self.pitch)
		end;
		--	self:Jump(100)
	end
	function ENT:OnLost()
		local curTime = CurTime();
		if (!self.nextLo or self.nextLo < curTime) then
			self.nextLo = curTime + 20
			self:EmitSound("begotten/npc/grunt/amb_alert0"..math.random(1, 3)..".mp3", 100, self.pitch)
		end;
	end
	function ENT:OnParried()
		self.nextMeleeAttack = CurTime() + 2;
	end

	function ENT:GetNextAttack()
		local attack = self.Attacks.Standard;

		for i, v in pairs(self.AttackChances) do
			if(self.nextAttack == i) then continue; end
			if(math.random(1, v) != 1) then continue; end

			attack = i;
			break;

		end

		self.nextAttack = attack;

	end

	-- Init/Think --
	function ENT:CustomInitialize()
		self:SetDefaultRelationship(D_HT);
		self:EmitSound("begotten/npc/grunt/enabled0"..math.random(1, 4)..".mp3");

		self:GetNextAttack();

	end

	local function Behead(player)
		local defaultModel = player:GetDefaultModel();
		local ragdollEntity = player:GetRagdollEntity();
				
		if string.find(defaultModel, "models/begotten/heads") then
			local head_suffixes = {"_glaze", "_gore", "_satanist", "_wanderer", "_darklander"};
			local headModel = defaultModel;
			
			for i, v in ipairs(head_suffixes) do
				headModel = string.gsub(headModel, v, "_decapitated");
			end

			local headEnt = ents.Create("prop_physics");
			
			if IsValid(ragdollEntity) then
				local headBone = ragdollEntity:LookupBone("ValveBiped.Bip01_Head1");
				local headBonePos, headBoneAng;
				
				if (headBone) then
					headBonePos, headBoneAng = ragdollEntity:GetBonePosition(headBone);
				end
				
				if headBonePos and headBoneAng then
					headEnt:SetPos(headBonePos + Vector(0, 0, 8));
					headEnt:SetAngles(headBoneAng);
				else
					headEnt:SetPos(player:EyePos());
					headEnt:SetAngles(player:EyeAngles());
				end
			else
				headEnt:SetPos(player:EyePos());
				headEnt:SetAngles(player:EyeAngles());
			end
			
			headEnt:SetModel(headModel);
			headEnt:SetSkin(player:GetSkin());
			headEnt:SetCollisionGroup(COLLISION_GROUP_DEBRIS);
			headEnt:Spawn();

			local physicsObject = headEnt:GetPhysicsObject();
			
			if IsValid(physicsObject) then
				physicsObject:SetVelocity(player:GetVelocity() + (player:GetUp() * 250));
				physicsObject:SetAngleVelocity(VectorRand() * 66);
			end
			
			if !player.opponent then
				local helmetItem = player:GetHelmetEquipped();
				
				if helmetItem then
					if hook.Run("PlayerCanDropWeapon", player, helmetItem, NULL, true) then
						if !helmetItem.attributes or !table.HasValue(helmetItem.attributes, "not_unequippable") then
							helmetItem:TakeCondition(math.random(20, 40));
						end
					
						local entity = Clockwork.entity:CreateItem(player, helmetItem, headEnt:GetPos() + Vector(0, 0, 16), headEnt:GetAngles());

						if (IsValid(entity)) then
							local helmetPhysObject = entity:GetPhysicsObject();
							
							if IsValid(helmetPhysObject) then
								helmetPhysObject:SetVelocity(physicsObject:GetVelocity());
								helmetPhysObject:SetAngleVelocity(physicsObject:GetAngleVelocity());
							end
						
							player:TakeItem(helmetItem);
						end
					end
				end
			end
			
			Clockwork.entity:Decay(headEnt, 600);
			
			local gender = player:GetGender();
			
			if gender == GENDER_FEMALE then
				player:SetModel("models/begotten/heads/female_gorecap.mdl");
				player:SetBodygroup(0, 0);
				
				if IsValid(ragdollEntity) then
					ragdollEntity:SetModel("models/begotten/heads/female_gorecap.mdl");
					ragdollEntity:SetBodygroup(0, 0);
				end
			else
				player:SetModel("models/begotten/heads/male_gorecap.mdl");
				player:SetBodygroup(0, 0);
				
				if IsValid(ragdollEntity) then
					ragdollEntity:SetModel("models/begotten/heads/male_gorecap.mdl");
					ragdollEntity:SetBodygroup(0, 0);
				end
			end
			
			player:EmitSound("nhzombie_headexplode.wav");
			headEnt:EmitSound("nhzombie_headexplode_jet.wav");
			
			timer.Simple(FrameTime(), function()
				if IsValid(headEnt) then
					--ParticleEffect("blood_advisor_pierce_spray", headEnt:GetPos(), -headEnt:GetUp():Angle(), headEnt);
					ParticleEffectAttach("blood_advisor_pierce_spray", PATTACH_POINT_FOLLOW, headEnt, 0);
				end

			end);
			
			return;

		end

	end

	local rotorFrames = 525
	local rotorEvents = {
		attackStart = 41 / rotorFrames,
		attackEnd = 441 / rotorFrames,
		moveStart = 70 / rotorFrames,
		moveEnd = 444 / rotorFrames,
		attackSkip = 427 / rotorFrames,

	}

	function ENT:HandleRotorAttack(cycle, curTime)
		if(cycle < rotorEvents.attackStart or cycle >= rotorEvents.attackEnd) then return; end
		if(self.nextRotorAttack and self.nextRotorAttack > curTime) then return; end

		self.nextRotorAttack = curTime + 0.25;

		local data = {}
		data.start = self:GetPos() + Vector(0,0,45);
		data.endpos = data.start + self:GetForward() * 50;
		data.filter = self;

		local tr = util.TraceLine(data);

		if(IsValid(tr.Entity) and Clockwork.entity:IsDoor(tr.Entity)) then
			self:EmitSound("physics/wood/wood_crate_impact_hard2.wav");
			self:EmitSound("physics/wood/wood_panel_impact_hard1.wav", 100, math.random(70, 130));
			self:HandleDoorDamage(tr.Entity);

		end

		self:Attack({
			damage = self.Damage * 0.5,
			type = DMG_SLASH,
			viewpunch = Angle(20, math.random(-10, 10), 0)
		}, function(self, hit)
			if #hit > 0 then
				self:EmitSound("begotten/npc/grunt/attack_claw_hit0"..math.random(1,3)..".mp3", 100, self.pitch)
				self:EmitSound("ambient/machines/slicer"..math.random(1,4)..".wav", 100, self.pitch, 2)

				for _, v in pairs(hit) do
					if(!v:IsPlayer()) then continue; end

					v.hitByRotor = curTime + 0.8;
					v:SetRunSpeed(v.cwInfoTable.runSpeed * 0.75);

					local ragdoll = v:GetRagdollEntity();
					if(!v:Alive() and IsValid(ragdoll)) then
						if(math.random(1) == 0) then
							cwGore:SplatCorpse(ragdoll);
							
						else
							Behead(v);
						
						end
					
					end

				end

			end
		end)

	end

	function ENT:HandleRotor()
		local cycle = self:GetCycle();
		local curTime = CurTime();

		if(self:IsPossessed()) then
			self:PossessionFaceForward();
			
		else
			self:FaceEnemy();

		end

		if(cycle > rotorEvents.moveStart and cycle < rotorEvents.moveEnd) then
			self:Approach(self:GetPos() + self:GetForward() * 5)

		end

		if(cycle >= rotorEvents.attackStart and cycle < rotorEvents.attackEnd and !self.playedRotor) then
			self.playedRotor = true;
			self:EmitSound("ambient/machines/spin_loop.wav", 100, 100, 0.5);

		elseif(cycle >= rotorEvents.attackEnd and self.playedRotor) then
			self:StopSound("ambient/machines/spin_loop.wav");
			self.playedRotor = false;

		end

		self:HandleRotorAttack(cycle, curTime);

		if(cycle >= rotorEvents.attackEnd) then self.MeleeAttackRange = 120; end

		if((!self:IsPossessed() and !self:HasEnemy()) or (self:IsPossessed() and self:GetPossessor():KeyDown(IN_ATTACK2)) and cycle > rotorEvents.moveStart and cycle < rotorEvents.attackSkip - 0.02) then self:SetCycle(rotorEvents.attackSkip); self:StopSound("ambient/machines/spin_loop.wav"); end

	end

	-- AI --
	function ENT:OnMeleeAttack(enemy)
		if !self.nextMeleeAttack or self.nextMeleeAttack < CurTime() then

			self.AttackFunctions[self.nextAttack](self);
			self:GetNextAttack();

			return true;

		else return false; end
	end
	function ENT:OnReachedPatrol()
		self:Wait(math.random(3, 7))
	end
	function ENT:ShouldIgnore(ent)
		if ent:IsPlayer() and (ent.possessor or ent.victim) then
			return true;
		end
	end
	function ENT:WhilePatrolling()
		self:OnIdle()
	end
	
	function ENT:OnIdle()
		local curTime = CurTime();
		
		if (!self.nextId or self.nextId < curTime) then
			self.nextId = curTime + 10
			self:EmitSound("begotten/npc/grunt/amb_idle0"..math.random(1, 5)..".mp3", 100, self.pitch)
			self:AddPatrolPos(self:RandomPos(1500))
		end;
	end
	-- Damage --
	function ENT:OnDeath(dmg, delay, hitgroup)
	end
	function ENT:OnRagdoll(dmg)
		local ragdoll = self;
		
		if IsValid(ragdoll) then
			ParticleEffectAttach("doom_dissolve", PATTACH_POINT_FOLLOW, ragdoll, 0);
			
			timer.Simple(1.6, function() 
				if IsValid(ragdoll) then
					ParticleEffectAttach("doom_dissolve_flameburst", PATTACH_POINT_FOLLOW, ragdoll, 0);
					ragdoll:Fire("fadeandremove", 1);
					ragdoll:EmitSound("begotten/npc/burn.wav");
					
					if cwRituals and cwItemSpawner then
						local randomItem;
						local spawnable = cwItemSpawner:GetSpawnableItems(true);
						local lootPool = {};
						
						for _, itemTable in ipairs(spawnable) do
							if itemTable.category == "Catalysts" then
								if itemTable.itemSpawnerInfo and !itemTable.itemSpawnerInfo.supercrateOnly then
									table.insert(lootPool, itemTable);
								end
							end
						end
						
						randomItem = lootPool[math.random(1, #lootPool)];
						
						if randomItem then
							local itemInstance = item.CreateInstance(randomItem.uniqueID);
							
							if itemInstance then
								local entity = Clockwork.entity:CreateItem(nil, itemInstance, ragdoll:GetPos() + Vector(0, 0, 16));
								
								entity.lifeTime = CurTime() + config.GetVal("loot_item_lifetime");
								
								table.insert(cwItemSpawner.ItemsSpawned, entity);
							end
						end
					end
					
					if cwRecipes and cwItemSpawner then
						for i = 1, math.random(3, 4) do
							local itemInstance = item.CreateInstance("iron_chunks");
							
							if itemInstance then
								itemInstance:SetCondition(math.random(50, 100));
								
								local entity = Clockwork.entity:CreateItem(nil, itemInstance, ragdoll:GetPos() + Vector(0, 0, 24) + (VectorRand() * 24));
								
								entity.lifeTime = CurTime() + config.GetVal("loot_item_lifetime");
								
								table.insert(cwItemSpawner.ItemsSpawned, entity);
							end
						end
					end
				end;
			end)
			
			return true;
		end
	end
	function ENT:Makeup()
	end;
	ENT.ModelScale = 1
	ENT.pitch = 80
	function ENT:CustomThink()
		if (!self.lastStuck and self:IsStuck()) then
			self.lastStuck = CurTime() + 2;
		end;
		
		if (self.lastStuck and self.lastStuck < CurTime()) then
			if (self:IsStuck()) then
				--self:Jump(500)
				self:MoveForward(5000, function() return true end)
			end;
			
			self.lastStuck = nil
			
		end;

		if !self.angry and self:Health() < (self.SpawnHealth / 2) then
			self.angry = true;
			self.UseWalkframes = false;
			self.WalkSpeed = 35;
			self.RunSpeed = 135;
			self.RunAnimation = ACT_RUN;
			self.MeleeAttackRange = 100;
			self.Armor = 70;

			self:UpdateSpeed();
			self:EmitSound("physics/metal/metal_box_break1.wav", 100, 90);

			self.nextAttack = self.Attacks.Rotor;

		end

	end

	function ENT:OnRemove()
		self:StopSound("ambient/machines/spin_loop.wav");

	end
	
	-- Animations/Sounds --
	function ENT:OnNewEnemy()
		self:EmitSound("begotten/npc/grunt/notice0"..math.random(1,4)..".mp3", 100, self.pitch)
	end
	
	function ENT:OnChaseEnemy()
		local curTime = CurTime();
		if (!self.nextId or self.nextId < curTime) then
			self.nextId = curTime + math.random(7, 15)
			self:EmitSound("begotten/npc/grunt/amb_hunt0"..math.random(1,4)..".mp3", 100, self.pitch)
		end;
	end
	function ENT:OnLandedOnGround()
	end;

	function ENT:OnAnimEvent(_, event)
		if(event == 54 or event == 53) then
			if(self:IsOnGround()) then self:EmitSound("armormovement/body-armor-"..math.random(1, 6)..".wav.mp3"); end

			return;

		end

		if self:IsAttacking() and self:GetCycle() > 0.3 then
			self:Attack({
				damage = self.Damage,
				type = DMG_SLASH,
				viewpunch = Angle(20, math.random(-10, 10), 0)
			}, function(self, hit)
				if #hit > 0 then
					self:EmitSound("begotten/npc/grunt/attack_claw_hit0"..math.random(1,3)..".mp3", 100, self.pitch)
				else self:EmitSound("Zombie.AttackMiss") end
			end)
		elseif self:IsOnGround() then
			self:EmitSound("armormovement/body-armor-"..math.random(1, 6)..".wav.mp3");
		end
		
	end
end

hook.Add("ModifyPlayerSpeed", "IroncladRotorAttack", function(player, infoTable)
	local curTime = CurTime();
	if(!player.hitByRotor) then return; end

	if(player.hitByRotor > curTime) then infoTable.runSpeed = infoTable.runSpeed * 0.75; end

end)

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)