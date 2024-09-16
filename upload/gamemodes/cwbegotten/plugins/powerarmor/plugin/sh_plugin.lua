PLUGIN:SetGlobalAlias("cwPowerArmor");

Clockwork.kernel:IncludePrefixed("cl_hooks.lua");
Clockwork.kernel:IncludePrefixed("sv_hooks.lua");
Clockwork.kernel:IncludePrefixed("sv_plugin.lua");

local playerMeta = FindMetaTable("Player");

local powerArmor = {
	["models/begotten/gatekeepers/districtonearmor.mdl"] = true,
	["models/begotten/gatekeepers/lordmaximus.mdl"] = true,
	["models/begotten/wanderers/scrapperking.mdl"] = true,
	["models/begotten/gatekeepers/magistratearmor.mdl"] = true,
	["models/begotten/gatekeepers/adyssa.mdl"] = true,
	["models/begotten/wanderers/voltistpowerarmor.mdl"] = true,
}

function playerMeta:IsWearingPowerArmor()
	return powerArmor[self:GetModel()];
end

local COMMAND = Clockwork.command:New("ExitPowerArmor");
	COMMAND.tip = "Exit the power armor you are currently in.";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.alias = {"ExitArmor", "PowerArmorExit"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		if player:IsWearingPowerArmor() then
			player:ExitPowerArmor();
		else
			Schema:EasyText(player, "firebrick", "You are not currently in a suit of power armor!");
			return;
		end
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("CharSetBattery");
COMMAND.tip = "Set a player's battery level for power armor.";
COMMAND.text = "<string Name> <number Amount>";
COMMAND.access = "o";
COMMAND.arguments = 2;
COMMAND.alias = {"SetBattery", "PlySetBattery"};

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID( arguments[1] )
	local amount = tonumber(arguments[2]);
	
	if (!amount) then
		amount = 100;
	end;
	
	if (target) then
		target:SetCharacterData("battery", amount);
		target:SetNetVar("battery", amount);
		
		if (player != target) then
			Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", "["..self.name.."] "..player:Name().." has set "..target:Name().."'s battery to "..amount..".");
		else
			Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You have set your own battery to "..amount..".");
		end;
	else
		Schema:EasyText(player, "grey", "["..self.name.."] "..arguments[1].." is not a valid player!");
	end;
end;

COMMAND:Register();