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
	ITEM.fireplaceFuel = 180;

	-- Called when the item should be setup.
	function ITEM:OnSetup()
		if not self.setup then
			if (self.bookInformation) then
				for i = 1, #self.bookInformation do
					local background = self.background or "https://i.imgur.com/ofkBgu0.png";
					local text = string.gsub(string.gsub(self.bookInformation[i], "\n", "<br>"), "\t", string.rep("&nbsp", 4));
					
					self.bookInformation[i] = "<html><style>#example {padding-top:48px; padding-left:60px; padding-right:60px; padding-bottom:0px; height: 736px; overflow: visible; background-image: url('"..background.."'); background-repeat: no-repeat; background-size: 100% 790px;}</style><font face='Papyrus' size='3'><div id='example'>"..text.."</div></font></html>"
				end
			end
			
			self.setup = true;
		end
	end
	
	-- Called when the player uses item.
	function ITEM:OnUse(player, itemEntity)
		if !cwBeliefs or (cwBeliefs and player:HasBelief("literacy")) then
			if (!cwBeliefs or (self.bookType == "Glazic" or player:HasBelief("anthropologist"))) then
				local booksRead = player:GetCharacterData("BooksRead", {});
				
				if !table.HasValue(booksRead, self.uniqueID) then
					if cwBeliefs and #booksRead < 8 then
						local readXP = cwBeliefs.xpValues["read"] or 50;
						
						if player:GetFaction() ~= "Wanderer" then
							readXP = math.Round(readXP / 2);
						end
						
						player:HandleXP(readXP);
					end
					
					table.insert(booksRead, self.uniqueID);
					
					player:SetCharacterData("BooksRead", booksRead);
					netstream.Start(player, "UpdateBooksRead", booksRead);
				end
				
				player:EmitSound("begotten/items/note_turn.wav")
				netstream.Start(player, "OpenBook", self("uniqueID"))
			else
				Schema:EasyText(player, "chocolate", "You cannot decipher the glyphs in this scripture!");
			end
		else
			Schema:EasyText(player, "chocolate", "You are not literate!");
		end
		
		return false
	end
	
	function ITEM:OnCustomFunction(player, name)
		if (name == "Copy") then
			local booksCopied = player:GetCharacterData("BooksCopied", {});
			
			if player:HasItemByID("quill") and player:HasItemByID("paper") then
				if !cwBeliefs or (cwBeliefs and player:HasBelief("scribe")) then
					if !table.HasValue(player:GetCharacterData("BooksRead", {}), self.uniqueID) then
						Schema:EasyText(player, "chocolate", "You must have read this scripture before attempting to copy it!");
						
						return false;
					end
				
					if (!cwBeliefs or (self.bookType == "Glazic" or player:HasBelief("anthropologist"))) then
						local itemTable = item.CreateInstance(self.uniqueID);
						local bSuccess, fault = player:GiveItem(itemTable, true);
						
						if bSuccess then
							if table.HasValue(booksCopied, self.uniqueID) then
								if cwBeliefs then
									player:HandleXP(math.Round(cwBeliefs.xpValues["copy"] / 2));
								end
							else
								table.insert(booksCopied, self.uniqueID);
								
								player:SetCharacterData("BooksCopied", booksCopied);
								netstream.Start(player, "UpdateBooksCopied", booksCopied);
							
								if cwBeliefs then
									player:HandleXP(cwBeliefs.xpValues["copy"]);
								end
							end
							
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
							Schema:EasyText(player, "chocolate", "You cannot decipher the glyphs in this scripture!");
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
	ITEM.stackable = true;
	ITEM.description = "A small quill that can be used for writing by those who are sufficiently learned.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/quill.png"

	ITEM.itemSpawnerInfo = {category = "City Junk", rarity = 200, onGround = false};

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();

