--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

--config.AddToSystem("Attribute Progression Scale", "scale_attribute_progress", "The amount to scale attribute progress by.");
config.AddToSystem("Messages Must See Player", "messages_must_see_player", "Whether or not you must see a player to hear some in-character messages.");
--config.AddToSystem("Starting Attribute Points", "default_attribute_points", "The default amount of attribute points that a player has.");
--config.AddToSystem("Clockwork Introduction Enabled", "clockwork_intro_enabled", "Enable the Clockwork introduction for new players.");
config.AddToSystem("Health Regeneration Enabled", "health_regeneration_enabled", "Whether or not health regeneration is enabled.");
config.AddToSystem("Prop Protection Enabled", "enable_prop_protection", "Whether or not to enable prop protection.");
config.AddToSystem("Use Local Machine Date", "use_local_machine_date", "Whether or not to use the local machine's date when the map is loaded.");
config.AddToSystem("Use Local Machine Time", "use_local_machine_time", "Whether or not to use the local machine's time when the map is loaded.");
config.AddToSystem("Use Key Opens Entity Menus", "use_opens_entity_menus", "Whether or not 'use' opens the context menus.");
config.AddToSystem("Shoot After Raise Delay", "shoot_after_raise_time", "The time that it takes for players to be able to shoot after raising their weapon (seconds).\nSet to 0 for no time.");
config.AddToSystem("Use Clockwork's Admin System", "use_own_group_system", "Whether or not you use a different group or admin system to Clockwork.");
config.AddToSystem("Saved Recognised Names", "save_recognised_names", "Whether or not recognised names should be saved.");
--config.AddToSystem("Save Attribute Boosts", "save_attribute_boosts", "Whether or not attribute boosts are saved.");
config.AddToSystem("Ragdoll Damage Immunity Time", "ragdoll_immunity_time", "The time that a player's ragdoll is immune from damage (seconds).");
config.AddToSystem("Additional Character Count", "additional_characters", "The additional amount of characters that each player can have.");
config.AddToSystem("Faction Ratio System Enabled", "faction_ratio_enabled", "Whether or not the faction ratio system is enabled.");
config.AddToSystem("Class Changing Interval", "change_class_interval", "The time that a player has to wait to change class again (seconds).", 0, 7200);
config.AddToSystem("Sprinting Lowers Weapon", "sprint_lowers_weapon", "Whether or not sprinting lowers a player's weapon.");
config.AddToSystem("Weapon Raising System Enabled", "raised_weapon_system", "Whether or not the raised weapon system is enabled.");
config.AddToSystem("Prop Kill Protection Enabled", "prop_kill_protection", "Whether or not prop kill protection is enabled.");
config.AddToSystem("Gravity Gun Punt Enabled", "enable_gravgun_punt", "Whether or not to enable entities to be punted with the gravity gun.");
config.AddToSystem("Default Inventory Weight", "default_inv_weight", "The default inventory weight (kilograms).");
config.AddToSystem("Default Inventory Space", "default_inv_space", "The default inventory space (litres).");
config.AddToSystem("Data Save Interval", "save_data_interval", "The time that it takes for data to be saved (seconds).", 0, 7200);
config.AddToSystem("View Punch On Damage", "damage_view_punch", "Whether or not a player's view gets punched when they take damage.");
config.AddToSystem("Unrecognised Name", "unrecognised_name", "The name that is given to unrecognised players.");
config.AddToSystem("Limb Damage Scale", "scale_limb_dmg", "The amount to scale limb damage by.");
config.AddToSystem("Fall Damage Scale", "scale_fall_damage", "The amount to scale fall damage by.");
config.AddToSystem("Starting Currency", "default_cash", "The default amount of cash that each player starts with.", 0, 10000);
--config.AddToSystem("Armor Affects Chest Only", "armor_chest_only", "Whether or not armor only affects the chest.");
config.AddToSystem("Minimum Physical Description Length", "minimum_physdesc", "The minimum amount of characters a player must have in their physical description.", 0, 128);
config.AddToSystem("Wood Breaks Fall", "wood_breaks_fall", "Whether or not wooden physics entities break a player's fall.");
config.AddToSystem("Vignette Enabled", "enable_vignette", "Whether or not the vignette is enabled.");
config.AddToSystem("Heartbeat Sounds Enabled", "enable_heartbeat", "Whether or not the heartbeat is enabled.");
config.AddToSystem("Crosshair Enabled", "enable_crosshair", "Whether or not the crosshair is enabled.");
config.AddToSystem("Free Aiming Enabled", "use_free_aiming", "Whether or not free aiming is enabled.");
config.AddToSystem("Recognise System Enabled", "recognise_system", "Whether or not the recognise system is enabled.");
config.AddToSystem("Currency Enabled", "cash_enabled", "Whether or not cash is enabled.");
config.AddToSystem("Default Physical Description", "default_physdesc", "The physical description that each player begins with.");
config.AddToSystem("Chest Damage Scale", "scale_chest_dmg", "The amount to scale chest damage by.");
config.AddToSystem("Corpse Decay Time", "body_decay_time", "The time that it takes for a player's ragdoll to decay (seconds).", 0, 7200);
config.AddToSystem("Banned Disconnect Message", "banned_message", "The message that a player receives when trying to join while banned.\n!t for the time left, !f for the time format.");
config.AddToSystem("Wages Interval", "wages_interval", "The time that it takes for wages cash to be distrubuted (seconds).", 0, 7200);
config.AddToSystem("Prop Cost Scale", "scale_prop_cost", "How to much to scale prop cost by.\nSet to 0 to to make props free.");
config.AddToSystem("Fade NPC Corpses", "fade_dead_npcs", "Whether or not to fade dead NPCs.");
config.AddToSystem("Cash Weight", "cash_weight", "The weight of cash (kilograms).", 0, 100, 3);
config.AddToSystem("Cash Space", "cash_space", "The amount of space cash takes (litres).", 0, 100, 3);
config.AddToSystem("Head Damage Scale", "scale_head_dmg", "The amount to scale head damage by.");
--config.AddToSystem("Block Inventory Binds", "block_inv_binds", "Whether or not inventory binds should be blocked for players.");
config.AddToSystem("Target ID Delay", "target_id_delay", "The delay before the Target ID is displayed when looking at an entity.");
config.AddToSystem("Headbob Enabled", "enable_headbob", "Whether or not to enable headbob.");
config.AddToSystem("Chat Command Prefix", "command_prefix", "The prefix that is used for chat commands.");
config.AddToSystem("Crouch Walk Speed", "crouched_speed", "The speed that characters walk at when crouched.", 0, 1024);
config.AddToSystem("Maximum Chat Length", "max_chat_length", "The maximum amount of characters that can be typed in chat.", 0, 1024);
config.AddToSystem("Starting Flags", "default_flags", "The flags that each player begins with.");
config.AddToSystem("Player Spray Enabled", "disable_sprays", "Whether players can spray their tags.");
config.AddToSystem("Hint Interval", "hint_interval", "The time that a hint is displayed to each player (seconds).", 0, 7200);
config.AddToSystem("Out-Of-Character Chat Interval", "ooc_interval", "The time that a player has to wait to speak out-of-character again (seconds).\nSet to 0 for never.", 0, 7200);
config.AddToSystem("Local-Out-Of-Character Chat Interval", "looc_interval", "The time that a player has to wait to speak local-out-of-character again (seconds).\nSet to 0 for never.", 0, 7200);
config.AddToSystem("Global Out-Of-Character Chat Enabled", "global_ooc_enabled", "Whether or not global OOC chat is enabled.");
config.AddToSystem("Minute Time", "minute_time", "The time that it takes for a minute to pass (seconds).", 0, 7200);
config.AddToSystem("Door Unlock Interval", "unlock_time", "The time that a player has to wait to unlock a door (seconds).", 0, 7200);
config.AddToSystem("Voice Chat Enabled", "voice_enabled", "Whether or not voice chat is enabled.");
config.AddToSystem("Local Voice Chat", "local_voice", "Whether or not to enable local voice.");
config.AddToSystem("Talk Radius", "talk_radius", "The radius of each player that other characters have to be in to hear them talk (units).", 0, 4096);
config.AddToSystem("Give Hands", "give_hands", "Whether or not to give hands to each player.");
config.AddToSystem("Custom Weapon Color", "custom_weapon_color", "Whether or not to enable custom weapon colors.");
config.AddToSystem("Give Keys", "give_keys", "Whether or not to give keys to each player.");
config.AddToSystem("Wages Name", "wages_name", "The name that is given to wages.");
config.AddToSystem("Jump Power", "jump_power", "The power that characters jump at.", 0, 1024);
config.AddToSystem("Respawn Delay", "spawn_time", "The time that a player has to wait before they can spawn again (seconds).", 0, 7200);
config.AddToSystem("Maximum Walk Speed", "walk_speed", "The speed that characters walk at.", 0, 1024);
config.AddToSystem("Maximum Run Speed", "run_speed", "The speed that characters run at.", 0, 1024);
--config.AddToSystem("Door Price", "door_cost", "The amount of cash that each door costs.");
config.AddToSystem("Door Lock Interval", "lock_time", "The time that a player has to wait to lock a door (seconds).", 0, 7200);
--config.AddToSystem("Maximum Ownable Doors", "max_doors", "The maximum amount of doors a player can own.");
config.AddToSystem("Enable Space System", "enable_space_system", "Whether or not to use the space system that affects inventories.");
--config.AddToSystem("Draw Intro Bars", "draw_intro_bars", "Whether or not to draw cinematic intro black bars on top and bottom of the screen.");
config.AddToSystem("Enable LOOC Icons", "enable_looc_icons", "Whether or not to enable LOOC chat icons.");
--config.AddToSystem("Show Business Menu", "show_business", "Whether or not to show the business menu.");
config.AddToSystem("Enable Chat Multiplier", "chat_multiplier", "Whether or not to change text size based on types of chat.");
config.AddToSystem("Enable Map Props Physgrab", "enable_map_props_physgrab", "Whether or not players will be able to grab map props and doors with physguns.");
config.AddToSystem("Entity Use Cooldown", "entity_handle_time", "The amount of time between entity uses a player has to wait.", 0, 1, 3);
--config.AddToSystem("Enable Quick Raise", "quick_raise_enabled", "Whether or not players can use quick raising to raise their weapons.");
config.AddToSystem("Block Cash Commands Binds", "block_cash_binds", "Whether or not to block any cash command binds.")
config.AddToSystem("Block Fallover Binds", "block_fallover_binds", "Whether or not to block charfallover binds.")
config.AddToSystem("Max Traits", "max_trait_points", "The maximum amount of traits each character can have.")