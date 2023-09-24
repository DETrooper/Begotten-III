--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

local Clockwork = Clockwork;

local ITEM = Clockwork.item:New(nil, true);
ITEM.name = "Weapon Base";
ITEM.useText = "Equip";
ITEM.useSound = false;
ITEM.category = "Weapons";
ITEM.useInVehicle = false;
ITEM.excludeFactions = {};
ITEM.requireFaction = {};
ITEM.requireFaith = {};
ITEM.requireSubfaction = {};
ITEM.breakable = true;
ITEM.breakMessage = " shatters into pieces!";
ITEM.repairItem = "weapon_repair_kit";
ITEM.customFunctions = {"Engrave"};

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

ITEM:AddData("ClipOne", 0, true);
ITEM:AddData("ClipTwo", 0, true);
ITEM:AddData("engraving", "", true);
ITEM:AddData("kills", 0, true);

-- Called whent he item entity's menu options are needed.
function ITEM:GetEntityMenuOptions(entity, options)
	--[[if (self:HasSecondaryClip() or self:HasPrimaryClip()) then
		local informationColor = Clockwork.option:GetColor("information");
		local toolTip = Clockwork.kernel:AddMarkupLine("", "Salvage any ammo from this weapon.", informationColor);
		local clipOne = self:GetData("ClipOne");
		local clipTwo = self:GetData("ClipTwo");
		
		if (clipOne > 0 or clipTwo > 0) then
			if (clipOne > 0) then
				toolTip = Clockwork.kernel:AddMarkupLine(toolTip, "Primary: "..clipOne);
			end;
			
			if (clipTwo > 0) then
				toolTip = Clockwork.kernel:AddMarkupLine(toolTip, "Secondary: "..clipTwo);
			end;
			
			options["Ammo"] = {
				isArgTable = true,
				arguments = "cwItemAmmo",
				toolTip = toolTip
			};
		end;
	end;]]--
end;

function ITEM:Engrave(player, text, engravingItemTable)
	local nospaces = string.gsub(text,"%s+","")
	
	if string.len(text) > 32 then
		Schema:EasyText(player, "peru", "This name is too long!");
	elseif #nospaces == 0 then
		Schema:EasyText(player, "chocolate", "You can't leave this blank!");
	else
		self:SetData("engraving", text);
		player:TakeItem(engravingItemTable, true);
		Schema:EasyText(player, "olivedrab", "You engrave \'"..text.."\' into the side of your "..self.name..".");
		Clockwork.inventory:Rebuild(player);
	end;
end;

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
--[[function ITEM:OnPlayerUnequipped(player, extraData)
	local weapon = player:GetWeapon(self("weaponClass"));
	if (!IsValid(weapon)) then return; end;
	
	local itemTable = Clockwork.item:GetByWeapon(weapon);
	
	if (itemTable:IsTheSameAs(self)) then
		local class = weapon:GetClass();
		
		if (extraData != "drop") then
			if (Clockwork.plugin:Call("PlayerCanHolsterWeapon", player, self, weapon)) then
				if (player:GiveItem(self)) then
					Clockwork.plugin:Call("PlayerHolsterWeapon", player, self, weapon);
					player:StripWeapon(class);
					player:SelectWeapon("begotten_fists");
				end;
			end;
		elseif (Clockwork.plugin:Call("PlayerCanDropWeapon", player, self, weapon)) then
			local trace = player:GetEyeTraceNoCursor();
			
			if (player:GetShootPos():Distance(trace.HitPos) <= 192) then
				local entity = Clockwork.entity:CreateItem(player, self, trace.HitPos);
				
				if (IsValid(entity)) then
					Clockwork.entity:MakeFlushToGround(entity, trace.HitPos, trace.HitNormal);
					Clockwork.plugin:Call("PlayerDropWeapon", player, self, entity, weapon);

					player:TakeItem(self, true);
					player:StripWeapon(class);
					player:SelectWeapon("begotten_fists");
				end;
			else
				Schema:EasyText(player, "peru", "You cannot drop your weapon that far away!");
			end;
		end;
	end;
end;]]--

-- A function to get whether the item has a secondary clip.
function ITEM:HasSecondaryClip()
	return !self("hasNoSecondaryClip");
end;

-- A function to get whether the item has a primary clip.
function ITEM:HasPrimaryClip()
	return !self("hasNoPrimaryClip");
