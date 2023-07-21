-- Registry --

function DrGBase.AddParticles(pcf, particles)
  if not isstring(pcf) then return end
  game.AddParticles("particles/"..pcf)
  if not istable(particles) then particles = {particles} end
  for i, particle in ipairs(particles) do
    if not isstring(particle) then continue end
    PrecacheParticleSystem(particle)
  end
end

-- Premade particles --

DrGBase.AddParticles("drgbase.pcf", {
  "drg_plasma_ball",
  "drg_smokescreen"
})

-- Vanilla particles --

PrecacheParticleSystem("blood_impact_red_01_goop")
PrecacheParticleSystem("blood_impact_yellow_01")
PrecacheParticleSystem("blood_impact_green_01")
PrecacheParticleSystem("blood_impact_antlion_01")
PrecacheParticleSystem("blood_impact_zombie_01")
PrecacheParticleSystem("blood_impact_antlion_worker_01")

-- Create particles --

if SERVER then

  function DrGBase.ParticleEffect(effect, data)
    if not isstring(effect) then return end
    if not istable(data) then return end
    local ent = ents.Create("info_particle_system")
    if not IsValid(ent) then return NULL end
    ent:SetKeyValue("effect_name", effect)
    ent:SetName("drg_info_particle_system_"..ent:GetCreationID())
    if isvector(data.pos) then ent:SetPos(data.pos) end
    if isangle(data.ang) then ent:SetAngles(data.ang) end
    if data.active ~= false then ent:SetKeyValue("start_active", "1") end
    for i, subdata in ipairs(data.cpoints or {}) do
      local sub = DrGBase.ParticleEffect(effect, subdata)
      if not IsValid(sub) then continue end
      ent:SetKeyValue("cpoint"..tostring(i), sub:GetName())
      ent:DeleteOnRemove(sub)
    end
    ent:Spawn()
    ent:Activate()
    if isentity(data.parent) and IsValid(data.parent) then
      if isstring(data.attachment) then
        ent:SetParent(data.parent)
        if data.keepoffset then
          ent:Fire("SetParentAttachmentMaintainOffset", data.attachment)
        else ent:Fire("SetParentAttachment", data.attachment) end
      elseif not data.keepoffset then
        ent:SetPos(data.parent:GetPos())
        ent:SetParent(data.parent)
      else ent:SetParent(data.parent) end
    end
    return ent
  end

  function DrGBase.SimpleParticleEffect(effect, arg1, arg2)
    if isentity(arg1) and IsValid(arg1) then
      return DrGBase.ParticleEffect(effect, {
        parent = arg1, attachment = arg2
      })
    elseif isvector(arg1) then
      return DrGBase.ParticleEffect(effect, {
        pos = arg1, ang = arg2
      })
    end
  end

end
