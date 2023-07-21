TOOL.Tab = "DrGBase"
TOOL.Category = "Tools"
TOOL.Name = "#tool.drgbase_tool_info.name"
TOOL.BuildCPanel = function(panel)
	panel:Help("#tool.drgbase_tool_info.desc")
	panel:Help("#tool.drgbase_tool_info.0")
end

local PAGE_NAMES = {
	"Status", "AI",
	"Possession", "Movement",
	"Animation", "Viewcam"
}

function TOOL:LeftClick(tr)
  if not IsValid(tr.Entity) then return false end
  if not tr.Entity.IsDrGNextbot then return false end
	if CLIENT then return true end
	local owner = self:GetOwner()
	owner:SetNW2Int("DrGBaseNextbotInfoToolPage", 1)
	owner:DrG_SingleEntitySelect(tr.Entity)
  return true
end
function TOOL:RightClick()
	if CLIENT then return false end
	local owner = self:GetOwner()
	if IsValid(owner:DrG_GetSelectedEntities()[1]) then
		local page = owner:GetNW2Int("DrGBaseNextbotInfoToolPage")
		if page < #PAGE_NAMES then
			owner:SetNW2Int("DrGBaseNextbotInfoToolPage", page+1)
		else owner:SetNW2Int("DrGBaseNextbotInfoToolPage", 1) end
		owner:SendLua('surface.PlaySound("buttons/lightswitch2.wav")')
	else owner:SendLua('surface.PlaySound("buttons/button10.wav")') end
	return false
end
function TOOL:Reload(tr)
  if CLIENT then return true end
  self:GetOwner():DrG_ClearSelectedEntities()
  return true
end

if CLIENT then
	DrGBase.INFO_TOOL = {}
	DrGBase.INFO_TOOL.Viewcam = nil
	DrGBase.INFO_TOOL.RT = GetRenderTarget("DrGBaseInfoToolRT", 256, 256, false)
	DrGBase.INFO_TOOL.Mat = CreateMaterial("DrGBaseInfoToolMaterial", "GMODScreenspace", {
		["$basetexture"] = DrGBase.INFO_TOOL.RT,
		["$basetexturetransform"] = "center .5 .5 scale -1 -1 rotate 0 translate 0 0",
		["$texturealpha"] = 0,
		["$vertexalpha"] = 1,
	})
