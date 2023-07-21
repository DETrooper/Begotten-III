ENT.Base = "base_entity"
ENT.Type = "anim"
ENT.IsDrGEntity = true

if SERVER then AddCSLuaFile() end
DrGBase.IncludeFile("drgbase/entity_helpers.lua")

local entMETA = FindMetaTable("Entity")

local old_tostring = entMETA.__tostring
function entMETA:__tostring()
  if self.IsDrGProjectile then
    return "Projectile ["..self:EntIndex().."]["..self:GetClass().."]"
  elseif self.IsDrGSpawner then
    return "Spawner ["..self:EntIndex().."]["..self:GetClass().."]"
  else return old_tostring(self) end
end
