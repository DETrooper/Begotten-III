timer.Create("LoadSH", 1, 0, function()
if (Clockwork) then
timer.Destroy("LoadSH")

properties.Remove = function(name)
	name = name:lower()
	
	properties.List[name] = nil;
end

-- Remove drive so admins don't accidentally possess props or items.
properties.Remove("drive");

-- Select optimizations from Pika's random patches.
local hook_Add, hook_Remove = hook.Add, hook.Remove

math.Clamp = function(number, min, max)
	if number < min then
		return min
	end
	
	if number > max then
		return max
	end
	
	return number
end

do
	local index, length = 1, 0
	local random = math.random
	
	table.Shuffle = function(tbl)
		length = #tbl
		for i = length, 1, -1 do
			index = random(1, length)
			tbl[i], tbl[index] = tbl[index], tbl[i]
		end
		return tbl
	end
	
	do
		local keys = setmetatable({ }, {
			__mode = "v"
		})
		table.Random = function(tbl, issequential)
			if issequential then
				length = #tbl
				if length == 0 then
					return nil, nil
				end
				if length == 1 then
					index = 1
				else
					index = random(1, length)
				end
			else
				length = 0
				for key in pairs(tbl) do
					length = length + 1
					keys[length] = key
				end
				if length == 0 then
					return nil, nil
				end
				if length == 1 then
					index = keys[1]
				else
					index = keys[random(1, length)]
				end
			end
			return tbl[index], index
		end
	end
end

local ENTITY, PLAYER = nil, nil

do
	local findMetaTable = CFindMetaTable
	if not findMetaTable then
		findMetaTable = FindMetaTable
		CFindMetaTable = findMetaTable
	end
	local registry = _R
	if not registry then
		registry = setmetatable({ }, {
			["__index"] = function(tbl, key)
				local value = findMetaTable(key)
				if value == nil then
					return
				end
				tbl[key] = value
				return value
			end
		})
		_R = registry
	end
	FindMetaTable = function(name)
		return registry[name]
	end
	debug.getregistry = function()
		return registry
	end
	ENTITY, PLAYER = registry.Entity, registry.Player
	local getCTable = ENTITY.GetCTable
	if not getCTable then
		getCTable = ENTITY.GetTable
		ENTITY.GetCTable = getCTable
	end
	local cache = { }
	hook_Add("EntityRemove", "Entity.GetTable", function(self)
		return Simple(0, function()
			cache[self] = nil
		end)
	end)
	local getTable
	getTable = function(self)
		local result = cache[self]
		if not result then
			result = getCTable(self) or { }
			cache[self] = result
		end
		return result
	end
	ENTITY.GetTable = getTable
	ENTITY.__index = function(self, key)
		local value = ENTITY[key]
		if value == nil then
			value = getTable(self)[key]
		end
		return value
	end
	PLAYER.__index = function(self, key)
		local value = PLAYER[key]
		if value == nil then
			value = ENTITY[key]
			if value == nil then
				return getTable(self)[key]
			end
		end
		return value
	end
	do
		local GetOwner = ENTITY.GetOwner
		local Weapon = registry.Weapon
		Weapon.__index = function(self, key)
			if key == "Owner" then
				return GetOwner(self)
			end
			local value = Weapon[key]
			if value == nil then
				value = ENTITY[key]
				if value == nil then
					return getTable(self)[key]
				end
			end
			return value
		end
	end
	do
		local Vehicle = registry.Vehicle
		Vehicle.__index = function(self, key)
			local value = Vehicle[key]
			if value == nil then
				value = ENTITY[key]
				if value == nil then
					return getTable(self)[key]
				end
			end
			return value
		end
	end
	do
		local NPC = registry.NPC
		NPC.__index = function(self, key)
			local value = NPC[key]
			if value == nil then
				value = ENTITY[key]
				if value == nil then
					return getTable(self)[key]
				end
			end
			return value
		end
	end
end

if CLIENT then
	do
		local getLocalPlayer = util.GetLocalPlayer
		if not getLocalPlayer then
			getLocalPlayer = LocalPlayer
			util.GetLocalPlayer = getLocalPlayer
		end
		local entity = NULL
		LocalPlayer = function()
			entity = getLocalPlayer()
			if entity and IsValid(entity) then
				LocalPlayer = function()
					return entity
				end
			end
			return entity
		end
	end
	do
		local Start = cam.Start
		do
			local view = {
				type = "2D"
			}
			cam.Start2D = function()
				return Start(view)
			end
		end
		do
			local view = {
				type = "3D"
			}
			cam.Start3D = function(origin, angles, fov, x, y, w, h, znear, zfar)
				view.origin, view.angles, view.fov = origin, angles, fov
				if x ~= nil and y ~= nil and w ~= nil and h ~= nil then
					view.x, view.y = x, y
					view.w, view.h = w, h
					view.aspect = w / h
				else
					view.x, view.y = nil, nil
					view.w, view.h = nil, nil
					view.aspect = nil
				end
				if znear ~= nil and zfar ~= nil then
					view.znear, view.zfar = znear, zfar
				else
					view.znear, view.zfar = nil, nil
				end
				return Start(view)
			end
		end
	end
	do
		local camStack = 0
		local cStartOrthoView = cam.CStartOrthoView
		if not cStartOrthoView then
			cStartOrthoView = cam.StartOrthoView
			cam.CStartOrthoView = cStartOrthoView
		end
		cam.StartOrthoView = function(a, b, c, d)
			camStack = camStack + 1
			return cStartOrthoView(a, b, c, d)
		end
		local cEndOrthoView = cam.CEndOrthoView
		if not cEndOrthoView then
			cEndOrthoView = cam.EndOrthoView
			cam.CEndOrthoView = cEndOrthoView
		end
		cam.EndOrthoView = function()
			if camStack == 0 then
				return
			end
			camStack = camStack - 1
			if camStack < 0 then
				camStack = 0
			end
			return cEndOrthoView()
		end
	end
end

-- Bot commands.
if SERVER then
	concommand.Add("botfill", function(player, command, arguments)
		if player:IsAdmin() then
			for i = 1, game.MaxPlayers() - _player.GetCount() do
				game.ConsoleCommand("bot\n")
			end;
		else
			Schema:EasyText(GetAdmins(), "lightslategrey", player:Name().." has tried to run the botfill console command!");
		end;
	end);
	
	-- Teleports all bots to the Pope's penthouse on rp_begotten3 for testing on large groups of bots.
	concommand.Add("botteleportall", function(player, command, arguments)
		if player:IsAdmin() then
			local row = 0;
			local column = 0;
			local max_col = 8;
		
			for i, v in ipairs(_player.GetAll()) do
				if v:IsBot() then
					v:SetPos(Vector(-1156 + (48 * column), 14185 - (48 * row), 298));
					v:Freeze(true);
					
					column = column + 1;
					
					if column >= max_col then
						row = row + 1;
						column = 0;
					end
				end
			end
		else
			Schema:EasyText(GetAdmins(), "lightslategrey", player:Name().." has tried to run the botteleportall console command!");
		end;
	end);

	concommand.Add("botfullequip", function(player, command, arguments)
		if player:IsAdmin() then
			for k, v in pairs (_player.GetAll()) do
				local pos = v:GetPos();
				
				if (v:IsBot()) then
					Clockwork.player:SetRagdollState(v, nil)
					v:Spawn();
					
					local ass = pos
					v:SetPos(ass)
					
					local items_to_give = {
						"begotten_1h_glazicus",
						"shield11",
						"begotten_javelin_pilum",
						"gatekeeper_plate",
						"gatekeeper_helmet",
						"backpack_survivalist"
					};
					
					for i = 1, #items_to_give do
						local instance = Clockwork.item:CreateInstance(items_to_give[i]);
						
						v:GiveItem(instance, true);
						Clockwork.item:Use(v, instance, true);
					end
					
					v:SelectWeapon("begotten_1h_glazicus");
					v:SetWeaponRaised(true);
					
			--		v:SelectWeapon("begotten_polearm_glazicbanner");
				end;
			end;
		else
			Schema:EasyText(GetAdmins(), "lightslategrey", player:Name().." has tried to run the botfullequip console command!");
		end;
	end);

	concommand.Add("botdistortedring", function(player, command, arguments)
		if player:IsAdmin() then
			for k, v in pairs (_player.GetAll()) do
				if (v:IsBot()) then
					local pos = v:GetPos();
					
					Clockwork.player:SetRagdollState(v, nil)
					v:Spawn();
					v:Freeze(true);
					v:SetPos(pos + Vector(0, 0, 16));
					
					local hasItem = Clockwork.inventory:HasItemByID(v:GetInventory(), "ring_distorted");
					
					if !hasItem then
						local instance = Clockwork.item:CreateInstance("ring_distorted");
						
						v:GiveItem(instance, true);
						Clockwork.item:Use(v, instance, true);
					end
				end;
			end;
		else
			Schema:EasyText(GetAdmins(), "lightslategrey", player:Name().." has tried to run the botdistortedring console command!");
		end;
	end);
end
end
end)