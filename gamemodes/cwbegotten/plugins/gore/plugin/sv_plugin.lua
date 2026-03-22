--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

-- A function to turn a ragdoll into gibs.
function cwGore:SplatCorpse(corpse, fadeDelay, damageForce, onFire)
	local ignite = onFire or false
	local gibModels = {
		"models/props_junk/watermelon01_chunk02a.mdl",
		"models/gibs/antlion_gib_medium_1.mdl",
		"models/gibs/antlion_gib_small_2.mdl",
		"models/gibs/antlion_gib_small_1.mdl",
		"models/props_junk/watermelon01_chunk02b.mdl",
		"models/props_junk/watermelon01_chunk02c.mdl"
	};
	
	local dmgForce = damageForce or (Vector(0, 0, 1000) + (VectorRand() * 2000));

	if (IsValid(corpse)) then
		if (!fadeDelay) then 
			fadeDelay = 180;
		end;
		
		if (corpse:GetClass() == "prop_ragdoll") then
			cwMedicalSystem:DoBleedEffect(corpse, true);
			corpse:EmitSound("physics/flesh/flesh_squishy_impact_hard3.wav");
			corpse:EmitSound("begotten/ambient/corpse/body_splat1.wav");
			
			for i = 1, math.random(2, 6) do
				corpse:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav")
			end;

			local headEnt = ents.Create("prop_physics");
				headEnt:SetModel("models/gibs/hgibs.mdl");
				headEnt:SetPos(corpse:LocalToWorld(corpse:OBBCenter() + Vector(0, 0, 40)));
				headEnt:SetCollisionGroup(COLLISION_GROUP_WORLD);
			headEnt:Spawn();
			
			timer.Simple(fadeDelay / 2, function()
				if (IsValid(headEnt)) then
					headEnt:Remove();
				end;
			end);
			
			local headObject = headEnt:GetPhysicsObject();
			
			if (IsValid(headObject)) then
				headObject:ApplyForceCenter(dmgForce);
			end;
			
			cwMedicalSystem:DoBleedEffect(headEnt, true);
			
			for i = 1, math.random(2, 6) do 
				headEnt:EmitSound("physics/flesh/flesh_squishy_impact_hard"..math.random(1, 4)..".wav");
			end;
			
			timer.Simple(2, function()
				cwMedicalSystem:DoBleedEffect(headEnt, true);
			end)

			local torsoEnt = ents.Create("prop_ragdoll");
				torsoEnt:SetModel("models/skeleton/skeleton_torso2.mdl");
				torsoEnt:SetSkin(2);
				torsoEnt:SetPos(corpse:LocalToWorld(corpse:OBBCenter() + Vector(0, 0, 40)));
				torsoEnt:SetCollisionGroup(COLLISION_GROUP_WORLD);
			torsoEnt:Spawn();
			
			local torsoObject = torsoEnt:GetPhysicsObject();
			
			if (IsValid(torsoObject)) then
				torsoObject:ApplyForceCenter(dmgForce);
			end;
			
			cwMedicalSystem:DoBleedEffect(torsoEnt, true);
			
			timer.Simple(2, function()
				cwMedicalSystem:DoBleedEffect(torsoEnt, true);
			end)

			local rightLegEnt = ents.Create("prop_ragdoll");
				rightLegEnt:SetModel("models/skeleton/skeleton_leg_l.mdl");
				rightLegEnt:SetSkin(2);
				rightLegEnt:SetPos(corpse:LocalToWorld(corpse:OBBCenter() + Vector(0, 0, 20)));
				rightLegEnt:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR);
			rightLegEnt:Spawn();
			
			local rLegObject = rightLegEnt:GetPhysicsObject();
			
			if (IsValid(rLegObject)) then
				rLegObject:ApplyForceCenter(dmgForce);
			end;
			
			cwMedicalSystem:DoBleedEffect(rightLegEnt, true);
			
			timer.Simple(2, function()
				cwMedicalSystem:DoBleedEffect(rightLegEnt, true);
			end)

			local leftLegEnt = ents.Create("prop_ragdoll");
				leftLegEnt:SetModel("models/skeleton/skeleton_leg_l.mdl");
				leftLegEnt:SetSkin(2);
				leftLegEnt:SetPos(corpse:LocalToWorld(corpse:OBBCenter() + Vector(0, 0, 20)));
				leftLegEnt:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR);
			leftLegEnt:Spawn();
			
			local lLegObject = rightLegEnt:GetPhysicsObject();
			
			if (IsValid(lLegObject)) then
				lLegObject:ApplyForceCenter(dmgForce);
			end;
			
			cwMedicalSystem:DoBleedEffect(leftLegEnt, true);
			
			timer.Simple(2, function()
				cwMedicalSystem:DoBleedEffect(leftLegEnt, true);
			end)

			local rightArmEnt = ents.Create("prop_ragdoll");
				rightArmEnt:SetModel("models/skeleton/skeleton_arm.mdl");
				rightArmEnt:SetSkin(2);
				rightArmEnt:SetPos(corpse:LocalToWorld(corpse:OBBCenter() + Vector(0, 0, 30)));
				rightArmEnt:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR);
			rightArmEnt:Spawn();
			
			local rArmObject = rightArmEnt:GetPhysicsObject();
			
			if (IsValid(rArmObject)) then
				rArmObject:ApplyForceCenter(dmgForce);
			end;
			
			cwMedicalSystem:DoBleedEffect(rightArmEnt, true);
			
			timer.Simple(2, function()
				cwMedicalSystem:DoBleedEffect(rightArmEnt, true);
			end)
			
			local leftArmEnt = ents.Create("prop_ragdoll");
				leftArmEnt:SetModel("models/skeleton/skeleton_arm_l.mdl");
				leftArmEnt:SetSkin(2);
				leftArmEnt:SetPos(corpse:LocalToWorld(corpse:OBBCenter() + Vector(0, 0, 30)));
				leftArmEnt:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR);
			leftArmEnt:Spawn();
			
			local lArmObject = leftArmEnt:GetPhysicsObject();
			
			if (IsValid(lArmObject)) then
				lArmObject:ApplyForceCenter(dmgForce);
			end;
			
			cwMedicalSystem:DoBleedEffect(leftArmEnt, true);
			
			timer.Simple(2, function()
				cwMedicalSystem:DoBleedEffect(leftArmEnt, true);
			end)
			
			for i = 1, math.random(10, 14) do 
				local gibEnt = ents.Create("prop_physics");
					gibEnt:SetModel(table.Random(gibModels));
					gibEnt:SetMaterial("models/flesh");
					gibEnt:SetPos(corpse:GetPos() + Vector(math.random(0, 20), math.random(0, 20), math.random(0, 20)));
					gibEnt:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR);
					gibEnt:SetHealth(10000);
				gibEnt:Spawn();
				
				timer.Simple(2, function()
					cwMedicalSystem:DoBleedEffect(gibEnt, true);
				end)

				local gibObject = gibEnt:GetPhysicsObject();
				
				if (IsValid(gibObject)) then
					gibObject:ApplyForceCenter(dmgForce);
				end;
				
				timer.Simple(fadeDelay / 2, function()
					if (IsValid(gibEnt)) then
						gibEnt:Remove();
					end;
				end);
			end;
			
			local entList = {
				headEnt,
				torsoEnt,
				rightArmEnt,
				leftArmEnt,
				rightLegEnt,
				leftLegEnt
			};
			
			for k, v in pairs (entList) do
				if ignite then
					v:Ignite(fadeDelay);
				end
				if (math.random(1, 2) == 2) then
					ParticleEffectAttach("blood_advisor_puncture_withdraw", PATTACH_ABSORIGIN_FOLLOW, v, 0);
				end;
				
				timer.Simple(fadeDelay / 2, function()
					if (IsValid(v)) then
						v:SetSkin(3);
					end;
				end);
			end;

			timer.Simple(fadeDelay, function()
				for k, v in pairs(entList) do
					if (IsValid(v)) then
						v:Remove();
					end;
				end;
			end);

			timer.Simple(0.1, function()
				if IsValid(corpse) then
					corpse:Remove();
				end
			end);
		end;
	end;
