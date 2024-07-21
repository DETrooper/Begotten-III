local PLUGIN = PLUGIN;

-- Called when screen space effects should be rendered.
function cwGore:RenderScreenspaceEffects()
	if (Clockwork.Client:GetNetVar("blackOut") and Clockwork.Client:Alive()) then
		local blackOut = {
			[ "$pp_colour_brightness" ] = 0,
			[ "$pp_colour_contrast" ] = 0,
			[ "$pp_colour_colour" ] = 0,
		}
		
		DrawColorModify(blackOut);
	end;
end;

-- Called when an entity's target ID HUD should be painted.
function cwGore:HUDPaintEntityTargetID(entity, info)
	local colorTargetID = Clockwork.option:GetColor("target_id");
	local colorWhite = Clockwork.option:GetColor("white");
	
	if (entity:GetClass() == "prop_physics") then
		if (entity:GetModel() == "models/gibs/hgibs.mdl") then
			info.y = Clockwork.kernel:DrawInfo("A human skull.", info.x, info.y, colorTargetID, info.alpha);
		end;
	elseif (entity:GetClass() == "prop_ragdoll") then
		if (entity:GetModel() == "models/undead/charple01.mdl") then
			info.y = Clockwork.kernel:DrawInfo("A rotting body.", info.x, info.y, colorTargetID, info.alpha);
		elseif (entity:GetModel() == "models/skeleton/skeleton_torso2.mdl") then
			info.y = Clockwork.kernel:DrawInfo("A human ribcage.", info.x, info.y, colorTargetID, info.alpha);
		elseif (entity:GetModel() == "models/skeleton/skeleton_leg_l.mdl" or entity:GetModel() == "models/skeleton/skeleton_leg.mdl") then
			info.y = Clockwork.kernel:DrawInfo("A human leg bone.", info.x, info.y, colorTargetID, info.alpha);
		elseif (entity:GetModel() == "models/skeleton/skeleton_arm.mdl" or entity:GetModel() == "models/skeleton/skeleton_arm_l.mdl") then
			info.y = Clockwork.kernel:DrawInfo("A human arm bone.", info.x, info.y, colorTargetID, info.alpha);
		end;
		
		if (entity:GetSkin() == 2) then
			info.y = Clockwork.kernel:DrawInfo("It is still fresh with blood.", info.x, info.y, colorWhite, info.alpha);
		end;
	end;
end;

local fliesDist = (1024 * 1024);

local function FliesThink(entity)
	local withinDist = LocalPlayer():GetPos():DistToSqr(entity:GetPos()) < fliesDist;

	if !entity.rottingSound and entity:WaterLevel() < 3 and withinDist then
		entity.rottingSound = true;
	
		entity:EmitSound("ambient/creatures/housefly_loop_0"..tostring(math.random(1, 2))..".wav", 60, math.random(95, 105));
	elseif entity.rottingSound and !withinDist then
		entity:StopSound("ambient/creatures/housefly_loop_01.wav");
		entity:StopSound("ambient/creatures/housefly_loop_02.wav");
		
		entity.rottingSound = false;
	end
end

function cwGore:OnEntityCreated(entity)
	if entity:GetModel() == "models/undead/charple01.mdl" then
		FliesThink(entity);
	end
end

function cwGore:EntityRemoved(entity)
	if entity.rottingSound then
		entity:StopSound("ambient/creatures/housefly_loop_01.wav");
		entity:StopSound("ambient/creatures/housefly_loop_02.wav");
	end
end

function cwGore:OnEntityWaterLevelChanged(entity, oldLevel, newLevel)
	if entity:GetModel() == "models/undead/charple01.mdl" then
		if newLevel == 3 and entity.rottingSound then
			entity:StopSound("ambient/creatures/housefly_loop_01.wav");
			entity:StopSound("ambient/creatures/housefly_loop_02.wav");
			
			entity.rottingSound = false;
		end
	end
end

function cwGore:Think()
	local curTime = CurTime();

	if !self.nextFliesCheck or self.nextFliesCheck < curTime then
		self.nextFliesCheck = curTime + math.Rand(0.5, 1.5);
		
		for i, v in ipairs(ents.FindByModel("models/undead/charple01.mdl")) do
			FliesThink(v);
		end
	end
end

