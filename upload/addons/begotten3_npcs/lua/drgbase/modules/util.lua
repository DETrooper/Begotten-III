
-- Traces --

local DebugTraces = CreateConVar("drgbase_debug_traces", "0")
function util.DrG_TraceLine(data)
  local tr = util.TraceLine(data)
  if DebugTraces:GetFloat() > 0 then
    local clr = tr.Hit and DrGBase.CLR_RED or DrGBase.CLR_GREEN
    debugoverlay.Line(data.start, tr.HitPos, DebugTraces:GetFloat(), clr, false)
    debugoverlay.Line(tr.HitPos, data.endpos, DebugTraces:GetFloat(), DrGBase.CLR_WHITE, false)
  end
  return tr
end
function util.DrG_TraceHull(data)
  local tr = util.TraceHull(data)
  if DebugTraces:GetFloat() > 0 then
    local clr = tr.Hit and DrGBase.CLR_RED or DrGBase.CLR_GREEN
    clr = clr:ToVector():ToColor() clr.a = 0
    debugoverlay.Line(data.start, tr.HitPos, DebugTraces:GetFloat(), DrGBase.CLR_WHITE, false)
    debugoverlay.Box(tr.HitPos, data.mins, data.maxs, DebugTraces:GetFloat(), clr)
  end
  return tr
end
function util.DrG_TraceLineRadial(dist, precision, data)
  local traces = {}
  for i = 1, precision do
    local normal = Vector(1, 0, 0)
    normal:Rotate(Angle(0, i*(360/precision), 0))
    data.endpos = data.start + normal*dist
    table.insert(traces, util.DrG_TraceLine(data))
  end
  table.sort(traces, function(tr1, tr2)
    return data.start:DistToSqr(tr1.HitPos) < data.start:DistToSqr(tr2.HitPos)
  end)
  return traces
end
function util.DrG_TraceHullRadial(dist, precision, data)
  local traces = {}
  for i = 1, precision do
    local normal = Vector(1, 0, 0)
    normal:Rotate(Angle(0, i*(360/precision), 0))
    data.endpos = data.start + normal*dist
    table.insert(traces, util.DrG_TraceHull(data))
  end
  table.sort(traces, function(tr1, tr2)
    return data.start:DistToSqr(tr1.HitPos) < data.start:DistToSqr(tr2.HitPos)
  end)
  return traces
end

-- Misc --

function util.DrG_SaveDmg(dmg)
  local data = {}
  data.ammoType = dmg:GetAmmoType()
  data.attacker = dmg:GetAttacker()
  data.baseDamage = dmg:GetBaseDamage()
  data.damage = dmg:GetDamage()
  data.damageBonus = dmg:GetDamageBonus()
  data.damageCustom = dmg:GetDamageCustom()
  data.damageForce = dmg:GetDamageForce()
  data.damagePosition = dmg:GetDamagePosition()
  data.damageType = dmg:GetDamageType()
  data.inflictor = dmg:GetInflictor()
  data.maxDamage = dmg:GetMaxDamage()
  data.reportedPosition = dmg:GetReportedPosition()
  return data
end
function util.DrG_LoadDmg(data)
  local dmg = DamageInfo()
  if not istable(data) then return end
  dmg:SetAmmoType(data.ammoType)
  if IsValid(data.attacker) then
    dmg:SetAttacker(data.attacker)
  end
  dmg:SetDamage(data.damage)
  dmg:SetDamageBonus(data.damageBonus)
  dmg:SetDamageCustom(data.damageCustom)
  dmg:SetDamageForce(data.damageForce)
  dmg:SetDamagePosition(data.damagePosition)
  dmg:SetDamageType(data.damageType)
  if IsValid(data.inflictor) then
    dmg:SetInflictor(data.inflictor)
  end
  dmg:SetMaxDamage(data.maxDamage)
  dmg:SetReportedPosition(data.reportedPosition)
  return dmg
end

function util.DrG_MergeColors(ratio, max, low)
  ratio = math.Clamp(ratio, 0, 1)
  return Color(
    max.r*ratio + low.r*(1-ratio),
    max.g*ratio + low.g*(1-ratio),
    max.b*ratio + low.b*(1-ratio),
    max.a*ratio + low.a*(1-ratio)
  )
end
