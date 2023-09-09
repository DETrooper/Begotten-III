--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

local playerMeta = FindMetaTable("Player");

cwShacks.expireTime = 604800; -- 1 week in seconds.

local charactersTable = config.Get("mysql_characters_table"):Get()
local map = game.GetMap() == "rp_begotten3";
-- Called when Clockwork has loaded all of the entities.
function cwShacks:ClockworkInitPostEntity()
	if (!map) then
		return;
	end;
	
	self:LoadShackData()
end

-- Called when a player's shared variables should be set.
--[[function cwShacks:OnePlayerSecond(player, curTime)
	if self.shacks then
		player:SetSharedVar("shack", player:GetOwnedShack());
	else
		self:LoadShackData();
		
		timer.Simple(5, function()
			if IsValid(player) then
				player:SetSharedVar("shack", player:GetOwnedShack());
			end
		end);
	end
end;]]--

-- A function for when a player purchases (or attempts to purchase) a shack!
function cwShacks:ShackPurchased(player, shack)
	if player:GetOwnedShack() then
		Schema:EasyText(player, "peru", "You already own a property and cannot own more than one!");
		return;
	end
	
	--[[if cwBeliefs and !player:HasBelief("literacy") then
		Schema:EasyText(player, "chocolate", "You must be literate in order to buy property!");
		return;
	end]]--
	
	local characterKey = player:GetCharacterKey();
	
	if !characterKey then
		Schema:EasyText(player, "red", "Your character key is invalid! You may need to rejoin in order to buy property!");
		
		return;
	end

	for k, v in pairs(self.shacks) do
		if k == shack then
			if not v.owner then
				local price = v.cost;
				
				if Clockwork.player:CanAfford(player, price) then
					v.owner = player:GetCharacterKey();
					v.stash = {};
					v.stashCash = 0;
					
					Clockwork.player:GiveCash(player, -price, nil, true);
					Clockwork.player:GiveDoor(player, v.doorEnt);
					Schema:ModifyTowerTreasury(price);
					
					player:SetSharedVar("shack", shack);
					Clockwork.player:GiveSpawnWeapon(player, "cw_keys");
					
					self:NetworkShackData();
					self:SaveShackData();
					
					Schema:EasyText(player, "olivedrab", "You have bought a property. It will be in your ownership until you expire or if your character has inactive for longer than one week. You may use /OpenStash to access your property's inventory, and the positive effects of /Sleep will be boosted depending on the quality of your property. You will now also spawn with 'Keys' to unlock and lock your property.");
					Clockwork.kernel:PrintLog(LOGTYPE_GENERIC, player:Name().." has bought the property '"..k.."' for "..price.." coin! The treasury now sits at "..Schema.towerTreasury..".");
					
					return;
				else
					local amount = price - player:GetCash();
					
					Schema:EasyText(player, "chocolate", "You need another "..Clockwork.kernel:FormatCash(price, nil, true).." to purchase this property!");
					
					return;
				end
			else
				Schema:EasyText(player, "darkgrey", "This property is already owned by someone!");
				
				return;
			end
		end
	end
	
	Schema:EasyText(player, "grey", "The property "..shack.." could not be found!");
end

-- A function to sell shacks.
function cwShacks:ShackSold(player, shack)
	local characterKey = player:GetCharacterKey();
	
	if !characterKey then
		Schema:EasyText(player, "red", "Your character key is invalid! You may need to rejoin in order to sell property!");
		
		return;
	end

	for k, v in pairs(self.shacks) do
		if k == shack then
			local price = v.cost / 2;
			
			if Schema.towerTreasury >= price then
				v.owner = nil;
				v.stash = nil;
				v.stashCash = nil;
				
				Clockwork.entity:ClearProperty(v.doorEnt);
				Clockwork.player:GiveCash(player, (price), nil, true);
				Schema:ModifyTowerTreasury(-price);
				
				player:SetSharedVar("shack", nil);
				
				if player:GetFaction() ~= "Holy Hierarchy" then
					Clockwork.player:TakeSpawnWeapon(player, "cw_keys");
				end
				
				self:NetworkShackData();
				self:SaveShackData();
				
				Schema:EasyText(player, "olivedrab", "You have sold your property for "..Clockwork.kernel:FormatCash(price, nil, true).."!");
				Clockwork.kernel:PrintLog(LOGTYPE_GENERIC, player:Name().." has sold the property '"..k.."' for "..price.." coin! The treasury now sits at "..Schema.towerTreasury..".");
			else
				Schema:EasyText(player, "olivedrab", "This property cannot be sold as there is not enough money in the Tower treasury to refund you!");
			end
		end
	end
