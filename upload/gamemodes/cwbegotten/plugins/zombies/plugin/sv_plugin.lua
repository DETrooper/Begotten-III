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

-- A function to get a random zombie NPC.
function cwZombies:GetRandomZombie()
	return "cw_zombie";
end;

local map = game.GetMap() == "rp_begotten3";

-- A function to spawn a Begotten thrall.
function cwZombies:SpawnThrall(name, spawnPos, angles)
	if (!map) then
		return;
	end;
	
	local entity;
	
	if name == "npc_bgt_another" or string.lower(name) == "another" then
		entity = ents.Create("npc_bgt_another");
		
		entity:SetModel("models/Zombie/Classic.mdl")
		entity:SetPos(spawnPos)
		entity:SetAngles(angles);
		entity:Spawn();
		entity:Activate();
		
		cwParts:HandleClothing(entity, "models/undead/fast.mdl", 1, 0, true);
		cwParts:HandleClothing(entity, "models/undead/fast.mdl", 2, 0, true);
		cwParts:HandleClothing(entity, "models/undead/fast.mdl", 3, 0, true);
		cwParts:HandleClothing(entity, "models/undead/poison.mdl", 4, 0, true);

		entity:SetMaterial("effects/water_warp01");
	elseif name == "npc_bgt_brute" or string.lower(name) == "brute" then
		entity = ents.Create("npc_bgt_brute");
		
		entity:SetModel("models/zombie/zombie_soldier.mdl")
		entity:SetPos(spawnPos)
		entity:SetAngles(angles);
		entity:Spawn();
		entity:Activate();
		
		cwParts:HandleClothing(entity, "models/Zombie/Fast.mdl", 1, 0, true);
		cwParts:HandleClothing(entity, "models/undead/poison.mdl", 2, 0, true);
		cwParts:HandleClothing(entity, "models/Gibs/Fast_Zombie_Torso.mdl", 3, 0, true);
		cwParts:HandleClothing(entity, "models/Zombie/Classic_legs.mdl", 4, 0, true);
		cwParts:HandleClothing(entity, "models/skeleton/skeleton_whole.mdl", 8, 2, false);
		cwParts:HandleClothing(entity, "models/zombie/zombie_soldier.mdl", 3, 0, false);
		
		if (math.random(1, 2) == 1) then
			cwGear:HandleGear(entity, "models/props_c17/TrapPropeller_Blade.mdl", "right hand", Vector(0, -1, 0), Angle(0, 0, 180), 0.5);
		end;
		
		entity:SetMaterial("effects/water_warp01");
	elseif name == "npc_bgt_chaser" or string.lower(name) == "chaser" then
		entity = ents.Create("npc_bgt_chaser");
		
		entity:SetModel("models/Zombie/Fast.mdl");
		entity:SetPos(spawnPos)
		entity:SetAngles(angles);
		entity:Spawn();
		entity:Activate();

		--cwGear:HandleGear(entity, "models/props_c17/TrapPropeller_Blade.mdl", "head", Vector(8, -2, 0), Angle(210, 90, 90), 0.4);

		entity:SetMaterial("models/barnacle/barnacle_sheet");
	elseif name == "npc_bgt_ed" or string.lower(name) == "eddie" then
		entity = ents.Create("npc_bgt_ed");
		
		entity:SetModel("models/zombie/zombie_soldier.mdl")
		entity:SetPos(spawnPos)
		entity:SetAngles(angles);
		entity:Spawn();
		entity:Activate();

		entity.gri = cwParts:HandleClothing(entity, "models/monk.mdl", 9, 0, true);
		entity.gri:SetMaterial("models/undead/poisonzombie_sheet")
		cwParts:HandleClothing(entity, "models/undead/fast.mdl", 0, 0, true);
		cwParts:HandleClothing(entity, "models/undead/poison.mdl", 4, 0, true);
		entity.skele = cwParts:HandleClothing(entity, "models/skeleton/skeleton_torso.mdl", 8, 2, true);
		entity.skele:SetMaterial("models/undead/charple4_sheet")
		entity.kni = cwGear:HandleGear(entity, "models/props_c17/TrapPropeller_Blade.mdl", "right hand", Vector(0, -1, 0), Angle(0, 0, 180), 0.5);
		entity.kni:SetMaterial("models/undead/poisonzombie_sheet")
		entity:SetMaterial("effects/water_warp01");
	elseif name == "npc_bgt_grunt" or string.lower(name) == "grunt" then
		entity = ents.Create("npc_bgt_grunt");
		
		entity:SetModel("models/zombie/zombie_soldier.mdl")
		entity:SetPos(spawnPos)
		entity:SetAngles(angles);
		entity:Spawn();
		entity:Activate();
		
		cwParts:HandleClothing(entity, "models/undead/poison.mdl", 1, 0, true);
		cwParts:HandleClothing(entity, "models/skeleton/skeleton_torso.mdl", 8, 2, true);
		cwParts:HandleClothing(entity, "models/Zombie/Fast.mdl", 3, 0, true);
		cwParts:HandleClothing(entity, "models/Zombie/Poison.mdl", 4, 0, true);
		cwGear:HandleGear(entity, "models/props_c17/TrapPropeller_Engine.mdl", "chest", Vector(4, -4, 0), Angle(0, 90, 90), 0.8);
		cwGear:HandleGear(entity, "models/props_junk/sawblade001a.mdl", "right hand", Vector(0, 0, -2), Angle(0, 90, 0), 0.6);
		entity:SetMaterial("effects/water_warp01");

		hook.Add("EntityRemoved", entity, function()
			if (entity.cwChainsawSound) then
				entity.cwChainsawSound:Stop();
				entity.cwChainsawSound = nil;
			end;
		end);
		
		hook.Add("Think", entity:EntIndex().."_Chainsaws", function()
			if (!IsValid(entity)) then
				return;
			end;
			
			local curTime = CurTime();
			
			if (!entity.cwChainsawSound) then
				entity.cwChainsawSound = CreateSound(entity, "vehicles/v8/v8_start_loop1.wav");
				entity.cwChainsawSound:PlayEx(0.8, math.random(85, 110));
			end;
			
			if (!entity.nextsasd or curTime > entity.nextsasd) then
				entity.nextsasd = curTime + 30;
				
				if (entity.cwChainsawSound) then
					entity.cwChainsawSound:Stop();
					entity.cwChainsawSound = nil;
					
					if (entity.sawasd == 1) then
						entity.cwChainsawSound = CreateSound(entity, "vehicles/junker/jnk_turbo_on_loop1.wav");
						entity.cwChainsawSound:PlayEx(1, math.random(85, 110));
					else
						entity.cwChainsawSound = CreateSound(entity, "vehicles/v8/v8_start_loop1.wav");
						entity.cwChainsawSound:PlayEx(0.8, math.random(85, 110));
					end;
				end;
			end;
			
			if (!entity.sawasd) then
				entity.sawasd = 0;
			end;
			
			if (IsValid(entity:GetEnemy())) then
				if (entity.sawasd == 0) then
					if (entity.cwChainsawSound) then
						entity.cwChainsawSound:Stop();
						entity.cwChainsawSound = nil;
					end;
					
					entity.cwChainsawSound = CreateSound(entity, "vehicles/junker/jnk_turbo_on_loop1.wav");
					entity.cwChainsawSound:PlayEx(1, math.random(85, 110));
					entity.sawasd = 1;
					
					local en = table.Random({"begotten/npc/grunt/attack_launch01.mp3", "begotten/npc/grunt/attack_launch02.mp3", "begotten/npc/grunt/attack_launch03.mp3"})
					entity:EmitSound(en, 90, 100);
				end;
			else
				if (entity.sawasd == 1) then
					if (entity.cwChainsawSound) then
						entity.cwChainsawSound:Stop();
						entity.cwChainsawSound = nil;
					end;
					
					entity.cwChainsawSound = CreateSound(entity, "vehicles/v8/v8_start_loop1.wav");
					entity.cwChainsawSound:PlayEx(0.8, math.random(85, 110));
					entity.sawasd = 0;
				end;
			end;
		end);
	elseif name == "npc_bgt_guardian" or string.lower(name) == "guardian" then
		entity = ents.Create("npc_bgt_guardian");
		
		entity:SetModel("models/AntLion.mdl")
		entity:SetPos(spawnPos)
		entity:SetAngles(angles);
		entity:Spawn();
		entity:Activate();

		entity:SetMaterial("models/zombie_fast/fast_zombie_sheet");
	elseif name == "npc_bgt_otis" or string.lower(name) == "otis" then
		entity = ents.Create("npc_bgt_otis");
		
		entity:SetModel("models/zombie/zombie_soldier.mdl")
		entity:SetPos(spawnPos)
		entity:SetAngles(angles);
		entity:Spawn();
		entity:Activate();
		
		cwParts:HandleClothing(entity, "models/skeleton/skeleton_whole.mdl", 0, 8, true); -- torso
		cwParts:HandleClothing(entity, "models/Zombie/Fast.mdl", 3, 0, true); -- hands
		cwParts:HandleClothing(entity, "models/Zombie/Fast.mdl", 4, 0, true); -- legs
		cwParts:HandleClothing(entity, "models/Gibs/Fast_Zombie_Torso.mdl", 1, 0, false); -- hands
		cwParts:HandleClothing(entity, "models/undead/corpse1.mdl", 1, 0, false); -- hands
		cwGear:HandleGear(entity, "models/props_swamp/chainsaw.mdl", "right hand", Vector(3, -1, 0), Angle(0, 0, 180), 0.7);

		entity:SetMaterial("effects/water_warp01");
		entity:EmitSound("weapons/chainsaw/chainsaw_start_0"..math.random(1, 2)..".wav", 75);

		hook.Add("EntityRemoved", entity, function()
			if (entity.cwChainsawSound) then
				entity.cwChainsawSound:Stop();
				entity.cwChainsawSound = nil;
			end;
		end);
		
		hook.Add("Think", entity:EntIndex().."_Chainsaws", function()
			if (!IsValid(entity)) then
				return;
			end;
			
			local curTime = CurTime();
			
			if (!entity.cwChainsawSound) then
				entity.cwChainsawSound = CreateSound(entity, "weapons/chainsaw/chainsaw_idle_lp_01.wav");
				entity.cwChainsawSound:PlayEx(0.75, math.random(85, 110));
			end;
			
			if (!entity.nextsasd or curTime > entity.nextsasd) then
				entity.nextsasd = curTime + 6;
				
				if (entity.cwChainsawSound) then
					entity.cwChainsawSound:Stop();
					entity.cwChainsawSound = nil;
					
					if (entity.sawasd == 1) then
						entity.cwChainsawSound = CreateSound(entity, "weapons/chainsaw/chainsaw_high_speed_lp_01.wav");
						entity.cwChainsawSound:PlayEx(0.75, math.random(85, 110));
					else
						entity.cwChainsawSound = CreateSound(entity, "weapons/chainsaw/chainsaw_idle_lp_01.wav");
						entity.cwChainsawSound:PlayEx(0.75, math.random(85, 110));
					end;
				end;
			end;
			
			if (!entity.sawasd) then
				entity.sawasd = 0;
			end;
			
			if (IsValid(entity:GetEnemy())) then
				if (entity.sawasd == 0) then
					if (entity.cwChainsawSound) then
						entity.cwChainsawSound:Stop();
						entity.cwChainsawSound = nil;
					end;
					
					entity.cwChainsawSound = CreateSound(entity, "weapons/chainsaw/chainsaw_high_speed_lp_01.wav");
					entity.cwChainsawSound:PlayEx(0.75, math.random(85, 110));
					entity.sawasd = 1;
					
					local en = table.Random({"begotten/npc/brute/attack_launch01.mp3", "begotten/npc/brute/attack_launch02.mp3", "begotten/npc/brute/attack_launch03.mp3"})
					entity:EmitSound(en, 90, 100);
				end;
			else
				if (entity.sawasd == 1) then
					if (entity.cwChainsawSound) then
						entity.cwChainsawSound:Stop();
						entity.cwChainsawSound = nil;
					end;
					
					entity.cwChainsawSound = CreateSound(entity, "weapons/chainsaw/chainsaw_idle_lp_01.wav");
					entity.cwChainsawSound:PlayEx(0.75, math.random(85, 110));
					entity.sawasd = 0;
				end;
			end;
		end);
	elseif name == "npc_bgt_shambler" or string.lower(name) == "shambler" then
		entity = ents.Create("npc_bgt_shambler");
		
		entity:SetModel("models/Zombie/Fast.mdl");
		entity:SetPos(spawnPos)
		entity:SetAngles(angles);
		entity:Spawn();
		entity:Activate();

		cwParts:HandleClothing(entity, "models/undead/corpse1.mdl", 0, 0, false);
		
		entity:SetMaterial("effects/water_warp01");
	elseif name == "npc_bgt_suitor" or string.lower(name) == "suitor" then
		entity = ents.Create("npc_bgt_suitor");
		
		entity:SetModel("models/zombie/zombie_soldier.mdl")
		entity:SetPos(spawnPos)
		entity:SetAngles(angles);
		entity:Spawn();
		entity:Activate();
		
		cwParts:HandleClothing(entity, "models/undead/poison.mdl", 1, 0, true); -- torso
		cwParts:HandleClothing(entity, "models/undead/poison.mdl", 2, 0, true); -- head
		cwParts:HandleClothing(entity, "models/Gibs/Fast_Zombie_Torso.mdl", 3, 0, true); -- hands
		cwParts:HandleClothing(entity, "models/zombie/zombie_soldier_legs.mdl", 4, 0, true); -- legs
		cwParts:HandleClothing(entity, "models/zombie/zombie_soldier.mdl", 3, 0, false); -- hands
		cwGear:HandleGear(entity, "models/props_swamp/chainsaw.mdl", "right hand", Vector(3, -1, 0), Angle(0, 0, 180), 0.7);
		cwGear:HandleGear(entity, "models/props_junk/meathook001a.mdl", "upper back", Vector(15, 4, 0), Angle(90, 180, 0), 1);
		
		entity:SetMaterial("effects/water_warp01");
		entity:EmitSound("weapons/chainsaw/chainsaw_start_0"..math.random(1, 2)..".wav", 75);

		hook.Add("EntityRemoved", entity, function()
			if (entity.cwChainsawSound) then
				entity.cwChainsawSound:Stop();
				entity.cwChainsawSound = nil;
			end;
		end);

		hook.Add("Think", entity:EntIndex().."_Chainsaws", function()
			if (!IsValid(entity)) then
				return;
			end;
			
			local curTime = CurTime();
			
			if (!entity.cwChainsawSound) then
				entity.cwChainsawSound = CreateSound(entity, "weapons/chainsaw/chainsaw_idle_lp_01.wav");
				entity.cwChainsawSound:PlayEx(0.75, math.random(85, 110));
			end;
			
			if (!entity.nextsasd or curTime > entity.nextsasd) then
				entity.nextsasd = curTime + 6;
				
				if (entity.cwChainsawSound) then
					entity.cwChainsawSound:Stop();
					entity.cwChainsawSound = nil;
					
					if (entity.sawasd == 1) then
						entity.cwChainsawSound = CreateSound(entity, "weapons/chainsaw/chainsaw_high_speed_lp_01.wav");
						entity.cwChainsawSound:PlayEx(0.75, math.random(85, 110));
					else
						entity.cwChainsawSound = CreateSound(entity, "weapons/chainsaw/chainsaw_idle_lp_01.wav");
						entity.cwChainsawSound:PlayEx(0.75, math.random(85, 110));
					end;
				end;
			end;
			
			if (!entity.sawasd) then
				entity.sawasd = 0;
			end;
			
			if (IsValid(entity:GetEnemy())) then
				if (entity.sawasd == 0) then
					if (entity.cwChainsawSound) then
						entity.cwChainsawSound:Stop();
						entity.cwChainsawSound = nil;
					end;
					
					entity.cwChainsawSound = CreateSound(entity, "weapons/chainsaw/chainsaw_high_speed_lp_01.wav");
					entity.cwChainsawSound:PlayEx(0.75, math.random(85, 110));
					entity.sawasd = 1;
					
					local en = table.Random({"begotten/npc/suitor/attack_launch01.mp3", "begotten/npc/suitor/attack_launch02.mp3"})
					entity:EmitSound(en, 90, 100);
				end;
			else
				if (entity.sawasd == 1) then
					if (entity.cwChainsawSound) then
						entity.cwChainsawSound:Stop();
						entity.cwChainsawSound = nil;
					end;
					
					entity.cwChainsawSound = CreateSound(entity, "weapons/chainsaw/chainsaw_idle_lp_01.wav");
					entity.cwChainsawSound:PlayEx(0.75, math.random(85, 110));
					entity.sawasd = 0;
				end;
			end;
		end);
	end
	
	return entity;
end