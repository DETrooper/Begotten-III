
local PossessionEnabled = CreateConVar("drgbase_possession_enable", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED})
local EnableLockOn = CreateConVar("drgbase_possession_allow_lockon", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED})

--[[properties.Add("drgbasepossess", {
	MenuLabel = "Possess",
	Order = 1000,
	MenuIcon = "drgbase/icon16.png",
	Filter = function(self, ent, ply)
		if not ent.IsDrGNextbot then return false end
		if not PossessionEnabled:GetBool() then return false end
		if not ent.PossessionPrompt then return false end
		if not ent:IsPossessionEnabled() then return false end
		return true
	end,
	Action = function(self, ent)
    self:MsgStart()
    net.WriteEntity(ent)
    self:MsgEnd()
  end,
	Receive = function(self, len, ply)
		local ent = net.ReadEntity()
    local possess = ent:Possess(ply)
    if possess == "ok" then
			net.Start("DrGBaseNextbotCanPossess")
			net.WriteEntity(ent)
		else
			net.Start("DrGBaseNextbotCantPossess")
			net.WriteEntity(ent)
      net.WriteString(possess)
    end
		net.Send(ply)
	end
})]]--

--[[hook.Add("StartCommand", "DrGBasePossessionStartCommand", function(ply, cmd)
	if not isfunction(ply.DrG_IsPossessing) then return end
	if ply:DrG_IsPossessing() then
		local possessing = ply:DrG_GetPossessing()
		-- disable movement
		cmd:ClearMovement()
		if ply:HasWeapon("drgbase_possession") then
			cmd:SelectWeapon(ply:GetWeapon("drgbase_possession"))
		elseif SERVER then
			ply:Give("drgbase_possession")
		end
		-- lock on entity
		local lockedOn = possessing:PossessionGetLockedOn()
		if IsValid(lockedOn) then
			local origin = possessing:PossessorView()
			local forward = cmd:GetViewAngles():Forward()
			local dir = origin:DrG_Direction(lockedOn:WorldSpaceCenter()):GetNormalized()
			local bone = lockedOn.DrGBase_LockOnBone
			if isstring(bone) then bone = lockedOn:LookupBone(bone) end
			if isnumber(bone) then
				dir = origin:DrG_Direction(lockedOn:GetBonePosition(bone)):GetNormalized()
			end
			if SERVER then
				cmd:SetViewAngles(forward:DrG_Join(dir, ply:GetInfoNum("drgbase_possession_lockon_speed", 0.05)):Angle())
			else
				cmd:SetViewAngles(forward:DrG_Join(dir, GetConVar("drgbase_possession_lockon_speed"):GetFloat()):Angle())
			end
		end
	elseif SERVER then
		ply:StripWeapon("drgbase_possession")
	end
end)

hook.Add("PlayerFootstep", "DrGBasePossessionMuteFootsteps", function(ply)
	if not isfunction(ply.DrG_IsPossessing) then return end
	if ply:DrG_IsPossessing() then return true end
end)]]--

