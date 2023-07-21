--[[
	BEGOTTEN III: Developed by DETrooper, cash wednesday, gabs & alyousha35
--]]

cwLimbs.limbStates = {
	["head"] = {
		["fine"] = {name = "Fine", effects = "None"},
		["slightly_damaged"] = {name = "Slightly Damaged", effects = "Slightly Increased Headbob\nIncreased Injury Chance"},
		["damaged"] = {name = "Damaged", effects = "Blurry Vision\nSlightly Increased Headbob\nIncreased Injury Chance"},
		["heavily_damaged"] = {name = "Heavily Damaged", effects = "Blurry Vision\nIncreased Headbob\nIncreased Injury Chance"},
		["severely_damaged"] = {name = "Severely Damaged", effects = "Very Blurry Vision\nGreatly Increased Headbob\nIncreased Injury Chance"},
		["mangled"] = {name = "Mangled", effects = "Very Blurry Vision\nExtreme Headbob\nIncreased Injury Chance"},
	},
	["torso"] = {
		["fine"] = {name = "Fine", effects = "None"},
		["slightly_damaged"] = {name = "Slightly Damaged", effects = "Increased Injury Chance"},
		["damaged"] = {name = "Damaged", effects = "Increased Injury Chance"},
		["heavily_damaged"] = {name = "Heavily Damaged", effects = "Increased Injury Chance"},
		["severely_damaged"] = {name = "Severely Damaged", effects = "Increased Injury Chance"},
		["mangled"] = {name = "Mangled", effects = "Guaranteed Injury"},
	},
	["arms"] = {
		["fine"] = {name = "Fine", effects = "None"},
		["slightly_damaged"] = {name = "Slightly Damaged", effects = "Increased Injury Chance"},
		["damaged"] = {name = "Damaged", effects = "Slightly Increased Poise Consumption\nIncreased Injury Chance"},
		["heavily_damaged"] = {name = "Heavily Damaged", effects = "Increased Poise Consumption\nIncreased Injury Chance"},
		["severely_damaged"] = {name = "Severely Damaged", effects = "Greatly Increased Poise Consumption\nIncreased Injury Chance"},
		["mangled"] = {name = "Mangled", effects = "Greatly Increased Poise Consumption\nIncreased Injury Chance"},
	},
	["legs"] = {
		["fine"] = {name = "Fine", effects = "None"},
		["slightly_damaged"] = {name = "Slightly Damaged", effects = "Slightly Decreased Stability Damage Resistance\nIncreased Injury Chance"},
		["damaged"] = {name = "Damaged", effects = "Decreased Running Speed\nDecreased Jump Power\nDecreased Stability Damage Resistance\nIncreased Injury Chance"},
		["heavily_damaged"] = {name = "Heavily Damaged", effects = "Greatly Decreased Running Speed\nGreatly Decreased Jump Power\nDecreased Stability Damage Resistance\nIncreased Injury Chance"},
		["severely_damaged"] = {name = "Severely Damaged", effects = "Cannot Roll\nCannot Run\nDecreased Walk Speed\nCannot Jump\nGreatly Decreased Stability Damage Resistance\nRandom Fallover Chance\nIncreased Injury Chance"},
		["mangled"] = {name = "Mangled", effects = "Cannot Roll\nCannot Run\nCan Only Crouch-walk\nCannot Jump\nGreatly Decreased Stability Damage Resistance\nRandom Fallover Chance\nGuaranteed Injury"},
	},
};

local texInfo = {
	shouldDisplay = true, textures = {}, names = {}
}

local backgroundColor = Color(255, 255, 255)
local mainTextFont = "Default"