local ITEM = Clockwork.item:New("book_base")
	ITEM.name = "Booby Blagoona: A Bibliography"
	ITEM.model = "models/props_monastery/book_small.mdl"
	ITEM.weight = 0.6;
	ITEM.uniqueID = "book_bbab"
	ITEM.description = "A leatherbound book titled after the controversial Glazic figure, Booby Blagoona."
	ITEM.background = "https://i.imgur.com/ofkBgu0.png"
	ITEM.bookInformation = {Book_Booby_Page1, Book_Booby_Page2, Book_Booby_Page3, Book_Booby_Page4}
	ITEM.bookType = "Glazic"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/book_small.png";

	ITEM.itemSpawnerInfo = {category = "City Junk", rarity = 1000, onGround = false};

ITEM:Register()

local ITEM = Clockwork.item:New("book_base")
	ITEM.name = "Boxer Harvus Krammy: A Bibliography"
	ITEM.model = "models/props_monastery/book_small.mdl"
	ITEM.weight = 0.6;
	ITEM.uniqueID = "book_bhkab"
	ITEM.description = "A leatherbound book titled after an esteemed Glazic philosopher."
	ITEM.background = "https://i.imgur.com/ofkBgu0.png"
	ITEM.bookInformation = {Book_Boxer_Page1, Book_Boxer_Page2, Book_Boxer_Page3, Book_Boxer_Page4, Book_Boxer_Page5}
	ITEM.bookType = "Glazic"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/book_small.png";
	
	ITEM.itemSpawnerInfo = {category = "City Junk", rarity = 1000, onGround = false};

ITEM:Register()

local ITEM = Clockwork.item:New("book_base")
	ITEM.name = "Ballad of Saint Ragnar"
	ITEM.model = "models/props_monastery/book_small.mdl"
	ITEM.weight = 0.6;
	ITEM.uniqueID = "book_bosr"
	ITEM.description = "A leatherbound book that details one of the two Northern saints - the first, the Gore."
	ITEM.background = "https://i.imgur.com/ofkBgu0.png"
	ITEM.bookInformation = {Book_SaintRagnar_Page1, Book_SaintRagnar_Page2, Book_SaintRagnar_Page3}
	ITEM.bookType = "Glazic"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/book_small.png";
	
	ITEM.itemSpawnerInfo = {category = "City Junk", rarity = 1000, onGround = false};

ITEM:Register()

local ITEM = Clockwork.item:New("book_base")
	ITEM.name = "Saga of Saint Jeremiah Matheus the Bald"
	ITEM.model = "models/props_monastery/book_small.mdl"
	ITEM.weight = 0.6;
	ITEM.uniqueID = "book_sosjtb"
	ITEM.description = "A leatherbound book that details one of the two Northern saints - the last, the Philimonjio."
	ITEM.background = "https://i.imgur.com/ofkBgu0.png"
	ITEM.bookInformation = {Book_SaintMatheus_Page1, Book_SaintMatheus_Page2, Book_SaintMatheus_Page3, Book_SaintMatheus_Page4}
	ITEM.bookType = "Glazic"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/book_small.png";
	
	ITEM.itemSpawnerInfo = {category = "City Junk", rarity = 1000, onGround = false};

ITEM:Register()

local ITEM = Clockwork.item:New("book_base")
	ITEM.name = "The County Districts"
	ITEM.model = "models/items/magic/scrolls/scroll_rolled.mdl"
	ITEM.weight = 0.6;
	ITEM.uniqueID = "book_tcd"
	ITEM.description = "A scroll of paper detailing a brief summary of the poor outlying districts."
	ITEM.background = "https://i.imgur.com/ofkBgu0.png"
	ITEM.bookInformation = {Book_County1}
	ITEM.bookType = "Glazic"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/scroll.png";
	
	ITEM.itemSpawnerInfo = {category = "City Junk", rarity = 800, onGround = false};

ITEM:Register()

