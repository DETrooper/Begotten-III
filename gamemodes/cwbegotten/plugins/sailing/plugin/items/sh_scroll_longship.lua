--[[
	By: DETrooper
--]]

local cwSailing = cwSailing;

local ITEM = Clockwork.item:New();
	ITEM.name = "Scroll of a Goreic Longship";
	ITEM.uniqueID = "scroll_longship";
	ITEM.category = "Naval";
	ITEM.model = "models/items/magic/scrolls/scroll_open.mdl";
	ITEM.weight = 0.1;
	ITEM.description = "A scroll and some basic navigational equipment. It shows a detailed map to where a Goreic Longship is docked.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/scroll_open.png";
	ITEM.longshipEnt = "cw_longship";
	ITEM:AddData("customName", "", true);
	ITEM:AddData("enchantment", false);
	ITEM:AddData("health", -1, true);
	
	function ITEM:OnUseCustom(player, itemEntity, itemFunction)
		if (game.GetMap() != "rp_begotten3" and game.GetMap() != "rp_district21") then
			return false;
		end;
	
		local faction = player:GetFaction();
		
		if (faction ~= "Goreic Warrior") then
			Schema:EasyText(player, "chocolate", "You are not the correct faction to use this item!");
			return false;
		end;
		
		if player:GetCharacterData("LastZone") ~= "gore" then
			Schema:EasyText(player, "peru", "You must be in the Goreic forest to use this item!");
			return false;
		end
		
		--[[if itemFunction == "dock" then
			local longshipEnt = cwSailing:LongshipExists(self.itemID);
			
			if longshipEnt then
				longshipEnt:Remove();
			else
				Schema:EasyText(player, "peru", "This longship is already docked!");
			end
		else]]if itemFunction == "undock" then
			if cwSailing:LongshipExists(self.itemID) then
				Schema:EasyText(player, "peru", "This longship is already undocked!");
				return false;
			end
			
			local longshipEnt = cwSailing:SpawnLongship(player, "docks", self);
			
			if longshipEnt then
				if self:GetData("customName") and self:GetData("customName") ~= "" then
					longshipEnt:SetNWString("name", self:GetData("customName"));
				end
				
				if longshipEnt.longshipType ~= "ironclad" then
					if self:GetData("health") == -1 then
						if player:GetSubfaction() == "Clan Harald" then
							longshipEnt.health = 1000;
						else
							longshipEnt.health = 500;
						end
					else
						longshipEnt.health = self:GetData("health", 500);
					end
					
					if self:GetData("enchantment") == true then
						longshipEnt.enchantment = true;
					end
					
					--self:SetData("health", longshipEnt.health);
				end
			else
				return false;
			end
		elseif itemFunction == "rename" then
			Clockwork.dermaRequest:RequestString(player, "Rename Longship", "What would you like to rename this Longship to?", "", function(result)
				if result and result:len() > 0 then
					local longshipEnt = cwSailing:LongshipExists(self.itemID);
				
					if IsValid(longshipEnt) then
						longshipEnt:SetNWString("name", result);
					end
					
					self:SetData("customName", result); 
				end
			end);
			
			return false;
		end
		
		player:EmitSound("begotten/items/note_turn.wav");

		--return false; -- Prevent this item from being used, it should be permanent.
		
		return true;
	end
	
	function ITEM:GetCustomName()
		local customName = self:GetData("customName");
		
		if customName and customName ~= "" then
			return "Scroll of \""..customName.."\"";
		else
			return self.name;
		end
	end

	--[[function ITEM:CanTakeStorage(player, storageTable)
		local faction = player:GetFaction();
		
		if (faction ~= "Goreic Warrior") then
			return false;
		end;
	end;
	
	function ITEM:CanPickup(player, quickUse, itemEntity)
		local faction = player:GetFaction();
		
		if (faction ~= "Goreic Warrior") then
			return false;
		end;
	end;]]--
	
	function ITEM:OnDrop(player, itemEntity)
		
	end;
Clockwork.item:Register(ITEM);

