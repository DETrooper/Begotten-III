
-- Getters/setters --

function ENT:GetActiveWeapon()
	return self:GetNW2Entity("DrGBaseWeapon")
end
function ENT:GetWeapon(class)
	if isstring(class) then
		return self._DrGBaseWeapons[class] or NULL
	else return self:GetActiveWeapon() end
end
function ENT:HasWeapon(class)
	return IsValid(self:GetWeapon(class))
end
function ENT:HaveWeapon(class)
	return self:HasWeapon(class)
end

function ENT:GetWeapons()
	return table.DrG_Copy(self._DrGBaseWeapons)
end
function ENT:GetWeaponCount()
	local count = 0
	for class, weapon in pairs(self._DrGBaseWeapons) do
		if IsValid(weapon) then count = count+1 end
	end
	return count
end

function ENT:IsReloadingWeapon()
	if not self:HasWeapon() then return false end
	return self:GetNW2Bool("DrGBaseReloadWeapon")
end

function ENT:GetShootPos(class)
	if self:HasWeapon(class) then
		local weapon = self:GetWeapon(class)
		for boneId = 0, (weapon:GetBoneCount()-1) do
			local boneName = weapon:GetBoneName(boneId)
			local lookedUp = self:LookupBone(boneName)
			if lookedUp then
				local bonepos = self:GetBonePosition(lookedUp)
				return bonepos
			end
		end
		return self:WorldSpaceCenter()
	else return self:WorldSpaceCenter() end
end
function ENT:GetAimVector(class)
	if self:IsPossessed() then
		local lockedOn = self:PossessionGetLockedOn()
		if IsValid(lockedOn) then
			local aimAt = self:OnAimAtEntity(lockedOn) or lockedOn:WorldSpaceCenter()
			return self:GetShootPos(class):DrG_Direction(aimAt):GetNormalized()
		else return self:GetShootPos(class):DrG_Direction(self:PossessorTrace().HitPos):GetNormalized() end
	elseif self:HasEnemy() then
		local enemy = self:GetEnemy()
		local aimAt = self:OnAimAtEntity(enemy) or enemy:WorldSpaceCenter()
		return self:GetShootPos(class):DrG_Direction(aimAt):GetNormalized()
	else return self:EyeAngles():Forward() end
end

-- Functions --

-- Hooks --

function ENT:OnWeaponChange() end
function ENT:OnPickupWeapon() end
function ENT:OnDropWeapon() end
function ENT:OnAimAtEntity() end

-- Handlers --

local LONG_RANGE = {
	["crossbow"] = true
}
local MEDIUM_RANGE = {
	["pistol"] = true,
	["revolver"] = true,
	["grenade"] = true,
	["duel"] = true
}
local CLOSE_RANGE = {
	["shotgun"] = true,
	["camera"] = true
}

function ENT:_InitWeapons()
	self._DrGBaseWeapons = {}
	self:SetNW2VarProxy("DrGBaseWeapon", function(self, name, old, new)
		if not self:OnWeaponChange(old, new) and SERVER and
		self.BehaviourType == AI_BEHAV_HUMAN then
			local holdType = new:GetHoldType()
			if DrGBase.IsMeleeWeapon(new) then
				self.RangeAttackRange = 0
				self.MeleeAttackRange = 30
				self.ReachEnemyRange = 25
				self.AvoidEnemyRange = 0
			elseif LONG_RANGE[holdType] then
				self.RangeAttackRange = 3000
				self.MeleeAttackRange = 0
				self.ReachEnemyRange = 2000
				self.AvoidEnemyRange = 750
			elseif CLOSE_RANGE[holdType] then
				self.RangeAttackRange = 325
				self.MeleeAttackRange = 0
				self.ReachEnemyRange = 250
				self.AvoidEnemyRange = 175
			elseif MEDIUM_RANGE[holdType] then
				self.RangeAttackRange = 750
				self.MeleeAttackRange = 0
				self.ReachEnemyRange = 500
				self.AvoidEnemyRange = 350
			else
				self.RangeAttackRange = 1500
				self.MeleeAttackRange = 0
				self.ReachEnemyRange = 1000
				self.AvoidEnemyRange = 750
			end
		end
	end)
	if CLIENT then return end
	if self.UseWeapons then
		for i, class in ipairs(self.Weapons) do
			self:GiveWeapon(class)
		end
		self:RandomWeapon()
	end
