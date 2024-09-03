PLUGIN:SetGlobalAlias("cwTransmit");

Clockwork.kernel:IncludePrefixed("sv_hooks.lua");

Clockwork.flag:Add("i", "No Prevent Transmit", "Turns off prevent transmit when in observer. This means players with ESP will be able to see you, but will fix issues with PAC and observer.")