end;

-- A function to get whether the item is a throwable weapon.
function ITEM:IsThrowableWeapon()
	return self("isThrowableWeapon");
end;

-- A function to get whether the item is a fake weapon.
function ITEM:IsFakeWeapon()
	return self("isFakeWeapon");
end;

-- A function to get whether the item is a melee weapon.
function ITEM:IsMeleeWeapon()
	return self("isMeleeWeapon");
end;

-- Called when the item is given to a player as a weapon.
function ITEM:OnWeaponGiven(player, weapon)
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
end;

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	local faction = player:GetFaction();
	local subfaction = player:GetSubfaction();
	local kinisgerOverride = player:GetSharedVar("kinisgerOverride");
	local kinisgerOverrideSubfaction = player:GetSharedVar("kinisgerOverrideSubfaction");
	
	if (table.HasValue(self.excludeFactions, kinisgerOverride or faction)) then
		Schema:EasyText(player, "peru", "You are not the correct faction for this item!")
		return false
	end
	
	if #self.requireFaith > 0 then
		if (!table.HasValue(self.requireFaith, player:GetFaith())) then
			Schema:EasyText(player, "peru", "You are not the correct faith for this item!")
			return false
		end
	end
	
	if #self.requireFaction > 0 then
		if (!table.HasValue(self.requireFaction, faction) and (!kinisgerOverride or !table.HasValue(self.requireFaction, kinisgerOverride))) then
			Schema:EasyText(player, "peru", "You are not the correct faction for this item!")
			return false
		end
	end
	
	if #self.requireSubfaction > 0 then
		if (!table.HasValue(self.requireSubfaction, subfaction) and (!kinisgerOverrideSubfaction or !table.HasValue(self.requireSubfaction, kinisgerOverrideSubfaction))) then
			Schema:EasyText(player, "peru", "You are not the correct subfaction for this item!")
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
		
		local weapon = player:GetWeapon(weaponClass);
		
		if (IsValid(weapon)) then
			local weaponData = player.bgWeaponData or {}
			local weaponDataTable = {};
			
			weaponDataTable.itemID = self.uniqueID.." "..self.itemID
			weaponDataTable.uniqueID = self.uniqueID
			weaponDataTable.realID = self.itemID
			
			local weaponAlreadyInTable = false;
			
			for i = 1, #weaponData do
				if weaponData[i].uniqueID == weaponDataTable.uniqueID then
					weaponAlreadyInTable = true;
				end
			end
			
			if weaponAlreadyInTable == false then
				table.insert(weaponData, weaponDataTable);
			end

			Clockwork.datastream:Start(player, "BGWeaponData", weaponData);
			Clockwork.player:SaveGear(player);
			
			player.bgWeaponData = weaponData;
			
			if (self.OnWeaponEquipped) then
				self:OnWeaponEquipped(player, weapon);
			end;
		
			return true;
		else
			--Schema:EasyText(player, "peru", "This weapon is not valid! Contact an admin.")
			return false;
		end;
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

	local slots = {"Primary", "Secondary", "Tertiary"};
	--if (item.IsWeapon(self) and !self:IsFakeWeapon()) then
		for i = 1, #slots do
			if (!Clockwork.player:GetGear(player, slots[i])) then
				Clockwork.player:CreateGear(player, slots[i], self);
				player:RebuildInventory();
				
				return true;
			end
		end
	--end
	
	Schema:EasyText(player, "peru", "You do not have an open slot to equip this weapon in!")
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
	
	timer.Simple(2, function()
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
	end);
end;

-- Called when a player holsters the item.
function ITEM:OnHolster(player, bForced) end;

if (CLIENT) then
	function ITEM:GetClientSideInfo()
		if (!self:IsInstance()) then
			return;
		end;
		
		local clientSideInfo = "";
		local clipOne = self:GetData("ClipOne");
		local clipTwo = self:GetData("ClipTwo");
		
		if (clipOne > 0) then
			clientSideInfo = Clockwork.kernel:AddMarkupLine(clientSideInfo, "Clip One: "..clipOne);
		end;
		
		if (clipTwo > 0) then
			clientSideInfo = Clockwork.kernel:AddMarkupLine(clientSideInfo, "Clip Two: "..clipTwo);
		end;
		
		return (clientSideInfo != "" and clientSideInfo);
	end;
end;

Clockwork.item:Register(ITEM);