end;

-- A function to rot an entity's body.
function cwGore:RotCorpse(entity, delay)
	if (!delay) then
		local delay = 30;
	end;
	
	if (IsValid(entity) and entity:GetClass() == "prop_ragdoll") then
		timer.Create("CorpseDecay_"..tostring(entity:EntIndex()), delay, 1, function()
			if (!IsValid(entity)) then
				return;
			end;
			
			local corpse = ents.Create("prop_ragdoll");
				corpse:SetPos(entity:GetPos());
				corpse:SetAngles(entity:GetAngles());			
				corpse:SetModel("models/undead/charple01.mdl");
				corpse:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
			corpse:Spawn();

			if (IsValid(corpse)) then
				local headIndex = corpse:LookupBone("ValveBiped.Bip01_Head1");
				local velocity = entity:GetVelocity();
				local corpseIndex = corpse:EntIndex()
				local physCount = corpse:GetPhysicsObjectCount();
				
				for i = 1, physCount do
					local physicsObject = corpse:GetPhysicsObjectNum(i);
					local boneIndex = corpse:TranslatePhysBoneToBone(i);
					local position, angle = entity:GetBonePosition(boneIndex);
					
					if (IsValid(physicsObject) and position and angle) then
						physicsObject:SetPos(position);
						physicsObject:SetAngles(angle);
						
						if (boneIndex == headIndex) then
							physicsObject:SetVelocity(velocity * 2);
						else
							physicsObject:SetVelocity(velocity);
						end;
						
						if (force) then
							if (boneIndex == headIndex) then
								physicsObject:ApplyForceCenter(force * 2);
							else
								physicsObject:ApplyForceCenter(force);
							end;
						end;
					end;
				end;
				
				entity:Remove();
				
				local timeRemove = delay * 2;

				timer.Create("CorpseDecay_"..tostring(corpse:EntIndex()), timeRemove, 1, function()
					if (IsValid(corpse)) then
						local headEnt = ents.Create("prop_physics");
							headEnt:SetModel("models/gibs/hgibs.mdl");
							headEnt:SetPos(corpse:LocalToWorld(corpse:OBBCenter() + Vector(0, 0, 40)));
							headEnt:SetCollisionGroup(COLLISION_GROUP_WORLD);
						headEnt:Spawn();
						
						local torsoEnt = ents.Create("prop_ragdoll");
							torsoEnt:SetModel("models/skeleton/skeleton_torso2.mdl");
							torsoEnt:SetSkin(2);
							torsoEnt:SetPos(corpse:LocalToWorld(corpse:OBBCenter() + Vector(0, 0, 40)));
							torsoEnt:SetCollisionGroup(COLLISION_GROUP_WORLD);
						torsoEnt:Spawn();

						local rightLegEnt = ents.Create("prop_ragdoll");
							rightLegEnt:SetModel("models/skeleton/skeleton_leg_l.mdl");
							rightLegEnt:SetSkin(2);
							rightLegEnt:SetPos(corpse:LocalToWorld(corpse:OBBCenter() + Vector(0, 0, 20)));
							rightLegEnt:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR);
						rightLegEnt:Spawn();

						local leftLegEnt = ents.Create("prop_ragdoll");
							leftLegEnt:SetModel("models/skeleton/skeleton_leg_l.mdl");
							leftLegEnt:SetSkin(2);
							leftLegEnt:SetPos(corpse:LocalToWorld(corpse:OBBCenter() + Vector(0, 0, 20)));
							leftLegEnt:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR);
						leftLegEnt:Spawn();

						local rightArmEnt = ents.Create("prop_ragdoll");
							rightArmEnt:SetModel("models/skeleton/skeleton_arm.mdl");
							rightArmEnt:SetSkin(2);
							rightArmEnt:SetPos(corpse:LocalToWorld(corpse:OBBCenter() + Vector(0, 0, 30)));
							rightArmEnt:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR);
						rightArmEnt:Spawn();

						local leftArmEnt = ents.Create("prop_ragdoll");
							leftArmEnt:SetModel("models/skeleton/skeleton_arm_l.mdl");
							leftArmEnt:SetSkin(2);
							leftArmEnt:SetPos(corpse:LocalToWorld(corpse:OBBCenter() + Vector(0, 0, 30)));
							leftArmEnt:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR);
						leftArmEnt:Spawn();
						
						local entList = {
							headEnt,
							torsoEnt,
							rightArmEnt,
							leftArmEnt,
							rightLegEnt,
							leftLegEnt
						};
						
						cwMedicalSystem:DoBleedEffect(corpse, 30);
						
						for i = 1, 3 do
							corpse:EmitSound("physics/flesh/flesh_squishy_impact_hard"..math.random(2, 4)..".wav", 80);
						end;
						
						for k, v in pairs (entList) do
							timer.Simple(timeRemove, function()
								if (IsValid(v)) then
									v:SetSkin(3);
								end;
							end);
							
							timer.Simple(timeRemove * 2, function()
								if (IsValid(v)) then
									v:Remove();
								end;
							end);
						end;
						
						for i = 1, 2 do
							corpse:EmitSound("physics/body/body_medium_break"..math.random(2, 3)..".wav");
						end;
						
						corpse:Remove();
					end;
				end);
			end;
		end);
	end;
end;

-- A function to make a blood effect.
function cwGore:BloodEffect(entity, position)
	if (!IsValid(entity) or entity:IsWorld()) then
		return;
	elseif (!position) then
		position = entity:GetPos();
	end;
	
	ParticleEffect("blood_advisor_puncture_withdraw", position, AngleRand(), entity);
	entity:EmitSound("begotten/ambient/corpse/body_flow.wav", 80, 100);
end;