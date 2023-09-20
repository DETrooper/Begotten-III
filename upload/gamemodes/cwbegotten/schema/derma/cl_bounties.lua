--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

if (IsValid(Clockwork.Client.cwBountyMenu)) then
	Clockwork.Client.cwBountyMenu:Close()
	Clockwork.Client.cwBountyMenu:Remove()
	Clockwork.Client.cwBountyMenu = nil;
end

local PANEL = {};

surface.CreateFont("Papyrus_Header", {
	font		= "Papyrus",
	size		= 60,
	weight		= 800,
	antialiase	= true,
	shadow 		= false
});

surface.CreateFont("Papyrus_Subheader", {
	font		= "Papyrus",
	size		= 42,
	weight		= 600,
	antialiase	= true,
	shadow 		= false
});

surface.CreateFont("Papyrus_Text", {
	font		= "Papyrus",
	size		= 24,
	weight		= 600,
	antialiase	= true,
	shadow 		= false
});

surface.CreateFont("Papyrus_Text_Small", {
	font		= "Papyrus",
	size		= 18,
	weight		= 600,
	antialiase	= true,
	shadow 		= false
});

AccessorFunc(PANEL, "m_bPaintBackground", "PaintBackground");
AccessorFunc(PANEL, "m_bgColor", "BackgroundColor");
AccessorFunc(PANEL, "m_bDisabled", "Disabled");

-- Called when the panel is initialized.
function PANEL:Init()
	self:SetTitle("");
	self:SetSize(768, 810);
	self.font = Clockwork.fonts:GetMultiplied("nov_IntroTextSmallDETrooper", 1.5);
	
	Clockwork.Client.cwBountyMenu = self;
	
	self:Center();
	--self:Rebuild();
end;

-- A function to rebuild the panel.
function PANEL:Rebuild(bounties, state)
	self.bounties = bounties;
	
	if !table.IsEmpty(bounties) then
		local bountyForm = vgui.Create("cwBasicForm", self);
		bountyForm:StretchToParent(0, 28, self:GetWide() / 1.5, 0);
		--bountyForm:SetText("Uncollected Bounties", nil, "basic_form_highlight");
		bountyForm:SetText("");
	
		local descriptionLabel = vgui.Create("cwInfoText", self);
		descriptionLabel:SetText("Those listed here have committed transgressions against the Glaze and must be corpsed.");
		descriptionLabel:SetWide(self:GetWide() - 8);
		descriptionLabel:SetPos(4, 22);
		
		local panelList = vgui.Create("DPanelList", self.bountyForm);
		panelList:StretchToParent(0, 0, 0, 0);
		panelList:SetPaintBackground(false);
		
		for k, v in SortedPairsByMemberValue(bounties, "bounty", true) do
			local label = vgui.Create("cwInfoText", bountyForm);
			label:SetText("("..v.bounty..") "..v.name);
			label:SetButton(true);
			label.charKey = k;
			label.charName = v.name;
			
			label.DoClick = function()
				local bountyData = Clockwork.Client.cwBountyMenu.bounties[label.charKey];
				
				if bountyData then
					Clockwork.Client.cwBountyMenu:DisplayWantedPoster(bountyData, label.charKey);
				end
			end;
			
			if state == "Hierarchy" or Clockwork.Client:IsAdmin() then
				label.DoRightClick = function()
					Derma_Query("Do you wish to remove this bounty?", label:GetText(), "Yes", function()
						local player = Clockwork.player:FindByID(label.charName);
						
						if player and player:IsWanted() then
							Clockwork.kernel:RunCommand("RemoveBounty", label.charName);
						else
							Clockwork.kernel:RunCommand("RemoveBounty", label.charKey);
						end
						
						Clockwork.Client.cwBountyMenu:Close();
						Clockwork.Client.cwBountyMenu:Remove();
						Clockwork.Client.cwBountyMenu = nil;
					end, "No");
				end
			end
			
			if !self.wantedPoster then
				local bountyData = self.bounties[k];
				
				if bountyData then
					self:DisplayWantedPoster(bountyData, k);
				end
			end

			panelList:AddItem(label);
		end;
		
		bountyForm:AddItem(panelList);
	end;
end;

local grad = Material("begotten/ui/collapsible3-full.png")

function PANEL:PaintOver(width, height)
	if not self.bounties or table.IsEmpty(self.bounties) then
		local x, y = 4, 23;
		local wid,hei = width - 8, height - (23 + 4)

		surface.SetDrawColor(150, 150, 150, 255);
		surface.SetMaterial(grad);
		surface.DrawTexturedRect(x, y, wid, hei)
		draw.RoundedBox(4, x, y, wid, hei, Color(0, 0, 0, 100));
		
		draw.DrawText("There are currently no active bounties,\n though there are yet enemies of the Glaze.", self.font, (width / 2), (height / 2), Color(170, 0, 0, 255), 1, 1);
	end
