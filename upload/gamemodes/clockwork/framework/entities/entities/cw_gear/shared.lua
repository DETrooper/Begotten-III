--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

DEFINE_BASECLASS("base_gmodentity")

ENT.Type = "anim"
ENT.Author = "kurozael"
ENT.PrintName = "Gear"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.UsableInVehicle = true

-- Called when the data tables are setup.
function ENT:SetupDataTables()
	self:DTVar("Int", 0, "Index")
end

-- A function to get the entity's real position.
function ENT:GetRealPosition()
	local offsetVector = self:GetOffsetVector()
	local offsetAngle = self:GetOffsetAngle()
	local itemTable = self:GetItemTable()
	local player = self:GetPlayer()
	local bone = player:LookupBone(self:GetBone())
	
	if (offsetVector and offsetAngle and player and bone) then
		local position, angles = player:GetBonePosition(bone)
		local ragdollEntity = player:GetRagdollEntity()

		if (itemTable.AdjustAttachmentOffsetInfo) then
			local info = {
				offsetVector = offsetVector,
				offsetAngle = offsetAngle
			}

			itemTable:AdjustAttachmentOffsetInfo(player, self, info)
			offsetVector = info.offsetVector
			offsetAngle = info.offsetAngle
		end

		if (ragdollEntity) then
			position, angles = ragdollEntity:GetBonePosition(bone)
		end

		local x = angles:Up() * offsetVector.x
		local y = angles:Right() * offsetVector.y
		local z = angles:Forward() * offsetVector.z

		angles:RotateAroundAxis(angles:Forward(), offsetAngle.p)
		angles:RotateAroundAxis(angles:Right(), offsetAngle.y)
		angles:RotateAroundAxis(angles:Up(), offsetAngle.r)

		return position + x + y + z, angles
	end
end

function ENT:GetSecondaryRealPosition()
	local offsetVector = self:GetSecondaryOffsetVector()
	local offsetAngle = self:GetSecondaryOffsetAngle()
	local itemTable = self:GetItemTable()
	local player = self:GetPlayer()
	local bone = player:LookupBone(self:GetSecondaryBone())
	
	if (offsetVector and offsetAngle and player and bone) then
		local position, angles = player:GetBonePosition(bone)
		local ragdollEntity = player:GetRagdollEntity()

		if (itemTable.AdjustAttachmentOffsetInfo) then
			local info = {
				offsetVector = offsetVector,
				offsetAngle = offsetAngle
			}

			itemTable:AdjustAttachmentOffsetInfo(player, self, info)
			offsetVector = info.offsetVector
			offsetAngle = info.offsetAngle
		end

		if (ragdollEntity) then
			position, angles = ragdollEntity:GetBonePosition(bone)
		end

		local x = angles:Up() * offsetVector.x
		local y = angles:Right() * offsetVector.y
		local z = angles:Forward() * offsetVector.z

		angles:RotateAroundAxis(angles:Forward(), offsetAngle.p)
		angles:RotateAroundAxis(angles:Right(), offsetAngle.y)
		angles:RotateAroundAxis(angles:Up(), offsetAngle.r)

		return position + x + y + z, angles
	end
end

-- A function to get the entity's bone.
function ENT:GetBone()
	local itemTable = self:GetItemTable()
	return itemTable.attachmentBone or ""
end

-- A function to get the entity's secondary bone.
function ENT:GetSecondaryBone()
	local itemTable = self:GetItemTable()
	return itemTable.secondaryAttachmentBone or "";
end


-- A function to get the entity's item table.
function ENT:GetItemTable()
	if (CLIENT) then
		local itemTable = Clockwork.entity:FetchItemTable(self)

		if (!itemTable) then
			return item.FindByID(self:GetDTInt(0))
		else
			return itemTable
		end
	end

	return self.cwItemTable
end

-- A function to get the entity's player.
function ENT:GetPlayer()
	local player = self:GetOwner()

	if (IsValid(player) and player:IsPlayer()) then
		return player
	end
end

-- A function to get the entity's offset vector.
function ENT:GetOffsetVector()
	local itemTable = self:GetItemTable()
	local offsetAngle = itemTable.attachmentOffsetVector or Vector(0, 0, 0);
	
	if itemTable.category == "Shields" then
		local backpackData = {}
		local player = self:GetPlayer();
		
		if IsValid(player) then
			backpackData = player:GetNetVar("backpacks", {});
		end
		
		if backpackData and istable(backpackData) and backpackData[1] then
			if backpackData[1].uniqueID == "gore_pouch" then
				local backpackItemTable = item.FindByID(backpackData[1].uniqueID);
				
				if backpackItemTable and backpackItemTable.attachmentOffsetVector then
					offsetAngle = offsetAngle + (backpackItemTable.attachmentOffsetVector) + Vector(0, 5.5, 4);
				end
			else
				local backpackItemTable = item.FindByID(backpackData[1].uniqueID);
				
				if backpackItemTable and backpackItemTable.attachmentOffsetVector then
					offsetAngle = offsetAngle + (backpackItemTable.attachmentOffsetVector) - Vector(-1, 0.5, -1);
				end
			end
		end
	end
	
	--[[if itemTable.category == "Backpacks" then
		local weaponData = {}
		
		if (CLIENT) then
			weaponData = Clockwork.Client.bgWeaponData or {};
		else
			weaponData = self:GetPlayer().bgWeaponData or {};
		end
		
		if weaponData then
			for i = 1, #weaponData do
				local weaponItemTable = item.FindByID(weaponData[i].uniqueID);
				
				printp(weaponItemTable);
				
				if weaponItemTable and weaponItemTable.attachmentOffsetVector then
					offsetAngle = offsetAngle + (weaponItemTable.attachmentOffsetVector) + Vector(0, 5, 0);
					break;
				end
			end
		end
	end]]--

	return offsetAngle;
end

-- A function to get the entity's offset vector.
function ENT:GetSecondaryOffsetVector()
	local itemTable = self:GetItemTable()
	return itemTable.secondaryAttachmentOffsetVector or Vector(0, 0, 0)
end

-- A function to get the entity's offset angle.
function ENT:GetOffsetAngle()
	local itemTable = self:GetItemTable()
	return itemTable.attachmentOffsetAngles or Angle(0, 0, 0)
end

-- A function to get the entity's offset angle.
function ENT:GetSecondaryOffsetAngle()
	local itemTable = self:GetItemTable()
	return itemTable.secondaryAttachmentOffsetAngles or Angle(0, 0, 0)
end