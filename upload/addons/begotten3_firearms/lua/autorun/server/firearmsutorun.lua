hook.Add("KeyPress", "KeyPressFirearms", function(ply, key)
	if key == IN_RELOAD then
		local activeWeapon = ply:GetActiveWeapon();
		
		if IsValid(activeWeapon) and activeWeapon.Base == "begotten_firearm_base" then
			activeWeapon.ReloadKeyTime = CurTime();
		end
	end
end);

hook.Add("KeyRelease", "KeyReleaseFirearms", function(ply, key)
	if key == IN_RELOAD then
		local activeWeapon = ply:GetActiveWeapon();
		
		if IsValid(activeWeapon) and activeWeapon.Base == "begotten_firearm_base" and ply:Alive() then
			if (Clockwork.player:GetAction(ply) == "reloading") then
				Schema:EasyText(ply, "peru", "Your character is already reloading!");
				
				return;
			end
			
			local curTime = CurTime();
		
			if activeWeapon.ReloadKeyTime and curTime - activeWeapon.ReloadKeyTime > 0.2 then
				if (action == "reloading") then
					Schema:EasyText(ply, "peru", "Your character is already reloading!");
					
					return;
				end
					
				netstream.Start(ply, "ReloadMenu", true);
				activeWeapon.ReloadKeyTime = nil;
			else
				activeWeapon.ReloadKeyTime = nil;
				
				local firearmItemTable = item.GetByWeapon(activeWeapon);
				
				if !firearmItemTable then return end;
				if !firearmItemTable.ammoTypes then return end;
				
				local inventory = ply:GetInventory();
				
				if !inventory then return end;
				
				local lastLoadedShot = ply.lastLoadedShot;
				
				if lastLoadedShot then
					local itemTable = item.FindByID(lastLoadedShot);
					
					if itemTable then
						local itemInstances = inventory[itemTable.uniqueID] or {};
						local validItemInstances = {};
						
						for k, v in pairs(itemInstances) do
							if !v.ammoMagazineSize or v:GetAmmoMagazine() > 0 then
								table.insert(validItemInstances, v);
							end
						end
						
						if !table.IsEmpty(validItemInstances) then
							local randomItem = table.Random(itemInstances);
							
							if randomItem:CanUseOnItem(ply, firearmItemTable, true) then
								randomItem:UseOnItem(ply, firearmItemTable, true);
							end
							
							return;
						end
					end
				end
				
				-- Select a random ammo type if a previous one has not been found.
				for i, v in RandomPairs(firearmItemTable.ammoTypes) do
					local itemTable = item.FindByID(string.lower(v));
					
					if itemTable then
						if firearmItemTable.usesMagazine and !itemTable.ammoMagazineSize then continue end;
						
						local itemInstances = inventory[itemTable.uniqueID] or {};
						local validItemInstances = {};
						
						for k2, v2 in pairs(itemInstances) do
							if !v2.ammoMagazineSize or v2:GetAmmoMagazine() > 0 then
								table.insert(validItemInstances, v2);
							end
						end
						
						if !table.IsEmpty(validItemInstances) then
							local randomItem = table.Random(itemInstances);
							
							if randomItem:CanUseOnItem(ply, firearmItemTable, true) then
								randomItem:UseOnItem(ply, firearmItemTable, true);
							end
							
							return;
						end
					end
				end

				-- Go over again for magazined firearms to select single shots if no magazines are found.
				if firearmItemTable.usesMagazine then
					for i, v in RandomPairs(firearmItemTable.ammoTypes) do
						local itemTable = item.FindByID(string.lower(v));
						
						if itemTable then
							local itemInstances = inventory[itemTable.uniqueID] or {};
							local validItemInstances = {};
							
							for k2, v2 in pairs(itemInstances) do
								if !v2.ammoMagazineSize or v2:GetAmmoMagazine() > 0 then
									table.insert(validItemInstances, v2);
								end
							end
							
							if !table.IsEmpty(validItemInstances) then
								local randomItem = table.Random(itemInstances);
								
								if randomItem:CanUseOnItem(ply, firearmItemTable, true) then
									randomItem:UseOnItem(ply, firearmItemTable, true);
								end
								
								return;
							end
						end
					end
				end
				
				Schema:EasyText(ply, "chocolate", "No valid ammo could be found for this weapon!");
			end
		end
	end
end);