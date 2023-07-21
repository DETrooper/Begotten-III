--[[
	cwdamation created & developed by cash wednesday
--]]

local COMMAND = Clockwork.command:New();
COMMAND.tip = "Clear a players gear. If no name is specified, the player you are looking at will have their gear cleared.";
COMMAND.text = "<string Name>";
COMMAND.access = "o";
COMMAND.optionalArguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local traceEntity = player:GetEyeTraceNoCursor().Entity;
	local target = Clockwork.player:FindByID(arguments[1]);
	
	if (target) then
		if (target:HasInitialized()) then
			if (target.gear) then
				cwGear:RemoveAllGear(target);
				
				Clockwork.player:Notify(player, "You have cleared "..target:Name().."'s gear.");
			else
				Clockwork.player:Notify(player, "This player does not have any gear!");
			end;
		end;
	elseif (traceEntity and traceEntity:IsPlayer() and traceEntity:HasInitialized() and !traceEntity.cwObserverMode) then
		if (traceEntity.gear) then
			cwGear:RemoveAllGear(traceEntity);
			
			Clockwork.player:Notify(player, "You have cleared "..traceEntity:Name().."'s gear.");
		else
			Clockwork.player:Notify(player, "This player does not have any gear!");
		end;
	else
		Clockwork.player:Notify(player, "This is not a valid player!");
	end;
end;

Clockwork.command:Register(COMMAND, "ClearPlayerGear");