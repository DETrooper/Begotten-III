
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

function cwDiscordLog:ClockworkSchemaLoaded()
	cwDiscordLog:Refresh();

end

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

local color_red = Color(255,0,0);

---Forwards a embed object to a discord webhook
---```
---local msg = { -- follows https://discord.com/developers/docs/resources/message#embed-object
--- title = "test",
--- description = "jolly day 2 day, infact it's a always a good day :)"
---}
---cwDiscordLog:Send(msg, "miscellaneous")
---```
---@param message table
---@param logType string
---@return nil
function cwDiscordLog:Send(message, logType)
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
			MsgC(color_red, "Discord API HTTP Error: ", color_white, error, "\n");
		end,
		success = function(code, response)
			if code ~= 204 then
				MsgC(color_red, "Discord API HTTP Error: ", color_white, code, response, "\n");
			end
	    end
    });

end

---@param title string
---@param message string
---@param link string
---@param color number
---@param player Player
---@return table
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

timer.Remove("cwDiscordLog_Watchman")

local logqueue = logqueue or {}
for i, v in pairs(cwDiscordLog.webhooks) do
	logqueue[i] = {}

	timer.Create("cwDiscordLog_Watchman_"..i, 0.75, 0, function()
		if #logqueue[i] == 0 then return end
	
		local msg, _, logType = unpack(logqueue[i][1])
		cwDiscordLog:Send(msg, logType)
		table.remove(logqueue[i], 1)
	end)

end

---@param message table
---@param player Player
---@param logType string
---@return nil
function cwDiscordLog:Add(message, player, logType)
    if(!cwDiscordLog.enabled) then return; end

	logqueue[#logqueue + 1] = {
		message,
		player,
		logType,
	}

    MsgC((IsValid(player) and (player:Nick().." ["..player:SteamID().."]") or "CONSOLE"), " : ", message.title, " - ", message.description, "\n");

end

function cwDiscordLog:PlayerCanSayIC(player, text)
	if Clockwork.config:Get(self.webhooks["ic"]):GetString() == "" then return end

    self:Add(self:FormatMessage("IC Message", player:Nick()..": "..text, self:GetSteamCommunityLink(player), self.colors.white, player), player, "ic");

end

function cwDiscordLog:PlayerCanSayLOOC(player, text)
	if Clockwork.config:Get(self.webhooks["ooc"]):GetString() == "" then return end

    self:Add(self:FormatMessage("LOOC Message", player:Nick()..": "..text, self:GetSteamCommunityLink(player), self.colors.white, player), player, "ooc");

end

function cwDiscordLog:PlayerCanSayOOC(player, text)
	if Clockwork.config:Get(self.webhooks["ooc"]):GetString() == "" then return end

    self:Add(self:FormatMessage("OOC Message", player:Nick()..": "..text, self:GetSteamCommunityLink(player), self.colors.white, player), player, "ooc");

end

function cwDiscordLog:PlayerCountryAuthed(player, countryCode)
	if Clockwork.config:Get(self.webhooks["miscellaneous"]):GetString() == "" then return end

	self:Add(self:FormatMessage("Player Join", player:Nick().." ["..player:IPAddress().."] ".." has connected from "..(Clockwork.kernel:GetCountryName(player) or "an unknown location"), self:GetSteamCommunityLink(player), self.colors.green, player), player, "miscellaneous");

end

function cwDiscordLog:PlayerDisconnected(player)
	if Clockwork.config:Get(self.webhooks["miscellaneous"]):GetString() == "" then return end

	self:Add(self:FormatMessage("Player Join", player:Nick().." ["..player:IPAddress().."] ".." has left the server", self:GetSteamCommunityLink(player), self.colors.red, player), player, "miscellaneous");

end

function cwDiscordLog:PrePlayerInvAction(player, itemAction, uniqueID, itemID, interactUniqueID, interactItemID)
	if Clockwork.config:Get(self.webhooks["invaction"]):GetString() == "" then return end

	self:Add(self:FormatMessage("Inventory Action", player:Nick().." ran ".."["..itemAction.."] on ".." ["..uniqueID.."] ".." #"..itemID, self:GetSteamCommunityLink(player), self.colors.blue, player), player, "invaction");

end

cwDiscordLog.commandFuncs = {

};

cwDiscordLog.blockedCommands = {
	["Observer"] = true,

};

-- redirection function so return doesnt fuck anything up
function cwDiscordLog:CommandUsedHook(player, commandTable, arguments)
	if Clockwork.config:Get(self.webhooks["commands"]):GetString() == "" then return end

	if(self.blockedCommands[commandTable.name]) then return; end

	if(self.commandFuncs[commandTable.name]) then self.commandFuncs[commandTable.name](player, commandTable, arguments); return; end

    self:Add(self:FormatMessage("Command Attempted", player:Nick()..": ".."/"..commandTable.name.." "..table.concat(arguments, " "), self:GetSteamCommunityLink(player), self.colors.yellow, player), player, "commands");

end

function cwDiscordLog:PlayerCanUseCommand(player, commandTable, arguments)
	self:CommandUsedHook(player, commandTable, arguments);

end

function cwDiscordLog:DamageLog(player, attacker, damage, inflictor, health, armor)
	if Clockwork.config:Get(self.webhooks["damage"]):GetString() == "" then return end

    local attackerName = (attacker == false and "" or " from "..(attacker:IsPlayer() and attacker:Name() or attacker:GetClass()));

	self:Add(self:FormatMessage("Damage Log", (player:Name().." has taken "..tostring(math.ceil(damage)).." damage"..attackerName..(inflictor or "")..", leaving them at "..health.." health"..armor), self:GetSteamCommunityLink(player), self.colors.black, player), player, "damage");

end

function cwDiscordLog:KillLog(player, attacker, damage, inflictor)
	if Clockwork.config:Get(self.webhooks["damage"]):GetString() == "" then return end
	
    local attackerName = (attacker == false and "" or (attacker:IsPlayer() and attacker:Name() or attacker:GetClass()));

	self:Add(self:FormatMessage("Damage Log", (attackerName.." has dealt "..tostring(math.ceil(damage)).." damage to "..player:Name()..(inflictor or "")..", killing them!"), self:GetSteamCommunityLink(player), self.colors.black, player), player, "damage");

end

cwDiscordLog:Add(cwDiscordLog:FormatMessage("Server Log", "Server has autorefreshed or started."), nil, "miscellaneous");