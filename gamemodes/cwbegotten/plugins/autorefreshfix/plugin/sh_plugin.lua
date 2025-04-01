PLUGIN:SetGlobalAlias("cwAutorefreshFix");

-- Attempt to fix autorefresh
function cwAutorefreshFix:ClockworkSchemaLoaded()
	Clockwork.item:Initialize();

end