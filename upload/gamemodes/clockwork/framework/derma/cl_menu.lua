--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

local Clockwork = Clockwork;
local SysTime = SysTime;
local IsValid = IsValid;
local pairs = pairs;
local ScrH = ScrH;
local ScrW = ScrW;
local PentR = 0;
local table = table;
local vgui = vgui;
local math = math;

local GRADIENT = surface.GetTextureID("gui/gradient");
local PANEL = {};
local buttons = {};

-- Called when the panel is initialized.
function PANEL:Init()
	if (!hook.Run("PreMainMenuInit", self)) then	
		self:SetSize(scrW, scrH);
		self:SetDrawOnTop(false);
		self:SetPaintBackground(false);
		self:SetMouseInputEnabled(true);
		self:SetKeyboardInputEnabled(true);
		
		Clockwork.kernel:SetNoticePanel(self);
		
		self.CreateTime = SysTime();
		self.activePanel = nil;
		
		hook.Run("PostMainMenuInit", self);
		self:Rebuild();
	end;
end;

-- A function to return to the main menu.
function PANEL:ReturnToMainMenu(bPerformCheck)
	if (bPerformCheck) then
		if (IsValid(self.activePanel) and self.activePanel:IsVisible()) then
			self.activePanel:MakePopup();
		end;
		
		return;
	end;
	
	if (IsValid(self.activePanel) and self.activePanel:IsVisible()) then
		self.activePanel:MakePopup();
		self:FadeOut(0.5, self.activePanel,
			function()
				self.activePanel = nil;
			end
		);
	end;
	
	self:MoveTo(self.tabX, self.tabY, 0.4, 0, 4);
end;

