
--[[
	Overwrite and fix skins not being used.
--]]

function Derma_Message(strText, strTitle, strButtonText)
	local Window = vgui.Create("DFrame")
		Window:SetTitle(strTitle or "Message")
		Window:SetDraggable(false)
		Window:ShowCloseButton(false)
		Window:SetBackgroundBlur(true)
		Window:SetDrawOnTop(true)
		
	local InnerPanel = vgui.Create("Panel", Window)
	
	local Text = vgui.Create("DLabel", InnerPanel)
		Text:SetText(strText or "Message Text")
		Text:SizeToContents()
		Text:SetContentAlignment(5)
		
	local ButtonPanel = vgui.Create("DPanel", Window)
		ButtonPanel:SetTall(30)
		ButtonPanel:SetDrawBackground(false)
		
	local Button = vgui.Create("DButton", ButtonPanel)
		Button:SetText(strButtonText or "OK")
		Button:SizeToContents()
		Button:SetTall(20)
		Button:SetWide(Button:GetWide() + 20)
		Button:SetPos(5, 5)
		Button.DoClick = function() Window:Close() end
		
	ButtonPanel:SetWide(Button:GetWide() + 10)
	
	local w, h = Text:GetSize()
	
	Window:SetSize(w + 50, h + 25 + 45 + 10)
	Window:Center()
	
	InnerPanel:StretchToParent(5, 25, 5, 45)
	
	Text:StretchToParent(5, 5, 5, 5)	
	
	ButtonPanel:CenterHorizontal()
	ButtonPanel:AlignBottom(8)
	
	Window:MakePopup()
	Window:DoModal()
	return Window
end

local blue = 25;
local alpha = 75;

function Derma_Query(strText, strTitle, ...)
	local Window = vgui.Create("DFrame")
		Window:SetTitle(strTitle or "Message Title (First Parameter)")
		Window:SetDraggable(false)
		Window:ShowCloseButton(false)
		Window:SetBackgroundBlur(true)
		Window:SetDrawOnTop(true)
		
	local InnerPanel = vgui.Create("DPanel", Window)
		InnerPanel:SetDrawBackground(false)
	
	local Text = vgui.Create("DLabel", InnerPanel)
		Text:SetText(strText or "Message Text (Second Parameter)");
		Text:SetContentAlignment(5)
		Text:SizeToContents()
Window.taa = Text
	local ButtonPanel = vgui.Create("DPanel", Window)
		ButtonPanel:SetTall(30)
		ButtonPanel:SetDrawBackground(false)

	-- Loop through all the options and create buttons for them.
	local NumOptions = 0
	local x = 5

	for k = 1, 8, 2 do
		
		local Text = select(k, ...)
		if Text == nil then break end
		
		local Func = select(k+1, ...) or function() end
	
		local Button = vgui.Create("DButton", ButtonPanel)
			Button:SetText(Text)
			Button:SizeToContents()
			Button:SetTall(20)
			Button:SetWide(Button:GetWide() + 20)
			Button.DoClick = function() Window:Close(); Func() end
			Button:SetPos(x, 5)

		x = x + Button:GetWide() + 5
			
		ButtonPanel:SetWide(x) 
		NumOptions = NumOptions + 1
	
	end

	
	local w, h = Text:GetSize()
	
	w = math.max(w, ButtonPanel:GetWide())
	w = w * 1.5
	Window:SetSize(w + 50, h + 25 + 45 + 10)
	Window:Center()
	
	InnerPanel:StretchToParent(5, 25, 5, 45)
	
	Text:StretchToParent(5, 5, 5, 5)	

	ButtonPanel:CenterHorizontal()
	ButtonPanel:AlignBottom(8)
	
	Window:MakePopup()
	Window:DoModal()
	
	if (NumOptions == 0) then
		Window:Close()
		Error("Derma_Query: Created Query with no Options!?")
		return nil
	end
	
	return Window
end

function Derma_StringRequest(strTitle, strText, strDefaultText, fnEnter, fnCancel, strButtonText, strButtonCancelText)
	local Window = vgui.Create("DFrame")
		Window:SetTitle(strTitle or "Message Title (First Parameter)")
		Window:SetDraggable(false)
		Window:ShowCloseButton(false)
		Window:SetBackgroundBlur(true)
		Window:SetDrawOnTop(true)
		
	local InnerPanel = vgui.Create("DPanel", Window)
		InnerPanel:SetDrawBackground(false)
	
	local Text = vgui.Create("DLabel", InnerPanel)
		Text:SetText(strText or "Message Text (Second Parameter)")
		Text:SizeToContents()
		Text:SetContentAlignment(5)
Window.taa = Text

	local TextEntry = vgui.Create("DTextEntry", InnerPanel)
		TextEntry:SetText(strDefaultText or "")
		TextEntry.OnEnter = function() Window:Close() fnEnter(TextEntry:GetValue()) end
		
	local ButtonPanel = vgui.Create("DPanel", Window)
		ButtonPanel:SetTall(30)
		ButtonPanel:SetDrawBackground(false)
		
	local Button = vgui.Create("DButton", ButtonPanel)
		Button:SetText(strButtonText or "OK")
		Button:SizeToContents()
		Button:SetTall(20)
		Button:SetWide(Button:GetWide() + 20)
		Button:SetPos(5, 5)
		Button.DoClick = function() Window:Close() fnEnter(TextEntry:GetValue()) end
		
	local ButtonCancel = vgui.Create("DButton", ButtonPanel)
		ButtonCancel:SetText(strButtonCancelText or "Cancel")
		ButtonCancel:SizeToContents()
		ButtonCancel:SetTall(20)
		ButtonCancel:SetWide(Button:GetWide() + 20)
		ButtonCancel:SetPos(5, 5)
		ButtonCancel.DoClick = function() Window:Close() if (fnCancel) then fnCancel(TextEntry:GetValue()) end end
		ButtonCancel:MoveRightOf(Button, 5)
		
	ButtonPanel:SetWide(Button:GetWide() + 5 + ButtonCancel:GetWide() + 10)
	
	local w, h = Text:GetSize()
	w = math.max(w, 400) 
	
	Window:SetSize(w + 50, h + 25 + 75 + 10)
	Window:Center()
	
	InnerPanel:StretchToParent(5, 25, 5, 45)
	
	Text:StretchToParent(5, 5, 5, 35)	
	
	TextEntry:StretchToParent(5, nil, 5, nil)
	TextEntry:AlignBottom(5)
	
	TextEntry:RequestFocus()
	TextEntry:SelectAllText(true)
	
	ButtonPanel:CenterHorizontal()
	ButtonPanel:AlignBottom(8)
	
	Window:MakePopup()
	Window:DoModal()
	return Window
end
