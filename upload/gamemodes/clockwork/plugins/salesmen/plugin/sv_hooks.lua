--[[
	BEGOTTEN III: Developed by DETrooper, cash wednesday, gabs & alyousha35
--]]

-- Called when Clockwork has loaded all of the entities.
function cwSalesmen:ClockworkInitPostEntity()
	self:LoadSalesmen()
end

-- Called just after data should be saved.
function cwSalesmen:PostSaveData()
	self:SaveSalesmen()
end

-- Called when a player attempts to use a salesman.
function cwSalesmen:PlayerCanUseSalesman(player, entity)
	local numFactions = table.Count(entity.cwFactions)
	local numClasses = table.Count(entity.cwClasses)
	local flags = entity.cwFlags or ""
	local realFlags = flags:Replace("-", "")
	local bDisallowed = nil
	local bOverride = nil

	if (numFactions > 0) then
		local faction = player:GetSharedVar("kinisgerOverride") or player:GetFaction();
		
		if player:GetFaction() == "Children of Satan" then
			if entity.cwFactions["Children of Satan"] then
				bOverride = true
			end
		end
		
		if (!entity.cwFactions[faction]) then
			if !bOverride then
				bDisallowed = true
			end
		end
	end

	if (numClasses > 0) then
		if (!entity.cwClasses[_team.GetName(player:Team())]) then
			if !bOverride then
				bDisallowed = true
			end
		end
	end

	if (isstring(flags) and flags != "") then
		local hasFlags = Clockwork.player:HasFlags(player, realFlags)

		if (flags:find("-") and !hasFlags) then
			bDisallowed = true
		end

		if (hasFlags) then
			bDisallowed = false
		end
	end

	if (bDisallowed) then
		entity:TalkToPlayer(player, entity.cwTextTab.noSale, "I cannot trade my inventory with you!")
		return false
	end
end

-- Called when a player uses a salesman.
function cwSalesmen:PlayerUseSalesman(player, entity)
	netstream.Start(player, "Salesmenu", {
		buyInShipments = entity.cwBuyInShipments,
		priceScale = entity.cwPriceScale,
		factions = entity.cwFactions,
		buyRate = entity.cwBuyRate,
		classes = entity.cwClasses,
		entity = entity,
		stock = entity.cwStock,
		sells = entity.cwSellTab,
		cash = entity.cwCash,
		text = entity.cwTextTab,
		buys = entity.cwBuyTab,
		name = entity:GetNetworkedString("Name"),
		flags = entity.cwFlags
	})

	entity:TalkToPlayer(player,	entity.cwTextTab.start,	"How can I help?")
end