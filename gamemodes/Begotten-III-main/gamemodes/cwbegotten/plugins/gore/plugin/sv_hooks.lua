--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

-- Called every tick.
function cwGore:Think()
	local curTime = CurTime();
	
	if (!self.nextCleanUp) then
		self.nextCleanUp = curTime + 900;
	elseif (curTime > self.nextCleanUp) then
		for k, v in pairs (ents.FindByClass("prop_ragdoll")) do
			local removeTable = {
				"models/skeleton/skeleton_arm.mdl",
				"models/skeleton/skeleton_arm_l.mdl",
				"models/skeleton/skeleton_leg.mdl",
				"models/skeleton/skeleton_leg_l.mdl",
				"models/skeleton/skeleton_torso.mdl",
				"models/skeleton/skeleton_torso2.mdl",
				"models/skeleton/skeleton_torso1.mdl",
				"models/skeleton/skeleton_arm.mdl",
			};
			
			if (table.HasValue(removeTable, v:GetModel())) then
				v:Remove();
			end;
		end;
		
		for k, v in pairs (ents.FindByClass("prop_physics")) do
			local removeTable = {
				"models/props_junk/watermelon01_chunk02a.mdl",
				"models/gibs/antlion_gib_medium_1.mdl",
				"models/gibs/antlion_gib_small_2.mdl",
				"models/gibs/antlion_gib_small_1.mdl",
				"models/props_junk/watermelon01_chunk02b.mdl",
				"models/props_junk/watermelon01_chunk02c.mdl",
				"models/gibs/hgibs.mdl",
			};
			
			if (table.HasValue(removeTable, v:GetModel())) then
				v:Remove();
			end;
		end;
		
		--[[for _, v in _player.Iterator() do
			v:ConCommand("r_cleardecals");
		end;]]--

		self.nextCleanUp = nil;
	end;
end;

-- Called when a player dies.
function cwGore:PlayerDeath(player, inflictor, attacker, damageInfo)
	if (!damageInfo) then
		local ragCorpse = player:GetRagdollEntity();
		
		if IsValid(ragCorpse) then
			self:RotCorpse(ragCorpse, 600);
		end
	
		return;
	end;

	if player.opponent then
		return;
	end
	
	local damage = damageInfo:GetDamage()
	local ragCorpse = player:GetRagdollEntity();
	
	if (damage > (player:GetMaxHealth() * 2)) and damageInfo:IsDamageType(DMG_CLUB) and (attacker:IsPlayer() or attacker:IsNPC() or attacker:IsNextBot()) and attacker ~= player then
		self:SplatCorpse(ragCorpse, 60);
	elseif damageInfo:IsDamageType(DMG_BLAST) or damageInfo:IsDamageType(DMG_CRUSH) or damageInfo:IsDamageType(DMG_FALL) then
		if (damage >= 75) then
			self:SplatCorpse(ragCorpse, 60);
		else
			self:RotCorpse(ragCorpse, 600);
		end
	elseif (damageInfo:IsDamageType(DMG_BUCKSHOT)) then
		if (damage >= 200) then
			self:SplatCorpse(ragCorpse, 60);
		else
			self:RotCorpse(ragCorpse, 600);
		end;
	else
		self:RotCorpse(ragCorpse, 600);
	end;
end;

