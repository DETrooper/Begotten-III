if SERVER then return end

function DrGBase.GetIcon(name)
  return list.Get("DrGBaseIcons")[name]
end
function DrGBase.SetIcon(name, icon)
  list.Set("DrGBaseIcons", name, icon)
end
DrGBase.SetIcon("DrGBase", DrGBase.Icon)

-- Creation Tab --

spawnmenu.AddCreationTab("DrGBase", function()
  local ctrl = vgui.Create("SpawnmenuContentPanel")
  ctrl:EnableSearch("drgbase", "PopulateDrGBaseSpawnmenu")
  ctrl:CallPopulateHook("PopulateDrGBaseSpawnmenu")
  return ctrl
end, DrGBase.Icon, 75, "Every addon made using DrGBase.")

search.AddProvider(function(str)
	str = str:PatternSafe()
	local results = {}
	for class, ent in pairs(list.Get("DrGBaseNextbots")) do
    if #results >= 128 then break end
		if string.find(string.lower(ent.Name), string.lower(str)) ~= nil or
		string.find(string.lower(class), string.lower(str)) ~= nil then
			table.insert(results, {
				text = ent.Name or class,
				icon = spawnmenu.CreateContentIcon("npc", nil, {
					nicename = ent.Name or class,
					spawnname = class,
					material = "entities/"..class..".png",
					admin = ent.AdminOnly
				}),
				words = {ent}
			})
		end
	end
	for class, ent in pairs(list.Get("DrGBaseSpawners")) do
    if #results >= 128 then break end
		if string.find(string.lower(ent.Name), string.lower(str)) ~= nil or
		string.find(string.lower(class), string.lower(str)) ~= nil then
			table.insert(results, {
				text = ent.Name or class,
				icon = spawnmenu.CreateContentIcon("npc", nil, {
					nicename = ent.Name or class,
					spawnname = class,
					material = "entities/"..class..".png",
					admin = ent.AdminOnly
				}),
				words = {ent}
			})
		end
	end
	table.SortByMember(results, "text", true)
	return results
end, "drgbase")

-- Tool Tab --

hook.Add("AddToolMenuTabs", "DrGBaseToolMenu", function()
  spawnmenu.AddToolTab("DrGBase", "DrGBase", DrGBase.Icon)
end)

hook.Add("PopulateToolMenu", "DrGBaseToolMenu", function()
  -- Main Menu --
  --[[spawnmenu.AddToolMenuOption("DrGBase", "Main Menu", "drgbase_mm_about", "About", "", "", function(panel)
    panel:ClearControls()

  end)
  spawnmenu.AddToolMenuOption("DrGBase", "Main Menu", "drgbase_mm_list_nextbot", "Nextbot List", "", "", function(panel)
    panel:ClearControls()

  end)]]
  -- Nextbot Settings --
  spawnmenu.AddToolMenuOption("DrGBase", "Nextbot Settings", "drgbase_nb_settings_ai", "AI Settings", "", "", function(panel)
    panel:ClearControls()
    panel:ControlHelp("\nDetection")
    panel:NumSlider("Target distance", "drgbase_ai_radius", 0, 50000, 0)
    panel:CheckBox("Enable omniscience", "drgbase_ai_omniscient")
    panel:CheckBox("Enable sight", "drgbase_ai_sight")
    panel:CheckBox("Enable hearing", "drgbase_ai_hearing")
    panel:CheckBox("Enable patrol", "drgbase_ai_patrol")
    panel:ControlHelp("\nWeapons")
    panel:CheckBox("Players can give weapons", "drgbase_give_weapons")
  end)
  spawnmenu.AddToolMenuOption("DrGBase", "Nextbot Settings", "drgbase_nb_settings_possession", "Possession", "", "", function(panel)
    panel:ClearControls()
    panel:ControlHelp("\nServer Settings")
    panel:CheckBox("Enable possession", "drgbase_possession_enable")
    panel:ControlHelp("\nClient Settings")
    panel:AddControl("numpad", {
      label = "Exit possession",
      command = "drgbase_possession_exit",
      label2 = "Cycle views",
      command2 = "drgbase_possession_view"
    })
    panel:AddControl("numpad", {
      label = "Climb",
      command = "drgbase_possession_climb",
      label2 = "Lock on",
      command2 = "drgbase_possession_lockon"
    })
    panel:NumSlider("Lock on speed", "drgbase_possession_lockon_speed", 0.01, 1, 2)
    panel:CheckBox("Teleport on dispossess", "drgbase_possession_teleport")
  end)
  spawnmenu.AddToolMenuOption("DrGBase", "Nextbot Settings", "drgbase_nb_settings_misc", "Misc", "", "", function(panel)
    panel:ClearControls()
    panel:ControlHelp("\nStats")
    panel:NumSlider("Health multiplier", "drgbase_multiplier_health", 0.1, 10, 1)
    panel:NumSlider("Player damage multiplier", "drgbase_multiplier_damage_players", 0.1, 10, 1)
    panel:NumSlider("NPC damage multiplier", "drgbase_multiplier_damage_npc", 0.1, 10, 1)
    panel:NumSlider("Speed multiplier", "drgbase_multiplier_speed", 0.1, 10, 1)
    panel:ControlHelp("\nRagdolls")
    panel:NumSlider("Remove ragdolls", "drgbase_remove_ragdolls", -1, 180, 0)
    panel:NumSlider("Ragdoll fadeout", "drgbase_ragdoll_fadeout", 0, 10, 1)
    panel:CheckBox("Also remove 'dead' nextbots", "drgbase_remove_dead")
    panel:CheckBox("Disable ragdoll collisions", "drgbase_ragdoll_collisions_disabled")
    panel:ControlHelp("\nPathfinding")
    panel:NumSlider("Compute delay", "drgbase_compute_delay", 0.01, 3, 2)
    panel:CheckBox("Avoid obstacles", "drgbase_avoid_obstacles")
  end)
end)
