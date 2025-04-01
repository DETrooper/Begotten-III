local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("AdminPlayTime");
COMMAND.tip = "See someone's playtime.";
COMMAND.text = "<string Name>";
COMMAND.arguments = 1
COMMAND.access = "o";

function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1])
	
	if !target then
		Schema:EasyText(target, "grey",target:Name().." is not a valid player!");
		return
	end;
	
	--local playTime = ConvertSecondsToMultiples(target:PlayTime())
	local charPlayTime = ConvertSecondsToMultiples(target:CharPlayTime())
	
	--[[local days = playTime.days
	local minutes = playTime.minutes
	local hours = playTime.hours
	local seconds = playTime.seconds]]--
	
	local chardays = charPlayTime.days
	local charminutes = charPlayTime.minutes
	local charhours = charPlayTime.hours
	local charseconds = charPlayTime.seconds
	
	--Schema:EasyText(player, "cornflowerblue", "["..self.name.."] "..target:Name().." has played on the server for: "..days.." Days - "..hours.." Hours - "..minutes.." Minutes - "..seconds.." Seconds.")
	Schema:EasyText(player, "cornflowerblue", "["..self.name.."] "..target:Name().." has played on this character for: "..chardays.." Days - "..charhours.." Hours - "..charminutes.." Minutes - "..charseconds.." Seconds.")
end;

COMMAND:Register();