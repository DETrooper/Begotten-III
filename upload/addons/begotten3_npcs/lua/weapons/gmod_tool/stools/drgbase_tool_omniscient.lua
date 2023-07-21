TOOL.Tab = "DrGBase"
TOOL.Category = "Tools"
TOOL.Name = "#tool.drgbase_tool_omniscient.name"
TOOL.BuildCPanel = function(panel)
	panel:Help("#tool.drgbase_tool_omniscient.desc")
	panel:Help("#tool.drgbase_tool_omniscient.0")
end

function TOOL:LeftClick(tr)
  if not IsValid(tr.Entity) then return false end
  if not tr.Entity.IsDrGNextbot then return false end
  if SERVER then tr.Entity:SetOmniscient(not tr.Entity:IsOmniscient()) end
  return true
end

if CLIENT then
  language.Add("tool.drgbase_tool_omniscient.name", "Set Omniscient")
	language.Add("tool.drgbase_tool_omniscient.desc", "Disable/enable omniscience for a nextbot.")
	language.Add("tool.drgbase_tool_omniscient.0", "Left click to toggle omniscience. (Green => Enabled / Red => Disabled)")

  hook.Add("PreDrawHalos", "DrGBaseToolOmniscientHalos", function()
    local wep = LocalPlayer():GetActiveWeapon()
    if not IsValid(wep) or wep:GetClass() ~= "gmod_tool" then return end
    local tool = LocalPlayer():GetTool()
    if tool == nil or tool.Mode ~= "drgbase_tool_omniscient" then return end
    local enabled = {}
    local disabled = {}
    for i, nextbot in ipairs(DrGBase.GetNextbots()) do
      if not IsValid(nextbot) then continue end
      if nextbot:IsOmniscient() then table.insert(enabled, nextbot)
      else table.insert(disabled, nextbot) end
    end
    halo.Add(enabled, DrGBase.CLR_GREEN)
    halo.Add(disabled, DrGBase.CLR_RED)
  end)
end
