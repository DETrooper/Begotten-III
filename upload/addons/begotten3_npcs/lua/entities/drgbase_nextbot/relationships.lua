
-- Convars --

local DebugRelationship = CreateConVar("drgbase_debug_relationships", "0")

-- Getters/setters --

function ENT:IsFrightening()
  return self:GetNW2Bool("DrGBaseFrightening")
end

function ENT:Team()
  return self:GetNW2Int("DrGBaseTeam", 0)
end

-- Helpers --

local function EnumToString(disp)
  if disp == D_LI then return "D_LI"
  elseif disp == D_HT then return "D_HT"
  elseif disp == D_FR then return "D_FR"
  elseif disp == D_NU then return "D_NU"
  else return "D_ER" end
end

local CACHED_DISPS = {
  [D_LI] = true,
  [D_HT] = true,
  [D_FR] = true
}
local function IsCachedDisp(disp)
  return CACHED_DISPS[disp] or false
end
local function IsValidDisp(disp)
  return IsCachedDisp(disp) or disp == D_NU
end

local DEFAULT_DISP = D_NU
local DEFAULT_PRIO = 1
local DEFAULT_REL = {disp = DEFAULT_DISP, prio = DEFAULT_PRIO}
function ENT:_InitRelationships()
  if CLIENT then return end
  self._DrGBaseRelationships = table.DrG_Default({}, DEFAULT_DISP)
  self._DrGBaseRelPriorities = table.DrG_Default({}, DEFAULT_PRIO)
  self._DrGBaseRelationshipCaches = {[D_LI] = {}, [D_HT] = {}, [D_FR] = {}}
  self._DrGBaseRelationshipCachesSpotted = {[D_LI] = {}, [D_HT] = {}, [D_FR] = {}}
  self._DrGBaseIgnoredEntities = {}
  if IsValidDisp(self.DefaultRelationship) then
    self._DrGBaseDefaultRelationship = self.DefaultRelationship
  else self._DrGBaseDefaultRelationship = DEFAULT_DISP end
  self._DrGBaseRelationshipDefiners = {
    ["entity"] = table.DrG_Default({}, DEFAULT_REL),
    ["class"] = table.DrG_Default({}, DEFAULT_REL),
    ["model"] = table.DrG_Default({}, DEFAULT_REL),
    ["faction"] = table.DrG_Default({}, DEFAULT_REL)
  }
  self:SetNW2Bool("DrGBaseFrightening", self.Frightening)
  self._DrGBaseFactions = {}
  self:JoinFactions(self.Factions)
end

