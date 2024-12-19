Clockwork.config:Add("discordlogs_enabled", false);
Clockwork.config:Add("discordlogs_webhook_ic", "");
Clockwork.config:Add("discordlogs_webhook_ooc", "");
Clockwork.config:Add("discordlogs_webhook_commands", "");
Clockwork.config:Add("discordlogs_webhook_miscellaneous", "");
Clockwork.config:Add("discordlogs_webhook_invaction", "");
Clockwork.config:Add("discordlogs_webhook_damage", "");

Clockwork.config:AddToSystem("Discord Logs - Enabled", "discordlogs_enabled", "Whether or not the Discord logs are enabled.");
Clockwork.config:AddToSystem("Discord Logs - IC Webhook URL", "discordlogs_webhook_ic", "The IC Webhook URL for Discord logs.");
Clockwork.config:AddToSystem("Discord Logs - OOC Webhook URL", "discordlogs_webhook_ooc", "The OOC Webhook URL for Discord logs.");
Clockwork.config:AddToSystem("Discord Logs - Commands Webhook URL", "discordlogs_webhook_commands", "The Commands Webhook URL for Discord logs.");
Clockwork.config:AddToSystem("Discord Logs - Miscellaneous Webhook URL", "discordlogs_webhook_miscellaneous", "The Miscellaneous Webhook URL for Discord logs.");
Clockwork.config:AddToSystem("Discord Logs - Inv Action Webhook URL", "discordlogs_webhook_invaction", "The Inv Action Webhook URL for Discord logs.");
Clockwork.config:AddToSystem("Discord Logs - Damage Webhook URL", "discordlogs_webhook_damage", "The Damage Webhook URL for Discord logs.");