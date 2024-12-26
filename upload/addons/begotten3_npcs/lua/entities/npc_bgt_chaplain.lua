if !DrGBase then return end -- return if DrGBase isn't installed

game.AddParticles("particles/bg_necromancer.pcf");

ENT.Base = "drgbase_nextbot" -- DO NOT TOUCH (obviously)
-- Misc --
ENT.PrintName = "Chaplain"
ENT.Category = "Begotten DRG"
ENT.Models = {"models/begotten/thralls/chaplain.mdl"}
ENT.BloodColor = BLOOD_COLOR_RED
ENT.RagdollOnDeath = true;
-- Sounds --
ENT.OnDamageSounds = {"begotten/npc/grunt/attack_claw01.mp3", "begotten/npc/grunt/attack_claw02.mp3", "begotten/npc/grunt/attack_claw03.mp3"}
ENT.OnDeathSounds = {"begotten/npc/grunt/amb_idle_scratch01.mp3", "begotten/npc/grunt/amb_idle_scratch02.mp3", "begotten/npc/grunt/amb_idle_scratch03.mp3"}
ENT.PainSounds = {"begotten/npc/grunt/attack_launch01.mp3", "begotten/npc/grunt/attack_launch02.mp3"};
-- Stats --
ENT.SpawnHealth = 600
ENT.SpotDuration = 20
ENT.Armor = 20;
-- AI --
ENT.RangeAttackRange = 400
ENT.MeleeAttackRange = 90
ENT.ReachEnemyRange = 90
ENT.AvoidEnemyRange = 0
ENT.HearingCoefficient = 0.5
ENT.SightFOV = 300
ENT.SightRange = 1024
ENT.XPValue = 250;
-- Relationships --
ENT.Factions = {FACTION_ZOMBIES}
-- Movements/animations --
ENT.UseWalkframes = true
ENT.WalkAnimation = "walk_All"
ENT.RunAnimation = "walk_All"
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
ENT.MaxMultiHit = 3;
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

ENT.WalkSpeed = 100;
ENT.RunSpeed = 150;

ENT.Attacks = {
	Fireball = 1,
	Summon = 2,

};

ENT.AttackFunctions = {
	[ENT.Attacks.Fireball] = {
		ShouldAttack = function(self)
			return true;

		end,
		Attack = function(self)
			self:StartFireball();

		end,
	},

	[ENT.Attacks.Summon] = {
		ShouldAttack = function(self)
			return !self.nextSummonAttack or self.nextSummonAttack <= CurTime();

		end,
		Attack = function(self)
			self.nextSummonAttack = CurTime() + 30;
			self:StartSummon();

		end,
	},
}

local summonFrames = 185;
local summonEvents = {
	fireStart = 38 / summonFrames,
	fireEnd = 170 / summonFrames,
	summonStart = 56 / summonFrames,
	summonEnd = 158 / summonFrames,

};

function ENT:ClampNum(num, a, b)
	if(num < a and num > 0) then return a; end
	if(num > b and num < 0) then return b; end
	return num;

end

function ENT:SummonTrace()
	local data = {};
	data.start = self:GetPos() + Vector(self:ClampNum(math.random(-100, 100), 30, -30), self:ClampNum(math.random(-100, 100), 30, -30), 80);
	data.endpos = data.start - Vector(0, 0, 200);

	local tr = util.TraceLine(data);

	if(IsValid(data.Entity) and data.Entity != game.GetWorld() and !string.find(data.Entity:GetClass(), "prop_")) then
		return self:SummonTrace();

	end

	return tr;

end

function ENT:HandleSummon()
	local cycle = self:GetCycle();
	local curTime = CurTime();

	if(cycle >= summonEvents.fireStart and cycle < summonEvents.fireEnd and !self.playedFire) then
		self:EmitSound("ambient/fire/ignite.wav", 100);
		self.playedFire = true;
		ParticleEffectAttach("bg_necromancer_summon", PATTACH_POINT_FOLLOW, self, self:LookupAttachment("anim_attachment_RH"));
		ParticleEffectAttach("bg_necromancer_summon", PATTACH_POINT_FOLLOW, self, self:LookupAttachment("anim_attachment_LH"));

	elseif(cycle >= summonEvents.fireEnd and self.playedFire) then
		self.playedFire = false;
		self:StopParticles();

	end

	if(cycle >= summonEvents.summonStart and cycle < summonEvents.summonEnd) then
		if(!self.nextSummon or self.nextSummon < curTime) then
			self.nextSummon = curTime + math.Rand(0.5, 0.8);

			local tr = self:SummonTrace();
			Schema:Summon(tr.HitPos, tr.HitNormal, function()
				if(!IsValid(self)) then return; end
				local entity = ents.Create("npc_bgt_soldier");
				entity:CustomInitialize();
				entity:SetPos(tr.HitPos);
				entity:Spawn();
				entity:Activate();
				self:DeleteOnRemove(entity);
				
			end);

		end

	elseif(cycle >= summonEvents.summonEnd) then
		self.nextSummon = nil;
		self:StopParticles();

	end

