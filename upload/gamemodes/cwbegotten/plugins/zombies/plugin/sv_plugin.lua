--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

--[[cwZombies.manualZombieSpawns = cwZombies.manualZombieSpawns or {};

-- A function to make a zombie spring up from the dead.
function cwZombies:UndeadScare(entity, player)
	if (!player or !IsValid(player)) then
		player = table.Random(_player.GetAll());
	end;
	
	timer.Simple(0.5, function()
		if (IsValid(player) and IsValid(entity)) then
			local headIndex = entity:LookupBone("ValveBiped.Bip01_Head1");
			local physCount = entity:GetPhysicsObjectCount();
			
			for i = 1, physCount do
				local physicsObject = entity:GetPhysicsObjectNum(i);
				local boneIndex = entity:TranslatePhysBoneToBone(i);
				
				if (IsValid(physicsObject)) then
					if (boneIndex == headIndex) then
						physicsObject:ApplyForceCenter(Vector(0, 0, 10000));
					end
				end;
			end;
			
			local zombieNPC = ents.Create("cw_zombie");
				zombieNPC:SetPos(entity:GetPos() + entity:GetPos():GetNormal() * 20);
				zombieNPC:SetAngles(Angle(0, 0, 0));
			zombieNPC:Spawn();
			
			zombieNPC:SetEnemy(player);
			
			timer.Simple(FrameTime(), function()
				if (IsValid(zombieNPC) and IsValid(entity)) then
					zombieNPC:SetModel(entity:GetModel());
					zombieNPC:SetSkin(entity:GetSkin());
					
					entity:Remove();
				end;
			end);
		end;
	end);
end;

-- A function to drop a grenade at a zombie's position.
function cwZombies:ZombieGrenade(entity)
	local grenade = ents.Create("prop_physics");
		grenade:SetPos(entity:GetPos() + Vector(0, 0, 16));
		grenade:SetAngles(Angle(0, 0, 90));
		grenade:SetModel("models/weapons/w_grenade.mdl");
	grenade:Spawn();
	
	local pitch = 100;

	timer.Create(grenade:EntIndex().."_tick", 0.5, 6, function()
		grenade:EmitSound("weapons/grenade/tick1.wav", 80, pitch);
		
		pitch = pitch + 5;
	end);
	
	timer.Simple(3.5, function()
		if (IsValid(grenade)) then
			grenade:Remove();
			
			local effectData = EffectData();
				effectData:SetStart(grenade:GetPos());
				effectData:SetOrigin(grenade:GetPos());
				effectData:SetScale(scale or 8);
			util.Effect("Explosion", effectData);

			for k, v in ipairs(ents.FindInSphere(grenade:GetPos(), 196)) do
				local damageInfo = DamageInfo();
					damageInfo:SetDamageType(DMG_BLAST);
					damageInfo:SetDamage(math.random(70, 130));
					damageInfo:SetAttacker(grenade);
					damageInfo:SetInflictor(grenade);
					damageInfo:SetDamageForce(Vector(100, 100, 100));
				v:TakeDamageInfo(damageInfo);
			end;
		end;
	end);
end;

-- A function to spawn a zombie NPC at a given position.
function cwZombies:SpawnZombie(class, position)
	local zombie = ents.Create(class);
	
	if (IsValid(zombie)) then
		zombie:SetPos(position + position:GetNormalized() * 20);
		zombie:SetAngles(Angle(0, 0, 0));
		
		if (math.random(1, 3) == 3) then
			zombie:SetEnemy(table.Random(_player.GetAll()));
		end;
		
		for k, v in pairs (_player.GetAll()) do
			local playerPosition = v:GetPos();
			local zombiePosition = zombie:GetPos();
			local distance = zombiePosition:Distance(playerPosition);
			local randomSound = nil;
			
			if (distance > 0 and distance <= 1000) then
				randomSound = "begotten/l4d2/mob/germx"..math.random(1, 2)..table.Random({"a", "b"})..".wav";
			elseif (distance > 1000 and distance <= 2000) then
				randomSound = "begotten/l4d2/mob/germl"..math.random(1, 2)..table.Random({"a", "b"})..".wav";
			elseif (distance > 2000 and distance <= 3000) then
				randomSound = "begotten/l4d2/mob/germm"..math.random(1, 2)..table.Random({"a", "b"})..".wav";
			elseif (distance > 3000 and distance <= 4000) then
				randomSound = "begotten/l4d2/mob/germs"..math.random(1, 2)..table.Random({"a", "b"})..".wav";
			else
				randomSound = table.Random({
					"begotten/l4d2/glimpse_death1.mp3",
					"begotten/l4d2/glimpse_death2.mp3",
					"begotten/l4d2/glimpse_hell1.mp3",
					"begotten/l4d2/glimpse_hell2.mp3",
					"begotten/l4d2/glimpse_hell3.mp3"
				})
				
				if (math.random(1, 10) == 10) then
					randomSound = "begotten/l4d2/mob/walkingdead.wav";
				end;
			end;
			
			if (randomSound) then
				Clockwork.datastream:Start(v, "PlaySound", randomSound);
			end;
		end;
	end;
end;]]--

