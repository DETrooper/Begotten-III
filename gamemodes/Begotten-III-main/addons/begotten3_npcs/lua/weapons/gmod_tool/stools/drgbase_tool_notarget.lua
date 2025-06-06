TOOL.Tab = "DrGBase"
TOOL.Category = "Tools"
TOOL.Name = "#tool.drgbase_tool_notarget.name"
TOOL.BuildCPanel = function(panel)
	panel:Help("#tool.drgbase_tool_notarget.desc")
	panel:Help("#tool.drgbase_tool_notarget.0")
end

function TOOL:LeftClick(tr)
	if not IsValid(tr.Entity) then return false end
	if not tr.Entity.IsDrGNextbot then return false end
	if CLIENT then return true end
	local owner = self:GetOwner()
	tr.Entity:SetIgnored(owner, not tr.Entity:IsIgnored(owner))
	return true
end

if CLIENT then
	language.Add("tool.drgbase_tool_notarget.name", "Toggle Notarget")
	language.Add("tool.drgbase_tool_notarget.desc", "Disable/enable notarget for a nextbot.")
	language.Add("tool.drgbase_tool_notarget.0", "Left click to toggle notarget. (Green => Enabled / Red => Disabled)")

	local NOTARGET_CACHE = {}
	hook.Add("DrawDRGBaseHalos", "DrGBaseToolNoTargetHalos", function(ply, mode)
		if mode ~= "drgbase_tool_notarget" then return end
		local ent = ply:GetEyeTrace().Entity
		if not IsValid(ent) or not ent.IsDrGNextbot then return end
		if NOTARGET_CACHE[ent] ~= nil then halo.Add({ent}, NOTARGET_CACHE[ent] and DrGBase.CLR_GREEN or DrGBase.CLR_RED) end
		ent:IsIgnored(ply, function(ent, ignored) NOTARGET_CACHE[ent] = ignored end)
	end)
end