end

function ENT:StartSummon()
	self:FaceEnemy();
	local laugh = math.random(1, 2)
	self:EmitSound("begotten/necromancer/laugh"..laugh..".mp3", 100);
	self:EmitSound("begotten/necromancer/laugh"..laugh..".mp3", 100);
	self:PlaySequenceAndMove("summon", 1, self.HandleSummon);

end

local punchFrames = 86;
local punchEvents = {
	punch = 30 / punchFrames,
	windup = 20 / punchFrames,
	windupEnd = 40 / punchFrames,

};

function ENT:HandleStrongLeft()
	local cycle = self:GetCycle();
	local curTime = CurTime();

	if(self:IsPossessed()) then
		self:PossessionFaceForward();
		
	else
		self:FaceEnemy();

	end

	if(cycle >= punchEvents.windup and cycle < punchEvents.windupEnd and !self.playedWindup) then
		self:EmitSound("begotten/necromancer/punch_windup.mp3", 100);
		self:EmitSound("begotten/necromancer/punch_windup.mp3", 100);
		self:EmitSound("begotten/necromancer/punch_windup.mp3", 100);
		self.playedWindup = true;
		ParticleEffectAttach("bg_necromancer_summon", PATTACH_POINT_FOLLOW, self, self:LookupAttachment("anim_attachment_LH"));

	elseif(cycle >= punchEvents.windupEnd and self.playedWindup) then
		self.playedWindup = false;
		self:StopParticles();

	end

	if(cycle >= punchEvents.punch and !self.punched) then
		self.punched = true;
		self:Attack({
			damage = 95,
			type = DMG_CLUB,
			viewpunch = Angle(20, math.random(-10, 10), 0),

		}, function(self, hit)
			if #hit > 0 then
				self:StopSound("begotten/necromancer/punch_windup.mp3");
				self:EmitSound("begotten/necromancer/punch_hit.mp3", 100);
				self:EmitSound("begotten/necromancer/punch_hit.mp3", 100);
				self:EmitSound("begotten/necromancer/punch_hit.mp3", 100);

			end

			local fwd = self:GetForward();

			for _, v in pairs(hit) do
				if(!v:IsPlayer()) then continue; end

				Clockwork.player:SetRagdollState(v, RAGDOLL_FALLENOVER, 3);
				
				local ragdoll = v:GetRagdollEntity();
				if(!IsValid(ragdoll)) then return; end
				
				for i = 1, ragdoll:GetPhysicsObjectCount() do
					local physObj = ragdoll:GetPhysicsObjectNum(i);
					if(!IsValid(physObj)) then continue; end

					physObj:SetVelocity((fwd * 300) + Vector(0, 0, 200));

				end

			end

		end)

	end

end

function ENT:StartStrongLeft()
	self:PlaySequenceAndMove("strongleft", math.Rand(0.5, 2.5), self.HandleStrongLeft);
	self.playedWindup = false;
	self.punched = false;

end

local fireballFrames = 70;
local fireballEvents = {
	fireStart = 15 / fireballFrames,
	throw = 48 / fireballFrames,

};

function ENT:HandleFireball()
	local cycle = self:GetCycle();
	local curTime = CurTime();

	if(self:IsPossessed()) then
		self:PossessionFaceForward();
		
	else
		self:FaceEnemy();

	end

	if(cycle >= fireballEvents.fireStart and cycle < fireballEvents.throw and !self.playedFire) then
		self:EmitSound("ambient/fire/mtov_flame2.wav", 100);
		self.playedFire = true;
		ParticleEffectAttach("bg_necromancer_fireball", PATTACH_POINT_FOLLOW, self, self:LookupAttachment("anim_attachment_RH"));

	elseif(cycle >= fireballEvents.throw and self.playedFire) then
		self.playedFire = false;
		self:StopParticles();

	end

	if(cycle >= fireballEvents.throw and !self.threwFire) then
		self.threwFire = true;

		local ent = ents.Create("begotten_fireball_thrown");
		ent:SetPos(self:GetBonePosition(self:LookupBone("ValveBiped.Bip01_R_Hand")));
		ent:SetOwner(self);
		ent.Owner = self;

		ent:Spawn();
		ent:Activate();

		local physObj = ent:GetPhysicsObject();
		if(IsValid(physObj)) then
			physObj:SetVelocity(self:GetForward() * 1750);

		end

	end

end