end

function cwShacks:ShackForeclosed(player, shack)
	for k, v in pairs(self.shacks) do
		if k == shack then
			v.owner = nil;
			v.stash = nil;
			v.stashCash = nil;
			
			if IsValid(player) then
				player:SetSharedVar("shack", nil);
				
				if player:GetFaction() ~= "Holy Hierarchy" then
					Clockwork.player:TakeSpawnWeapon(player, "cw_keys");
				end
			end
			
			Clockwork.entity:ClearProperty(v.doorEnt);
			
			self:NetworkShackData();
			self:SaveShackData();
			return;
		end
	end
end

function cwShacks:ShackStashOpen(player)
	if (!map) then
		return;
	end;
	
	local characterKey = player:GetCharacterKey();
	
	if !characterKey then
		Schema:EasyText(player, "red", "Your character key is invalid! You may need to rejoin in order to interact with property!");
		return;
	end

	local playerPos = player:GetPos();
	
	for k, v in pairs(self.shacks) do
		if playerPos:WithinAABox(v.pos1, v.pos2) then
			if v.owner then
				if k == player:GetSharedVar("shack") or player:IsAdmin() then
					if IsValid(v.stashEnt) then
						v.stashEnt:Remove();
					end
				
					if !IsValid(v.stashEnt) then
						local stashEnt = ents.Create("prop_physics");
						
						stashEnt:SetModel("models/props/cs_militia/footlocker01_closed.mdl");
						stashEnt:SetPos(player:GetPos());
						stashEnt:SetCollisionGroup(COLLISION_GROUP_WORLD);
						stashEnt:SetRenderMode(RENDERMODE_TRANSALPHA);
						stashEnt:SetColor(Color(0, 0, 0, 0));
						stashEnt:DrawShadow(false);
						stashEnt:Spawn();
						
						stashEnt:SetNetVar("stash", true);
						
						physicsObject = stashEnt:GetPhysicsObject();
						
						if (IsValid(physicsObject)) then
							physicsObject:Wake();
							physicsObject:EnableMotion(false);
						end;
						
						stashEnt.cwInventory = v.stash;
						stashEnt.cwCash = v.stashCash;
						stashEnt.shack = k;
						v.stashEnt = stashEnt;
					end

					timer.Simple(0.5, function()
						if IsValid(player) and IsValid(v.stashEnt) then
							Clockwork.storage:Open(player, {
								name = "Stash",
								weight = v.stashSize or 40,
								entity = v.stashEnt,
								distance = 192,
								cash = v.stashEnt.cwCash,
								inventory = v.stashEnt.cwInventory,
								OnClose = function(player, storageTable, entity)
									v.stash = entity.cwInventory;
									v.stashCash = entity.cwCash;
								
									if IsValid(entity) then
										entity:Remove();
									end
								end,
								OnGiveCash = function(player, storageTable, cash)
									storageTable.entity.cwCash = storageTable.cash
								end,
								OnTakeCash = function(player, storageTable, cash)
									storageTable.entity.cwCash = storageTable.cash
								end
							});
						end
					end);
					
					return;
				end
			else
				Schema:EasyText(player, "darkgrey", "This property does not have a stash as it does not have an owner!");
				return;
			end
		end
	end
	
	Schema:EasyText(player, "peru", "You must be inside your own property to open its stash!");
end

