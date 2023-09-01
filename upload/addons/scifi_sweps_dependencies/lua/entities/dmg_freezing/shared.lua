AddCSLuaFile()

-- cryo --
sound.Add( {
	name = "scifi.cryo.explode",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 92,
	pitch = {95, 105},
	sound = "weapons/misc/cryo_explo.wav"
} )

sound.Add( {
	name = "scifi.cryo.freeze", 
	channel = CHAN_STATIC,
	volume = 1,
	level = SNDLVL_GUNFIRE, --SNDLVL_85dB,
	pitch = {95, 105},
	sound = "elemental/freeze.wav"
} )

sound.Add( {
	name = "scifi.bliz.freeze", 
	channel = CHAN_STATIC,
	volume = 1,
	level = SNDLVL_85dB,
	pitch = {95, 105},
	sound = "elemental/freeze_short.wav"
} )

sound.Add( {
	name = "scifi.bliz.breakfree",
	channel = CHAN_STATIC,
	volume = 1,
	level = SNDLVL_85dB,
	pitch = {95, 105},
	sound = "elemental/freeze_breakfree.wav"
} )

sound.Add( {
	name = "scifi.bliz.shatter",
	channel = CHAN_STATIC,
	volume = 1,
	level = 110,
	pitch = {95, 105},
	sound = "elemental/freeze_shatter.wav"
} )

sound.Add( {
	name = "scifi.bliz.hit",
	channel = CHAN_STATIC,
	volume = 1,
	level = 60,
	pitch = {95, 105},
	sound = "effects/ice_hit.wav"
} )

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName 		= "ice damage proc"
ENT.Phx 			= SOLID_NONE
ENT.PhxMType 		= MOVETYPE_FLY
ENT.PhxMColl		= MOVECOLLIDE_FLY_CUSTOM 						-- Just ... just accept this, ok? Alternatively:  MOVECOLLIDE_FLY_BOUNCE
ENT.PhxCGroup 		= COLLISION_GROUP_IN_VEHICLE
ENT.PhxSSize		= 1
ENT.PhxSProp 		= "item"
ENT.PhxMass 		= 0
ENT.PhxGrav			= false
ENT.PhxDrag			= false
ENT.PhxElastic 		= 0
ENT.LifeTime		= 2
ENT.KillSilentDelay = 0.005											-- Duration of the death event. This can be overriden without changing this particular value and won't be used at all, if the legacy death event is used.

function ENT:Initialize()
	local size = self.PhxSSize

	if ( SERVER ) then
		self:SetMoveType( self.PhxMType )
		self:SetMoveCollide( self.PhxMColl )
		self:PhysicsInitSphere( size, self.PhxSProp )
		self:SetCollisionBounds( Vector( -size, -size, -size ), Vector( size, size, size ) )
		self:SetCollisionGroup( self.PhxCGroup )
		self:DrawShadow( false )
		self:SetNoDraw( true )
		self:SetElasticity( self.PhxElastic )
		self:SetModel( "models/dav0r/hoverball.mdl" )
		self:SetMaterial( "vgui/white" )
		
		local phys = self:GetPhysicsObject()
		if ( !IsValid( phys ) ) then DevMsg( "@"..self:GetClass().." : !Error; Invalid physics object. Removing! " ) self:Remove() return end
		phys:EnableGravity( self.PhxGrav )
		phys:EnableDrag( self.PhxDrag )
		phys:SetMass( self.PhxMass )

		self.DieTime = CurTime() + self.LifeTime
		
		local target = self:GetParent()

		if ( IsValid( target ) ) then
			if ( target:GetMaxHealth() < 150 ) then
				target:SetNWBool( "bliz_frozen", true )
			end
			
			if ( target:IsNPC() ) then
				if ( !target:IsCurrentSchedule( SCHED_NPC_FREEZE ) ) then
					target:SetSchedule( SCHED_NPC_FREEZE )
				end
				
				target:SetPlaybackRate( 0.1 )
			elseif ( target:IsPlayer() ) then
				target:AddFlags( FL_FROZEN )
			end
			
			local ed = EffectData()
			ed:SetOrigin( target:GetPos() )
			ed:SetEntity( target )
			ed:SetScale( self.LifeTime )
			util.Effect( "cryon_frozen", ed, true, true )
			
			local ed2 = EffectData()
			ed2:SetOrigin( target:GetPos() )
			ed2:SetEntity( target )
			ed2:SetScale( self.LifeTime )
			util.Effect( "cryon_hull", ed2, true, true )
			
			ParticleEffectAttach( "ice_freezing", 1, target, 1 )
			self:EmitSound( "scifi.bliz.freeze" )
		end
	end
end

function ENT:Think()
	if ( SERVER ) then
		local target = self:GetParent()
		
		if ( !IsValid( target ) ) then
			self:KillSilent()
			return true
		end

		if ( target:IsPlayer() && !target:Alive() ) then
			self:KillSilent()
			return true
		end
		
		if ( target:IsNPC() && target:Health() <= 1 ) then
			target:SetNWBool( "bliz_frozen", false )
			target:SetSchedule( SCHED_WAKE_ANGRY )
			
			ParticleEffectAttach( "ice_freezing_release", 1, target, 1 )
--			target:EmitSound( "scifi.bliz.breakfree" )
			
			local pOwner = self.Owner:GetActiveWeapon()
			if ( IsValid( self.Owner ) && IsValid( pOwner ) ) then
				target:TakeDamage( 5, self.Owner, pOwner )
				
				if ( target:Health() <= target:GetMaxHealth() * -0.25 ) then
					self:EmitSound( "scifi.bliz.shatter" )
					DoShatterRagdolls( target:EyePos() )
				else
					self:EmitSound( "scifi.cryo.freeze" )
					DoFreezeRagdolls( target:EyePos() )
				end
			end
		
			self:KillSilent()
			return true
		end
	end
	
	if ( SERVER ) then
		self:NextThink( CurTime() + 0 )
		
		if ( IsValid( self ) ) && ( self.LifeTime > 0 ) && ( self.DieTime <= CurTime() ) then
			self:KillSilent( false, 0 )
		end
	end
	
	return true 
end

function ENT:PhysicsCollide( data, phys )

end

function ENT:OnTakeDamage( CTakeDamageInfo )

end

function ENT:OnRemove()
	if ( !SERVER ) then return end

	local parent = self:GetParent()

	if ( !IsValid( parent ) ) then
		return 
	end
	
	if ( parent:IsNPC() ) then
		parent:SetSchedule( SCHED_WAKE_ANGRY )
	elseif ( parent:IsPlayer() ) then
		parent:RemoveFlags( FL_FROZEN )
	end

	parent:EmitSound( "scifi.bliz.breakfree" )
	parent:StopParticles()

	ParticleEffectAttach( "ice_freezing_release", 1, parent, 1 )
	parent:SetNWBool( "bliz_frozen", false )
end

function ENT:KillSilent( evForce, evDelay )
	if ( !IsValid( self ) ) then return end
	if ( CLIENT ) then return end

	local delay = self.KillSilentDelay
	if ( evDelay ) then	
		delay = evDelay
	end
	
--		self:StopSound( self.SoundFile )
	self:StopParticles()
	self:Fire( "kill", "", delay )
end
