--[[
	cwdamation created & developed by cash wednesday
--]]

local COMMAND = Clockwork.command:New();
COMMAND.tip = "Clear an entity's gear.";
COMMAND.text = "You must look at the entity you wish to clear.";
COMMAND.access = "o";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local traceEntity = player:GetEyeTraceNoCursor().Entity;
	
	if (!traceEntity:IsPlayer()) then
		if (traceEntity.gear) then
			cwGear:RemoveAllGear(traceEntity);
			
			Clockwork.player:Notify(player, "You have cleared this "..traceEntity:GetClass().."'s gear.");
		else
			Clockwork.player:Notify(player, "This entity does not have any gear!");
		end;
	else
		Clockwork.player:Notify(player, "Use /ClearPlayerGear to clear a player's gear!");
	end;
end;

Clockwork.command:Register(COMMAND, "ClearEntityGear");