function cwZombies:GiveAwayPosition(entity, radius)
	local playerPosition = entity:GetPos();
	
	for k, v in pairs (ents.FindInSphere(playerPosition, (radius or 2500))) do
		if ((v:IsNPC() or v:IsNextBot()) and table.HasValue(self.zombieNPCS, v:GetClass()) --[[and v:GetLastEnemy() != entity]]) then
			v:SetEnemy(entity);
			--v:SetLastEnemy(entity);
			--v:UpdateEnemyMemory(entity, entity:GetPos());
			
			--v:EmitSound("begotten/npc/"..string.sub(tostring(v:GetClass()), 4, -1).."/notice_long0"..math.random(1, 2)..".mp3", 500, math.random(95, 105));
			
			break;
		end;
	end;
end

local map = game.GetMap() == "rp_begotten3";

-- A function to spawn a Begotten thrall.
function cwZombies:SpawnThrall(name, spawnPos, angles)
	if (!map) then
		return;
	end;
	
	local entity;
	
	if name == "npc_bgt_another" or string.lower(name) == "another" then
		entity = ents.Create("npc_bgt_another");
		
		entity:CustomInitialize();
		entity:SetPos(spawnPos)
		entity:SetAngles(angles);
		entity:Spawn();
		entity:Activate();
	elseif name == "npc_bgt_brute" or string.lower(name) == "brute" then
		entity = ents.Create("npc_bgt_brute");
		
		entity:CustomInitialize();
		entity:SetPos(spawnPos)
		entity:SetAngles(angles);
		entity:Spawn();
		entity:Activate();
	elseif name == "npc_bgt_chaser" or string.lower(name) == "chaser" then
		entity = ents.Create("npc_bgt_chaser");
		
		entity:CustomInitialize();
		entity:SetPos(spawnPos)
		entity:SetAngles(angles);
		entity:Spawn();
		entity:Activate();
	elseif name == "npc_bgt_ed" or string.lower(name) == "eddie" then
		entity = ents.Create("npc_bgt_ed");
		
		entity:CustomInitialize();
		entity:SetPos(spawnPos)
		entity:SetAngles(angles);
		entity:Spawn();
		entity:Activate();
	elseif name == "npc_bgt_grunt" or string.lower(name) == "grunt" then
		entity = ents.Create("npc_bgt_grunt");
		
		entity:CustomInitialize();
		entity:SetPos(spawnPos)
		entity:SetAngles(angles);
		entity:Spawn();
		entity:Activate();
	elseif name == "npc_bgt_guardian" or string.lower(name) == "guardian" then
		entity = ents.Create("npc_bgt_guardian");
		
		entity:CustomInitialize();
		entity:SetPos(spawnPos)
		entity:SetAngles(angles);
		entity:Spawn();
		entity:Activate();
	elseif name == "npc_bgt_otis" or string.lower(name) == "otis" then
		entity = ents.Create("npc_bgt_otis");
		
		entity:CustomInitialize();
		entity:SetPos(spawnPos)
		entity:SetAngles(angles);
		entity:Spawn();
		entity:Activate();
	elseif name == "npc_bgt_shambler" or string.lower(name) == "shambler" then
		entity = ents.Create("npc_bgt_shambler");
		
		entity:CustomInitialize();
		entity:SetPos(spawnPos)
		entity:SetAngles(angles);
		entity:Spawn();
		entity:Activate();
	elseif name == "npc_bgt_suitor" or string.lower(name) == "suitor" then
		entity = ents.Create("npc_bgt_suitor");
		
		entity:CustomInitialize();
		entity:SetPos(spawnPos)
		entity:SetAngles(angles);
		entity:Spawn();
		entity:Activate();
	end
	
	return entity;
end