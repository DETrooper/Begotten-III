--[[
	© 2016 TeslaCloud Studios.
	Private code for Global Cooldown community.
	Stealing Lua cache is not nice lol.
	get a life kiddos.
--]]

local ITEM = Clockwork.item:New(nil, true)
	ITEM.name 			= "Skin Base"
	ITEM.model 			= "models/props_borealis/bluebarrel001.mdl"
	ITEM.skin 			= 1
	ITEM.weight 		= 1
	ITEM.useText 		= "Wear"
	ITEM.category 		= "Clothing"
	ITEM.description 	= "Default Skin Clothing Item."
	ITEM.playerSkin 	= -1
	ITEM.isCombine		= false
	ITEM.protection		= 0

	function ITEM:SetSkin(player, skin)
		if (skin <= player:SkinCount()) then
			player:SetSkin(skin)

			return true
		else
			Schema:EasyText(player, "peru", "You cannot wear this!")

			return false
		end
	end

	function ITEM:ResetSkin(player)
		player:SetSkin(0)
		return true
	end

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		if ((!Schema:PlayerIsCombine(player) or self.isCombine) and self.playerSkin != -1) then
			if (player:Alive() and !player:IsRagdolled()) then
				player:SetSkinClothes(self)
				return true
			end
		else
			Schema:EasyText(player, "peru", "You cannot wear this!")

			return false
		end
	end

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position)
		if (self:HasPlayerEquipped(player) and self.playerSkin != -1) then
			player:SetSkinClothes(self, true)
		end

		return true
	end

	-- Called when a player attempts to sell the item to salesman.
	function ITEM:CanSell(player)
		if (self:HasPlayerEquipped(player) and self.playerSkin != -1) then
			player:SetSkinClothes(self, true)
		end

		return true
	end

	-- Called when a player attempts to give the item to storage.
	function ITEM:CanGiveStorage(player, storageTable)
		if (self:HasPlayerEquipped(player) and self.playerSkin != -1) then
			player:SetSkinClothes(self, true)
		end

		return true
	end

	-- Called when a player changes clothes.
	function ITEM:OnChangeClothes(player, bIsWearing)
		if (bIsWearing) then
			self:SetSkin(player, self.playerSkin)
		else
			self:ResetSkin(player)
		end

		if (self.OnChangedClothes) then
			self:OnChangedClothes(player, bIsWearing)
		end
	end

	-- Called to get whether a player has the item equipped.
	function ITEM:HasPlayerEquipped(player, bIsValidWeapon)
		local clothesData = player.skinClothesData or {}

		if (CLIENT) then
			clothesData = Clockwork.client.skinClothesData or {}
		end

		local skin = self.playerSkin

		if (clothesData[skin] and clothesData[skin].val != nil and clothesData[skin].itemID == self.uniqueID.." "..self.itemID) then
			return true
		end

		return false
	end

	-- Called when a player has unequipped the item.
	function ITEM:OnPlayerUnequipped(player, extraData)
		player:SetSkinClothes(self, true)
	end

ITEM:Register();