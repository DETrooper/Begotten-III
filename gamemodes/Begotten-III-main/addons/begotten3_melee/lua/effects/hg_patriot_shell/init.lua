local up = Vector(0, 0, -100)
function EFFECT:Init(data)
	velocity = velocity or up
	velocity = velocity + VectorRand() * 300
	self.Position = data:GetOrigin()
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()
	local ang, smokepos = self:GetBulletEjectPos(self.Position, self.WeaponEnt, self.Attachment)
	local direction = ang:Forward()
	local direction2 = ang:Right()
	local direction3 = ang:Up()
	local emitter = self.Entity
	local ang = LocalPlayer():GetAimVector():Angle()
	if IsValid(LocalPlayer():GetViewModel()) then
		direction2 = ang:Up()
	end
		ang = ang * 1
		ang:RotateAroundAxis( ang:Right(), math.random(-15,15) )
		ang:RotateAroundAxis( ang:Up(), math.random(-15,15) )
		ang:RotateAroundAxis( ang:Forward(), math.random(-5,5) )
	emitter:SetModel("models/weapons/shell.mdl")--models/weapons/shell_762.mdl
	emitter:SetPos(smokepos )
	emitter:PhysicsInitBox(Vector(-0.5, -0.5, -0.5), Vector(0.5, 0.15, 0.5))
	emitter:SetSolid(SOLID_VPHYSICS)
	emitter:SetMoveType(MOVETYPE_VPHYSICS) 
	emitter:SetSolid(SOLID_VPHYSICS) 
	emitter:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	emitter:SetAngles(ang)
	local phys = emitter:GetPhysicsObject()
	self.emitter = ParticleEmitter(phys:GetPos(), true)
	if IsValid(phys) then
		phys:SetMaterial("gmod_silent")
		phys:SetMass(5)
		phys:Wake()
		phys:SetDamping(0, 5)
		phys:SetVelocity(direction * math.random(-200,-270) + direction2*math.random(40,60) + direction3*math.random(20,40))
		
		self.Entity:SetNWInt("smoke", math.random(1,3))
		self.Entity:SetNWInt("smokerand", math.random(2,6))
		self.Entity:SetNWInt("smoketime", CurTime() + math.random(3,7))
	end
	self.LifeTime = CurTime()+15
end

function EFFECT:PhysicsCollide(data,phys)

local emitter = self.Entity
local phys = emitter:GetPhysicsObject()
local dist = self.Entity:GetPos():Distance(LocalPlayer():GetPos())
	if data.Speed > 50 and dist < 300 then
		local volume = 80-(dist*0.3)
			if volume > 0 then
				emitter:EmitSound("player/pl_shell"..(math.random (1,3))..".wav", 25, 100)
			end
	end
	local impulse = -data.Speed * data.HitNormal * 2 + (data.OurOldVelocity * -.8)
	phys:ApplyForceCenter(impulse)
	
end

function EFFECT:GetBulletEjectPos(Position, Ent, Attachment)

	if (!Ent:IsValid()) then return Angle(), Position end
	if (!Ent:IsWeapon()) then return Angle(), Position end

	// Shoot from the viewmodel
	if (Ent:IsCarriedByLocalPlayer() && GetViewEntity() == LocalPlayer()) then
	
		local ViewModel = LocalPlayer():GetViewModel()
		
		if (ViewModel:IsValid()) then
			
			local att = ViewModel:GetAttachment(Attachment)
			if (att) then
				return att.Ang, att.Pos //+ att.Ang:Forward()*20 + att.Ang:Up()*0
			end
			
		end
	// Shoot from the world model
	else
		local att = Ent:GetAttachment(Attachment)
		if (att) then
			return att.Ang, att.Pos
		end
	end

	return Angle(), Position
end


function EFFECT:Think()

if self.Entity:GetNWInt("smoke") == 1 and self.Entity:GetNWInt("smoketime") > CurTime() then

	for i=0, 1 do
		local particle = self.emitter:Add( "particle/particle_smokegrenade", self.Entity:GetPos() - self.Entity:GetForward() * -3 )
		particle:SetVelocity( Vector( 0, math.sin(CurTime()*2)*self.Entity:GetNWInt("smokerand"), 40 ) )
		particle:SetGravity( Vector( 0, math.sin(CurTime()*2)*5, 0 ) )
		particle:SetAirResistance( 0 )
		//particle:SetColor(Color(255,0,0,25))

		particle:SetDieTime( math.Rand( 0.4, 1 ) )

		particle:SetStartAlpha( math.Rand( 15, 50 ) )
		particle:SetEndAlpha( 0 )
				
		particle:SetStartSize( math.random( 0.1, 0.2 ) )
		particle:SetEndSize( 3 )

		particle:SetRoll( math.Rand( 180, 480 ) )
		particle:SetRollDelta( math.Rand( -1, 1 ) )
		//particle:SetBounce( 1 )
		particle:SetCollide( true )

	end
	
end

	return self.LifeTime > CurTime()
end

function EFFECT:Render()

	self.Entity:DrawModel()
	
end