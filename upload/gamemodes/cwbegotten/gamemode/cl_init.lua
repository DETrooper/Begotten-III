--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

DeriveGamemode("clockwork");

concommand.Add("clearui", function(player)
	if (IsValid(Clockwork.Client.cwBeliefPanel)) then
		Clockwork.Client.cwBeliefPanel:Close()
		Clockwork.Client.cwBeliefPanel:Remove()
		Clockwork.Client.cwBeliefPanel = nil;
	end
	
	if (IsValid(Clockwork.Client.cwCraftingMenu)) then
		Clockwork.Client.cwCraftingMenu:Close()
		Clockwork.Client.cwCraftingMenu:Remove()
		Clockwork.Client.cwCraftingMenu = nil;
	end
	
	if (IsValid(Clockwork.Client.cwRitualsMenu)) then
		Clockwork.Client.cwRitualsMenu:Close()
		Clockwork.Client.cwRitualsMenu:Remove()
		Clockwork.Client.cwRitualsMenu = nil;
	end
	
	Clockwork.menu:SetOpen(false);
end)