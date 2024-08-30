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
ITEM.slots = {"Primary", "Secondary", "Tertiary"};
ITEM.equipmentSaveString = "weapons";

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

function ITEM:HasPlayerEquipped(player)
	return player:GetWeaponEquipped(self);
end

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
	local isOffhand = false;
	local activeWeapon = player:GetActiveWeapon();
	local weapon = player:GetWeapon(self.weaponClass);
	
	if (extraData != "drop") then
		if !player:IsNoClipping() and (!player.GetCharmEquipped or !player:GetCharmEquipped("urn_silence")) then
			local useSound = self("useSound");
			
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
		
		if weapon then
			if (SERVER) then
				for k, v in pairs(player.equipmentSlots) do
					if v then
						if v.category == "Shields" then
							-- Old code, restore if you want the old functionality for one shield per weapon.
							--[[if IsValid(weapon) and weapon:GetNWString("activeShield"):len() > 0 and weapon:GetNWString("activeShield") == v.uniqueID then
								local weaponItemTable = item.GetByWeapon(weapon);
								
								if weaponItemTable and weaponItemTable:IsTheSameAs(self) then
									Clockwork.kernel:ForceUnequipItem(player, v.uniqueID, v.itemID);
								end
								
								break;
							end]]--
							
							-- New code.
							
							local other_melee_found = false;
							
							for k2, v2 in pairs(player.equipmentSlots) do
								if !string.find(k2, "Offhand") and !player.equipmentSlots[k2.."Offhand"] then
									if v2.canUseShields and !v2:IsTheSameAs(self) then
										other_melee_found = true;
										
										break;
									end
								end
							end
							
							if !other_melee_found then
								Clockwork.kernel:ForceUnequipItem(player, v.uniqueID, v.itemID);
							end
						elseif string.find(k, "Offhand") then
							local mainSlot = string.gsub(k, "Offhand", "");
							
							if player.equipmentSlots[mainSlot] then
								if player.equipmentSlots[mainSlot].itemID == self.itemID then
									if IsValid(weapon) and weapon:GetNWString("activeOffhand"):len() > 0 and weapon:GetNWString("activeOffhand") == v.uniqueID then
										Clockwork.kernel:ForceUnequipItem(player, v.uniqueID, v.itemID);
									
										break;
									end
								elseif player.equipmentSlots[k].itemID == self.itemID then
									weapon = player:GetWeapon(player.equipmentSlots[mainSlot].weaponClass);
									
									if weapon then
										if IsValid(weapon) and weapon:GetNWString("activeOffhand"):len() > 0 then
											weapon:HolsterOffhand();
										end
									end
									
									isOffhand = true;
									
									break;
								end
							end
						end
					end
				end
			end
		end
		
		if !isOffhand then
			if IsValid(activeWeapon) and activeWeapon:GetClass() == self.weaponClass then
				player:SelectWeapon("begotten_fists")
			end
			
			player:StripWeapon(self.weaponClass)
		end
		
		return Clockwork.equipment:UnequipItem(player, self);
	elseif (hook.Run("PlayerCanDropWeapon", player, self)) then
		local trace = player:GetEyeTraceNoCursor()

		if (player:GetShootPos():Distance(trace.HitPos) <= 192) then
			if weapon then
				if (SERVER) then
					for k, v in pairs(player.equipmentSlots) do
						if v then
							if v.category == "Shields" then
								if IsValid(weapon) and weapon:GetNWString("activeShield"):len() > 0 and weapon:GetNWString("activeShield") == v.uniqueID then
									local weaponItemTable = item.GetByWeapon(weapon);
									
									if weaponItemTable and weaponItemTable:IsTheSameAs(self) then
										Clockwork.kernel:ForceUnequipItem(player, v.uniqueID, v.itemID);
									end
									
									break;
								end
							elseif string.find(k, "Offhand") then
								local mainSlot = string.gsub(k, "Offhand", "");
								
								if player.equipmentSlots[mainSlot] then
									if player.equipmentSlots[mainSlot].itemID == self.itemID then
										if IsValid(weapon) and weapon:GetNWString("activeOffhand"):len() > 0 and weapon:GetNWString("activeOffhand") == v.uniqueID then
											Clockwork.kernel:ForceUnequipItem(player, v.uniqueID, v.itemID);
										
											break;
										end
									elseif player.equipmentSlots[k].itemID == self.itemID then
										weapon = player:GetWeapon(player.equipmentSlots[mainSlot].weaponClass);
										
										if weapon then
											if IsValid(weapon) and weapon:GetNWString("activeOffhand"):len() > 0 then
												weapon:HolsterOffhand();
											end
										end
										
										isOffhand = true;
										
										break;
									end
								end
							end
						end
					end
				end
			end
		
			local entity = Clockwork.entity:CreateItem(player, self, trace.HitPos)

			if (IsValid(entity)) then		
				Clockwork.entity:MakeFlushToGround(entity, trace.HitPos, trace.HitNormal)
				hook.Run("PlayerDropWeapon", player, self, entity)

				player:TakeItem(self)
				
				if !isOffhand then
					if IsValid(activeWeapon) and activeWeapon:GetClass() == self.weaponClass then
						player:SelectWeapon("begotten_fists")
					end
					
					player:StripWeapon(self.weaponClass);
				end

				return Clockwork.equipment:UnequipItem(player, self);
			end
		else
			Schema:EasyText(player, "peru", "You cannot drop this item that far away.")
		end
	end
