--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

PLUGIN.name = "Raise Weapon"
PLUGIN.description = "Allows players to raise and lower their weapons."
PLUGIN.author = "Mr. Meow"
PLUGIN.compatibility = "1.2"

local Clockwork = Clockwork

local playerMeta = FindMetaTable("Player")
local blockedWeapons = {
	"weapon_physgun",
	"gmod_tool",
	"gmod_camera",
	"cw_senses",
	"cw_keys",
	"cw_adminasstool",
}

local rotationTranslate = {
	["default"] = Angle(30, -30, -25),
	["weapon_fists"] = Angle(30, -30, -50),
	["cw_hands"] = Angle(0, 0, -90)
}

function playerMeta:SetWeaponRaised(bIsRaised)
	if (SERVER) then
		self:SetDTBool(BOOL_WEAPON_RAISED, bIsRaised)

		hook.Run("OnWeaponRaised", self, self:GetActiveWeapon(), bIsRaised)
	end
end

function playerMeta:IsWeaponRaised(weapon)
	local weapon = weapon or self:GetActiveWeapon()

	if (!IsValid(weapon)) then
		return false
	end

	if (table.HasValue(blockedWeapons, weapon:GetClass())) then
		return true, weapon;
	end

	-- This doesn't seem to be used currently so I'm disabling it for now.
	--[[local shouldRaise = hook.Run("ShouldWeaponBeRaised", self, weapon)

	if (shouldRaise) then
		return shouldRaise
	end]]--

	return self:GetDTBool(BOOL_WEAPON_RAISED), weapon
end

function playerMeta:ToggleWeaponRaised()
	local activeWeapon = self:GetActiveWeapon();
	
	if (hook.Run("CanWeaponBeToggled", self, activeWeapon) != false) then
		if (self:IsWeaponRaised(activeWeapon)) then
			self:SetWeaponRaised(false)	
		else
			self:SetWeaponRaised(true)
		end
	end
end

function PLUGIN:OnWeaponRaised(player, weapon, bIsRaised)
	if (IsValid(weapon)) then
		local curTime = CurTime()

		hook.Run("UpdateWeaponRaised", player, weapon, bIsRaised, curTime)
	end
end

function PLUGIN:UpdateWeaponRaised(player, weapon, bIsRaised, curTime)
	if (bIsRaised or table.HasValue(blockedWeapons, weapon:GetClass())) then
		weapon:SetNextPrimaryFire(curTime)
		weapon:SetNextSecondaryFire(curTime)

		if (weapon.OnRaised) then
			weapon:OnRaised(player, curTime)
		end
	else
		weapon:SetNextPrimaryFire(curTime + 60)
		weapon:SetNextSecondaryFire(curTime + 60)

		if (weapon.OnLowered) then
			weapon:OnLowered(player, curTime)
		end
	end
end

function PLUGIN:PlayerThink(player, curTime)
	local weapon = player:GetActiveWeapon()

	if (IsValid(weapon)) then
		if (!player:IsWeaponRaised()) then
			weapon:SetNextPrimaryFire(curTime + 60)
			weapon:SetNextSecondaryFire(curTime + 60)
		end
	end
end

function PLUGIN:ModelWeaponRaised(player, model)
	return player:IsWeaponRaised()
end

function PLUGIN:PlayerSwitchWeapon(player, oldWeapon, newWeapon)
	local action = Clockwork.player:GetAction(player);
	
	if action == "raise" then
		Clockwork.player:SetAction(player, nil);
	end
end

function PLUGIN:PlayerSetupDataTables(player)
	player:DTVar("Bool", BOOL_WEAPON_RAISED, "WeaponRaised")
end

if CLIENT then
	function PLUGIN:GetProgressBarInfoAction(action, percentage)
		if (action == "raise") then
			local raiseText = "RAISING...";

			if (Clockwork.Client:IsWeaponRaised()) then
				raiseText = "LOWERING..."
			end;
						
			return {text = raiseText, percentage = percentage, flash = percentage < 10}
		end
	end
	
	function PLUGIN:ClockworkInitialized()
		Clockwork.ConVars.Binds.RAISEWEAPON = Clockwork.kernel:CreateClientConVar("cwRaiseBind", KEY_F, true, true)
		Clockwork.setting:AddKeyBinding("Key Bindings", "Raise Weapon: ", "cwRaiseBind", "begotten_raise");
	end
end