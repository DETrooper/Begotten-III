--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

PLUGIN:SetGlobalAlias("cwShacks");

Clockwork.kernel:IncludePrefixed("cl_hooks.lua");
Clockwork.kernel:IncludePrefixed("sv_hooks.lua");

-- Called when the Clockwork shared variables are added.
function cwShacks:ClockworkAddSharedVars(globalVars, playerVars)
	playerVars:Number("shack");
end;

local COMMAND = Clockwork.command:New("CoinslotPurchase");
	COMMAND.tip = "Purchase property from the Coinslot.";
	COMMAND.text = "<string Shack>";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local trace = player:GetEyeTrace();

		if (trace.Entity) then
			local entity = trace.Entity;

			if (entity:GetClass() == "cw_coinslot") then
				if player:GetFaction() == "Holy Hierarchy" then
					Schema:EasyText(player, "peru", "The Holy Hierarchy cannot purchase property!");
					return false;
				end
				
				if cwShacks then
					cwShacks:ShackPurchased(player, arguments[1]);
					return;
				end
			end;
		end;
		
		Schema:EasyText(player, "peru", "You must be looking at the Coinslot to purchase property!");
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("CoinslotSell");
	COMMAND.tip = "Sell your property to the Coinslot.";
	COMMAND.text = "<string Shack>";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.arguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local trace = player:GetEyeTrace();

		if (trace.Entity) then
			local entity = trace.Entity;

			if (entity:GetClass() == "cw_coinslot") then
				if cwShacks then
					cwShacks:ShackSold(player, arguments[1]);
					return;
				end
			end;
		end;
		
		Schema:EasyText(player, "peru", "You must be looking at the Coinslot to sell property!");
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("OpenStash");
	COMMAND.tip = "Open your property's stash. Your stash is not accessible by anyone else except for admins and the inqusition.";
	COMMAND.flags = CMD_DEFAULT;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		cwShacks:ShackStashOpen(player);
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("ClearProperty");
	COMMAND.tip = "Clear a property that you are looking at or inside.";
	COMMAND.access = "s";

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local playerPos = player:GetPos();
		local trace = player:GetEyeTrace();
		local entity = trace.Entity;
		local shack;
	
		for k, v in pairs(cwShacks.shacks) do
			if (playerPos:WithinAABox(v.pos1, v.pos2)) or (IsValid(entity) and v.doorEnt == entity) then
				shack = v;
				break;
			end
		end
		
		if shack then
			for k, v in pairs (_player.GetAll()) do
				if v:GetCharacterKey() == shack.owner then
					v:SetSharedVar("shack", nil);
					
					if v:GetFaction() ~= "Holy Hierarchy" then
						Clockwork.player:TakeSpawnWeapon(v, "cw_keys");
					end
				end
			end
			
			shack.owner = nil;
			shack.stash = nil;
			shack.stashCash = nil;
			
			Clockwork.entity:ClearProperty(shack.doorEnt);
			
			cwShacks:NetworkShackData();
			cwShacks:SaveShackData();
			Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You have cleared this property.");
		else
			Schema:EasyText(player, "grey", "A valid property could not be found!");
		end
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("GetPropertyInfo");
	COMMAND.tip = "Get information about a property when looking at the property's front door or while standing inside of it. Will only work for the Holy Hierarchy.";
	COMMAND.flags = CMD_DEFAULT;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		cwShacks:GetPropertyInfo(player);
	end;
COMMAND:Register();