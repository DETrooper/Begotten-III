
function SWEP:ShootBullet(damage, num_bullets, aimcone)
	local bullet = {}
	bullet.Num = num_bullets
	bullet.Src = self.Owner:GetShootPos()
	bullet.Dir = self.Owner:GetAimVector()
	bullet.Spread = Vector(aimcone, aimcone, 0)
	bullet.Tracer	= 1
	bullet.Force = damage/10
	bullet.Damage	= damage
	bullet.AmmoType = "Pistol"
	bullet.Callback = function(ent, tr, dmg)
		dmg:SetAttacker(self.Owner)
		dmg:SetInflictor(self)
	end
	self.Owner:FireBullets(bullet)
	self:ShootEffects()
end
