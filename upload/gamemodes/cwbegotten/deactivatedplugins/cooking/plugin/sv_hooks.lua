--[[
	B3 Jessu Weep
--]]

-- Called when an entity's menu option should be handled.
function cwCooking:EntityHandleMenuOption(player, entity, option, arguments)
end;

-- Called at an interval while the player is connected to the server.
function cwCooking:PlayerThink(player, curTime, infoTable)
end;

-- Called when an entity is removed.
function cwCooking:EntityRemoved(entity)
end;

-- Called when attempts to use a command.
function cwCooking:PlayerCanUseCommand(player, commandTable, arguments)
end;

-- Called when a player attempts to drop an item.
function cwCooking:PlayerCanDropItem(player, itemTable, noMessage)
end;

-- Called when a player attempts to use an item.
function cwCooking:PlayerCanUseItem(player, itemTable, noMessage)
end;
function printp(t)
	--for _, v in _player.Iterator() do
		--Schema:EasyText(v, table.Random(colors), tostring(t))
	--end;
	--print(tostring(t))
end;
--printp("sex")
function cwCooking:OnPlayerHitGround(player, inWater, onFloater, speed)
end;