end
function TOOL:DrawToolScreen(width, height)
	surface.SetDrawColor(DrGBase.CLR_DARKGRAY)
	surface.DrawRect(0, 0, width, height)
	local owner = self:GetOwner()
	local selected = owner:DrG_GetSelectedEntities()[1]
	if IsValid(selected) then
		local page = owner:GetNW2Int("DrGBaseNextbotInfoToolPage")
		local pageName = PAGE_NAMES[page] or "Invalid"
		if pageName == "Status" then
			draw.SimpleText("Health:", "DermaLarge", 10, 10, DrGBase.CLR_LIGHTGRAY)
			draw.SimpleText(selected:Health().." / "..selected:GetMaxHealth(), "DermaLarge", 10, 50, util.DrG_MergeColors(selected:Health()/selected:GetMaxHealth(), DrGBase.CLR_GREEN, DrGBase.CLR_RED))
			draw.SimpleText("Regen: "..tostring(selected:GetHealthRegen()), "DermaLarge", 10, 90, DrGBase.CLR_LIGHTGRAY)
			draw.SimpleText("Godmode: "..(selected:GetGodMode() and "Enabled" or "Disabled"), "DermaLarge", 10, 130, DrGBase.CLR_LIGHTGRAY)
			draw.SimpleText("Status:", "DermaLarge", 10, 170, DrGBase.CLR_LIGHTGRAY)
			if selected:IsDead() then
				draw.SimpleText("Dead", "DermaLarge", 100, 170, DrGBase.CLR_RED)
			elseif selected:IsDown() then
				draw.SimpleText("Down", "DermaLarge", 100, 170, DrGBase.CLR_ORANGE)
			else draw.SimpleText("Alive", "DermaLarge", 100, 170, DrGBase.CLR_GREEN) end
		elseif pageName == "AI" then
			draw.SimpleText("Enemy:", "DermaLarge", 10, 10, DrGBase.CLR_LIGHTGRAY)
			if selected:HasEnemy() then
				local enemy = selected:GetEnemy()
				if enemy:IsPlayer() then
					draw.SimpleText(enemy:GetName(), "DermaLarge", 10, 50, DrGBase.CLR_RED)
				else draw.SimpleText("#"..enemy:GetClass(), "DermaLarge", 10, 50, DrGBase.CLR_RED) end
			else draw.SimpleText("None", "DermaLarge", 10, 50, DrGBase.CLR_RED) end
			draw.SimpleText("Relationship:", "DermaLarge", 10, 130, DrGBase.CLR_LIGHTGRAY)
			draw.SimpleText("Spotted: "..(selected:HasSpottedLocalPlayer() and "True" or "False"), "DermaLarge", 10, 170, DrGBase.CLR_LIGHTGRAY)
			local disp = selected:LocalPlayerRelationship()
			if disp == D_LI then
				draw.SimpleText("Like", "DermaLarge", 170, 130, DrGBase.CLR_GREEN)
			elseif disp == D_HT then
				draw.SimpleText("Hate", "DermaLarge", 170, 130, DrGBase.CLR_RED)
			elseif disp == D_FR then
				draw.SimpleText("Afraid", "DermaLarge", 170, 130, DrGBase.CLR_PURPLE)
			elseif disp == D_NU then
				draw.SimpleText("Neutral", "DermaLarge", 165, 130, DrGBase.CLR_CYAN)
			elseif disp == D_ER then
				draw.SimpleText("Error", "DermaLarge", 170, 130, DrGBase.CLR_ORANGE)
			end
			draw.SimpleText("Omniscient: "..(selected:IsOmniscient() and "True" or "False"), "DermaLarge", 10, 90, DrGBase.CLR_LIGHTGRAY)
		elseif pageName == "Possession" then
			if selected:IsPossessed() then
				draw.SimpleText("Possessed by:", "DermaLarge", 10, 10, DrGBase.CLR_LIGHTGRAY)
				draw.SimpleText(selected:GetPossessor():GetName(), "DermaLarge", 10, 50, DrGBase.CLR_CYAN)
				draw.SimpleText("Locked on:", "DermaLarge", 10, 90, DrGBase.CLR_LIGHTGRAY)
				local lockedOn = selected:PossessionGetLockedOn()
				if IsValid(lockedOn) then
					if lockedOn:IsPlayer() then
						draw.SimpleText(lockedOn:GetName(), "DermaLarge", 10, 130, DrGBase.CLR_ORANGE)
					else draw.SimpleText("#"..lockedOn:GetClass(), "DermaLarge", 10, 130, DrGBase.CLR_ORANGE) end
				else draw.SimpleText("None", "DermaLarge", 10, 130, DrGBase.CLR_ORANGE) end
			else
				draw.SimpleText("This nextbot", "DermaLarge", width/2, height/2-40, DrGBase.CLR_RED, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText("isn't possessed", "DermaLarge", width/2, height/2, DrGBase.CLR_RED, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		elseif pageName == "Movement" then
			draw.SimpleText("Speed: "..tostring(math.Round(selected:Speed(true), 2)), "DermaLarge", 10, 10, DrGBase.CLR_LIGHTGRAY)
			draw.SimpleText("Scale: "..tostring(math.Round(selected:GetScale(), 2)), "DermaLarge", 10, 50, DrGBase.CLR_LIGHTGRAY)
			draw.SimpleText("Movement:", "DermaLarge", 10, 130, DrGBase.CLR_LIGHTGRAY)
			draw.SimpleText(selected:GetMovement():DrG_ToString(2), "DermaLarge", 10, 170, DrGBase.CLR_CYAN)
		elseif pageName == "Animation" then
			if selected.IsDrGNextbotSprite then
				draw.SimpleText("Animation:", "DermaLarge", 10, 10, DrGBase.CLR_LIGHTGRAY)
				draw.SimpleText(selected:GetSpriteAnim(), "DermaLarge", 10, 50, DrGBase.CLR_CYAN)
				draw.SimpleText("Frame: "..tostring(selected:GetSpriteFrame()), "DermaLarge", 10, 90, DrGBase.CLR_LIGHTGRAY)
			else
				draw.SimpleText("Sequence:", "DermaLarge", 10, 10, DrGBase.CLR_LIGHTGRAY)
				draw.SimpleText(selected:GetSequenceName(selected:GetSequence()), "DermaLarge", 10, 50, DrGBase.CLR_CYAN)
				draw.SimpleText("Activity:", "DermaLarge", 10, 90, DrGBase.CLR_LIGHTGRAY)
				draw.SimpleText(selected:GetSequenceActivityName(selected:GetSequence()), "DermaLarge", 10, 130, DrGBase.CLR_CYAN)
			end
			draw.SimpleText("Attacking? "..(selected:IsAttack(selected:GetSequence()) and "True" or "False"), "DermaLarge", 10, 170, DrGBase.CLR_LIGHTGRAY)
		elseif pageName == "Viewcam" then
			local legs = owner.ShouldDisableLegs
			owner.ShouldDisableLegs = true
			local pos = selected:GetPos()
			local eyepos = selected:EyePos()
			render.PushRenderTarget(DrGBase.INFO_TOOL.RT)
			DrGBase.INFO_TOOL.Viewcam = true
			render.RenderView({
				x = 0, y = 0, w = 256, h = 256,
				origin = Vector(pos.x, pos.y, eyepos.z),
				angles = selected:EyeAngles(),
				dopostprocess = false,
				drawviewmodel = false,
				drawmonitors = true
			})
			DrGBase.INFO_TOOL.Viewcam = nil
			render.PopRenderTarget()
			owner.ShouldDisableLegs = legs
			DrGBase.INFO_TOOL.Mat:SetTexture("$basetexture", DrGBase.INFO_TOOL.RT)
			surface.SetMaterial(DrGBase.INFO_TOOL.Mat)
			surface.DrawTexturedRect(0, 0, width, height)
		end
		draw.SimpleText("("..tostring(page).. ")", "DermaLarge", 10, height-10, DrGBase.CLR_LIGHTGRAY, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
		if page == 2 and selected:IsAIDisabled() then
			draw.SimpleText(PAGE_NAMES[page], "DermaLarge", width/2, height-10, DrGBase.CLR_RED, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
		else draw.SimpleText(PAGE_NAMES[page], "DermaLarge", width/2, height-10, DrGBase.CLR_LIGHTGRAY, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM) end
		draw.SimpleText(">>", "DermaLarge", width-10, height-10, DrGBase.CLR_LIGHTGRAY, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
	else
		draw.SimpleText("No nextbot", "DermaLarge", width/2, height/2-20, DrGBase.CLR_RED, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("selected", "DermaLarge", width/2, height/2+20, DrGBase.CLR_RED, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end

if CLIENT then
  language.Add("tool.drgbase_tool_info.name", "Nextbot Info")
	language.Add("tool.drgbase_tool_info.desc", "View and edit information about the nextbot.")
	language.Add("tool.drgbase_tool_info.0", "Left click to select/deselect a nextbot.")

  hook.Add("PreDrawHalos", "DrGBaseToolNextbotInfoHalos", function()
		local ply = LocalPlayer()
    local wep = ply:GetActiveWeapon()
    if not IsValid(wep) or wep:GetClass() ~= "gmod_tool" then return end
    local tool = ply:GetTool()
    if tool == nil or tool.Mode ~= "drgbase_tool_info" then return end
		local selected = ply:DrG_GetSelectedEntities()[1]
		if not IsValid(selected) then return end
		local page = ply:GetNW2Int("DrGBaseNextbotInfoToolPage")
		local pageName = PAGE_NAMES[page] or "Invalid"
		if pageName == "Status" then
			halo.Add({selected}, util.DrG_MergeColors(selected:Health()/selected:GetMaxHealth(), DrGBase.CLR_GREEN, DrGBase.CLR_RED), nil, nil, nil, nil, true)
		elseif pageName == "AI" then
			local color = DrGBase.CLR_ORANGE
			local disp = selected:LocalPlayerRelationship()
			if disp == D_LI then
				color = DrGBase.CLR_GREEN
			elseif disp == D_HT then
				color = DrGBase.CLR_RED
			elseif disp == D_FR then
				color = DrGBase.CLR_PURPLE
			elseif disp == D_NU then
				color = DrGBase.CLR_CYAN
			end
			halo.Add({selected}, color, nil, nil, nil, nil, true)
		elseif pageName == "Possession" then
			if selected:IsPossessed() then
				halo.Add({selected}, DrGBase.CLR_GREEN, nil, nil, nil, nil, true)
			else halo.Add({selected}, DrGBase.CLR_RED, nil, nil, nil, nil, true) end
		elseif not DrGBase.INFO_TOOL.Viewcam then
			halo.Add({selected}, DrGBase.CLR_CYAN, nil, nil, nil, nil, true)
		end
  end)

	hook.Add("ShouldDrawLocalPlayer", "DrGBaseNextbotInfoToolDrawPlayer", function(ply)
		local weapon = ply:GetActiveWeapon()
    if not IsValid(weapon) or weapon:GetClass() ~= "gmod_tool" then return end
    local tool = ply:GetTool()
    if tool == nil or tool.Mode ~= "drgbase_tool_info" then return end
		local selected = ply:DrG_GetSelectedEntities()[1]
		if not IsValid(selected) then return end
		local page = ply:GetNW2Int("DrGBaseNextbotInfoToolPage")
		local pageName = PAGE_NAMES[page] or "Invalid"
		if pageName ~= "Viewcam" then return end
		cam.Start3D() cam.End3D()
		return DrGBase.INFO_TOOL.Viewcam
	end)
end
