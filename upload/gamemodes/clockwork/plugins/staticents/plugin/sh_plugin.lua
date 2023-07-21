--[[
	Begotten III: Jesus Wept
--]]

--[[
	You don't have to do this, but I think it's nicer.
	Alternatively, you can simply use the PLUGIN variable.
--]]
PLUGIN:SetGlobalAlias("cwStaticEnts");

--[[ You don't have to do this either, but I prefer to seperate the functions. --]]
Clockwork.kernel:IncludePrefixed("cl_plugin.lua");
Clockwork.kernel:IncludePrefixed("sv_plugin.lua");
Clockwork.kernel:IncludePrefixed("sv_hooks.lua");

-- A function to check if an entity can be static.
function cwStaticEnts:CanEntityStatic(entity)
	if (entity:IsValid()) then
		local class = entity:GetClass();
		local classCheck = {
			"prop_vehicle_",
			"cw_",
			"func_",
			"prop_dynamic"
		};

		if (class == "player" or entity:MapCreationID() != -1) then
			return false;
		end;

		for k, v in ipairs(classCheck) do
			if (string.find(class, v)) then
				return false;
			end;
		end;
		
		return class;
	end;
end;

local COMMAND = Clockwork.command:New("StaticAdd");
COMMAND.tip = "Add a static entity at your target position.";
COMMAND.access = "a";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = player:GetEyeTraceNoCursor().Entity;
	
	if (IsValid(target)) then
		local class = Clockwork.plugin:Call("CanEntityStatic", target);

		if (class != false) then
			for k, v in pairs(cwStaticEnts.staticEnts) do
				if (target == v) then
					Schema:EasyText(player, "grey", "["..self.name.."] This entity is already static!");

					return;
				end;
			end;
				
			table.insert(cwStaticEnts.staticEnts, target);
			cwStaticEnts:SaveStaticEnts();

			Schema:EasyText(player, "cornflowerblue", "["..self.name.." You have added a static entity.");		
		else
			Schema:EasyText(player, "grey", "["..self.name.."] You cannot static this entity!");
		end;
	else
		Schema:EasyText(player, "grey", "["..self.name.."] You must look at a valid entity!");
	end;
end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("StaticRemove");
COMMAND.tip = "Remove static entities at your target position.";
COMMAND.access = "a";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = player:GetEyeTraceNoCursor().Entity;
	
	if (IsValid(target)) then
		for k, v in pairs(cwStaticEnts.staticEnts) do
			if (target == v) then
				table.remove(cwStaticEnts.staticEnts, k);
				cwStaticEnts:SaveStaticEnts();
					
				Schema:EasyText(player, "cornflowerblue", "["..self.name.." You have removed a static entity.");

				return;
			end;
		end;

		Schema:EasyText(player, "grey", "["..self.name.."] This entity is not static.");
	else
		Schema:EasyText(player, "grey", "["..self.name.."] You must look at a valid entity!");
	end;
end;

COMMAND:Register();