local ITEM = Clockwork.item:New("book_base")
	ITEM.name = "Gay King Summit"
	ITEM.model = "models/props_monastery/book_large.mdl"
	ITEM.weight = 1.4;
	ITEM.uniqueID = "book_gks"
	ITEM.description = "An large leatherbound epic detailing the first encounter with the Northern threat."
	ITEM.background = "https://i.imgur.com/ofkBgu0.png"
	ITEM.bookInformation = {Book_Gay_Page1, Book_Gay_Page2, Book_Gay_Page3, Book_Gay_Page4, Book_Gay_Page5, Book_Gay_Page6, Book_Gay_Page7, Book_Gay_Page8, Book_Gay_Page9, Book_Gay_Page10, Book_Gay_Page11, Book_Gay_Page12, Book_Gay_Page13, Book_Gay_Page14, Book_Gay_Page15, Book_Gay_Page16, Book_Gay_Page17, Book_Gay_Page18, Book_Gay_Page19, Book_Gay_Page20, Book_Gay_Page21, Book_Gay_Page22, Book_Gay_Page23, Book_Gay_Page24, Book_Gay_Page25, Book_Gay_Page26, Book_Gay_Page27}
	ITEM.bookType = "Glazic"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/book_large.png";
	
	ITEM.itemSpawnerInfo = {category = "City Junk", rarity = 1200, onGround = false};
	
ITEM:Register()

local ITEM = Clockwork.item:New("book_base")
	ITEM.name = "Spooning"
	ITEM.model = "models/items/magic/scrolls/scroll_rolled.mdl"
	ITEM.weight = 0.6;
	ITEM.uniqueID = "book_s"
	ITEM.description = "A scroll of paper dictating the practice of spooning."
	ITEM.background = "https://i.imgur.com/ofkBgu0.png"
	ITEM.bookInformation = {Book_Spooning}
	ITEM.bookType = "Glazic"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/scroll.png";
	
	ITEM.itemSpawnerInfo = {category = "City Junk", rarity = 800, onGround = false};

ITEM:Register()

local ITEM = Clockwork.item:New("book_base")
	ITEM.name = "The Ride of Tears"
	ITEM.model = "models/items/magic/scrolls/scroll_rolled.mdl"
	ITEM.weight = 0.6;
	ITEM.uniqueID = "book_rot"
	ITEM.description = "A scroll of paper dictating the use of the Ride of Tears."
	ITEM.background = "https://i.imgur.com/ofkBgu0.png"
	ITEM.bookInformation = {Book_Tears}
	ITEM.bookType = "Glazic"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/scroll.png";
	
	ITEM.itemSpawnerInfo = {category = "City Junk", rarity = 1100, onGround = false};

ITEM:Register()

local ITEM = Clockwork.item:New("book_base")
	ITEM.name = "Quotes of Glazic Renewal"
	ITEM.model = "models/items/magic/scrolls/scroll_rolled.mdl"
	ITEM.weight = 0.6;
	ITEM.uniqueID = "book_qogr"
	ITEM.description = "A scroll of paper displaying quotes of brilliance."
	ITEM.background = "https://i.imgur.com/ofkBgu0.png"
	ITEM.bookInformation = {Book_Quotes1, Book_Quotes2}
	ITEM.bookType = "Glazic"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/scroll.png";
	
	ITEM.itemSpawnerInfo = {category = "City Junk", rarity = 1000, onGround = false};

ITEM:Register()

local ITEM = Clockwork.item:New("book_base")
	ITEM.name = "Quotes of Northern Piety"
	ITEM.model = "models/items/magic/scrolls/scroll_rolled.mdl"
	ITEM.weight = 0.6;
	ITEM.uniqueID = "book_qonp"
	ITEM.description = "A scroll of paper displaying quotes of Gore-Glazic faith."
	ITEM.background = "https://i.imgur.com/ofkBgu0.png"
	ITEM.bookInformation = {Book_NorthQuotes_Page1, Book_NorthQuotes_Page2, Book_NorthQuotes_Page3}
	ITEM.bookType = "Glazic"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/scroll.png";
	
	ITEM.itemSpawnerInfo = {category = "City Junk", rarity = 1000, onGround = false};

ITEM:Register()

local ITEM = Clockwork.item:New("book_base")
	ITEM.name = "The Perpetual Urges"
	ITEM.model = "models/items/magic/scrolls/scroll_rolled.mdl"
	ITEM.weight = 0.6;
	ITEM.uniqueID = "book_tpu"
	ITEM.description = "A scroll of paper regarding a publication on the Fourth Erotica Ban."
	ITEM.background = "https://i.imgur.com/ofkBgu0.png"
	ITEM.bookInformation = {Book_Urges1}
	ITEM.bookType = "Glazic"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/scroll.png";
	
	ITEM.itemSpawnerInfo = {category = "City Junk", rarity = 1000, onGround = false};

