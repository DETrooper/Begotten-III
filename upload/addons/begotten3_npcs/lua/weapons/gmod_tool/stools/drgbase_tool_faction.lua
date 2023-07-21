TOOL.Tab = "DrGBase"
TOOL.Category = "Tools"
TOOL.Name = "#tool.drgbase_tool_faction.name"
TOOL.ClientConVar = {["list"] = "[]"}
TOOL.BuildCPanel = function(panel)
  panel:Help("#tool.drgbase_tool_faction.desc")
  panel:Help("Click on a faction to remove it from the list, or right click to copy it.")
  local dlist = DrGBase.DListView({"Factions"}, {convar = "drgbase_tool_faction_list"})
  dlist:SetSize(10, 300)
  function dlist:OnRowSelected(row)
    self:RemoveLine(row)
  end
  panel:AddItem(dlist)
  panel:Help("Insert a custom faction here:")
  local entry = vgui.Create("DTextEntry")
  function dlist:OnRowRightClick(id, line)
    entry:SetValue(line:GetValue(1))
  end
  panel:AddItem(entry)
  local insert = vgui.Create("DButton")
  insert:SetText("Insert faction")
  function insert:DoClick()
    dlist:AddLine(string.upper(entry:GetValue()))
  end
  panel:AddItem(insert)
  local clear = vgui.Create("DButton")
  clear:SetText("Clear factions")
  function clear:DoClick()
    dlist:Clear()
  end
  panel:AddItem(clear)
end

function TOOL:ClearFactions()
  if CLIENT then return end
  net.Start("DrGBaseFactionTool")
  net.WriteString("[]")
  net.Send(self:GetOwner())
end
function TOOL:SetFactions(factions)
  if CLIENT then return end
  local list = {}
  for i, faction in ipairs(factions) do
    table.insert(list, {faction})
  end
  net.Start("DrGBaseFactionTool")
  net.WriteString(util.TableToJSON(list))
  net.Send(self:GetOwner())
end

function TOOL:LeftClick(tr)
  local ent = tr.Entity
  if IsValid(ent) and ent.IsDrGNextbot then
    if SERVER then
      ent:LeaveAllFactions()
      local factions = util.JSONToTable(self:GetClientInfo("list"))
      for i, faction in ipairs(factions) do
        if not isstring(faction[1]) then continue end
        ent:JoinFaction(faction[1])
      end
    end
  elseif ent:IsWorld() then
    if SERVER then
      ent = self:GetOwner()
      ent:DrG_LeaveAllFactions()
      local factions = util.JSONToTable(self:GetClientInfo("list"))
      for i, faction in ipairs(factions) do
        if not isstring(faction[1]) then continue end
        ent:DrG_JoinFaction(faction[1])
      end
    end
  else return false end
  return true
end
function TOOL:RightClick(tr)
  local ent = tr.Entity
  if ent:IsPlayer() then
    if SERVER then self:SetFactions(ent:DrG_GetFactions()) end
  elseif ent.IsDrGNextbot then
    if SERVER then self:SetFactions(ent:GetFactions()) end
  elseif ent:IsWorld() then
    if SERVER then self:SetFactions(self:GetOwner():DrG_GetFactions()) end
  else return false end
  return true
end
function TOOL:Reload()
  if CLIENT then return true end
  self:ClearFactions()
  return true
end

if SERVER then
  util.AddNetworkString("DrGBaseFactionTool")
else
  language.Add("tool.drgbase_tool_faction.name", "Faction Tool")
	language.Add("tool.drgbase_tool_faction.desc", "Edit your factions or a nextbot's.")
	language.Add("tool.drgbase_tool_faction.0", "Right click to copy a nextbot/player's factions, left click to apply those factions to a nextbot. (aim at the ground to apply them to yourself)")

  net.Receive("DrGBaseFactionTool", function(len)
    GetConVar("drgbase_tool_faction_list"):SetString(net.ReadString())
  end)
end