local ITEM = Clockwork.item:New();
	ITEM.name = "Scroll of a Shagalaxian Ironclad";
	ITEM.uniqueID = "scroll_ironclad";
	ITEM.category = "Naval";
	ITEM.model = "models/items/magic/scrolls/scroll_open.mdl";
	ITEM.weight = 0.1;
	ITEM.description = "In the legends of Clan Shagalax, it is said that a thousand steam tanks descended upon the followers of the Glaze. Confined to the Gore Forest, Clan Shagalax has continued this tradition by adapting their methods to naval war machines.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/scroll_open.png";
	ITEM.longshipEnt = "cw_longship_ironclad";
	ITEM:AddData("customName", "", true);
	ITEM:AddData("enchantment", false);
	ITEM:AddData("fuel", 0);
	ITEM:AddData("machinegunUpgrade", false);
	ITEM:AddData("ammo", 0);
	
	function ITEM:OnUseCustom(player, itemEntity, itemFunction)
		if (game.GetMap() != "rp_begotten3" and game.GetMap() != "rp_district21") then
			return false;
		end;
	
		local faction = player:GetFaction();
		
		if (faction ~= "Goreic Warrior") then
			Schema:EasyText(player, "chocolate", "You are not the correct faction to use this item!");
			return false;
		end;
		
		if player:GetCharacterData("LastZone") ~= "gore" then
			Schema:EasyText(player, "peru", "You must be in the Goreic forest to use this item!");
			return false;
		end
		
		--[[if itemFunction == "dock" then
			local longshipEnt = cwSailing:LongshipExists(self.itemID);
			
			if longshipEnt then
				longshipEnt:Remove();
			else
				Schema:EasyText(player, "peru", "This ironclad is already docked!");
			end
		else]]if itemFunction == "undock" then
			if cwSailing:LongshipExists(self.itemID) then
				Schema:EasyText(player, "peru", "This ironclad is already undocked!");
				return false;
			end
			
			local longshipEnt = cwSailing:SpawnLongship(player, "docks", self);
			
			if longshipEnt then
				if self:GetData("customName") and self:GetData("customName") ~= "" then
					longshipEnt:SetNWString("name", self:GetData("customName"));
				end

				if (longshipEnt.longshipType != "longship") then
					if (self:GetData("enchantment") == true) then
						longshipEnt.enchantment = true
					end
				end
			else
				return false;
			end
		elseif itemFunction == "rename" then
			Clockwork.dermaRequest:RequestString(player, "Rename Ironclad", "What would you like to rename this Ironclad to?", "", function(result)
				if result and result:len() > 0 then
					local longshipEnt = cwSailing:LongshipExists(self.itemID);
				
					if IsValid(longshipEnt) then
						longshipEnt:SetNWString("name", result);
					end
					
					self:SetData("customName", result); 
				end
			end);
			
			return false;
		end
		
		player:EmitSound("begotten/items/note_turn.wav");

		--return false; -- Prevent this item from being used, it should be permanent.
		
		return true;
	end
	
	function ITEM:GetCustomName()
		local customName = self:GetData("customName");
		
		if customName and customName ~= "" then
			return "Scroll of \""..customName.."\"";
		else
			return self.name;
		end
	end

	--[[function ITEM:CanTakeStorage(player, storageTable)
		local faction = player:GetFaction();
		
		if (faction ~= "Goreic Warrior") then
			return false;
		end;
	end;
	
	function ITEM:CanPickup(player, quickUse, itemEntity)
		local faction = player:GetFaction();
		
		if (faction ~= "Goreic Warrior") then
			return false;
		end;
	end;]]--
	
	function ITEM:OnDrop(player, itemEntity)
		
	end;
Clockwork.item:Register(ITEM);

local ITEM = Clockwork.item:New();
	ITEM.name = "Ironclad Machinegun Upgrade Kit";
	ITEM.uniqueID = "ironclad_mgupgrade";
	ITEM.category = "Naval";
	ITEM.model = "models/kali/vehicles/cod4/technical_mg_m2.mdl";
	ITEM.weight = 30;
	ITEM.description = "It is recorded in oral histories that Clan Shagalax once relied on overwhelming firepower in industrialized warfare with their southern rival. Among the tribes of the border area formerly known as Utah, such examples can be found and collected for an exorbitant price.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/ironclad_mgupgrade.png";
	ITEM.useText = "Upgrade Ironclad";
	
	function ITEM:OnUse(player, itemEntity, itemFunction)
		if (game.GetMap() != "rp_begotten3" and game.GetMap() != "rp_district21") then
			return;
		end;
		
		local characterID = player:GetCharacterKey();
		local longshipEnt;
		
		for i, v in ipairs(ents.FindByClass("cw_longship_ironclad")) do
			if v.ownerID and v.ownerID == characterID then
				longshipEnt = v;
				
				break;
			end
		end
		
		if !IsValid(longshipEnt) or longshipEnt:GetClass() ~= "cw_longship_ironclad" then
			Schema:EasyText(player, "peru", "You must have an active Ironclad to mount this machinegun!");
			
			return false;
		end
		
		local tr = util.TraceHull({
			start = player:EyePos(),
			endpos = player:GetPos() - Vector(0, 0, 100),
			maxs = player:OBBMaxs(),
			mins = player:OBBMins(),
			filter = function( ent ) return ( ent == longshipEnt ) end,
			collisiongroup = COLLISION_GROUP_NONE,
		});
		
		if !IsValid(tr.Entity) or tr.Entity ~= longshipEnt then
			Schema:EasyText(player, "peru", "You must be standing on your Ironclad to mount this machinegun!");
			
			return false;
		end
		
		--[[if longshipEnt.itemID then
			local itemTable = item.FindInstance(longshipEnt.itemID);
			
			if itemTable then
				if itemTable:GetData("machinegunUpgrade") == true then
					Schema:EasyText(player, "peru", "This ironclad has already been upgraded!");
				
					return false;
				else
					itemTable:SetData("machinegunUpgrade", true);
				end
			end
		end]]--
		
		if IsValid(longshipEnt.machinegun) then
			Schema:EasyText(player, "peru", "This ironclad has already been upgraded!");
			
			return false;
		end
		
		player:EmitSound("oneuse_deploy.ogg");
		
		longshipEnt:AttachMachinegun();
	end;
	
	function ITEM:OnDrop(player, itemEntity)
		
	end;
Clockwork.item:Register(ITEM);

local ITEM = Clockwork.item:New();
	ITEM.name = "Ironclad Ammo Box";
	ITEM.uniqueID = "ironclad_ammo_box";
	ITEM.category = "Naval";
	ITEM.model = "models/kali/vehicles/cod4/technical_mg_m2_ammobox_closed.mdl";
	ITEM.weight = 15;
	ITEM.description = "A box of old world ammunition acquired from the distant Goreic tribes of Utah, specifically for use in the Ironclad's mounted machinegun.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/ironclad_ammo_box.png";
	
	function ITEM:OnDrop(player, itemEntity)
		
	end;
Clockwork.item:Register(ITEM);