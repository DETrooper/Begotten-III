
-- Misc --

local RANGE_MELEE = {
	["melee"] = true,
	["melee2"] = true,
	["fist"] = true,
	["knife"] = true
}
function DrGBase.IsMeleeWeapon(weapon)
	local holdType = weapon:GetHoldType()
	if RANGE_MELEE[holdType] or RANGE_MELEE[weapon.HoldType] then return true end
	return weapon.DrGBase_Melee or string.find(holdType, "melee") ~= nil
end

if SERVER then

	-- Misc --

	function DrGBase.CreateProjectile(model, binds)
		local proj = ents.Create("proj_drg_default")
		if not IsValid(proj) then return NULL end
		if istable(model) and #model > 0 then model = model[math.random(#model)] end
		if isstring(model) then proj:SetModel(model) end
		binds = binds or {}
		if isfunction(binds.Init) then proj.CustomInitialize = binds.Init end
		if isfunction(binds.Think) then proj.CustomThink = binds.Think end
		if isfunction(binds.Contact) then proj.OnContact = binds.Contact end
		if isfunction(binds.Use) then proj.Use = binds.Use end
		if isfunction(binds.DealtDamage) then proj.OnDealtDamage = binds.DealtDamage end
		if isfunction(binds.TakeDamage) then proj.OnTakeDamage = binds.TakeDamage end
		if isfunction(binds.Remove) then proj.OnRemove = binds.Remove end
		proj:Spawn()
		return proj
	end

	local TARGET_BLACKLIST = {
		["npc_bullseye"] = true,
		["npc_grenade_frag"] = true,
		["npc_tripmine"] = true,
		["npc_satchel"] = true,
		["npc_antlion_grub"] = true,
		["monster_cockroach"] = true
	}
	local TARGET_WHITELIST = {
		["replicator_melon"] = true,
		["replicator_worker"] = true,
		["replicator_queen"] = true,
		["replicator_queen_hive"] = true
	}
	function DrGBase.IsTarget(ent)
		if not IsValid(ent) then return false end
		local class = ent:GetClass()
		if ent:HasSpawnFlags(SF_NPC_TEMPLATE) then return false end
		if TARGET_BLACKLIST[class] then return false end
		if TARGET_WHITELIST[class] then return true end
		if ent.DrGBase_Target then return true end
		if ent:IsNextBot() then return true end
		if ent:IsPlayer() then return true end
		if ent:IsNPC() then return true end
		if Clockwork and ((ent:GetClass() == "prop_ragdoll" and Clockwork.entity:IsPlayerRagdoll(ent)) or ent:GetClass() == "cw_player_body") then return true end -- bgt change
		return false
	end

	function DrGBase.CanAttack(ent)
		if not IsValid(ent) then return false end
		if ent:IsPlayer() and ent:DrG_IsPossessing() then return false end
		if DrGBase.IsTarget(ent) then return true end
		local phys = ent:GetPhysicsObject()
		return IsValid(phys)
	end

	local BlindData = {}
	BlindData.__index = BlindData
	function BlindData:New()
		local blind = {}
		blind._duration = 3
		blind._attacker = NULL
		blind._inflictor = NULL
		setmetatable(blind, self)
		return blind
	end
	function BlindData:GetDuration()
		return self._duration
	end
	function BlindData:SetDuration(duration)
		if not isnumber(duration) then return end
		self._duration = math.max(0, duration)
	end
	function BlindData:ScaleDuration(scale)
		if not isnumber(scale) or scale < 0 then return end
		self:SetDuration(self:GetDuration()*scale)
	end
	function BlindData:GetAttacker()
		return self._attacker
	end
	function BlindData:SetAttacker(attacker)
		if not isentity(attacker) then return end
		self._attacker = attacker
	end
	function BlindData:GetInflictor()
		return self._inflictor
	end
	function BlindData:SetInflictor(inflictor)
		if not isentity(inflictor) then return end
		self._inflictor = inflictor
	end

	function DrGBase.Blind()
		return BlindData:New()
	end

else

	-- Misc --

	local MATERIALS = {}
	function DrGBase.Material(name, ...)
		if not MATERIALS[name] then
			local material = Material(name, ...)
			MATERIALS[name] = material
			return material
		else return MATERIALS[name] end
	end

	-- propspawn.lua effect fix --
	-- rubat fix your shit --

	local effects_Register = effects.Register
	function effects.Register(tbl, name)
		if name == "propspawn" then
			local RenderParent = tbl.RenderParent
			function tbl:RenderParent()
				if not IsValid(self) then return end
				if not IsValid(self.SpawnEffect) then self.RenderOverride = nil return end
				return RenderParent(self)
			end
		end

		return effects_Register(tbl, name)
	end

end
