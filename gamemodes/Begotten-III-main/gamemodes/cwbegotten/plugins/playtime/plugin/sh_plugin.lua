local PLUGIN = PLUGIN;

Clockwork.kernel:IncludePrefixed("cl_hooks.lua");
Clockwork.kernel:IncludePrefixed("sv_hooks.lua");

-- Called when the Clockwork shared variables are added.
--[[function PLUGIN:ClockworkAddSharedVars(globalVars, playerVars)
	playerVars:Number("characterPlayTime");
end;]]--

function FormattedPlayTime( seconds,format)
	if ( not seconds ) then seconds = 0 end
	local hours = math.floor( seconds / 3600 )
	local minutes = math.floor( ( seconds / 60 ) % 60 )
	local millisecs = ( seconds - math.floor( seconds ) ) * 100
	seconds = math.floor( seconds % 60 )

	if ( format ) then
		return string.format( format, hours, minutes, seconds )
	else
		return { h = hours, m = minutes, s = seconds, ms = millisecs }
	end
end