end

local function Grayscale(entity)
    local colorMod = {
        ["$pp_colour_colour"] = 0,

    };

    for i, v in pairs(entity:GetMaterials()) do
        local tex = Material(v):GetTexture("$basetexture");

        if !IsValid(tex) then continue; end

        colorMod["$fbtexture"] = tex;

        DrawColorModify(colorMod);
    end
end

function PANEL:DisplayWantedPoster(bountyData, charKey)
	if IsValid(self.wantedPoster) then
		self.wantedPoster:Remove();
	end
	
	local wantedPoster = vgui.Create("DImage", self);
	wantedPoster:SetImage("begotten/ui/papes.png");
	wantedPoster:SetSize(self:GetWide() / 1.465, self:GetTall() - 48);
	wantedPoster:SetPos(self:GetWide() / 3.1, 48);
	
	self.wantedPoster = wantedPoster;
	
	local proclamationLabel = vgui.Create("DLabel", wantedPoster);
	proclamationLabel:SetPos(0, 55);
	proclamationLabel:SetText("PROCLAMATION OF THE HOLY HIERARCHY");
	proclamationLabel:SetTextColor(Color(25, 25, 25, 255));
	proclamationLabel:SetFont("Papyrus_Text");
	proclamationLabel:SizeToContents();
	proclamationLabel:CenterHorizontal();
	
	local wantedLabel = vgui.Create("DLabel", wantedPoster);
	wantedLabel:SetPos(0, 80);
	wantedLabel:SetText("WANTED");
	wantedLabel:SetTextColor(Color(120, 25, 25, 255));
	wantedLabel:SetFont("Papyrus_Header");
	wantedLabel:SizeToContents();
	wantedLabel:CenterHorizontal();
	
	local name = bountyData.name;
	local nameLabel = vgui.Create("DLabel", wantedPoster);
	nameLabel:SetPos(0, 130);
	nameLabel:SetText(name);
	nameLabel:SetTextColor(Color(25, 25, 25, 255));
	nameLabel:SetFont("Papyrus_Subheader");
	nameLabel:SizeToContents();
	nameLabel:CenterHorizontal();
	
	local reason = bountyData.reason or "crimes against the Holy Hierarchy.";
	local reasonLabel = vgui.Create("DLabel", wantedPoster);
	reasonLabel:SetPos(0, 165);
	reasonLabel:SetText("For "..reason);
	reasonLabel:SetTextColor(Color(25, 25, 25, 255));
	reasonLabel:SetFont("Papyrus_Text");
	reasonLabel:SetAutoStretchVertical(true);
	reasonLabel:SizeToContents();
	reasonLabel:SetWrap(true);
	reasonLabel:CenterHorizontal();

	local modelPanel = vgui.Create("DModelPanel", wantedPoster);
	modelPanel:SetModel(bountyData.model);
	modelPanel:SetSize(325, 325);
	modelPanel:SetPos(0, 180);
	modelPanel:CenterHorizontal();
	modelPanel:SetAmbientLight(Color(0, 0, 0, 0));
	modelPanel:SetAnimated(false);
	modelPanel:SetDirectionalLight(BOX_TOP, Color(200, 200, 200))
	modelPanel:SetDirectionalLight(BOX_FRONT, Color(200, 200, 200))
	modelPanel:SetMouseInputEnabled(false);
	
	function modelPanel:LayoutEntity(ent)
		-- do nothing
	end
	
	function modelPanel.DrawModel(modelPanel)
		local curparent = modelPanel;
		local rightx = modelPanel:GetWide();
		local leftx = 0;
		local topy = 0;
		local bottomy = modelPanel:GetTall();
		local previous = curparent;
		
		while( curparent:GetParent() != nil ) do
			curparent = curparent:GetParent()
			local x, y = previous:GetPos()
			topy = math.Max( y, topy + y )
			leftx = math.Max( x, leftx + x )
			bottomy = math.Min( y + previous:GetTall(), bottomy + y )
			rightx = math.Min( x + previous:GetWide(), rightx + x )
			previous = curparent
		end
		
		render.SetScissorRect( leftx, topy, rightx, bottomy, true )
			modelPanel.Entity:DrawModel();
			--Grayscale(modelPanel.Entity);
		render.SetScissorRect( 0, 0, 0, 0, false )
	end

	local modelEnt = modelPanel:GetEntity();
	
	if IsValid(modelEnt) then
		modelEnt.noDelete = true;

		if bountyData.skin then
			modelEnt:SetSkin(bountyData.skin);
		end
		
		if bountyData.bodygroup1 then
			modelEnt:SetBodygroup(0, bountyData.bodygroup1);
		end
		
		if bountyData.bodygroup2 then
			modelEnt:SetBodygroup(1, bountyData.bodygroup2);
		end
		
		local headpos = modelEnt:GetBonePosition(modelEnt:LookupBone("ValveBiped.Bip01_Head1"));
		
		modelPanel:SetLookAt(headpos);
		modelPanel:SetCamPos(headpos-Vector(-18, 0, 0));
	end
	
	local physdescLabel = vgui.Create("DLabel", wantedPoster);
	physdescLabel:SetPos(0, 510);
	physdescLabel:SetText(bountyData.physDesc or "They have no known physical description.");
	physdescLabel:SetTextColor(Color(25, 25, 25, 255));
	physdescLabel:SetFont("Papyrus_Text_Small");
	physdescLabel:SetWidth(math.min(470, physdescLabel:GetContentSize()));
	physdescLabel:SetAutoStretchVertical(true);
	physdescLabel:SizeToContents();
	physdescLabel:SetWrap(true);
	physdescLabel:CenterHorizontal();
	
	local statusLabel = vgui.Create("DLabel", wantedPoster);
	statusLabel:SetPos(0, 540);
	statusLabel:SetText("CURRENT LOCATION UNKNOWN");
	statusLabel:SetTextColor(Color(120, 25, 25, 255));
	
	for i, v in ipairs(_player.GetAll()) do
		if v:GetNetVar("Key") == charKey then
			statusLabel:SetText("ACTIVE IN THE AREA");
			statusLabel:SetTextColor(Color(25, 120, 25, 255));
			
			break;
		end
	end

	statusLabel:SetFont("Papyrus_Text");
	statusLabel:SizeToContents();
	statusLabel:CenterHorizontal();
	
	local rewardLabel = vgui.Create("DLabel", wantedPoster);
	rewardLabel:SetPos(0, 575);
	rewardLabel:SetText(tostring(bountyData.bounty or 0).." COIN REWARD!");
	rewardLabel:SetTextColor(Color(25, 25, 25, 255));
	rewardLabel:SetFont("Papyrus_Subheader");
	rewardLabel:SizeToContents();
	rewardLabel:CenterHorizontal();
	
	local captureLabel = vgui.Create("DLabel", wantedPoster);
	captureLabel:SetPos(0, 615);
	captureLabel:SetText("FOR THEIR CAPTURE DEAD OR ALIVE!");
	captureLabel:SetTextColor(Color(25, 25, 25, 255));
	captureLabel:SetFont("Papyrus_Text");
	captureLabel:SizeToContents();
	captureLabel:CenterHorizontal();
	
	local authorityLabel = vgui.Create("DLabel", wantedPoster);
	authorityLabel:SetPos(0, 666);
	authorityLabel:SetText("This proclamation is issued by the authority of:");
	authorityLabel:SetTextColor(Color(25, 25, 25, 255));
	authorityLabel:SetFont("Papyrus_Text");
	authorityLabel:SizeToContents();
	authorityLabel:CenterHorizontal();
	
	local posterLabel = vgui.Create("DLabel", wantedPoster);
	posterLabel:SetPos(0, 690);
	posterLabel:SetText(bountyData.poster or "The Holy Hierarchy");
	posterLabel:SetTextColor(Color(25, 25, 25, 255));
	posterLabel:SetFont("Papyrus_Text");
	posterLabel:SizeToContents();
	posterLabel:CenterHorizontal();
end

-- Called when the menu is opened.
function PANEL:OnMenuOpened()
	if (Clockwork.menu:GetActivePanel() == self) then
		self:Rebuild();
	end;
end;

function PANEL:OnCursorEntered()
	self.cursorInside = true;
end

function PANEL:OnCursorExited()
	self.cursorInside = false;
end

function PANEL:OnMousePressed(keyCode)
	if self.cursorInside == false and keyCode == MOUSE_LEFT then
		self:Remove();
		self = nil;
	end
end

-- Called when the panel is selected.
function PANEL:OnSelected() self:Rebuild(); end;

-- Called when the layout should be performed.
function PANEL:PerformLayout()
	DFrame.PerformLayout(self);

	--self:SetPos((ScrW() / 2) - (self:GetWide() / 2), (ScrH() / 2) - (self:GetTall() / 2));
end;

-- Called each frame.
function PANEL:Think()
	self:InvalidateLayout(true);
end;

vgui.Register("cwBountyMenu", PANEL, "DFrame");