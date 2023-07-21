--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

local ITEM = Clockwork.item:New();
	ITEM.name = "Small Bottle of Oil";
	ITEM.model = "models/weapons/w_oil.mdl";
	ITEM.weight = 0.1;
	ITEM.useText = "Refill";
	ITEM.category = "Other"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/small_oil.png";
	ITEM.description = "A small bottle of oil. Use it wisely.";
	ITEM.useSound = "begotten/ui/use_oil.mp3";
	ITEM.uniqueID = "small_oil";
	ITEM.lootValue = 8;
	
	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		local activeWeapon = player:GetActiveWeapon();
		
		if (activeWeapon:GetClass() == "cw_lantern") then
			local currentOil = player:GetCharacterData("oil", 0);
			
			player:SetCharacterData("oil", math.Clamp(currentOil + 30, 0, 100));

			if (currentOil + 30) > 100 then
				Schema:EasyText(player, "olive","Some of the oil did not make it into your lantern, as it is now full.");
			end;
		else
			Schema:EasyText(player, "firebrick", "You must be holding your lantern to refill it!");
			
			return false;
		end;
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();