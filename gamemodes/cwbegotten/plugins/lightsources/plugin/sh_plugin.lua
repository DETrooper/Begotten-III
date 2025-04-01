--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

PLUGIN:SetGlobalAlias("cwLantern");

Clockwork.kernel:IncludePrefixed("cl_hooks.lua");
Clockwork.kernel:IncludePrefixed("cl_plugin.lua");
Clockwork.kernel:IncludePrefixed("sv_hooks.lua");

-- Called when the Clockwork shared variables are added.
function cwLantern:ClockworkAddSharedVars(globalVars, playerVars)
	playerVars:Number("oil");
end

local playerMeta = FindMetaTable("Player");

-- A function to get if the player has a light source.
function playerMeta:HasLightSource()
	local activeWeapon = self:GetActiveWeapon();
	local lightSources = {"cw_lantern"};
	
	if (activeWeapon:IsValid()) then
		if (table.HasValue(lightSources, activeWeapon:GetClass())) then
			return true;
		end;
	end;
	
	if (self:FlashlightIsOn()) then
		return true;
	end;

	return false;
end;