--[[

	plugin.Remove("LIMBS")
		LIMBS = {}
		LIMBS.Groups = {
			["left hand"] = {
				"ValveBiped.Bip01_L_Hand",
				"ValveBiped.Bip01_L_Wrist",
				"ValveBiped.Bip01_L_Finger0",
				"ValveBiped.Bip01_L_Finger1",
				"ValveBiped.Bip01_L_Finger2",
				"ValveBiped.Bip01_L_Finger3",
				"ValveBiped.Bip01_L_Finger4",
				"ValveBiped.Bip01_L_Finger01",
				"ValveBiped.Bip01_L_Finger02",
				"ValveBiped.Bip01_L_Finger11",
				"ValveBiped.Bip01_L_Finger12",
				"ValveBiped.Bip01_L_Finger21",
				"ValveBiped.Bip01_L_Finger22",
				"ValveBiped.Bip01_L_Finger31",
				"ValveBiped.Bip01_L_Finger32",
				"ValveBiped.Bip01_L_Finger41",
				"ValveBiped.Bip01_L_Finger42",
			},
			
			["right hand"] = {
				"ValveBiped.Bip01_R_Hand",
				"ValveBiped.Bip01_R_Wrist",
				"ValveBiped.Bip01_R_Finger0",
				"ValveBiped.Bip01_R_Finger1",
				"ValveBiped.Bip01_R_Finger2",
				"ValveBiped.Bip01_R_Finger3",
				"ValveBiped.Bip01_R_Finger4",
				"ValveBiped.Bip01_R_Finger01",
				"ValveBiped.Bip01_R_Finger02",
				"ValveBiped.Bip01_R_Finger11",
				"ValveBiped.Bip01_R_Finger12",
				"ValveBiped.Bip01_R_Finger21",
				"ValveBiped.Bip01_R_Finger22",
				"ValveBiped.Bip01_R_Finger31",
				"ValveBiped.Bip01_R_Finger32",
				"ValveBiped.Bip01_R_Finger41",
				"ValveBiped.Bip01_R_Finger42",
			},
			
			["left arm"] = {
				"ValveBiped.Bip01_Spine3",
				"ValveBiped.Bip01_L_UpperArm",
				"ValveBiped.Bip01_L_Forearm",
				"ValveBiped.Bip01_L_Hand",
				"ValveBiped.Bip01_L_Finger0",
				"ValveBiped.Bip01_L_Finger1",
				"ValveBiped.Bip01_L_Finger2",
				"ValveBiped.Bip01_L_Finger3",
				"ValveBiped.Bip01_L_Finger4",
				"ValveBiped.Bip01_L_Finger01",
				"ValveBiped.Bip01_L_Finger02",
				"ValveBiped.Bip01_L_Finger11",
				"ValveBiped.Bip01_L_Finger12",
				"ValveBiped.Bip01_L_Finger21",
				"ValveBiped.Bip01_L_Finger22",
				"ValveBiped.Bip01_L_Finger31",
				"ValveBiped.Bip01_L_Finger32",
				"ValveBiped.Bip01_L_Finger41",
				"ValveBiped.Bip01_L_Finger42",
			},
			
			["right arm"] = {
				"ValveBiped.Bip01_Spine3",
				"ValveBiped.Bip01_R_Shoulder",
				"ValveBiped.Bip01_R_UpperArm",
				"ValveBiped.Bip01_R_Forearm",
				"ValveBiped.Bip01_R_Hand",
				"ValveBiped.Bip01_R_Finger0",
				"ValveBiped.Bip01_R_Finger1",
				"ValveBiped.Bip01_R_Finger2",
				"ValveBiped.Bip01_R_Finger3",
				"ValveBiped.Bip01_R_Finger4",
				"ValveBiped.Bip01_R_Finger01",
				"ValveBiped.Bip01_R_Finger02",
				"ValveBiped.Bip01_R_Finger11",
				"ValveBiped.Bip01_R_Finger12",
				"ValveBiped.Bip01_R_Finger21",
				"ValveBiped.Bip01_R_Finger22",
				"ValveBiped.Bip01_R_Finger31",
				"ValveBiped.Bip01_R_Finger32",
				"ValveBiped.Bip01_R_Finger41",
				"ValveBiped.Bip01_R_Finger42",
			},
			
			["left leg"] = {
				"ValveBiped.Bip01_L_Calf",
				"ValveBiped.Bip01_L_Foot",
				"ValveBiped.Bip01_L_Toe0",
			},
			
			["right leg"] = {
				"ValveBiped.Bip01_R_Calf",
				"ValveBiped.Bip01_R_Foot",
				"ValveBiped.Bip01_R_Toe0",
			},
			
			["leftarm"] = {
				"ValveBiped.Bip01_Spine3",
				"ValveBiped.Bip01_L_UpperArm",
				"ValveBiped.Bip01_L_Forearm",
				"ValveBiped.Bip01_L_Hand",
				"ValveBiped.Bip01_L_Finger0",
				"ValveBiped.Bip01_L_Finger1",
				"ValveBiped.Bip01_L_Finger2",
				"ValveBiped.Bip01_L_Finger3",
				"ValveBiped.Bip01_L_Finger4",
				"ValveBiped.Bip01_L_Finger01",
				"ValveBiped.Bip01_L_Finger02",
				"ValveBiped.Bip01_L_Finger11",
				"ValveBiped.Bip01_L_Finger12",
				"ValveBiped.Bip01_L_Finger21",
				"ValveBiped.Bip01_L_Finger22",
				"ValveBiped.Bip01_L_Finger31",
				"ValveBiped.Bip01_L_Finger32",
				"ValveBiped.Bip01_L_Finger41",
				"ValveBiped.Bip01_L_Finger42",
			},
			
			["rightarm"] = {
				"ValveBiped.Bip01_Spine3",
				"ValveBiped.Bip01_R_Shoulder",
				"ValveBiped.Bip01_R_UpperArm",
				"ValveBiped.Bip01_R_Forearm",
				"ValveBiped.Bip01_R_Hand",
				"ValveBiped.Bip01_R_Finger0",
				"ValveBiped.Bip01_R_Finger1",
				"ValveBiped.Bip01_R_Finger2",
				"ValveBiped.Bip01_R_Finger3",
				"ValveBiped.Bip01_R_Finger4",
				"ValveBiped.Bip01_R_Finger01",
				"ValveBiped.Bip01_R_Finger02",
				"ValveBiped.Bip01_R_Finger11",
				"ValveBiped.Bip01_R_Finger12",
				"ValveBiped.Bip01_R_Finger21",
				"ValveBiped.Bip01_R_Finger22",
				"ValveBiped.Bip01_R_Finger31",
				"ValveBiped.Bip01_R_Finger32",
				"ValveBiped.Bip01_R_Finger41",
				"ValveBiped.Bip01_R_Finger42",
			},
			
			["leftleg"] = {
				"ValveBiped.Bip01_L_Calf",
				"ValveBiped.Bip01_L_Foot",
				"ValveBiped.Bip01_L_Toe0",
			},
			
			["rightleg"] = {
				"ValveBiped.Bip01_R_Calf",
				"ValveBiped.Bip01_R_Foot",
				"ValveBiped.Bip01_R_Toe0",
			},
			
			["left foot"] = {
				"ValveBiped.Bip01_L_Foot",
				"ValveBiped.Bip01_L_Toe0",
			},
			
			["right foot"] = {
				"ValveBiped.Bip01_R_Foot",
				"ValveBiped.Bip01_R_Toe0",
			},
			
			["left calf"] = {
				"ValveBiped.Bip01_L_Calf",
				"ValveBiped.Bip01_L_Foot",
				"ValveBiped.Bip01_L_Toe0",
			},
			
			["right calf"] = {
				"ValveBiped.Bip01_R_Calf",
				"ValveBiped.Bip01_R_Foot",
				"ValveBiped.Bip01_R_Toe0",
			},
			
			["head"] = {
				"ValveBiped.Bip01_Neck1",
				"ValveBiped.Bip01_Head1",
			},
		}

		-- A function to resize a bone.
		function LIMBS:ResizeBone(data) -- begin anew
			local entity = data.entity;
			local boneID = data.boneID;
			local scale = data.scale;

			local entity = data.entity or nil
			local boneID = data.boneID or nil
			local scale = data.scale or Vector(1, 1, 1)

			if (!IsValid(entity) or !boneID) then
				return
			end
			
			local index = entity:EntIndex()
			
			if (!Clockwork.Client.BoneRescales) then
				Clockwork.Client.BoneRescales = {}
			end
			
			if (!Clockwork.Client.BoneRescales[index]) then
				Clockwork.Client.BoneRescales[index] = {}
			end
			
			Clockwork.Client.BoneRescales[index][boneID] = scale
			entity:ManipulateBoneScale(boneID, scale)
		end
		
		-- A function to reset all of an entity's bone scales.
		function LIMBS:ResetBoneScale(entity)
			if (!Clockwork.Client.BoneRescales) then
				Clockwork.Client.BoneRescales = {}
			end
			
			local index = entity:EntIndex()
			
			if (Clockwork.Client.BoneRescales[index]) then
				for k, v in pairs (Clockwork.Client.BoneRescales[index]) do
					entity:ManipulateBoneScale(k, Vector(1, 1, 1))
				end
			end
		end
		
		Clockwork.datastream:Hook("ResetBoneScale", function(data)
			if (type(data) == "Player" or type(data) == "Entity" and IsValid(data)) then
				LIMBS:ResetBoneScale(data)
			end
		end)
		
		for k, v in pairs (_player.GetAll()) do
			LIMBS:ResetBoneScale(v)
		end
		
		Clockwork.datastream:Hook("ResizeBone", function(data)
			if (IsValid(data.entity)) then
				if (data.removeGroup and LIMBS.Groups[data.removeGroup]) then
					for k, v in pairs (LIMBS.Groups[data.removeGroup]) do
						data.boneID = data.entity:LookupBone(v)
						LIMBS:ResizeBone(data)
					end
				
					return
				end
				
				LIMBS:ResizeBone(data)
			end
		end)

		plugin.Add("LIMBS", LIMBS)
--]]