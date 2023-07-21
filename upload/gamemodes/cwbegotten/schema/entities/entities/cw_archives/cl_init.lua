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
	
	y = Clockwork.kernel:DrawInfo("The Archives", x, y, colorTargetID, alpha)
	y = Clockwork.kernel:DrawInfo("A gloriously tall library shelf full of knowledge.", x, y, colorWhite, alpha);
end;

local function CreateMenu(state)
	if (IsValid(menu)) then
		menu:Remove();
	end;
	
	local scrW = ScrW();
	local scrH = ScrH();
	local menu = DermaMenu();
		
	menu:SetMinimumWidth(150);

	local subMenu = menu:AddSubMenu("Add to Archives...");
	local itemList = Clockwork.inventory:GetItemsAsList(Clockwork.inventory:GetClient());
	
	for k, v in pairs (itemList) do
		if v.category == "Scripture" then
			subMenu:AddOption(v.name, function()
				Clockwork.kernel:RunCommand("ArchivesAdd", v.uniqueID);
			end);
		end
	end
	
	if Schema.archivesBookList and !table.IsEmpty(Schema.archivesBookList) then
		if Clockwork.Client:GetFaction() == "Holy Hierarchy" then
			subMenu = menu:AddSubMenu("Take from Archives...");
			
			for k, v in pairs (Schema.archivesBookList) do
				if v and v > 0 then
					local itemTable = item.FindByID(k);
					
					if itemTable and itemTable.category == "Scripture" then
						subMenu:AddOption("("..tostring(v)..") "..itemTable.name, function()
							Clockwork.kernel:RunCommand("ArchivesTake", k);
						end);
					end
				end
			end
		end
	end
	
	menu:Open();
	menu:SetPos(scrW / 2 - (menu:GetWide() / 2), scrH / 2 - (menu:GetTall() / 2));
end

Clockwork.datastream:Hook("OpenArchivesMenu", function(state)
	CreateMenu(state);
end);