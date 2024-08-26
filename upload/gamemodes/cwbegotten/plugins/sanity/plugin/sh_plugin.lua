--[[
	Begotten III: Jesus Wept
--]]

PLUGIN:SetGlobalAlias("cwSanity");

Clockwork.kernel:IncludePrefixed("cl_plugin.lua");
Clockwork.kernel:IncludePrefixed("cl_hooks.lua");
Clockwork.kernel:IncludePrefixed("sv_plugin.lua");
Clockwork.kernel:IncludePrefixed("sv_hooks.lua");

-- Called when the Clockwork shared variables are added.
function cwSanity:ClockworkAddSharedVars(globalVars, playerVars)
	playerVars:Number("sanity");
end;

local playerMeta = FindMetaTable("Player");

-- A function to get a player's sanity level.
function playerMeta:GetSanity()
	return self:GetNetVar("sanity");
end;

-- A function to get the player's sanity level.
function playerMeta:GetMaxSanity()
	return self.maxSanity or 100;
end;

local COMMAND = Clockwork.command:New("CharSetSanity");
COMMAND.tip = "Set a players Sanity level.";
COMMAND.text = "<string Name> [number Amount]";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";
COMMAND.arguments = 1;
COMMAND.optionalArguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);

	if (target) then
		local amount = arguments[2];
		
		if (!amount or !tonumber(amount)) then
			amount = 0;
		else
			amount = math.Clamp(tonumber(amount), 0, 100);
		end;

		target:SetCharacterData("sanity", amount);
		target:SetNetVar("sanity", amount);

		if (player != target)	then
			Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You have set "..target:Name().."'s sanity to "..amount..".");
		else
			Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You have set your own sanity to "..amount..".");
		end;
	else
		Schema:EasyText(player, "grey", "["..self.name.."] "..arguments[1].." is not a valid player!");
	end;
end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyScare");
COMMAND.tip = "Scare a player and reduce their sanity by 10. Leave argument blank to scare the player you are looking at.";
COMMAND.text = "<string Name>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";
COMMAND.optionalArguments = 1;
COMMAND.alias = {"ScarePlayer", "CharScare", "Scare", "Jumpscare"};

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);
	
	if !target then
		local ent = player:GetEyeTraceNoCursor().Entity;
		
		if ent:IsPlayer() then
			target = ent;
		end
	end

	if (target) then
		target:HandleSanity(-10);

		if (player != target) then
			netstream.Start({player, target}, "ScarePlayer");
		
			Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You have scared "..target:Name().."!");
		else
			netstream.Start(player, "ScarePlayer");
			
			Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You have scared yourself!");
		end;
	end;
end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("ToggleHellSanityLoss");
COMMAND.tip = "Toggle Hell's residual sanity loss.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if cwSanity.hellZoneSanityDisabled then
		cwSanity.hellZoneSanityDisabled = false;
		Schema:EasyText(player, "cornflowerblue", "Residual sanity loss in Hell has been disabled.");
	else
		cwSanity.hellZoneSanityDisabled = true;
		Schema:EasyText(player, "cornflowerblue", "Residual sanity loss in Hell has been enabled.");
	end
end;

COMMAND:Register();