if SERVER then
  util.AddNetworkString("DrGBaseNextbotPlayerRelationship")

  -- Util --

  local DISP_PRIORITIES = {
    [D_LI] = 4,
    [D_FR] = 3,
    [D_HT] = 2,
    [D_NU] = 1,
    [D_ER] = 0
  }
  local function HighestRelationship(relationships)
    local relationship = table.DrG_Fetch(relationships, function(rel1, rel2)
      if rel1.prio > rel2.prio then
        return true
      elseif rel1.prio == rel2.prio then
        if DISP_PRIORITIES[rel1.disp] > DISP_PRIORITIES[rel2.disp] then
          return true
        else return false end
      else return false end
    end)
    return relationship
  end

  local DEFAULT_FACTIONS = {
    ["npc_crow"] = FACTION_ANIMALS,
    ["npc_monk"] = FACTION_REBELS,
    ["npc_pigeon"] = FACTION_ANIMALS,
    ["npc_seagull"] = FACTION_ANIMALS,
    ["npc_combine_camera"] = FACTION_COMBINE,
    ["npc_turret_ceiling"] = FACTION_COMBINE,
    ["npc_cscanner"] = FACTION_COMBINE,
    ["npc_combinedropship"] = FACTION_COMBINE,
    ["npc_combinegunship"] = FACTION_COMBINE,
    ["npc_combine_s"] = FACTION_COMBINE,
    ["npc_hunter"] = FACTION_COMBINE,
    ["npc_helicopter"] = FACTION_COMBINE,
    ["npc_manhack"] = FACTION_COMBINE,
    ["npc_metropolice"] = FACTION_COMBINE,
    ["npc_rollermine"] = FACTION_COMBINE,
    ["npc_clawscanner"] = FACTION_COMBINE,
    ["npc_stalker"] = FACTION_COMBINE,
    ["npc_strider"] = FACTION_COMBINE,
    ["npc_turret_floor"] = FACTION_COMBINE,
    ["npc_alyx"] = FACTION_REBELS,
    ["npc_barney"] = FACTION_REBELS,
    ["npc_citizen"] = FACTION_REBELS,
    ["npc_dog"] = FACTION_REBELS,
    ["npc_magnusson"] = FACTION_REBELS,
    ["npc_kleiner"] = FACTION_REBELS,
    ["npc_mossman"] = FACTION_REBELS,
    ["npc_eli"] = FACTION_REBELS,
    ["npc_fisherman"] = FACTION_REBELS,
    ["npc_gman"] = FACTION_GMAN,
    ["npc_odessa"] = FACTION_REBELS,
    ["npc_vortigaunt"] = FACTION_REBELS,
    ["npc_breen"] = FACTION_COMBINE,
    ["npc_antlion"] = FACTION_ANTLIONS,
    ["npc_antlion_grub"] = FACTION_ANTLIONS,
    ["npc_antlionguard"] = FACTION_ANTLIONS,
    ["npc_antlionguardian"] = FACTION_ANTLIONS,
    ["npc_antlion_worker"] = FACTION_ANTLIONS,
    ["npc_barnacle"] = FACTION_BARNACLES,
    ["npc_headcrab_fast"] = FACTION_ZOMBIES,
    ["npc_fastzombie"] = FACTION_ZOMBIES,
    ["npc_fastzombie_torso"] = FACTION_ZOMBIES,
    ["npc_headcrab"] = FACTION_ZOMBIES,
    ["npc_headcrab_black"] = FACTION_ZOMBIES,
    ["npc_poisonzombie"] = FACTION_ZOMBIES,
    ["npc_zombie"] = FACTION_ZOMBIES,
    ["npc_zombie_torso"] = FACTION_ZOMBIES,
    ["npc_zombine"] = FACTION_ZOMBIES,
    ["monster_alien_grunt"] = FACTION_XEN_ARMY,
    ["monster_alien_slave"] = FACTION_XEN_ARMY,
    ["monster_human_assassin"] = FACTION_HECU,
    ["monster_babycrab"] = FACTION_ZOMBIES,
    ["monster_bullchicken"] = FACTION_XEN_WILDLIFE,
    ["monster_cockroach"] = FACTION_ANIMALS,
    ["monster_alien_controller"] = FACTION_XEN_ARMY,
    ["monster_gargantua"] = FACTION_XEN_ARMY,
    ["monster_bigmomma"] = FACTION_ZOMBIES,
    ["monster_human_grunt"] = FACTION_HECU,
    ["monster_headcrab"] = FACTION_ZOMBIES,
    ["monster_houndeye"] = FACTION_XEN_WILDLIFE,
    ["monster_nihilanth"] = FACTION_XEN_ARMY,
    ["monster_scientist"] = FACTION_REBELS,
    ["monster_barney"] = FACTION_REBELS,
    ["monster_snark"] = FACTION_XEN_WILDLIFE,
    ["monster_tentacle"] = FACTION_XEN_WILDLIFE,
    ["monster_zombie"] = FACTION_ZOMBIES,
    ["npc_apc_dropship"] = FACTION_COMBINE,
    ["npc_elite_overwatch_dropship"] = FACTION_COMBINE,
    ["npc_civil_protection_tier1_dropship"] = FACTION_COMBINE,
    ["npc_civil_protection_tier2_dropship"] = FACTION_COMBINE,
    ["npc_shotgunner_dropship"] = FACTION_COMBINE,
    ["npc_overwatch_squad_tier1_dropship"] = FACTION_COMBINE,
    ["npc_overwatch_squad_tier2_dropship"] = FACTION_COMBINE,
    ["npc_overwatch_squad_tier3_dropship"] = FACTION_COMBINE,
    ["npc_random_combine_dropship"] = FACTION_COMBINE,
    ["npc_strider_dropship"] = FACTION_COMBINE
  }

  -- Getters/setters --

  function ENT:GetRelationship(ent, absolute)
    if not IsValid(ent) then return D_ER end
    if self == ent then return D_ER end
    local disp = self._DrGBaseRelationships[ent]
    if not absolute and self:IsIgnored(ent) then
      return D_NU
    else return disp or DEFAULT_DISP end
  end
  function ENT:GetPriority(ent)
    if not IsValid(ent) then return -1 end
    if self == ent then return -1 end
    return self._DrGBaseRelPriorities[ent] or DEFAULT_PRIO
  end
  function ENT:IsAlly(ent)
    return self:GetRelationship(ent) == D_LI
  end
  function ENT:IsEnemy(ent)
    return self:GetRelationship(ent) == D_HT
  end
  function ENT:IsAfraidOf(ent)
    return self:GetRelationship(ent) == D_FR
  end
  function ENT:IsHostile(ent)
    local disp = self:GetRelationship(ent)
    return disp == D_HT or disp == D_FR
  end
  function ENT:IsNeutral(ent)
    return self:GetRelationship(ent) == D_NU
  end

  function ENT:_SetRelationship(ent, disp)
    if not IsValid(ent) then return end
    if not IsValidDisp(disp) then return end
    local curr = self:GetRelationship(ent, true)
    if (cur ~= disp or disp == D_HT) and
    ent:IsNPC() then self:_UpdateNPCRelationship(ent, disp) end
    if curr == disp then return end
    if IsCachedDisp(disp) then
      self._DrGBaseRelationshipCaches[D_LI][ent] = nil
      self._DrGBaseRelationshipCaches[D_HT][ent] = nil
      self._DrGBaseRelationshipCaches[D_FR][ent] = nil
      self._DrGBaseRelationshipCaches[disp][ent] = true
      self._DrGBaseRelationshipCachesSpotted[D_LI][ent] = nil
      self._DrGBaseRelationshipCachesSpotted[D_HT][ent] = nil
      self._DrGBaseRelationshipCachesSpotted[D_FR][ent] = nil
      if self:HasSpotted(ent, true) then
        self._DrGBaseRelationshipCachesSpotted[disp][ent] = true
      end
      self._DrGBaseRelationships[ent] = disp
      ent:CallOnRemove("DrGBaseRemoveFromDrGNextbot"..self:GetCreationID().."RelationshipCache", function()
        if IsValid(self) then self._DrGBaseRelationshipCaches[disp][ent] = nil end
      end)
    elseif disp == D_NU then
      self._DrGBaseRelationshipCaches[D_LI][ent] = nil
      self._DrGBaseRelationshipCaches[D_HT][ent] = nil
      self._DrGBaseRelationshipCaches[D_FR][ent] = nil
      self._DrGBaseRelationshipCachesSpotted[D_LI][ent] = nil
      self._DrGBaseRelationshipCachesSpotted[D_HT][ent] = nil
      self._DrGBaseRelationshipCachesSpotted[D_FR][ent] = nil
      self._DrGBaseRelationships[ent] = DEFAULT_DISP
    end
    if self:GetEnemy() == ent and
    disp ~= D_HT and disp ~= D_FR then
      self:UpdateEnemy()
    end
    self:OnRelationshipChange(ent, curr, disp)
    if DebugRelationship:GetBool() then
      DrGBase.Print(tostring(self)..": ".."'"..tostring(ent).."' "..EnumToString(curr).." => "..EnumToString(disp)..".")
    end
    if ent:IsPlayer() then
      net.Start("DrGBaseNextbotPlayerRelationship")
      net.WriteEntity(self)
      net.WriteInt(disp, 4)
      net.Send(ent)
    end
  end
  function ENT:_SetPriority(ent, prio)
    if not IsValid(ent) then return end
    if not isnumber(prio) then return end
    self._DrGBaseRelPriorities[ent] = prio
  end

  net.DrG_DefineCallback("DrGBaseGetRelationship", function(nextbot, ent)
    if not IsValid(nextbot) or not IsValid(ent) then return D_ER, -1
    else return nextbot:GetRelationship(ent) end
  end)

  local NPC_STATES_IGNORED = {
    [NPC_STATE_PLAYDEAD] = true,
    [NPC_STATE_DEAD] = true
  }
  function ENT:IsIgnored(ent)
    if ent:IsPlayer() and not ent:Alive() then return true end
    if ent:IsPlayer() and GetConVar("ai_ignoreplayers"):GetBool() then return true end
    --if ent:IsFlagSet(FL_NOTARGET) then return true end
    if ent.IsVJBaseSNPC and ent.VJ_NoTarget then return true end
    if ent.CPTBase_NPC and ent.UseNotarget then return true end
    if ent:IsNPC() and NPC_STATES_IGNORED[ent:GetNPCState()] then return true end
    if (ent:IsPlayer() or ent:IsNPC() or ent:IsNextBot()) and ent:Health() <= 0 then return true end
    if ent.IsDrGNextbot and (ent:IsDown() or ent:IsDead()) then return true end
	
	if Clockwork then
		if ent:GetClass() == "prop_ragdoll" and Clockwork.entity:IsPlayerRagdoll(ent) and ent:GetNWEntity("Player") ~= game.GetWorld() then
			local ragdollPlayer = Clockwork.entity:GetPlayer(ent);
			if IsValid(ragdollPlayer) then
				if !ragdollPlayer:Alive() or !ragdollPlayer:IsRagdolled() then
					return true;
				end
			end
		elseif ent:IsPlayer() then
			if !ent:HasInitialized() or (ent.cwObserverMode and ent:GetCharacterData("IsObserverTarget") ~= true) then
				return true;
			end
		end
	end
	
    if self:ShouldIgnore(ent) then return true end
    return self._DrGBaseIgnoredEntities[ent] or false
  end
  function ENT:SetIgnored(ent, bool)
    self._DrGBaseIgnoredEntities[ent] = tobool(bool)
  end

  net.DrG_DefineCallback("DrGBaseIsIgnored", function(nextbot, ent)
    if not IsValid(nextbot) or not IsValid(ent) then return false
    else return nextbot:IsIgnored(ent) end
  end)

  function ENT:SetFrightening(frightening)
    local old = self:IsFrightening()
    if old == tobool(frightening) then return end
    self:SetNW2Bool("DrGBaseFrightening", frightening)
    if old ~= self:IsFrightening() then
      for i, ent in ipairs(ents.GetAll()) do
        if not ent:IsNPC() then continue end
        self:UpdateRelationshipWith(ent)
      end
    end
  end

  -- Functions --

  function ENT:GetDefaultRelationship()
    return self._DrGBaseDefaultRelationship, DEFAULT_PRIO
  end
  function ENT:SetDefaultRelationship(disp)
    self._DrGBaseDefaultRelationship = disp
    self:UpdateRelationships()
  end

  function ENT:_GetRelationshipDefiner(name, id)
    local rel = self._DrGBaseRelationshipDefiners[name][id]
    return rel.disp, rel.prio
  end
  function ENT:_SetRelationshipDefiner(name, id, disp, prio)
    if not IsValidDisp(disp) then return end
    self._DrGBaseRelationshipDefiners[name][id] = {
      disp = disp, prio = prio or DEFAULT_PRIO
    }
  end
  function ENT:_AddRelationshipDefiner(name, id, disp, prio)
    prio = prio or DEFAULT_PRIO
    local curr = self._DrGBaseRelationshipDefiners[name][id]
    if curr.prio > prio then return end
    self:_SetRelationshipDefiner(name, id, disp, prio)
  end

  -- Entity
  function ENT:GetEntityRelationship(ent)
    if not IsValid(ent) then return D_ER, -1 end
    return self:_GetRelationshipDefiner("entity", ent)
  end
  function ENT:SetEntityRelationship(ent, disp, prio)
    if not IsValid(ent) then return end
    local res = self:_SetRelationshipDefiner("entity", ent, disp, prio)
    self:UpdateRelationshipWith(ent)
    return res
  end
  function ENT:AddEntityRelationship(ent, disp, prio)
    if not IsValid(ent) then return end
    local res = self:_AddRelationshipDefiner("entity", ent, disp, prio)
    self:UpdateRelationshipWith(ent)
    return res
  end

  -- Class
  function ENT:GetClassRelationship(class)
    if not isstring(class) then return D_ER, -1 end
    class = string.lower(class)
    return self:_GetRelationshipDefiner("class", class)
  end
  function ENT:SetClassRelationship(class, disp, prio)
    if not isstring(class) then return end
    class = string.lower(class)
    local res = self:_SetRelationshipDefiner("class", class, disp, prio)
    self:UpdateRelationships()
    return res
  end
  function ENT:AddClassRelationship(class, disp, prio)
    if not isstring(class) then return end
    class = string.lower(class)
    local res = self:_AddRelationshipDefiner("class", class, disp, prio)
    self:UpdateRelationships()
    return res
  end

  function ENT:GetSelfClassRelationship()
    return self:GetClassRelationship(self:GetClass())
  end
  function ENT:SetSelfClassRelationship(disp, prio)
    return self:SetClassRelationship(self:GetClass(), disp, prio)
  end
  function ENT:AddSelfClassRelationship(disp, prio)
    return self:AddClassRelationship(self:GetClass(), disp, prio)
  end

  function ENT:GetPlayersRelationship()
    return self:GetClassRelationship("player")
  end
  function ENT:SetPlayersRelationship(disp, prio)
    return self:SetClassRelationship("player", disp, prio)
  end
  function ENT:AddPlayersRelationship(disp, prio)
    return self:AddClassRelationship("player", disp, prio)
  end

  -- Models
  function ENT:GetModelRelationship(model)
    if not isstring(model) then return D_ER, -1 end
    model = string.lower(model)
    return self:_GetRelationshipDefiner("model", model)
  end
  function ENT:SetModelRelationship(model, disp, prio)
    if not isstring(model) then return end
    model = string.lower(model)
    local res = self:_SetRelationshipDefiner("model", model, disp, prio)
    self:UpdateRelationships()
    return res
  end
  function ENT:AddModelRelationship(model, disp, prio)
    if not isstring(model) then return end
    model = string.lower(model)
    local res = self:_AddRelationshipDefiner("model", model, disp, prio)
    self:UpdateRelationships()
    return res
  end

  function ENT:GetSelfModelRelationship()
    return self:GetModelRelationship(self:GetModel())
  end
  function ENT:SetSelfModelRelationship(disp, prio)
    return self:SetModelRelationship(self:GetModel(), disp, prio)
  end
  function ENT:AddSelfModelRelationship(disp, prio)
    return self:AddModelRelationship(self:GetModel(), disp, prio)
  end

  -- Factions
  function ENT:GetFactionRelationship(faction)
    if not isstring(faction) then return D_ER, -1 end
    faction = string.upper(faction)
    return self:_GetRelationshipDefiner("faction", faction)
  end
  function ENT:SetFactionRelationship(faction, disp, prio)
    if not isstring(faction) then return end
    faction = string.upper(faction)
    local res = self:_SetRelationshipDefiner("faction", faction, disp, prio)
    self:UpdateRelationships()
    return res
  end
  function ENT:AddFactionRelationship(faction, disp, prio)
    if not isstring(faction) then return end
    faction = string.upper(faction)
    local res = self:_AddRelationshipDefiner("faction", faction, disp, prio)
    self:UpdateRelationships()
    return res
  end

  function ENT:JoinFaction(faction)
    if self:IsInFaction(faction) then return end
    self._DrGBaseFactions[string.upper(faction)] = true
    self:AddFactionRelationship(faction, D_LI)
    for i, nextbot in ipairs(DrGBase.GetNextbots()) do
      if nextbot == self then continue end
      nextbot:UpdateRelationshipWith(self)
    end
  end
  function ENT:JoinFactions(factions)
    for i, faction in ipairs(factions) do self:JoinFaction(faction) end
  end

  function ENT:LeaveFaction(faction)
    if not self:IsInFaction(faction) then return end
    self._DrGBaseFactions[string.upper(faction)] = nil
    local disp, prio = self:GetFactionRelationship(faction)
    if disp == D_LI and prio == DEFAULT_PRIO then
      self:SetFactionRelationship(faction, D_NU)
    end
    for i, nextbot in ipairs(DrGBase.GetNextbots()) do
      if nextbot == self then continue end
      nextbot:UpdateRelationshipWith(self)
    end
  end
  function ENT:LeaveFactions(factions)
    for i, faction in ipairs(factions) do self:LeaveFaction(faction) end
  end
  function ENT:LeaveAllFactions()
    return self:LeaveFactions(self:GetFactions())
  end

  function ENT:IsInFaction(faction)
    return self._DrGBaseFactions[string.upper(faction)] or false
  end
  function ENT:GetFactions()
    local factions = {}
    for faction, joined in pairs(self._DrGBaseFactions) do
      if not joined then return end
      table.insert(factions, faction)
    end
    return factions
  end

  -- Teams
  function ENT:SetTeam(team)
    local current = self:Team()
    self:SetNW2Int("DrGBaseTeam", team)
    if team ~= current then self:UpdateRelationships() end
  end

  -- Update
  function ENT:UpdateRelationships()
    if not self._DrGBaseRelationshipReady then return end
    for i, ent in ipairs(ents.GetAll()) do
      self:UpdateRelationshipWith(ent)
    end
  end
  function ENT:UpdateRelationshipWith(ent)
    if not self._DrGBaseRelationshipReady then return end
    if not IsValid(ent) then return end
    if ent == self then return end
    if (ent:IsPlayer() or ent.IsDrGNextbot) and
    ent:Team() == self:Team() and self:Team() ~= 0 then
      self:_SetRelationship(ent, D_LI)
      self:_SetPriority(ent, DEFAULT_PRIO)
    else
      local default, defprio
      if not DrGBase.IsTarget(ent) then
        default = DEFAULT_DISP
        defprio = DEFAULT_PRIO
      else default, defprio = self:GetDefaultRelationship() end
      local entdisp, entprio = self:GetEntityRelationship(ent)
      local classdisp, classprio = self:GetClassRelationship(ent:GetClass())
      local modeldisp, modelprio = self:GetModelRelationship(ent:GetModel())
      local customdisp, customprio = self:CustomRelationship(ent)
      local relationships = {HighestRelationship({
        {disp = default, prio = defprio}, {disp = entdisp, prio = entprio},
        {disp = classdisp, prio = classprio}, {disp = modeldisp, prio = modelprio},
        {disp = customdisp or DEFAULT_DISP, prio = customprio or DEFAULT_PRIO}
      })}
      for faction, relationship in pairs(self._DrGBaseRelationshipDefiners["faction"]) do
        if relationship.disp == D_ER or relationship.prio < relationships[1].prio then continue end
        if ent:IsPlayer() then
          if ent:DrG_IsInFaction(faction) then table.insert(relationships, relationship) end
        elseif ent.IsDrGNextbot then
          if ent:IsInFaction(faction) then table.insert(relationships, relationship) end
        elseif ent:DrG_IsSanic() then
          if faction == FACTION_SANIC then table.insert(relationships, relationship) end
        elseif ent.IsVJBaseSNPC then
          for i, class in ipairs(ent.VJ_NPC_Class) do
            if string.upper(class) ~= faction then continue end
            table.insert(relationships, relationship)
            break
          end
        elseif ent.CPTBase_NPC or ent.IV04NextBot then
          if string.upper(ent.Faction) == faction then table.insert(relationships, relationship) end
        else
          local def = DEFAULT_FACTIONS[ent:GetClass()]
          if def == faction then table.insert(relationships, relationship) end
        end
      end
      local relationship = HighestRelationship(relationships)
      self:_SetRelationship(ent, relationship.disp)
      self:_SetPriority(ent, relationship.prio)
    end
  end

  -- Iterators
  local function NextCachedEntity(self, cache, previous, spotted)
    local ent = next(cache, previous)
    if ent == nil then return nil
    elseif not IsValid(ent) or
    self:GetRelationship(ent) == D_NU or
    (spotted and not self:HasSpotted(ent)) then
      return NextCachedEntity(self, cache, ent, spotted)
    else return ent end
  end
  local function NextNeutralEntity(self, entities, j, spotted)
    local i = j+1
    local ent = entities[i]
    if ent == nil then return i, nil
    elseif not IsValid(ent) or
    self:GetRelationship(ent) ~= D_NU or
    (spotted and not self:HasSpotted(ent)) then
      return NextNeutralEntity(self, entities, i, spotted)
    else return i, ent end
  end
  function ENT:EntityIterator(disp, spotted)
    if istable(disp) then
      local i = 1
      local iterators = {}
      for i, dis in ipairs(disp) do
        table.insert(iterators, self:EntityIterator(dis, spotted))
      end
      return function(inv, previous)
        local ent = iterators[i](nil, previous)
        if IsValid(ent) then return ent end
        for j = i+1, #iterators do
          i = j
          ent = iterators[i](nil, nil)
          if IsValid(ent) then return ent end
        end
      end
    elseif IsCachedDisp(disp) then
      local cache = (spotted and not self:IsOmniscient()) and self._DrGBaseRelationshipCachesSpotted[disp] or self._DrGBaseRelationshipCaches[disp]
      return function(inv, previous)
        return NextCachedEntity(self, cache, previous, spotted)
      end
    elseif disp == D_NU then
      local i = 0
      local entities = ents.GetAll()
      return function()
        local j, ent = NextNeutralEntity(self, entities, i, spotted)
        i = j
        return ent
      end
    else return function() end end
  end
  function ENT:AllyIterator(spotted)
    return self:EntityIterator(D_LI, spotted)
  end
  function ENT:EnemyIterator(spotted)
    return self:EntityIterator(D_HT, spotted)
  end
  function ENT:AfraidOfIterator(spotted)
    return self:EntityIterator(D_FR, spotted)
  end
  function ENT:HostileIterator(spotted)
    return self:EntityIterator({D_HT, D_FR}, spotted)
  end
  function ENT:NeutralIterator(spotted)
    return self:EntityIterator(D_NU, spotted)
  end

  -- Get entities
  function ENT:GetEntities(disp, spotted)
    local entities = {}
    for ent in self:EntityIterator(disp, spotted) do
      table.insert(entities, ent)
    end
    return entities
  end
  function ENT:GetAllies(spotted)
    return self:GetEntities(D_LI, spotted)
  end
  function ENT:GetEnemies(spotted)
    return self:GetEntities(D_HT, spotted)
  end
  function ENT:GetAfraidOf(spotted)
    return self:GetEntities(D_FR, spotted)
  end
  function ENT:GetHostiles(spotted)
    return self:GetEntities({D_HT, D_FR}, spotted)
  end
  function ENT:GetNeutrals(spotted)
    return self:GetEntities(D_NU, spotted)
  end

  -- Number of entities left
  function ENT:EntitiesLeft(disp, spotted)
    return #self:GetEntities(disp, spotted)
  end
  function ENT:AlliesLeft(spotted)
    return self:EntitiesLeft(D_LI, spotted)
  end
  function ENT:EnemiesLeft(spotted)
    return self:EntitiesLeft(D_HT, spotted)
  end
  function ENT:AfraidOfLeft(spotted)
    return self:Entitiesleft(D_FR, spotted)
  end
  function ENT:HostilesLeft(spotted)
    return self:Entitiesleft({D_HT, D_FR}, spotted)
  end
  function ENT:NeutralsLeft(spotted)
    return self:EntitiesLeft(D_NU, spotted)
  end

  -- Get closest entity
  function ENT:GetClosestEntity(disp, spotted)
    local closest = NULL
    for ent in self:EntityIterator(disp, spotted) do
      if not IsValid(closest) or
      self:GetRangeSquaredTo(ent) < self:GetRangeSquaredTo(closest) then
        closest = ent
      end
    end
    return closest
  end
  function ENT:GetClosestAlly(spotted)
    return self:GetClosestEntity(D_LI, spotted)
  end
  function ENT:GetClosestEnemy(spotted)
    return self:GetClosestEntity(D_HT, spotted)
  end
  function ENT:GetClosestAfraidOf(spotted)
    return self:GetClosestEntity(D_FR, spotted)
  end
  function ENT:GetClosestHostile(spotted)
    return self:GetClosestEntity({D_HT, D_FR}, spotted)
  end
  function ENT:GetClosestNeutral(spotted)
    return self:GetClosestEntity(D_NU, spotted)
  end

  -- Hooks --

  function ENT:CustomRelationship() end
  function ENT:ShouldIgnore() end
  function ENT:OnRelationshipChange() end

  -- Handlers --

  function ENT:_UpdateNPCRelationship(ent, relationship)
    if not IsValid(ent) or not ent:IsNPC() then return end
    if relationship == D_FR then
      ent:DrG_SetRelationship(self, D_HT)
    elseif relationship == D_HT and self:IsFrightening() then
      ent:DrG_SetRelationship(self, D_FR)
    else ent:DrG_SetRelationship(self, relationship) end
  end

  local function CPTBaseValidTarget(ent, nextbot)
    local disp = ent:Disposition(nextbot)
    if disp ~= D_HT and disp ~= D_FR then return false end
    if nextbot:IsFlagSet(FL_NOTARGET) then return false end
    if nextbot:IsDead() or nextbot:IsDown() then return false end
    return true
  end
  local function CPTBasePickClosestEnemy(ent, nextbots)
    local enemy
    for i, nextbot in ipairs(nextbots) do
      if not ent:Visible(nextbot) then continue end
      if not ent:CanSeeEntities(nextbot) then continue end
      if not ent:FindInCone(nextbot, ent.ViewAngle) then continue end
      if not ent:CanSetAsEnemy(nextbot) then continue end
      if not CPTBaseValidTarget(ent, nextbot) then continue end
      if not IsValid(enemy) or ent:GetPos():DistToSqr(nextbot:GetPos()) < ent:GetPos():DistToSqr(enemy:GetPos()) then
        enemy = nextbot
      end
    end
    return enemy
  end
  hook.Add("OnEntityCreated", "DrGBaseNextbotRelationshipsInit", function(ent)
    ent:DrG_Timer(0, function()
      if ent.IsVJBaseSNPC and isfunction(ent.DoHardEntityCheck) then
        local old_DoHardEntityCheck = ent.DoHardEntityCheck
        ent.DoHardEntityCheck = function(ent, tbl)
          local entities = old_DoHardEntityCheck(ent, tbl)
          return table.Merge(entities, DrGBase.GetNextbots())
        end
      elseif ent.CPTBase_NPC then
        local old_LocateEnemies = ent.LocateEnemies
        ent.LocateEnemies = function(ent)
          local enemy = old_LocateEnemies(ent)
          local nextbots = DrGBase.GetNextbots()
          if #nextbots == 0 then return enemy end
          local nextbot = CPTBasePickClosestEnemy(ent, nextbots)
          if not IsValid(nextbot) then return enemy
          elseif IsValid(enemy) and
          ent:GetPos():DistToSqr(enemy:GetPos()) < ent:GetPos():DistToSqr(nextbot:GetPos()) then
            return enemy
          elseif ent:GetPos():DistToSqr(nextbot:GetPos()) <= ent.FindEntitiesDistance^2 then
            return nextbot
          end
        end
        local old_FindAllEnemies = ent.FindAllEnemies
        ent.FindAllEnemies = function(ent)
          local enemy = old_FindAllEnemies(ent)
          local nextbots = DrGBase.GetNextbots()
          if #nextbots == 0 then return enemy end
          local nextbot = table.DrG_Fetch(nextbots, function(nb1, nb2)
            if not CPTBaseValidTarget(ent, nb1) and CPTBaseValidTarget(ent, nb2) then return false end
            if CPTBaseValidTarget(ent, nb1) and not CPTBaseValidTarget(ent, nb2) then return true end
            return ent:GetPos():DistToSqr(nb1:GetPos()) < ent:GetPos():DistToSqr(nb2:GetPos())
          end)
          if not CPTBaseValidTarget(ent, nextbot) then return enemy
          elseif IsValid(enemy) and
          ent:GetPos():DistToSqr(enemy:GetPos()) < ent:GetPos():DistToSqr(nextbot:GetPos()) then
            return enemy
          else return nextbot end
        end
      end
      for i, nextbot in ipairs(DrGBase.GetNextbots()) do
        if ent == nextbot then continue end
        nextbot:UpdateRelationshipWith(ent)
      end
    end)
  end)

  -- Aliases --

  function ENT:Disposition(ent)
    return self:GetRelationship(ent)
  end
  function ENT:AddRelationship(str)
    local split = string.Explode("[%s]+", str, true)
    if #split ~= 3 then return end
    local class = split[1]
    local relationship = split[2]
    if relationship == "D_ER" then relationship = D_ER
    elseif relationship == "D_HT" then relationship = D_HT
    elseif relationship == "D_FR" then relationship = D_FR
    elseif relationship == "D_LI" then relationship = D_LI
    elseif relationship == "D_NU" then relationship = D_NU
    else return end
    local val = tonumber(split[3])
    if val ~= val then return end
    self:AddClassRelationship(class, relationship, val)
  end

