--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

library.New("chatBox", Clockwork)
Clockwork.chatBox.multiplier = nil;
	
function Clockwork.chatBox:Add(listeners, speaker, class, text, data)
	if (type(listeners) != "table") then
		if (!listeners) then
			listeners = _player.GetAll();
		else
			listeners = {listeners};
		end;
	end;
	
	local info = {
		bShouldSend = true,
		multiplier = self.multiplier,
		listeners = listeners,
		speaker = speaker,
		class = class,
		text = text,
		data = data
	};
	
	if (type(info.data) != "table") then
		info.data = {info.data};
	end;
	
	hook.Run("ChatBoxAdjustInfo", info);
	hook.Run("ChatBoxMessageAdded", info);
	
	if (info.bShouldSend) then
		if (IsValid(info.speaker)) then
			netstream.Start(info.listeners, "ChatBoxPlayerMessage", {
				multiplier = info.multiplier,
				speaker = info.speaker,
				class = info.class,
				text = info.text,
				data = info.data
			});
		else
			netstream.Start(info.listeners, "ChatBoxMessage", {
				multiplier = info.multiplier,
				class = info.class,
				text = info.text,
				data = info.data
			});
		end;
	end;
	
	self.multiplier = nil;
	return info;
end;

function Clockwork.chatBox:AddInTargetRadius(speaker, class, text, position, radius, data)
	local listeners = {};
	local trackers = {};
	local playerCount = _player.GetCount();
	local players = _player.GetAll();
	local ass = (radius / 2)
	local sex = (ass * ass)
	for i = 1, playerCount do
		local v = players[i];
		
		if (v:HasInitialized()) then
			local realTrace = Clockwork.player:GetRealTrace(v);
			
			if ((realTrace.HitPos:DistToSqr(position) <= sex) or position:DistToSqr(v:GetPos()) <= sex) then
				listeners[#listeners + 1] = v;
			elseif v:GetNetVar("tracktarget") then
				trk = v:GetNetVar("tracktarget")
				if trk == speaker:SteamID() then
					listeners[#listeners + 1] = v;
				end
			end;
		end;
	end;
	
	self:Add(listeners, speaker, class, text, data);
	
	if (class == "me") then
		local curTime = CurTime();
		speaker.HasMe = curTime + 6;
	end;
end;

function Clockwork.chatBox:AddInRadius(speaker, class, text, position, radius, data)
	local listeners = {};
	local outOfRangeListeners = {};
	
	local players = _player.GetAll();
	local massiveDump = (radius * radius);
	
	for k, v in pairs(players) do
		if (v:HasInitialized()) then
			local distance = position:DistToSqr(v:GetPos());
			
			if (distance <= massiveDump) then
				if cwSanity and (class == "ic" or class == "yell" or class == "whisper" or class == "me" or class == "proclaim" or class == "meproclaim") then
					if v:Sanity() <= 20 and not v:HasBelief("saintly_composure") then
						if IsValid(speaker) then
							Clockwork.datastream:Start(v, "SanitySpeech", speaker:GetPos());
						end
						
						continue;
					end
				end
				
				listeners[#listeners + 1] = v;
			elseif v:GetNetVar("tracktarget") then
				trk = v:GetNetVar("tracktarget")
				if trk == speaker:SteamID() then
					listeners[#listeners + 1] = v;
				end
			elseif (distance <= ((radius * radius) * 2)) and class == "yell" then
				outOfRangeListeners[#outOfRangeListeners + 1] = v;
			end;
		end;
	end;
	
	self:Add(listeners, speaker, class, text, data);
	
	if #outOfRangeListeners > 0 then
		self:Add(outOfRangeListeners, speaker, "me", "yells something but you are too far away to understand!", data);
	end
	
	if (class == "ic") then
		Clockwork.kernel:PrintLog(LOGTYPE_GENERIC, speaker:Name().." says: \""..text.."\"")
	elseif (class == "looc") then
		Clockwork.kernel:PrintLog(LOGTYPE_GENERIC, "[LOOC] "..speaker:Name()..": "..text)
	end
end;

function Clockwork.chatBox:SendColored(listeners, ...)
	netstream.Start(listeners, "ChatBoxColorMessage", {...});
end;

function Clockwork.chatBox:SetMultiplier(multiplier)
	self.multiplier = multiplier;
end;