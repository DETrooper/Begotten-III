AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "M2 Browning"
ENT.Author = "Annoying Rooster"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Emplacements"

if (SERVER) then
	function ENT:GetTurretAngle()
		local modAng = Angle(-90, 0, -90)
		local ang = self:GetAngles()
		ang:RotateAroundAxis(ang:Up(), modAng[1])
		ang:RotateAroundAxis(ang:Right(), modAng[2])
		ang:RotateAroundAxis(ang:Forward(), modAng[3])

		return ang
	end

	function ENT:Initialize()
		self:SetModel("models/props_lab/tpplug.mdl")
		self:SetMaterial("models/props_building_details/courtyard_template001c_bars_dark");
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		local physicsObject = self:GetPhysicsObject()

		if (IsValid(physicsObject)) then
			physicsObject:Wake()
		end

		local pos, ang = self:GetPos(), self:GetAngles()
		local modPos = Vector(0, 11, 4)

		pos = pos + ang:Up() * modPos[3]
		pos = pos + ang:Forward() * modPos[2]
		pos = pos + ang:Right() * modPos[1]

		self.gun = ents.Create("cw_longship_m2browning")
		self.gun:SetPos(pos)
		self.gun:SetAngles(self:GetTurretAngle())
		self.gun:Spawn()
		self.gun:Activate()
		self.gun:SetParent(self)
		self:DeleteOnRemove(self.gun)
		self.gunAng = Angle(0, 0, 0)
	end

	function ENT:AddGunAngle(ang)
		self.gunAng = self.gunAng + ang

	end

	function ENT:OnRemove()
		if (self.Owner and IsValid(self.Owner)) then
			self.Owner:GetViewModel():SetNoDraw(false)
			self.Owner.Turret = nil
		end
	end

	function ENT:Think()
		if (self.Owner and IsValid(self.Owner) and self.Owner:Alive() and self:GetPos():Distance(self.Owner:GetPos()) <= 80) then
			local aimVector = self.Owner:GetAimVector()
			local turretForward = self:GetUp()
			local turretDot = turretForward:Dot(aimVector)

			if (turretDot > 0.4) then
				self.Owner:GetViewModel():SetNoDraw(false)
				self.Owner.Turret = nil
				self.Owner = nil
				self:EmitSound("weapons/ironclad50/50-dismount.wav")
				return
			end

			local data = {}
				data.start = self.Owner:GetShootPos()
				data.endpos = data.start + aimVector*10000
				data.filter = {self.Owner, self, self.gun}
			local trace = util.TraceLine(data)

			local cappedVector = (turretForward + trace.Normal)
			cappedVector.x = math.Clamp( cappedVector.x, -1, 1)
			cappedVector.y = math.Clamp( cappedVector.y, -1, 1)
			cappedVector.z = math.Clamp( cappedVector.z, -.4, .4)

			local ang = (turretForward - cappedVector):Angle()
			ang:RotateAroundAxis(ang:Up(), 90)
			self.gunAng = LerpAngle( .1, self.gunAng, ang )
			self.gun:SetAngles(self.gunAng)

			if self.Owner:GetActiveWeapon():IsValid() then
				self.Owner:GetActiveWeapon():SetNextPrimaryFire(CurTime()+1)
				self.Owner:GetActiveWeapon():SetNextSecondaryFire(CurTime()+1)
			end

			if self.Owner:KeyDown( IN_ATTACK ) then
				self.gun:ShootBullet()
			end

			if self.Owner:KeyDown( IN_RELOAD ) then
				local reloadItem = self.Owner:GetItemInstance("ironclad_ammo_box");
				
				if reloadItem then
					self.Owner:TakeItem(reloadItem);
					self.gun:Reload()
				end
			end
		else
			if (self.Owner and IsValid(self.Owner)) then
				self.Owner:GetViewModel():SetNoDraw(false)
				self.Owner.Turret = nil
				self.Owner = nil
				self:EmitSound("weapons/ironclad50/50-dismount.wav")
			end
		end

		self:NextThink(CurTime())
		return true
	end

	function ENT:Use(client)
		local faction = client:GetSharedVar("kinisgerOverride") or client:GetFaction();
		
		if faction == "Goreic Warrior" then
			local subfaction = client:GetSharedVar("kinisgerOverrideSubfaction") or client:GetSubfaction();
			
			if subfaction == "Clan Shagalax" then
				self:OnUse(client)
			else
				Schema:EasyText(client, "peru", "Only Clan Shagalax can use firearms!");
			end
		else
			Schema:EasyText(client, "peru", "The turret is locked in place and cannot be budged!");
		end
	end

	function ENT:OnUse(client)
		if (self.Owner and IsValid(self.Owner)) then
			if (self.Owner == client) then
				self:EmitSound("weapons/ironclad50/50-dismount.wav")
				self.Owner:GetViewModel():SetNoDraw(false)
				self.Owner.Turret = nil
				self.Owner = nil
			end
		else
			local aimVector = client:GetAimVector()
			local turretForward = self:GetUp()
			local turretDot = turretForward:Dot(aimVector)

			if (turretDot > 0 or math.abs(turretDot) < .2) then
				return
			end

			if (client.Turret and IsValid(client.Turret)) then
				return
			end

			self.gun.nextFire = CurTime() + .7
			self:EmitSound("weapons/ironclad50/50-mount.wav")
			self.Owner = client
			self.Owner:GetViewModel():SetNoDraw(true)
			self.Owner.Turret = self
		end
	end
end