else

  -- Getters/setters --

  function ENT:LocalPlayerRelationship()
    return self._DrGBaseLocalPlayerRelationship or DEFAULT_DISP
  end
  net.Receive("DrGBaseNextbotPlayerRelationship", function()
    local nextbot = net.ReadEntity()
    local disp = net.ReadInt(4)
    if IsValid(nextbot) then
      nextbot._DrGBaseLocalPlayerRelationship = disp
    end
  end)

  function ENT:GetRelationship(ent, callback)
    if IsValid(ent) then
      return self:NetCallback("DrGBaseGetRelationship", callback, ent)
    elseif isfunction(callback) then callback(self, D_ER) end
  end
  function ENT:IsAlly(ent, callback)
    return self:GetRelationship(ent, function(self, disp)
      callback(self, disp == D_LI)
    end)
  end
  function ENT:IsEnemy(ent, callback)
    return self:GetRelationship(ent, function(self, disp)
      callback(self, disp == D_HT)
    end)
  end
  function ENT:IsAfraidOf(ent, callback)
    return self:GetRelationship(ent, function(self, disp)
      callback(self, disp == D_FR)
    end)
  end
  function ENT:IsHostile(ent, callback)
    return self:GetRelationship(ent, function(self, disp)
      callback(self, disp == D_HT or disp == D_FR)
    end)
  end
  function ENT:IsNeutral(ent, callback)
    return self:GetRelationship(ent, function(self, disp)
      callback(self, disp == D_NU)
    end)
  end

  function ENT:IsIgnored(ent, callback)
    if IsValid(ent) then
      return self:NetCallback("DrGBaseIsIgnored", callback, ent)
    elseif isfunction(callback) then callback(self, false) end
  end

  -- Functions --

  -- Hooks --

  -- Handlers --

end