ITEM:Register()

local ITEM = Clockwork.item:New("book_base")
	ITEM.name = "The Glaze"
	ITEM.model = "models/items/magic/scrolls/scroll_rolled.mdl"
	ITEM.weight = 0.6;
	ITEM.uniqueID = "book_g"
	ITEM.description = "A scroll of paper regarding the essence of creation and the source of all Light."
	ITEM.background = "https://i.imgur.com/ofkBgu0.png"
	ITEM.bookInformation = {Book_Glaze1}
	ITEM.bookType = "Glazic"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/scroll.png";
	
	ITEM.itemSpawnerInfo = {category = "City Junk", rarity = 1000, onGround = false};

ITEM:Register()

local ITEM = Clockwork.item:New("book_base")
	ITEM.name = "Treachery of the Great Northern Orthodoxy"
	ITEM.model = "models/items/magic/scrolls/scroll_rolled.mdl"
	ITEM.weight = 0.6;
	ITEM.uniqueID = "book_totgno"
	ITEM.description = "A scroll of paper detailing a great betrayal in a Gore-Glazic settlement."
	ITEM.background = "https://i.imgur.com/ofkBgu0.png"
	ITEM.bookInformation = {Book_Treachery1}
	ITEM.bookType = "Glazic"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/scroll.png";
	
	ITEM.itemSpawnerInfo = {category = "City Junk", rarity = 800, onGround = false};

ITEM:Register()

local ITEM = Clockwork.item:New("book_base")
	ITEM.name = "Death Ships"
	ITEM.model = "models/props_monastery/book_small.mdl"
	ITEM.weight = 1;
	ITEM.uniqueID = "book_ds"
	ITEM.description = "A leatherbound book dictating the maiden voyage of the Death Ships."
	ITEM.background = "https://i.imgur.com/ofkBgu0.png"
	ITEM.bookInformation = {Book_Deathships_Page1, Book_Deathships_Page2, Book_Deathships_Page3, Book_Deathships_Page4, Book_Deathships_Page5}
	ITEM.bookType = "Glazic"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/book_small.png";
	
	ITEM.itemSpawnerInfo = {category = "City Junk", rarity = 1200, onGround = false};

ITEM:Register()

local ITEM = Clockwork.item:New("book_base")
	ITEM.name = "The Assault on Farmstead 8"
	ITEM.model = "models/props_monastery/book_small.mdl"
	ITEM.weight = 0.6;
	ITEM.uniqueID = "book_assault"
	ITEM.description = "A leatherbound book recalling the events of a terrible tragedy."
	ITEM.background = "https://i.imgur.com/ofkBgu0.png"
	ITEM.bookInformation = {Book_Assault_Page1, Book_Assault_Page2, Book_Assault_Page3, Book_Assault_Page4, Book_Assault_Page5}
	ITEM.bookType = "Glazic"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/book_small.png";
	
	ITEM.itemSpawnerInfo = {category = "City Junk", rarity = 1000, onGround = false};

ITEM:Register()

local ITEM = Clockwork.item:New("book_base")
	ITEM.name = "Karmine Willtan: A Bibliography"
	ITEM.model = "models/props_monastery/book_small.mdl"
	ITEM.weight = 0.6;
	ITEM.uniqueID = "book_karmine"
	ITEM.description = "A leatherbound book titled after a county man of faith."
	ITEM.background = "https://i.imgur.com/ofkBgu0.png"
	ITEM.bookInformation = {Book_Karmine_Page1, Book_Karmine_Page2, Book_Karmine_Page3}
	ITEM.bookType = "Glazic"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/book_small.png";
	
	ITEM.itemSpawnerInfo = {category = "City Junk", rarity = 1000, onGround = false};

ITEM:Register()

