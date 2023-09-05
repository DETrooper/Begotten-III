--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

if (Clockwork.player) then return end
if (!plugin) then include("sh_plugin.lua") end
if (!config) then include("sh_config.lua") end
if (!Clockwork.attribute) then include("sh_attribute.lua") end
if (!Clockwork.faction) then include("sh_faction.lua") end
if (!Clockwork.class) then include("sh_class.lua") end
if (!Clockwork.command) then include("sh_command.lua") end
if (!Clockwork.attribute) then include("sh_attribute.lua") end
if (!Clockwork.option) then include("sh_option.lua") end
if (!Clockwork.entity) then include("sh_entity.lua") end
if (!item) then include("sh_item.lua") end
if (!Clockwork.inventory) then include("sh_inventory.lua") end

library.New("player", Clockwork)

Clockwork.player.playerData = Clockwork.player.playerData or {}
Clockwork.player.characterData = Clockwork.player.characterData or {}

function Clockwork.player:GetPlayerDataTable()
	return self.playerData
end

function Clockwork.player:GetCharacterDataTable()
	return self.characterData
end

function Clockwork.player:GetPlayerData(key)
	return self.playerData[key]
end

function Clockwork.player:GetCharacterData(key)
	return self.characterData[key]
end

function Clockwork.player:SetNetVar(player, key, value)
	if (SERVER) then
		if (IsValid(player)) then
			player:SetNetVar(key, value)
		end
	end
end

function Clockwork.player:GetNetVar(player, key)
	if (IsValid(player)) then
		return player:GetNetVar(key)
	end
end

Clockwork.player.GetSharedVar = Clockwork.player.GetNetVar
Clockwork.player.SetSharedVar = Clockwork.player.SetNetVar

function player.Find(name, bCaseSensitive)
	if (name == nil) then return end
	if (!isstring(name)) then return (IsValid(name) and name) or nil end

	local players = _player.GetAll();
	
	for k, v in pairs(players) do
		if (!v:HasInitialized()) then continue end

		local plyName = v:Name(true)

		if (!bCaseSensitive and plyName:utf8lower():find(name:utf8lower())) then
			return v
		elseif (plyName:find(name)) then
			return v
		elseif (v:SteamID() == name) then
			return v
		elseif (v:Name():find(name)) then
			return v
		end
	end
end

--[[
	@codebase Shared
	@details Add a new character data type that can be synced over the network.
	@param String The name of the data type (can be pretty much anything.)
	@param Int The type of the object (must be a type of NWTYPE_* enum).
	@param Various The default value of the data type.
	@param Function Alter the value that gets networked.
	@param Bool Whether or not the data is networked to the player only (defaults to false.)
--]]
function Clockwork.player:AddCharacterData(name, nwType, default, playerOnly, callback)
	self.characterData[name] = {
		default = default,
		nwType = nwType,
		callback = callback,
		playerOnly = playerOnly
	}
end

--[[
	@codebase Shared
	@details Add a new player data type that can be synced over the network.
	@param String The name of the data type (can be pretty much anything.)
	@param Int The type of the object (must be a type of NWTYPE_* enum).
	@param Various The default value of the data type.
	@param Function Alter the value that gets networked.
	@param Bool Whether or not the data is networked to the player only (defaults to false.)
--]]
function Clockwork.player:AddPlayerData(name, nwType, default, playerOnly, callback)
	self.playerData[name] = {
		default = default,
		nwType = nwType,
		callback = callback,
		playerOnly = playerOnly
	}
end

--[[
	@codebase Shared
	@details A function to get a player's rank within their faction.
	@param Userdata The player whose faction rank you are trying to obtain.
--]]
function Clockwork.player:GetFactionRank(player, character)
	if (character) then
		local faction = Clockwork.faction:FindByID(character.faction)

		if (faction and istable(faction.ranks)) then
			local rank

			for k, v in pairs(faction.ranks) do
				if (k == character.data["factionrank"]) then
					rank = v
					break
				end
			end

			return character.data["factionrank"], rank
		end
	else
		local faction = Clockwork.faction:FindByID(player:GetFaction())

		if (faction and istable(faction.ranks)) then
			local rank

			for k, v in pairs(faction.ranks) do
				if (k == player:GetCharacterData("factionrank")) then
					rank = v
					break
				end
			end

			return player:GetCharacterData("factionrank"), rank
		end
	end
end

--[[
	@codebase Shared
	@details A function to check if a player can promote the target.
	@param Userdata The player whose permissions you are trying to check.
	@param Userdata The player who may be promoted.
--]]
function Clockwork.player:CanPromote(player, target)
	local stringRank, rank = self:GetFactionRank(player)

	if (rank) then
		if (rank.canPromote) then
			local stringTargetRank, targetRank = self:GetFactionRank(target)
			local highestRank, rankTable = Clockwork.faction:GetHighestRank(player:Faction()).position

			if (targetRank.position and targetRank.position != rankTable.position) then
				return (rank.canPromote <= targetRank.position)
			end
		end
	end
