--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

local PLUGIN = PLUGIN;

Clockwork.kernel:IncludePrefixed("cl_hooks.lua")
Clockwork.kernel:IncludePrefixed("sv_plugin.lua")

local COMMAND = Clockwork.command:New("CharSetHelmetCondition");
COMMAND.tip = "Set a character's helmet condition. Defaults to 100% condition if no argument is provided.";
COMMAND.text = "<string Name> [number Condition]";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";
COMMAND.arguments = 1;
COMMAND.optionalArguments = 1;
COMMAND.alias = {"SetHelmetCondition", "PlySetHelmetCondition"};

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);

	if (target) then
		local condition = arguments[2];
		
		if (!condition) then
			condition = 100;
		else
			condition = math.Clamp(tonumber(condition), 0, 100);
		end;

		local helmetItem = target:GetHelmetEquipped();
	
		if (helmetItem) then
			helmetItem:SetCondition(condition, true);

			if (player != target)	then
				Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You have set "..target:Name().."'s helmet item condition to "..condition..".");
			else
				Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You have set your own helmet item condition to "..condition..".");
			end;
		else
			Schema:EasyText(player, "firebrick", "["..self.name.."] "..target:Name().." does not have a valid helmet equipped!");
		end
	else
		Schema:EasyText(player, "grey", "["..self.name.."] "..arguments[1].." is not a valid player!");
	end;
end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("CharSetArmorCondition");
COMMAND.tip = "Set a character's armor condition. Defaults to 100% condition if no argument is provided.";
COMMAND.text = "<string Name> [number Condition]";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";
COMMAND.arguments = 1;
COMMAND.optionalArguments = 1;
COMMAND.alias = {"SetArmorCondition", "PlySetArmorCondition"};

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);

	if (target) then
		local condition = arguments[2];
		
		if (!condition) then
			condition = 100;
		else
			condition = math.Clamp(tonumber(condition), 0, 100);
		end;
	
		local armorItem = target:GetClothesEquipped();
		
		if armorItem then
			armorItem:SetCondition(condition, true);

			if (player != target)	then
				Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You have set "..target:Name().."'s armor item condition to "..condition..".");
			else
				Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You have set your own armor item condition to "..condition..".");
			end;
		else
			Schema:EasyText(player, "firebrick", "["..self.name.."] "..target:Name().." does not have a valid armor equipped!");
		end
	else
		Schema:EasyText(player, "grey", "["..self.name.."] "..arguments[1].." is not a valid player!");
	end;
end;

COMMAND:Register();