local PLUGIN = PLUGIN or {}
PLUGIN.name = "The Damnation"
PLUGIN.author = "zigbomb"
PLUGIN.description = "Cleans up unused item instances to reduce memory leaks."

if CLIENT then
	hook.Add("ClockworkInitialized", "StartCleanupUnusedItemInstances", function()
		timer.Create("CleanupUnusedItemInstances", 60, 0, function()
			local validInventory = Clockwork.inventory:GetClient()
			local validItemIDs = {}
			local totalInstances = table.Count(item.GetInstances())
			local removed = 0

			if not validInventory then
				print("[INSTANCE GC] Inventory not ready — skipping cleanup.")
				return
			end

			for _, item in pairs(Clockwork.inventory:GetItemsAsList(validInventory)) do
				validItemIDs[item.itemID] = true
			end

			for itemID, instance in pairs(item.GetInstances()) do
				if not validItemIDs[itemID] then
					item.RemoveInstance(itemID, true)
					removed = removed + 1
				end
			end

			local remaining = table.Count(item.GetInstances())

			print(string.format(
				"[INSTANCE GC] Total before: %d | Removed: %d | Remaining: %d",
				totalInstances, removed, remaining
			))
		end)
	end)
end