local ITEM = Clockwork.item:New("book_base")
	ITEM.name = "Lord Maximus: A Bibliography"
	ITEM.model = "models/props_monastery/book_large.mdl"
	ITEM.weight = 1.4;
	ITEM.uniqueID = "book_lord"
	ITEM.description = "A large leatherbound epic titled after the greatest of all Glazic figures."
	ITEM.background = "https://i.imgur.com/ofkBgu0.png"
	ITEM.bookInformation = {Book_Maximus_Page1, Book_Maximus_Page2, Book_Maximus_Page3, Book_Maximus_Page4, Book_Maximus_Page5, Book_Maximus_Page6, Book_Maximus_Page7, Book_Maximus_Page8, Book_Maximus_Page9, Book_Maximus_Page10, Book_Maximus_Page11}
	ITEM.bookType = "Glazic"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/book_large.png";
	
	ITEM.itemSpawnerInfo = {category = "City Junk", rarity = 1250, onGround = false};
	
ITEM:Register()

local ITEM = Clockwork.item:New("book_base")
	ITEM.name = "Fucker Joe: A Bibliography"
	ITEM.model = "models/props_monastery/book_small.mdl"
	ITEM.weight = 0.6;
	ITEM.uniqueID = "book_fuckerjoe"
	ITEM.description = "A leatherbound book titled after an infamous serial killer."
	ITEM.background = "https://i.imgur.com/ofkBgu0.png"
	ITEM.bookInformation = {Book_Fucker_Page1, Book_Fucker_Page2, Book_Fucker_Page3, Book_Fucker_Page4}
	ITEM.bookType = "Glazic"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/book_small.png";
	
	ITEM.itemSpawnerInfo = {category = "City Junk", rarity = 1000, onGround = false};

ITEM:Register()

local ITEM = Clockwork.item:New("book_base")
	ITEM.name = "Alamos Eulogy"
	ITEM.model = "models/items/magic/scrolls/scroll_rolled.mdl"
	ITEM.weight = 0.6;
	ITEM.uniqueID = "book_alamos"
	ITEM.description = "A scroll of paper depicting the eulogy of a fallen follower."
	ITEM.background = "https://i.imgur.com/ofkBgu0.png"
	ITEM.bookInformation = {Book_Alamos_Page1}
	ITEM.bookType = "Glazic"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/scroll.png";
	
	ITEM.itemSpawnerInfo = {category = "City Junk", rarity = 3000, onGround = false};

ITEM:Register()

local ITEM = Clockwork.item:New("book_base")
	ITEM.name = "Order of the Golden Phallus"
	ITEM.model = "models/items/magic/scrolls/scroll_rolled.mdl"
	ITEM.weight = 0.6;
	ITEM.uniqueID = "book_phallus"
	ITEM.description = "A scroll from the Far East. It bears foreign words written in red text."
	ITEM.background = "https://i.imgur.com/ofkBgu0.png"
	ITEM.bookInformation = {Book_Phallus_Page1, Book_Phallus_Page2}
	ITEM.bookType = "Darklander"
	ITEM.iconoverride = "materials/begotten/ui/itemicons/scroll.png";
	
	ITEM.itemSpawnerInfo = {category = "City Junk", rarity = 1500, onGround = false};

ITEM:Register()

if (SERVER) then
	function cwScriptures:PlayerCharacterLoaded(player)
		local booksCopied = player:GetCharacterData("BooksCopied", {});
		local booksRead = player:GetCharacterData("BooksRead", {});
		
		netstream.Start(player, "UpdateBooksCopied", booksCopied);
		netstream.Start(player, "UpdateBooksRead", booksRead);
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
		self:SetPos((scrW / 2) - (self:GetWide() / 2), (scrH / 2) - (self:GetTall() / 2) )
		
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
	
	netstream.Hook("OpenBook", function(data)
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
	
	netstream.Hook("UpdateBooksRead", function(data)
		if data then
			cwScriptures.booksRead = data;
		end
	end)
	
	netstream.Hook("UpdateBooksCopied", function(data)
		if data then
			cwScriptures.booksCopied = data;
		end
	end)
end