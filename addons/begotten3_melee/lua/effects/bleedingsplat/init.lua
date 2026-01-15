function EFFECT:Init(data) --from Hoobsug, since it was just what i was looking for. it's part of his old badass sweps. if he wants this taken out he can gimme a buzz
	
	//if not IsValid(data:GetEntity()) then return end
	//if not IsValid(data:GetEntity():GetOwner()) then return end
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()
	
	//if self.WeaponEnt == nil or self.WeaponEnt:GetOwner() == nil or self.WeaponEnt:GetOwner():GetVelocity() == nil then 
		//return
	//else
	
	//self.Position = self:GetTracerShootPos(data:GetOrigin(), self.WeaponEnt, self.Attachment)
	self.Position = data:GetOrigin()
	self.Forward = data:GetNormal()
	self.Angle = self.Forward:Angle()
	self.Right = self.Angle:Right()
	
	local AddVel = 5//self.WeaponEnt:GetOwner():GetVelocity()
	local emitter = ParticleEmitter(data:GetOrigin())

for i=1, 5 do
			--self:EmitSound("physics/flesh/flesh_bloody_impact_hard1.wav", 30, 60)
			local Blood = {}
			Blood[1] = "decals/blood2"
			Blood[2] = "decals/blood7"
			Blood[3] = "decals/blood3"
			Blood[4] = "decals/blood8"
			local particle = emitter:Add( Blood[math.random(1,4)], self.Position - self.Forward * 4, (Color(255,0,0,25)) )
			particle:SetVelocity( 10 * VectorRand() + 10 * VectorRand() + 10 * VectorRand() )
			particle:SetGravity( Vector( 0, 0, -500 ) )
			particle:SetAirResistance( 0 )
			//particle:SetColor(Color(255,0,0,25))

			particle:SetDieTime( 1 )

			particle:SetStartSize( 10 )
			particle:SetEndSize( 0 )
			
			particle:SetStartLength( 0 ) 
			particle:SetEndLength( 105 )

			particle:SetRoll( math.Rand( 180, 480 ) )
			particle:SetRollDelta( math.Rand( -1, 1 ) )
			//particle:SetBounce( 1 )
			particle:SetCollide( true )
			
			particle:SetCollideCallback( function(a,h,n)
				local tr = {}
			 	tr.start = particle:GetPos()
			 	tr.endpos = particle:GetPos() + Vector(0,0,-128)--+ particle:GetAngles():Forward() * 50
			 	tr.filter = particle
				tr.mask = MASK_ALL
				local tr = util.TraceLine( tr )
				util.Decal( "Blood", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal )
				
				timer.Simple(math.Rand(0, 0.25), function()
					if (math.random(1, 2) == 2) then
						sound.Play("physics/flesh/flesh_squishy_impact_hard"..math.random(1, 4)..".wav", tr.HitPos, 35, math.random(80, 150), 1)
					end;
				end);
			end)

end

emitter:Finish()
end
//end

function EFFECT:Think()
	
	return false
end


function EFFECT:Render()
end