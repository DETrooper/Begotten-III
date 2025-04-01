--[[
	BEGOTTEN III: Developed by DETrooper, cash wednesday, gabs & alyousha35
--]]

netstream.Hook("FactionStorageAdd", function(data)
	if (IsValid(cwFactionStorage.panel) and cwFactionStorage.panel:IsVisible()) then
		CloseDermaMenus()

		cwFactionStorage.panel:Close()
		cwFactionStorage.panel:Remove()
	end

	cwFactionStorage.factions = data.factions or {}
	cwFactionStorage.subfactions = data.subfactions or {}
	
	if Schema.Ranks then
		cwFactionStorage.ranks = data.ranks or {}
	end
	
	if Schema.faiths then
		cwFactionStorage.subfaiths = data.subfaiths or {}
	end
	
	cwFactionStorage.activeName = data.name;

	gui.EnableScreenClicker(true)

	local scrW = ScrW()
	local scrH = ScrH()

	cwFactionStorage.panel = vgui.Create("cwFactionStorage")
	cwFactionStorage.panel:SetSize(scrW * 0.5, scrH * 0.75)
	cwFactionStorage.panel:SetPos(
		(scrW / 2) - (cwFactionStorage.panel:GetWide() / 2),
		(scrH / 2) - (cwFactionStorage.panel:GetTall() / 2)
	)
	cwFactionStorage.panel:MakePopup()
end)