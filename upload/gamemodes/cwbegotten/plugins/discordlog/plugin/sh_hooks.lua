Clockwork.config:Add("discordlogs_enabled", false);
Clockwork.config:Add("discordlogs_webhook_ic", "", nil, nil, nil, true);
Clockwork.config:Add("discordlogs_webhook_ooc", "", nil, nil, nil, true);
Clockwork.config:Add("discordlogs_webhook_commands", "", nil, nil, nil, true);
Clockwork.config:Add("discordlogs_webhook_miscellaneous", "", nil, nil, nil, true);
Clockwork.config:Add("discordlogs_webhook_invaction", "", nil, nil, nil, true);
Clockwork.config:Add("discordlogs_webhook_damage", "", nil, nil, nil, true);

if CLIENT then
Clockwork.config:AddToSystem("Discord Logs - Enabled", "discordlogs_enabled", "Whether or not the Discord logs are enabled.");
Clockwork.config:AddToSystem("Discord Logs - IC Webhook URL", "discordlogs_webhook_ic", "The IC Webhook URL for Discord logs.");
Clockwork.config:AddToSystem("Discord Logs - OOC Webhook URL", "discordlogs_webhook_ooc", "The OOC Webhook URL for Discord logs.");
Clockwork.config:AddToSystem("Discord Logs - Commands Webhook URL", "discordlogs_webhook_commands", "The Commands Webhook URL for Discord logs.");
Clockwork.config:AddToSystem("Discord Logs - Miscellaneous Webhook URL", "discordlogs_webhook_miscellaneous", "The Miscellaneous Webhook URL for Discord logs.");
Clockwork.config:AddToSystem("Discord Logs - Inv Action Webhook URL", "discordlogs_webhook_invaction", "The Inv Action Webhook URL for Discord logs.");
Clockwork.config:AddToSystem("Discord Logs - Damage Webhook URL", "discordlogs_webhook_damage", "The Damage Webhook URL for Discord logs.");
end


---Registers a cfgvar for a custom logtype/channel
---```
---
---cwDiscordLog:RegisterChannel("somethingcool", "test") -- registers a cfg var this must be set on both the client and server
---                                                      -- you can set this with /cfgsetvar somethingcool etc/webhooks/xxxx
---if SERVER then
---local e = {
---    title = "title here",
---    description = "message here",
---    url = "https://steamcommunity.com",
---    color = 0,
---    fields = {
---        {
---            name = "a custom header",
---            value = "a custom footer",
---        },
---        {
---            name = "header",
---            value = "footer",
---        },
---    },
---    timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
---}
---cwDiscordLog:Send(e, "test") -- shorthand name is used here
---end
---```
---@param identifier string
---@param shorthand string
---@return nil
function cwDiscordLog:RegisterChannel(identifier, shorthand)
	if not isstring(identifier) then error("Expected string for identifier, got " .. type(identifier)) end
    if not isstring(shorthand) then error("Expected string for shorthand name, got " .. type(shorthand)) end

    Clockwork.config:Add(identifier, "", nil, nil, nil, true)

    if SERVER then
        self.webhooks[shorthand] = identifier
    else
        Clockwork.config:AddToSystem("Discord Logs - " .. shorthand .. " Webhook URL", identifier, "The " .. shorthand .. " Webhook URL for Discord logs.");
    end
end