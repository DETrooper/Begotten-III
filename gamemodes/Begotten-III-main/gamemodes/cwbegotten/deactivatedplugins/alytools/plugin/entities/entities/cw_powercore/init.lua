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
local corepos = Vector(0,0,0);
 
-- Called when the entity initializes.
function ENT:Initialize()
	self:SetNWFloat( "wormholesize", 8 )
	self:SetModel("models/hunter/blocks/cube05x075x025.mdl");
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:PhysicsInit(SOLID_NONE);
	self:SetUseType(SIMPLE_USE);
	self:SetSolid(SOLID_NONE);
	self:SetRenderMode(RENDERMODE_TRANSCOLOR);
	self:SetColor(Color(0, 0, 0, 0));
	
	local physicsObject = self:GetPhysicsObject();
	
	if (IsValid(physicsObject)) then
		physicsObject:Wake();
		physicsObject:EnableMotion(false);
	end;
	corepos = self:GetPos();
	self:SetPos(corepos + Vector(41,0,35));
	self:SetSolid(0);
	self:SetModelScale( 1.5, 0.25 )
	--self:SetColor( Color(0, 255, 100, 255) )
	local interface = ents.Create("prop_dynamic")
	interface:SetModel("models/props_combine/combine_interface001a.mdl");
	interface:PhysicsInit(SOLID_VPHYSICS);
	interface:SetMoveType(MOVETYPE_NONE);
	interface:SetUseType(SIMPLE_USE);
	interface:SetPos(corepos + Vector(41,0,-5));
	function interface:Use(activator, caller)
		print("USED")
		Clockwork.chatBox:AddInTargetRadius(activator, "me", "random taps some keys.", activator:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
		curtime = CurTime();
		self.NextUse = self.NextUse or 0;
		if self.NextUse < curtime then
			self:EmitSound("ambient/machines/keyboard_slow_1second.wav");
			self.NextUse = curtime + 1;
		end;
	end;
	interface:SetParent( self );
	interface:Spawn();
	local base = ents.Create("prop_dynamic")
	base:SetModel("models/Mechanics/gears2/vert_36t1.mdl");
	base:PhysicsInit(SOLID_VPHYSICS);
	base:SetMoveType(MOVETYPE_NONE);
	base:SetPos(corepos + Vector(0,0,0));
	base:SetMaterial("models/props_combine/metal_combinebridge001");
	base:SetParent( self );
	base:Spawn();
	
	local stand = ents.Create("prop_dynamic")
	stand:SetModel("models/xqm/cylinderx1large.mdl");
	stand:PhysicsInit(SOLID_VPHYSICS);
	stand:SetMoveType(MOVETYPE_NONE);
	stand:SetPos(corepos + Vector(0,0,10));
	local ang = Angle(0,0,0)
	ang:RotateAroundAxis( Vector(0,1,0), 90 )
	stand:SetAngles(ang);
	stand:SetMaterial("models/props_combine/metal_combinebridge001");
	stand:SetParent( self );
	stand:Spawn();
	
	local emitter = ents.Create("prop_dynamic")
	emitter:SetModel("models/props_phx/gears/bevel90_24.mdl");
	emitter:PhysicsInit(SOLID_VPHYSICS);
	emitter:SetMoveType(MOVETYPE_NONE);
	emitter:SetPos(corepos + Vector(0,0,37));
	emitter:SetMaterial("models/XQM/LightLinesRed_tool");
	emitter:SetParent( self );
	emitter:Spawn();
	emitter.RotZ = 20;
	
	local emitter2 = ents.Create("prop_dynamic")
	emitter2:SetModel("models/maxofs2d/hover_rings.mdl");
	emitter2:PhysicsInit(SOLID_VPHYSICS);
	emitter2:SetMoveType(MOVETYPE_NONE);
	emitter2:SetPos(corepos + Vector(0,0,38));
	emitter2:SetModelScale( 0.5, 0 )
	emitter2:SetMaterial("models/props_combine/combine_interface_disp");
	emitter2:SetParent( self );
	emitter2:Spawn();
	emitter2.RotZ = 20;
	
	local holostate = ents.Create("prop_dynamic")
	holostate:SetModel("models/maxofs2d/hover_rings.mdl");
	holostate:PhysicsInit(SOLID_VPHYSICS);
	holostate:SetMoveType(MOVETYPE_NONE);
	holostate:SetPos(corepos + Vector(36,13,51));
	holostate:SetModelScale( 0.5, 0 )
	holostate:SetMaterial("models/wireframe");
	holostate:SetParent( self );
	holostate:Spawn();
	holostate:SetRenderFX( kRenderFxHologram )

	local core = ents.Create("prop_dynamic")
	core:SetModel("models/props_phx/ball.mdl");
	core:SetMaterial( "phoenix_storms/pack2/chrome" )
	core:SetModelScale( 0.5, 0 )
	core:PhysicsInit(SOLID_NONE);
	core:SetMoveType(MOVETYPE_NONE);
	core:SetPos(corepos + Vector(0,0,60));
	core:SetParent( self );
	core:Spawn();
	core:AddEffects( EF_BRIGHTLIGHT )
	core:AddEffects( EF_NOSHADOW )
	
	-- local ring1 = ents.Create("prop_dynamic")
	-- ring1:SetModel("models/hunter/tubes/tube4x4x025.mdl");
	-- --core:SetMaterial( "phoenix_storms/pack2/chrome" )
	-- ring1:SetModelScale( 0.25, 0 )
	-- ring1:PhysicsInit(SOLID_VPHYSICS);
	-- ring1:SetMoveType(MOVETYPE_NONE);
	-- ring1:SetPos(corepos + Vector(0,0,68));
	-- ring1:SetParent( self );
	-- ring1:Spawn();
	-- ring1:AddEffects( EF_BRIGHTLIGHT )
	-- ring1:AddEffects( EF_NOSHADOW )
	-- ring1.RotX = 0;
	-- ring1.RotY = 5;
	-- ring1.RotZ = 0;
	
	local shield = ents.Create("prop_dynamic")
	shield:SetModel("models/maxofs2d/hover_rings.mdl");
	shield:SetMaterial( "models/props_combine/portalball001_sheet" )
	shield:SetModelScale(3.3)
	shield:PhysicsInit(SOLID_NONE);
	shield:SetMoveType(MOVETYPE_NONE);
	shield:SetPos(corepos + Vector(0,0,70));
	shield:SetParent( self );
	shield.IsTheShield = true;
	shield:Spawn();
	
	
	ambient = self:StartLoopingSound( "ambient/machines/combine_terminal_loop1.wav" )
	local effectData = EffectData()
	effectData:SetScale(1)
	effectData:SetOrigin(self:GetPos())
	effectData:SetMagnitude(1)
	util.Effect("camera_flash", effectData, true, true)
	util.Effect("cball_explode", effectData, true, true)
	--self:UpdateDisplayText()
end;

function ENT:Think()
	scale = self:GetModelScale()
	for k, v in pairs(self:GetChildren()) do
		ang = v:GetAngles()
		if v.RotX then
			ang:RotateAroundAxis( Vector(1,0,0), v.RotX )
		end
		if v.RotY then
			ang:RotateAroundAxis( Vector(0,1,0), v.RotY )
		end
		if v.RotZ then
			ang:RotateAroundAxis( Vector(0,0,1), v.RotZ )
		end
		v:SetAngles(ang)
		if v:GetModel() == "models/props_phx/construct/glass/glass_curve360x2.mdl" then
			v:SetModelScale( scale*0.95, 0 )
		end
	end
end


-- Called when the entity's transmit state should be updated.
function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS;
end;

function ENT:UpdateDisplayText()
	self:SetNWString( "interfaceMainText", "SYS ACTIVE" )
end

function ENT:Use(activator, caller)
	local target = activator:GetEyeTraceNoCursor().Entity;
	if target then
		if target:GetModel() == "models/props_combine/combine_interface001a.mdl" then
			curtime = CurTime();
			self.NextUse = self.NextUse or 0;
			if self.NextUse < curtime then
				self:EmitSound("ambient/machines/keyboard_slow_1second.wav");
				Clockwork.chatBox:AddInTargetRadius(activator, "me", "randomly taps some keys.", activator:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
				self.NextUse = curtime + 1;
			end;
		end
	end
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