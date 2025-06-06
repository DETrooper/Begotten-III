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
	
	y = Clockwork.kernel:DrawInfo("Bounty Board", x, y, colorTargetID, alpha)
	y = Clockwork.kernel:DrawInfo("A board with bounties for enemies of the Glaze pinned to it.", x, y, colorWhite, alpha);
end;

local function CreateMenu(state)
	if (IsValid(menu)) then
		menu:Remove();
	end;
	
	local scrW = ScrW();
	local scrH = ScrH();
	local menu = DermaMenu();
		
	menu:SetMinimumWidth(150);
	
	if state ~= "Gore" then
		menu:AddOption("View Bounties", function()
			netstream.Start("QueryBountyBoard", state);
		end);
	end

	if state == "Hierarchy" then
		menu:AddOption("Add Bounty", function()
			Derma_StringRequest("Bounty Board", "Who do you want to add to the bounty board?", nil, function(target)
				Derma_StringRequest(target, "How much coin will this bounty be worth?", nil, function(price)
					Derma_StringRequest(target, "What should the reason for this bounty be?", nil, function(reason)
						Clockwork.kernel:RunCommand("AddBounty", target, price, reason);
					end);
				end);
			end);
		end);
		
		--[[local subMenu = menu:AddSubMenu("Remove Bounty");
		local bountyPlayers = {};
			
		for _, v in _player.Iterator() do
			if (v:HasInitialized() and v:IsWanted()) then
				bountyPlayers[#bountyPlayers + 1] = {
					bounty = v:GetBounty(),
					player = v
				};
			end;
		end;
			
		table.sort(bountyPlayers, function(a, b)
			return a.bounty > b.bounty;
		end);
		
		for i = 1, #bountyPlayers do
			local bounty = bountyPlayers[i];
			
			subMenu:AddOption("("..bounty.bounty..") "..bounty.player:Name(), function()
				if IsValid(bounty.player) then
					Clockwork.kernel:RunCommand("RemoveBounty", bounty.player:Name());
				end
			end);
		end]]--
	elseif Clockwork.Client:IsAdmin() then
		menu:AddOption("(ADMIN) Add Bounty", function()
			Derma_StringRequest("Bounty Board", "Who do you want to add to the bounty board?", nil, function(target)
				Derma_StringRequest(target, "How much coin will this bounty be worth?", nil, function(price)
					Derma_StringRequest(target, "What should the reason for this bounty be?", nil, function(reason)
						Clockwork.kernel:RunCommand("AddBounty", target, price, reason);
					end);
				end);
			end);
		end);
	
		--[[local subMenu = menu:AddSubMenu("(ADMIN) Remove Bounty");
		local bountyPlayers = {};
			
		for _, v in _player.Iterator() do
			if (v:HasInitialized() and v:IsWanted()) then
				bountyPlayers[#bountyPlayers + 1] = {
					bounty = v:GetBounty(),
					player = v
				};
			end;
		end;
			
		table.sort(bountyPlayers, function(a, b)
			return a.bounty > b.bounty;
		end);
		
		for i = 1, #bountyPlayers do
			local bounty = bountyPlayers[i];
			
			subMenu:AddOption("("..bounty.bounty..") "..bounty.player:Name(), function()
				if IsValid(bounty.player) then
					Clockwork.kernel:RunCommand("RemoveBounty", bounty.player:Name());
				end
			end);
		end]]--
	end
	
	menu:Open();
	menu:SetPos(scrW / 2 - (menu:GetWide() / 2), scrH / 2 - (menu:GetTall() / 2));
end

netstream.Hook("OpenBountyBoardMenu", function(state)
	CreateMenu(state);
end);

netstream.Hook("OpenBountyList", function(data, state)
	if !Clockwork.Client.cwBountyMenu or !IsValid(Clockwork.Client.cwBountyMenu) then
		Clockwork.Client.cwBountyMenu = vgui.Create("cwBountyMenu");
	end
	
	Clockwork.Client.cwBountyMenu:Rebuild(data or {}, state);
	Clockwork.Client.cwBountyMenu:MakePopup();
end);