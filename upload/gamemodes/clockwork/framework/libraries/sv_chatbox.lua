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
	local dist = (radius / 2)
	local distSqr = (dist * dist)
	
	for i, v in ipairs(_player.GetAll()) do
		if (v:HasInitialized()) then
			local realTrace = Clockwork.player:GetRealTrace(v);
			
			if ((realTrace.HitPos:DistToSqr(position) <= distSqr) or position:DistToSqr(v:GetPos()) <= distSqr) then
				if hook.Run("CanHearClass", v, speaker, class) ~= false then
					listeners[#listeners + 1] = v;
				end
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
	local sqrRadius = (radius * radius);

	for i, v in ipairs(_player.GetAll()) do
		if (v:HasInitialized()) then
			local distance = position:DistToSqr(v:GetPos());
			
			if (distance <= sqrRadius) then
				if hook.Run("CanHearClass", v, speaker, class) == false then
					continue;
				end
				
				listeners[#listeners + 1] = v;
			elseif v:GetNetVar("tracktarget") then
				trk = v:GetNetVar("tracktarget")
				if trk == speaker:SteamID() then
					listeners[#listeners + 1] = v;
				end
			elseif (distance <= (sqrRadius * 2)) and class == "yell" then
				if hook.Run("CanHearClass", v, speaker, class) == false then
					continue;
				end
			
				outOfRangeListeners[#outOfRangeListeners + 1] = v;
			end;
		end;
	end;
	
	self:Add(listeners, speaker, class, text, data);
	
	if #outOfRangeListeners > 0 then
		self:Add(outOfRangeListeners, speaker, "me", "yells something but you are too far away to understand!", data);
	end
end;

function Clockwork.chatBox:SendColored(listeners, ...)
	netstream.Start(listeners, "ChatBoxColorMessage", {...});
end;

function Clockwork.chatBox:SetMultiplier(multiplier)
	self.multiplier = multiplier;
end;