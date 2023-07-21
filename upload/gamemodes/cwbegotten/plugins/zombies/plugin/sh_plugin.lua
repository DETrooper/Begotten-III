--[[
	created by cash wednesday.
--]]

PLUGIN:SetGlobalAlias("cwZombies");

Clockwork.kernel:IncludePrefixed("cl_hooks.lua");
Clockwork.kernel:IncludePrefixed("cl_plugin.lua");
Clockwork.kernel:IncludePrefixed("sv_hooks.lua");
Clockwork.kernel:IncludePrefixed("sv_plugin.lua");

-- Called when the Clockwork shared variables are added.
function cwZombies:ClockworkAddSharedVars(globalVars, playerVars)
	playerVars:Number("NextSound");
	playerVars:Bool("IsTarget", true);
end

cwZombies.zombieNPCS = {
	"npc_bgt_brute",
	"npc_bgt_suitor",
	"npc_bgt_grunt",
	"npc_bgt_another",
	"npc_bgt_chaser",
	"npc_bgt_eddie",
	"npc_bgt_giant",
	"npc_bgt_guardian",
	"npc_bgt_otis"
};

cwZombies.terrorNPCs = cwZombies.zombieNPCS;

local entityMeta = FindMetaTable("Entity");

-- A function to get if an entity is a zombie.
function entityMeta:IsZombie()
	return table.HasValue(cwZombies.zombieNPCS, self:GetClass());
end;