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
	
	y = Clockwork.kernel:DrawInfo("Sacrificial Altar", x, y, colorTargetID, alpha)
end;

local function CreateMenu(state)
	if (IsValid(menu)) then
		menu:Remove();
	end;
	
	local scrW = ScrW();
	local scrH = ScrH();
	local menu = DermaMenu();
		
	menu:SetMinimumWidth(150);

	local subMenu = menu:AddSubMenu("Sacrifice");
	
	subMenu:AddOption("Disembowel (Solo)", function() Clockwork.Client:ConCommand("cw_AltarDisembowel") end);
	subMenu:AddOption("Disembowel (Shared)", function() Clockwork.Client:ConCommand("cw_AltarDisembowelShared") end);
	subMenu:AddOption("Dismember (Solo)", function() Clockwork.Client:ConCommand("cw_AltarDismember") end);
	subMenu:AddOption("Dismember (Shared)", function() Clockwork.Client:ConCommand("cw_AltarDismemberShared") end);
	subMenu:AddOption("Flay (Solo)", function() Clockwork.Client:ConCommand("cw_AltarFlay") end);
	subMenu:AddOption("Flay (Shared)", function() Clockwork.Client:ConCommand("cw_AltarFlayShared") end);
	
	menu:Open();
	menu:SetPos(scrW / 2 - (menu:GetWide() / 2), scrH / 2 - (menu:GetTall() / 2));
end

netstream.Hook("OpenAltarMenu", function(state)
	CreateMenu(state);
end);

