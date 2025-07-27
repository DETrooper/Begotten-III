--[[
	Begotten III: Jesus Wept
--]]


--[[function cwForceFeeding:GetEntityMenuOptions(entity, options)
	if Clockwork.Client:IsWeaponRaised() then return end;

	if (entity:GetClass() == "prop_ragdoll") then
		local player = Clockwork.entity:GetPlayer(entity);

		if player and player:Alive() then
			entity = player;
		end;
	end
	
	if entity:IsPlayer() and entity:Alive() and entity:GetNetVar("tied") != 0 then
		local inventoryList = Clockwork.inventory:GetAsItemsList(Clockwork.inventory:GetClient());
		
		for k, itemTable in pairs (inventoryList) do
			if options["Force Feed"] and options["Force Feed"][itemTable.name] then continue end;
		
			local category = itemTable.category;
		
			if category == "Food" or category == "Drinks" or category == "Alcohol" then
				if !options["Force Feed"] then
					options["Force Feed"] = {}
				end;
				
				options["Force Feed"][itemTable.name] = function()
					Clockwork.inventory:InventoryAction("force_feeding", itemTable.uniqueID, itemTable.itemID);
				end;
			end
		end
	end;
end;]]--

-- Called when the post progress bar info is needed.
function cwForceFeeding:GetProgressBarInfoAction(action, percentage)
	if (action == "force_feeding") then
		return {text = "You are force feeding somebody. Click to cancel.", percentage = percentage, flash = percentage > 75};
	end;
end;

-- Called to get the screen text info.
function cwForceFeeding:GetScreenTextInfo()
	local blackFadeAlpha = Clockwork.kernel:GetBlackFadeAlpha();
	
	if (Clockwork.Client:GetNetVar("beingForceFed")) then
		return {
			alpha = 255 - blackFadeAlpha,
			title = "SOMEBODY IS FORCE FEEDING YOU"
		};
	end;
end;

-- Called when the local player's item menu should be adjusted.
function cwForceFeeding:PlayerAdjustItemMenu(itemTable, menuPanel, itemFunctions)
	local category = itemTable.category;
	
	if category == "Food" or category == "Drinks" or category == "Alcohol" then
		local entity = Clockwork.Client:GetEyeTrace().Entity;
		
		if IsValid(entity) and (entity:IsPlayer() or Clockwork.entity:GetPlayer(entity)) then
			menuPanel:AddOption(string.gsub("Force Feed", "^.", string.upper), function()
				Clockwork.inventory:InventoryAction("force_feeding", itemTable.uniqueID, itemTable.itemID);
			end);
		end
	end;
end;