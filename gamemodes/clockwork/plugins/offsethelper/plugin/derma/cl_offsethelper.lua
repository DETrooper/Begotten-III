local PANEL = {};

local function GetOutputText(category, itemTable)
	local outputText = "ITEM."..category.." = ";

	if (string.find(category, "Angle")) then
		outputText = outputText.."Angle(";
	else
		outputText = outputText.."Vector(";
	end;

	for i=120,122 do
		local c = string.char(i);

		outputText = outputText..math.Round(itemTable[category][c], 2);

		if (i != 122) then
			outputText = outputText..", ";
		end;
	end;

	return outputText..");";
end;

function PANEL:Init()
	local scrW, scrH = ScrW(), ScrH();
	local itemTable = Clockwork.item:FindByID(Clockwork.Client.vohUniqueID);
	local defaults = {};
	local equippedItem;

	if (Clockwork.item:IsWeapon(itemTable)) then
		local weapon = Clockwork.Client:GetWeapon(itemTable("weaponClass"));
		local wItemTable = Clockwork.item:GetByWeapon(weapon);

		if (wItemTable and wItemTable("uniqueID") == itemTable("uniqueID")) then
			equippedItem = wItemTable;
		end;
	elseif (itemTable("isAttachment")) then
		local inventoryItems = Clockwork.inventory:GetItemsByID(Clockwork.inventory.client, itemTable.uniqueID);

		if (inventoryItems) then
			for k, v in pairs(inventoryItems) do
				if (v.HasPlayerEquipped and v:HasPlayerEquipped(Clockwork.Client)) then
					equippedItem = v;
					break;
				end;
			end;
		else
			Clockwork.Client:ChatPrint("This attachment is not using the accessory base, some features may be non-functional!");
		end;
	end;

	--[[if (itemTable.AdjustAttachmentOffsetInfo) then
		local inventoryItems = Clockwork.inventory:GetItemsByID(Clockwork.inventory.client, itemTable.uniqueID);

		if (inventoryItems) then
			for k, v in pairs(inventoryItems) do
				v.AdjustAttachmentOffsetInfo = nil;
				equippedItem = v;
			end;
		end;

		defaults.AdjustAttachmentOffsetInfo = itemTable.AdjustAttachmentOffsetInfo;
		itemTable.AdjustAttachmentOffsetInfo = nil;
	end;--]]

	local categories = {
		"loweredOrigin",
		"loweredAngles",
		"attachmentOffsetVector",
		"attachmentOffsetAngles",
		"attachmentModelScale"
	};

	local frame = vgui.Create("EditablePanel");
	frame:MakePopup();
	frame:SetSize(scrW, scrH);
	frame.Paint = function() end;
	frame.Think = function(panel)
		if (input.IsMouseDown(MOUSE_RIGHT)) then
			if (!panel.inputSet) then
				panel.inputSet = true;
				panel:SetMouseInputEnabled(false);
				panel:SetKeyboardInputEnabled(false);
			end;
		else
			if (panel.inputSet) then
				panel.inputSet = nil;
				panel:SetMouseInputEnabled(true);
				panel:SetKeyboardInputEnabled(true);
			end;
		end;
		
		if equippedItem then
			if Clockwork.Client.equipmentSlotModels then
				-- Update this every frame.
				local modelEnt = Clockwork.Client.equipmentSlotModels[equippedItem.itemID];
				
				if IsValid(modelEnt) then
					modelEnt:Remove();
				end
				
				Clockwork.Client.equipmentSlotModels[equippedItem.itemID] = nil;
			end
		end
	end;

	local main = vgui.Create("DFrame", frame);
	main:RequestFocus();
	main:SetTitle("Viz Offset Helper");
	main:SetSize(0.234 * scrW, 0.314 * scrH); // 450, 340
	main:Center();
	main:SetSizable(true);
	main.OnClose = function(panel)
		if (defaults.AdjustAttachmentOffsetInfo) then
			equippedItem.AdjustAttachmentOffsetInfo = defaults.AdjustAttachmentOffsetInfo;
		end;

		if (defaults.attachmentBone) then
			equippedItem.attachmentBone = defaults.attachmentBone;
		end;

		for k, v in pairs(categories) do
			if (!equippedItem[v]) then continue; end;

			for i=120,122 do
				local c = string.char(i);

				equippedItem[v][c] = defaults[v][c];
			end;
		end;

		Clockwork.Client.vohUniqueID = nil;
		frame:Remove();
	end;

	local labelPanel = vgui.Create("DPanel", main);
	labelPanel:Dock(TOP);
	labelPanel:DockMargin(1, 0, 1, 4);
	labelPanel:SetTall(20);

	local label = vgui.Create("DLabel", labelPanel);
	label:SetText("Closing this panel will reset all values!");
	label:SetFont("DermaDefaultBold");
	label:SetPaintBackgroundEnabled(true);
	label:SetBGColor(Color(255, 255, 255, 255));
	label:SetTextColor(Color(0, 0, 0, 255));
	label:SetContentAlignment(5);
	label:Dock(FILL);

	if (equippedItem) then
		if (equippedItem.AdjustAttachmentOffsetInfo) then
			defaults.AdjustAttachmentOffsetInfo = equippedItem.AdjustAttachmentOffsetInfo;
			equippedItem.AdjustAttachmentOffsetInfo = nil;
		end;

		if (equippedItem.attachmentBone) then
			defaults.attachmentBone = equippedItem.attachmentBone;

			local bonePanel = vgui.Create("DPanel", main);
			bonePanel:Dock(TOP);
			bonePanel:DockMargin(0, 0, 0, 3);
			bonePanel:SetTall(20);

			local bone = vgui.Create("DComboBox", bonePanel);
			bone:SetContentAlignment(5);
			bone:Dock(FILL);
			bone:SetValue(itemTable.attachmentBone);
			bone.OnSelect = function(panel, index, value)
				equippedItem.attachmentBone = value;
			end;

			for i=1, Clockwork.Client:GetBoneCount() do
				local boneName = Clockwork.Client:GetBoneName(i);
				if (!Clockwork.Client:BoneHasFlag(i, BONE_USED_BY_HITBOX)) then continue; end;

				bone:AddChoice(boneName);
			end;
		end;
	end;

	local catList = vgui.Create("DCategoryList", main);
	catList:Dock(FILL);

	local panels = {}

	for k, v in pairs(categories) do
		if (!equippedItem[v]) then continue; end;

		self[v.."Cat"] = catList:Add("ITEM."..v);
		self[v.."Cat"]:SetExpanded(0);
		self[v.."Panel"] = vgui.Create("EditablePanel");
		panels[v] = {};

		panels[v].reset = vgui.Create("DButton", self[v.."Panel"]);
		panels[v].reset:Dock(TOP);
		panels[v].reset:DockMargin(4, 4, 4, 0);
		panels[v].reset:SetText("RESET");
		panels[v].reset:SizeToContents();

		if (string.find(v, "Angle")) then
			defaults[v] = Angle(equippedItem[v].x, equippedItem[v].y, equippedItem[v].z);
		else
			defaults[v] = Vector(equippedItem[v].x, equippedItem[v].y, equippedItem[v].z);
		end;


		for i=120,122 do
			local c = string.char(i);

			panels[v][c] = vgui.Create("DNumSlider", self[v.."Panel"]);
			panels[v][c]:Dock(TOP);
			panels[v][c]:DockMargin(4, 4, 4, 0);
			if (string.find(v, "Angle")) then
				panels[v][c]:SetMin(0);
				panels[v][c]:SetMax(360);
			else
				panels[v][c]:SetMin(-64);
				panels[v][c]:SetMax(64);
			end;
			panels[v][c]:SetText(string.upper(c)..":");
			panels[v][c]:SetDark(true);
			panels[v][c]:SetValue(defaults[v][c]);
			panels[v][c].OnValueChanged = function(panel, value)
				equippedItem[v][c] = value;
				panels[v].output:SetText(GetOutputText(v, equippedItem));
			end;
		end;

		panels[v].output = vgui.Create("DTextEntry", self[v.."Panel"]);
		panels[v].output:SetText(GetOutputText(v, equippedItem));
		panels[v].output:SetFont("DebugFixedSmall");
		panels[v].output:SetDisabled(true);
		panels[v].output:Dock(TOP);
		panels[v].output:DockMargin(4, 4, 4, 0);

		panels[v].reset.DoClick = function(panel)
			for i=120,122 do
				local c = string.char(i);

				panels[v][c]:SetValue(defaults[v][c]);
			end;
		end;

		self[v.."Cat"]:SetContents(self[v.."Panel"]);
	end;

	for k, v in pairs(panels) do
		if (string.find(k, "Angle")) then
			v.x:SetText("Pitch:");
			v.y:SetText("Yaw:");
			v.z:SetText("Roll:");
		end;

		if (k == "attachmentModelScale") then
			for i=120,122 do
				local c = string.char(i);

				v[c]:SetMin(-10);
				v[c]:SetMax(10);
			end;
		end;
	end;
end;

vgui.Register("vizOffsetHelper", PANEL);