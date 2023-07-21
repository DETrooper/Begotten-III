--[[
	cwdamation created & developed by cash wednesday
--]]

local PLUGIN = PLUGIN;
local boneList = {
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
};

function cwGear:BoneShortToFull(bone)
	return boneList[bone];
end;

function cwGear:BoneFullToShort(bone)
	for k, v in pairs(boneList) do
		if v == bone then
			return k;
		end;
	end;
end;

function cwGear:PostPlayerSpawn(player, lightSpawn, changeClass, firstSpawn)
	if (!lightSpawn) then
		if (!player.gear) then
			player.gear = {};
		end;
	end;
end;

-- A function to create new gear for the entity.
function cwGear:HandleGear(entity, model, bone, offset, angle, scale, skin, bIsVisible, decay)
	local bone = bone or "head";
	
	if (!entity.gear) then
		entity.gear = {};
	end;
	
	if (entity.gear[bone]) then
		self:RemoveGear(entity, bone);
	end;
	
	entity.gear[bone] = {};
	
	local model = model or "models/gibs/hgibs.mdl";
	local offset = offset or Vector(0, 0, 0);
	local angle = angle or Angle(0, 0, 0);
	local scale = scale or 1;
	local skin = skin or 0;
	local bIsVisible = bIsVisible or true;
	local decay = decay;
	
	entity.gear[bone]["entity"] = ents.Create("cw_gearhandler");
		entity.gear[bone]["entity"]:SetModel(model);
		entity.gear[bone]["entity"]:SetSkin(skin);
		entity.gear[bone]["entity"]:SetParent(entity);
		entity.gear[bone]["entity"]:SetPos(entity:GetPos());
		entity.gear[bone]["entity"]:SetAngles(entity:GetAngles());
		entity.gear[bone]["entity"]:SetDTInt(1, entity:LookupBone(self:BoneShortToFull(bone)));
		entity.gear[bone]["entity"]:SetDTInt(2, scale);
		entity.gear[bone]["entity"]:SetDTEntity(1, entity);
		entity.gear[bone]["entity"]:SetDTAngle(1, angle);
		entity.gear[bone]["entity"]:SetDTVector(1, offset);
		entity.gear[bone]["entity"]:SetDTBool(1, bIsVisible);
		entity.gear[bone]["entity"]:SetNWInt("scale", scale);
	entity.gear[bone]["entity"]:Spawn();
	
	if (decay and type(decay) == "number") then
		timer.Simple(decay, function()
			self:RemoveGear(entity, bone);
		end);
	end;
	
	return entity.gear[bone]["entity"];
end;

-- A function to remove any gear attached to the bone of an entity.
function cwGear:RemoveGear(entity, bone)
	if (entity.gear[bone]) then
		entity.gear[bone]["entity"]:Remove();
		entity.gear[bone] = nil;
	end;
end;
	
-- A function to remove all gear from an entity.
function cwGear:RemoveAllGear(entity)
	if (entity.gear) then
		for k, v in pairs(entity.gear) do
			self:RemoveGear(entity, k);
		end;
	end;

	entity.gear = {};
end;