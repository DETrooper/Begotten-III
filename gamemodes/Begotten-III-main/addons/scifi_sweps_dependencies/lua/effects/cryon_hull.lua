local mat_ice = Material( "models/elemental/frozen_alpha" )

local icegibs = {
	"models/props_wasteland/rockgranite03b.mdl",
	"models/props_wasteland/rockgranite03c.mdl",
	"models/props_wasteland/rockgranite03a.mdl",
	"models/props_wasteland/rockgranite02c.mdl",
	"models/props_wasteland/rockgranite02b.mdl",
	"models/props_wasteland/rockgranite02a.mdl",
}

EFFECT.Childs = {}

function EFFECT:Init( data )

	self.Time = data:GetScale() -- 2
	self.LifeTime = CurTime() + self.Time
	
	local ent = data:GetEntity()
	
	if ( !IsValid( ent ) ) then return end
	if ( !ent:GetModel() ) then return end
	
	self.Childs = {}
	
	self.ParentEntity = ent
	self:SetModel( ent:GetModel() )	
	self:SetPos( ent:GetPos() )
	self:SetAngles( ent:GetAngles() )
	self:SetParent( ent )
	
end

function EFFECT:OnRemove()
	
	for k,v in pairs( self.Childs ) do
		if ( v ) then
			v:Remove()
		end
	end

end

function EFFECT:Think( )

	if ( !IsValid( self.ParentEntity ) ) then 
		self:OnRemove()

		return false 
	end

	if ( self.LifeTime > CurTime() ) then
		return true
	end
	
	self:OnRemove()

	return false
	
end

local fFraction, iBoneCount, iBoneMax, sMin, sMax
local vShatter = Vector( 0, 0, 0 )

function EFFECT:Render()
	
	local parent = self:GetParent()

	if ( !IsValid( parent ) ) then
		self:OnRemove()
		return
	end

	fFraction = ( self.LifeTime - CurTime() ) / self.Time
	fFraction = math.Clamp( fFraction, 0, 0.4 )

	iBoneCount = parent:GetBoneCount()
	sMin, sMax = parent:GetModelBounds()
	iBoneMax = math.min( 32, iBoneCount )
	
	for bone = 0 + iBoneMax / 4, iBoneMax do
		if ( !parent:GetBoneName( bone ) ) then continue end
		
		local bOrigin, bRotation = parent:GetBonePosition( bone )
		
		if ( !isvector( bOrigin ) ) then continue end
		
		local rng = math.random( 0.04, 0.08 )
		
		local gibScale = Vector( rng, rng, rng )
		local gibScaleFactor = ( sMin - sMax ):Length() * ( bone / 24 ) / ( iBoneMax / 16 )
		local gibScaleFinal = math.max( gibScaleFactor / 200, 0.1 ) * ( 0.8 + fFraction )
		
		if ( !self.Childs[ bone ] ) then
			self.Childs[ bone ] = ClientsideModel(  icegibs[ math.random( 1, #icegibs ) ] , RENDERGROUP_BOTH )
		end
		
		local gib = self.Childs[ bone ]
		if ( IsValid( gib ) ) then
			local vShatter = vShatter || Vector( 0, 0, 0 )
			if ( fFraction < 0.3 ) then
				vShatter = VectorRand() * ( 0.3 - fFraction )
			end
			
			gib:SetPos( bOrigin + vShatter )
			gib:SetAngles( bRotation )
			gib:SetMaterial( "models/elemental/frozen_alpha" )
			gib:SetModelScale( gibScaleFinal )
			gib:SetCollisionBounds( gibScale * -1, gibScale )
			gib:DrawModel()
		end

--		debugoverlay.Line( bOrigin, parent:GetPos(), 0.1, Color( 255, 0, 255, 255 ), true )
	end
	
end