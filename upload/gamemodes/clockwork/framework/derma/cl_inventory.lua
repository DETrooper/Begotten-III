local Clockwork = Clockwork;
local pairs = pairs;
local ScrH = ScrH;
local ScrW = ScrW;
local table = table;
local vgui = vgui;
local math = math;

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	self:SetSize(740, 800);
	self:SetName("Inventory");
	self:Receiver("invdummy", nil);
	
	self.characterEquipmentFrames = vgui.Create("DImage", self);
	self.characterEquipmentFrames:SetSize(740, 488);
	self.characterEquipmentFrames:SetImage("begotten/ui/equipment.png");
	
	self.categoryLocations = {
		["Helms"] = {x = 110, y = 48, receiver = nil, occupier = nil},
		["Armor"] = {x = 110, y = 157, receiver = nil, occupier = nil},
		["Backpacks"] = {x = 110, y = 266, receiver = nil, occupier = nil},
		["Charm1"] = {x = 110, y = 375, receiver = nil, occupier = nil},
		["Primary"] = {x = 566, y = 48, receiver = nil, occupier = nil},
		["Secondary"] = {x = 566, y = 157, receiver = nil, occupier = nil},
		["Tertiary"] = {x = 566, y = 266, receiver = nil, occupier = nil},
		["Charm2"] = {x = 566, y = 375, receiver = nil, occupier = nil},
	};
	
	for k, v in pairs(self.categoryLocations) do
		v.receiver = vgui.Create('DPanel', self);
	
		if v.receiver then
			v.receiver:SetSize(64, 64);
			v.receiver:SetPos(v.x, v.y);
			
			local receiverName = k;
			
			if k == "Primary" or k == "Secondary" or k == "Tertiary" then
				receiverName = "weaponSlot";
			elseif k == "Charm1" or k == "Charm2" then
				receiverName = "Charms";
			end
			
			v.receiver:Receiver(receiverName, function(self, panels, dropped, menuIndex, x, y)
				if (dropped) then
					local panel = panels[1];
					
					if panel then
						local parent = panel:GetParent();

						if parent and parent.itemData and parent.itemTable then
							if (parent.itemData.OnPress) then
								parent.itemData.OnPress();
								return;
							end;

							Clockwork.kernel:HandleItemSpawnIconRightClick(parent.itemTable, spawnIcon);
						end
					end
				end
			end);
		end
	end
	
	self.characterModel = vgui.Create("cwCharacterModel", self);
	self.characterModel:SetPos(190, 0);
	self.characterModel:SetSize(360, 488);
	
	self.coinIcon = vgui.Create("DImage", self);
	self.coinIcon:SetImage("begotten/ui/othericons/coin.png");
	self.coinIcon:SetSize(50, 50);
	self.coinIcon:SetImageColor(Color(255, 255, 255, 200));
	self.coinIcon:SetPos(100, 442);
	self.coin = vgui.Create("DLabel", self);
	self.coin:SetPos(150, 452);
	self.coin:SetText(tostring(Clockwork.player:GetCash() or 0));
	self.coin:SetTextColor(Color(203, 195, 185, 200));
	self.coin:SetFont(Clockwork.option:GetFont("menu_text_small"));
	self.coin:SizeToContents();
	
	self.inventoryList = vgui.Create("DPanelList", self);
 	self.inventoryList:SetPadding(8);
 	self.inventoryList:SetSpacing(8);

	Clockwork.inventory.panel = self;
	Clockwork.inventory.panel:Rebuild();
	
	self.inventoryList:EnableVerticalScrollbar(true);
end;

function PANEL:DoDrop(self, panels, bDoDrop, Command, x, y)
	if (bDoDrop) then
		for k, v in pairs (panels) do
			self:AddItem(v);
		end
	end
end

-- Called to by the menu to get the width of the panel.
function PANEL:GetMenuWidth()
	return 740;
end;

-- A function to handle unequipping for the panel.
function PANEL:HandleUnequip(itemTable)
	if (itemTable.OnHandleUnequip) then
		itemTable:OnHandleUnequip(
		function(arguments)
			if (arguments) then
				Clockwork.datastream:Start("UnequipItem", {itemTable("uniqueID"), itemTable("itemID"), arguments});
			else
				Clockwork.datastream:Start("UnequipItem", {itemTable("uniqueID"), itemTable("itemID")});
			end;
		end);
	else
		Clockwork.datastream:Start("UnequipItem", {itemTable("uniqueID"), itemTable("itemID")});
	end;
end;

