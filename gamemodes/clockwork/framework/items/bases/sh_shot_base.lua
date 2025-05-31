--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

local ITEM = item.New(nil, true);
	ITEM.name = "Shot Base"
	ITEM.useText = "Load"
	ITEM.useSound = false
	ITEM.category = "Shot"
	ITEM.roundsText = "Bullets"
	ITEM:AddData("Rounds", 1, true) -- default to 1 round
	ITEM.equippable = false; -- this blocks equipping the item as a melee weapon.
	ITEM.ammoMagazineSize = nil;
	ITEM.requiredReloadBelief = nil;
	
	-- A function to get the item's weight.
	function ITEM:GetItemWeight()
		return (self.weight / (self.ammoMagazineSize or 1)) * self:GetData("Rounds") or 1;
	end

	-- A function to get the item's space.
	function ITEM:GetItemSpace()
		return (self.space / (self.ammoMagazineSize or 1)) * self:GetData("Rounds") or 1;
	end
	
	-- Called whent he item entity's menu options are needed.
	function ITEM:GetEntityMenuOptions(entity, options)
		if self.ammoMagazineSize then
			local ammo = self:GetAmmoMagazine();
			
			if ammo and ammo > 0 then
				options["Unload Shot"] = {
					isArgTable = true,
					arguments = "cwItemMagazineAmmo",
					toolTip = toolTip
				};
			end;
		end;
	end;

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		if self.ammoType then
			if itemEntity and itemEntity.beingUsed then
				Schema:EasyText(player, "peru", "This item is already being used!");
				return false;
			end
			
			if player.HasBelief and self.requiredReloadBelief then
				if !player:HasBelief(self.requiredReloadBelief) then
					Schema:EasyText(player, "chocolate", "You do not have the required belief, '"..cwBeliefs:GetBeliefName(self.requiredReloadBelief).."', to load this weapon!");
					
					return false;
				end
			end

			for i, v in ipairs(player:GetWeaponsEquipped()) do
				if v and self:CanUseOnItem(player, v, false) then
					self:UseOnItem(player, v, true, itemEntity);
					return false; -- Gets taken by the UseOnItem function after a delay.
				end
			end
		end
		
		Schema:EasyText(player, "chocolate", "No valid weapon could be found for this ammo type!");
		return false;
	end
	
	function ITEM:UseOnItem(player, weaponItem, canUse, itemEntity)
		if canUse or self:CanUseOnItem(player, weaponItem, true) then
			local consumeTime = weaponItem.reloadTime or 10;
		
			if player:HasBelief("dexterity") then
				consumeTime = math.Round(consumeTime * 0.67);
			end
			
			if player.holyPowderkegActive then
				consumeTime = math.Round(consumeTime * 0.33);
			end
			
			if player:GetCharmEquipped("bandolier") then
				consumeTime = math.Round(consumeTime * 0.85);
			end

			consumeTime = math.max(consumeTime, 0.1)
			
			if weaponItem.reloadSounds then
				player:EmitSound(weaponItem.reloadSounds[1]);
			
				for i = 2, #weaponItem.reloadSounds do
					timer.Create(player:EntIndex().."reload"..i, consumeTime * ((i - 1) / #weaponItem.reloadSounds), 1, function()
						if IsValid(player) and Clockwork.player:GetAction(player) == "reloading" then
							player:EmitSound(weaponItem.reloadSounds[i]);
						end
					end);
				end
			end
			
			local weaponRaised = Clockwork.player:GetWeaponRaised(player);
			
			if weaponRaised then
				Clockwork.player:SetWeaponRaised(player, false);
			end
			
			if itemEntity then
				itemEntity.beingUsed = true;
				player.itemUsing = itemEntity;
			end
			
			player:SetLocalVar("cwProgressBarVerb", weaponItem.name);
			player:SetLocalVar("cwProgressBarItem", self.name);
			player:SetLocalVar("lastLoadedShot", self.uniqueID)
			
			Clockwork.player:SetAction(player, "reloading", consumeTime, nil, function()
				if IsValid(player) and weaponItem then
					if itemEntity and !IsValid(itemEntity) then
						Schema:EasyText(player, "peru", "The shot you were reloading no longer exists!");
						return;
					end
					
					local weaponItemAmmo = weaponItem:GetData("Ammo");
				
					if not weaponItem.usesMagazine then
						table.insert(weaponItemAmmo, self.ammoType);
						
						weaponItem:SetData("Ammo", weaponItemAmmo);
					elseif #weaponItemAmmo <= 0 then
						if self.ammoMagazineSize then
							local rounds = self:GetAmmoMagazine();
							
							if rounds and rounds > 0 then
								for j = 1, rounds do
									table.insert(weaponItemAmmo, self.ammoType);
								end

								weaponItem:SetData("Ammo", weaponItemAmmo);
							end
						else
							-- Chambered single round.
							 
							table.insert(weaponItemAmmo, self.ammoType);
							
							weaponItem:SetData("Ammo", weaponItemAmmo);
						end
					end
					
					if weaponRaised then
						Clockwork.player:SetWeaponRaised(player, true);
					end
					
					if IsValid(itemEntity) then
						itemEntity:Remove();
					else
						player:TakeItem(self, true);
					end
				end
			end);
		end
	end
	
	function ITEM:CanUseOnItem(player, weaponItem, bNotify)
		local action = Clockwork.player:GetAction(player);
		
		if (action == "reloading") then
			if bNotify then
				Schema:EasyText(player, "peru", "Your character is already reloading!");
			end
			
			return false;
		end
		
		if cwStamina and weaponItem.category == "Crossbows" then
			local stamina = player:GetCharacterData("Stamina");
			
			if stamina < 10 then
				if bNotify then
					Schema:EasyText(player, "chocolate", "You do not have enough stamina to reload this crossbow!");
				end
				
				return false;
			end
		end
		
		if weaponItem and (weaponItem.category == "Firearms" or weaponItem.category == "Crossbows") and weaponItem.ammoTypes then
			if table.HasValue(weaponItem.ammoTypes, self.ammoType) then
				local weaponItemAmmo = weaponItem:GetData("Ammo");
				
				if weaponItemAmmo and #weaponItemAmmo < weaponItem.ammoCapacity then
					if player.HasBelief and self.requiredReloadBelief then
						if !player:HasBelief(self.requiredReloadBelief) then
							if bNotify then
								Schema:EasyText(player, "chocolate", "You do not have the required belief, '"..cwBeliefs:GetBeliefName(self.requiredReloadBelief).."', to load this weapon!");
							end
							
							return false;
						end
					end
					
					if weaponItem.category == "Firearms" then
						if (player:WaterLevel() >= 3) then 
							Schema:EasyText(player, "peru", "You can't load your powder charge while underwater!");
							
							return false;
						end
						
						if cwWeather then
							local lastZone = player:GetCharacterData("LastZone");
							local zoneTable = zones:FindByID(lastZone);
							
							if zoneTable and zoneTable.hasWeather and cwWeather:IsOutside(player:EyePos()) then
								if lastZone == "wasteland" or lastZone == "tower" then
									local weather = cwWeather.weather;
									
									if weather == "acidrain" or weather == "bloodstorm" or weather == "thunderstorm" then
										Schema:EasyText(player, "peru", "You can't load your powder charge under these wet conditions!");
								
										return false;
									end
								end
							end
						end
					end
					
					if not weaponItem.usesMagazine then
						if cwStamina and weaponItem.category == "Crossbows" then
							player:HandleStamina(-10);
							player.nextStamina = CurTime() + 3;
						end
						
						return true;
					else
						if self.ammoMagazineSize and #weaponItemAmmo <= 0 then			
							local roundsLeft = self:GetAmmoMagazine();
							
							if roundsLeft and roundsLeft > 0 then
								return true;
							else
								if bNotify then
									Schema:EasyText(player, "peru", "This magazine is empty!");
								end
								
								return false;
							end
						elseif #weaponItemAmmo <= 0 then
							-- Chambered single round.
							return true;
						else
							if bNotify then
								Schema:EasyText(player, "peru", "This weapon is currently loaded with a magazine or a round in the chamber!");
							end
							
							return false;
						end
					end
				else
					if bNotify then
						Schema:EasyText(player, "peru", "This weapon is at its ammunition capacity!");
					end
					
					return false;
				end
			else
				if bNotify then
					Schema:EasyText(player, "peru", "This weapon cannot use this ammunition type!");
				end
				
				return false;
			end
		else
			if bNotify then
				Schema:EasyText(player, "peru", "This weapon cannot take ammunition!");
			end
			
			return false;
		end
	end
	
	function ITEM:UseOnMagazine(player, magazineItem)
		if magazineItem and magazineItem.category == "Shot" and magazineItem.ammoMagazineSize then
			if magazineItem.ammoName == self.ammoName then
				local magazineItemAmmo = magazineItem:GetAmmoMagazine();
				
				if magazineItemAmmo and magazineItemAmmo < magazineItem.ammoMagazineSize then
					if magazineItem.SetAmmoMagazine then
						if SERVER then
							magazineItem:SetAmmoMagazine(magazineItemAmmo + 1);
							player:EmitSound("weapons/request day of defeat/m1903 springfield clipin.wav", 60, math.random(98, 102));
						end
						
						return true;
					end
				else
					Schema:EasyText(player, "peru", "This magazine is currently full!");
					return false;
				end
			else
				Schema:EasyText(player, "peru", "This magazine is not the correct ammo type for this round!");
				return false;
			end
		else
			Schema:EasyText(player, "chocolate", "You must load this round into a suitable magazine or weapon!");
			return false;
		end
	end
	
	function ITEM:TakeFromMagazine(player)
		if IsValid(player) and self.ammoMagazineSize then
			local itemAmmo = self:GetAmmoMagazine();

			if itemAmmo and itemAmmo > 0 then
				local ammoItemID = string.gsub(string.lower(self.ammoName), " ", "_");
				local ammoItem = item.CreateInstance(ammoItemID);
				
				if ammoItem then
					self:SetAmmoMagazine(itemAmmo - 1);
					player:EmitSound("weapons/m1911/handling/m1911_boltback.wav", 60, math.random(98, 102), 0.7);
					player:GiveItem(ammoItem);
				end
				
				return;
			end
			
			Schema:EasyText(player, "peru", "This magazine has no ammo to unload!");
			return;
		end
	end

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end

	if (SERVER) then
		function ITEM:OnGenerated()
			self:SetData("Rounds", self.ammoMagazineSize)
		end
	else
		function ITEM:GetClientSideInfo()
			return Clockwork.kernel:AddMarkupLine("", "Rounds: "..self.ammoMagazineSize)
		end
	end
	
	function ITEM:GetAmmoMagazine()
		if self.ammoMagazineSize then
			-- Item is magazine.
			local rounds = self:GetData("Rounds");
			
			if (rounds) then
				return rounds;
			else
				return self.ammoMagazineSize;
			end;
		end;
	end;
	
	function ITEM:SetAmmoMagazine(amount)
		if self.ammoMagazineSize then
			if amount and self.SetData then
				self:SetData("Rounds", amount);
			end
		end;
	end
	
	ITEM:AddQueryProxy("ammoMagazineSize", ITEM.GetAmmoMagazine)
ITEM:Register()