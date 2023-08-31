--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

PLUGIN:SetGlobalAlias("cwScriptures");

Clockwork.kernel:IncludePrefixed("sh_bookdata.lua");

local ITEM = Clockwork.item:New(nil, true)
	ITEM.name = "Book Base"
	ITEM.weight = 0
	ITEM.category = "Scripture"
	ITEM.useText = "Read"
	ITEM.uniqueID = "book_base"
	ITEM.notStackable = true
	ITEM.customFunctions = {"Copy"};

	-- Called when the item should be setup.
	function ITEM:OnSetup()
		if not self.setup then
			if (self.bookInformation) then
				for i = 1, #self.bookInformation do
					local background = self.background or "https://i.imgur.com/ofkBgu0.png";
					local text = string.gsub(string.gsub(self.bookInformation[i], "\n", "<br>"), "\t", string.rep("&nbsp", 4));
					
					self.bookInformation[i] = "<html><style>#example {padding-top:96px; padding-left:80px; padding-right:96px; padding-bottom:48px; overflow: hidden; background-image: url('"..background.."'); background-repeat: no-repeat; background-size: 100% 740px;}</style><font face='Papyrus' size='3'><div id='example'>"..text.."</div></font></html>"
				end
			end
			
			self.setup = true;
		end
	end
	
	-- Called when the player uses item.
	function ITEM:OnUse(player, itemEntity)
		if !cwBeliefs or (cwBeliefs and player:HasBelief("literacy") and (self.bookType == "Glazic" or player:HasBelief("anthropologist"))) then
			local booksRead = player:GetCharacterData("BooksRead", {});
			
			if !table.HasValue(booksRead, self.uniqueID) then
				if cwBeliefs and player:HasBelief("scribe") then
					player:HandleXP(cwBeliefs.xpValues["read"]);
				end
				
				table.insert(booksRead, self.uniqueID);
				
				player:SetCharacterData("BooksRead", booksRead);
			end
			
			player:EmitSound("begotten/items/note_turn.wav")
			Clockwork.datastream:Start(player, "OpenBook", self("uniqueID"))
		else
			Schema:EasyText(player, "chocolate", "You are not literate!");
		end
		
		return false
	end
	
	function ITEM:OnCustomFunction(player, name)
		if (name == "Copy") then
			--if player:GetCharacterData("LastZone") == "tower" then
				local booksCopied = player:GetCharacterData("BooksCopied", {});
				
				--[[if table.HasValue(booksCopied, self.uniqueID) then
					Schema:EasyText(player, "peru", "You have already copied this scripture!");
					return false;
				else]]if player:HasItemByID("quill") and player:HasItemByID("paper") then
					if !cwBeliefs or (cwBeliefs and player:HasBelief("scribe")) then
						local itemTable = item.CreateInstance(self.uniqueID);
						local bSuccess, fault = player:GiveItem(itemTable, true);
						
						if bSuccess then
							if cwBeliefs then
								if not table.HasValue(booksCopied, self.uniqueID) then
									player:HandleXP(cwBeliefs.xpValues["copy"]);
								end
							end
							
							table.insert(booksCopied, self.uniqueID);
							
							player:SetCharacterData("BooksCopied", booksCopied);
							Clockwork.datastream:Start(player, "UpdateBooksCopied", booksCopied);
							
							player:TakeItemByID("paper");
							
							local itemList = Clockwork.inventory:GetItemsAsList(player:GetInventory());
							local quillItemTable;
							
							for k, v in pairs (itemList) do
								if v.uniqueID == "quill" then
									quillItemTable = v;
									break;
								end
							end
							
							if quillItemTable then
								local quillCondition = quillItemTable:GetCondition();
								local condition = quillCondition - 34;
								
								if condition <= 0 then
									player:TakeItem(quillItemTable, true);
								else
									quillItemTable:SetCondition(condition, true);
								end
							end
						else
							--Schema:EasyText(player, "firebrick", "Something went horribly wrong! Please contact an admin using /adminhelp.");
							return false;
						end
					else
						Schema:EasyText(player, "chocolate", "You do not have the required belief to do this!");
						return false;
					end
				else
					Schema:EasyText(player, "chocolate", "You need paper and a quill to copy scriptures!");
					return false;
				end
			--[[else
				Schema:EasyText(player, "peru", "You should get somewhere safer before attempting to copy this scripture!");
				return false;
			end;]]--
		end;
	end;
	
	-- Called when a player drops the item.
	function ITEM:OnDrop(player, itemEntity) end
	
	-- A function to get the item's weight based on how many pages the book contains.
	function ITEM:GetItemWeight()
		if (!self.bookInformation or #self.bookInformation <= 0) then
			return 0.25;
		else
			return 0.05 + (#self.bookInformation * 0.05);
		end;
	end;
	
	ITEM:AddQueryProxy("weight", ITEM.GetItemWeight);
ITEM:Register()

local ITEM = Clockwork.item:New();
	ITEM.name = "Quill";
	ITEM.uniqueID = "quill";
	ITEM.cost = 50;
	ITEM.model = "models/begotten/misc/quill.mdl";
	ITEM.weight = 0.1;
	ITEM.category = "Tools";
	ITEM.business = true;
	ITEM.stackable = true;
	ITEM.description = "A small quill that can be used for writing by those who are sufficiently learned.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/quill.png"

	ITEM.itemSpawnerInfo = {category = "City Junk", rarity = 200, onGround = false};

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();

-- Replace these with your own, the old books have been removed due to their obscene contents.
local ITEM = Clockwork.item:New("book_base")
	ITEM.name = "Test Book"
	ITEM.model = "models/props_monastery/book_small.mdl"
	ITEM.weight = 0.6;
	ITEM.uniqueID = "book_test"
	ITEM.description = "A leatherbound book."
	ITEM.background = "https://i.imgur.com/ofkBgu0.png"
	ITEM.bookInformation = {Book_Test_Page1}
	ITEM.bookType = "Glazic"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/book_small.png";
	
	ITEM.itemSpawnerInfo = {category = "City Junk", rarity = 600, onGround = false};
ITEM:Register()

Clockwork.item:Initialize(); -- This fixes shit for autorefresh I guess?

if (SERVER) then
	function cwScriptures:PlayerCharacterLoaded(player)
		local booksCopied = player:GetCharacterData("BooksCopied", {});
		
		Clockwork.datastream:Start(player, "UpdateBooksCopied", booksCopied)
	end
end

if (CLIENT) then
	local PANEL = {}

	-- Called when the panel is initialized.
	function PANEL:Init()
		local unixTime = SysTime()
		local scrW = ScrW()
		local scrH = ScrH()
		
		self:SetTitle("")
		self:SetBackgroundBlur(true)
		self:SetDeleteOnClose(false)
		self:ShowCloseButton(false)

		self:SetSize(749, 870)
		self:SetPos(960 - (self:GetWide() / 2), 540 - (self:GetTall() / 2) )
		
		local loadingText = vgui.Create("DLabel", self)
		loadingText:SetText("Loading...")
		loadingText:SetFont("Subtitle_Yell")
		loadingText:SetTextColor(Color(255, 0, 0, 150))
		loadingText:SetPos((self:GetWide() / 2) - (GetFontWidth("Subtitle_Yell", "Loading...") / 2), (self:GetTall() / 2) - (GetFontHeight("Subtitle_Yell", "Loading...") / 2))
		loadingText:SizeToContents()
		
		-- Called when the button is clicked.
		function self.btnClose.DoClick(button)
			self:Close() self:Remove()
			
			gui.EnableScreenClicker(false)
		end
		
		Clockwork.Client.currentPage = 1
		Clockwork.kernel:RegisterBackgroundBlur(self, unixTime)
	end

	-- Called each frame.
	function PANEL:Think()
		if (self.alwaysDisabled) then
			return
		end
		
		if (IsValid(self.leftButton)) then
			if (Clockwork.Client.currentPage <= 1) then
				self.leftButton:SetEnabled(false)
			else
				self.leftButton:SetEnabled(true)
			end
		end
		
		if (IsValid(self.rightButton)) then
			if (Clockwork.Client.currentPage >= #pages) then
				self.rightButton:SetEnabled(false)
			else
				self.rightButton:SetEnabled(true)
			end
		end
	end

	-- Called each frame.
	function PANEL:Paint()
		
	end

	-- A function to populate the panel.
	function PANEL:Populate(itemTable)
		Clockwork.Client.CurrentitemTable = itemTable
		pages = itemTable.bookInformation
		
		self.leftButton = vgui.Create("DButton", self)
		self.leftButton:SetSize((self:GetWide() - 8) / 2, 48 + 4 - 8)
		self.leftButton:SetPos(4, 870 - 48 - 4 - 16 + 4)
		self.leftButton:SetText("<")
		
		-- Called when the button is clicked.
		function self.leftButton:DoClick()
			PANEL:DoPage(true)
		end
		
		self.rightButton = vgui.Create("DButton", self)
		self.rightButton:SetSize(((self:GetWide() - 8) / 2), 48 + 4 - 8)
		self.rightButton:SetPos(self.leftButton:GetPos() + self.leftButton:GetWide() + 4, 870 - 48 - 4 - 16 + 4)
		self.rightButton:SetText(">")
		
		-- Called when the button is clicked.
		function self.rightButton:DoClick()
			PANEL:DoPage(false)
		end

		local x, y = self.rightButton:GetPos()
		
		self.closebutton = vgui.Create("DButton", self)
		self.closebutton:SetSize(self:GetWide() - 4, 16)
		self.closebutton:SetPos(4, 870 - 48 - 4 + 36)
		self.closebutton:SetText("  Close Scripture")
		
		if (#pages <= 1) then
			self.alwaysDisabled = true
			self.leftButton:SetVisible(false)
			self.rightButton:SetVisible(false)
			self.closebutton:SetPos(4, 804)
		end
		
		-- Called when the button is clicked.
		function self.closebutton:DoClick()
			Clockwork.Client.BookPanel:Close() Clockwork.Client.BookPanel:Remove()
			gui.EnableScreenClicker(false)
			surface.PlaySound("begotten/items/note_turn.wav")
		end

		htmlPanel = vgui.Create("DHTML", self)
		htmlPanel:SetHTML(pages[Clockwork.Client.currentPage])
		htmlPanel:SetWrap(true)
		gui.EnableScreenClicker(true)
	end

	-- A function to change the page.
	function PANEL:DoPage(bLeft)
		surface.PlaySound("begotten/items/note_turn.wav")
		
		if (!Clockwork.Client.currentPage) then
			Clockwork.Client.currentPage = 1
		end
		
		if (bLeft) then
			Clockwork.Client.currentPage = math.Clamp(Clockwork.Client.currentPage - 1, 1, 100)
			htmlPanel:SetHTML(pages[Clockwork.Client.currentPage])
		else
			Clockwork.Client.currentPage = math.Clamp(Clockwork.Client.currentPage + 1, 1, #pages)
			htmlPanel:SetHTML(pages[Clockwork.Client.currentPage])
		end
	end

	-- Called when the layout should be performed.
	function PANEL:PerformLayout()
		--htmlPanel:StretchToParent(4, 24, 4, 52)
		htmlPanel:SetSize(770, 800);
		DFrame.PerformLayout(self)
	end

	-- Called when the panel is closed.
	function PANEL:OnClose()
		Clockwork.kernel:RemoveBackgroundBlur(self)
	end

	vgui.Register("cwViewBook", PANEL, "DFrame")
	
	if (IsValid(Clockwork.Client.BookPanel)) then
		Clockwork.Client.BookPanel:Close()
		Clockwork.Client.BookPanel:Remove()
	end
	
	Clockwork.datastream:Hook("OpenBook", function(data)
		local itemTable = Clockwork.item:FindByID(data)

		if (itemTable and itemTable.bookInformation) then
			if (IsValid(Clockwork.Client.BookPanel)) then
				Clockwork.Client.BookPanel:Close()
				Clockwork.Client.BookPanel:Remove()
			end
			
			Clockwork.Client.BookPanel = vgui.Create("cwViewBook")
			Clockwork.Client.BookPanel:Populate(itemTable)
			Clockwork.Client.BookPanel:MakePopup()
			
			if (Clockwork.menu:GetOpen()) then
				Clockwork.menu:SetOpen(false)
			end
		end
	end)
	
	Clockwork.datastream:Hook("UpdateBooksCopied", function(data)
		if data then
			Clockwork.Client.booksCopied = data;
		end
	end)
end