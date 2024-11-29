--[[
	BEGOTTEN III: Developed by DETrooper, cash wednesday, gabs & alyousha35
--]]

local PLUGIN = PLUGIN;
local icons = {
	["Alcohol"] = "begotten/ui/itemicons/beer.png",
	["Armor"] = "begotten/ui/itemicons/auxiliary_gambeson.png",
	["Backpacks"] = "begotten/ui/itemicons/backpack.png",
	["Catalysts"] = "begotten/ui/itemicons/belphegor_catalyst.png",
	["Charms"] = "begotten/ui/itemicons/ring_distorted.png",
	["Communication"] = "begotten/ui/itemicons/warhorn.png",
	["Crafting Materials"] = "begotten/ui/itemicons/scrap.png",
	["Crossbows"] = "begotten/ui/itemicons/crossbow.png",
	["Drinks"] = "begotten/ui/itemicons/cold_pop.png",
	["Food"] = "begotten/ui/itemicons/neat_yummy_meat.png",
	["Firearms"] = "begotten/ui/itemicons/corpsecrank.png",
	["Fuel"] = "begotten/ui/itemicons/small_oil.png",
	["Helms"] = "begotten/ui/itemicons/gatekeeper_helmet.png",
	["Lights"] = "begotten/ui/itemicons/lantern.png",
	["Medical"] = "begotten/ui/itemicons/survival_pack.png",
	["Melee"] = "begotten/ui/itemicons/gore_axe_falchion.png",
	["Naval"] = "begotten/ui/itemicons/scroll_open.png",
	["Other"] = "begotten/ui/itemicons/yumchug.png",
	["Scripture"] = "begotten/ui/itemicons/scroll_open2.png",
	["Shields"] = "begotten/ui/itemicons/gatekeeper_shield.png",
	["Shot"] = "begotten/ui/itemicons/grapeshot.png",
	["Throwables"] = "begotten/ui/itemicons/throwing_axe.png",
	["Tools"] = "begotten/ui/itemicons/breakdown_kit.png",
};

spawnmenu.AddContentType("cwItem", function(container, data)
	if (!data.name) then return; end

	local icon = vgui.Create("ContentIcon", container)

	icon:SetContentType("cwItem")
	icon:SetSpawnName(data.uniqueID)
	icon:SetName(data.name)
	icon:SetMaterial(data.iconoverride or "begotten/ui/itemicons/yumchug.png");

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
		if (!categories[v.category]) then
			if (v.isBaseItem or v.name == "Item Base") then
				continue;
			end;
		
			categories[v.category] = true;

			local category = tree:AddNode(v.category, icons[v.category] or "icon16/brick.png")

			category.DoPopulate = function(self)
				if (self.Container) then return; end

				self.Container = vgui.Create("ContentContainer", base)
				self.Container:SetVisible(false)
				self.Container:SetTriggerSpawnlistChange(false)

				for uniqueID, itemTable in SortedPairsByMemberValue(item.GetStored(), "name") do
					if (itemTable.isBaseItem or itemTable.name == "Item Base") then
						continue;
					end;
				
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
end, "icon16/script_key.png")