local COMMAND = Clockwork.command:New("ClearGore");
COMMAND.tip = "Remove all gore related entities.";
COMMAND.text = "<bool Decals>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";
COMMAND.optionalArguments = 1;
COMMAND.alias = {"CleanupGore"};

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local items = ents.FindByClass("cw_item");
	local count = 0;
	
	for k, v in pairs(items) do
		if v.GetItemTable then
			local itemTable = v:GetItemTable();
			
			if itemTable and itemTable.uniqueID == "humanmeat" then
				v:Remove();
				
				count = count + 1;
			end
		end
	end
	
	for k, v in pairs (ents.FindByClass("prop_ragdoll")) do
		local removeTable = {
			"models/skeleton/skeleton_arm.mdl",
			"models/skeleton/skeleton_arm_l.mdl",
			"models/skeleton/skeleton_leg.mdl",
			"models/skeleton/skeleton_leg_l.mdl",
			"models/skeleton/skeleton_torso.mdl",
			"models/skeleton/skeleton_torso2.mdl",
			"models/skeleton/skeleton_torso1.mdl",
			"models/skeleton/skeleton_arm.mdl",
		};
		
		if table.HasValue(removeTable, v:GetModel()) then
			v:Remove();
			
			count = count + 1;
		end;
	end;

	for k, v in pairs (ents.FindByClass("prop_physics")) do
		local removeTable = {
			"models/gibs/hgibs.mdl",
			"models/props_junk/watermelon01_chunk02a.mdl",
			"models/gibs/antlion_gib_medium_1.mdl",
			"models/gibs/antlion_gib_small_2.mdl",
			"models/gibs/antlion_gib_small_1.mdl",
			"models/props_junk/watermelon01_chunk02b.mdl",
			"models/props_junk/watermelon01_chunk02c.mdl"
		};
		
		if table.HasValue(removeTable, v:GetModel()) then
			v:Remove();
			
			count = count + 1;
		end;
	end;
	
	if (arguments[1]) then
		for _, v in _player.Iterator() do
			v:ConCommand("r_cleardecals");
		end;
		
		Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You have removed "..count.." gore entities and cleared decals.");
	else
		Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You have removed "..count.." gore entities.");
	end;
end;

COMMAND:Register();