--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

local ITEM = item.New(nil, true);
	ITEM.name = "Ammo Base"
	ITEM.useText = "Load"
	ITEM.useSound = false
	ITEM.category = "Ammunition"
	ITEM.ammoClass = "pistol"
	ITEM.ammoAmount = 0
	ITEM.roundsText = "Rounds"
	ITEM:AddData("Rounds", -1, true)
	ITEM.equippable = false; -- this blocks equipping the item as a melee weapon.
	
	-- A function to get the item's weight.
	function ITEM:GetItemWeight()
		return (self.weight / self.ammoAmount) * self:GetData("Rounds")
	end

	-- A function to get the item's space.
	function ITEM:GetItemSpace()
		return (self.space / self.ammoAmount) * self:GetData("Rounds")
	end

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		player:GiveAmmo(self:GetVar("ammoAmount"), string.lower(self.ammoClass))
	end

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end

	if (SERVER) then
		function ITEM:OnInstantiated()
			self:SetData("Rounds", self.ammoAmount)
		end
	else
		function ITEM:GetClientSideInfo()
			return Clockwork.kernel:AddMarkupLine("", "Rounds: "..self.ammoAmount)
		end
	end
	
	function ITEM:GetAmmoAmount()
		local rounds = self:GetData("Rounds");
		
		if (rounds and rounds > 0) then
			return rounds;
		else
			return self.ammoAmount;
		end;
	end;
	
	ITEM:AddQueryProxy("ammoAmount", ITEM.GetAmmoAmount)
ITEM:Register()