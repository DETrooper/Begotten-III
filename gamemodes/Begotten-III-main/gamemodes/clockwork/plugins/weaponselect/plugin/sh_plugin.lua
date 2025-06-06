--[[
	BEGOTTEN III: Developed by DETrooper, cash wednesday, gabs & alyousha35
--]]

PLUGIN:SetGlobalAlias("cwWeaponSelect")

Clockwork.kernel:IncludePrefixed("cl_hooks.lua");
Clockwork.kernel:IncludePrefixed("cl_plugin.lua");
Clockwork.kernel:IncludePrefixed("sv_plugin.lua");

if (CLIENT) then
	cwWeaponSelect.displaySlot = 0;
	cwWeaponSelect.displayFade = 0;
	cwWeaponSelect.displayAlpha = 0;
	cwWeaponSelect.displayDelay = 0;
	cwWeaponSelect.weaponPrintNames = {};
end;