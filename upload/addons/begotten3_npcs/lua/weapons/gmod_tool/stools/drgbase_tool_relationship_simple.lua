TOOL.Tab = "DrGBase"
TOOL.Category = "Tools"
TOOL.Name = "#tool.drgbase_tool_relationship_simple.name"
TOOL.ClientConVar = {
	["disposition"] = 1,
	["bothways"] = 0
}
TOOL.BuildCPanel = function(panel)
	panel:Help("#tool.drgbase_tool_relationship_simple.desc")
	panel:Help("#tool.drgbase_tool_relationship_simple.0")
	panel:ControlHelp("\nOptions\n")
	local combo = panel:ComboBox("Relationship", "drgbase_tool_relationship_simple_disposition")
	combo:AddChoice("Like", 3)
	combo:AddChoice("Hate", 1)
	combo:AddChoice("Fear", 2)
	combo:AddChoice("Ignore", 4)
	panel:CheckBox("Both ways", "drgbase_tool_relationship_simple_bothways")
	panel:Help("If both ways, it will set the same relationship on the other entity.")
end

function TOOL:LeftClick(tr)
	if not IsValid(tr.Entity) then return false end
	if not tr.Entity.IsDrGNextbot and
	not tr.Entity:IsNPC() then return false end
	if CLIENT then return true end
	self:GetOwner():DrG_CleverEntitySelect(tr.Entity)
	return true
end
function TOOL:RightClick(tr)
	if not IsValid(tr.Entity) and not tr.Entity:IsWorld() then return false end
	if CLIENT then return true end
	if tr.Entity:IsWorld() then tr.Entity = self:GetOwner() end
	local disp = self:GetClientNumber("disposition")
	if self:GetOwner():KeyDown(IN_SPEED) then
		for ent in self:GetOwner():DrG_SelectedEntities() do
			for ent2 in self:GetOwner():DrG_SelectedEntities() do
				if ent == ent2 then continue end
				if ent.IsDrGNextbot then
					ent:_SetRelationship(ent2, disp)
				elseif ent:IsNPC() then
					ent:DrG_SetRelationship(ent2, disp)
				end
			end
		end
	else
		for ent in self:GetOwner():DrG_SelectedEntities() do
			if ent.IsDrGNextbot then
				ent:_SetRelationship(tr.Entity, disp)
			elseif ent:IsNPC() then
				ent:DrG_SetRelationship(tr.Entity, disp)
			end
		end
	end
	return true
end
function TOOL:Reload(tr)
	if CLIENT then return true end
	self:GetOwner():DrG_ClearSelectedEntities()
	return true
end

if CLIENT then
	language.Add("tool.drgbase_tool_relationship_simple.name", "Set Relationship")
	language.Add("tool.drgbase_tool_relationship_simple.desc", "Change relationship of a nextbot towards an entity.")
	language.Add("tool.drgbase_tool_relationship_simple.0", "Left click to select/deselect a nextbot/NPC (hold shift to select multiple entities), right click to set the relationship towards an entity (aim at the ground to set the relationship towards yourself) and reload to clear the list of selected entities.")

	hook.Add("DrawDRGBaseHalos", "DrGBaseToolRelationshipHalos", function(ply, mode)
		if mode ~= "drgbase_tool_relationship_simple" then return end
		local allies = {}
		local enemies = {}
		local afraid = {}
		local neutrals = {}
		local errors = {}
		for selected in ply:DrG_SelectedEntities() do
			if selected.IsDrGNextbot then
				local disp = selected:LocalPlayerRelationship()
				if disp == D_LI then table.insert(allies, selected)
				elseif disp == D_HT then table.insert(enemies, selected)
				elseif disp == D_FR then table.insert(afraid, selected)
				elseif disp == D_NU then table.insert(neutrals, selected)
				else table.insert(errors, selected) end
			else table.insert(errors, selected) end
		end
		halo.Add(allies, DrGBase.CLR_GREEN)
		halo.Add(enemies, DrGBase.CLR_RED)
		halo.Add(afraid, DrGBase.CLR_PURPLE)
		halo.Add(neutrals, DrGBase.CLR_CYAN)
		halo.Add(errors, DrGBase.CLR_ORANGE)
	end)
end