function ENT:StartFireball()
	self.playedFire = false;
	self:PlaySequenceAndMove("fireball", 1, self.HandleFireball);
	self.threwFire = false;

end

--[[for _, v in pairs(ents.FindByClass("npc_bgt_chaplain")) do
	if(v.emitter) then v.emitter:Finish() v.emitter = nil end

end]]

function ENT:Draw()
	self:DrawModel();

end

function ENT:OnRemove()
	if(self.emitter) then self.emitter:Finish(); end

end

ENT.PossessionBinds = {
	[IN_JUMP] = {{
		coroutine = true,
		onkeydown = function(self)
			if(!self:IsOnGround()) then return; end

			self:LeaveGround();
			self:SetVelocity(self:GetVelocity() + Vector(0,0,700) + self:GetForward() * 100);

			--self:EmitSound("begotten/npc/grunt/attack_launch0"..math.random(1, 3)..".mp3", 100, self.pitch)

		end

	}},

	[IN_ATTACK] = {{
		coroutine = true,
		onkeydown = function(self)
			if !self.nextMeleeAttack or self.nextMeleeAttack < CurTime() then
				self:StartSummon();
	
				return true;
	
			else return false; end
		end
	}},

	[IN_ATTACK2] = {{
		coroutine = true,
		onkeydown = function(self)
			if !self.nextMeleeAttack or self.nextMeleeAttack < CurTime() then
				self:StartStrongLeft();
	
				return true;
	
			else return false; end
		end
	}},

};

if SERVER then
	PrecacheParticleSystem("bg_necromancer_summon");
	PrecacheParticleSystem("bg_necromancer_fireball");
	PrecacheParticleSystem("bg_necromancer_frostball");

	function ENT:OnSpotted()
		local curTime = CurTime();
		if (!self.nextNotice or self.nextNotice < curTime) then
			self.nextNotice = curTime + 20
			--self:EmitSound("begotten/npc/grunt/enabled0"..math.random(1, 4)..".mp3", 100, self.pitch)
		end;
		--	self:Jump(100)
	end
	function ENT:OnLost()
		local curTime = CurTime();
		if (!self.nextLo or self.nextLo < curTime) then
			self.nextLo = curTime + 20
			--self:EmitSound("begotten/npc/grunt/amb_alert0"..math.random(1, 3)..".mp3", 100, self.pitch)
		end;
	end
	function ENT:OnParried()
		self.nextMeleeAttack = CurTime() + 2;
	end

	function ENT:GetNextAttack()
		local attack = self.Attacks.Fireball;

		for i, v in pairs(self.AttackFunctions) do
			if(self.nextAttack == i) then continue; end
			if(!v.ShouldAttack(self)) then continue; end

			attack = i;
			break;

		end

		self.nextAttack = attack;

	end

	-- Init/Think --
	function ENT:CustomInitialize()
		self:SetDefaultRelationship(D_HT);
		--self:EmitSound("begotten/necromancer/laugh"..math.random(1, 2)..".mp3", 100);

		self.WalkSpeed = 200;
		self.RunSpeed = 200;
		self:UpdateSpeed();

		self.nextAttack = self.Attacks.Summon;

	end

	-- AI --
	function ENT:OnMeleeAttack(enemy)
		if !self.nextMeleeAttack or self.nextMeleeAttack < CurTime() then

			self:StartStrongLeft();

			return true;

		else return false; end
	end

	function ENT:OnRangeAttack(enemy)
		if !self.nextMeleeAttack or self.nextMeleeAttack < CurTime() then

			self.AttackFunctions[self.nextAttack].Attack(self);
			self:GetNextAttack();
			self.nextMeleeAttack = CurTime() + 3;

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
			--self:EmitSound("begotten/npc/grunt/amb_idle0"..math.random(1, 5)..".mp3", 100, self.pitch)
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
						for i = 1, 5 do
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

		--[[if !self.angry and self:Health() < (self.SpawnHealth / 2) then
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

		end]]

	end
	
	-- Animations/Sounds --
	function ENT:OnNewEnemy()
		--self:EmitSound("begotten/npc/grunt/notice0"..math.random(1,4)..".mp3", 100, self.pitch)
	end
	
	function ENT:OnChaseEnemy()
		local curTime = CurTime();
		if (!self.nextId or self.nextId < curTime) then
			self.nextId = curTime + math.random(7, 15)
			--self:EmitSound("begotten/npc/grunt/amb_hunt0"..math.random(1,4)..".mp3", 100, self.pitch)
		end;
	end
	function ENT:OnLandedOnGround()
	end;

	function ENT:OnAnimEvent(_, event)
		if(self:IsOnGround()) then self:EmitSound("armormovement/body-lobe-"..math.random(1, 5)..".wav.mp3"); end

		return;
		
	end
end

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)