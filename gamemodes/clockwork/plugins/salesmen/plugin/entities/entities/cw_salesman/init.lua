--[[
	BEGOTTEN III: Developed by DETrooper, cash wednesday, gabs & alyousha35
--]]

util.Include("shared.lua")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

-- Called when the entity initializes.
function ENT:Initialize()
	self:DrawShadow(true)
	self:SetSolid(SOLID_BBOX)
	self:PhysicsInit(SOLID_BBOX)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetUseType(SIMPLE_USE)
end

-- A function to setup the salesman.
function ENT:SetupSalesman(name, physDesc, animation, bShowChatBubble)
	self:SetNetworkedString("Name", name)
	self:SetNetworkedString("PhysDesc", physDesc)
	self:SetupAnimation(animation)

	if (bShowChatBubble) then
		self:MakeChatBubble()
	end
end

-- A function to talk to a player.
function ENT:TalkToPlayer(player, text, default)
	--[[local sayString = text.text or default

	if (text.bHideName != true) then
		sayString = self:GetNetworkedString("Name").." says \""..sayString.."\""
	end

	if (!text.text or (text.text and text.text != "")) then
		Schema:EasyText(player, "lightslategrey", sayString)
	end

	if (text.sound and text.sound != "") then
		netstream.Start(player, "SalesmanPlaySound", {text.sound, self})
	end]]--
	
	-- new stuff
	
	local sayString = text.text or default;
	local chatType = "talk";
	local name = self:GetNetworkedString("Name");
	local type = "t"..chatType;

	if sayString and sayString ~= "" then
		--[[if (istable(player)) then
			for k, v in pairs (player) do
				if (IsValid(v) and v:IsPlayer()) then
					local eyeTrace = v:GetEyeTrace();
					local entity = eyeTrace.Entity;
					local bFocused = false
					
					if (IsValid(entity) and entity == self) then
						bFocused = true;
					end;

					Clockwork.chatBox:Add(v, nil, type, sayString, {name = name, focusedOn = bFocused});
				end;
			end;
		else]]if (IsValid(player) and player:IsPlayer()) then
			local eyeTrace = player:GetEyeTrace();
			local entity = eyeTrace.Entity;
			local bFocused = false

			if (IsValid(entity) and entity == self) then
				bFocused = true;
			end
		
			Clockwork.chatBox:Add(player, nil, type, sayString, {name = name, focusedOn = bFocused});
		end;
	end;
	
	if (text.sound and text.sound != "") then
		netstream.Start(player, "SalesmanPlaySound", {text.sound, self})
	end
end

-- Called to setup the animation.
function ENT:SetupAnimation(animation)
	if (animation and animation != -1) then
		self:ResetSequence(animation)
	else
		self:ResetSequence(4)
	end
end

-- Called to make the chat bubble.
function ENT:MakeChatBubble()
	self.cwChatBubble = ents.Create("cw_chatbubble")
	self.cwChatBubble:SetParent(self)
	self.cwChatBubble:SetPos(self:GetPos() + Vector(0, 0, 90))
	self.cwChatBubble:SetNWEntity("salesman", self)
	self.cwChatBubble:Spawn()
end

-- A function to get the chat bubble.
function ENT:GetChatBubble()
	return self.cwChatBubble
end

-- Called when the entity is used.
function ENT:Use(activator, caller)
	if (IsValid(activator) and activator:IsPlayer()) then
		if (activator:GetEyeTraceNoCursor().HitPos:Distance(self:GetPos()) < 196) then
			if (hook.Run("PlayerCanUseSalesman", activator, self) != false) then
				hook.Run("PlayerUseSalesman", activator, self)
			end
		end
	end
end

-- Called when the entity is removed.
function ENT:OnRemove()
	if (IsValid(self.cwChatBubble)) then
		self.cwChatBubble:Remove()
	end
end