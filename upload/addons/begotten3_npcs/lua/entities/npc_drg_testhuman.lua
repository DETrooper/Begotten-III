if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = "drgbase_nextbot_human" -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = "Test Human"
ENT.Category = "DrGBase"
ENT.Models = {
  "models/player/kleiner.mdl",
  "models/player/magnusson.mdl"
}

-- Relationships --
ENT.Factions = {FACTION_REBELS}

-- Movements --
ENT.UseWalkframes = true

-- Weapons --
ENT.Weapons = {
  "weapon_ar2",
  "weapon_smg1",
  "weapon_crossbow",
  "weapon_shotgun",
  "weapon_pistol",
  "weapon_357"
}
ENT.WeaponAccuracy = 0.75

if SERVER then

  -- Init/Think --

  function ENT:CustomInitialize()
    self:SetDefaultRelationship(D_HT)
    self:SetSelfModelRelationship(D_LI)
    if self:GetModel() == "models/player/kleiner.mdl" then
      self:JoinFaction("FACTION_KLEINER")
    elseif self:GetModel() == "models/player/magnusson.mdl" then
      self:JoinFaction("FACTION_MAGNUSSON")
    end
  end

end

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)