function cwShacks:GetPropertyInfo(player, shack)
	local faction = player:GetFaction();

	if faction == "Holy Hierachy" or player:IsAdmin() then	
		if !shack or not istable(shack) then
			local playerPos = player:GetPos();
			local trace = player:GetEyeTrace();
			local entity = trace.Entity;
		
			for k, v in pairs(self.shacks) do
				if (playerPos:WithinAABox(v.pos1, v.pos2)) or (IsValid(entity) and v.doorEnt == entity) then
					shack = v;
					break;
				end
			end
		end
		
		if shack then
			local charactersTable = config.Get("mysql_characters_table"):Get();
			local items = 0;
			
			if shack.owner then
				local queryObj = Clockwork.database:Select(charactersTable)
					queryObj:Callback(function(result)
						if (Clockwork.database:IsResult(result)) then
							for k, v in pairs(result) do
								if v._Name and v._LastPlayed then
									if shack.stash then
										for k2, v2 in pairs(shack.stash) do
											if v2 then
												for k3, v3 in pairs(v2) do
													items = items + 1;
												end
											end
										end
									end
									
									local timeLastPlayed = tostring(os.time() - tonumber(v._LastPlayed));
									
									if player:IsAdmin() then
										Schema:EasyText(player, "cornflowerblue", "Property Owner: "..v._Name.." ("..v._SteamName..")");
										Schema:EasyText(player, "cornflowerblue", "(ADMIN DEBUG) Door Ent: "..tostring(shack.doorEnt).."   # of Stash Items: "..tostring(items).."   Time Last Played: "..timeLastPlayed.." seconds ago");
									else
										Schema:EasyText(player, "cornflowerblue", "Property Owner: "..v._Name);
									end
									
									break;
								end
							end
						end
					end);
					
					queryObj:Where("_Key", shack.owner)
				queryObj:Execute()
			else
				Schema:EasyText(player, "cornflowerblue", "Property Owner: Unowned");
			end
		else
			Schema:EasyText(player, "grey", "A valid property could not be found!");
		end
	else
		Schema:EasyText(player, "peru", "You are not the correct faction to do this!");
	end
end

-- A function for detecting if a player is inside a given shack.
function cwShacks:PlayerInsideShack(player, shack)
	for k, v in pairs(self.shacks) do
		if k == shack then
			return player:GetPos():WithinAABox(v.pos1, v.pos2);
		end
	end
	
	return false;
end

function cwShacks:PlayerCanOpenContainer(player, container)
	if container.shack and container.shack ~= player:GetSharedVar("shack") and !player:IsAdmin() then
		return false;
	end
end

function playerMeta:InsideShack(shack)
	return cwShacks:PlayerInsideShack(self, shack);
end

function playerMeta:InsideOwnedShack()
	local ownedShack = self:GetSharedVar("shack");
	
	if ownedShack then
		return cwShacks:PlayerInsideShack(self, ownedShack);
	else
		return false;
	end
end

function playerMeta:GetOwnedShack()
	local characterKey = self:GetCharacterKey();
	
	if !characterKey then
		return;
	end

	for k, v in pairs(cwShacks.shacks) do
		if v.owner == characterKey then
			return k;
		end
	end
end

function playerMeta:GetPlayerShackData()
	for k, v in pairs(cwShacks.shacks) do
		if v.owner == self:GetCharacterKey() then
			local shackData = {};
			
			shackData.bedTier = v.bedTier;
			shackData.doorEnt = v.doorEnt;
			shackData.stash = v.stash;
			shackData.stashCash = v.stashCash;
		end
	end
end

function playerMeta:ForecloseShack(shack)
	cwShacks:ShackForeclosed(self, shack)
end

function cwShacks:NetworkShackData()
	local shackInfo = {};
	
	for k, v in pairs(self.shacks) do
		shackInfo[k] = v.owner;
	end

	for k, v in pairs (_player.GetAll()) do
		Clockwork.datastream:Start(v, "ShackInfo", shackInfo);
	end
end

