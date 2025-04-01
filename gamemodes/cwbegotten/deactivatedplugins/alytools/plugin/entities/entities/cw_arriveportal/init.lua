--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

Clockwork.kernel:IncludePrefixed("shared.lua");

AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

local cwAlyTools = cwAlyTools;

local ambient = 0;
 
-- Called when the entity initializes.
function ENT:Initialize()
	self:SetNWFloat( "wormholesize", 8 )
	self:SetModel("models/props_phx/ball.mdl");
	self:SetModelScale( 0, 0 )
	self:SetMoveType(MOVETYPE_NONE);
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetUseType(SIMPLE_USE);
	self:SetSolid(0);
	self:SetMaterial( "models/props_c17/fisheyelens" )
	self:SetModelScale( 1.5, 0.25 )
	--self:SetColor( Color(0, 255, 100, 255) )
	self:AddEffects( EF_BRIGHTLIGHT )
	self:AddEffects( EF_NOSHADOW )
	-- local core = ents.Create("prop_physics")
	-- core:SetModel("models/props_phx/misc/smallcannonball.mdl");
	-- core:SetMoveType(MOVETYPE_NONE);
	-- core:PhysicsInit(SOLID_VPHYSICS);
	-- core:SetMaterial( "models/props_combine/masterinterface01c" )
	-- core:SetSolid(0);
	-- core:SetParent( self );
	-- core:SetPos(self:GetPos());
	-- core:Spawn();
	ambient = self:StartLoopingSound( "ambient/machines/combine_terminal_loop1.wav" )
	local effectData = EffectData()
	effectData:SetScale(1)
	effectData:SetOrigin(self:GetPos())
	effectData:SetMagnitude(1)
	util.Effect("camera_flash", effectData, true, true)
	util.Effect("cball_explode", effectData, true, true)
	util.Effect("TeslaZap", effectData, true, true)
	
end;


-- Called when the entity's transmit state should be updated.
function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS;
end;

function ENT:Use(activator, caller)

end;

function ENT:OnRemove()
	self:SetModelScale( 0, 0.25 )
	self:StopLoopingSound( ambient )
	local effectData = EffectData()
	effectData:SetScale(1)
	effectData:SetOrigin(self:GetPos())
	effectData:SetMagnitude(1)
	util.Effect("camera_flash", effectData, true, true)
	util.Effect("AR2Explosion", effectData, true, true)
	util.Effect("TeslaZap", effectData, true, true)
	self:EmitSound("ambient/levels/citadel/weapon_disintegrate1.wav")
end;