end;

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
	
	if clipOne and (clipOne > 0) then
		weapon:SetClip1(clipOne);
		self:SetData("ClipOne", 0);
	end;
	
	if clipTwo and (clipTwo > 0) then
		weapon:SetClip2(clipTwo);
		self:SetData("ClipTwo", 0);
	end;
end;

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity, interactItemTable)
	local faction = player:GetFaction();
	local subfaction = player:GetSubfaction();
	local kinisgerOverride = player:GetNetVar("kinisgerOverride");
	local kinisgerOverrideSubfaction = player:GetNetVar("kinisgerOverrideSubfaction");
	
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
	
	if (!player:HasWeapon(weaponClass)) or interactItemTable then
		if (self.OnEquip) then
			if self:OnEquip(player, interactItemTable) == false then
				return false;
			end
		end;
	
		if interactItemTable then
			local activeWeapon = player:GetActiveWeapon();
			
			if activeWeapon:GetClass() == interactItemTable.weaponClass then
				activeWeapon:EquipOffhand(self.weaponClass);
			end
		else
			local weapon = player:Give(weaponClass, self);
			
			if IsValid(weapon) then
				-- Check for equipped shields.
				if self.canUseShields then
					for i, v in ipairs(self.slots) do
						local shieldItem = player.equipmentSlots[v];
						
						if shieldItem and shieldItem.category == "Shields" then
							weapon:EquipShield(shieldItem.uniqueID);
						
							break;
						end
					end
				end
			end
		end
		
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

function ITEM:OnEquip(player, interactItemTable)
	if self:IsBroken() then
		Schema:EasyText(player, "peru", "This weapon is broken and cannot be used!");
		return false;
	end

	if interactItemTable then
		local slot;
		local offhandSlot;
		
		for k, v in pairs(player.equipmentSlots) do
			if v and (v:IsTheSameAs(interactItemTable)) then
				slot = k;
				offhandSlot = k.."Offhand";
				
				break;
			end
		end
		
		if slot then
			if !player.equipmentSlots[slot] then
				Schema:EasyText(player, "peru", "You cannot equip an offhand weapon in a slot with no weapon!")
				return false;
			end
			
			local shieldItem = player:GetShieldEquipped();
			
			if shieldItem then
				local numValidItems = 0;
			
				for i, v in ipairs(player:GetWeaponsEquipped()) do
					if v.canUseShields then
						numValidItems = numValidItems + 1;
					end
				end
				
				if numValidItems < 2 then
					local weaponItem = item.GetByWeapon(interactItemTable.weaponClass or interactItemTable.uniqueID);
					
					if !weaponItem or !weaponItem:IsTheSameAs(interactItemTable) then
						Schema:EasyText(player, "peru", "You cannot equip an offhand weapon with a weapon that is using a shield!")
						return false;
					end
				end
			end
			
			local weaponClass = interactItemTable("weaponClass");
			local weaponTable = weapons.GetStored(weaponClass);
			local attackTable = GetTable(weaponTable.AttackTable);
			local offhandWeaponClass = self("weaponClass");
			local offhandWeaponTable = weapons.GetStored(offhandWeaponClass);
			local offhandAttackTable = GetTable(offhandWeaponTable.AttackTable);
			
			if !attackTable.canaltattack and attackTable.dmgtype == DMG_VEHICLE and !offhandAttackTable.canaltattack and offhandAttackTable.dmgtype ~= DMG_VEHICLE then
				Schema:EasyText(player, "peru", "You cannot equip a slash-only weapon with a thrust-only weapon!");
				return false;
			elseif !attackTable.canaltattack and attackTable.dmgtype ~= DMG_VEHICLE and !offhandAttackTable.canaltattack and offhandAttackTable.dmgtype == DMG_VEHICLE then
				Schema:EasyText(player, "peru", "You cannot equip a thrust-only weapon with a slash-only weapon!");
				return false;
			end
			
			if !player.equipmentSlots[offhandSlot] then
				return Clockwork.equipment:EquipItem(player, self, offhandSlot);
			end
			
			Schema:EasyText(player, "peru", "You cannot equip another weapon in that slot!")
			return false;
		end
		
		Schema:EasyText(player, "peru", "A valid slot could not be found for this weapon!")
		return false;
	else
		for i, slot in ipairs(self.slots) do
			if !player.equipmentSlots[slot] then
				return Clockwork.equipment:EquipItem(player, self, slot);
			end
		end
		
		Schema:EasyText(player, "peru", "You do not have an open slot to equip this weapon in!")
		return false;
	end
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

Clockwork.item:Register(ITEM);