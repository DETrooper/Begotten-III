--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

PLUGIN:SetGlobalAlias("cwContainerHiding");

Clockwork.kernel:IncludePrefixed("cl_hooks.lua");
Clockwork.kernel:IncludePrefixed("cl_plugin.lua");
Clockwork.kernel:IncludePrefixed("sv_hooks.lua");
Clockwork.kernel:IncludePrefixed("sv_plugin.lua");

cwContainerHiding.containerProps = {
	["white"] = {""}, -- No Overlay
	
	["black"] = {
		"models/props_wasteland/controlroom_storagecloset001a.mdl",
		"models/props_wasteland/controlroom_storagecloset001b.mdl",
		"models/props_c17/furnituredresser001a.mdl",
		"models/props_c17/FurnitureFireplace001a.mdl"
	}
};

if (SERVER) then
	cwContainerHiding.startleSounds = {
		["male"] = {
			"vo/npc/male01/ohno.wav",
			"vo/npc/male01/uhoh.wav",
			"vo/npc/male01/startle01.wav",
			"vo/npc/male01/startle02.wav"
		},
		
		["female"] = {
			"vo/npc/female01/ohno.wav",
			"vo/npc/female01/uhoh.wav",
			"vo/npc/female01/startle01.wav",
			"vo/npc/female01/startle02.wav"
		}
	};
end;

-- Called when the Clockwork shared variables are added.
function cwContainerHiding:ClockworkAddSharedVars(globalVars, playerVars)
	playerVars:Bool("hidden");
end;

-- Called when the player's move data should be manipulated.
function cwContainerHiding:Move(player, moveData)
	local hidden = player:GetSharedVar("hidden");
	
	if (hidden) then
		return true;
	end;
	
	local action, percentage = Clockwork.player:GetAction(player, true);
	
	if (action == "hide") then
		return true;
	end;
end;

local COMMAND = Clockwork.command:New("CharForceOut");
	COMMAND.tip = "Force a player out of the container they are in. Use 'true' as a second argument to make them quietly exit.";
	COMMAND.text = "<string Name> <bool Quiet>";
	COMMAND.access = "a";
	COMMAND.arguments = 1;
	COMMAND.optionalArguments = 1;
	COMMAND.alias = {"CharForceExitContainer", "ForceExitContainer", "PlyForceExitContainer", "ForceOut", "PlyForceOut"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1])
		
		if (target) then
			if (IsValid(target.hideEntity) and target:GetCharacterData("hidden") == true) then
				if (SERVER) then
					if (arguments[2]) then
						cwContainerHiding:AttemptHide(target, target.hideEntity, false);
						
						if (target:GetSharedVar("blackOut") == true) then
							target:SetSharedVar("blackOut", false);
						end;
					else
						cwContainerHiding:OpenedStorage(target, target.hideEntity);
					end;
				end;
			else
				Schema:EasyText(player, "firebrick", "["..self.name.."] "..target.." is not in a container!");
			end;
		else
			Schema:EasyText(player, "grey", "["..self.name.."] "..arguments[1].." is not a valid player!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("CharGetOut");
	COMMAND.tip = "Get out of a container you are in.";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.alias = {"GetOut", "PlyGetOut", "CharExitContainer", "ExitContainer", "PlyExitContainer"};
	
	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		if (player:GetCharacterData("hidden") == true and IsValid(player.hideEntity)) then
			cwContainerHiding:OpenedStorage(player, player.hideEntity);
		end;
	end;
COMMAND:Register();