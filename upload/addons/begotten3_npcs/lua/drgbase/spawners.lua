
-- Registry --

function DrGBase.AddSpawner(ENT)
  local class = string.Replace(ENT.Folder, "entities/", "")
  if ENT.PrintName == nil or ENT.Category == nil then return false end
  if SERVER then resource.AddFile("materials/entities/"..class..".png")
  else language.Add(class, ENT.PrintName) end
  local spawner = {
    Name = ENT.PrintName,
    Class = class,
    Category = ENT.Category
  }
  if ENT.Spawnable ~= false then
    list.Set("NPC", class, spawner)
    list.Set("DrGBaseSpawners", class, spawner)
  end
  DrGBase.Print("Spawner '"..class.."': loaded.")
  return true
end

hook.Add("PopulateDrGBaseSpawnmenu", "AddDrGBaseSpawners", function(pnlContent, tree, node)
	local list = list.Get("DrGBaseSpawners")
	local categories = {}
	for class, ent in pairs(list) do
		local category = ent.Category or "Other"
		local tab = categories[category] or {}
		tab[class] = ent
		categories[category] = tab
	end
	local nextbotsTree = tree:AddNode("Spawners", "icon16/box.png")
	for categoryName, category in SortedPairs(categories) do
		local icon = DrGBase.GetIcon(categoryName) or "icon16/box.png"
		if categoryName == "DrGBase" then icon = DrGBase.Icon end
		local node = nextbotsTree:AddNode(categoryName, icon)
		node.DoPopulate = function(self)
			if self.PropPanel then return end
			self.PropPanel = vgui.Create("ContentContainer", pnlContent)
			self.PropPanel:SetVisible(false)
			self.PropPanel:SetTriggerSpawnlistChange(false)
			for class, ent in SortedPairsByMemberValue(category, "Name") do
				spawnmenu.CreateContentIcon("npc", self.PropPanel, {
					nicename	= ent.Name or class,
					spawnname	= class,
					material = "entities/"..class..".png",
					admin	= ent.AdminOnly or false
				})
			end
		end
		node.DoClick = function(self)
			self:DoPopulate()
			pnlContent:SwitchPanel(self.PropPanel)
		end
	end
	local firstNode = tree:Root():GetChildNode(0)
	if IsValid(firstNode) then
		firstNode:InternalDoClick()
	end
end)

if SERVER then

  function DrGBase.CreateSpawner(pos, tospawn, radius, quantity, class)
    local spawner = ents.Create(class or "spwn_drg_default")
    if not IsValid(spawner) then return NULL end
    if isvector(pos) then spawner:SetPos(pos) end
    spawner:Spawn()
    spawner:SetRadius(radius)
    spawner:SetQuantity(quantity)
    if istable(tospawn) then
      for class, nb in pairs(tospawn) do
        spawner:AddToSpawn(class, nb)
      end
    else spawner:AddToSpawn(tospawn) end
    return spawner
  end

end
