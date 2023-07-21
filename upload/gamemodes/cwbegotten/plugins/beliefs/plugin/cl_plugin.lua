--[[
	Begotten 3
	Created by cash wednesday, gabs, DETrooper and alyousha35
--]]

-- A function to draw a rounded gradient.
function cwBeliefs:DrawTreeBackground(x, y, width, height, panel)
	if (!panel.alpha) then
		panel.alpha = 255;
	end;
	
	if (panel.alpha != 255) then
		panel.alpha = math.Approach(panel.alpha, 255, FrameTime() * 512);
	end;
	
	local material = "begotten/ui/bgttex3xl.png";
	
	if (panel.texture) then
		material = "begotten/ui/"..panel.texture..".png";
	end;

	surface.SetDrawColor(255, 255, 255, panel.alpha);
	surface.SetMaterial(Material(material));
	surface.DrawTexturedRect(x, y, width, height);
end;

-- A function to open the belief tree.
function cwBeliefs:OpenTree(level, experience, beliefs, points, faith)
	self.localLevelCap = cwBeliefs.sacramentLevelCap;

	if self:HasBelief("loremaster") then
		self.localLevelCap = self.localLevelCap + 10;
	end
	
	if self:HasBelief("sorcerer") then
		self.localLevelCap = self.localLevelCap + 5;
	end
	
	if Clockwork.Client:GetSharedVar("subfaction") == "Rekh-khet-sa" then
		self.localLevelCap = self.localLevelCap + 666;
	end

	if (IsValid(Clockwork.Client.cwBeliefPanel)) then
		local oldMenu = Clockwork.Client.cwBeliefPanel;
		
		Clockwork.Client.cwBeliefPanel = vgui.Create("cwBeliefTree")
		Clockwork.Client.cwBeliefPanel:Rebuild(level, experience, beliefs, points, faith)
		Clockwork.Client.cwBeliefPanel:MakePopup()
	
		timer.Simple(FrameTime() * 2, function()
			if (IsValid(oldMenu)) then
				oldMenu:Close()
				oldMenu:Remove()
			end;
		end);
	else
		Clockwork.Client.cwBeliefPanel = vgui.Create("cwBeliefTree")
		Clockwork.Client.cwBeliefPanel:Rebuild(level, experience, beliefs, points, faith)
		Clockwork.Client.cwBeliefPanel:MakePopup()
	end
end

-- A function to refresh the belief tree.
function cwBeliefs:RefreshTree(level, experience, beliefs, points, faith)
	self.localLevelCap = cwBeliefs.sacramentLevelCap;

	if self:HasBelief("loremaster") then
		self.localLevelCap = self.localLevelCap + 10;
	end
	
	if self:HasBelief("sorcerer") then
		self.localLevelCap = self.localLevelCap + 5;
	end
	
	if Clockwork.Client:GetSharedVar("subfaction") == "Rekh-khet-sa" then
		self.localLevelCap = self.localLevelCap + 666;
	end

	if (IsValid(Clockwork.Client.cwBeliefPanel)) then
		Clockwork.Client.cwBeliefPanel:Rebuild(level, experience, beliefs, points, faith)
		Clockwork.Client.cwBeliefPanel:MakePopup()
	else
		Clockwork.Client.cwBeliefPanel = vgui.Create("cwBeliefTree")
		Clockwork.Client.cwBeliefPanel:Rebuild(level, experience, beliefs, points, faith)
		Clockwork.Client.cwBeliefPanel:MakePopup()
	end
end

function cwBeliefs:HasBelief(uniqueID)
	if (!uniqueID) then
		return
	end;
	
	if (self.beliefs[uniqueID]) then
		return true
	end
	
	return false
end

netstream.Hook("SetLevelInfo", function(data)
	if data and data[1] and data[2] and data[3] and data[4] then
		cwBeliefs.level = data[1];
		cwBeliefs.experience = data[2];
		cwBeliefs.beliefs = data[3];
		cwBeliefs.points = data[4];
	end
end);

netstream.Hook("OpenLevelTree", function(data)
	if not Clockwork.kernel:IsChoosingCharacter() then
		if cwBeliefs.level and cwBeliefs.experience and cwBeliefs.beliefs and cwBeliefs.points then
			cwBeliefs:OpenTree(cwBeliefs.level, cwBeliefs.experience, cwBeliefs.beliefs, cwBeliefs.points, Clockwork.Client:GetSharedVar("faith") or "Faith of the Light");
		end
	end
end);

netstream.Hook("OpenLevelTreeOtherPlayer", function(data)
	if data[1] and data[2] and data[3] and data[4] and data[5] then
		cwBeliefs:OpenTree(data[1], data[2], data[3], data[4], data[5]);
	end
end);

netstream.Hook("RefreshLevelTree", function(data)
	if not Clockwork.kernel:IsChoosingCharacter() and IsValid(Clockwork.Client.cwBeliefPanel) and Clockwork.Client.cwBeliefPanel:IsVisible() then
		if cwBeliefs.level and cwBeliefs.experience and cwBeliefs.beliefs and cwBeliefs.points then
			cwBeliefs:RefreshTree(cwBeliefs.level, cwBeliefs.experience, cwBeliefs.beliefs, cwBeliefs.points, Clockwork.Client:GetSharedVar("faith") or "Faith of the Light");
		end
	end
end);

Clockwork.chatBox:RegisterClass("prayerreply", "ic", function(info)
	Clockwork.chatBox:Add(info.filtered, nil, Color(255, 255, 153, 255), "A powerful voice reverberates through your mind "..info.text);
end);

Clockwork.chatBox:RegisterClass("darkwhisper", "ic", function(info)
	Clockwork.chatBox:Add(info.filtered, nil, Color(150, 20, 20, 255), info.speaker:Name().." speaks to you with the voice of the dead, whispering "..info.text);
end);

Clockwork.chatBox:RegisterClass("darkwhisperglobal", "ic", function(info)
	Clockwork.chatBox:Add(info.filtered, nil, Color(150, 20, 20, 255), info.speaker:Name().." speaks to you and other Children with the voice of the dead, whispering "..info.text);
end);

Clockwork.chatBox:RegisterClass("darkwhisperevent", "ic", function(info)
	Clockwork.chatBox:Add(info.filtered, nil, Color(150, 20, 20, 255), "A whispering voice pierces your mind, accompanied by shrieking: "..info.text);
end);

Clockwork.chatBox:RegisterClass("darkwhispernondark", "ic", function(info)
	Clockwork.chatBox:Add(info.filtered, nil, Color(150, 20, 20, 255), "A terrifying unholy whisper can be heard, conferring "..info.text..". You may reply using /darkreply, but this will undoubtedly infer corruption.");
end);

Clockwork.chatBox:RegisterClass("darkwhisperreply", "ic", function(info)
	Clockwork.chatBox:Add(info.filtered, nil, Color(150, 20, 20, 255), info.speaker:Name().." speaks back through the void, whispering "..info.text);
end);

Clockwork.chatBox:RegisterClass("darkwhispernoprefix", "ic", function(info)
	Clockwork.chatBox:Add(info.filtered, nil, Color(150, 20, 20, 255), info.text);
end);

Clockwork.chatBox:RegisterClass("relay", "ic", function(info)
	Clockwork.chatBox:Add(info.filtered, nil, Color(125, 249, 255, 255), info.speaker:Name().." speaks to your mind through electrical signals, "..info.text, info.font);
end);