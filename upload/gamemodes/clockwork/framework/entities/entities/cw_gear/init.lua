--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

include("shared.lua")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

-- Called when the entity initializes.
function ENT:Initialize()
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetNotSolid(true)
	self:DrawShadow(false)
	self:SetNoDraw(true); -- Default NoDraw to true for first tick.
end

-- Called when the entity's transmit state should be updated.
function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end

-- A function to get whether the entity should exist.
function ENT:GetShouldExist(player)
	local itemTable = self:GetItemTable()

	if (itemTable) then
		if (itemTable.GetAttachmentExists) then
			return itemTable:GetAttachmentExists(player, self)
		elseif (item.IsWeapon(itemTable)) then
			local weaponClass = itemTable:GetWeaponClass()
			
			if (player:IsRagdolled()) then
				if player.bgWeaponData then
					for i = 1, #player.bgWeaponData do
						if player.bgWeaponData[i].uniqueID == itemTable.uniqueID then
							return true;
						end
					end
				
					return false;
				else
					return player:RagdollHasWeapon(weaponClass)
				end
			elseif player:HasWeapon(weaponClass) then
				return true;
			--elseif (player.bgShieldData and player.bgShieldData.uniqueID and player:HasWeapon(weaponClass.."_"..player.bgShieldData.uniqueID)) then
				--return true;
			end
		elseif (itemTable.HasPlayerEquipped) then
			return true;
		end
	end
end

-- A function to get whether the entity is visible.
function ENT:GetIsVisible(player)
	if player.cloaked then
		return false;
	end

	local itemTable = self:GetItemTable()

	if (itemTable) then
		if (itemTable.GetAttachmentVisible) then
			return itemTable:GetAttachmentVisible(player, self)
		elseif (item.IsWeapon(itemTable)) then
			local weapon_class = Clockwork.player:GetWeaponClass(player);
			
			if weapon_class == itemTable:GetWeaponClass() then
				return false;
			--[[elseif player.bgShieldData and player.bgShieldData.uniqueID then
				if weapon_class == itemTable:GetWeaponClass().."_"..player.bgShieldData.uniqueID then
					return false;
				else
					return true;
				end]]
			end
		elseif (itemTable.category == "Shields") and itemTable.uniqueID then
			--[[local weapon_class = Clockwork.player:GetWeaponClass(player);
			
			if weapon_class then
				if string.find(Clockwork.player:GetWeaponClass(player), itemTable.uniqueID) then
					return false;
				end
			end]]--
			
			local activeWeapon = player:GetActiveWeapon();
			
			if IsValid(activeWeapon) and activeWeapon:GetNWString("activeShield"):len() > 0 then
				return false;
			end
		end
		
		return true
	end
end

-- A function to set whether the player must have the item.
function ENT:SetMustHave(bMustHave)
	self.cwMustHave = bMustHave
end

-- A function to set the entity's item.
function ENT:SetItemTable(gearClass, itemTable)
	self.cwGearClass = gearClass
	self.cwItemTable = itemTable
	self:SetDTInt(0, itemTable.index)
end

-- Called each frame.
function ENT:Think()
	local player = self:GetPlayer()

	if (!IsValid(player)) then
		self:Remove()
		return
	end
	
	local curTime = CurTime();
	
	if !self.nextExistCheck or self.nextExistCheck < curTime then
		self.nextExistCheck = curTime + math.Rand(1.5, 2.5);
	
		if !self:GetShouldExist(player) then
			self:Remove()
			return
		end
		
		if (self.cwMustHave and !player:HasItemInstance(self.cwItemTable)) then
			Clockwork.player:RemoveGear(
				player, self.cwGearClass
			)
		end
	end

	if !self.nextColorCheck or self.nextColorCheck < curTime then
		local entityColor = self:GetColor()

		if (!self:GetIsVisible(player)) or self.cwItemTable.invisibleAttachment then
			self:SetColor(Color(entityColor.r, entityColor.g, entityColor.b, 0))
			self:SetNoDraw(true)
		else
			self:SetColor(Color(entityColor.r, entityColor.g, entityColor.b, 255))
			self:SetNoDraw(false)
		end

		self:SetMaterial(player:GetMaterial())
		
		self.nextColorCheck = curTime + math.Rand(0.5, 1);
	end

	--[[local model = self.cwItemTable.attachmentModel or self.cwItemTable.model

	if (self:GetModel() != model or (self.cwItemTable.ShouldGearRespawn and self.cwItemTable:ShouldGearRespawn(self))) then
		Clockwork.player:CreateGear(
			player, self.cwGearClass, self.cwItemTable
		)
	end]]--
end