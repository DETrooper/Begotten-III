
-- Registry --

function DrGBase.AddWeapon(SWEP)
  local class = string.Replace(SWEP.Folder, "weapons/", "")
  if SWEP.PrintName == nil or SWEP.Category == nil then return end
  if CLIENT then
    language.Add(class, SWEP.PrintName)
    SWEP.Killicon = SWEP.Killicon or {
      icon = "HUD/killicons/default",
      color = Color(255, 80, 0, 255)
    }
    killicon.Add(class, SWEP.Killicon.icon, SWEP.Killicon.color)
  else resource.AddFile("materials/weapons/"..class..".png") end
  list.Set("DrGBaseWeapons", class, {
    Name = SWEP.PrintName,
    Class = class,
    Category = SWEP.Category
  })
  DrGBase.Print("Weapon '"..class.."': loaded.")
end

hook.Add("PopulateDrGBaseSpawnmenu", "AddDrGBaseWeapons", function(pnlContent, tree, node)
	local list = list.Get("DrGBaseWeapons")
	local categories = {}
	for class, ent in pairs(list) do
		local category = ent.Category or "Other"
		local tab = categories[category] or {}
		tab[class] = ent
		categories[category] = tab
	end
	local weaponsTree = tree:AddNode("Weapons", "icon16/gun.png")
	for categoryName, category in SortedPairs(categories) do
		local icon = DrGBase.GetIcon(categoryName) or "icon16/gun.png"
		if categoryName == "DrGBase" then icon = DrGBase.Icon end
		local node = weaponsTree:AddNode(categoryName, icon)
		node.DoPopulate = function(self)
			if self.PropPanel then return end
			self.PropPanel = vgui.Create("ContentContainer", pnlContent)
			self.PropPanel:SetVisible(false)
			self.PropPanel:SetTriggerSpawnlistChange(false)
			for class, ent in SortedPairsByMemberValue(category, "Name") do
				spawnmenu.CreateContentIcon("weapon", self.PropPanel, {
					nicename	= ent.Name or class,
					spawnname	= class,
					material	= "entities/"..class..".png",
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

-- Misc --

local PlayersCanGiveWeapons = CreateConVar("drgbase_give_weapons", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED})

properties.Add("drgbasegiveweapons", {
	MenuLabel = "Give Current Weapon",
	Order = 1001,
	MenuIcon = "icon16/gun.png",
	Filter = function(self, ent, ply)
    return ent.IsDrGNextbot and
    ent.UseWeapons and
    ent.AcceptPlayerWeapons and
		PlayersCanGiveWeapons:GetBool()
	end,
	Action = function(self, ent)
    self:MsgStart()
    net.WriteEntity(ent)
    self:MsgEnd()
  end,
	Receive = function(self, len, ply)
		local ent = net.ReadEntity()
    if not IsValid(ent) then return end
    local wep = ply:GetActiveWeapon()
    ent:SetActiveWeapon(ent:GiveWeapon(wep:GetClass()))    
	end
})

properties.Add("drgbasestripweapons", {
	MenuLabel = "Strip Weapon",
	Order = 1002,
	MenuIcon = "icon16/gun.png",
	Filter = function(self, ent, ply)
    return ent.IsDrGNextbot and
    ent.UseWeapons and
    ent.AcceptPlayerWeapons and
		PlayersCanGiveWeapons:GetBool()
	end,
	Action = function(self, ent)
    self:MsgStart()
    net.WriteEntity(ent)
    self:MsgEnd()
  end,
	Receive = function(self, len, ply)
		local ent = net.ReadEntity()
    if not IsValid(ent) then return end
    ent:RemoveWeapon()
	end
})
