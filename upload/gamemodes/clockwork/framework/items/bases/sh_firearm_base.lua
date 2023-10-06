local Clockwork = Clockwork;

local ITEM = Clockwork.item:New(nil, true);
ITEM.name = "Firearm Base";
ITEM.useText = "Equip";
ITEM.useSound = false;
ITEM.category = "Firearms";
ITEM.useInVehicle = false;
ITEM.excludeFactions = {"Goreic Warrior"};
ITEM.includeSubfactions = {"Clan Shagalax"};
ITEM.requireFaith = {};
ITEM.requireFaction = {};
ITEM.breakable = true;
ITEM.breakMessage = " breaks into pieces!";
ITEM.repairItem = "firearm_repair_kit";
ITEM.customFunctions = {"Engrave"};
ITEM.slots = {"Primary", "Secondary", "Tertiary"};
ITEM.equipmentSaveString = "weapons";

-- Firearm specific shit.
ITEM.usesMagazine = false;
ITEM.isRevolver = false;
ITEM.ammoCapacity = 1;
ITEM.ammoTypes = {};

local defaultWeapons = {
	["weapon_357"] = {"357", nil, true},
	["weapon_ar2"] = {"ar2", "ar2altfire", 30},
	["weapon_rpg"] = {"rpg_round", nil, 3},
	["weapon_smg1"] = {"smg1", "smg1_grenade", true},
	["weapon_slam"] = {"slam", nil, 2},
	["weapon_frag"] = {"grenade", nil, 1},
	["weapon_pistol"] = {"pistol", nil, true},
	["weapon_shotgun"] = {"buckshot", nil, true},
	["weapon_crossbow"] = {"xbowbolt", nil, 4}
};

ITEM:AddData("Ammo", {}, true);
ITEM:AddData("engraving", "", true);
ITEM:AddData("kills", 0, true);