-- A function to load the shack owners.
function cwShacks:LoadShackData()
	if (!map) then
		return;
	end;

	if !self.shacks then
		self.shacks = {
			["A1"] = {pos1 = Vector(37.013779, 12976.841797, -1081), pos2 = Vector(163.824875, 12702.644531, -955.25061), doorPos = Vector(36, 12810, -1026), cost = 500, bedTier = 1, stashSize = 40, doorEnt = nil, owner = nil, stash = nil, stashCash = nil},
			["A2"] = {pos1 = Vector(154.158813, 12434.868164, -976.109253), pos2 = Vector(26.265575, 12692.110352, -1081), doorPos = Vector(25, 12465, -1026.125000), cost = 500, bedTier = 1, stashSize = 40, doorEnt = nil, owner = nil, stash = nil, stashCash = nil},
			["A3"] = {pos1 = Vector(-83.262093, 12162.241211, -1081), pos2 = Vector(-356.620117, 12036.083008, -955.413757), doorPos = Vector(-206, 12164, -1026), cost = 500, bedTier = 1, stashSize = 40, doorEnt = nil, owner = nil, stash = nil, stashCash = nil},
			["A4"] = {pos1 = Vector(-804.436707, 13005.667969, -1081), pos2 = Vector(-673.679993, 12748.556641, -965.855469), doorPos = Vector(-673, 12930, -1026), cost = 500, bedTier = 1, stashSize = 40, doorEnt = nil, owner = nil, stash = nil, stashCash = nil},
			["M1"] = {pos1 = Vector(-843.680786, 12746, -1081), pos2 = Vector(-1117.449219, 12619.226563, -967.197266), doorPos = Vector(-950, 12618, -1022.750000), cost = 700, bedTier = 1, stashSize = 60, doorEnt = nil, owner = nil, stash = nil, stashCash = nil},
			["M2"] = {pos1 = Vector(-2004.016113, 12314.244141, -1081), pos2 = Vector(-1874.978638, 12571.260742, -954.95282), doorPos = Vector(-1875, 12495, -1022.750000), cost = 700, bedTier = 1, stashSize = 60, doorEnt = nil, owner = nil, stash = nil, stashCash = nil},
			["M3"] = {pos1 = Vector(-2004.178711, 12574.166992, -970.9812), pos2 = Vector(-1874.538696, 12831.419922, -1081), doorPos = Vector(-1874, 12801, -1022.875000), cost = 700, bedTier = 1, stashSize = 60, doorEnt = nil, owner = nil, stash = nil, stashCash = nil},
			["M4"] = {pos1 = Vector(-1978.712036, 12960.448242, -1081), pos2 = Vector(-1705.644653, 12836.264648, -952.438416), doorPos = Vector(-1811, 12834.593750, -1022.750000), cost = 700, bedTier = 1, stashSize = 60, doorEnt = nil, owner = nil, stash = nil, stashCash = nil},
			["B1"] = {pos1 = Vector(-876.418213, 12045.673828, -700), pos2 = Vector(-620.080261, 12175.291992, -571.366943), doorPos = Vector(-801, 12176, -643), cost = 350, bedTier = 1, stashSize = 40, doorEnt = nil, owner = nil, stash = nil, stashCash = nil},
			["B2"] = {pos1 = Vector(-569.935791, 12454.107422, -700), pos2 = Vector(-442.82843, 12727.579102, -589.316345), doorPos = Vector(-571, 12560, -643), cost = 350, bedTier = 1, stashSize = 40, doorEnt = nil, owner = nil, stash = nil, stashCash = nil},
			["B3"] = {pos1 = Vector(-397.652679, 12766.617188, -700), pos2 = Vector(-142.196655, 12895.430664, -574.654602), doorPos = Vector(-322, 12896, -643), cost = 350, bedTier = 1, stashSize = 40, doorEnt = nil, owner = nil, stash = nil, stashCash = nil},
			["B4"] = {pos1 = Vector(-285.686066, 13175.671875, -700), pos2 = Vector(-12.448647, 13301.737305, -573.351257), doorPos = Vector(-118, 13175, -643.125000), cost = 350, bedTier = 1, stashSize = 40, doorEnt = nil, owner = nil, stash = nil, stashCash = nil},
			["B5"] = {pos1 = Vector(38.330040, 13160.685547, -700), pos2 = Vector(295.445129, 13290.114258, -592.246033), doorPos = Vector(266, 13161, -643.125000), cost = 350, bedTier = 1, stashSize = 40, doorEnt = nil, owner = nil, stash = nil, stashCash = nil},
			["B6"] = {pos1 = Vector(164.536499, 12892.866211, -700), pos2 = Vector(437.507385, 12766.875977, -588.996704), doorPos = Vector(270, 12894, -643.187500), cost = 350, bedTier = 1, stashSize = 40, doorEnt = nil, owner = nil, stash = nil, stashCash = nil},
			["B7"] = {pos1 = Vector(365.298126, 13161.915039, -700), pos2 = Vector(622.124023, 13290.522461, -593.267456), doorPos = Vector(546, 13161, -643), cost = 350, bedTier = 1, stashSize = 40, doorEnt = nil, owner = nil, stash = nil, stashCash = nil},
			["B8"] = {pos1 = Vector(586.674683, 12731.111328, -700), pos2 = Vector(456.973694, 12474.118164, -592.470886), doorPos = Vector(587, 12656, -643), cost = 350, bedTier = 1, stashSize = 40, doorEnt = nil, owner = nil, stash = nil, stashCash = nil},
			["B9"] = {pos1 = Vector(1206.690674, 12500, -700), pos2 = Vector(1469.100464, 12002, -576), doorPos = Vector(1426, 12505,-643), cost = 1000, bedTier = 2, stashSize = 100, doorEnt = nil, owner = nil, stash = nil, stashCash = nil},
			["B10"] = {pos1 = Vector(1206.690674, 12500, -700), pos2 = Vector(950.859558, 12002, -576), doorPos = Vector(1034, 12505, -643), cost = 1000, bedTier = 2, stashSize = 100, doorEnt = nil, owner = nil, stash = nil, stashCash = nil},
			["B11"] = {pos1 = Vector(-1192.268555, 12500, -700), pos2 = Vector(-933, 12002, -576), doorPos = Vector(-972.96875, 12505, -643), cost = 1000, bedTier = 2, stashSize = 100, doorEnt = nil, owner = nil, stash = nil, stashCash = nil},
			["B12"] = {pos1 = Vector(-1192.268555, 12500, -700), pos2 = Vector(-1453, 12002, -576), doorPos = Vector(-1365, 12505, -643), cost = 1000, bedTier = 2, stashSize = 100, doorEnt = nil, owner = nil, stash = nil, stashCash = nil},
			["C2"] = {pos1 = Vector(-1192.268555, 12500, -505), pos2 = Vector(-1453, 12002, -372), doorPos = Vector(-1365, 12505, -451), cost = 1000, bedTier = 2, stashSize = 100, doorEnt = nil, owner = nil, stash = nil, stashCash = nil},
			["C3"] = {pos1 = Vector(-1710.958252, 12500, -505), pos2 = Vector(-1453, 12002, -372), doorPos = Vector(-1491, 12505, -451), cost = 1000, bedTier = 2, stashSize = 100, doorEnt = nil, owner = nil, stash = nil, stashCash = nil},
			["C4"] = {pos1 = Vector(-1710.958252, 12500, -505), pos2 = Vector(-1966, 12002, -372), doorPos = Vector(-1883, 12505, -451), cost = 1000, bedTier = 2, stashSize = 100, doorEnt = nil, owner = nil, stash = nil, stashCash = nil},
			["D1"] = {pos1 = Vector(-886.894104, 12380.319336, -313), pos2 = Vector(-643.248352, 12032.481445, -201.112366), doorPos = Vector(-656, 12213, -258.718750), cost = 600, bedTier = 1, stashSize = 60, doorEnt = nil, owner = nil, stash = nil, stashCash = nil},
			["D2"] = {pos1 = Vector(-1192.268555, 12500, -315), pos2 = Vector(-933, 12002, -185), doorPos = Vector(-972.968750, 12505, -259), cost = 1000, bedTier = 2, stashSize = 100, doorEnt = nil, owner = nil, stash = nil, stashCash = nil},
		};

		for k, v in pairs(Clockwork.entity:GetDoorEntities()) do
			if (IsValid(v)) then
				local position = v:GetPos()

				if (position) then
					for k2, v2 in pairs(self.shacks) do
						if position:IsEqualTol(v2.doorPos, 5) then
							v2.doorEnt = v;
							v:Fire("lock", "", 0);
							break;
						end
					end
				end
			end
		end
	end

	if !self.shackData then
		self.shackData = Clockwork.kernel:RestoreSchemaData("plugins/shacks/"..game.GetMap()) or {};
		
		local charactersTable = config.Get("mysql_characters_table"):Get()
		
		for k, v in pairs(self.shackData) do
			if v.owner == "" then v.owner = nil end;
			
			if !v.owner then
				self.shackData[k] = nil;
				
				continue;
			else
				if v.stash == "" then v.stash = nil end;
				if v.stashCash == "" then v.stashCash = nil end;
			end
			
			local queryObj = Clockwork.database:Select(charactersTable)
				queryObj:Callback(function(result)
					if (Clockwork.database:IsResult(result)) then
						local ownerFound = false;
					
						for k2, v2 in pairs(result) do
							--if v2._LastPlayed then
								local permakilled = false;
								
								if v2._Data then
									local data = Clockwork.player:ConvertDataString(player, v2._Data)
									
									if data then
										permakilled = data["permakilled"];
									end
								end
								
								if --[[tonumber(v2._LastPlayed) + cwShacks.expireTime > os.time() and]] permakilled ~= true then
									cwShacks.shacks[k].owner = v.owner;
									
									if v.stash then
										cwShacks.shacks[k].stash = Clockwork.inventory:ToLoadable(v.stash);
									end

									cwShacks.shacks[k].stashCash = v.stashCash;
									
									ownerFound = true;
									break;
								end
							--end
						end
						
						if !ownerFound then
							print("No owner found for shack "..k.."!");
							cwShacks.shacks[k].owner = nil;
							cwShacks.shacks[k].stash = nil;
							cwShacks.shacks[k].stashCash = nil;
						else
							print("Owner found for shack "..k.."!");
						end
					end
				end);
				
				queryObj:Where("_Key", v.owner)
			queryObj:Execute()
		end
	end
