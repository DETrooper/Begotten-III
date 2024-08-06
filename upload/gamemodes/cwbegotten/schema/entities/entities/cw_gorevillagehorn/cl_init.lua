include("shared.lua");

-- Called when the target ID HUD should be painted.
function ENT:HUDPaintTargetID(x, y, alpha)
	local colorTargetID = Clockwork.option:GetColor("target_id")
	local colorWhite = Clockwork.option:GetColor("white")
	
	y = Clockwork.kernel:DrawInfo("Goreic Gathering Horn", x, y, colorTargetID, alpha)
	y = Clockwork.kernel:DrawInfo("A Goreic warhorn handcrafted to produce a sound that will echo throughout the Forest when blown.", x, y, colorWhite, alpha);
end;

local function CreateMenu(state)
	if (IsValid(menu)) then
		menu:Remove();
	end;
	
	local scrW = ScrW();
	local scrH = ScrH();
	local menu = DermaMenu();
		
	menu:SetMinimumWidth(150);
	
	if state == "Gore" then
		menu:AddOption("Summon All Goreic Warriors", function() Clockwork.kernel:RunCommand("GoreicHornSummonAll") end);
        menu:AddOption("Summon Raiding Party", function() Clockwork.kernel:RunCommand("GoreicHornSummonRaid") end);
	end
	
	menu:Open();
	menu:SetPos(scrW / 2 - (menu:GetWide() / 2), scrH / 2 - (menu:GetTall() / 2));
end

Clockwork.datastream:Hook("OpenGoreicHornMenu", function(state)
	CreateMenu(state);
end);