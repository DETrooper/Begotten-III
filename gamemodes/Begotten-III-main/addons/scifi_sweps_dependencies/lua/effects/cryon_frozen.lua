local mat_ice = Material( "models/elemental/frozen_alpha" )
local overlay_cache = Material( "models/elemental/frozen_overlay" )
local overlay = "models/elemental/frozen_overlay"

function EFFECT:Init( data )

	self.Time = data:GetScale() -- 2
	self.LifeTime = CurTime() + self.Time
	
	local ent = data:GetEntity()
	
	if ( !IsValid( ent ) ) then return end
	if ( !ent:GetModel() ) then return end
	
	self.ParentEntity = ent
	self:SetModel( ent:GetModel() )	
	self:SetPos( ent:GetPos() )
	self:SetAngles( ent:GetAngles() )
	self:SetParent( ent )
	
	self.ParentEntity.RenderOverride = self.RenderParent
	self.ParentEntity.SpawnEffect = self

end

function EFFECT:Think( )

	if ( !IsValid( self.ParentEntity ) ) then return false end
	
	local PPos = self.ParentEntity:GetPos()
	self:SetPos( PPos + ( EyePos() - PPos ):GetNormal() )
	
	if ( self.LifeTime > CurTime() ) then
		return true
	end
	
	self.ParentEntity.RenderOverride = nil
	self.ParentEntity.SpawnEffect = nil
			
	return false
	
end

function EFFECT:Render()
	
	local ply = self:GetParent()
	
	if ( ply:IsPlayer() ) && ( ply == LocalPlayer() ) then
		DrawMaterialOverlay( overlay, 0.2 )
	end

end

function EFFECT:RenderOverlay( entity )
		
	local Fraction = (self.LifeTime - CurTime()) / self.Time
	local ColFrac = (Fraction-0.5) * 2
	
	Fraction = math.Clamp( Fraction, 0, 1 )
	ColFrac =  math.Clamp( ColFrac, 0, 1 )

	local EyeNormal = entity:GetPos() - EyePos()
	local Distance = EyeNormal:Length()
	EyeNormal:Normalize()
	
	local Pos = EyePos() + EyeNormal * Distance * 0.01
	
	cam.Start3D( Pos, EyeAngles() )
		render.MaterialOverride( mat_ice )
	
		entity:DrawModel()
		render.MaterialOverride( 0 )
	cam.End3D()

end


function EFFECT:RenderParent()	
	
--	local bones = self:GetBoneCount() --GetPhysicsObjectCount()
--	for bone = 1, bones-1 do
--		self:ManipulateBoneScale( bone, Vector( math.random( 1.1, 1.2 ), math.random( 1.1, 1.2 ), math.random( 1.1, 1.2 ) ) * 42 )
--	end	
	
	self:DrawModel()
	
	render.SetColorModulation( 1, 1.1, 1.2 )	

	self.SpawnEffect:RenderOverlay( self )

end