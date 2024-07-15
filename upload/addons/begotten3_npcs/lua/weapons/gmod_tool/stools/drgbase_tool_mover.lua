TOOL.Tab = "DrGBase"
TOOL.Category = "Tools"
TOOL.Name = "#tool.drgbase_tool_mover.name"
TOOL.BuildCPanel = function(panel)
	panel:Help("#tool.drgbase_tool_mover.desc")
	panel:Help("#tool.drgbase_tool_mover.0")
end

function TOOL:LeftClick(tr)
	if not IsValid(tr.Entity) then return false end
	if not tr.Entity.IsDrGNextbot then return false end
	if CLIENT then return true end
	self:GetOwner():DrG_CleverEntitySelect(tr.Entity)
	return true
end
function TOOL:RightClick(tr)
	if CLIENT then return true end
	for nextbot in self:GetOwner():DrG_SelectedEntities() do
		nextbot._DrGBaseMoverTool = true
		nextbot:CallInCoroutine(function(nextbot, delay)
			nextbot._DrGBaseMoverTool = false
			nextbot:GoTo(tr.HitPos, nil, function()
				if nextbot._DrGBaseMoverTool then return false end
			end)
		end)
	end
	return true
end
function TOOL:Reload(tr)
	if CLIENT then return true end
	self:GetOwner():DrG_ClearSelectedEntities()
	return true
end

if CLIENT then
	language.Add("tool.drgbase_tool_mover.name", "Nextbot Mover")
	language.Add("tool.drgbase_tool_mover.desc", "Force nextbots to move to a different position.")
	language.Add("tool.drgbase_tool_mover.0", "Left click to select/deselect a nextbot (hold shift to select multiple nextbots), right click to set the position to go to and reload to clear the list of selected nextbots.")

	hook.Add("PreDrawHalos", "DrGBaseToolMoverHalos", function()
		local ply = LocalPlayer()
		local wep = ply:GetActiveWeapon()
		if not IsValid(wep) or wep:GetClass() ~= "gmod_tool" then return end
		local tool = ply:GetTool()
		if tool == nil or tool.Mode ~= "drgbase_tool_mover" then return end
		halo.Add(ply:DrG_GetSelectedEntities(), DrGBase.CLR_CYAN, nil, nil, nil, nil, true)
	end)
end
