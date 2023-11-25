
-- Convars --

local MultDamagePlayer = CreateConVar("drgbase_multiplier_damage_players", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED})
local MultDamageNPC = CreateConVar("drgbase_multiplier_damage_npc", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED})
local RemoveDead = CreateConVar("drgbase_remove_dead", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED})

-- Functions --

function ENT:LastHitGroup()
  return self:GetNW2Int("DrGBaseLastHitGroup", 0)
end

-- Handlers --

function ENT:_InitHooks()
  if CLIENT then return end
  self._DrGBaseLastDmgInflicted = {}
  self:DrG_AddListener("OnTraceAttack", self._HandleTraceAttack)
  self:DrG_AddListener("OnNavAreaChanged", self._HandleNavAreaChanged)
  self:DrG_AddListener("OnLeaveGround", self._HandleLeaveGround)
  self:DrG_AddListener("OnLandOnGround", self._HandleLandOnGround)
end

if SERVER then

  -- Damage --

  function ENT:OnTakeDamage(dmg)
    self:SpotEntity(dmg:GetAttacker())
  end
  --function ENT:OnTookDamage() end

  function ENT:OnFatalDamage() end
  function ENT:OnDowned() end
  --function ENT:OnDeath() end

  function ENT:OnDealtDamage() end

  local function NextbotDeath(self, dmg)
    if not IsValid(self) then return end
    if self:HasWeapon() and self.DropWeaponOnDeath then
      self:DropWeapon()
    end
    if self.RagdollOnDeath then
      return self:BecomeRagdoll(dmg)
    else 
		self:Remove();
		end
  end

  function ENT:_HandleTraceAttack(dmg, dir, tr)
    self:SetNW2Int("DrGBaseLastHitGroup", tr.HitGroup)
    self._DrGBaseHitGroupToHandle = true
  end
  function ENT:OnInjured(dmg)
    if dmg:GetDamage() <= 0 or self:GetGodMode() then
      self._DrGBaseHitGroupToHandle = false
      return dmg:ScaleDamage(0)
    else
      self:Timer(0, self._UpdateHealth)
      local hitgroup = self._DrGBaseHitGroupToHandle and self:LastHitGroup() or HITGROUP_GENERIC
      local attacker = dmg:GetAttacker()
      local res = self:OnTakeDamage(dmg, hitgroup)
      if IsValid(attacker) and DrGBase.IsTarget(attacker) then
        if self:IsAlly(attacker) then
          self._DrGBaseAllyDamageTolerance[attacker] = self._DrGBaseAllyDamageTolerance[attacker] or 0
          self._DrGBaseAllyDamageTolerance[attacker] = self._DrGBaseAllyDamageTolerance[attacker] + self.AllyDamageTolerance
          self:AddEntityRelationship(attacker, D_HT, self._DrGBaseAllyDamageTolerance[attacker])
        elseif self:IsAfraidOf(attacker) then
          self._DrGBaseAfraidOfDamageTolerance[attacker] = self._DrGBaseAfraidOfDamageTolerance[attacker] or 0
          self._DrGBaseAfraidOfDamageTolerance[attacker] = self._DrGBaseAfraidOfDamageTolerance[attacker] + self.AfraidDamageTolerance
          self:AddEntityRelationship(attacker, D_HT, self._DrGBaseAfraidOfDamageTolerance[attacker])
        elseif self:IsNeutral(attacker) then
          self._DrGBaseNeutralDamageTolerance[attacker] = self._DrGBaseNeutralDamageTolerance[attacker] or 0
          self._DrGBaseNeutralDamageTolerance[attacker] = self._DrGBaseNeutralDamageTolerance[attacker] + self.NeutralDamageTolerance
          self:AddEntityRelationship(attacker, D_HT, self._DrGBaseNeutralDamageTolerance[attacker])
        end
      end
      if res == true or self:IsDown() or self:IsDead() then
        self._DrGBaseHitGroupToHandle = false
        return dmg:ScaleDamage(0)
      else
        if isnumber(res) then dmg:ScaleDamage(res) end
        if dmg:GetDamage() >= self:Health() then
          if self:OnFatalDamage(dmg, hitgroup) then
            self._DrGBaseHitGroupToHandle = false
            self:SetNW2Bool("DrGBaseDown", true)
            self:SetNW2Int("DrGBaseDowned", self:GetNW2Int("DrGBaseDowned")+1)
            self:SetHealth(1)
            if #self.OnDownedSounds > 0 then
              self:EmitSound(self.OnDownedSounds[math.random(#self.OnDownedSounds)])
            end
            local noTarget = self:GetNoTarget()
            self:SetNoTarget(true)
            local data = util.DrG_SaveDmg(dmg)
            self:CallInCoroutine(function(self)
              self:OnDowned(util.DrG_LoadDmg(data), hitgroup)
              if self:Health() <= 0 then self:SetHealth(1) end
              self:SetNoTarget(noTarget)
              self:SetNW2Bool("DrGBaseDown", false)
            end)
          else self:SetHealth(0) end
          return dmg:ScaleDamage(0)
        else
          self._DrGBaseHitGroupToHandle = false
          if #self.OnDamageSounds > 0 then
            self:EmitSlotSound("DrGBaseDamageSounds", self.DamageSoundDelay, self.OnDamageSounds[math.random(#self.OnDamageSounds)])
          end
          if isfunction(self.OnTookDamage) then
            local data = util.DrG_SaveDmg(dmg)
            self:ReactInCoroutine(function(self)
              if self:IsDown() then return end
              dmg = util.DrG_LoadDmg(data)
              self:OnTookDamage(dmg, hitgroup)
            end)
          elseif isfunction(self.AfterTakeDamage) then
            local data = util.DrG_SaveDmg(dmg)
            local now = CurTime()
            self:ReactInCoroutine(function(self)
              if self:IsDown() then return end
              dmg = util.DrG_LoadDmg(data)
              self:AfterTakeDamage(dmg, CurTime()-now, hitgroup)
            end)
          end
        end
      end
    end
  end
  function ENT:OnKilled(dmg)
    if self:IsDead() then return end
    local hitgroup = self._DrGBaseHitGroupToHandle and self:LastHitGroup() or HITGROUP_GENERIC
    self._DrGBaseHitGroupToHandle = false
    self:SetHealth(0)
    self:SetNW2Bool("DrGBaseDying", true)
    self:DrG_DeathNotice(dmg:GetAttacker(), dmg:GetInflictor())
    if #self.OnDeathSounds > 0 then
      self:EmitSound(self.OnDeathSounds[math.random(#self.OnDeathSounds)])
    end
    if dmg:IsDamageType(DMG_DISSOLVE) then self:DrG_Dissolve() end
    if isfunction(self.OnDeath) then
      local data = util.DrG_SaveDmg(dmg)
      self.BehaveThread = coroutine.create(function()
        self:SetNW2Bool("DrGBaseDying", false)
        self:SetNW2Bool("DrGBaseDead", true)
        if RemoveDead:GetBool() and GetConVar("drgbase_remove_ragdolls"):GetFloat() >= 0 then
          self:Timer(GetConVar("drgbase_remove_ragdolls"):GetFloat(), self.Remove)
        end
        local now = CurTime()
        dmg = self:OnDeath(util.DrG_LoadDmg(data), hitgroup)
        if dmg == nil then
          dmg = util.DrG_LoadDmg(data)
          if CurTime() > now then
            dmg:SetDamageForce(Vector(0, 0, 1))
          end
        end
        NextbotDeath(self, dmg)
      end)
    else
      self:SetNW2Bool("DrGBaseDying", false)
      self:SetNW2Bool("DrGBaseDead", true)
      NextbotDeath(self, dmg)
    end
  end

  hook.Add("EntityTakeDamage", "DrGBaseNextbotDealtDamage", function(ent, attacker, inflictor, hitGroup, dmg)
    local attacker = dmg:GetAttacker()
    if IsValid(attacker) and attacker.IsDrGNextbot then
      if attacker == ent then return true end
      if ent:IsPlayer() then dmg:ScaleDamage(MultDamagePlayer:GetFloat())
      else dmg:ScaleDamage(MultDamageNPC:GetFloat()) end
      local res = attacker:OnDealtDamage(ent, dmg)
      if isnumber(res) then dmg:ScaleDamage(res)
      elseif res == true then return true end
      attacker._DrGBaseLastDmgInflicted[ent] = {
        data = util.DrG_SaveDmg(dmg), time = CurTime()
      }
    end
  end)
  function ENT:LastDamageDealt(ent)
    if not self._DrGBaseLastDmgInflicted[ent] then return nil, -1 end
    local last = self._DrGBaseLastDmgInflicted[ent]
    return util.DrG_LoadDmg(last.data), last.time
  end

  -- Collisions --

  function ENT:OnCombineBall() end

  function ENT:OnPhysDamage(ent, data)
    return (data.TheirOldVelocity:Length()*data.HitObject:GetMass())/1000
  end

  function ENT:_HandleCollide(data)
    local ent = data.HitEntity
    if not IsValid(ent) then return end
    local class = ent:GetClass()
    local phys = data.HitObject
    if class == "prop_combine_ball" then
      if self:IsFlagSet(FL_DISSOLVING) then return end
      if not self:OnCombineBall(ent) then
        if not self:IsDead() then
          local dmg = DamageInfo()
          local owner = ent:GetOwner()
          dmg:SetAttacker(IsValid(owner) and owner or ent)
          dmg:SetInflictor(ent)
          dmg:SetDamage(1000)
          dmg:SetDamageType(DMG_DISSOLVE)
          dmg:SetDamageForce(ent:GetVelocity())
          self:TakeDamageInfo(dmg)
        else self:DrG_Dissolve() end
        ent:EmitSound("NPC_CombineBall.KillImpact")
      end
    elseif not ent:IsPlayerHolding() then
      local damage = math.floor(self:OnPhysDamage(ent, data))
      if damage > math.max(0, self.MinPhysDamage) then
        local dmg = DamageInfo()
        if ent:IsVehicle() and IsValid(ent:GetDriver()) then
          dmg:SetAttacker(ent:GetDriver())
        elseif IsValid(ent:GetPhysicsAttacker()) then
          dmg:SetAttacker(ent:GetPhysicsAttacker())
        else dmg:SetAttacker(ent) end
        dmg:SetInflictor(ent)
        dmg:SetDamage(damage)
        if ent:IsVehicle() then
          dmg:SetDamageType(DMG_VEHICLE)
        else dmg:SetDamageType(DMG_CRUSH) end
        dmg:SetDamageForce(phys:GetVelocity())
        self:TakeDamageInfo(dmg)
      end
    end
  end

  hook.Add("OnEntityCreated", "DrGBaseAddPhysicsCollideCallback", function(ent)
    ent:DrG_Timer(0, function()
      ent:AddCallback("PhysicsCollide", function(ent, data)
        if not isfunction(ent.PhysicsCollide) then return end
        if IsValid(data.HitEntity) and data.HitEntity.IsDrGNextbot then
          ent:PhysicsCollide(data, data.PhysObject)
        end
      end)
    end)
  end)

  -- Ground --

  function ENT:OnFallDamage(speed)
    --return math.max(0, speed-self.loco:GetDeathDropHeight())/15
    return 0
  end
  -- function ENT:OnLeftGround() end
  -- function ENT:OnLandedOnGround() end

  function ENT:_HandleLeaveGround()
    self:SetNW2Bool("DrGBaseOnGround", false)
    self:UpdateAnimation()
    self:UpdateSpeed()
    if isfunction(self.OnLeftGround) then
      self:ReactInCoroutine(self.OnLeftGround)
    end
  end
  function ENT:_HandleLandOnGround()
    self:SetNW2Bool("DrGBaseOnGround", true)
    self:UpdateAnimation()
    self:UpdateSpeed()
    self:InvalidatePath()
    local damage = math.floor(self:OnFallDamage(self._DrGBaseDownSpeed))
    --print(damage)
    if damage > math.max(0, self.MinFallDamage) then
      local dmg = DamageInfo()
      dmg:SetDamage(damage)
      dmg:SetAttacker(self)
      dmg:SetInflictor(self)
      dmg:SetDamageType(DMG_FALL)
      self:TakeDamageInfo(dmg)
    end
    if isfunction(self.OnLandedOnGround) then
      self:ReactInCoroutine(self.OnLandedOnGround)
    end
  end

  -- OnNavAreaChanged --

  function ENT:GetPreviousNavArea()
    return self._DrGBasePreviousNavArea
  end
  function ENT:GetNavArea()
    return self._DrGBaseNavArea
  end
  function ENT:_HandleNavAreaChanged(old, new)
    self._DrGBasePreviousNavArea = old
    self._DrGBaseNavArea = new
  end

  -- Misc --

  hook.Add("vFireEntityStartedBurning", "DrGBaseNextbotOnIgniteVFire", function(ent)
    if ent.IsDrGNextbot then ent:OnIgnite() end
  end)

end
