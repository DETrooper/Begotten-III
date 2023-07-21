--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

PLUGIN:SetGlobalAlias("cwRituals");

Clockwork.kernel:IncludePrefixed("cl_plugin.lua");
Clockwork.kernel:IncludePrefixed("sh_hooks.lua");
Clockwork.kernel:IncludePrefixed("sv_hooks.lua");

-- Certain recipes won't load until after the items have been initialized, so they need to be required manually to ensure the correct order.
Clockwork.kernel:IncludePrefixed("sh_ritual_items.lua");
Clockwork.kernel:IncludePrefixed("sh_rituals.lua");

local COMMAND = Clockwork.command:New("CharMark");
	COMMAND.tip = "Manually mark a character for death in the same way as the Satanist ritual. NOT THE SAME AS THE MARKED TRAIT.";
	COMMAND.text = "<string Name>";
	COMMAND.access = "s";
	COMMAND.arguments = 1;
	COMMAND.alias = {"Mark", "PlyMark"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1])
		
		if (target) then
			if target:GetCharacterData("markedBySatanist") == true then
				Schema:EasyText(player, "darkgrey", target:Name().." is already marked for death!");
			else
				target:SetCharacterData("markedBySatanist", true);
				target:SetSharedVar("markedBySatanist", true);
				
				Schema:EasyText(GetAdmins(), "cornflowerblue", target:Name().." has been manually marked for death by "..player:Name());
			end
		else
			Schema:EasyText(player, "grey", arguments[1].." is not a valid character!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("CharUnMark");
	COMMAND.tip = "Unmark a character if they have been marked by Satanists. DOES NOT REMOVE THE MARKED TRAIT, USE '/CharTakeTrait marked' FOR THAT!";
	COMMAND.text = "<string Name>";
	COMMAND.access = "s";
	COMMAND.arguments = 1;
	COMMAND.alias = {"UnMark", "PlyUnMark"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1])
		
		if (target) then
			if target:GetCharacterData("markedBySatanist") == true then
				target:SetCharacterData("markedBySatanist", false);
				target:SetSharedVar("markedBySatanist", false);
				
				Schema:EasyText(GetAdmins(), "cornflowerblue", target:Name().." has been manually unmarked for death by "..player:Name());
			else
				Schema:EasyText(player, "darkgrey", target:Name().." is not marked for death!");
			end
		else
			Schema:EasyText(player, "grey", arguments[1].." is not a valid character!");
		end;
	end;
COMMAND:Register();