end

-- Called just after data should be saved.
function cwShacks:PostSaveData()
	if (!map) then
		return;
	end;

	self:SaveShackData();
end

-- A function to save the shack owners.
function cwShacks:SaveShackData()
	if (!map) then
		return;
	end;
	
	if !self.shackData then
		self.shackData = Clockwork.kernel:RestoreSchemaData("plugins/shacks/"..game.GetMap()) or {};
	end

	for k, v in pairs(self.shacks) do
		if !self.shackData[k] then
			self.shackData[k] = {owner = nil, stash = nil, stashCash = nil};
		end
		
		self.shackData[k].owner = v.owner;
		
		if v.stash then
			self.shackData[k].stash = Clockwork.inventory:ToSaveable(v.stash);
		end
		
		self.shackData[k].stashCash = v.stashCash;
	end

	Clockwork.kernel:SaveSchemaData("plugins/shacks/"..game.GetMap(), self.shackData)
end

-- Called when a player's weapons should be given.
function cwShacks:PlayerLoadout(player)
	if (!map) then
		return;
	end;
	
	local characterKey = player:GetCharacterKey();
	local faction = player:GetFaction();
	local ownedShackFound = false;
	local shackInfo = {};

	if faction == "Holy Hierarchy" then
		Clockwork.player:GiveSpawnWeapon(player, "cw_keys");
	end
	
	for k, v in pairs(self.shacks) do
		shackInfo[k] = v.owner;
		
		if characterKey and characterKey == v.owner then
			Clockwork.player:GiveDoor(player, v.doorEnt);
			
			player:SetSharedVar("shack", k);
			
			Clockwork.player:GiveSpawnWeapon(player, "cw_keys");
			
			ownedShackFound = true;
			break;
		end
	end

	if !ownedShackFound then
		player:SetSharedVar("shack", nil);
		
		if faction ~= "Holy Hierarchy" then
			Clockwork.player:TakeSpawnWeapon(player, "cw_keys");
		end
	end
	
	Clockwork.datastream:Start(player, "ShackInfo", shackInfo);
end;