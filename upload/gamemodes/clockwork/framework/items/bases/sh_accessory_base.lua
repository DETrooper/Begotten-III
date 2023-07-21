--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

local ITEM = item.New(nil, true);
	ITEM.name = "Accessory Base"
	ITEM.model = "models/gibs/hgibs.mdl"
	ITEM.weight = 1
	ITEM.useText = "Wear"
	ITEM.category = "Accessories"
	ITEM.description = "An accessory you can wear."
	ITEM.isAttachment = true
	ITEM.attachmentBone = "ValveBiped.Bip01_Head1"
	ITEM.attachmentOffsetAngles = Angle(270, 270, 0)
	ITEM.attachmentOffsetVector = Vector(0, 3, 3)
	ITEM.equippable = false; -- this blocks equipping the item as a melee weapon.

	-- Called when a player wears the accessory.
	function ITEM:OnWearAccessory(player, bIsWearing) end

	-- Called to get whether a player has the item equipped.
	function ITEM:HasPlayerEquipped(player, bIsValidWeapon)
		if (CLIENT) then
			return Clockwork.player:IsWearingAccessory(self)
		else
			return player:IsWearingAccessory(self)
		end
	end

	-- Called when a player has unequipped the item.
	function ITEM:OnPlayerUnequipped(player, extraData)
		player:RemoveAccessory(self)
	end

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position)
		if (player:IsWearingAccessory(self)) then
			Schema:EasyText(player, "peru", "You cannot drop an item you're currently wearing.")
			return false
		end
	end

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		if (player:Alive() and !player:IsRagdolled()) then
			if (!self.CanPlayerWear or self:CanPlayerWear(player, itemEntity) != false) then
				player:WearAccessory(self)
				return true
			end
		else
			Schema:EasyText(player, "peru", "You cannot do this action at this moment.")
		end

		return false
	end

	if (CLIENT) then
		function ITEM:GetClientSideInfo()
			if (!self:IsInstance()) then return end

			if (Clockwork.player:IsWearingAccessory(self)) then
				return "Is wearing? Yes."
			else
				return "Is wearing? No."
			end
		end
	end
ITEM:Register()