local COMMAND = Clockwork.command:New("OffsetHelper");

COMMAND.tip = "Helps you setup item offsets.";
COMMAND.text = "<string UniqueID>";
COMMAND.flags = bit.bor(CMD_DEFAULT, CMD_FALLENOVER);
COMMAND.access = "s";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local itemTable = Clockwork.item:FindByID(arguments[1]);

	if (itemTable) then
		local hasCategory;
		local categories = {
			"loweredOrigin",
			"loweredAngles",
			"attachmentOffsetVector",
			"attachmentOffsetAngles"
		};

		for k, v in pairs(categories) do
			if (itemTable[v]) then
				hasCategory = true;
			end;
		end;

		if (hasCategory) then
			netstream.Start(player, "OpenOffsetHelper", {uniqueID = itemTable.uniqueID});
		else
			Schema:EasyText(player, "grey", "["..self.name.."] This item has no offsets or angles defined!");
		end;
	else
		Schema:EasyText(player, "grey", "["..self.name.."] This is not a valid item!");
	end;
end;

COMMAND:Register();