-- Called when a player takes damage.
function cwGore:FuckMyLife(player, damageInfo)
	local damage = damageInfo:GetDamage();
	local isSlash = damageInfo:IsDamageType(DMG_SLASH);
	
	if (damage > 60) and isSlash then
		--[[if player:LastHitGroup() == HITGROUP_HEAD then
			if damage >= player:Health() then
				local attacker = damageInfo:GetAttacker();
				
				if IsValid(attacker) and attacker:IsPlayer() then
					local death_strings = {"is decapitated by", "'s head goes flying off in an arc, cut off by", "loses their head to"};
				
					Clockwork.chatBox:AddInTargetRadius(player, "me", death_strings[math.random(1, #death_strings)]..attacker:Name().."!", player:GetPos(), config.Get("talk_radius"):Get() * 2);
				end
				
				timer.Simple(1, function()
					local headEnt = ents.Create("prop_physics");
						headEnt:SetModel("models/gibs/hgibs.mdl");
						headEnt:SetPos(corpse:LocalToWorld(corpse:OBBCenter() + Vector(0, 0, 40)));
						headEnt:SetCollisionGroup(COLLISION_GROUP_WORLD);
					headEnt:Spawn();
				end);
			end
		else]]if (math.random(1, 2) == 2) then
			local gibEntity = ents.Create("prop_physics");
			
			if (math.random(1, 2) == 2) then
				gibEntity:SetModel("models/props_junk/watermelon01_chunk02b.mdl");
			else
				gibEntity:SetModel("models/props_junk/watermelon01_chunk02a.mdl");
			end;
			
			gibEntity:SetPos(damageInfo:GetDamagePosition());
			gibEntity:Spawn();
			gibEntity:SetMaterial("models/flesh");
			gibEntity:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
			
			timer.Simple(math.random(8, 16), function()
				if (IsValid(gibEntity)) then
					gibEntity:Remove();
				end;
			end)
		end;
		
		player:EmitSound("physics/body/body_medium_break"..math.random(2, 3)..".wav");
	end;
end;

-- Called when an entity is removed.
function Schema:EntityRemoved(entity)
	if (IsValid(entity) and entity:GetClass() == "prop_ragdoll") then
		local timerID = "CorpseDecay_"..tostring(entity:EntIndex());
		
		if timer.Exists(timerID) then
			timer.Remove(timerID);
		end
	end
end
--GORE

--[[

function cwGore:HasSharpObject(player)
	local inventory = Clockwork.inventory:GetItemsAsList(player:GetInventory());
	
	for k, v in pairs (inventory) do
		if (v.sharp) then
			
		end;
	end;
end;

		boneList = {
			["pelvis"] = "ValveBiped.Bip01_Pelvis",
			["stomach"] = "ValveBiped.Bip01_Spine",
			["lower back"] = "ValveBiped.Bip01_Spine1",
			["chest"] = "ValveBiped.Bip01_Spine2",
			["upper back"] = "ValveBiped.Bip01_Spine4",
			["neck"] = "ValveBiped.Bip01_Neck1",
			["head"] = "ValveBiped.Bip01_Head1",
			["right clavicle"] = "ValveBiped.Bip01_R_Clavicle",
			["right upper arm"] = "ValveBiped.Bip01_R_UpperArm",
			["right forearm"] = "ValveBiped.Bip01_R_Forearm",
			["right hand"] = "ValveBiped.Bip01_R_Hand",
			["left clavicle"] = "ValveBiped.Bip01_L_Clavicle",
			["left upper arm"] = "ValveBiped.Bip01_L_UpperArm",
			["left forearm"] = "ValveBiped.Bip01_L_Forearm",
			["left hand"] = "ValveBiped.Bip01_L_Hand",
			["right thigh"] = "ValveBiped.Bip01_R_Thigh",
			["right calf"] = "ValveBiped.Bip01_R_Calf",
			["right foot"] = "ValveBiped.Bip01_R_Foot",
			["right toe"] = "ValveBiped.Bip01_R_Toe0",
			["left thigh"] = "ValveBiped.Bip01_L_Thigh",
			["left calf"] = "ValveBiped.Bip01_L_Calf",
			["left foot"] = "ValveBiped.Bip01_L_Foot",
			["left toe"] = "ValveBiped.Bip01_L_Toe0"
		}

local bodypartItems = {
	["head"] = "ValveBiped.Bip01_Head1",
	["rightarm"] = "ValveBiped.Bip01_R_Forearm",
	["leftarm"] = "ValveBiped.Bip01_L_Forearm",
	["leftleg"] = "ValveBiped.Bip01_L_Thigh",
	["rightleg"] = "ValveBiped.Bip01_R_Thigh",
}

local goodGroups = {
	["head"] = true,
	["left arm"] = true,
	["right arm"] = true,
	["left hand"] = true,
	["right hand"] = true,
	["left leg"] = true,
	["right leg"] = true,
	["left calf"] = true,
	["right calf"] = true,
	["left foot"] = true,
	["right foot"] = true,
}

function cwGore:GiveBodyparts(entity, player)
	if (IsValid(entity) and IsValid(player)) then
		if (!entity.cwInventory) then
			entity.cwInventory = {};
		end;

		for k, v in pairs (bodypartItems) do
			if (!entity.bodyparts) then
				entity.bodyparts = {};
			end;
			
			if (entity.bodyparts[k] or (entity.cwInventory[k] and !table.IsEmpty(entity.cwInventory[k]))) then
				continue;
			end;
			
			local itemTable = item.CreateInstance(k)

			if (!itemTable or !itemTable:IsInstance()) then
				return {};
			end
			printp("sexpoop")
			local bodypart = Clockwork.inventory:AddInstance(entity.cwInventory, itemTable);
				bodypart:SetData("ownername", player:GetName());
				bodypart:SetData("ownerentity", entity:EntIndex());
			entity.bodyparts[k] = true;
		end;
	end;
end;

function cwGore:PlayerDeath(player, inflictor, attacker)
	timer.Simple(FrameTime() * 16, function()
		if (IsValid(player) and IsValid(player:GetRagdollEntity())) then
			self:GiveBodyparts(player:GetRagdollEntity(), player)
		end;
	end);
end;

function cwGore:OnEntityCreated(entity)
	timer.Simple(FrameTime(), function()
		if (IsValid(entity)) then
			if (entity.cwGoreperson) then
				self:SetupcwGoreman(entity)
			end;
			local player = Clockwork.entity:GetPlayer(entity);
			
			if (player and !player:Alive() and entity:GetClass() == "prop_ragdoll") then
				self:GiveBodyparts(entity, player)
			end;
		end;
	end);
end;

-- A function to explode a player's head.
function cwGore:ExplodeHead(player)
	if (!IsValid(player)) then
		return
	end
		
	if (player.decapitated) then
		return
	else
		player.decapitated = true
	end
		
	local class = player:GetClass()
	
	if (class == "prop_ragdoll") then
		local boneID = player:LookupBone("ValveBiped.Bip01_Head1")
		self:LimbExplodeEffects(player, boneID)
		self:RemoveLimb(player, "head")
		
	elseif (player:IsPlayer()) then
		if (player:Alive()) then
			player:Kill()
		end
		
		timer.Simple(FrameTime(), function()
			if (IsValid(player)) then
				local ragdollEntity = Clockwork.player:GetRagdollEntity(player)
						
				if (IsValid(ragdollEntity)) then
					self:RemoveLimb(ragdollEntity, "head")
					self:LimbExplodeEffects(ragdollEntity, ragdollEntity:LookupBone("ValveBiped.Bip01_Head1"))
				end
						
				player.decapitated = nil
			end
		end)
	end
end

-- A function to explode a player's head.
function cwGore:Explode(player, group)
	if (!IsValid(player)) then
		return
	end
	
	if (!player.removedLimbs) then
		player.removedLimbs = {};
	end;
	
	if (player.removedLimbs[group]) then
		return;
	else
		player.removedLimbs[group] = true;
	end;

	local class = player:GetClass()
	
	if (class == "prop_ragdoll") then
		self:LimbExplodeEffects(player, player:LookupBone(bodypartItems[group]))
		self:RemoveLimb(player, group)
		printp(group)
	elseif (player:IsPlayer()) then
		if (player:Alive() and group == "head") then
			player:Kill()
		end
		
		timer.Simple(FrameTime(), function()
			if (IsValid(player)) then
				local ragdollEntity = Clockwork.player:GetRagdollEntity(player)
						
				if (IsValid(ragdollEntity)) then
					self:RemoveLimb(ragdollEntity, group)
					self:LimbExplodeEffects(ragdollEntity, ragdollEntity:LookupBone(bodypartItems[group]))
				end
						
				player.decapitated = nil
			end
		end)
	end
end

-- A function to dispatch a bone scale to the entire server.
function cwGore:DispatchBoneScale(entity, bone, scale, removeGroup)
	if (!IsValid(entity) or type(scale) != "Vector") then
		return
	end
	local bone = bone or "head"
			
	if (!string.find(bone, "ValveBiped")) then
		if (boneList[bone]) then
			bone = boneList[bone]
		end
	end
	
	local boneID = entity:LookupBone(bone)
	local resizeTable = {entity = entity, boneID = boneID, scale = scale}
	
	if (removeGroup) then
		resizeTable.removeGroup = removeGroup
	end
	netstream.Start(nil, "ResizeBone", resizeTable)
end

local tras = {["rightarm"] = "right arm", ["leftarm"] = "left arm", ["rightleg"] = "right leg", ["leftleg"] = "left leg"}

-- A function to easily remove an entire limb group.
function cwGore:RemoveLimb(entity, group)
	local group = string.lower(group)
	if (tras[group]) then group = tras[group] end
	if (goodGroups[group]) then
		self:DispatchBoneScale(entity, nil, Vector(0, 0, 0), group)
	end
		
	if (entity:IsPlayer()) then
		hook.Run("PlayerLimbRemoved", entity, group)
	end
end

-- Called whenever a limb group is removed.
function cwGore:PlayerLimbRemoved(player, limb)
end

-- A function to dispatch a blood splatter effect.
function cwGore:BloodSplat(entity, position, bCritical)
	local position = position
	local effect = "bleedingsplat"
		
	if (bCritical) then
		effect = "bloodsplat"
	end
			
	if (type(position) == "string") then
		if (boneList[position]) then
			if (entity:LookupBone(boneList[position])) then
				position = entity:GetBonePosition(entity:LookupBone(boneList[position]))
			end
		end
	end
		
	local velocity = entity:GetVelocity()
	local length = velocity:Length()
			
	if (length > 70) then
		local forward = entity:GetForward()
		position = position + forward * (20 * (length / 70))
	end

	local effectData = EffectData()
		effectData:SetOrigin(position)
		effectData:SetEntity(entity)
	util.Effect(effect, effectData)
end
		
-- A function to dispatch a blood impact effect at a specified position.
function cwGore:BloodImpact(position, count)
	for i = 1, (count or 4) do 
		local effectData = EffectData()
			effectData:SetOrigin(position)
			effectData:SetScale(20)
		util.Effect("BloodImpact", effectData)
	end
end
		
-- A function to splatter blood around a position.
function cwGore:BloodSplatter(position, count)
	for i = 1, (count or 10) do 
		local trace = {}
			trace.start = position
			trace.endpos = trace.start + (Vector((math.random() * 2) - 1, (math.random() * 2) - 1, (math.random() * 2) - 1) * 200)
			trace.filter = {entity}
		local traceLine = util.TraceLine(trace)
		
		local startPos = traceLine.HitPos + traceLine.HitNormal
		local endPos = traceLine.HitPos - traceLine.HitNormal
		util.Decal("Blood", startPos, endPos)								
	end
end
		
-- A function to create an amount of gibs at a position.
function cwGore:CreateGibs(position, count)
	for i = 1, (math.Clamp(count, 1, 10) or 4) do 
		local gib = ents.Create("prop_physics")
		gib:SetModel("models/props_junk/watermelon01_chunk02a.mdl")
		gib:SetPos(position + Vector(math.random(0, 20), math.random(0, 20), math.random(0, 20)))
		gib:Spawn()
		gib:SetMaterial("models/flesh")
		gib:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		
		local physicsObject = gib:GetPhysicsObject()
			
		if (IsValid(physicsObject)) then
			physicsObject:ApplyForceCenter(VectorRand() * 1000)
		end
		
		timer.Simple(15, function()
			if (IsValid(gib)) then
				gib:Remove()
			end
		end)
	end
end
		
-- A function to dispatch a multitude of decapitation effects.
function cwGore:LimbExplodeEffects(entity, boneID)
	local position = entity:GetBonePosition(boneID)
			
	entity:EmitSound("physics/flesh/flesh_squishy_impact_hard3.wav", 500)
	entity:EmitSound("begotten/ambient/corpse/body_explode_jet.wav", 500)

	for i = 1, 4 do
		timer.Simple(0.05 * i, function()
			ParticleEffectAttach("blood_advisor_puncture_withdraw", PATTACH_POINT_FOLLOW, entity, boneID)
		end)
	end
			
	ParticleEffectAttach("blood_advisor_puncture_withdraw", PATTACH_POINT_FOLLOW, entity, boneID)
			
	self:BloodImpact(position, 4)
	self:BloodSplatter(position, 10)
	self:CreateGibs(position, math.random(2, 8))

	for i = 1, 2 do
		self:BloodSplat(entity, position, true)
	end

	for i = 1, 4 do
		self:BloodSplat(entity, position)
	end
end

function cwGore:PlayerCanUseCommand(player, commandTable, arguments)
	local name = commandTable.name;
	
	if (name == "StorageTakeItem") then
		if (bodypartItems[arguments[1]]--) then
--[[			local itemTable = item.FindInstance(arguments[2]);
			
			if (itemTable) then
				local entIndex = itemTable:GetData("ownerentity", 0);
				local entity = Entity(entIndex);
				
				if (!entity:IsWorld()) then
					cwGore:Explode(entity, arguments[1])
				end;
			end;
		end;
	end;
end;
--]]
--END GORE