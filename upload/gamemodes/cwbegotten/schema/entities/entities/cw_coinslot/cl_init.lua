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
	
	y = Clockwork.kernel:DrawInfo("Coinslot", x, y, colorTargetID, alpha)
	y = Clockwork.kernel:DrawInfo("An ancient machine with a multitude of cranks and gears. It has a prominent coinslot.", x, y, colorWhite, alpha);
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
		menu:AddOption("Collect Ration", function() Clockwork.Client:ConCommand("cw_CoinslotRation") end);
		
		if state == "Gatekeeper" then
			if !Clockwork.Client:GetNetVar("collectedGear") then
				menu:AddOption("Collect Gatekeeper Kit", function() Clockwork.Client:ConCommand("cw_CoinslotGear") end);
			end
		end
		
		menu:AddOption("Donate", function() 
			Derma_StringRequest("Coinslot", "How much coin would you offer to the Coinslot?", nil, function(text)
				Clockwork.kernel:RunCommand("CoinslotDonate", text);
			end)
		end);
		
		if cwShacks.shacks and Clockwork.Client:GetFaction() ~= "Holy Hierarchy" then
			local playerShack = Clockwork.Client:GetNetVar("shack");
			
			if !playerShack then
				local subMenu = menu:AddSubMenu("Purchase Property");
				local marketMenu = subMenu:AddSubMenu("Market Area");
				
				for k, v in SortedPairsByMemberValue(cwShacks.shackData["market"], "name") do
					if not cwShacks.shacks[k].owner then
						marketMenu:AddOption("("..tostring(v.price)..") "..v.name, function() Clockwork.kernel:RunCommand("CoinslotPurchase", k) end);
					else
						marketMenu:AddOption("(SOLD) "..v.name, function() end);
					end
				end
				
				local groundFloorMenu = subMenu:AddSubMenu("Ground Floor");
				
				for k, v in SortedPairsByMemberValue(cwShacks.shackData["floor1"], "name") do
					if not cwShacks.shacks[k].owner then
						groundFloorMenu:AddOption("("..tostring(v.price)..") "..v.name, function() Clockwork.kernel:RunCommand("CoinslotPurchase", k) end);
					else
						groundFloorMenu:AddOption("(SOLD) "..v.name, function() end);
					end
				end
				
				local secondFloorMenu = subMenu:AddSubMenu("Second Floor");
				
				for k, v in SortedPairsByMemberValue(cwShacks.shackData["floor2"], "name") do
					if not cwShacks.shacks[k].owner then
						secondFloorMenu:AddOption("("..tostring(v.price)..") "..v.name, function() Clockwork.kernel:RunCommand("CoinslotPurchase", k) end);
					else
						secondFloorMenu:AddOption("(SOLD) "..v.name, function() end);
					end
				end
				
				local thirdFloorMenu = subMenu:AddSubMenu("Third Floor");
				
				for k, v in SortedPairsByMemberValue(cwShacks.shackData["floor3"], "name") do
					if not cwShacks.shacks[k].owner then
						thirdFloorMenu:AddOption("("..tostring(v.price)..") "..v.name, function() Clockwork.kernel:RunCommand("CoinslotPurchase", k) end);
					else
						thirdFloorMenu:AddOption("(SOLD) "..v.name, function() end);
					end
				end
				
				local fourthFloorMenu = subMenu:AddSubMenu("Fourth Floor");
				
				for k, v in SortedPairsByMemberValue(cwShacks.shackData["floor4"], "name") do
					if not cwShacks.shacks[k].owner then
						fourthFloorMenu:AddOption("("..tostring(v.price)..") "..v.name, function() Clockwork.kernel:RunCommand("CoinslotPurchase", k) end);
					else
						fourthFloorMenu:AddOption("(SOLD) "..v.name, function() end);
					end
				end
			else
				local subMenu = menu:AddSubMenu("Sell Property");
				
				for k, v in pairs(cwShacks.shackData) do
					for k2, v2 in pairs(v) do
						if k2 == playerShack then
							subMenu:AddOption("("..tostring(v2.price / 2)..") "..v2.name, function() Clockwork.kernel:RunCommand("CoinslotSell", k2) end);
							
							local ownerData = cwShacks.shacks[k2];
							
							if ownerData then
								if !ownerData.coowners or (table.Count(ownerData.coowners) < cwShacks.maxCoowners) then
									menu:AddOption("Add Co-Owner", function() Clockwork.kernel:RunCommand("CoinslotAddCoowner") end);
								end

								if ownerData.coowners and table.Count(ownerData.coowners) > 0 then
									local removeMenu = menu:AddSubMenu("Remove Co-Owner");
									
									for k3, v3 in pairs(ownerData.coowners) do
										removeMenu:AddOption(v3, function() Clockwork.kernel:RunCommand("CoinslotRemoveCoowner", k3) end);
									end
								end
							end
						
							break;
						end
					end
				end
			end
		end
	end
	
	if state == "Gatekeeper" then
		local subMenu = menu:AddSubMenu("Salary");
		
		subMenu:AddOption("Check", function() Clockwork.Client:ConCommand("cw_CoinslotSalaryCheck") end);
		subMenu:AddOption("Collect", function() Clockwork.Client:ConCommand("cw_CoinslotSalary") end);
	end
	
	local subMenu = menu:AddSubMenu("Treasury");
	
	subMenu:AddOption("Check Tax Rate", function() Clockwork.Client:ConCommand("cw_CheckTaxRate") end);
	
	if state == "Hierarchy" then
		subMenu:AddOption("Check", function() Clockwork.Client:ConCommand("cw_CoinslotTreasury") end);
		subMenu:AddOption("Set Tax Rate", function() 
			Derma_StringRequest("Coinslot", "What tax rate would you like to set for the "..(game.GetMap() == "rp_district21" and "Hill" or "Tower").."? (1-99)", nil, function(text)
				Clockwork.kernel:RunCommand("CoinslotTax", text);
			end) 
		end);
	elseif Clockwork.Client:IsAdmin() then
		local subMenu = menu:AddSubMenu("(ADMIN) Treasury");
		
		subMenu:AddOption("Check", function() Clockwork.Client:ConCommand("cw_CoinslotTreasury") end);
		subMenu:AddOption("Collect", function() 
			Derma_StringRequest("Coinslot", "How much coin would you collect from the Coinslot?", nil, function(text)
				Clockwork.kernel:RunCommand("CoinslotCollect", text);
			end) 
		end);
		subMenu:AddOption("Modify", function() 
			Derma_StringRequest("Coinslot", "How much coin would you modify the treasury by?", nil, function(text)
				Clockwork.kernel:RunCommand("CoinslotDonate", text, "true");
			end) 
		end);
		subMenu:AddOption("Set Tax Rate", function() 
			Derma_StringRequest("Coinslot", "What tax rate would you like to set for the Tower? (1-99)", nil, function(text)
				Clockwork.kernel:RunCommand("CoinslotTax", text);
			end) 
		end);
	end
	
	menu:Open();
	menu:SetPos(scrW / 2 - (menu:GetWide() / 2), scrH / 2 - (menu:GetTall() / 2));
end

netstream.Hook("OpenCoinslotMenu", function(state)
	CreateMenu(state);
end);