-- A function to rebuild the panel.
function PANEL:Rebuild(change)
	if (!hook.Run("PreMainMenuRebuild", self)) then
		self.tabX = ScrW() * 0.05;
		self.tabY = ScrH() * 0.1;

		local activePanel = Clockwork.menu:GetActivePanel();	
		local backgroundColor = Color(255, 255, 255);
		local mainTextFont = Clockwork.option:GetFont("main_text");		
		local smallTextFont = Clockwork.option:GetFont("menu_text_small");
		local tinyTextFont = Clockwork.option:GetFont("menu_text_tiny");
		local imageWidth, imageHeight = 512, 512;
		local fonts = {tinyTextFont, smallTextFont};
		local scrW, scrH = ScrW() * 0.2, ScrH() * 0.5
		
		self:Receiver("dropper", function(self, panels, dropped, menuIndex, x, y)
			if (dropped) then
				local panel = panels[1];
				
				if panel then
					local parent = panel:GetParent();

					if parent and parent.itemData and parent.itemTable then
						Clockwork.inventory:InvAction("drop", parent.itemTable.uniqueID, parent.itemTable.itemID);
					end
				end
			end
		end);
		
		if (IsValid(self.adminlabel)) then
			self.adminlabel:Remove();
		end
		
		if (IsValid(self.closeMenu)) then
			self.closeMenu:Remove();
			self.characterMenu:Remove();
			self.beliefsmenu:Remove();
			self.ritualsmenu:Remove();
			self.craftingmenu:Remove();
			self.statusInfo:Remove();
		end;
		
		-- Close Menu Button
		local width, height = Clockwork.kernel:GetCachedTextSize(smallTextFont, "Close");
		
		self.closeMenu = vgui.Create("cwLabelButton", self);
		self.closeMenu:SetFont(smallTextFont);
		self.closeMenu:SetText("Close");
		self.closeMenu:SetCallback(function(button)
			self:SetOpen(false);
		end);
		--self.closeMenu:SetToolTip("Click here to close the menu.");
		self.closeMenu:SizeToContents();
		self.closeMenu:SetMouseInputEnabled(true);
		self.closeMenu:SetPos(scrW - (width / 2), scrH - (height / 2));
		function self.closeMenu:Paint()
			if (self:GetHovered()) then
				local texts = {"CLOSE", "cLoSe", "ClOsE"};
				
				for i = 1, math.random(2, 4) do
					surface.DrawRotatedText(table.Random(texts), table.Random(fonts), math.random(-20, 20), math.random(-20, 20), math.random(-5, 5), Color(170, 0, 0))
				end;
			end;
		end;
		self.closeMenu:FadeIn(0.5);

		-- Victims Button (Character Menu)
		local width, height = Clockwork.kernel:GetCachedTextSize(smallTextFont, "Victims");
		
		self.characterMenu = vgui.Create("cwLabelButton", self);
		self.characterMenu:SetFont(Clockwork.option:GetFont("menu_text_tiny"));
		self.characterMenu:SetText("Victims");
		self.characterMenu:SetCallback(function(button)
			self:SetOpen(false);
			Clockwork.character:SetPanelOpen(true);
			Clockwork.datastream:Start("RefreshCharacterMenu");
		end);
		--self.characterMenu:SetToolTip("Click here to view the character menu.");
		self.characterMenu:SizeToContents();
		self.characterMenu:SetMouseInputEnabled(true);
		self.characterMenu:SetPos(((scrW - width / 2) + imageWidth * 0.25), (((scrH - 256) + imageHeight * 0.171875) - height));
		
		function self.characterMenu:Paint()
			local width = self:GetWide();
			local height = self:GetTall();
			self:SetPos((((scrW - width / 2) - 256) + width / 2) - (math.cos((PentR - 200) / 57.5) * 232) + 232, ((scrH - height / 2) + imageHeight * 0.125) + (math.sin((PentR - 200) / 57.5) * 232) - (imageHeight * 0.125));

			if (self:GetHovered()) then
				local texts = {"VICTIMS", "vIcTiMs", "ViCtImS"};
				
				for i = 1, math.random(2, 4) do
					surface.DrawRotatedText(table.Random(texts), table.Random(fonts), math.random(-20, 20), math.random(-20, 20), math.random(-5, 5), Color(170, 0, 0))
				end;
			end;
		end;
		self.characterMenu:FadeIn(0.5);

		-- Rituals Button
		local width, height = Clockwork.kernel:GetCachedTextSize(smallTextFont, "Rituals");
		
		self.ritualsmenu = vgui.Create("cwLabelButton", self);
		self.ritualsmenu:SetFont(Clockwork.option:GetFont("menu_text_tiny"));
		self.ritualsmenu:SetText("Rituals");
		self.ritualsmenu:SetCallback(function(button)
			if cwRituals then
				if !Clockwork.Client.cwRitualsMenu or !IsValid(Clockwork.Client.cwRitualsMenu) then
					Clockwork.Client.cwRitualsMenu = vgui.Create("cwRitualsMenu");
				end
				
				Clockwork.Client.cwRitualsMenu:Rebuild();
				Clockwork.Client.cwRitualsMenu:MakePopup();
			end
			
			Clockwork.menu:SetOpen(false);
		end);
		self.ritualsmenu:SizeToContents();
		self.ritualsmenu:SetMouseInputEnabled(true);
		self.ritualsmenu:SetPos((((scrW) + 256) - width), ((scrH - height * 0.5) + imageHeight * 0.125));

		function self.ritualsmenu:Paint()
			local width = self:GetWide();
			local height = self:GetTall();
			self:SetPos((((scrW - width / 2) - 256) + width / 2) - (math.cos((PentR - 128) / 57.5) * 232) + 192, ((scrH - height / 2) + imageHeight * 0.125) + (math.sin((PentR - 128) / 57.5) * 232) - (imageHeight * 0.125));
			
			if (self:GetHovered()) then
				local texts = {"RITUALS", "rItUaLs", "RiTuAlS"};
				
				for i = 1, math.random(2, 4) do
					surface.DrawRotatedText(table.Random(texts), table.Random(fonts), math.random(-20, 20), math.random(-20, 20), math.random(-5, 5), Color(170, 0, 0))
				end;
			end;
		end;
		self.ritualsmenu:FadeIn(0.5);
		
		-- Crafting Button
		local width, height = Clockwork.kernel:GetCachedTextSize(smallTextFont, "Crafting");
		
		self.craftingmenu = vgui.Create("cwLabelButton", self);
		self.craftingmenu:SetFont(Clockwork.option:GetFont("menu_text_tiny"));
		self.craftingmenu:SetText("Crafting");
		self.craftingmenu:SetCallback(function(button)
			if cwRecipes then
				if Clockwork.player:GetAction(Clockwork.Client) == "crafting" then
					return;
				end
				
				if !Clockwork.Client.cwCraftingMenu or !IsValid(Clockwork.Client.cwCraftingMenu) then
					Clockwork.Client.cwCraftingMenu = vgui.Create("cwCraftingMenu");
				end
				
				Clockwork.Client.cwCraftingMenu:Rebuild();
				Clockwork.Client.cwCraftingMenu:MakePopup();
			end
			
			Clockwork.menu:SetOpen(false);
		end);
		self.craftingmenu:SizeToContents();
		self.craftingmenu:SetMouseInputEnabled(true);
		self.craftingmenu:SetPos(((scrW - width / 2) - imageWidth * 0.25), (((scrH - 256) + imageHeight * 0.171875) - height));
		
		function self.craftingmenu:Paint()
			local width = self:GetWide();
			local height = self:GetTall();
			self:SetPos((((scrW - width / 2) - 256) + width / 2) - (math.cos((PentR + 88) / 57.5) * 232) + 232, ((scrH - height / 2) + imageHeight * 0.125) + (math.sin((PentR + 88) / 57.5) * 232) - (imageHeight * 0.125));
			
			if (self:GetHovered()) then
				local texts = {"CRAFTING", "cRaFtInG", "CrAfTiNg"};
				
				for i = 1, math.random(2, 4) do
					surface.DrawRotatedText(table.Random(texts), table.Random(fonts), math.random(-20, 20), math.random(-20, 20), math.random(-5, 5), Color(170, 0, 0))
				end;
			end;
		end;
		self.craftingmenu:FadeIn(0.5);
		
		-- Beliefs Button
		local width, height = Clockwork.kernel:GetCachedTextSize(smallTextFont, "Beliefs");
		
		self.beliefsmenu = vgui.Create("cwLabelButton", self);
		self.beliefsmenu:SetFont(Clockwork.option:GetFont("menu_text_tiny"));
		self.beliefsmenu:SetText("Beliefs");
		self.beliefsmenu:SetCallback(function(button)
			if cwBeliefs then
				cwBeliefs:OpenTree();
			end
			
			Clockwork.menu:SetOpen(false);
		end);
		--self.beliefsmenu:SetToolTip("Click here to view the character menu.");
		self.beliefsmenu:SizeToContents();
		self.beliefsmenu:SetMouseInputEnabled(true);
		
		self.beliefsmenu:SetPos(((scrW - width / 2) + imageWidth * 0.25), (((scrH - 256) + imageHeight * 0.171875) - height));
		function self.beliefsmenu:Paint()
			local width = self:GetWide();
			local height = self:GetTall();
			self:SetPos((((scrW - width / 2) - 256) + width / 2) - (math.cos((PentR - 56) / 57.5) * 232) + 232, ((scrH - height / 2) + imageHeight * 0.125) + (math.sin((PentR - 56) / 57.5) * 232) - (imageHeight * 0.125));
			
			if (self:GetHovered()) then
				local texts = {"BELIEFS", "bElIeFs", "BeLiEfS"};
				
				for i = 1, math.random(2, 4) do
					surface.DrawRotatedText(table.Random(texts), table.Random(fonts), math.random(-20, 20), math.random(-20, 20), math.random(-5, 5), Color(170, 0, 0))
				end;
			end;
		end;
		self.beliefsmenu:FadeIn(0.5);

		if (change) then
			self:SetPos(self.tabX, self.tabY);		
		elseif (IsValid(self.activePanel)) then
			local width = self.activePanel:GetWide();			

			self:SetPos(-400, self.tabY);
			self:MoveTo(ScrW() - width - self.tabX - self.closeMenu:GetWide()*1.50, self.tabY, 0.4, 0, 4);
		else			
			self:SetPos(-400, self.tabY);
			self:MoveTo(self.tabX, self.tabY, 0.4, 0, 4);
		end;
	
		local bIsVisible = false;
		local width = self.characterMenu:GetWide();
		local scrH = ScrH();
		local scrW = ScrW();
		local x = 80;
		local y = 150;
		
		if (Clockwork.Client:IsAdmin()) then
			self.adminlabel = vgui.Create("cwLabelButton", self);
			self.adminlabel:NoClipping(true);
			self.adminlabel:SetFont(Clockwork.option:GetFont("menu_text_tiny"));
			self.adminlabel:SetText(string.upper("[ADMIN OPTIONS]"));
			self.adminlabel:SizeToContents();
			self.adminlabel:SetMouseInputEnabled(false);
			self.adminlabel:SetPos(x, y);
			self.adminlabel:FadeIn(0.5);
			y = y + self.adminlabel:GetTall() + 4;
		end
		
		for k, v in pairs(Clockwork.menu:GetItems()) do
			if (IsValid(v.button)) then
				v.button:Remove();
			end;
		end;
		
		Clockwork.menuitems.stored = {};
		Clockwork.plugin:Call("MenuItemsAdd", Clockwork.menuitems);
		Clockwork.plugin:Call("MenuItemsDestroy", Clockwork.menuitems);
		
		table.sort(Clockwork.menuitems.stored, function(a, b)
			return (a.text < b.text);
		end);
		
		local smallTextFont = Clockwork.option:GetFont("menu_text_tiny");
		for k, v in pairs(Clockwork.menuitems.stored) do
			local button, panel = nil, nil;
			
			if (Clockwork.menu.stored[v.panel]) then
				panel = Clockwork.menu.stored[v.panel].panel;
			else
				panel = vgui.Create(v.panel, self);
				panel:SetVisible(false);
				panel:SetSize(Clockwork.menu:GetWidth(), panel:GetTall());
				--panel:SetPos(self.tabX + (scrW - width - 280), self.tabY + (scrH * 0.1));
				panel:SetPos((ScrW() * 0.5) - (panel:GetWide() / 4), (ScrH() * 0.5) - (panel:GetTall() / 2));
				panel.Name = v.text;
			end;
			
			if (!panel.IsButtonVisible or panel:IsButtonVisible()) then
				button = vgui.Create("cwLabelButton", self);
				button:NoClipping(true);
			end;
		
			if (button) then
				button:SetFont(Clockwork.option:GetFont("menu_text_tiny"));
				button:SetText(string.upper(v.text));
				button:SetAlpha(0);
				button:FadeIn(0.5);
				
				button:SetCallback(function(button)
					if (Clockwork.menu:GetActivePanel() != panel) then
						Clockwork.menu:GetPanel():OpenPanel(panel);
					end;
				end);
				button:SizeToContents();
				button:SetMouseInputEnabled(true);
				button:SetPos(x, y);

				local bannedMenus = {"INVENTORY", "SETTINGS"};
				
				if (!table.HasValue(bannedMenus, string.upper(v.text))) then
					y = y + button:GetTall() + 4;
				end;
				
				bIsVisible = true;
				
				if (button:GetWide() > width) then
					width = button:GetWide();
				end;
				
				local imageWidth, imageHeight = 512, 512;
				local scrW, scrH = ScrW() * 0.2, ScrH() * 0.5;
				
				if (string.find(string.upper(v.text), "INVENTORY")) then
					local width, height = Clockwork.kernel:GetCachedTextSize(smallTextFont, "Sack");
					button:SetPos((((scrW - width / 2) - 256) + width / 2), ((scrH - height / 2) + imageHeight * 0.125));
					button:SetText("Sack");
					buttons[#buttons + 1] = button;
					function button:Paint()
						local width = self:GetWide();
						local height = self:GetTall();
						self:SetPos((((scrW - width / 2) - 256) + width / 2) - (math.cos((PentR + 16) / 57.5) * 232) + 232, ((scrH - height / 2) + imageHeight * 0.125) + (math.sin((PentR + 16) / 57.5) * 232) - (imageHeight * 0.125));

						if (self:GetHovered()) then
							local texts = {"SACK", "sAcK", "SaCk"};
							
							for i = 1, math.random(2, 4) do
								surface.DrawRotatedText(table.Random(texts), table.Random(fonts), math.random(-20, 20), math.random(-20, 20), math.random(-5, 5), Color(170, 0, 0))
							end;
						end;
					end;
				elseif (string.find(string.upper(v.text), "SCOREBOARD")) then
					if (!Clockwork.Client:IsAdmin()) then
						button:SetVisible(false);
					end
				elseif (string.find(string.upper(v.text), "SETTINGS")) then
					local width, height = Clockwork.kernel:GetCachedTextSize(smallTextFont, "Settings");
					button:SetPos(ScrW() - (width * 2), height);
					button:SetText("Settings");
					buttons[#buttons + 1] = button;
				end;
			end;
			
			Clockwork.menu.stored[v.panel] = {
				button = button,
				panel = panel
			};
		end;
		
		for k, v in pairs(Clockwork.menu:GetItems()) do
			if (activePanel == v.panel) then
				if (!IsValid(v.button)) then
					self:FadeOut(0.5, activePanel, function()
						self.activePanel = nil;
					end);
				end;
			end;
		end;
		
		self.statusInfo = vgui.Create("DPanel", self);
		
		self.statusInfo:SetSize(200, 875);
		self.statusInfo:SetPos(ScrW() - 200, (ScrH() - 850) / 2);
		self.statusInfo:MakePopup();
		
		self.statusInfo.panelList = vgui.Create("DPanelList", self.statusInfo);
		self.statusInfo.panelList:SetSize(200, 875);
		self.statusInfo.panelList:EnableVerticalScrollbar(false);
		self.statusInfo.panelList:EnableHorizontal(true);
		self.statusInfo.panelList:HideScrollbar();
		self.statusInfo.panelList:SetPaintBackground(false);
		
		self.statusInfo.limbFrame = vgui.Create("DPanel", self.statusInfo);
		self.statusInfo.limbFrame:SetSize(200, 256);
		self.statusInfo.limbFrame:SetPos(0, 0);
		self.statusInfo.limbFrame:SetPaintBackground(false);
		self.statusInfo.limbFrame.texInfo = {
			textures = {
				[HITGROUP_RIGHTARM] = Clockwork.limb:GetTexture(HITGROUP_RIGHTARM),
				[HITGROUP_RIGHTLEG] = Clockwork.limb:GetTexture(HITGROUP_RIGHTLEG),
				[HITGROUP_LEFTARM] = Clockwork.limb:GetTexture(HITGROUP_LEFTARM),
				[HITGROUP_LEFTLEG] = Clockwork.limb:GetTexture(HITGROUP_LEFTLEG),
				[HITGROUP_STOMACH] = Clockwork.limb:GetTexture(HITGROUP_STOMACH),
				[HITGROUP_CHEST] = Clockwork.limb:GetTexture(HITGROUP_CHEST),
				[HITGROUP_HEAD] = Clockwork.limb:GetTexture(HITGROUP_HEAD),
				["body"] = Clockwork.limb:GetTexture("body")
			},
			limbBounds = {
				[HITGROUP_RIGHTARM] = {x = 88, y = 43, bX = 22, bY = 101},
				[HITGROUP_RIGHTLEG] = {x = 66, y = 143, bX = 25, bY = 111},
				[HITGROUP_LEFTARM] = {x = 19, y = 44, bX = 23, bY = 100},
				[HITGROUP_LEFTLEG] = {x = 41, y = 143, bX = 24, bY = 111},
				[HITGROUP_STOMACH] = {x = 40, y = 88, bX = 51, bY = 54},
				[HITGROUP_CHEST] = {x = 43, y = 42, bX = 44, bY = 45},
				[HITGROUP_HEAD] = {x = 46, y = 4, bX = 39, bY = 37},
			},
			names = {
				[HITGROUP_RIGHTARM] = Clockwork.limb:GetName(HITGROUP_RIGHTARM),
				[HITGROUP_RIGHTLEG] = Clockwork.limb:GetName(HITGROUP_RIGHTLEG),
				[HITGROUP_LEFTARM] = Clockwork.limb:GetName(HITGROUP_LEFTARM),
				[HITGROUP_LEFTLEG] = Clockwork.limb:GetName(HITGROUP_LEFTLEG),
				[HITGROUP_STOMACH] = Clockwork.limb:GetName(HITGROUP_STOMACH),
				[HITGROUP_CHEST] = Clockwork.limb:GetName(HITGROUP_CHEST),
				[HITGROUP_HEAD] = Clockwork.limb:GetName(HITGROUP_HEAD),
			}
		};
		
		self.statusInfo.limbFrame.tipHeight = 0;
		self.statusInfo.limbFrame.tipWidth = 0;
		self.statusInfo.limbFrame.limbInfo = {};
		self.statusInfo.limbFrame.height = 240;
		self.statusInfo.limbFrame.width = 120;
		
		for k, v in pairs(self.statusInfo.limbFrame.texInfo.limbBounds) do
			local name = self.statusInfo.limbFrame.texInfo.names[k];

			self.statusInfo.limbFrame[name] = Clockwork.kernel:CreateDermaToolTip(vgui.Create("DImageButton", self.statusInfo.limbFrame));
			self.statusInfo.limbFrame[name]:SetPos(38 + v.x, 8 + v.y);
			self.statusInfo.limbFrame[name]:SetSize(v.bX, v.bY);
			self.statusInfo.limbFrame[name].hitGroup = k;
			
			self.statusInfo.limbFrame[name]:SetToolTipCallback(function(frame)
				Clockwork.limb:BuildTooltip(k, x, y, 220, frame:GetTall(), frame);
			end);
		end
		
		function self.statusInfo.limbFrame.Paint()
			x = 38;
			y = 8;
			
			surface.SetDrawColor(255, 255, 255, 150);
			surface.SetMaterial(self.statusInfo.limbFrame.texInfo.textures["body"]);
			surface.DrawTexturedRect(x, y, self.statusInfo.limbFrame.width, self.statusInfo.limbFrame.height);
			
			for k, v in pairs(Clockwork.limb.hitGroups) do
				local limbHealth = Clockwork.limb:GetHealth(k);
				local limbColor = Clockwork.limb:GetColor(limbHealth);
				local newIndex = #self.statusInfo.limbFrame.limbInfo + 1;
				
				surface.SetDrawColor(limbColor.r, limbColor.g, limbColor.b, 150);
				surface.SetMaterial(self.statusInfo.limbFrame.texInfo.textures[k]);
				surface.DrawTexturedRect(x, y, self.statusInfo.limbFrame.width, self.statusInfo.limbFrame.height);
				
				self.statusInfo.limbFrame.limbInfo[newIndex] = {
					color = limbColor,
					text = self.statusInfo.limbFrame.texInfo.names[k]..": "..limbHealth.."%"
				};
				
				local textWidth, textHeight = Clockwork.kernel:GetCachedTextSize(mainTextFont, self.statusInfo.limbFrame.limbInfo[newIndex].text);
				self.statusInfo.limbFrame.tipHeight = self.statusInfo.limbFrame.tipHeight + textHeight + 4;
				
				if (textWidth > self.statusInfo.limbFrame.tipWidth) then
					self.statusInfo.limbFrame.tipWidth = textWidth;
				end;
				
				self.statusInfo.limbFrame.limbInfo[newIndex].textHeight = textHeight;
			end;
		end
		
		self.statusInfo.iconFrame = vgui.Create("DPanel", self.statusInfo);
		self.statusInfo.iconFrame:SetSize(200, 320);
		self.statusInfo.iconFrame:SetPaintBackground(false);
		
		self.statusInfo.iconFrame.iconSanity = Clockwork.kernel:CreateDermaToolTip(vgui.Create("DImageButton", self.statusInfo.iconFrame));
		self.statusInfo.iconFrame.iconSanity:SetSize(64, 64);
		self.statusInfo.iconFrame.iconSanity:SetPos(36, 0);
		self.statusInfo.iconFrame.iconSanity:SetImage("begotten/ui/othericons/sanity.png");
		self.statusInfo.iconFrame.iconSanity.text = vgui.Create("DLabel", self.statusInfo.iconFrame);
		self.statusInfo.iconFrame.iconSanity.text:SetText("100%");
		self.statusInfo.iconFrame.iconSanity.text:SetTextColor(Color(160, 145, 145));
		self.statusInfo.iconFrame.iconSanity.text:SetFont("nov_IntroTextSmallDETrooper");
		self.statusInfo.iconFrame.iconSanity.text:SetPos(100, 16);
		self.statusInfo.iconFrame.iconSanity.text:SizeToContents();
		
		x, y = self.statusInfo.iconFrame.iconSanity:GetPos();
		
		self.statusInfo.iconFrame.iconSanity:SetToolTipCallback(function(frame)
			cwSanity:BuildSanityTooltip(x, y, frame:GetWide(), frame:GetTall(), frame);
		end);
		
		self.statusInfo.iconFrame.iconHunger = Clockwork.kernel:CreateDermaToolTip(vgui.Create("DImageButton", self.statusInfo.iconFrame));
		self.statusInfo.iconFrame.iconHunger:SetSize(64, 64);
		self.statusInfo.iconFrame.iconHunger:SetPos(36, 64);
		self.statusInfo.iconFrame.iconHunger:SetImage("begotten/ui/othericons/hunger.png");
		self.statusInfo.iconFrame.iconHunger.text = vgui.Create("DLabel", self.statusInfo.iconFrame);
		self.statusInfo.iconFrame.iconHunger.text:SetText("100%");
		self.statusInfo.iconFrame.iconHunger.text:SetTextColor(Color(160, 145, 145));
		self.statusInfo.iconFrame.iconHunger.text:SetFont("nov_IntroTextSmallDETrooper");
		self.statusInfo.iconFrame.iconHunger.text:SetPos(100, 80);
		self.statusInfo.iconFrame.iconHunger.text:SizeToContents();
		
		x, y = self.statusInfo.iconFrame.iconHunger:GetPos();
		
		self.statusInfo.iconFrame.iconHunger:SetToolTipCallback(function(frame)
			cwCharacterNeeds:BuildNeedTooltip("hunger", x, y, frame:GetWide(), frame:GetTall(), frame);
		end);
		
		self.statusInfo.iconFrame.iconThirst = Clockwork.kernel:CreateDermaToolTip(vgui.Create("DImageButton", self.statusInfo.iconFrame));
		self.statusInfo.iconFrame.iconThirst:SetSize(64, 64);
		self.statusInfo.iconFrame.iconThirst:SetPos(36, 128);
		self.statusInfo.iconFrame.iconThirst:SetImage("begotten/ui/othericons/thirst.png");
		self.statusInfo.iconFrame.iconThirst.text = vgui.Create("DLabel", self.statusInfo.iconFrame);
		self.statusInfo.iconFrame.iconThirst.text:SetText("100%");
		self.statusInfo.iconFrame.iconThirst.text:SetTextColor(Color(160, 145, 145));
		self.statusInfo.iconFrame.iconThirst.text:SetFont("nov_IntroTextSmallDETrooper");
		self.statusInfo.iconFrame.iconThirst.text:SetPos(100, 144);
		self.statusInfo.iconFrame.iconThirst.text:SizeToContents();
		
		x, y = self.statusInfo.iconFrame.iconThirst:GetPos();
		
		self.statusInfo.iconFrame.iconThirst:SetToolTipCallback(function(frame)
			cwCharacterNeeds:BuildNeedTooltip("thirst", x, y, frame:GetWide(), frame:GetTall(), frame);
		end);
		
		self.statusInfo.iconFrame.iconSleep = Clockwork.kernel:CreateDermaToolTip(vgui.Create("DImageButton", self.statusInfo.iconFrame));
		self.statusInfo.iconFrame.iconSleep:SetSize(64, 64);
		self.statusInfo.iconFrame.iconSleep:SetPos(36, 192);
		self.statusInfo.iconFrame.iconSleep:SetImage("begotten/ui/othericons/sleep.png");
		self.statusInfo.iconFrame.iconSleep.text = vgui.Create("DLabel", self.statusInfo.iconFrame);
		self.statusInfo.iconFrame.iconSleep.text:SetText("100%");
		self.statusInfo.iconFrame.iconSleep.text:SetTextColor(Color(160, 145, 145));
		self.statusInfo.iconFrame.iconSleep.text:SetFont("nov_IntroTextSmallDETrooper");
		self.statusInfo.iconFrame.iconSleep.text:SetPos(100, 208);
		self.statusInfo.iconFrame.iconSleep.text:SizeToContents();
		
		x, y = self.statusInfo.iconFrame.iconSleep:GetPos();
		
		self.statusInfo.iconFrame.iconSleep:SetToolTipCallback(function(frame)
			cwCharacterNeeds:BuildNeedTooltip("sleep", x, y, frame:GetWide(), frame:GetTall(), frame);
		end);
		
		self.statusInfo.iconFrame.iconCorruption = Clockwork.kernel:CreateDermaToolTip(vgui.Create("DImageButton", self.statusInfo.iconFrame));
		self.statusInfo.iconFrame.iconCorruption:SetSize(64, 64);
		self.statusInfo.iconFrame.iconCorruption:SetPos(36, 256);
		self.statusInfo.iconFrame.iconCorruption:SetImage("begotten/ui/othericons/corruption.png");
		self.statusInfo.iconFrame.iconCorruption.text = vgui.Create("DLabel", self.statusInfo.iconFrame);
		self.statusInfo.iconFrame.iconCorruption.text:SetText("100%");
		self.statusInfo.iconFrame.iconCorruption.text:SetTextColor(Color(160, 145, 145));
		self.statusInfo.iconFrame.iconCorruption.text:SetFont("nov_IntroTextSmallDETrooper");
		self.statusInfo.iconFrame.iconCorruption.text:SetPos(100, 272);
		self.statusInfo.iconFrame.iconCorruption.text:SizeToContents();
		
		x, y = self.statusInfo.iconFrame.iconCorruption:GetPos();
		
		self.statusInfo.iconFrame.iconCorruption:SetToolTipCallback(function(frame)
			cwCharacterNeeds:BuildNeedTooltip("corruption", x, y, frame:GetWide(), frame:GetTall(), frame);
		end);
		
		self.statusInfo.statusFrame = vgui.Create("DPanel", self.statusInfo);
		self.statusInfo.statusFrame:SetSize(200, 274);
		self.statusInfo.statusFrame:SetPaintBackground(false);
		
		self.statusInfo.statusFrame.container = vgui.Create("DImage", self.statusInfo.statusFrame);
		self.statusInfo.statusFrame.container:SetImage("begotten/ui/statuscontainer.png");
		self.statusInfo.statusFrame.container:SetSize(200, 256);
		
		self.statusInfo.statusFrame.statusText = vgui.Create("DLabel", self.statusInfo.statusFrame);
		self.statusInfo.statusFrame.statusText:SetText("Status Effects");
		self.statusInfo.statusFrame.statusText:SetTextColor(Color(160, 145, 145));
		self.statusInfo.statusFrame.statusText:SetFont("nov_IntroTextSmallDETrooper");
		self.statusInfo.statusFrame.statusText:SizeToContents();
		self.statusInfo.statusFrame.statusText:SetPos(42, 0);
		
		self.statusInfo.statusFrame.effectPanel = vgui.Create("DPanelList", self.statusInfo.statusFrame);
		self.statusInfo.statusFrame.effectPanel:EnableVerticalScrollbar();
		self.statusInfo.statusFrame.effectPanel:SetSize(184, 236);
		self.statusInfo.statusFrame.effectPanel:SetPos(0, 18);
		self.statusInfo.statusFrame.effectPanel:SetSpacing(2);
		self.statusInfo.statusFrame.effectPanel:SetPadding(8);
		self.statusInfo.statusFrame.effectPanel:SetPaintBackground(false);
		
		local statusEffects = {};
		
		hook.Run("ModifyStatusEffects", statusEffects);
		
		for i = 1, #statusEffects do
			local statusEffect = statusEffects[i];
			
			local statusEffectLabel = vgui.Create("DLabel", self);
			statusEffectLabel:SetText(statusEffect.text);
			statusEffectLabel:SetTextColor(statusEffect.color);
			statusEffectLabel:SetFont("Decay_FormText");
			statusEffectLabel:SizeToContents();
			
			self.statusInfo.statusFrame.effectPanel:AddItem(statusEffectLabel);
		end;
		
		self.statusInfo.limbFrame:SetPos(0, 0);
		self.statusInfo.iconFrame:SetPos(0, 256);
		self.statusInfo.statusFrame:SetPos(0, 576);
		
		--self.statusInfo.panelList:AddItem(self.statusInfo.limbFrame);
		--self.statusInfo.panelList:AddItem(self.statusInfo.iconFrame);
		--self.statusInfo.panelList:AddItem(self.statusInfo.statusFrame);
		
		hook.Run("PostMainMenuRebuild", self);
	end;
end;

-- A function to open a panel.
function PANEL:OpenPanel(panelToOpen)
	if (!hook.Run("PreMainMenuOpenPanel", self, panelToOpen)) then
		local height = Clockwork.menu:GetHeight();
		local width = Clockwork.menu:GetWidth();
		local scrW = ScrW();
		local scrH = ScrH();
		
		if (IsValid(self.activePanel)) then
			self:FadeOut(0.5, self.activePanel, function()
				self.activePanel = nil;
				self:OpenPanel(panelToOpen);
			end);
				
			return;
		end;
		
		if (panelToOpen.GetMenuWidth) then
			width = panelToOpen:GetMenuWidth();
		end;
		
		self.activePanel = panelToOpen;
		self.activePanel:SetSize(width, self.activePanel:GetTall());
		self.activePanel:MakePopup();
		self.activePanel:SetPos(ScrW() + 400, scrH * 0.1); 
		
		self.activePanel.GetPanelName = function(panel)
			return panel.Name;
		end;
		
		self.activePanel:SetPos((ScrW() * 0.5) - (width / 4), (ScrH() * 0.5) - (height / 2));
		self.activePanel:SetAlpha(0);
		self:FadeIn(0.5, self.activePanel, function()
			timer.Simple(FrameTime() * 0.5, function()
				if (IsValid(self.activePanel)) then
					if (self.activePanel.OnSelected) then
						self.activePanel:OnSelected();
					end;
				end;
			end);
		end);
		
		hook.Run("PostMainMenuOpenPanel", self, panelToOpen);
	end;
end;

-- A function to make a panel fade out.
function PANEL:FadeOut(speed, panel, Callback)
	local height = Clockwork.menu:GetHeight();
	local width = Clockwork.menu:GetWidth();
	local scrW = ScrW();
	local scrH = ScrH();
	
	if (panel:GetAlpha() > 0 and (!self.fadeOutAnimation or !self.fadeOutAnimation:Active())) then
		self.fadeOutAnimation = Derma_Anim("Fade Panel", panel, function(panel, animation, delta, data)
			panel:SetAlpha(255 - (delta * 255));
			
			if (animation.Finished) then
				self.fadeOutAnimation = nil;
				panel:SetVisible(false);
			end;
			
			if (animation.Finished and Callback) then
				Callback();
			end;
		end);
		
		if (self.fadeOutAnimation) then
			self.fadeOutAnimation:Start(speed);
		end;
		
		surface.PlaySound("begotten/ui/buttonrollover.wav");
	else
		panel:SetVisible(false);
		panel:SetAlpha(0);
		
		if (Callback) then
			Callback();
		end;
	end;
end;

-- A function to make a panel fade in.
function PANEL:FadeIn(speed, panel, Callback)
	if (panel:GetAlpha() == 0 and (!self.fadeInAnimation or !self.fadeInAnimation:Active())) then
		self.fadeInAnimation = Derma_Anim("Fade Panel", panel, function(panel, animation, delta, data)
			local height = Clockwork.menu:GetHeight();
			local width = Clockwork.menu:GetWidth();
			local scrW = ScrW();
			local scrH = ScrH();
			
			panel:SetVisible(true);
			panel:SetAlpha(delta * 255);
			
			if (animation.Finished) then
				self.fadeInAnimation = nil;
			end;
			
			if (animation.Finished and Callback) then
				Callback();
			end;
		end);
		
		if (self.fadeInAnimation) then
			self.fadeInAnimation:Start(speed);
		end;
		
		surface.PlaySound("begotten/ui/buttonclick.wav");
	else
		panel:SetVisible(true);
		panel:SetAlpha(255);
		
		if (Callback) then
			Callback();
		end;
	end;
end;

local mPentagram = Material("begotten/pentagram_red.png");

-- Called when the panel is painted.
function PANEL:Paint(w, h)
	if (!hook.Run("PreMainMenuPaint", self)) then
		derma.SkinHook("Paint", "Panel", self);
		hook.Run("PostMainMenuPaint", self);
	end;
	
	if PentR < 360 then
		PentR = CurTime() % 360;
		
		if PentR >= 360 then
			PentR = PentR - 360;
		end
	else
		PentR = 0;
	end;
	
	local color = CurTime() % 10;
	
	if color > 5 then
		color = 5 - (color - 5);
	end
	
	color = math.ceil(color * 20);
	
	local scrW, scrH = ScrW() * 0.2, ScrH() * 0.5;
	
	surface.SetDrawColor(Color(color + 70, 0, 0, 255));
	surface.SetMaterial(mPentagram);
	surface.DrawTexturedRectRotated(scrW, scrH, 512, 512, PentR);
	
	--local width = self.characterMenu:GetWide();
	--
	--for k, v in pairs (buttons) do
	--	local button = v;
	--	
	--	if (button) then
	--		--width = 
	--		--if (button:GetWide() > width) then
	--		--	width = button:GetWide();
	--		--end;
	--			
	--		local imageWidth, imageHeight = 512, 512;
	--		local scrW, scrH = ScrW() * 0.2, ScrH() * 0.60;
	--			
	--		if (string.find(string.upper(v:GetText()), "INVENTORY")) then
	--			local width, height = Clockwork.kernel:GetCachedTextSize(smallTextFont, "Sack......");
	--			button:SetPos((((scrW - width / 2) - 256) + width / 2) + (cos(PentR) * 256), ((scrH - height / 2) + imageHeight * 0.125) + (sin(PentR) * 256));
			--[[elseif (string.find(string.upper(v.text), "BUSINESS")) then
				local width, height = Clockwork.kernel:GetCachedTextSize(smallTextFont, "Business...");
				button:SetPos((((scrW) + 256) - width), ((scrH - height * 0.5) + imageHeight * 0.125));
			elseif (string.find(string.upper(v.text), "SCOREBOARD")) then
				local width, height = Clockwork.kernel:GetCachedTextSize(smallTextFont, "Scoreboard....");
				button:SetPos(((scrW - width / 2) - imageWidth * 0.25), (((scrH - 256) + imageHeight * 0.171875) - height));
			elseif (string.find(string.upper(v.text), "ATTRIBUTES")) then
				local width, height = Clockwork.kernel:GetCachedTextSize(smallTextFont, "Attributes.....");
				button:SetPos(((scrW - width / 2) + imageWidth * 0.25), (((scrH - 256) + imageHeight * 0.171875) - height));
			elseif (string.find(string.upper(v.text), "SETTINGS")) then
				local width, height = Clockwork.kernel:GetCachedTextSize(smallTextFont, "Settings..");
				button:SetPos((scrW - width / 2), (((scrH * 1.5) - imageHeight * 0.125) - height * 2));]]--
	--		end;
	--	end;
	--end;
	
	local menuHeight = 0;
	
	for k, v in pairs(Clockwork.menuitems.stored) do
		menuHeight = menuHeight + 20;
	end;

	--[[if (!Clockwork.Client:IsAdmin()) then
		Clockwork.kernel:DrawTexturedGradientBox(4,
			ScrW() * 0.05 - 8,
			self.characterMenuLabel.y + self.characterMenuLabel:GetTall(),
			self.characterMenuLabel:GetWide() + 12,
			menuHeight - 12,
			Clockwork.option:GetColor("background"),
			150`
		);
	end;]]--

	return true;
end;

-- Called every fame.
function PANEL:Think()
	if (!hook.Run("PreMainMenuThink", self)) then
		local curTime = CurTime();
		
		self:SetVisible(Clockwork.menu:GetOpen());
		self:SetSize(ScrW(), ScrH());
		self:SetPos(0,0);

		Clockwork.menu.height = ScrH() * 0.75;
		Clockwork.menu.width = math.min(ScrW() * 0.7, 768);
		
		if (self.fadeOutAnimation) then
			self.fadeOutAnimation:Run();
		end;
		
		if (self.fadeInAnimation) then
			self.fadeInAnimation:Run();
		end;
		
		hook.Run("PostMainMenuRebuild", self); -- Refresh the status effect values every tick.
		hook.Run("PostMainMenuThink", self);
		
		if (!self.nextStatusCheck or self.nextStatusCheck < curTime) and self.statusInfo then
			local statusEffects = {};
				
			hook.Run("ModifyStatusEffects", statusEffects);
			
			for k, v in pairs(self.statusInfo.statusFrame.effectPanel:GetItems()) do
				if (IsValid(v)) then
					v:Remove();
				end;
			end;
			
			for i = 1, #statusEffects do
				local statusEffect = statusEffects[i];
				
				local statusEffectLabel = vgui.Create("DLabel", self);
				statusEffectLabel:SetText(statusEffect.text);
				statusEffectLabel:SetTextColor(statusEffect.color);
				statusEffectLabel:SetFont("Decay_FormText");
				statusEffectLabel:SizeToContents();
				
				self.statusInfo.statusFrame.effectPanel:AddItem(statusEffectLabel);
			end;
			
			self.nextStatusCheck = curTime + 0.5;
		end
		
		local activePanel = Clockwork.menu:GetActivePanel();
		local informationColor = Clockwork.option:GetColor("information");
		
		self.closeMenu:OverrideTextColor(informationColor);
		
		for k, v in pairs(Clockwork.menu:GetItems()) do
			if (IsValid(v.button)) then
				if (v.panel == activePanel) then
					v.button:OverrideTextColor(informationColor);
				else
					v.button:OverrideTextColor(false);
				end;
			end;
		end;
		
		if self.statusInfo then
			self.statusInfo:MakePopup();
		end
	end;
end;

-- A function to set whether the panel is open.
function PANEL:SetOpen(bIsOpen)
	self:SetVisible(bIsOpen);
	self:ReturnToMainMenu(true);
	
	Clockwork.menu.bIsOpen = bIsOpen;
	gui.EnableScreenClicker(bIsOpen);
	
	if (bIsOpen) then
		self:Rebuild();
		self.CreateTime = SysTime();
		
		--Clockwork.kernel:RegisterBackgroundBlur(self, SysTime());
		Clockwork.kernel:SetNoticePanel(self);
		Clockwork.plugin:Call("MenuOpened");
		surface.PlaySound("begotten/ui/menuopen.wav");
	else
		--Clockwork.kernel:RemoveBackgroundBlur(self);
		Clockwork.plugin:Call("MenuClosed");
	end;
end;

vgui.Register("cwMenu", PANEL, "DPanel");

hook.Add("VGUIMousePressed", "Clockwork.menu:VGUIMousePressed", function(panel, code)
	local activePanel = Clockwork.menu:GetActivePanel();
	local menuPanel = Clockwork.menu:GetPanel();
	local returnToMenu = false;
	
	if (IsValid(activePanel)) then
		local x, y = activePanel:GetPos();
		local mouseX = gui.MouseX();
		local mouseY = gui.MouseY();

		if (mouseX >= (x - 64) and mouseX <= (x + (activePanel:GetWide() + 64)) and mouseY >= (y - 32) and mouseY <= (y + (activePanel:GetTall() + 32))) then
			returnToMenu = true;
		end;
	end;

	if (Clockwork.menu:GetOpen() and IsValid(activePanel) and menuPanel == panel) then
		menuPanel:ReturnToMainMenu(returnToMenu);
	end;
end);

Clockwork.datastream:Hook("MenuOpen", function(data)
	local panel = Clockwork.menu:GetPanel();
	
	if (panel) then
		Clockwork.menu:SetOpen(data);
	else
		Clockwork.menu:Create(data);
	end;
end);