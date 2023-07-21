--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

Clockwork.kernel:IncludePrefixed("shared.lua")

ENT.bhSize = 8;
ENT.actSize = 8;
ENT.exitSize = 0;
ENT.actExitSize = 0;
ENT.exitTarget = nil;

-- Called when the target ID HUD should be painted.
function ENT:HUDPaintTargetID(x, y, alpha)
	-- y = Clockwork.kernel:DrawInfo("An exposed pile of iron ore. If broken up, its contents could be used as a crafting material.", x, y, Clockwork.option:GetColor("white"), alpha);
end;

function ENT:Think()
	local ang = self:GetAngles()
	ang:RotateAroundAxis( Vector(0,0,1), 10 )
	self:SetAngles(ang)

	if !isvector(self.exitTarget) then
		self.exitTarget = self:GetNWVector( "portaltarget" )
	end
	if self:GetNWBool( "transporting" ) then
		self.bhSize = 22
	else
		self.bhSize = 8
	end
	if self.bhSize ~= self.actSize then
		math.Approach( self.actSize, self.bhSize, 5 )
	end
end

function ENT:Draw( )
	self:DrawModel()
	self:SetRenderMode( RENDERMODE_GLOW )
	self:SetColor(255,60,60,30)
	local outer = (15*self:GetModelScale())
	render.SetColorMaterial()
	local core = self:GetPos() + Vector( 0, 0, 21*self:GetModelScale() )
	radius = 20*self:GetModelScale()
	offset = Vector(0,0,radius)
	local emitter = ParticleEmitter( core, false )
	for i=0, math.random(1,4) do
		local offtemp = offset
		local randang = AngleRand(-180,180)
		offtemp:Rotate(randang)
		local particle = emitter:Add( "effects/spark", core+offtemp )
		if particle then
			particle:SetAngles( randang )
			particle:SetVelocity( offtemp * -1 )
			particle:SetColor( 70, 255, 70, 255 )
			particle:SetLifeTime( 0 )
			particle:SetDieTime( 0.4 )
			particle:SetStartAlpha( 0 )
			particle:SetEndAlpha( 255 )
			particle:SetStartSize( 1.6 )
			particle:SetStartLength( 1 )
			particle:SetEndSize( 1.2 )
			particle:SetEndLength( 4 )
		end
	end
	render.DrawSphere( core+Vector(math.random(-2,2),math.random(-2,2),math.random(-2,2)), self.actSize*self:GetModelScale(), 45, 45, Color( 0, 0, 0 ) );
	emitter:Finish()
end