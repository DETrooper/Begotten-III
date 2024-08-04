--[[
	Begotten 3
	Created by cash wednesday, gabs, DETrooper and alyousha35
--]]

config.AddToSystem("Faith Modifier", "xp_modifier", "The amount to faith (XP) gain by.", 0.5, 10);

if !cwBeliefs.beliefs then
	cwBeliefs.beliefs = {};
end

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
		material = "begotten/ui/menu/"..panel.texture..".png";
	end;

	surface.SetDrawColor(255, 255, 255, panel.alpha);
	surface.SetMaterial(Material(material));
	surface.DrawTexturedRect(x, y, width, height);
end;

-- A function to open the belief tree.
function cwBeliefs:OpenTree(player, level, experience, beliefs, points, faith, highlightBelief)
	if !player then
		player = Clockwork.Client;
	end

	if (IsValid(Clockwork.Client.cwBeliefPanel)) then
		local oldMenu = Clockwork.Client.cwBeliefPanel;
		
		Clockwork.Client.cwBeliefPanel = vgui.Create("cwBeliefTree")
		Clockwork.Client.cwBeliefPanel:Rebuild(player, level, experience, beliefs, points, faith, highlightBelief)
		Clockwork.Client.cwBeliefPanel:MakePopup()
	
		timer.Simple(FrameTime() * 2, function()
			if (IsValid(oldMenu)) then
				oldMenu:Close()
				oldMenu:Remove()
			end;
		end);
	else
		Clockwork.Client.cwBeliefPanel = vgui.Create("cwBeliefTree")
		Clockwork.Client.cwBeliefPanel:Rebuild(player, level, experience, beliefs, points, faith, highlightBelief)
		Clockwork.Client.cwBeliefPanel:MakePopup()
	end
	
	Clockwork.Client:EmitSound("ui/pickup_secret01.wav", 70, 80);
end

function cwBeliefs:HasBelief(uniqueID, bHasAny)
	if (!uniqueID) then
		return
	end;
	
	if istable(uniqueID) then
		if bHasAny then
			for i, v in ipairs(uniqueID) do
				if self.beliefs[v] then
					return true;
				end
			end
		else
			for i, v in ipairs(uniqueID) do
				if !self.beliefs[v] then
					return false;
				end
			end
			
			return true;
		end
	else
		if (self.beliefs[uniqueID]) then
			return true
		end
	end
	
	return false
end

local playerMeta = FindMetaTable("Player");

function playerMeta:GetBeliefs()
	if self == Clockwork.Client then
		return cwBeliefs.beliefs;
	end
end

function playerMeta:HasBelief(uniqueID, bHasAny)
	if self == Clockwork.Client then
		return cwBeliefs:HasBelief(uniqueID, bHasAny);
	end
end

netstream.Hook("BeliefSync", function(data)
	cwBeliefs.beliefs = data;
	
	-- Refresh da beliefs.
	local beliefPanel = Clockwork.Client.cwBeliefPanel;
	
	if (IsValid(beliefPanel)) then
		if beliefPanel:IsVisible() then
			if IsValid(beliefPanel.panelList) then
				local panels = beliefPanel.panelList:GetItems();
				
				for i, v in ipairs(panels) do
					if v.buttons then
						for k, v2 in pairs(v.buttons) do
							v2.nextThink = 0;
						end
					end
				end
			end
		end
	end
end);

netstream.Hook("OpenLevelTreeOtherPlayer", function(data)
	if data[1] and data[2] and data[3] and data[4] and data[5] and data[6] then
		cwBeliefs:OpenTree(data[1], data[2], data[3], data[4], data[5], data[6]);
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

Clockwork.chatBox:RegisterClass("darkwhisperglobalkinisger", "ic", function(info)
	Clockwork.chatBox:Add(info.filtered, nil, Color(150, 20, 20, 255), "["..info.speaker:GetFaction().."] "..info.speaker:Name().." speaks to you and other Children with the voice of the dead, whispering "..info.text);
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

config.AddToSystem("Maximum Sacrament Level", "max_sac_level", "The maximum level that a character can level up to via the Beliefs system.", 30, 80);