--[[if SERVER then
	util.AddNetworkString("DrGBaseNextbotCanPossess")
	util.AddNetworkString("DrGBaseNextbotCantPossess")

	hook.Add("PlayerUse", "DrGBaseNextbotPossessionDisableUse", function(ply, ent)
	  if ply:DrG_IsPossessing() then return false end
	end)

	hook.Add("EntityTakeDamage", "DrGBaseNextbotProtectPossessingPlayer", function(ent, dmg)
		if ent:IsPlayer() and ent:DrG_IsPossessing() then return true end
	end)

	local function PlayerDeath(ply)
		if ply:DrG_IsPossessing() then ply:DrG_Possessing():Dispossess() end
	end
	hook.Add("PlayerDeath", "DrGBasePossessionPlayerDeath", PlayerDeath)
	hook.Add("PlayerSilentDeath", "DrGBasePossessionPlayerSilentDeath", PlayerDeath)

	local function LockOnEntity(nextbot, ent)
		nextbot._DrGBaseAutoLockOnID = nextbot._DrGBaseAutoLockOnID or 0
		nextbot._DrGBaseAutoLockOnID = nextbot._DrGBaseAutoLockOnID+1
		local id = nextbot._DrGBaseAutoLockOnID
		nextbot:PossessionLockOn(ent)
		ent:CallOnRemove("DrGBasePossessionSwitchLockOn", function()
			if not IsValid(nextbot) then return end
			if id == nextbot._DrGBaseAutoLockOnID then
				local closest = nextbot:PossessionFetchLockOn()
				if IsValid(closest) then LockOnEntity(nextbot, closest) end
			end
		end)
	end

	hook.Add("PlayerButtonDown", "DrGBasePossessionButtons", function(ply, button)
		if not ply:DrG_IsPossessing() then return end
		local possessing = ply:DrG_Possessing()
		if SERVER then
			if button == ply:GetInfoNum("drgbase_possession_view", KEY_V) then
				possessing:CycleViewPresets()
			elseif button == ply:GetInfoNum("drgbase_possession_exit", KEY_E) then
				possessing:Dispossess()
			elseif button == ply:GetInfoNum("drgbase_possession_lockon", KEY_L) and EnableLockOn:GetBool() then
				local lockedOn = possessing:PossessionGetLockedOn()
				local closest = possessing:PossessionFetchLockOn()
				if closest ~= lockedOn and IsValid(closest) then
					LockOnEntity(possessing, closest)
				else possessing:PossessionLockOn(NULL) end
			end
		end
	end)

	hook.Add("PlayerSwitchFlashlight", "DrGBasePossessionDisableFlashlight", function(ply, state)
		--if ply:DrG_IsPossessing() and state then return false end
	end)

	hook.Add("GetFallDamage", "DrGBasePossessionPlayerFallDamage", function(ply)
		if ply:DrG_IsPossessing() then return 0 end
	end)

	hook.Add("SetupPlayerVisibility", "DrGBasePossessionAddToPVS", function(ply)
		if ply:DrG_IsPossessing() then
			local possessing = ply:DrG_GetPossessing()
			AddOriginToPVS(possessing:GetPos())
			local lockedOn = possessing:PossessionGetLockedOn()
			if IsValid(lockedOn) then AddOriginToPVS(lockedOn:GetPos()) end
		end
	end)

	hook.Add("EntityEmitSound", "DrGBasePossessionMutePlayerSounds", function(sound)
		if IsValid(sound.Entity) and sound.Entity:IsPlayer() and sound.Entity:DrG_IsPossessing() then
			return false
		end
	end)

else

	CreateClientConVar("drgbase_possession_exit", tostring(KEY_E), true, true)
	CreateClientConVar("drgbase_possession_view", tostring(KEY_V), true, true)
	CreateClientConVar("drgbase_possession_climb", tostring(KEY_C), true, true)
	CreateClientConVar("drgbase_possession_lockon", tostring(KEY_L), true, true)
	CreateClientConVar("drgbase_possession_lockon_speed", "0.05", true, true)

	net.Receive("DrGBaseNextbotCanPossess", function()
		local ent = net.ReadEntity()
		if not IsValid(ent) then return end
		notification.AddLegacy("You are now possessing "..ent.PrintName..".", NOTIFY_HINT, 4)
		surface.PlaySound("buttons/lightswitch2.wav")
	end)

	net.Receive("DrGBaseNextbotCantPossess", function()
		local ent = net.ReadEntity()
		if not IsValid(ent) then return end
		local enum = net.ReadString()
		local reason = enum
		if enum == "not allowed" then reason = "you are not allowed to possess this nextbot."
		elseif enum == "already possessed" then reason = "another player is already possessing this nextbot."
		elseif enum == "error" then reason = "unknown error."
		elseif enum == "not alive" then reason = "you are dead."
		elseif enum == "already possessing" then reason = "you are already possessing a nextbot."
		elseif enum == "disabled" then reason = "possession is not available for this nextbot."
		elseif enum == "no views" then reason = "no defined camera views."
		elseif enum == "in vehicle" then reason = "you are in a vehicle."
		end
		notification.AddLegacy("You can't possess "..ent.PrintName..": "..reason, NOTIFY_ERROR, 4)
		surface.PlaySound("buttons/button10.wav")
	end)

	local HUD_HIDE = {
		["CHudWeaponSelection"] = true,
		["CHudAmmo"] = true,
		["CHudSecondaryAmmo"] = true,
		["CHudZoom"] = true
	}
	hook.Add("HUDShouldDraw", "DrGBasePossessionHideHUD", function(name)
		local ply = LocalPlayer()
		if not isfunction(ply.DrG_IsPossessing) then return end
		if not ply:DrG_IsPossessing() then return end
		if HUD_HIDE[name] then return false end
		if name == "CHudCrosshair" and not ply:DrG_Possessing().PossessionCrosshair then return false end
	end)

	hook.Add("CalcView", "DrGBasePossessionCalcView", function(ply, origin, angles, fov, znear, zfar)
		if not isfunction(ply.DrG_IsPossessing) then return end
		if not ply:DrG_IsPossessing() then return end
		local possessing = ply:DrG_Possessing()
		if not isfunction(possessing.PossessorView) then return end
		local view = {}
		view.origin, view.angles = possessing:PossessorView()
		view.fov, view.znear, view.zfar = fov, znear, zfar
		view.drawviewer = true
		return view
	end)

	hook.Add("ContextMenuOpen", "DrGBasePossessionDisableCMenu", function()
		local ply = LocalPlayer()
		if not isfunction(ply.DrG_IsPossessing) then return end
		if ply:DrG_IsPossessing() then return false end
	end)

	hook.Add("ShouldDrawLocalPlayer", "DrGBasePossessionDrawPlayer", function(ply)
		if not isfunction(ply.DrG_IsPossessing) then return end
		if ply:DrG_IsPossessing() then return false end
	end)

	function DrGBase.DrawPossessionHUD(ent)
		local ply = LocalPlayer()
		-- I should put the rest of the HUD code here but
		-- I don't have any inspiration for how the HUD should look
		-- so right now there is no code here
		-- I'll take care of it one day
	end

end]]--