end

if SERVER then

	-- Misc --

	local function IsWeapon(ent)
		return isentity(ent) and IsValid(ent) and ent:IsWeapon()
	end

	-- Getters/setters --

	function ENT:SetActiveWeapon(weapon)
		if not IsWeapon(weapon) then return false end
		if self._DrGBaseWeapons[weapon:GetClass()] ~= weapon then return false end
		local active = self:GetActiveWeapon()
		if IsValid(active) then active:SetNoDraw(true) end
		weapon:SetNoDraw(false)
		self:SetNW2Entity("DrGBaseWeapon", weapon)
		return true
	end

	function ENT:GetWeaponPrimaryAmmo(class)
		if not self:HasWeapon(class) then return 0 end
		local wep = self:GetWeapon(class)
		if wep:GetMaxClip1() > 0 then return wep:Clip1()
		elseif wep:GetPrimaryAmmoType() > -1 then
			return -1
		else return math.huge end
	end
	function ENT:GetWeaponSecondaryAmmo(class)
		if not self:HasWeapon(class) then return 0 end
		local wep = self:GetWeapon(class)
		if wep:GetMaxClip2() > 0 then return wep:Clip2()
		elseif wep:GetSecondaryAmmoType() > -1 then
			return -1
		else return math.huge end
	end

	function ENT:IsWeaponPrimaryFull(class)
		if not self:HasWeapon(class) then return false end
		local ammo = self:GetWeaponPrimaryAmmo(class)
		if ammo == math.huge or ammo == -1 then return true end
		return ammo >= self:GetWeapon(class):GetMaxClip1()
	end
	function ENT:IsWeaponPrimaryEmpty(class)
		if not self:HasWeapon(class) then return true end
		local ammo = self:GetWeaponPrimaryAmmo(class)
		if ammo == -1 then return false end
		return ammo <= 0
	end

	function ENT:IsWeaponSecondaryFull(class)
		if not self:HasWeapon(class) then return false end
		local ammo = self:GetWeaponSecondaryAmmo(class)
		if ammo == math.huge or ammo == -1 then return true end
		return ammo >= self:GetWeapon(class):GetMaxClip2()
	end
	function ENT:IsWeaponSecondaryEmpty(class)
		if not self:HasWeapon(class) then return true end
		local ammo = self:GetWeaponSecondaryAmmo(class)
		if ammo == -1 then return false end
		return ammo <= 0
	end

	function ENT:IsWeaponFull(class)
		return self:IsWeaponPrimaryFull(class) and self:IsWeaponSecondaryFull(class)
	end
	function ENT:IsWeaponEmpty(class)
		return self:IsWeaponPrimaryEmpty(class) and self:IsWeaponSecondaryEmpty(class)
	end

	-- Functions --

	function ENT:GiveWeapon(class)
		if not self:HasWeapon(class) then
			local weapon = ents.Create(class)
			if not IsValid(weapon) then return NULL end
			if IsWeapon(weapon) then
				weapon:Spawn()
				if not self:PickupWeapon(weapon) then
					weapon:Remove()
					return NULL
				else return weapon end
			else
				weapon:Remove()
				return NULL
			end
		else return self:GetWeapon(class) end
	end
	function ENT:PickupWeapon(weapon)
		if not IsWeapon(weapon) then return false end
		if self:HasWeapon(weapon:GetClass()) then return false end
		weapon:SetPos(self:WorldSpaceCenter())
		weapon:SetNotSolid(true)
		weapon:SetMoveType(MOVETYPE_NONE)
		weapon:SetOwner(self)
		weapon:SetParent(self)
		weapon:AddEffects(EF_BONEMERGE)
		self._DrGBaseWeapons[weapon:GetClass()] = weapon
		self:OnPickupWeapon(weapon, weapon:GetClass())
		self:NetMessage("DrGBasePickupWeapon", weapon)
		if IsValid(self:GetActiveWeapon()) then
			weapon:SetNoDraw(true)
		else self:SetActiveWeapon(weapon) end
		return true
	end

	function ENT:RemoveWeapon(weapon)
		weapon = self:DropWeapon(weapon or self:GetActiveWeapon())
		if IsValid(weapon) then
			weapon:Remove()
			return weapon
		else return NULL end
	end
	function ENT:DropWeapon(weapon)
		if weapon == nil then weapon = self:GetActiveWeapon() end
		if isstring(weapon) then weapon = self:GetWeapon(weapon) end
		if not IsWeapon(weapon) then return NULL end
		if self._DrGBaseWeapons[weapon:GetClass()] ~= weapon then return NULL end
		local active = self:GetActiveWeapon()
		weapon:SetOwner(NULL)
		weapon:SetParent(NULL)
		weapon:RemoveEffects(EF_BONEMERGE)
		weapon:SetMoveType(MOVETYPE_VPHYSICS)
		weapon:SetPos(self:WorldSpaceCenter())
		self._DrGBaseWeapons[weapon:GetClass()] = nil
		self:OnDropWeapon(weapon, weapon:GetClass())
		self:NetMessage("DrGBaseDropWeapon", weapon:GetClass())
		if active == weapon then self:SwitchWeapon() end
		weapon:SetNoDraw(false)
		weapon:SetNotSolid(false)
		return weapon
	end

	function ENT:SelectWeapon(class)
		local weapon = self:GetWeapon(class)
		if not IsValid(weapon) then return NULL end
		self:SetActiveWeapon(weapon)
		return weapon
	end
	function ENT:SwitchWeapon()
		local weapon = table.DrG_Fetch(self._DrGBaseWeapons, function(weap1, weap2)
			if not IsValid(weap1) then return false end
			if not IsValid(weap2) then return true end
			local res = self:OnSwitchWeapon(weap1, weap2)
			if isbool(res) then return res end
			return weap1:GetWeight() > weap2:GetWeight()
		end)
		if not IsValid(weapon) then return NULL end
		self:SetActiveWeapon(weapon)
		return weapon
	end
	function ENT:RandomWeapon()
		local weapons = {}
		for class, weapon in pairs(self._DrGBaseWeapons) do
			if IsValid(weapon) then table.insert(weapons, weapon) end
		end
		if #weapons > 0 then
			local weapon = weapons[math.random(#weapons)]
			self:SetActiveWeapon(weapon)
			return weapon
		else return NULL end
	end

	-- Shoot/reload
	local SUPPORTED_GUNS = {
		["weapon_ar2"] = {
			Bullet = {Damage = 8, TracerName = "AR2Tracer", Spread = Vector(0.020, 0.020, 0)},
			Sound = "Weapon_AR2.Single", Empty = "Weapon_AR2.Empty",
			Delay = 0.1, Cost = 1
		},
		["weapon_smg1"] = {
			Bullet = {Damage = 4, Spread = Vector(0.035, 0.035, 0)},
			Sound = "Weapon_SMG1.Single", Empty = "Weapon_SMG1.Empty",
			Delay = 0.065, Cost = 1
		},
		["weapon_shotgun"] = {
			Bullet = {Damage = 8, Spread = Vector(0.1, 0.1, 0), Num = 7},
			Sound = "Weapon_Shotgun.Single", Empty = "Weapon_Shotgun.Empty",
			Delay = 1.25, Cost = 1
		},
		["weapon_pistol"] = {
			Bullet = {Damage = 5, Spread = Vector(0.015, 0.015, 0)},
			Sound = "Weapon_Pistol.Single", Empty = "Weapon_Pistol.Empty",
			Delay = 0.75, Cost = 1
		},
		["weapon_357"] = {
			Bullet = {Damage = 40, Spread = Vector(0.015, 0.015, 0)},
			Sound = "Weapon_Revolver.Single", Empty = "Weapon_Pistol.Empty",
			Delay = 1.25, Cost = 1
		}
	}
	local function ShootGun(self, weapon, data)
		if not weapon._DrGBaseNextShoot or CurTime() > weapon._DrGBaseNextShoot then
			weapon._DrGBaseNextShoot = CurTime() + data.Delay
			if weapon:Clip1() >= data.Cost then
				weapon:EmitSound(data.Sound)
				data.Bullet.Src = self:GetShootPos()
				data.Bullet.Dir = self:GetAimVector()
				data.Bullet.Filter = {self, weapon, self:GetPossessor()}
				data.Bullet.Callback = function(self, tr, dmg)
					dmg:SetInflictor(weapon)
				end
				self:FireBullets(data.Bullet)
				weapon:SetClip1(weapon:Clip1() - data.Cost)
				return true
			else
				weapon:EmitSound(data.Empty)
				return false
			end
		else return false end
	end
	local function UseToolgun(self, toolgun, tr)
		if IsValid(tr.Entity) then
			local ent = tr.Entity
			local res = self:OnUseToolgun(ent, tr)
			if not isbool(res) then
				local rand = math.random(6)
				if rand == 1 then
					ent:SetColor(Color(math.random(0, 255), math.random(0, 255), math.random(0, 255)))
				elseif rand == 2 then
					local materials = list.Get("OverrideMaterials")
					ent:SetMaterial(materials[math.random(#materials)])
				elseif rand == 3 then
					local fx = EffectData()
					fx:SetOrigin(ent:GetPos())
					fx:SetEntity(ent)
					util.Effect("entity_remove", fx, true, true)
					if ent:IsPlayer() then ent:KillSilent()
					else SafeRemoveEntity(ent) end
				elseif rand == 4 then
					local dmg = DamageInfo()
					dmg:SetDamage(math.random(1, ent:Health()))
					dmg:SetAttacker(self)
					dmg:SetInflictor(toolgun)
					ent:DispatchTraceAttack(dmg, tr)
				elseif rand == 5 then
					local health = ent:Health()
					local maxHealth = ent:GetMaxHealth()
					ent:SetHealth(math.min(health + math.random(maxHealth - health + 1), maxHealth))
				elseif rand == 6 then
					local scale = math.Rand(0.1, 2)
					if ent.IsDrGNextbot then ent:Scale(scale, 0.1)
					else ent:SetModelScale(ent:GetModelScale()*scale, 0.1) end
				elseif rand == 7 then

				end
				return true
			else return res end
		else return false end
	end
	local function FireCrossbow(self, crossbow, target)
		local speed = 3500
		local offset = self:GetAimVector()*10
		if isentity(target) then
			local shootPos = self:GetShootPos()+offset
			local aimAt = self:OnAimAtEntity(target) or target:WorldSpaceCenter()
			local dist = shootPos:Distance(aimAt)
			if target:IsNPC() then
				return FireCrossbow(self, crossbow, aimAt+target:GetGroundSpeedVelocity()*(dist/speed))
			else return FireCrossbow(self, crossbow, aimAt+target:GetVelocity()*(dist/speed)) end
		elseif isvector(target) then
			local bolt = ents.Create("crossbow_bolt")
			if not IsValid(bolt) then return NULL end
			local shootPos = self:GetShootPos()+offset
			local dir = shootPos:DrG_Direction(target)
			bolt:SetOwner(self)
			bolt:SetPos(shootPos)
			bolt:SetAngles(dir:Angle())
			bolt:Fire("SetDamage", 100)
			bolt:Spawn()
			bolt:SetVelocity(dir:GetNormalized()*speed)
			return bolt
		else return NULL end
	end
	function ENT:WeaponPrimaryFire(anim)
		if not self:HasWeapon() then return false end
		if self:IsReloadingWeapon() then return false end
		local weapon = self:GetWeapon()
		local class = weapon:GetClass()
		if class == "gmod_tool" then
			if not weapon._DrGBaseNextShoot or CurTime() > weapon._DrGBaseNextShoot then
				weapon._DrGBaseNextShoot = CurTime() + 1.25
				local shootPos = self:GetShootPos()
				local tr = util.DrG_TraceLine({
					start = shootPos, endpos = shootPos+self:GetAimVector()*99999,
					filter = {self, weapon, self:GetPossessor()}
				})
				if UseToolgun(self, weapon, tr) then
					weapon:DoShootEffect(tr.HitPos, tr.HitNormal, tr.Entity, tr.PhysicsBone, true)
					self:PlayAnimation(anim)
				end
				return true
			else return false end
		elseif class == "weapon_crossbow" then
			if not weapon._DrGBaseNextShoot or CurTime() > weapon._DrGBaseNextShoot then
				weapon._DrGBaseNextShoot = CurTime() + 2.5
				if self:IsPossessed() then
					local lockedOn = self:PossessionGetLockedOn()
					if not IsValid(lockedOn) then
						FireCrossbow(self, weapon, self:PossessorTrace().HitPos)
					else FireCrossbow(self, weapon, lockedOn) end
				elseif self:HasEnemy() then
					FireCrossbow(self, weapon, self:GetEnemy())
				elseif self:HadEnemy() then
					self:UpdateEnemy()
					return self:WeaponPrimaryFire(anim)
				else FireCrossbow(self, weapon, self:GetPos()+self:GetForward()*3500) end
				weapon:EmitSound("Weapon_Crossbow.Single")
				weapon:EmitSound("Weapon_Crossbow.BoltFly")
				self:PlayAnimation(anim)
				return true
			else return false end
		elseif class == "gmod_camera" then
			if not weapon._DrGBaseNextShoot or CurTime() > weapon._DrGBaseNextShoot then
				weapon._DrGBaseNextShoot = CurTime() + 2.5
				weapon:EmitSound(weapon.ShootSound)
				return true
			else return false end
		elseif SUPPORTED_GUNS[class] then
			if weapon:Clip1() > weapon:GetMaxClip1() then weapon:SetClip1(weapon:GetMaxClip1()) end
			local data = SUPPORTED_GUNS[weapon:GetClass()]
			local res = ShootGun(self, weapon, data)
			if res then self:PlayAnimation(anim) end
			return res
		elseif weapon:IsScripted() and not self:IsWeaponPrimaryEmpty() then
			if CurTime() < weapon:GetNextPrimaryFire() then return false end
			self:PlayAnimation(anim)
			weapon:PrimaryAttack()
		else return false end
		return true
	end
	function ENT:WeaponSecondaryFire(anim)
		if not self:HasWeapon() then return false end
		if self:IsReloadingWeapon() then return false end
		local weapon = self:GetWeapon()
		local class = weapon:GetClass()
		if class == "weapon_ar2" then
			if not weapon._DrGBaseNextShoot or CurTime() > weapon._DrGBaseNextShoot then
				weapon._DrGBaseNextShoot = CurTime() + 1.5
				--[[local ball = ents.Create("prop_combine_ball")
				if not IsValid(ball) then return false end
				ball:SetOwner(self)
				ball:SetPos(self:GetShootPos()+self:GetAimVector()*10)
				ball:Spawn()
				local phys = ball:GetPhysicsObject()
				phys:Wake()
				phys:SetVelocity(self:GetAimVector()*500)]]
			else return false end
			return true
		elseif class == "weapon_shotgun" then
			if isstring(anim) then self:AddGestureSequence(anim)
			elseif isnumber(anim) then self:AddGesture(anim) end
			return ShootGun(self, weapon, {
				Bullet = {Damage = 8, Spread = Vector(0.1, 0.1, 0), Num = 14},
				Sound = "Weapon_Shotgun.Double", Empty = "Weapon_Shotgun.Empty",
				Delay = 1.25, Cost = 2
			}, anim)
		elseif weapon:IsScripted() and not self:IsWeaponSecondaryEmpty() then
			if CurTime() < weapon:GetNextSecondaryFire() then return false end
			if isstring(anim) then self:AddGestureSequence(anim)
			elseif isnumber(anim) then self:AddGesture(anim) end
			weapon:SecondaryAttack()
		else return false end
		return true
	end
	function ENT:WeaponReload(anim)
		if not self:HasWeapon() then return false end
		if self:IsReloadingWeapon() then return false end
		local weapon = self:GetWeapon()
		self:SetNW2Bool("DrGBaseReloadWeapon", true)
		self:Timer(self:PlayAnimation(anim) or 0, function()
			self:SetNW2Bool("DrGBaseReloadWeapon", false)
			if not self:HasWeapon() then return end
			weapon = self:GetWeapon()
			if not self:IsWeaponPrimaryFull() then
				weapon:SetClip1(weapon:GetMaxClip1())
			end
			if not self:IsWeaponSecondaryFull() then
				weapon:SetClip2(weapon:GetMaxClip2())
			end
		end)
		return true
	end

	-- Hooks --

	function ENT:OnSwitchWeapon() end
	function ENT:OnUseToolgun() end

	-- Handlers --

	hook.Add("PlayerCanPickupWeapon", "DrGBaseNextbotWeaponDisablePickup", function(ply, weapon)
		local owner = weapon:GetOwner()
		if IsValid(owner) and owner.IsDrGNextbot then return false end
	end)

else

	-- Getters/setters --

	-- Functions --

	-- Hooks --

	-- Handlers --

end
