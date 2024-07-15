AddCSLuaFile()
SWEP.PrintName = "Possessor"
SWEP.Category = "DrGBase"
SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Primary.Ammo = ""
SWEP.Secondary.Ammo = ""
SWEP.WorldModel = ""
SWEP.ViewModel = "models/weapons/v_bugbait.mdl"
SWEP.DrawAmmo = false
SWEP.AutoSwitchTo = false
SWEP.Slot = 5

local function CanPossess(ent)
	return ent.IsDrGNextbot and
	GetConVar("drgbase_possession_enable"):GetBool() and
	ent.PossessionPrompt and ent:IsPossessionEnabled()
end

function SWEP:Initialize()
	self:SetHoldType("magic")
end
function SWEP:PrimaryAttack()
	if CLIENT then return end
	local owner = self:GetOwner()
	if not IsValid(owner) then return end
	if not owner:IsPlayer() then return end
	local tr = owner:GetEyeTraceNoCursor()
	if IsValid(tr.Entity) and CanPossess(tr.Entity) then
		local possess = tr.Entity:Possess(owner)
		if possess == "ok" then
			net.Start("DrGBaseNextbotCanPossess")
			net.WriteEntity(tr.Entity)
		else
			net.Start("DrGBaseNextbotCantPossess")
			net.WriteEntity(tr.Entity)
			net.WriteString(possess)
		end
		net.Send(owner)
	end
end
function SWEP:SecondaryAttack() end
function SWEP:Reload() end
hook.Add("PreDrawHalos", "DrGBasePossessorSWEPHalos", function()
	local ply = LocalPlayer()
	local weapon = ply:GetActiveWeapon()
	if IsValid(weapon) and weapon:GetClass() == "drgbase_possessor" then
		local tr = ply:GetEyeTraceNoCursor()
		local ent = tr.Entity
		if not IsValid(ent) then return end
		if CanPossess(ent) and not ent:IsPossessed() then
			halo.Add({ent}, DrGBase.CLR_GREEN)
		else halo.Add({ent}, DrGBase.CLR_RED) end
	end
end)
