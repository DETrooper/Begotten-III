--[[
	Begotten Code
--]]

local ITEM = Clockwork.item:New();
	ITEM.name = "Wooden Planks";
	ITEM.model = "models/props_debris/wood_board04a.mdl";
	ITEM.plural = "Wooden Plank";
	ITEM.weight = 2;
	ITEM.useText = "Barricade";
	ITEM.description = "A single wooden plank.";
	ITEM.uniqueID = "wood_plank";

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		if (player:Alive()) then
			local eyePos = player:EyePos();
			local aimVector = player:GetAimVector();
			
			local trace = {};
				trace.start = eyePos;
				trace.endpos = trace.start + aimVector * 128;
				trace.filter = player;
			local traceLine = util.TraceLine(trace);
			
			local door = traceLine.Entity;
			
			if (IsValid(door) and door:GetClass() == "prop_door_rotating") then
				Clockwork.plugin:Call("AddPlankToDoor", player, door);
			else
				Schema:EasyText(player, "firebrick", "You must look at a door to barricade!");
				return false;
			end;
		end;
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();