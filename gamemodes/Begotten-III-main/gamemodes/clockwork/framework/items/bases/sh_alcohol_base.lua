--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

local ITEM = item.New(nil, true);
	ITEM.name = "Alcohol Base"
	ITEM.useText = "Drink"
	ITEM.category = "Alcohol"
	ITEM.useSound = {"npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav"}
	ITEM.expireTime = 1800
	ITEM.attributes = {}

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		for k, v in pairs(self.attributes) do
			player:BoostAttribute(self.name, k, v, self.expireTime)
		end

		Clockwork.player:SetDrunk(player, self.expireTime)

		if (self.OnDrink) then
			self:OnDrink(player)
		end
	end

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end
ITEM:Register()