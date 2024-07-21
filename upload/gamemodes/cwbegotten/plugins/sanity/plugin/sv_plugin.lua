--[[
	Begotten III: Jesus Wept
--]]

-- Chatbox classes muted when totally insane. Value reflects whether or not a noise should be made. 
cwSanity.deafClasses = {
	["ic"] = true,
	["whisper"] = true,
	["yell"] = true,
	["me"] = true,
	["proclaim"] = true,
	["meproclaim"] = true,
	["radio"] = false,
	["ravenspeak"] = false,
	["ravenspeakclan"] = false,
	["ravenspeakfaction"] = false,
	["ravenspeakreply"] = false,
	["darkwhisperglobal"] = false,
	["darkwhisperreply"] = false,
	["localevent"] = false,
	["event"] = false,
};

local playerMeta = FindMetaTable("Player")

-- A function to handle a player's sanity value.
function playerMeta:HandleSanity(amount)
	if (!amount or type(amount) != "number" or amount == 0 or self.opponent or (self.possessor and IsValid(self.possessor)) or (self.victim and IsValid(self.victim))) then
		return
	end
	
	local subfaction = self:GetSubfaction();
	
	if subfaction == "Rekh-khet-sa" then
		self:SetSharedVar("sanity", 100);
		self:SetCharacterData("sanity", 100);
		return;
	elseif subfaction == "Varazdat" then
		if amount < 0 then
			amount = amount * 1.5;
		end
	end
	
	if amount < 0 then
		if self:HasBelief("prudence") then
			amount = amount * 0.75;
		end
		
		if self.GetCharmEquipped then
			if self:GetFaith() == "Faith of the Family" and self:GetCharmEquipped("effigy_earthing") then
				amount = amount * 0.75;
			end
			
			if self:GetCharmEquipped("warding_talisman") or self:GetCharmEquipped("holy_sigils") or self:GetCharmEquipped("abandoned_doll") then
				amount = amount * 0.5;
			end
		end
		
		if self:GetNetVar("steelWill", false) == true then
			amount = amount * 0.1;
		end
	end
	
	local currentSanity = self:GetCharacterData("sanity", 0)
	local newSanity = math.Clamp(currentSanity + amount, 0, 100)
	local insane = self:HasTrait("insane");
	
	--[[if insane then
		-- Insane players do not gain sanity.
		newSanity = 0;
	else]]
		if (amount < 0) then
			hook.Run("SanityDegrade", self, currentSanity, newSanity, amount)
		else
			hook.Run("SanityGain", self, currentSanity, newSanity, amount)
		end
	--end
	
	if insane then
		newSanity = math.Clamp(newSanity, 0, 40);
	end
	
	if newSanity <= 0 and not self:IsRagdolled() and not self.cwWakingUp and (not player.moonCooldown or player.moonCooldown < CurTime()) then
		Clockwork.player:SetRagdollState(self, RAGDOLL_KNOCKEDOUT, 120);
		Clockwork.chatBox:AddInTargetRadius(self, "me", "stares blankly and then collapses onto the ground!", self:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
		newSanity = 20;
		player.moonCooldown = CurTime() + 125;
	end

	self:SetSharedVar("sanity", newSanity);
	self:SetCharacterData("sanity", newSanity)
end

-- A function to get the player's sanity level.
function playerMeta:Sanity()
	return self:GetCharacterData("sanity", 100)
end

-- A function to get if the player is in a dark area.
function playerMeta:InDarkness()
	return false;
end

-- A function to get if the player is alone.
function playerMeta:IsAlone(requiredDistance)
	local position = self:GetPosition();
	
	for k, v in pairs (ents.FindInSphere(position, requiredDistance)) do
		if v:IsPlayer() and v:GetFaith() == self:GetFaith() then
			return true;
		end
	end
	
	return false;
end

-- A function to get if the player is an enemy of another.
function playerMeta:IsEnemy(player)
	return false;
end

netstream.Hook("TakeSanity", function(player, data)
	if data then
		if data > 0 then
			-- fucker exploiting?
			player:HandleSanity(-5);
		else
			player:HandleSanity(math.max(data, -100));
		end
	else
		player:HandleSanity(-5);
	end
end)