Clockwork.config:Add("discordlogs_enabled", false);
Clockwork.config:Add("discordlogs_webhook_ic", "");
Clockwork.config:Add("discordlogs_webhook_ooc", "");
Clockwork.config:Add("discordlogs_webhook_commands", "");
Clockwork.config:Add("discordlogs_webhook_miscellaneous", "");
Clockwork.config:Add("discordlogs_webhook_invaction", "");
Clockwork.config:Add("discordlogs_webhook_damage", "");

if(!pcall(require, "chttp") or !CHTTP) then ErrorNoHalt("CHTTP NOT FOUND! INSTALL AT https://github.com/timschumi/gmod-chttp"); return; end

MsgC(Color(0,255,0), "[Clockwork] Successfully loaded CHTTP\n");

function cwDiscordLog:ValidURL(url)
    if(#url <= 0) then return false; end
    if(!string.StartsWith(url, "https://discord.com/api/webhooks/")) then return false; end

    return true;

end

function cwDiscordLog:Enabled()
    return CHTTP and
        Clockwork.config:Get("discordlogs_enabled"):Get() and
        #Clockwork.config:Get("discordlogs_webhook_ic"):GetString() > 0 and
        #Clockwork.config:Get("discordlogs_webhook_ooc"):GetString() > 0 and
        #Clockwork.config:Get("discordlogs_webhook_commands"):GetString() > 0 and
        #Clockwork.config:Get("discordlogs_webhook_miscellaneous"):GetString() > 0 and
        #Clockwork.config:Get("discordlogs_webhook_invaction"):GetString() > 0 and
        #Clockwork.config:Get("discordlogs_webhook_damage"):GetString() > 0;

end

function cwDiscordLog:Refresh()
    cwDiscordLog.enabled = cwDiscordLog:Enabled();
    Schema:EasyText(Schema:GetAdmins(), (cwDiscordLog.enabled and "icon16/accept.png" or "icon16/cancel.png"), (cwDiscordLog.enabled and "green" or "red"), "Discord logs "..(cwDiscordLog.enabled and "enabled" or "disabled or webhook urls invalid")..".");

end

cwDiscordLog:Refresh();

HTTP = CHTTP;

cwDiscordLog.webhooks = {
    ["ic"] = "discordlogs_webhook_ic",
    ["ooc"] = "discordlogs_webhook_ooc",
    ["commands"] = "discordlogs_webhook_commands",
    ["miscellaneous"] = "discordlogs_webhook_miscellaneous",
	["invaction"] = "discordlogs_webhook_invaction",
	["damage"] = "discordlogs_webhook_damage",

};

cwDiscordLog.colors = {
    white = 16777215,
    red = 16711680,
    yellow = 16776960,
    green = 65280,
    blue = 255,
    black = 0,

};

cwDiscordLog.nextLog = 0;
local color_red = Color(255,0,0);

function cwDiscordLog:Send(message, player, logType)
    logType = isstring(logType) and logType or "miscellaneous";
	message = istable(message) and message or {"error"};

	HTTP({
		method = "post",
		type = "application/json; charset=utf-8",
		headers = {
			["User-Agent"] = "Discord",
		},
		url = Clockwork.config:Get(self.webhooks[logType]):GetString(),
		body = "{\"embeds\": [" .. util.TableToJSON(message, true) .. "]}",

		failed = function(error)
			MsgC(color_red, "Discord API HTTP Error:", color_white, error, "\n");
		end,
		success = function(code, response)
			if code ~= 204 then
				MsgC(color_red, "Discord API HTTP Error:", color_white, code, response, "\n");
			end
	    end
    });

end

function cwDiscordLog:FormatMessage(title, message, link, color, player)
    return {
    	title = title or "",
    	description = message or "",
    	url = link or "https://steamcommunity.com",
    	color = color or self.colors.white,
    	fields = {
    		{
    			name = "CALLER:",
    			value = IsValid(player) and player:SteamName() or "CONSOLE",
    		},
    		{
    			name = "STEAMID:",
    			value = IsValid(player) and player:SteamID() or "CONSOLE",
    		},
    	},
    	timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
    };

end

function cwDiscordLog:GetSteamCommunityLink(player)
	return "https://steamcommunity.com/profiles/"..player:SteamID64().."/"

end

--[[
	this timer system is kind of fucked but its the only way i could get it to work
	without using fucked up tick hooks that break everything for some reason
]]--
function cwDiscordLog:Add(message, player, logType)
    if(!cwDiscordLog.enabled) then return; end

	timer.Simple(self.nextLog, function()
		self.nextLog = self.nextLog - 0.75;

		self:Send(message, player, logType);
	
	end);

	self.nextLog = self.nextLog + 0.75;

    MsgC((IsValid(player) and (player:Nick().." ["..player:SteamID().."]") or "CONSOLE"), " : ", message.title, " - ", message.description, "\n");

end

function cwDiscordLog:PlayerCanSayIC(player, text)
    self:Add(self:FormatMessage("IC Message", player:Nick()..": "..text, self:GetSteamCommunityLink(player), self.colors.white, player), player, "ic");

end

function cwDiscordLog:PlayerCanSayLOOC(player, text)
    self:Add(self:FormatMessage("LOOC Message", player:Nick()..": "..text, self:GetSteamCommunityLink(player), self.colors.white, player), player, "ooc");

end

function cwDiscordLog:PlayerCanSayOOC(player, text)
    self:Add(self:FormatMessage("OOC Message", player:Nick()..": "..text, self:GetSteamCommunityLink(player), self.colors.white, player), player, "ooc");

end

function cwDiscordLog:PlayerCountryAuthed(player, countryCode)
	self:Add(self:FormatMessage("Player Join", player:Nick().." ["..player:IPAddress().."] ".." has connected from "..(Clockwork.kernel:GetCountryName(player) or "an unknown location"), self:GetSteamCommunityLink(player), self.colors.green, player), player, "miscellaneous");

end

function cwDiscordLog:PlayerDisconnected(player)
	self:Add(self:FormatMessage("Player Join", player:Nick().." ["..player:IPAddress().."] ".." has left the server", self:GetSteamCommunityLink(player), self.colors.red, player), player, "miscellaneous");

end

function cwDiscordLog:PrePlayerInvAction(player, itemAction, uniqueID, itemID, interactUniqueID, interactItemID)
	self:Add(self:FormatMessage("Inventory Action", player:Nick().." ran ".."["..itemAction.."] on ".." ["..uniqueID.."] ".." #"..itemID, self:GetSteamCommunityLink(player), self.colors.blue, player), player, "invaction");

end

cwDiscordLog.commandFuncs = {

};

cwDiscordLog.blockedCommands = {
	["Observer"] = true,

};

-- redirection function so return doesnt fuck anything up
function cwDiscordLog:CommandUsedHook(player, commandTable, arguments)
	if(self.blockedCommands[commandTable.name]) then return; end

	if(self.commandFuncs[commandTable.name]) then self.commandFuncs[commandTable.name](player, commandTable, arguments); return; end

    self:Add(self:FormatMessage("Command Attempted", player:Nick()..": ".."/"..commandTable.name.." "..table.concat(arguments, " "), self:GetSteamCommunityLink(player), self.colors.yellow, player), player, "commands");

end

function cwDiscordLog:PlayerCanUseCommand(player, commandTable, arguments)
	self:CommandUsedHook(player, commandTable, arguments);

end

function cwDiscordLog:DamageLog(player, attacker, damage, inflictor, health, armor)
    local attackerName = (attacker == false and "" or " from "..(attacker:IsPlayer() and attacker:Name() or attacker:GetClass()));

	self:Add(self:FormatMessage("Damage Log", (player:Name().." has taken "..tostring(math.ceil(damage)).." damage"..attackerName..(inflictor or "")..", leaving them at "..health.." health"..armor), self:GetSteamCommunityLink(player), self.colors.black, player), player, "damage");

end

function cwDiscordLog:KillLog(player, attacker, damage, inflictor)
    local attackerName = (attacker == false and "" or (attacker:IsPlayer() and attacker:Name() or attacker:GetClass()));

	self:Add(self:FormatMessage("Damage Log", (attackerName.." has dealt "..tostring(math.ceil(damage)).." damage to "..player:Name()..(inflictor or "")..", killing them!"), self:GetSteamCommunityLink(player), self.colors.black, player), player, "damage");

end

cwDiscordLog:Add(cwDiscordLog:FormatMessage("Server Log", "Server has autorefreshed or started."), nil, "miscellaneous");