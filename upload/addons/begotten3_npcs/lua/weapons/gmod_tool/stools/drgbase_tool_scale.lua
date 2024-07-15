TOOL.Tab = "DrGBase"
TOOL.Category = "Tools"
TOOL.Name = "#tool.drgbase_tool_scale.name"
TOOL.BuildCPanel = function(panel)
	panel:Help("#tool.drgbase_tool_scale.desc")
	panel:Help("#tool.drgbase_tool_scale.0")
end

function TOOL:LeftClick(tr)
	if not IsValid(tr.Entity) then return false end
	if not tr.Entity.IsDrGNextbot then return false end
	if SERVER then tr.Entity:Scale(1.1, 0.1) end
	return true
end
function TOOL:RightClick(tr)
	if not IsValid(tr.Entity) then return false end
	if not tr.Entity.IsDrGNextbot then return false end
	if SERVER then tr.Entity:Scale(0.9, 0.1) end
	return true
end
function TOOL:Reload(tr)
	if not IsValid(tr.Entity) then return false end
	if not tr.Entity.IsDrGNextbot then return false end
	if SERVER then tr.Entity:SetScale(1, 0.1) end
	return true
end

if CLIENT then
	language.Add("tool.drgbase_tool_scale.name", "Change Scale")
	language.Add("tool.drgbase_tool_scale.desc", "Change the scale of a nextbot.")
	language.Add("tool.drgbase_tool_scale.0", "Left click to scale up, right click to scale down, reload to reset scale.")
end
