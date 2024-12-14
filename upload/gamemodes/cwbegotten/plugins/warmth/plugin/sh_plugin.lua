PLUGIN:SetGlobalAlias("cwWarmth");

cwWarmth.enabledMaps = {
    ["rp_district21"] = true,
}

cwWarmth.systemEnabled = cwWarmth.enabledMaps[game.GetMap()];

if cwWarmth.systemEnabled then
	Clockwork.kernel:IncludePrefixed("cl_hooks.lua");
	Clockwork.kernel:IncludePrefixed("sv_hooks.lua");

	local COMMAND = Clockwork.command:New("CharSetTemperature");
		COMMAND.tip = "Set a player's temperature level. (0 = Freezing, 100 = Normal)";
		COMMAND.text = "<string Name> <number Amount>";
		COMMAND.access = "o";
		COMMAND.arguments = 2;
		COMMAND.alias = {"SetTemperature", "PlySetTemperature", "SetWarmth", "CharSetWarmth", "PlySetWarmth"};

		-- Called when the command has been run.
		function COMMAND:OnRun(player, arguments)
			local target = Clockwork.player:FindByID( arguments[1] )
			local amount = arguments[2];
			
			if (!amount) then
				amount = 100;
			end;
			
			amount = math.Clamp(amount, 0, 100);
			
			if (target) then
				target:SetLocalVar("warmth", amount);
				target:SetCharacterData("warmth", amount);
				
				if (player != target) then
					Schema:EasyText(Schema:GetAdmins(), "cornflowerblue", "["..self.name.."] "..player:Name().." has set "..target:Name().."'s temperature to "..amount..".");
				else
					Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You have set your own temperature to "..amount..".");
				end;
			else
				Schema:EasyText(player, "grey", "["..self.name.."] "..arguments[1].." is not a valid player!");
			end;
		end;
	COMMAND:Register();

	function cwWarmth:ClockworkInitialized()
		if cwMedicalSystem then
			local INJURY = {};
				INJURY.uniqueID = "frostbite";
				INJURY.name = "Frostbite";
				INJURY.description = "This limb has frostbite!";
				INJURY.symptom = " appears to be ridden with frosbite.";
				INJURY.OnReceive = function(player)
					--printp(player:Name().." has frostbite!"); 
				end;
				INJURY.OnTake = function(player)
					--printp(player:Name().." cured their frostbite!");
				end;
			cwMedicalSystem:RegisterInjury(INJURY.uniqueID, INJURY);
		end
	end
end
