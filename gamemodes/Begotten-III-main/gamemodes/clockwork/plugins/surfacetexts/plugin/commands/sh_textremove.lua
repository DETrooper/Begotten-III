--[[
	Begotten III: Jesus Wept
--]]

local COMMAND = Clockwork.command:New("TextRemove");
COMMAND.tip = "Remove some text from a surface.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "a";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local position = player:GetEyeTraceNoCursor().HitPos;
	local iRemoved = 0;
	
	for k, v in pairs(cwSurfaceTexts.storedList) do
		if (v.position:Distance(position) <= 256) then
			netstream.Start(nil, "SurfaceTextRemove", v.position);
				cwSurfaceTexts.storedList[k] = nil;
			iRemoved = iRemoved + 1;
		end;
	end;
	
	if (iRemoved > 0) then
		if (iRemoved == 1) then
			Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You have removed "..iRemoved.." surface text.");
		else
			Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You have removed "..iRemoved.." surface texts.");
		end;
	else
		Schema:EasyText(player, "cornflowerblue", "["..self.name.."] There were no surface texts near this position.");
	end;
	
	cwSurfaceTexts:SaveSurfaceTexts();
end;

COMMAND:Register();