end

--[[
	@codebase Shared
	@details A function to check if a player can demote the target.
	@param Userdata The player whose permissions you are trying to check.
	@param Userdata The player who may be demoted.
--]]
function Clockwork.player:CanDemote(player, target)
	local stringRank, rank = self:GetFactionRank(player)

	if (rank) then
		if (rank.canDemote) then
			local stringTargetRank, targetRank = self:GetFactionRank(target)
			local lowestRank, rankTable = Clockwork.faction:GetLowestRank(player:Faction()).position

			if (targetRank.position and targetRank.position != rankTable.position) then
				return (rank.canDemote <= targetRank.position)
			end
		end
	end
end

-- A function to make a player say text as a radio broadcast.
function Clockwork.player:SayRadio(player, text, check, noEavesdrop, proclaim)
	local eavesdroppers = {};
	local listeners = {};
	local radiospies = {};
	local canRadio = true;
	local info = {listeners = {}, noEavesdrop = noEavesdrop, text = text};
	local playerFreq = player:GetCharacterData("frequency");
	
	--Clockwork.plugin:Call("PlayerAdjustRadioInfo", player, info);
	
	if (check) then
		canRadio = Clockwork.plugin:Call("PlayerCanRadio", player, info.text, listeners, eavesdroppers);
	end;
	
	if (canRadio) then
		local radios = ents.FindByClass("cw_radio");
		local TD = Clockwork.config:Get("talk_radius"):Get()
		local TR = (TD * TD)
		local Se = (80 * 80)
		local jammed = false
		for k, v in pairs( _player.GetAll()) do
			if (v:HasInitialized()) then
				local freq = v:GetCharacterData("frequency");
				if ((v:HasItemByID("ecw_radio")) and v:GetCharacterData("radioState", false)) then
					table.insert(radiospies, v);
					if ((v:GetCharacterData("radioJamming", false)) and (freq == playerFreq)) then
						info.text = "<STATIC>"
						jammed = true
					end
				elseif (v == player or (freq == playerFreq and v:HasItemByID("handheld_radio") and v:GetCharacterData("radioState", false))) then
					local lastZone = v:GetCharacterData("LastZone");
					
					if lastZone == "tower" or lastZone == "wasteland" then
						table.insert(listeners, v);
					end
					
					if (v ~= player) then
						if not v:IsNoClipping() and not v.cwWakingUp then
							if lastZone == "tower" or lastZone == "wasteland" or lastZone == "caves" or lastZone == "scrapper" then
								v:EmitSound("radio/radio_out"..tostring(math.random(2, 3))..".wav", 75, math.random(95, 100), 0.75, CHAN_AUTO);
							end
						end
					end
				elseif (!info.noEavesdrop) and (v:GetShootPos():DistToSqr(player:GetShootPos()) <= TR) then
					table.insert(eavesdroppers, v);
				else
					for k2, v2 in ipairs(radios) do
						if (!v2:IsOff() and !v2:IsCrazy() and v2:GetFrequency() == playerFreq) then
							if v:GetPos():DistToSqr(v2:GetPos()) <= Se then
								table.insert(listeners, v);
							end
						end
					end
				end;
			end;
		end;
		
		for k, v in ipairs(radios) do
			if (!v:IsOff() and !v:IsCrazy() and v:GetFrequency() == playerFreq) then
				v:EmitSound("radio/radio_out"..tostring(math.random(1, 3))..".wav", 75, math.random(95, 100), 0.75, CHAN_AUTO);
			end
		end
		
		if proclaim then
			Clockwork.chatBox:SetMultiplier(1.35);
		end
		
		info = Clockwork.chatBox:Add(listeners, player, "radio", info.text);
		
		if (info and IsValid(info.speaker)) then
			if proclaim then
				Clockwork.chatBox:SetMultiplier(1.35);
			end
			
			Clockwork.chatBox:Add(eavesdroppers, info.speaker, "radio_eavesdrop", info.text);
			
			if jammed then
				if proclaim then
					Clockwork.chatBox:SetMultiplier(1.35);
				end
				
				Clockwork.chatBox:Add(radiospies, info.speaker, "radiospy",  info.text);
			else
				if proclaim then
					Clockwork.chatBox:SetMultiplier(1.35);
				end
				
				Clockwork.chatBox:Add(radiospies, info.speaker, "radiospy",  "["..playerFreq.."]: \""..info.text.."\"");
			end
			
			Clockwork.plugin:Call("PlayerRadioUsed", player, info.text, listeners, eavesdroppers);
		end;
	end;
end;