-- A function to cache all required limb info.
function cwLimbs:CacheLimbs()
	texInfo = {
		textures = {
			[HITGROUP_RIGHTARM] = Clockwork.limb:GetTexture(HITGROUP_RIGHTARM),
			[HITGROUP_RIGHTLEG] = Clockwork.limb:GetTexture(HITGROUP_RIGHTLEG),
			[HITGROUP_LEFTARM] = Clockwork.limb:GetTexture(HITGROUP_LEFTARM),
			[HITGROUP_LEFTLEG] = Clockwork.limb:GetTexture(HITGROUP_LEFTLEG),
			[HITGROUP_STOMACH] = Clockwork.limb:GetTexture(HITGROUP_STOMACH),
			[HITGROUP_CHEST] = Clockwork.limb:GetTexture(HITGROUP_CHEST),
			[HITGROUP_HEAD] = Clockwork.limb:GetTexture(HITGROUP_HEAD),
			["body"] = Clockwork.limb:GetTexture("body")
		},
		names = {
			[HITGROUP_RIGHTARM] = Clockwork.limb:GetName(HITGROUP_RIGHTARM),
			[HITGROUP_RIGHTLEG] = Clockwork.limb:GetName(HITGROUP_RIGHTLEG),
			[HITGROUP_LEFTARM] = Clockwork.limb:GetName(HITGROUP_LEFTARM),
			[HITGROUP_LEFTLEG] = Clockwork.limb:GetName(HITGROUP_LEFTLEG),
			[HITGROUP_STOMACH] = Clockwork.limb:GetName(HITGROUP_STOMACH),
			[HITGROUP_CHEST] = Clockwork.limb:GetName(HITGROUP_CHEST),
			[HITGROUP_HEAD] = Clockwork.limb:GetName(HITGROUP_HEAD),
		}
	}

	backgroundColor = Clockwork.option:GetColor("background")
	mainTextFont = Clockwork.option:GetFont("main_text")
end

-- Called when the plugin initializes.
function cwLimbs:Initialize()
	self:CacheLimbs()
end

-- A function to get if the player can see their limb damage or not.
function cwLimbs:PlayerCanSeeLimbDamage()
	return (Clockwork.kernel:IsInfoMenuOpen() and config.Get("limb_damage_system"):Get())
end

-- Called just after the date time box is drawn.
function cwLimbs:PostDrawDateTimeBox(info)
	if (!hook.Call("PlayerCanSeeLimbDamage")) then
		return
	end

	local tipHeight = 0
	local tipWidth = 0
	local limbInfo = {}
	local height = 240
	local width = 120
	local x = info.x + (info.width / 2) + 32
	local y = info.originalY + 8
	
	hook.Call("GetPlayerLimbInfo", texInfo)
	
	if (texInfo.shouldDisplay) then
		surface.SetDrawColor(255, 255, 255, 150)
		surface.SetMaterial(texInfo.textures["body"])
		surface.DrawTexturedRect(x, y, width, height)
		
		for k, v in pairs(Clockwork.limb.hitGroups) do
			local limbHealth = Clockwork.limb:GetHealth(k)
			local limbColor = Clockwork.limb:GetColor(limbHealth)
			local newIndex = #limbInfo + 1
			
			surface.SetDrawColor(limbColor.r, limbColor.g, limbColor.b, 150)
			surface.SetMaterial(texInfo.textures[k])
			surface.DrawTexturedRect(x, y, width, height)
			
			limbInfo[newIndex] = {
				color = limbColor,
				text = texInfo.names[k]..": "..limbHealth.."%"
			}
			
			local textWidth, textHeight = self:GetCachedTextSize(mainTextFont, limbInfo[newIndex].text)
			tipHeight = tipHeight + textHeight + 4
			
			if (textWidth > tipWidth) then
				tipWidth = textWidth
			end
			
			limbInfo[newIndex].textHeight = textHeight
		end
		
		local mouseX = gui.MouseX()
		local mouseY = gui.MouseY()
		
		if (mouseX >= x and mouseX <= x + width and mouseY >= y and mouseY <= y + height) then
			local tipX = mouseX + 16
			local tipY = mouseY + 16
			
			self:DrawSimpleGradientBox(
				2, tipX - 8, tipY - 8, tipWidth + 16, tipHeight + 12, backgroundColor
			)
			
			for k, v in pairs(limbInfo) do
				self:DrawInfo(v.text, tipX, tipY, v.color, 255, true)
				
				if (k < #limbInfo) then
					tipY = tipY + v.textHeight + 4
				else
					tipY = tipY + v.textHeight
				end
			end
		end
	end
end

-- Called when the local player's limb damage is received.
function cwLimbs:PlayerLimbDamageReceived() end

-- Called when the local player's limb damage is reset.
function cwLimbs:PlayerLimbDamageReset() end

-- Called when the local player's limb damage is bIsHealed.
function cwLimbs:PlayerLimbDamageHealed(hitGroup, amount) end

-- Called when the local player's limb takes damage.
function cwLimbs:PlayerLimbTakeDamage(hitGroup, damage) end