-- A function to rebuild the panel.
function PANEL:Rebuild()
	self.inventoryList:Clear();
	
	if not self.equipmentIconList then
		self.equipmentIconList = {};
	end

	for k, v in pairs(self.equipmentIconList) do
		v:Remove();
	end
	
	for k, v in pairs(self.categoryLocations) do
		v.occupier = nil;
	end
	
	local coin = Clockwork.player:GetCash() or 0;
	local cycle;
	local playerModel = Clockwork.Client:GetModel();
	local playerSkin = Clockwork.Client:GetSkin();
	local playerBodygroups = {Clockwork.Client:GetBodygroup(0), Clockwork.Client:GetBodygroup(1)};
	local headModel;
	local weapons = {};
	local weapon1;
	local weapon2;
	local weapon3;
	
	if IsValid(self.characterModel) then
		if IsValid(self.characterModel.modelPanel.Entity) then
			cycle = self.characterModel.modelPanel.Entity:GetCycle();
		end
	end
	
	if string.find(playerModel, "models/begotten/heads") then
		headModel = playerModel;
		
		local clothesItem = Clockwork.Client:GetClothesEquipped();
		local factionTable = Clockwork.faction:FindByID(Clockwork.Client:GetFaction());
		local gender = string.lower(Clockwork.Client:GetGender());

		if clothesItem and clothesItem.group then
			if clothesItem.genderless then
				playerModel = "models/begotten/"..clothesItem.group..".mdl";
			else
				playerModel = "models/begotten/"..clothesItem.group.."_"..string.lower(gender)..".mdl";
			end
		elseif factionTable then
			playerModel = factionTable.models[gender].clothes;
		
			local subfaction = Clockwork.Client:GetSharedVar("subfaction");
			
			if subfaction and factionTable.subfactions then
				for i, v in ipairs(factionTable.subfactions) do
					if v.models and v.name == subfaction then
						playerModel = v.models[gender].clothes;
						
						break;
					end
				end
			end
		end
	end
	
	self.coin:SetText(tostring(coin));
	self.coin:SizeToContents();
	
	self.itemList = vgui.Create("DPanelList", self.inventoryList);
 	self.itemList:SetPadding(8);
 	self.itemList:SetSpacing(8);
	self.itemList:SetPaintBackground(false);
	
	self.inventoryList:Receiver("inventory", function(self, panels, dropped, menuIndex, x, y)
		if (dropped) then
			local panel = panels[1];
			
			if panel then
				local parent = panel:GetParent();

				if parent and parent.itemData and parent.itemTable then
					--PANEL:HandleUnequip(parent.itemTable);
					Clockwork.datastream:Start("UnequipItem", {parent.itemTable("uniqueID"), parent.itemTable("itemID")});
				end
			end
		end
	end);
	
	self.weightForm = vgui.Create("DForm", self);
	self.weightForm:SetPadding(4);
	self.weightForm:SetSpacing(4);
	self.weightForm:SetName("Weight");
	self.weightForm:AddItem(vgui.Create("cwInventoryWeight", self));

	if (Clockwork.inventory:UseSpaceSystem()) then
		self.spaceForm = vgui.Create("DForm", self);
		self.spaceForm:SetPadding(4);
		self.spaceForm:SetSpacing(4);
		self.spaceForm:SetName("Space");
		self.spaceForm:AddItem(vgui.Create("cwInventorySpace", self));
	end

	local itemsList = {inventory = {}, equipment = {}};
	local categories = {inventory = {}, equipment = {}};
	
	for k, v in pairs(Clockwork.Client:GetWeapons()) do
		local itemTable = Clockwork.item:GetByWeapon(v);
		
		if (itemTable and itemTable.HasPlayerEquipped and itemTable:HasPlayerEquipped(Clockwork.Client, true)) then
			local itemCategory = itemTable("category");
			
			itemsList.equipment[itemCategory] = itemsList.equipment[itemCategory] or {};
			itemsList.equipment[itemCategory][#itemsList.equipment[itemCategory] + 1] = itemTable;
		end;
	end;
	
	for k, v in pairs(Clockwork.inventory:GetClient()) do
		for k2, v2 in pairs(v) do
			local itemCategory = v2("category");
			
			if (itemsList.equipment[itemCategory] and (table.HasValue(itemsList.equipment[itemCategory], v2) ~= true)) or (!itemsList.equipment[itemCategory]) then
				if (v2.HasPlayerEquipped and v2:HasPlayerEquipped(Clockwork.Client, false)) then
					itemCategory = v2("equippedCategory", itemCategory);

					itemsList.equipment[itemCategory] = itemsList.equipment[itemCategory] or {};
					itemsList.equipment[itemCategory][#itemsList.equipment[itemCategory] + 1] = v2;
				else
					--[[if (v2.HasPlayerEquipped and v2:HasPlayerEquipped(Clockwork.Client, true)) then
						itemCategory = v2("equippedCategory", itemCategory);

						itemsList.equipment[itemCategory] = itemsList.equipment[itemCategory] or {};
						itemsList.equipment[itemCategory][#itemsList.equipment[itemCategory] + 1] = v2;
						continue;
					end;]]--
					
					itemsList.inventory[itemCategory] = itemsList.inventory[itemCategory] or {};
					itemsList.inventory[itemCategory][#itemsList.inventory[itemCategory] + 1] = v2;
				end;
			end
		end;
	end;
	
	for k, v in pairs(itemsList.equipment) do
		categories.equipment[#categories.equipment + 1] = {
			itemsList = v,
			category = k
		};
	end;
	
	table.sort(categories.equipment, function(a, b)
		return a.category < b.category;
	end);
	
	for k, v in pairs(itemsList.inventory) do
		categories.inventory[#categories.inventory + 1] = {
			itemsList = v,
			category = k,
		};
	end;
	
	table.sort(categories.inventory, function(a, b)
		return a.category < b.category;
	end);
	
	--Clockwork.plugin:Call("PlayerInventoryRebuilt", self, categories);
	
	if (self.weightForm) then
		self.inventoryList:AddItem(self.weightForm);
	end;

	if (Clockwork.inventory:UseSpaceSystem() and self.spaceForm) then
		self.inventoryList:AddItem(self.spaceForm);
	end;
	
	self.inventoryList:AddItem(self.itemList);

	if (#categories.equipment > 0) then
		local charm_slots = {"Charm1", "Charm2"};
		local slots = {"Primary", "Secondary", "Tertiary"};
		
		for k, v in pairs(categories.equipment) do
			table.sort(v.itemsList, function(a, b)
				return a("name") < b("name");
			end);

			for k2, v2 in pairs(v.itemsList) do
				local itemData = {
					itemTable = v2, OnPress = function()
						self:HandleUnequip(v2);
					end
				};

				self.itemData = itemData;
				self.itemData.condition = v2:GetCondition();
				
				local equipmentIcon = vgui.Create("cwInventoryItem", self);
				local equipmentPos = nil;
				
				table.insert(self.equipmentIconList, equipmentIcon);
				
				if self.itemData.condition and self.itemData.condition < 100 then
					if self.itemData.condition <= 0 then
						equipmentIcon.spawnIcon.brokenOverlay = vgui.Create("DImage", equipmentIcon.spawnIcon);
						equipmentIcon.spawnIcon.brokenOverlay:SetImage("begotten/ui/itemicons/broken_item1.png");
						equipmentIcon.spawnIcon.brokenOverlay:SetSize(64, 64);
					else
						equipmentIcon.spawnIcon.conditionBar = vgui.Create("DImage", equipmentIcon.spawnIcon);
						equipmentIcon.spawnIcon.conditionBar:SetImage("begotten/ui/conditionframe.png");
						equipmentIcon.spawnIcon.conditionBar:SetPos(4, 56);
						equipmentIcon.spawnIcon.conditionBar:SetSize(56, 6);
						equipmentIcon.spawnIcon.conditionBar.fill = vgui.Create("DShape", equipmentIcon.spawnIcon.conditionBar);
						equipmentIcon.spawnIcon.conditionBar.fill:SetType("Rect");
						equipmentIcon.spawnIcon.conditionBar.fill:SetPos(2, 2);
						equipmentIcon.spawnIcon.conditionBar.fill:SetSize(52 * (self.itemData.condition / 100), 2);
						equipmentIcon.spawnIcon.conditionBar.fill:SetColor(Color(1 * (100 - self.itemData.condition), 1 * self.itemData.condition, 0, 225));
					end
				end
				
				if v2.category == "Throwables" or v2.category == "Weapons" or v2.category == "Melee" or v2.category == "Shields" or v2.category == "Firearms" or v2.category == "Javelins" or v2.category == "Lights" then
					for i, slot in ipairs(slots) do
						local slottedItem = Clockwork.Client.equipmentSlots[slot];
						
						if slottedItem and slottedItem.itemID == v2.itemID then
							equipmentPos = self.categoryLocations[slot];
							self.categoryLocations[slot].occupier = equipmentIcon;
							weapons[i] = v2;
						end
					end
				elseif v2.category == "Charms" then	
					if v2:HasPlayerEquipped(Clockwork.Client) then
						for i = 1, #charm_slots do
							local slot = charm_slots[i];
							
							if not self.categoryLocations[slot].occupier then
								equipmentPos = self.categoryLocations[slot];
								self.categoryLocations[slot].occupier = equipmentIcon;
								break;
							end
						end
					end
				else
					equipmentPos = self.categoryLocations[v2.category or "Unknown Category"];
					self.categoryLocations[v2.category or "Unknown Category"].occupier = equipmentIcon;
					
					if v2.hasHelmet then
						local helmetImage;
						
						if v2.helmetIconOverride then
							helmetImage = v2.helmetIconOverride;
						else
							helmetImage = string.gsub(v2.iconoverride, ".png", "").."_helmet.png";
						end
					
						helmetIcon = vgui.Create("DImage", self);
						helmetIcon:SetImage(helmetImage);
						helmetIcon:SetSize(64, 64);
						helmetIcon:SetPos(self.categoryLocations["Helms"].x, self.categoryLocations["Helms"].y);
						self.categoryLocations["Helms"].occupier = helmetIcon;
						
						if self.itemData.condition and self.itemData.condition < 100 then
							if self.itemData.condition <= 0 then
								helmetIcon.brokenOverlay = vgui.Create("DImage", helmetIcon);
								helmetIcon.brokenOverlay:SetImage("begotten/ui/itemicons/broken_item1.png");
								helmetIcon.brokenOverlay:SetSize(64, 64);
							else
								helmetIcon.conditionBar = vgui.Create("DImage", helmetIcon);
								helmetIcon.conditionBar:SetImage("begotten/ui/conditionframe.png");
								helmetIcon.conditionBar:SetPos(4, 56);
								helmetIcon.conditionBar:SetSize(56, 6);
								helmetIcon.conditionBar.fill = vgui.Create("DShape", helmetIcon.conditionBar);
								helmetIcon.conditionBar.fill:SetType("Rect");
								helmetIcon.conditionBar.fill:SetPos(2, 2);
								helmetIcon.conditionBar.fill:SetSize(52 * (self.itemData.condition / 100), 2);
								helmetIcon.conditionBar.fill:SetColor(Color(1 * (100 - self.itemData.condition), 1 * self.itemData.condition, 0, 225));
							end
						end
						
						table.insert(self.equipmentIconList, helmetIcon);
					end
				end
				
				if equipmentPos then
					equipmentIcon:SetPos(equipmentPos.x, equipmentPos.y);
				end
				
				equipmentIcon.spawnIcon:Droppable("dropper");
				equipmentIcon.spawnIcon:Droppable("inventory");
				equipmentIcon.spawnIcon:Droppable("invdummy");
				
				equipmentIcon.spawnIcon:Receiver("ammunition", function(self, panels, dropped, menuIndex, x, y)
					if (dropped) then
						local panel = panels[1];
						
						if panel then
							local parent = panel:GetParent();

							if parent and parent.itemData and parent.itemTable then
								if parent.itemTable.category == "Shot" then
									local occupierParent = self:GetParent();
									
									if occupierParent and occupierParent.itemData and occupierParent.itemTable then
										local itemTable = occupierParent.itemTable;
										
										if itemTable.category == "Firearms" and itemTable.ammoTypes then
											if table.HasValue(itemTable.ammoTypes, parent.itemTable.ammoType) then
												Clockwork.datastream:Start("UseAmmo", {parent.itemTable("uniqueID"), parent.itemTable("itemID"), itemTable("uniqueID"), itemTable("itemID")});
											end
										end
									end
								end
							end
						end
					end
				end);
			end;
		end;
	end;

	if (#categories.inventory > 0) then
		for k, v in pairs(categories.inventory) do
			--local collapsibleCategory = vgui.Create("DForm", self);
			--local categoryList = vgui.Create("DPanelList", self);

			table.sort(v.itemsList, function(a, b)
				return a("itemID") < b("itemID");
			end);
			
			local items = {};
			
			for k2, v2 in pairs(v.itemsList) do
				if v2.stackable then
					if (!items[v2("uniqueID")]) then
						local itemData = {
							itemTable = v2
						};
						
						self.itemData = itemData;
						self.itemData.amount = Clockwork.inventory:GetItemCountByID(Clockwork.inventory:GetClient(), self.itemData.itemTable("uniqueID"));
						--self.itemData.condition = v2:GetCondition(); -- Stackable items should not have condition.
						items[v2("uniqueID")] = true;
						
						local inventoryIcon = vgui.Create("cwInventoryItem", self);
						
						inventoryIcon.spawnIcon:Droppable("repair");
						
						if self.itemData.condition and self.itemData.condition < 100 then
							if self.itemData.condition <= 0 then
								inventoryIcon.spawnIcon.brokenOverlay = vgui.Create("DImage", inventoryIcon.spawnIcon);
								inventoryIcon.spawnIcon.brokenOverlay:SetImage("begotten/ui/itemicons/broken_item1.png");
								inventoryIcon.spawnIcon.brokenOverlay:SetSize(64, 64);
								
								if !cwBeliefs or cwBeliefs and (cwBeliefs:HasBelief("artisan")) then
									inventoryIcon.spawnIcon:Receiver("repair", function(self, panels, dropped, menuIndex, x, y)
										if (dropped) then
											local panel = panels[1];
											
											if panel then
												local parent = panel:GetParent();

												if parent and parent.itemData and parent.itemTable then
													local occupierParent = self:GetParent();
													
													if occupierParent and occupierParent.itemData and occupierParent.itemTable then
														local itemTable = occupierParent.itemTable;
														
														if itemTable.uniqueID == parent.itemTable.uniqueID then
															Clockwork.datastream:Start("MergeRepair", {parent.itemTable("uniqueID"), parent.itemTable("itemID"), itemTable("uniqueID"), itemTable("itemID")});
														end
													end
												end
											end
										end
									end);
								end
							else
								inventoryIcon.spawnIcon.conditionBar = vgui.Create("DImage", inventoryIcon.spawnIcon);
								inventoryIcon.spawnIcon.conditionBar:SetImage("begotten/ui/conditionframe.png");
								inventoryIcon.spawnIcon.conditionBar:SetPos(4, 56);
								inventoryIcon.spawnIcon.conditionBar:SetSize(56, 6);
								inventoryIcon.spawnIcon.conditionBar.fill = vgui.Create("DShape", inventoryIcon.spawnIcon.conditionBar);
								inventoryIcon.spawnIcon.conditionBar.fill:SetType("Rect");
								inventoryIcon.spawnIcon.conditionBar.fill:SetPos(2, 2);
								inventoryIcon.spawnIcon.conditionBar.fill:SetSize(52 * (self.itemData.condition / 100), 2);
								inventoryIcon.spawnIcon.conditionBar.fill:SetColor(Color(1 * (100 - self.itemData.condition), 1 * self.itemData.condition, 0, 225));
								
								if !cwBeliefs or cwBeliefs and (cwBeliefs:HasBelief("mechanic")) then
									inventoryIcon.spawnIcon:Receiver("repair", function(self, panels, dropped, menuIndex, x, y)
										if (dropped) then
											local panel = panels[1];
											
											if panel then
												local parent = panel:GetParent();

												if parent and parent.itemData and parent.itemTable then
													local occupierParent = self:GetParent();
													
													if occupierParent and occupierParent.itemData and occupierParent.itemTable then
														local itemTable = occupierParent.itemTable;
														
														if itemTable.uniqueID == parent.itemTable.uniqueID then
															Clockwork.datastream:Start("MergeRepair", {parent.itemTable("uniqueID"), parent.itemTable("itemID"), itemTable("uniqueID"), itemTable("itemID")});
														end
													end
												end
											end
										end
									end);
								end
							end
						end
						
						if v2.category == "Melee" or v2.category == "Shields" or v2.category == "Weapons" or v2.category == "Firearms" or v2.category == "Javelins" or v2.category == "Lights" then
							inventoryIcon.spawnIcon:Droppable("weaponSlot");
							
							if v2.category == "Firearms" then
								inventoryIcon.spawnIcon:Receiver("ammunition", function(self, panels, dropped, menuIndex, x, y)
									if (dropped) then
										local panel = panels[1];
										
										if panel then
											local parent = panel:GetParent();

											if parent and parent.itemData and parent.itemTable then
												if parent.itemTable.category == "Shot" then
													local occupierParent = self:GetParent();
													
													if occupierParent and occupierParent.itemData and occupierParent.itemTable then
														local itemTable = occupierParent.itemTable;
														
														if itemTable.category == "Firearms" and itemTable.ammoTypes then
															if table.HasValue(itemTable.ammoTypes, parent.itemTable.ammoType) then
																Clockwork.datastream:Start("UseAmmo", {parent.itemTable("uniqueID"), parent.itemTable("itemID"), itemTable("uniqueID"), itemTable("itemID")});
															end
														end
													end
												end
											end
										end
									end
								end);
							end
						elseif v2.category == "Helms" or v2.category == "Armor" or v2.category == "Charms" or v2.category == "Backpacks" then
							inventoryIcon.spawnIcon:Droppable(v2.category);
						elseif v2.category == "Containers" or v2.category == "Dissolvables" then
							inventoryIcon.spawnIcon:Droppable("containers");
							
							if v2.category == "Containers" then
								inventoryIcon.spawnIcon:Receiver("containers", function(self, panels, dropped, menuIndex, x, y)
									if (dropped) then
										local panel = panels[1];
										
										if panel then
											local parent = panel:GetParent();

											if parent and parent.itemData and parent.itemTable then
												if parent.itemTable.category == "Containers" then
													local occupierParent = self:GetParent();
													
													if occupierParent and occupierParent.itemData and occupierParent.itemTable then
														local itemTable = occupierParent.itemTable;
														
														if itemTable.category == "Containers" then
															Clockwork.datastream:Start("MergeAlchemyContainers", {parent.itemTable("uniqueID"), parent.itemTable("itemID"), itemTable("uniqueID"), itemTable("itemID")});
														elseif itemTable.category == "Dissolvables" then
															Clockwork.datastream:Start("DissolveObject", {parent.itemTable("uniqueID"), parent.itemTable("itemID"), itemTable("uniqueID"), itemTable("itemID")});
														end
													end
												end
											end
										end
									end
								end);
							end
						elseif v2.category == "Shot" then
							inventoryIcon.spawnIcon:Droppable("ammunition");
							
							if v2.ammoMagazineSize then
								inventoryIcon.spawnIcon:Receiver("ammunitionMagazine", function(self, panels, dropped, menuIndex, x, y)
									if (dropped) then
										local panel = panels[1];
										
										if panel then
											local parent = panel:GetParent();

											if parent and parent.itemData and parent.itemTable then
												if parent.itemTable.category == "Shot" then
													local occupierParent = self:GetParent();
													
													if occupierParent and occupierParent.itemData and occupierParent.itemTable then
														local itemTable = occupierParent.itemTable;
														
														if itemTable.category == "Shot" then
															if parent.itemTable.UseOnMagazine and parent.itemTable:UseOnMagazine(Clockwork.Client, itemTable) then
																Clockwork.datastream:Start("MergeAmmoMagazine", {parent.itemTable("uniqueID"), parent.itemTable("itemID"), itemTable("uniqueID"), itemTable("itemID")});
															end
														end
													end
												end
											end
										end
									end
								end);
							else
								inventoryIcon.spawnIcon:Droppable("ammunitionMagazine");
							end
						end
						
						inventoryIcon.spawnIcon:Droppable("dropper");
						inventoryIcon.spawnIcon:Droppable("invdummy");
						
						self.itemList:AddItem(inventoryIcon);
					end;
				else
					local itemData = {
						itemTable = v2
					};
					self.itemData = itemData;
					self.itemData.amount = 1;
					self.itemData.condition = v2:GetCondition();
					
					local inventoryIcon = vgui.Create("cwInventoryItem", self);
					
					inventoryIcon.spawnIcon:Droppable("repair");
					
					if self.itemData.condition and self.itemData.condition < 100 then
						if self.itemData.condition <= 0 then
							inventoryIcon.spawnIcon.brokenOverlay = vgui.Create("DImage", inventoryIcon.spawnIcon);
							inventoryIcon.spawnIcon.brokenOverlay:SetImage("begotten/ui/itemicons/broken_item1.png");
							inventoryIcon.spawnIcon.brokenOverlay:SetSize(64, 64);
							
							if !cwBeliefs or cwBeliefs and (cwBeliefs:HasBelief("artisan")) then
								inventoryIcon.spawnIcon:Receiver("repair", function(self, panels, dropped, menuIndex, x, y)
									if (dropped) then
										local panel = panels[1];
										
										if panel then
											local parent = panel:GetParent();

											if parent and parent.itemData and parent.itemTable then
												local occupierParent = self:GetParent();
												
												if occupierParent and occupierParent.itemData and occupierParent.itemTable then
													local itemTable = occupierParent.itemTable;
													
													if itemTable.uniqueID == parent.itemTable.uniqueID then
														Clockwork.datastream:Start("MergeRepair", {parent.itemTable("uniqueID"), parent.itemTable("itemID"), itemTable("uniqueID"), itemTable("itemID")});
													end
												end
											end
										end
									end
								end);
							end
						else
							inventoryIcon.spawnIcon.conditionBar = vgui.Create("DImage", inventoryIcon.spawnIcon);
							inventoryIcon.spawnIcon.conditionBar:SetImage("begotten/ui/conditionframe.png");
							inventoryIcon.spawnIcon.conditionBar:SetPos(4, 56);
							inventoryIcon.spawnIcon.conditionBar:SetSize(56, 6);
							inventoryIcon.spawnIcon.conditionBar.fill = vgui.Create("DShape", inventoryIcon.spawnIcon.conditionBar);
							inventoryIcon.spawnIcon.conditionBar.fill:SetType("Rect");
							inventoryIcon.spawnIcon.conditionBar.fill:SetPos(2, 2);
							inventoryIcon.spawnIcon.conditionBar.fill:SetSize(52 * (self.itemData.condition / 100), 2);
							inventoryIcon.spawnIcon.conditionBar.fill:SetColor(Color(1 * (100 - self.itemData.condition), 1 * self.itemData.condition, 0, 225));
							
							if !cwBeliefs or cwBeliefs and (cwBeliefs:HasBelief("mechanic")) then
								inventoryIcon.spawnIcon:Receiver("repair", function(self, panels, dropped, menuIndex, x, y)
									if (dropped) then
										local panel = panels[1];
										
										if panel then
											local parent = panel:GetParent();

											if parent and parent.itemData and parent.itemTable then
												local occupierParent = self:GetParent();
												
												if occupierParent and occupierParent.itemData and occupierParent.itemTable then
													local itemTable = occupierParent.itemTable;
													
													if itemTable.uniqueID == parent.itemTable.uniqueID then
														Clockwork.datastream:Start("MergeRepair", {parent.itemTable("uniqueID"), parent.itemTable("itemID"), itemTable("uniqueID"), itemTable("itemID")});
													end
												end
											end
										end
									end
								end);
							end
						end
					end
					
					if v2.category == "Melee" or v2.category == "Shields" or v2.category == "Weapons" or v2.category == "Firearms" or v2.category == "Javelins" then
						inventoryIcon.spawnIcon:Droppable("weaponSlot");
						
						if v2.category == "Firearms" then
							inventoryIcon.spawnIcon:Receiver("ammunition", function(self, panels, dropped, menuIndex, x, y)
								if (dropped) then
									local panel = panels[1];
									
									if panel then
										local parent = panel:GetParent();
										
										if parent and parent.itemData and parent.itemTable then
											if parent.itemTable.category == "Shot" then
												local occupierParent = self:GetParent();
												
												if occupierParent and occupierParent.itemData and occupierParent.itemTable then
													local itemTable = occupierParent.itemTable;
													
													if itemTable.category == "Firearms" and itemTable.ammoTypes then
														if table.HasValue(itemTable.ammoTypes, parent.itemTable.ammoType) then
															Clockwork.datastream:Start("UseAmmo", {parent.itemTable("uniqueID"), parent.itemTable("itemID"), itemTable("uniqueID"), itemTable("itemID")});
														end
													end
												end
											end
										end
									end
								end
							end);
						end
					elseif v2.category == "Helms" or v2.category == "Armor" or v2.category == "Charms" or v2.category == "Backpacks" then
						inventoryIcon.spawnIcon:Droppable(v2.category);
					elseif v2.category == "Containers" or v2.category == "Dissolvables" then
						inventoryIcon.spawnIcon:Droppable("containers");
						
						if v2.category == "Containers" then
							inventoryIcon.spawnIcon:Receiver("containers", function(self, panels, dropped, menuIndex, x, y)
								if (dropped) then
									local panel = panels[1];
									
									if panel then
										local parent = panel:GetParent();

										if parent and parent.itemData and parent.itemTable then
											if parent.itemTable.category == "Containers" then
												local occupierParent = self:GetParent();
												
												if occupierParent and occupierParent.itemData and occupierParent.itemTable then
													local itemTable = occupierParent.itemTable;
													
													if occupierParent and occupierParent.itemData and occupierParent.itemTable then
														local itemTable = occupierParent.itemTable;
														
														if itemTable.category == "Containers" then
															Clockwork.datastream:Start("MergeAlchemyContainers", {parent.itemTable("uniqueID"), parent.itemTable("itemID"), itemTable("uniqueID"), itemTable("itemID")});
														elseif itemTable.category == "Dissolvables" then
															Clockwork.datastream:Start("DissolveObject", {parent.itemTable("uniqueID"), parent.itemTable("itemID"), itemTable("uniqueID"), itemTable("itemID")});
														end
													end
												end
											end
										end
									end
								end
							end);
						end
					elseif v2.category == "Shot" then
						inventoryIcon.spawnIcon:Droppable("ammunition");
						
						if v2.ammoMagazineSize then
							inventoryIcon.spawnIcon:Receiver("ammunitionMagazine", function(self, panels, dropped, menuIndex, x, y)
								if (dropped) then
									local panel = panels[1];
									
									if panel then
										local parent = panel:GetParent();

										if parent and parent.itemData and parent.itemTable then
											if parent.itemTable.category == "Shot" then
												local occupierParent = self:GetParent();
												
												if occupierParent and occupierParent.itemData and occupierParent.itemTable then
													local itemTable = occupierParent.itemTable;
													
													if parent.itemTable.UseOnMagazine and parent.itemTable:UseOnMagazine(Clockwork.Client, itemTable) then
														Clockwork.datastream:Start("MergeAmmoMagazine", {parent.itemTable("uniqueID"), parent.itemTable("itemID"), itemTable("uniqueID"), itemTable("itemID")});
													end
												end
											end
										end
									end
								end
							end);
						else
							inventoryIcon.spawnIcon:Droppable("ammunitionMagazine");
						end
					end
					
					inventoryIcon.spawnIcon:Droppable("dropper");
					inventoryIcon.spawnIcon:Droppable("invdummy");
					
					self.itemList:AddItem(inventoryIcon);
				end;
			end;
			
			self.itemList:SizeToContents();
			self.itemList:EnableHorizontal(true);
			self.itemList:SetAutoSize(true);
			self.itemList:SetPadding(4);
			self.itemList:SetSpacing(4);
		end;
	end;
	
	if weapons and not table.IsEmpty(weapons) then
		for i = 1, #weapons do
			local weapon = weapons[i];
			
			if weapon and weapon.uniqueID and weapon.itemID then
				local item = Clockwork.item:FindByID(weapon.uniqueID, weapon.itemID);
				
				if item then
					if i == 1 then
						weapon1 = {};
						
						if item.isAttachment and !item.invisibleAttachment then
							weapon1.attachmentInfo = {};
							weapon1.attachmentInfo.attachmentModel = item.model;
							weapon1.attachmentInfo.attachmentBone = item.attachmentBone;
							weapon1.attachmentInfo.attachmentOffsetAngles = item.attachmentOffsetAngles;
							weapon1.attachmentInfo.attachmentOffsetVector = item.attachmentOffsetVector;
							weapon1.attachmentInfo.attachmentSkin = item.attachmentSkin;
							weapon1.attachmentInfo.bodygroup0 = item.bodygroup0;
							weapon1.attachmentInfo.bodygroup1 = item.bodygroup1;
							weapon1.attachmentInfo.bodygroup2 = item.bodygroup2;
							weapon1.attachmentInfo.bodygroup3 = item.bodygroup3;
						end
					elseif i == 2 then
						weapon2 = {};
						
						if item.isAttachment and !item.invisibleAttachment then
							weapon2.attachmentInfo = {};
							weapon2.attachmentInfo.attachmentModel = item.model;
							weapon2.attachmentInfo.attachmentBone = item.attachmentBone;
							weapon2.attachmentInfo.attachmentOffsetAngles = item.attachmentOffsetAngles;
							weapon2.attachmentInfo.attachmentOffsetVector = item.attachmentOffsetVector;
							weapon2.attachmentInfo.attachmentSkin = item.attachmentSkin;
							weapon2.attachmentInfo.bodygroup0 = item.bodygroup0;
							weapon2.attachmentInfo.bodygroup1 = item.bodygroup1;
							weapon2.attachmentInfo.bodygroup2 = item.bodygroup2;
							weapon2.attachmentInfo.bodygroup3 = item.bodygroup3;
						end
					elseif i == 3 then
						weapon3 = {};
						
						if item.isAttachment and !item.invisibleAttachment then
							weapon3.attachmentInfo = {};
							weapon3.attachmentInfo.attachmentModel = item.model;
							weapon3.attachmentInfo.attachmentBone = item.attachmentBone;
							weapon3.attachmentInfo.attachmentOffsetAngles = item.attachmentOffsetAngles;
							weapon3.attachmentInfo.attachmentOffsetVector = item.attachmentOffsetVector;
							weapon3.attachmentInfo.attachmentSkin = item.attachmentSkin;
							weapon3.attachmentInfo.bodygroup0 = item.bodygroup0;
							weapon3.attachmentInfo.bodygroup1 = item.bodygroup1;
							weapon3.attachmentInfo.bodygroup2 = item.bodygroup2;
							weapon3.attachmentInfo.bodygroup3 = item.bodygroup3;
						end
					end
				end
			end
		end
	end
	
	self.characterModel.weapon1 = nil;
	self.characterModel.weapon2 = nil;
	self.characterModel.weapon3 = nil;
	
	if weapon1 then
		self.characterModel.weapon1 = weapon1;
	end
	
	if weapon2 then
		self.characterModel.weapon2 = weapon2;
	end
	
	if weapon3 then
		self.characterModel.weapon3 = weapon3;
	end
	
	self.characterModel:SetModelNew(playerModel);
	
	if IsValid(self.characterModel) then
		if IsValid(self.characterModel.modelPanel.Entity) then
			if headModel then
				self.characterModel.modelPanel.headModel = ClientsideModel(headModel, RENDERGROUP_OPAQUE);
				
				if IsValid(self.characterModel.modelPanel.headModel) then
					self.characterModel.modelPanel.headModel.noDelete = true;
					self.characterModel.modelPanel.headModel:SetParent(self.characterModel.modelPanel.Entity);
					self.characterModel.modelPanel.headModel:AddEffects(EF_BONEMERGE);
					self.characterModel.modelPanel.headModel:SetBodygroup(0, playerBodygroups[1]);
					self.characterModel.modelPanel.headModel:SetBodygroup(1, playerBodygroups[2]);
					self.characterModel.modelPanel.headModel:SetSkin(Clockwork.Client:GetSkin() or 0);
				end
			else
				self.characterModel.modelPanel.Entity:SetBodygroup(0, playerBodygroups[1]);
				self.characterModel.modelPanel.Entity:SetBodygroup(1, playerBodygroups[2]);
				self.characterModel.modelPanel.Entity:SetSkin(Clockwork.Client:GetSkin() or 0);
			end
			
			self.characterModel.modelPanel.Entity:ResetSequence(self.characterModel.modelPanel.Entity:LookupSequence("idle_angry"));
			self.characterModel.modelPanel.Entity:SetCycle(cycle or 0);
		end

		self.characterModel:SetVisible(true);
	end

	self.inventoryList:InvalidateLayout(true);
	
	if Clockwork.menu:GetPanel() then
		hook.Run("PostMainMenuRebuild", Clockwork.menu:GetPanel());
	end
end;

-- Called when the menu is opened.
function PANEL:OnMenuOpened()
	if (Clockwork.menu:IsPanelActive(self)) then
		self:Rebuild();
	end;
end;

function PANEL:OnMenuClosed()
	if IsValid(self.characterModel) then
		self.characterModel:SetVisible(false);
	end
end

-- Called when the panel is selected.
function PANEL:OnSelected() self:Rebuild(); end;

-- Called when the layout should be performed.
function PANEL:PerformLayout(w, h)
	--self:SetSize(w, math.min(self.inventoryList.pnlCanvas:GetTall() + 28, ScrH() * 0.75));
	self:SetSize(740, 800);
	self:SetPos((ScrW() * 0.5) - (self:GetWide() / 4), (ScrH() * 0.5) - (self:GetTall() / 2));
	self.inventoryList:SetSize(w, 320);
	self.inventoryList:SetPos(0, self:GetTall() - self.inventoryList:GetTall());
end;

--[[function PANEL:LayoutIcons()
	local x, y = self.inventoryList:GetPos();
	local row = 1;
	local column = 0;
	local max_columns = 11;
	
	if self.itemIcons then
		for i = 1, #self.itemIcons do
			column = column + 1;
			
			if column > max_columns then
				column = 1;
				row = row + 1;
			end

			self.itemIcons[i]:SetPos(x + 4 + (68 * i), row * 68);
		end
	end
end]]--

-- Called when the panel is painted.
function PANEL:Paint(w, h)
	derma.SkinHook("Paint", "Frame", self, w, h);

	return true;
end;

-- Called each frame.
function PANEL:Think()
	--[[for k, v in pairs(Clockwork.Client:GetWeapons()) do
		local weaponItem = Clockwork.item:GetByWeapon(v);
		
		if (weaponItem and !v.cwIsWeaponItem) then
			Clockwork.inventory:Rebuild();
			v.cwIsWeaponItem = true;
		end;
	end;]]--
	
	self:InvalidateLayout(true);
end;

vgui.Register("cwInventory", PANEL, "EditablePanel");

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	local itemData = self:GetParent().itemData;
	self.itemTable = itemData.itemTable;
	self.itemData = itemData

	local model, skin = Clockwork.item:GetIconInfo(self.itemTable);

	self:SetSize(64, 64);
	
	if self.itemTable.iconoverride then
		self.spawnIcon = Clockwork.kernel:CreateMarkupToolTip(vgui.Create("DImageButton", self));
		self.spawnIcon:SetImage(self.itemTable.iconoverride);
		self.spawnIcon:SetSize(64, 64);
		self.spawnIcon.isSpawnIcon = false;
		
		function self.spawnIcon.DoRightClick(spawnIcon)
			if (itemData.OnPress) then
				itemData.OnPress();
				return;
			end;
			
			Clockwork.kernel:HandleItemSpawnIconRightClick(self.itemTable, spawnIcon);
		end;
	else
		self.spawnIcon = Clockwork.kernel:CreateMarkupToolTip(vgui.Create("cwSpawnIcon", self));
		self.spawnIcon:SetModel(model, skin);
		self.spawnIcon:SetSize(64, 64);
		self.spawnIcon.isSpawnIcon = true;
	end
	
	self.spawnIcon:SetItemTable(self.itemTable);
	
	if (!itemData.OnPress) then
		self.spawnIcon.OpenMenu = function(spawnIcon)
			Clockwork.kernel:HandleItemSpawnIconRightClick(self.itemTable, spawnIcon);
		end;
	end;
	
	-- Called when the spawn icon is clicked.
	function self.spawnIcon.DoClick(spawnIcon)
		if (itemData.OnPress) then
			itemData.OnPress();
			return;
		end;

		Clockwork.kernel:HandleItemSpawnIconClick(self.itemTable, spawnIcon);
	end;
	
	self.cachedInfo = {model = model, skin = skin};
end;

-- Called each frame.
function PANEL:Think()
	local whiteColor = Color(255, 255, 255);
	local name = self.itemTable("name");
	local color = self.itemTable("color");
	local weight = self.itemTable("weight");
	local description = self.itemTable("description");
	local amount = self.itemData.amount or 0;
	
	if (self.spawnIcon.isSpawnIcon) then
		self.spawnIcon:SetColor(color);
	end

	if (self.itemTable.stackable) then
		if (amount > 1) then
			if self.spawnIcon then
				if !IsValid(self.spawnIcon.amount) then
					self.spawnIcon.amount = vgui.Create("DLabel", self.spawnIcon);
				end
				
				self.spawnIcon.amount:SetText(amount);
				self.spawnIcon.amount:SetFont("Decay_FormText");
				self.spawnIcon.amount:SetTextColor(Color(160, 145, 145));
				self.spawnIcon.amount:SizeToContents();
				
				if amount < 10 then
					self.spawnIcon.amount:SetPos(52, 46);
				else
					self.spawnIcon.amount:SetPos(46, 46);
				end
			end
			
			--[[local plural = self.itemTable("plural");
			
			if (!self.itemTable("plural")) then
				if (string.sub(name, -1) != "s") then
					plural = name.."s";
				else
					plural = name;
				end;
			end;
			
			name = amount.." "..plural;
			weight = weight * amount;
		elseif (amount == 1) then
			name = amount.." "..name]]--
		elseif self.spawnIcon and self.spawnIcon.amount then
			self.spawnIcon.amount:Remove();
		end;
	end;
	
	--[[self.nameLabel:SetText(name);
	self.nameLabel:SizeToContents();
	self.nameLabel:SetTextColor(whiteColor);
	
	self.infoLabel:SetText(weight.."kg");
	self.infoLabel:SizeToContents();
	self.infoLabel:SetTextColor(whiteColor);
	self.infoLabel:SetPos(36, 30 - self.infoLabel:GetTall());]]--

	local model, skin = Clockwork.item:GetIconInfo(self.itemTable);
	
	if (model != self.cachedInfo.model or skin != self.cachedInfo.skin) then
		self.spawnIcon:SetModel(model, skin);
		self.cachedInfo.model = model
		self.cachedInfo.skin = skin;
	end;
end;

vgui.Register("cwInventoryItem", PANEL, "DPanel");

local PANEL = {};

local scra = Material("begotten/ui/generic_scratch.png")
local icos = Material("begotten/ui/icos.png")
local squash = Material("begotten/ui/infotextsquash.png")

-- Called when the panel is initialized.
function PANEL:Init()
	local maximumWeight = Clockwork.player:GetMaxWeight();
	local colorWhite = Clockwork.option:GetColor("white");
	self:SetTall(32)
	self.spaceUsed = vgui.Create("DPanel", self);
	self.spaceUsed:SetPos(1, 1);

	local font = Clockwork.fonts:GetMultiplied("nov_IntroTextSmallDETrooper", 0.85);

	-- Called when the panel should be painted.
	function self.spaceUsed.Paint(spaceUsedR)
		SexyBar(self.spaceUsed, self, font)
	end;
end;

local backgroundColor = Color(150, 150, 150)
local backgroundMaterial = icos;
local weightBarMaterial = squash

function SexyBar(self, parent, font)
	local width = self:GetWide();
	local height = self:GetTall();
	
	local inventoryWeight = Clockwork.inventory:CalculateWeight(Clockwork.inventory:GetClient());
	local maximumWeight = Clockwork.player:GetMaxWeight();
	local colorBar = Color(139, 215, 113, 255);
	local encumberedBarColor = Color(179, 46, 49, 255);
	local textColor= Color(240, 240, 240)
	local shadowColor = Color(20, 20, 20, 200);
	local boxColor = Color(0, 0, 0, 200);
	
	if (inventoryWeight > maximumWeight) then
		if (inventoryWeight <= maximumWeight * 2) then
			colorBar = Color(215, 195, 0, 255);
		else
			colorBar = Color(179, 46, 49, 255);
		end;
	else
		encumberedBarColor = Color(200, 200, 200);
	end;
	
	local maxWeightText = maximumWeight.."kg";
	local maxWeightWidth, maxWeightHeight = GetFontWidth(font, maxWeightText), GetFontHeight(font, maxWeightText);
	local maxWeightX, maxWeightY = 6, (height / 2) - (maxWeightHeight / 2);
	
	if (inventoryWeight <= 0) then
		local emptyText = "Your sack is empty...";
		local emptyWidth = GetFontWidth(font, emptyText);
			draw.SimpleText(emptyText, font, (width / 2) - (emptyWidth / 2), (height / 2) - (maxWeightHeight / 2), Color(240, 240, 240), 0, 0)
		return;
	end;
	
	local encumbered = math.Clamp(math.abs(inventoryWeight - maximumWeight), 0, inventoryWeight);
	local encumberedRatio = (encumbered) / maximumWeight;
	local encumberedBarWidth = (width * encumberedRatio);
	local weightText = inventoryWeight.."kg";
	local weightTextWide = GetFontWidth(font, weightText);
	local invWeightRatio = inventoryWeight / maximumWeight;
	local weightBarX, weightBarY = 2, 2;
	local weightBarWidth, weightBarHeight = math.Clamp((width * invWeightRatio), (math.max(maxWeightWidth, weightTextWide) + 16), width - encumberedBarWidth), height;
	local weightTextX, weightTextY = math.Clamp((weightBarWidth + 2), 0, (weightBarWidth - (weightTextWide + 8))), (height / 2) - (maxWeightHeight / 2);
	local encumberedText = (math.Round(encumbered, 2)).."kg";
	local encumberedWidth = GetFontWidth(font, encumberedText) + 4;

	encumberedBarWidth = math.Clamp(encumberedBarWidth, encumberedWidth + 8, width);
	weightBarWidth = math.Clamp(weightBarWidth, 0, width - (encumberedBarWidth - 2))
	weightTextX = math.Clamp(weightTextX, 0, (weightBarWidth - (weightTextWide + 8)))
	
	local encumberedBarX, encumberedBarY = math.Clamp((weightBarWidth), weightBarWidth - (encumberedWidth + 2), width), 2;
	local encumberedTextX, encumberedTextY = math.Clamp(encumberedBarX, encumberedBarX + 3, width - (encumberedWidth + 2)), weightTextY;
	local bShowEncumbered = true;

	if (tostring(inventoryWeight) == tostring(maximumWeight)) then
		weightBarWidth = width;
		bShowEncumbered = false;
		weightTextX = width - (weightTextWide + 8)
	elseif (maximumWeight > inventoryWeight) then
		encumberedBarWidth = width - (weightBarWidth + 2)
		encumberedText = math.Round(maximumWeight - inventoryWeight, 2).."kg"
	elseif (maximumWeight < inventoryWeight) then--
		weightBarWidth = math.Clamp(weightBarWidth, weightTextWide + 12, width)
		weightTextX = math.Clamp(weightTextX, 4, width)
		encumberedBarWidth = math.Clamp(encumberedBarWidth, 0, width - 2)
		encumberedBarX = math.Clamp(encumberedBarX, weightBarWidth, width)
		encumberedTextX = math.Clamp(encumberedTextX, encumberedBarX + 4, width)
	end;
	
	--[[ Background texture --]]
	surface.SetDrawColor(backgroundColor);
	surface.SetMaterial(backgroundMaterial);
	surface.DrawTexturedRect(0, 0, width, height);
	
	--[[ Weight bar --]]
	surface.SetDrawColor(colorBar);
	surface.SetMaterial(weightBarMaterial);
	surface.DrawTexturedRect(weightBarX, weightBarY, weightBarWidth - (weightBarX * 2), weightBarHeight - (weightBarY * 2));

	--[[ Weight text --]]
	draw.RoundedBox(2, math.Clamp(weightTextX - 2, 3, width), weightTextY - 1, weightTextWide + 4, maxWeightHeight + 2, boxColor)
	draw.SimpleText(weightText, font, weightTextX + 1, weightTextY + 1, shadowColor)
	draw.SimpleText(weightText, font, weightTextX, weightTextY, textColor)
	
	if (bShowEncumbered) then
		--[[ Encumberment bar --]]
		surface.SetDrawColor(encumberedBarColor);
		surface.SetMaterial(weightBarMaterial);
		surface.DrawTexturedRect(encumberedBarX, weightBarY, encumberedBarWidth, weightBarHeight - (weightBarY * 2));
		
		--[[ Encumberment text--]]
		draw.RoundedBox(2, encumberedTextX - 2, encumberedTextY - 1, encumberedWidth + 2, maxWeightHeight + 2, boxColor)
		draw.SimpleText(encumberedText, font, encumberedTextX + 1, encumberedTextY + 1, shadowColor)
		draw.SimpleText(encumberedText, font, encumberedTextX, encumberedTextY, textColor)
	end;
	
	if (((maxWeightX + maxWeightWidth) + 16) > weightTextX) then
		maxWeightX = width - (maxWeightWidth + 8)
	end;
	
	--[[ Max weight text--]]
	draw.RoundedBox(2, maxWeightX - 2, maxWeightY - 1, maxWeightWidth + 4, maxWeightHeight + 2, boxColor)
	draw.SimpleText(maxWeightText, font, maxWeightX + 1, maxWeightY + 1, shadowColor)
	draw.SimpleText(maxWeightText, font, maxWeightX, maxWeightY, textColor)
end;

-- Called each frame.
function PANEL:Think()
	self.spaceUsed:SetSize(self:GetWide() - 2, self:GetTall() - 2);
end;

vgui.Register("cwInventoryWeight", PANEL, "DPanel");

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	local maximumSpace = Clockwork.player:GetMaxSpace();
	local colorWhite = Clockwork.option:GetColor("white");
	
	self.spaceUsed = vgui.Create("DPanel", self);
	self.spaceUsed:SetPos(1, 1);
	
	self.space = vgui.Create("DLabel", self);
	self.space:SetText("N/A");
	self.space:SetTextColor(colorWhite);
	self.space:SizeToContents();
	self.space:SetExpensiveShadow(1, Color(0, 0, 0, 150));
	
	-- Called when the panel should be painted.
	function self.spaceUsed.Paint(spaceUsed)
		local inventorySpace = Clockwork.inventory:CalculateSpace(
			Clockwork.inventory:GetClient()
		);
		local maximumSpace = Clockwork.player:GetMaxSpace();
		
		local color = Color(100, 100, 100, 255);
		local width = math.Clamp((spaceUsed:GetWide() / maximumSpace) * inventorySpace, 0, spaceUsed:GetWide());
		local red = math.Clamp((255 / maximumSpace) * inventorySpace, 0, 255) ;
		
		if (color) then
			color.r = math.min(color.r - 25, 255);
			color.g = math.min(color.g - 25, 255);
			color.b = math.min(color.b - 25, 255);
		end;
		
		local colorBar;
		
		if (inventoryWeight > maximumWeight) then
			if (inventoryWeight < maximumWeight * 2) then
				colorBar = Color(215, 195, 0, 255)
			else
				colorBar = Color(179, 46, 49, 255)
			end;
		else
			colorBar = Color(139, 215, 113, 255)
		end;			
		
		Clockwork.kernel:DrawTexturedGradient(0, 0, 0, spaceUsed:GetWide(), spaceUsed:GetTall(), color);
		Clockwork.kernel:DrawTexturedGradient(0, 0, 0, width, spaceUsed:GetTall(), colorBar);
	end;
end;

-- Called each frame.
function PANEL:Think()
	local inventorySpace = Clockwork.inventory:CalculateSpace(
		Clockwork.inventory:GetClient()
	);
	
	self.spaceUsed:SetSize(self:GetWide() - 2, self:GetTall() - 2);
	self.space:SetText(inventorySpace.."/"..Clockwork.player:GetMaxSpace().."l");
	self.space:SetPos(self:GetWide() / 2 - self.space:GetWide() / 2, self:GetTall() / 2 - self.space:GetTall() / 2);
	self.space:SizeToContents();
end;