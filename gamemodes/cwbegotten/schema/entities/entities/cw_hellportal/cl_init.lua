--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

include("shared.lua");

-- Called when the target ID HUD should be painted.
function ENT:HUDPaintTargetID(x, y, alpha)
	local colorTargetID = Clockwork.option:GetColor("target_id")
	local colorWhite = Clockwork.option:GetColor("white")
	
	y = Clockwork.kernel:DrawInfo("Hell Portal", x, y, colorTargetID, alpha)
	y = Clockwork.kernel:DrawInfo("The gateway to other worlds.", x, y, colorWhite, alpha);
end;

local function CreateMenu(state)
	if (IsValid(menu)) then
		menu:Remove();
	end;
	
	local scrW = ScrW();
	local scrH = ScrH();
	local menu = DermaMenu();
		
	menu:SetMinimumWidth(150);

	local subMenu = menu:AddSubMenu("Traverse...");
	local subMenu2 = menu:AddSubMenu("Gaze through the veil...");
	
	if game.GetMap() == "rp_district21" then
		subMenu:AddOption("...to the Pillars of Creation", function() Clockwork.Client:ConCommand("cw_HellPortalPillars") end);
		subMenu:AddOption("...to the Abandoned Church.", function() Clockwork.Client:ConCommand("cw_HellPortalAbandonedChurch") end);
		subMenu2:AddOption("...into the Pillars of Creation", function() Clockwork.kernel:RunCommand("HellPortalGaze", "Pillars") end);
		subMenu2:AddOption("...into the Abandoned Church", function() Clockwork.kernel:RunCommand("HellPortalGaze", "Church") end);
	elseif game.GetMap() == "bg_district34" then
		subMenu:AddOption("...to the Pillars of Creation", function() Clockwork.Client:ConCommand("cw_HellPortalPillars") end);
		subMenu:AddOption("...to the City Cave.", function() Clockwork.Client:ConCommand("cw_HellPortalCave") end);
		subMenu2:AddOption("...into the Pillars of Creation", function() Clockwork.kernel:RunCommand("HellPortalGaze", "Pillars") end);
		subMenu2:AddOption("...into the City Cave", function() Clockwork.kernel:RunCommand("HellPortalGaze", "Cave") end);
	else
		subMenu:AddOption("...to the Arch of Perdition", function() Clockwork.Client:ConCommand("cw_HellPortalArch") end);
		subMenu:AddOption("...to the Pillars of Creation", function() Clockwork.Client:ConCommand("cw_HellPortalPillars") end);
		subMenu2:AddOption("...into the Arch of Perdition", function() Clockwork.kernel:RunCommand("HellPortalGaze", "Arch") end);
		subMenu2:AddOption("...into the Pillars of Creation", function() Clockwork.kernel:RunCommand("HellPortalGaze", "Pillars") end);
	end


	menu:Open();
	menu:SetPos(scrW / 2 - (menu:GetWide() / 2), scrH / 2 - (menu:GetTall() / 2));
end

netstream.Hook("OpenHellPortalMenu", function(state)
	CreateMenu(state);
end);