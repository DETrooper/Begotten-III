--[[
	BEGOTTEN III: Developed by DETrooper, cash wednesday, gabs & alyousha35
--]]

local PLUGIN = PLUGIN;
local icons = {
	["Ammunition"] = "briefcase",
	["Clothing"] = "user_suit",
	["Communication"] = "telephone",
	["Consumables"] = "cake",
	["Crafting Resource"] = "cog",
	["Crafting Station"] = "cog",
	["Crafting"] = "cog",
	["Deployables"] = "arrow_down",
	["Filters"] = "weather_clouds",
	["Junk"] = "box",
	["Lights"] = "lightbulb",
	["Literature"] = "book",
	["Medical"] = "heart",
	["Melee Weapons"] = "bomb",
	["Other"] = "brick",
	["Promotional"] = "coins",
	["Reusables"] = "arrow_rotate_clockwise",
	["Storage"] = "package",
	["Tools"] = "wrench",
	["Turret"] = "gun",
	["UU-Branded Items"] = "asterisk_yellow",
	["Weapons"] = "gun",
	["Workstations"] = "page",
};

spawnmenu.AddContentType("cwItem", function(container, data)
	if (!data.name) then return; end

	local icon = vgui.Create("ContentIcon", container)

	icon:SetContentType("cwItem")
	icon:SetSpawnName(data.uniqueID)
	icon:SetName(data.name)

	function icon:DoClick()
		netstream.Start("MenuItemSpawn", data.uniqueID)
	end

	function icon:OpenMenu()
		local menu = DermaMenu()
		menu:AddOption("Copy entity name to clipboard.", function()
			SetClipboardText(data.uniqueID)
		end)

		menu:AddOption("Place single instance in your inventory.", function()
			netstream.Start("MenuItemGive", data.uniqueID)
		end)
		
		menu:AddOption("Place specified amount in your inventory.", function()
			Derma_StringRequest(data.name, "How many items of this type do you want to spawn into your inventory (up to 100)", nil, function(amount)
				if tonumber(amount) then
					netstream.Start("MenuItemGive", data.uniqueID, math.min(100, tonumber(amount)));
				end
			end);
		end);

		menu:Open()
	end

	if (IsValid(container)) then
		container:Add(icon)
	end
end)

spawnmenu.AddCreationTab("Items", function()
	local base = vgui.Create("SpawnmenuContentPanel")
	local tree = base.ContentNavBar.Tree;
	local categories = {};

	vgui.Create("ItemSearchBar", base.ContentNavBar)

	for k, v in SortedPairsByMemberValue(item.GetStored(), "category") do
		if (v.isBaseItem or v.name == "Item Base") then
			continue;
		end;
		
		if (!categories[v.category]) then
			categories[v.category] = true;

			local category = tree:AddNode(v.category, icons[v.category] and ("icon16/" .. icons[v.category] .. ".png") or "icon16/brick.png")

			category.DoPopulate = function(self)
				if (self.Container) then return; end

				self.Container = vgui.Create("ContentContainer", base)
				self.Container:SetVisible(false)
				self.Container:SetTriggerSpawnlistChange(false)

				for uniqueID, itemTable in SortedPairsByMemberValue(item.GetStored(), "name") do
					if (itemTable.category == v.category) then
						spawnmenu.CreateContentIcon("cwItem", self.Container, itemTable)
					end
				end
			end

			category.DoClick = function(self)
				self:DoPopulate()
				base:SwitchPanel(self.Container)
			end
		end
	end

	local FirstNode = tree:Root():GetChildNode(0)

	if (IsValid(FirstNode)) then
		FirstNode:InternalDoClick()
	end

	PLUGIN:PopulateContent(base, tree, nil)

	return base;
end,

"icon16/script_key.png")