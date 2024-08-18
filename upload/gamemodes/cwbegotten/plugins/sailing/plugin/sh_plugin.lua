--[[
	Begotten III: Jesus Wept
--]]

PLUGIN:SetGlobalAlias("cwSailing");

game.AddParticles("particles/fire_01.pcf");
PrecacheParticleSystem("env_fire_large");

Clockwork.kernel:IncludePrefixed("cl_plugin.lua");
Clockwork.kernel:IncludePrefixed("cl_hooks.lua");
Clockwork.kernel:IncludePrefixed("sv_plugin.lua");
Clockwork.kernel:IncludePrefixed("sv_hooks.lua");

local COMMAND = Clockwork.command:New("ToggleHellSailing");
COMMAND.tip = "Toggle whether sailing to Hell is enabled.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if cwSailing.hellSailingEnabled ~= true then
		cwSailing.hellSailingEnabled = true;
		cwSailing:EasyText(GetAdmins(), "cornflowerblue", player:Name().." has enabled sailing to hell for enchanted longships.");
	else
		cwSailing.hellSailingEnabled = false;
		cwSailing:EasyText(GetAdmins(), "cornflowerblue", player:Name().." has disabled sailing to hell for enchanged longships.");
	end
end;

COMMAND:Register()