-- Called whent he item entity's menu options are needed.
function ITEM:GetEntityMenuOptions(entity, options)
	local ammo = self:GetData("Ammo");
	
	if ammo and #ammo > 0 then
		if self.ammoCapacity == 1 or (#ammo == 1 and !string.find(ammo[1], "Magazine")) then
			if self.usesMagazine then
				options["Unload Chamber"] = {
					isArgTable = true,
					arguments = "cwItemAmmo",
					toolTip = toolTip
				};
			else
				options["Unload Shot"] = {
					isArgTable = true,
					arguments = "cwItemAmmo",
					toolTip = toolTip
				};
			end
		elseif self.isRevolver then
			options["Unload All Shot"] = {
				isArgTable = true,
				arguments = "cwItemAmmo",
				toolTip = toolTip
			};
		elseif self.usesMagazine then
			options["Unload Magazine"] = {
				isArgTable = true,
				arguments = "cwItemAmmo",
				toolTip = toolTip
			};
		end;
	end;
end;

function ITEM:Engrave(player, text, engravingItemTable)
	local nospaces = string.gsub(text,"%s+","")
	
	if string.len(text) > 32 then
		Schema:EasyText(player, "chocolate", "This name is too long!");
	elseif #nospaces == 0 then
		Schema:EasyText(player, "peru", "You can't leave this blank!");
	else
		self:SetData("engraving", text);
		player:TakeItem(engravingItemTable, true);
		Schema:EasyText(player, "olivedrab", "You engrave \'"..text.."\' into the side of your weapon.");
		Clockwork.inventory:Rebuild(player);
	end;
end;

function ITEM:HasPlayerEquipped(player)
	return player:GetWeaponEquipped(self);
end

if (SERVER) then
	function ITEM:OnCustomFunction(player, name)
		if (name == "Engrave") then
			if self:GetData("engraving") != "" then
				Schema:EasyText(player, "peru", "This weapon has already been engraved!");
			elseif cwBeliefs and !player:HasBelief("literacy") then
				Schema:EasyText(player, "chocolate", "You are not literate!");
			else
				local itemList = Clockwork.inventory:GetItemsAsList(player:GetInventory());
				local engravingItemTable;

				for k, v in pairs (itemList) do
					if v.uniqueID == "engraving_tool" then
						engravingItemTable = v;
						break;
					end
				end
	
				if engravingItemTable then
					Clockwork.dermaRequest:RequestString(player, "Engrave Weapon", "What would you like to etch on this item?", "", function(result)
						self:Engrave(player, result, engravingItemTable);
					end);
				else
					Schema:EasyText(player, "chocolate", "You do not have an item you can engrave this item with!");
					return false;
				end
			end;
		end;
	end;
end;

function ITEM:GetEngraving()
	local engraving = self.name;
	
	if self:GetData("engraving") != "" then
		engraving = self:GetData("engraving");
	end;
	
	return engraving;
end;

ITEM:AddQueryProxy("name", ITEM.GetEngraving);

-- Called when a player attempts to holster the weapon.
function ITEM:CanHolsterWeapon(player, forceHolster, bNoMsg)
	return true;
end;

-- Called when the unequip should be handled.
--[[function ITEM:OnHandleUnequip(Callback)
	if (self.OnDrop) then
		local menu = DermaMenu();
			menu:SetMinimumWidth(100);
			menu:AddOption("Holster", function()
				Callback();
			end);
			menu:AddOption("Drop", function()
				Callback("drop");
			end);
		menu:Open();
	else
		Callback();
	end;
end;]]--

-- Called when a player has unequipped the item.
function ITEM:OnPlayerUnequipped(player, extraData)
	local weapon = player:GetWeapon(self.uniqueID);
	
	if weapon then
		itemTable = item.GetByWeapon(weapon);
		
		if (SERVER) then
			for k, v in pairs(player.equipmentSlots) do
				if v and v.category == "Shields" then
					if IsValid(weapon) and weapon:GetNWString("activeShield"):len() > 0 and weapon:GetNWString("activeShield") == v.uniqueID then
						Clockwork.kernel:ForceUnequipItem(player, v.uniqueID, v.itemID);
						
						break;
					end
				end
			end
		end
	end
	
	if !itemTable then
		itemTable = self;
	end

	if (itemTable:IsTheSameAs(self)) then
		if (extraData == "unload") then
			local ammo = itemTable:GetData("Ammo");
			
			if ammo and #ammo > 0 then
				if #ammo == 1 then
					if itemTable.usesMagazine and !string.find(ammo[1], "Magazine") then
						local ammoItemID = string.gsub(string.lower(ammo[1]), " ", "_");
						local magazineItem = item.CreateInstance(ammoItemID);
						
						if magazineItem and magazineItem.SetAmmoMagazine then
							magazineItem:SetAmmoMagazine(1);
							
							player:GiveItem(magazineItem);
						end
					else
						local ammoItemID = string.gsub(string.lower(ammo[1]), " ", "_");
						
						player:GiveItem(item.CreateInstance(ammoItemID));
					end
				elseif itemTable.usesMagazine then
					local ammoItemID = string.gsub(string.lower(ammo[1]), " ", "_");
					local magazineItem = item.CreateInstance(ammoItemID);
					
					if magazineItem and magazineItem.SetAmmoMagazine then
						magazineItem:SetAmmoMagazine(#ammo);
						
						player:GiveItem(magazineItem);
					end
				else
					for i = 1, #ammo do
						local round = ammo[i];
						
						if round then
							local roundItemID = string.gsub(string.lower(round), " ", "_");
							local roundItemInstance = item.CreateInstance(roundItemID);
							
							player:GiveItem(roundItemInstance);
						end
					end
				end
				
				itemTable:SetData("Ammo", {});
			end
		elseif (extraData != "drop") then
			player:SelectWeapon("begotten_fists")
			player:StripWeapon(itemTable.weaponClass)

			if !player:IsNoClipping() and (!player.GetCharmEquipped or !player:GetCharmEquipped("urn_silence")) then
				local useSound = itemTable("useSound");
				
				if (useSound) then
					if (type(useSound) == "table") then
						player:EmitSound(useSound[math.random(1, #useSound)]);
					else
						player:EmitSound(useSound);
					end;
				elseif (useSound != false) then
					player:EmitSound("begotten/items/first_aid.wav");
				end;
			end

			Clockwork.equipment:UnequipItem(player, self);
		elseif (hook.Run("PlayerCanDropWeapon", player, self)) then
			local trace = player:GetEyeTraceNoCursor()

			if (player:GetShootPos():Distance(trace.HitPos) <= 192) then
				local entity = Clockwork.entity:CreateItem(player, self, trace.HitPos)

				if (IsValid(entity)) then		
					Clockwork.entity:MakeFlushToGround(entity, trace.HitPos, trace.HitNormal)
					hook.Run("PlayerDropWeapon", player, self, entity)

					player:TakeItem(self, true)
					player:SelectWeapon("begotten_fists")
					player:StripWeapon(itemTable.weaponClass);
					
					Clockwork.equipment:UnequipItem(player, self);
				end
			else
				Schema:EasyText(player, "peru", "You cannot drop this item that far away.")
			end
		end
	end
end;

-- Called when the item is given to a player as a weapon.
--[[function ITEM:OnWeaponGiven(player, weapon)
	Clockwork.player:StripDefaultAmmo(
		player, weapon, self
	);

	local clipOne = self:GetData("ClipOne");
	local clipTwo = self:GetData("ClipTwo");
	
	if (clipOne > 0) then
		weapon:SetClip1(clipOne);
		self:SetData("ClipOne", 0);
	end;
	
	if (clipTwo > 0) then
		weapon:SetClip2(clipTwo);
		self:SetData("ClipTwo", 0);
	end;
end;]]--

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	local faction = player:GetFaction();
	local subfaction = player:GetSubfaction();
	local kinisgerOverride = player:GetSharedVar("kinisgerOverride");
	local kinisgerOverrideSubfaction = player:GetSharedVar("kinisgerOverrideSubfaction");

	if (table.HasValue(self.excludeFactions, kinisgerOverride or faction)) then
		if !table.HasValue(self.includeSubfactions, kinisgerOverrideSubfaction or subfaction) then
			Schema:EasyText(player, "chocolate", "You are not the correct faction for this item!")
			return false
		end
	end
	
	if #self.requireFaith > 0 then
		if (!table.HasValue(self.requireFaith, player:GetFaith())) then
			Schema:EasyText(player, "peru", "You are not the correct faith for this item!")
			return false
		end
	end
	
	if #self.requireFaction > 0 then
		if (!table.HasValue(self.requireFaction, faction) and (!kinisgerOverride or !table.HasValue(self.requireFaction, kinisgerOverride))) then
			Schema:EasyText(player, "chocolate", "You are not the correct faction for this item!")
			return false
		end
	end
	
	local weaponClass = self("weaponClass");
	
	if (!player:HasWeapon(weaponClass)) then
		if (self.OnEquip) then
			if self:OnEquip(player) == false then
				return false;
			end
		end;
	
		player:Give(weaponClass, self);
		
		return true;
	else
		local weapon = player:GetWeapon(weaponClass);
		
		if (IsValid(weapon) and self.OnAlreadyHas) then
			if (Clockwork.item:GetByWeapon(weapon) == self) then
				self:OnAlreadyHas(player);
			end;
		end;
		
		Schema:EasyText(player, "peru", "You already have a weapon of this type equipped!")
		
		return false;
	end;
end;

-- Called when a player repairs the item.
function ITEM:OnRepair(player, itemEntity)
	return true;
end

function ITEM:OnEquip(player)
	if self:IsBroken() then
		Schema:EasyText(player, "peru", "This weapon is broken and cannot be used!");
		return false;
	end

	for i, v in ipairs(self.slots) do
		if !player.equipmentSlots[v] then
			return Clockwork.equipment:EquipItem(player, self, v);
		end
	end
	
	Schema:EasyText(player, "peru", "You do not have an open slot to equip this shield in!")
	return false;
end

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

-- Called when the item should be setup.
function ITEM:OnSetup()
	if (!self("weaponClass")) then
		self:Override("weaponClass", self("uniqueID"));
	end;
	
	self:Override("weaponClass", string.lower(self("weaponClass")));
	
	--[[timer.Simple(2, function()
		local weaponClass = self("weaponClass");
		local weaponTable = weapons.GetStored(weaponClass);
		
		if (weaponTable) then
			if (!self("primaryAmmoClass")) then
				if (weaponTable.Primary and weaponTable.Primary.Ammo) then
					self:Override("primaryAmmoClass", weaponTable.Primary.Ammo);
				end;
			end;
			
			if (!self("secondaryAmmoClass")) then
				if (weaponTable.Secondary and weaponTable.Secondary.Ammo) then
					self:Override("secondaryAmmoClass", weaponTable.Secondary.Ammo);
				end;
			end;
			
			if (!self("primaryDefaultAmmo")) then
				if (weaponTable.Primary and weaponTable.Primary.DefaultClip) then
					if (weaponTable.Primary.DefaultClip > 0) then
						if (weaponTable.Primary.ClipSize == -1) then
							self:Override("primaryDefaultAmmo", weaponTable.Primary.DefaultClip);
							self:Override("hasNoPrimaryClip", true);
						else
							self:Override("primaryDefaultAmmo", true);
						end;
					end;
				end;
			end;
			
			if (!self("secondaryDefaultAmmo")) then
				if (weaponTable.Secondary and weaponTable.Secondary.DefaultClip) then
					if (weaponTable.Secondary.DefaultClip > 0) then
						if (weaponTable.Secondary.ClipSize == -1) then
							self:Override("secondaryDefaultAmmo", weaponTable.Secondary.DefaultClip);
							self:Override("hasNoSecondaryClip", true);
						else
							self:Override("secondaryDefaultAmmo", true);
						end;
					end;
				end;
			end;
		elseif (defaultWeapons[weaponClass]) then
			if (!self("primaryAmmoClass")) then
				self:Override("primaryAmmoClass", defaultWeapons[weaponClass][1]);
			end;
			
			if (!self("secondaryAmmoClass")) then
				self:Override("secondaryAmmoClass", defaultWeapons[weaponClass][2]);
			end;
			
			if (!self("primaryDefaultAmmo")) then
				self:Override("primaryDefaultAmmo", defaultWeapons[weaponClass][3]);
			end;
			
			if (!self("secondaryDefaultAmmo")) then
				self:Override("secondaryDefaultAmmo", defaultWeapons[weaponClass][4]);
			end;
		end;
	end);]]--
end;

-- Called when a player holsters the item.
function ITEM:OnHolster(player, bForced) end;

Clockwork.item:Register(ITEM);