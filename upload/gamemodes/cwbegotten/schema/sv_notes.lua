--[[
	put notes and shit in here
--]]

-- A function to check if a player has a custom sound playing or not.
function Schema:CustomSoundPlaying(player)
	if (player:IsPlayer() and player:HasInitialized()) then
		player.HasCustomSoundRequested = true;
		netstream.Start(player, "PlayerCustomSoundCheck");
		
		timer.Create(player:EntIndex().."_soundcheckconfirm", FrameTime(), 60, function()
			if (player.CustomSoundPlaying) then
				if (timer.Exists(player:EntIndex().."_soundcheckconfirm")) then
					timer.Destroy(player:EntIndex().."_soundcheckconfirm");
				end;
				
				return true;
			end;
		end);
	end;
end;

netstream.Hook("ConfirmCustomSoundCheck", function(player, data)
	if (player.HasCustomSoundRequested) then
		player.HasCustomSoundRequested = nil;
	else
		player:Kick("Abusing datastreams. Your activity has been sent to admins for review.");
		
		for k, v in pairs (_player.GetAll()) do
			if (v:IsAdmin()) then
				Clockwork.player:Notify(v, player:Name().." ("..player:SteamID()..") has been kicked for initiating an unauthorized datastream. This is evidence of lua cache decryption and clientside lua execution!");
			end;
		end;
		
		return;
	end;

	if (data[1]) then
		player.CustomSoundPlaying = true;
	end;
end);

--[[
tomato
saddlebrown
lawngreen
dimgrey
mediumaquamarine
royalblue
darkgoldenrod
sienna
lightskyblue
slateblue
darkred
maroon
goldenrod
olive
crimson
orange
gold

skyblue -- dev
lightslateblue -- neutral notification
lawngreen -- really good status improvement, cold pops & purified water for example, 
slateblue -- ship status                    
orange -- duel notification passive
forestgreen - duel notifications positive
orangered -- duel notifications negative
tomato -- notifies about explosions, plague, admin notifies about player status
indianred -- medical text
olivedrab -- action text good (drinking something, positive effects), sold item to salesman
olive -- action text bad (taking damage, something you just ate made you take damage), bought item from salesman
maroon -- BAD text, something bad just happened (player just died to moon, etc)
firebrick -- error, cannot perform action (too far away, impossible action, ooc reasons)
chocolate -- player missing belief, trait, item, experience amount, anything
red -- corpse text, satanist action
cornflowerblue -- command notifications, confirmation etc
peru -- error already in action, action is currently impossible (ic reasons)
grey -- error notifications, arguments provided not valid
darkgrey -- missing arguments, requirements, already has
--]]

--[[ -- PLAYER SUGGESTIONS BE HERE
	
more traits would be kinda epic
like, more negative traits, more positive traits
can make much more varied characters

some more ways to earn coins as a non gatekeeper would be nice, it is extremely hard to get any currency as is as far as im aware

a deaf trait
you cant hear shit
so people can do the blind and deaf run

I wish there were more options to use the Scribe traits while in the tower.

i dunno how easy ritual items are to get but from my experience i dont think anyone has ever even gotten the chance to perform one. either make rituals take less catalysts or make the things easier to get

on the topic of balancing, i think the scrap blade needs a slight adjustment. you can 3 shot any other wanderer (especially with the right beliefs) with it and they're dead. i know slash attacks are supposed to the bread and butter against unarmored opponents but still. maybe it should be more in line with the machete's stats

Make it so that force falling over from exhaustion is only if your hunger, thirst, or sleep is low. Don't have it so you fall over if your blood level is low or if you're diseased. Also, make it so that blood regeneration is faster.

also i think purified water should be rarer or adjust sanity. probably need to adjust survivalist for that.

have blindness permanently enable senses so that u can use a weapon while ur blind
to increase sense range and toggle it yeah but while blind you're fucked with any faith other than that, to use regular shitty senses and have a weapon as non-dark would be cool

an undo button that lasts for maybe 15 seconds to allow you to undo any misclicks in the belief system
disappearing after a little bit of time to prevent just specing in and out of beliefs

make craftable lockpicks via scrap

make survivalist near impossible to have for it's disadvantages
so you don't get anyone who rushes near spawn and kills

Gluttony is free points right now, should be decreased or hunger rate should be faster.

could try introducing more traits that have both positive and negative effects, to spice things up a little bit, adding for a bit more variety when it comes to character creation:
for example, something that'd give you +25 HP and the 'Ironhide' perk off the bat, but at the cost of -25 Stamina and -20% movement speed all around - 'Lethargic', maybe?
--]]

--[[
	10/21/20
	cash - need to redo:
	object physdesc/npc naming commands, backport from old begotten 3 clockwork
	medical system, ez 1 day job ill do that at some point before or after melee test / Schema:GetHealAmount(player, scale)
	Schema:InTower(entity)
	Schema:PlayerGetLocation(player) - we should have a table with positions in the map and a radius value that will be used in here so we can track players around the map
	-- also requires we name every area but might be good for tying in with the pk system, maybe it could display location of death
	
	Schema:GetDexterityTime(player) - i want to replace this with something similar and standardize action times or have some kind of method which multiplies the argument by the player's dexterity modifier, as it stands this plugin just returns 7 if the player has to dexterity points
	-- we also have to do something about tying (which I think is fucked atm)
--]]

--[[
	10/24/20
	- added sanity back in, need to do effects and shit and refine when and why a player's sanity might drop
	- need to do imbicile trait
	- need to add item renaming into the item base, add an ITEM.bNoRenaming
	- item renaming should show up as a submenu when you use the stencil tool (or whatever) which shows you all the items in your inventory, you can then select one and rename it
	- fix condition 
	- finalize item tooltips
--]]

--[[
	11/07/20
	- random pills item, using may give health or some other effect, or poison and kill you
	- need to bring back the old alchemy item base or rewrite it to be integrated with the regular item base
	- better backpacks (items within items)
	- better attachments based on inventory contents
	- tinderboxes, explosive item entities (explode you if you catch on fire with them in your inventory maybe)
	- full junk base with junking/disassembly options
	- simple inventory combination actions
	- spiders
		- "dead spider" item can be found in containers, taking it will have a chance of eggs hatching on you
		- uses chriks spider hallucination and puts them all over your face for a bit (with a sanity drain)
		- maybe you can cook the spider and eat it to nullify the chance of having eggs hatch on you
		- lol spiders
	- meat base (would rather rotting/condition loss handled by another base rather than the item base)
	- sickening/disgust system, ties in with hunger/thirst (vomitting causes massive hunger/thirst gain)
	- rotting meat maybe attracts flies and cockroaches to you, increased chance of plague (when we get around to coding that)
	- human meat extraction (not sure if this is already done, if it is make it better)
	- keyring and random key items
		- random containers around the map should require keys to open and will have higher chance of spawning good loot
		- every time a container is spawned in the map that requires a key a random container somewhere else in the map will gain the key item for that container
		- when a container is removed or invalidated for reasons outside of being opened by a player, that key will get removed also
		- these will probably be separate entities 
	- need a cooking system, can probably get away with jacking it from damnation (hold meat over fire to cook)
	- need to fix equipping items as melee weapons
	- mystery meat item with random chance of ill effects
	- laudanum, ampoule medical items
	- batteries for electronic devices (?)
	- need to port the oil/alchemy base 
	- lanterns
	- water purification
	- container items that get dunked in water should have their remaining capacity fill with water (unless container is sealable)
		- sealable containers should be designated with an item property like ITEM.sealable = true
	- tons of scrap items
	- rare salt item
	- nasty canned items
	- colognes
	- achievement system
	- ported b2 items
	- what would also be good is an OTF item creation system (like Evolution for openaura)
--]]

-- fucked up admin esp
--[[
local playerMeta = FindMetaTable("Player");
local metaClass = playerMeta["MetaBaseClass"];

Clockwork.kernel.ESPItems = {};
Clockwork.kernel.ESPOrder = {};
Clockwork.kernel.ESPBuffer = {};

-- A function to get all ESP items.
function Clockwork.kernel:GetESPItems(buffer)
	if (buffer) then 
		return self.ESPBuffer
	end;
	
	return self.ESPItems;
end;

-- A function to add a toggleable status item to the ESP.
function Clockwork.kernel:AddESPItem(uniqueID, data)
	if (!uniqueID) then
		return;
	else
		uniqueID = string.gsub(string.lower(uniqueID), " ", "_");
	end;

	local name = data.name;
	local var = data.var;
	local max = data.max;
	local color = data.color;
	local default = data.default;
	local bar = data.bar;
	local priority = data.priority;
	local Callback = data.Callback;
	local NameFormat = data.NameFormat;
	local ShowCallback = data.ShowCallback;
	
	local priority = priority or #self.ESPItems + 1;
	local isMethod = false;
	local var = var;
	local originalVar = nil;
	local bar = bar or false;
	
	if (isfunction(var)) then
		isMethod = true;
	elseif (isstring(var)) then
		originalVar = var;
	end;

	if (!isMethod and Clockwork.Client:GetNetVar(var) == nil) then
		if (playerMeta[var]) then
			var = playerMeta[var];
		elseif (metaClass[var]) then
			var = metaClass[var];
		end;
	
		if (isfunction(var)) then
			isMethod = true;
		end;
	end;

	if (isstring(max)) then
		if (Clockwork.Client:GetNetVar(max) == nil) then
			if (playerMeta[max]) then
				max = playerMeta[max];
			elseif (metaClass[max]) then
				max = metaClass[max];
			end;
		end;
	end;
	
	if (isstring(color)) then
		if (Clockwork.Client:GetNetVar(color) == nil) then
			if (playerMeta[color]) then
				color = playerMeta[color];
			elseif (metaClass[color]) then
				color = metaClass[color];
			end;
		end;
	end;
	
	local index = #self.ESPItems + 1;

	self.ESPOrder[uniqueID] = 0;
	self.ESPItems[index] = {
		uniqueID = uniqueID,
		name = name, 
		var = var,
		priority = priority,
		originalVar = originalVar,
		color = color,
		max = max,
		bar = bar,
		default = default,
		Callback = Callback,
		NameFormat = NameFormat,
		hidden = data.hidden,
		ShowCallback = ShowCallback,
	};
	self.ESPBuffer[uniqueID] = self.ESPItems[index];

	if (#self.ESPItems > 1) then
		self:SortESPItems();
	end;
end;

Clockwork.kernel.DisabledESPItems = {};

-- A function to disable an ESP item.
function Clockwork.kernel:DisableESPItem(uniqueID)
	self.DisabledESPItems[uniqueID] = true;
end;

-- A function to enable an ESP item.
function Clockwork.kernel:EnableESPItem(uniqueID)
	self.DisabledESPItems[uniqueID] = false;
end;

-- A function to sort all the ESP items.
function Clockwork.kernel:SortESPItems()
	for k, v in pairs (self.ESPItems) do
		if (self.DisabledESPItems[v.uniqueID]) then
			self.ESPItems[k] = nil;
		end;
	end;
	
	table.sort(self.ESPItems, function(a, b)
		if (a.priority == b.priority) then
			return a.uniqueID:sub(1, 1) < b.uniqueID:sub(1, 1)
		else
			return a.priority < b.priority;
		end;
	end);
		
	table.sort(self.ESPItems, function(a, b)
		if (!a.bar and b.bar) then
			return false
		elseif (a.bar and !b.bar) then
			return true
		end;
	end);
	
	local customOrder = self.ESPOrder;

	table.sort(self.ESPItems, function(a, b)
		if (a.default and b.default) then
			return a.uniqueID:sub(1, 1) < b.uniqueID:sub(1, 1)
		end;			
			
		return false;
	end);
	
	table.sort(self.ESPItems, function(a, b)
		local aOrder = customOrder[a.uniqueID];
		local bOrder = customOrder[b.uniqueID];
		
		if (aOrder == 0 and bOrder != 0) then
			return false;
		elseif (aOrder != 0 and bOrder == 0) then
			return true;
		else
			return aOrder > bOrder
		end;
	end);
	
	table.sort(self.ESPItems, function(a, b)
		if (!a.default and b.default) then
			--return false
		elseif (a.default and !b.default) then
		--	return true
		end;
	end);
end;

-- A function to get the color of a value from green to red.
function Clockwork.kernel:GetValueColor(value, max)
	local max = max or 100;
	local red = math.floor(255 - ((100 * (value / max)) * 2.55));
	local green = math.floor((100 * (value / max)) * 2.55);
		
	return Color(red, green, 0, 255);
end;

-- A function to draw some simple text.
function Clockwork.kernel:DrawSimpleText(text, x, y, color, alignX, alignY, shadowless, shadowDepth)
	local mainTextFont = Clockwork.option:GetFont("main_text")
	local realX = math.Round(x)
	local realY = math.Round(y)

	if (!shadowless) then
		local outlineColor = Color(25, 25, 25, math.min(255, color.a))

		for i = 1, (shadowDepth or 1) do
			draw.SimpleText(text, mainTextFont, realX + -i, realY + -i, outlineColor, alignX, alignY)
			draw.SimpleText(text, mainTextFont, realX + -i, realY + i, outlineColor, alignX, alignY)
			draw.SimpleText(text, mainTextFont, realX + i, realY + -i, outlineColor, alignX, alignY)
			draw.SimpleText(text, mainTextFont, realX + i, realY + i, outlineColor, alignX, alignY)
		end
	end
	
	draw.SimpleText(text, mainTextFont, realX, realY, color, alignX, alignY)
	local width, height = self:GetCachedTextSize(mainTextFont, text)

	return realY + height + 2, width
end


Clockwork.kernel:AddESPItem("health", {
	name = "Health",
	var = "Health",
	max = "GetMaxHealth",
	color = "Health",
	default = true,
	bar = true,
	priority = 0,
});

Clockwork.kernel:AddESPItem("armor", {
	name = "Armor",
	var = "Armor",
	max = "GetMaxArmor",
	color = Color(30, 65, 175),
	default = false,
	bar = true,
	priority = 1,
	ShowCallback = function(self, tab, player)
		if (player:Armor() <= 0) then
			return false;
		end;
	end,
});


Clockwork.kernel:AddESPItem("stamina", {
	name = "Stamina",
	var = "Stamina",
	max = 100,
	color = Color(100, 175, 100),
	default = false,
	bar = true,
	priority = 1,
});


Clockwork.kernel:AddESPItem("sanity", {
	name = "Sanity",
	var = "sanity",
	max = 100,
	color = Color(80, 60, 80),
	default = false,
	bar = true,
	priority = 2,
});


Clockwork.kernel:AddESPItem("blood", {
	name = "Blood",
	var = "Stamina",
	max = 100,
	color = Color(200, 0, 0),
	default = false,
	bar = true,
	priority = 3,
});

Clockwork.kernel:AddESPItem("oxygen", {
	name = "Oxygen",
	var = "oxygen",
	max = 100,
	color = Color(0, 0, 200),
	default = false,
	bar = true,
	priority = 4,
});


Clockwork.kernel:AddESPItem("faith", {
	name = "Faith",
	color = Color(150, 150, 150),
	priority = 5,
	NameFormat = function(self, tab, player)
		local faith = player:GetNetVar("Faith", "N/A");
		local color;
		
		if (!faith) then
			return;
		end;

		if (faith == "Faith of the Family") then
			color = Color(230, 209, 87, 255)
		elseif (faith == "Faith of the Dark") then
			color = Color(163, 153, 143, 255)
		elseif (fatih == "The Glaze") then
			color = Color(230, 209, 87, 255);
		end;
		
		return "Faith: "..faith, color;
	end,
});

Clockwork.kernel:AddESPItem("subfaction", {
	name = "Subfaction",
	color = Color(45, 115, 145),
	priority = 6,
	NameFormat = function(self, tab, player)
		local subfaction = player:GetNetVar("subfaction", "N/A");
			if (!subfaction) then
				return;
			end;
		return "Subfaction: "..subfaction;
	end,
});

Clockwork.kernel:AddESPItem("traits", {
	name = "traits",
	color = Color(255, 0, 0),
	priority = 7,
	hidden = true,
	Callback = function(self, x, y, tab, player, font)
		local displayed = false;

		if (player:HasTrait("marked")) then
			Clockwork.kernel:OverrideMainFont("smawwer")
				y = Clockwork.kernel:DrawSimpleText("*MARKED*", x, y, Color(255, 0, 0), 1, 1, nil, 1) ;
			Clockwork.kernel:OverrideMainFont(false)
			displayed = true;
		end;

		if (player:HasTrait("possessed")) then
			Clockwork.kernel:OverrideMainFont("smawwer")
				y = Clockwork.kernel:DrawSimpleText("*POSSESSED*", x, y, Color(255, 0, 0), 1, 1, nil, 1) ;
			Clockwork.kernel:OverrideMainFont(false)
			displayed = true;
		end;
		
		return y;
	end,
});



Clockwork.kernel:AddESPItem("stability", {
	name = "Stability",
	var = "Stability",
	max = 100,
	color = Color(135, 80, 60),
	bar = true,
	priority = 8,
});

Clockwork.kernel:AddESPItem("poise", {
	name = "Poise",
	var = "meleeStamina",
	max = "maxMeleeStamina",
	color = Color(50, 175, 100),
	bar = true,
	priority = 9,
});



Clockwork.kernel:AddESPItem("weapon", {
	name = "Weapon: N/A",
	color = Color(45, 115, 145),
	priority = 10,
	--hidden = true,
	NameFormat = function(self, tab, player)
		local weapon = player:GetActiveWeapon();

		if (IsValid(weapon)) then
			local name = weapon:GetPrintName();
			local raised = Clockwork.player:GetWeaponRaised(player);
			local color = !raised and Color(240, 240, 240) or Color(255, 0, 0);
			
			return name, color;
		end;
	end,
});


Clockwork.kernel:SortESPItems()

-- A function to get the client's country icon.
function Clockwork.kernel:GetCountryIcon(code)
	if (code == "gmod") then
		return "vgui/titlebaricon"
	end;
	if (!code) then
		local flag = self:IsValidCountry();
		
		if (flag and flag != "") then
			return string.gsub(flag, "materials/", "");
		else
			return "debug/debugempty";
		end;
	else
		local code = string.lower(code);
			if (code == "il") then
				code = "ps";
			end;
		return "flags16/"..string.lower(code)..".png";
	end;
end;

-- A function to get the client's country code.
function Clockwork.kernel:GetCountryCode(player)
	if (!player or player == Clockwork.Client) then
		return string.upper(system.GetCountry())
	else
		local countryCode = player:GetNetVar("CountryCode");
		
		if (!countryCode) then
			countryCode = "GMOD"
		end;
		
		return string.upper(countryCode)
	end;
end;

surface.CreateFont("Pofoffffpy1ff", {
	font		= "Times New Roman",
	size		= Clockwork.kernel:ScaleToWideScreen(19),
	weight		= 100,
	antialiase	= true,
	shadow 		= false,
})

surface.CreateFont("smawwer", {
	font		= "Times New Roman",
	size		= Clockwork.kernel:ScaleToWideScreen(16),
	weight		= 100,
	antialiase	= true,
	shadow 		= false,
})

surface.CreateFont("Fonts", {
	font		= "Times New Roman",
	size		= Clockwork.kernel:ScaleToWideScreen(20),
	weight		= 100,
	antialiase	= true,
	shadow 		= false,
})

local function a(c)
	c.r = 255 - c.r;
		c.g = 255 - c.g;
			c.b = 255 - c.b;
			return c
end;

_SHOWVALUES = false
_MINDISTANCE = 768
_ONLYMINDIST = false
_BASICESPMINDIST = true;
data = nil
_USEALPHA= true;
_KEEPNAMEFLAGOUTDISTANCAR = true;



local cwClient = Clockwork.Client;



			local name, var, max, color = v2.name, v2.var, v2.max, v2.color;
			
			if (var) then
				if (isfunction(var)) then
					var = var(v);
				elseif (isstring(var)) then
					if (v:GetNetVar(var)) then
						var = v:GetNetVar(var);
					elseif (v:GetNWInt(var, false) != false) then
						var = v:GetNWInt(var);
					end;
				end;
			end;
			
			if (isstring(var)) then
				continue;
			end;



			if (v2.Callback) then
				y = v2:Callback(x, y, v2, v, font);
				
				if (y == false) then
					continue;
				end;
			end;
			
			if (v2.hidden) then
				continue;
			end;

			if (v2.NameFormat) then
				local oldColor = color;
				name, color = v2:NameFormat(v2, v);

				if (!color) then
					color = oldColor;
				end;
				
				if (!isstring(name)) then
					continue;
				end;
			end;


local function Readable(c,o)
	local r, g, b = c.r, c.g, c.b;
	local t = r + g + b;
	local f = {r, g, b};
	table.sort(f, function(a, b) return a > b end);
	local l = t/(o or 2)
	local a = l/f[#f]
	return Color(r * a, g * a, b * a);
end;

local function TooDark(c,t)
	local r, g, b = c.r,c.g,c.b
	if ((r+g+b) <= t) then
		return true;
	end;
	return false;
end;

Clockwork.kernel.espCache = nil
Clockwork.kernel.espData = nil
local font = "Fonts";
local smallFont = "smawwer";
_CACHETIME = 0.2;

local ITEMSaa = {
	
}

for k, v in pairs (Clockwork.kernel.ESPItems) do
	local uniqueID = v.uniqueID;
	ITEMSaa[uniqueID] = true;
end;

function Clockwork.kernel:DrawAdminESP()
	local curTime = CurTime();
	local disabledESPItems = self.DisabledESPItems;
	
	if (!self.espData) then
		self.espData = {};
	end;
		
	if (!self.nextRefresh or self.nextRefresh <= curTime) then
		self.nextRefresh = curTime + _CACHETIME;

		local espItems = self.ESPItems;
		local playerCount = _player.GetCount();
		local players = _player.GetAll();
		
		for i = 1, playerCount do
			local player = players[i];
			
			if (player == cwClient or !player:IsBot() or !player:HasInitialized()) then
				continue;
			end;
			
			if (!self.espData[player]) then
				self.espData[player] = {};
			end;
			
			local key = player:GetNetVar("Key", 0);
			local didChangeCharacters = false;

			if (!self.espData[player].Key) then
				didChangeCharacters = true;
				self.espData[player].Key = key;
			elseif (self.espData[player].Key != key) then
				didChangeCharacters = true;
			end;

			if (didChangeCharacters) then
				local countryCode = Clockwork.kernel:GetCountryCode(player);
				local countryIcon = Material(Clockwork.kernel:GetCountryIcon(countryCode));
				local chatIcon = Material(player:GetChatIcon());
				local name = player:Name();
				local steamName = player:SteamName();
				local steamNameWidth, steamNameHeight = GetFontWidth(smallFont, steamName), GetFontHeight(smallFont, steamName);
				local nameWidth, nameHeight = GetFontWidth(font, name), GetFontHeight(font, name);
				local nameColor = self:PlayerNameColor(player);
				
				self.espData[player].info = {
					infoTable = true,
					countryIcon = countryIcon,
					chatIcon = chatIcon,
					steamName = steamName,
					steamNameWidth = steamNameWidth,
					steamNameHeight = steamNameHeight,
					name = name,
					nameWidth = nameWidth,
					nameHeight = nameHeight,
					nameColor = nameColor,
				};
			end;

			for k = 1, #espItems do
				local item = espItems[k];
				local uniqueID = item.uniqueID;
				
				if (!uniqueID or disabledESPItems[uniqueID]) then
					continue;
				end;
				
				local name = item.name;
				local var = item.var;
				local max = item.max;
				local color = item.color;

				if (var) then
					if (isfunction(var)) then
						var = var(player);
					elseif (isstring(var)) then
						if (player:GetNetVar(var)) then
							var = player:GetNetVar(var);
						elseif (player:GetNWInt(var, false) != false) then
							var = player:GetNWInt(var);
						end;
					end;
				end;
				
				if (isstring(var)) then
					continue;
				end;
				
				if (color and isfunction(color)) then
					color = self:GetValueColor(color(player));
				end;
				
				if (max) then
					if (isfunction(max)) then
						max = max(player);
					elseif (isstring(max)) then
						if (player:GetNetVar(max)) then
							max = player:GetNetVar(max);
						elseif (player:GetNWInt(max, false) != false) then
							max = player:GetNWInt(max);
						end;
					end;
				end;

				self.espData[player][uniqueID] = {
					isItem = true;
					bar = item.bar,
					color = color,
					max = max,
					var = var,
					uniqueID = uniqueID,
					name = name,
					hidden = item.hidden,
				};
			end;
		end;
	end;

	if (!self.cwBarFontHeight) then
		self.cwBarFontHeight = GetFontHeight(smallFont, "Cunt");
	end;

	for k, v in pairs (self.espData) do
		local player = k;
		local alive = player:Alive();
		local position = player:GetPos() + Vector(0, 0, 78);
		local screenPosition = position:ToScreen();
		local x, y = screenPosition.x, screenPosition.y;

		if (v.info) then
			local infoTable = v.info;
			local name = infoTable.name;
			local steamName = infoTable.steamName;
			local nameColor = infoTable.nameColor;
			local steamNameWidth = infoTable.steamNameWidth;
			local countryIcon = infoTable.countryIcon;
			
			if (!alive) then
				name = name.." [DEAD]";
			end;
			
			self:OverrideMainFont(font);
				y = self:DrawSimpleText(name, x, y, nameColor, 1, 1, nil, 1) - 2;
			self:OverrideMainFont(false);
			
			local iconWidth, iconHeight = 16, 9;
			local posX = x - ((steamNameWidth / 2) + (iconWidth + 2) + 2);
			local posY = y - (iconHeight / 2) + 1;
			
			self:OverrideMainFont(smallFont)
				y = self:DrawSimpleText(steamName, x, y, Color(150, 150, 150), 1, 1, nil, 1) + 4;
			self:OverrideMainFont(false)

			if (player:IsAdmin()) then
				countryIcon = infoTable.chatIcon;
			end;
			
			surface.SetDrawColor(255, 255, 255);
			surface.SetMaterial(countryIcon);
			surface.DrawTexturedRect(posX, posY, iconWidth, iconHeight);
		end;
		
		if (!alive) then
			continue;
		end;

		local barWidth, barHeight, halfWidth, halfHeight = 100, (self.cwBarFontHeight * 0.75), 50, (self.cwBarFontHeight / 2);
		
		for k2, v2 in pairs (ITEMSaa) do
			local uniqueID = k2;
			
			if (!v[uniqueID] or disabledESPItems[uniqueID]) then
				continue;
			end;
			
			local statusTable = v[uniqueID];

			if (statusTable.hidden) then
				continue;
			end;

			local var = statusTable.var;
			local max = statusTable.max;
			local name = statusTable.name;
			local color = statusTable.color;
			
			if (statusTable.bar) then
				local progress = math.floor(math.Clamp((barWidth * (var / max)), 0, barWidth));

				if (progress <= 0) then
					if (!_SHOWZERO) then
						continue
					end;
					
					progress = 0;
				end;

				draw.RoundedBox(0, x - halfWidth, y - halfHeight, barWidth, barHeight + 4, Color(40, 40, 40, 255));
				draw.RoundedBox(0, x - (halfWidth - 1), y - halfHeight + 1, progress - 2, barHeight + 2, Color(color.r + 20, color.g + 20, color.b + 20, 200));
				draw.RoundedBox(0, x - (halfWidth - 3), y - halfHeight + 1, progress - 4, barHeight + 1, Color(color.r + 10, color.g + 10, color.b + 10, 200));
				draw.RoundedBox(0, x - (halfWidth - 3), y - halfHeight + 2, progress - 5, barHeight, color);

				self:OverrideMainFont(smallFont);
					y = self:DrawSimpleText(name, x, y, Color(255, 255, 255, 255), 1, 1, nil, 1);
				self:OverrideMainFont(false);
			end;
		end;

	end;
	
	
			local playerData = data[v];

		local steamName = v:SteamName();
		local nameAlpha = 255;
		local icon = playerData.icon.country;
		local nameColor = self:PlayerNameColor(v);

		local iconWidth, iconHeight = 16, 9;
		local disabledESPItems = self.DisabledESPItems;
		local barWidth = 100;
		local barHeight = height / 2;
		local halfBarWidth = (barWidth / 2);
		local halfBarHeight = (barHeight / 2);
		local sideAlpha = (alpha - 55);
		local halfAlpha = (alpha / 2);
	
	
	
		
		local player = k;
		local name = player:Name();
		local steamName = player:SteamName() or name;
		local font = "Fonts";
		local smallFont = "smawwer";
		
		local position = position:ToScreen();
		local x, y = position.x, position.y;
		
		local nameColor = 
		



		
	--end;
	
	
	for k, v in pairs (_player.GetAll()) do
		local p = v:GetPos() + Vector(0, 0, 78);
		local ts = p:ToScreen();
		draw.SimpleText(v:Name(), "DermaDefaultBold", ts.x, ts.y, Color(255, 255, 0), 1, 1)
	end;
	
	--
	
	

	local clientPosition = Clockwork.Client:GetPos();
	local tooFar = {};
	local players = ;
	
	if (!data) then
		data = {};
	end;
	
	local frameTime = FrameTime();
	
	for i = 1, _player.GetCount() do
		
		
		if (v == Clockwork.Client) then
		--	continue;
		end;

		local position = v:GetPos();
		
		if (_ONLYMINDIST) then
			if (position:DistToSqr(clientPosition) > (_MINDISTANCE * _MINDISTANCE)) then
				if (_BASICESPMINDIST) then
					tooFar[v] = v;
				else
					continue;
				end;
			end;
		end;
		
		local physBone = v:LookupBone("ValveBiped.Bip01_Head1");
		local name = v:Name()
		
		if (physBone) then
			local bonePosition = v:GetBonePosition(physBone);
			
			if (bonePosition) then
				position = bonePosition + Vector(0, 0, 16);
			end;
		else
			position = position + Vector(0, 0, 80);
		end;--var
		
		local alpha = 255;
		
		if (_USEALPHA) then
			if (!data[v]) then
				data[v] = {};
			end;
			
			local playerData = data[v];

			if (!playerData.alpha or !playerData.alphaTarget) then
				playerData.alpha = 0;
				playerData.alphaTarget = 255;
			end;

			if (tooFar[v]) then
				playerData.alphaTarget = 0;
			else
				playerData.alphaTarget = 255;
			end;
			
			if (playerData.alpha != playerData.alphaTarget) then
				playerData.alpha = math.Approach(playerData.alpha, playerData.alphaTarget, frameTime * 256);
			end;
			
			alpha = playerData.alpha;
		end;

		if (alpha <= 0 and !_KEEPNAMEFLAGOUTDISTANCAR) then
			continue;
		end;
		
		if (!data[v].icon) then
			data[v].icon = {};
			data[v].icon.country = Clockwork.kernel:GetCountryIcon(Clockwork.kernel:GetCountryCode(v));
			data[v].icon.chat = v:GetChatIcon();
		end;
		
		local playerData = data[v];
		local font = "Fonts";
		local smallFont = "smawwer";
		local steamName = v:SteamName();
		local nameAlpha = 255;
		local icon = playerData.icon.country;
		local width, height = GetFontWidth(font, name), GetFontHeight(font, name);
		local widthSmall, heightSmall = GetFontWidth(smallFont, steamName), GetFontHeight(smallFont, steamName);
		local nameColor = self:PlayerNameColor(v);
		local position = position:ToScreen();
		local x, y = position.x, position.y;
		local iconWidth, iconHeight = 16, 9;
		local disabledESPItems = self.DisabledESPItems;
		local barWidth = 100;
		local barHeight = height / 2;
		local halfBarWidth = (barWidth / 2);
		local halfBarHeight = (barHeight / 2);
		local sideAlpha = (alpha - 55);
		local halfAlpha = (alpha / 2);
		
		if (Clockwork.player:IsAdmin(v)) then
			icon = playerData.icon.chat;
			iconWidth, iconHeight = 16, 16
		end;

		if (!_KEEPNAMEFLAGOUTDISTANCAR) then
			nameAlpha = alpha;
		end;
		
		self:OverrideMainFont(font)
			y = self:DrawSimpleText(name, x, y, Color(nameColor.r, nameColor.g, nameColor.b, nameAlpha), 1, 1, nil, 1) - 2
		self:OverrideMainFont(false)
		
		local posX = x - ((widthSmall / 2) + (iconWidth + 2) + 2);
		local posY = y - (iconHeight / 2) + 1;
		
		self:OverrideMainFont("smawwer")
			y = self:DrawSimpleText(v:SteamName(), x, y, Color(150, 150, 150, nameAlpha), 1, 1, nil, 1)
		self:OverrideMainFont(false)
		
		surface.SetDrawColor(255, 255, 255, nameAlpha);
		surface.SetMaterial(Material(icon));
		surface.DrawTexturedRect(posX, posY, iconWidth, iconHeight);

		for k2, v2 in ipairs (self.ESPItems) do
			if (alpha <= 0) then
				break;
			end;
			if (v2.ShowCallback) then
				if (v2:ShowCallback(v2, v) == false) then
					continue;
				end;
			end;
			if (v2.Callback) then
				y = v2:Callback(x, y, v2, v, font);
				
				if (y == false) then
					continue;
				end;
			end;
			


			if (v2.NameFormat) then
				local oldColor = color;
				name, color = v2:NameFormat(v2, v);

				if (!color) then
					color = oldColor;
				end;
				
				if (!isstring(name)) then
					continue;
				end;
			end;

			color.a = alpha;

			if (v2.bar and var) then
				local progress = math.floor(math.Clamp((barWidth * (var / max)), 0, barWidth));
				local oY = y;
				
				if (progress < 0) then
					progress = 0;
				end;
				
				if (_SHOWVALUES) then
					name = name..": ["..var.."/"..max.."]";
				end;
				
				draw.RoundedBox(0, x - halfBarWidth, y - halfBarHeight, barWidth, barHeight + 4, Color(40, 40, 40, alpha));
				draw.RoundedBox(0, x - (halfBarWidth - 1), y - halfBarHeight + 1, progress - 2, barHeight + 2, Color(color.r + 20, color.g + 20, color.b + 20, sideAlpha));
				draw.RoundedBox(0, x - (halfBarWidth - 3), y - halfBarHeight + 1, progress - 4, barHeight + 1, Color(color.r + 10, color.g + 10, color.b + 10, sideAlpha));
				draw.RoundedBox(0, x - (halfBarWidth - 3), y - halfBarHeight + 2, progress - 5, barHeight, color);

				self:OverrideMainFont("smawwer")
					self:DrawSimpleText(name, x - 1, y + 1, Color(0, 0, 0, halfAlpha), 1, 1, nil, 1);
					y = self:DrawSimpleText(name, x, y + 1, v2.textColor or Color(255, 255, 255, alpha), 1, 1, nil, 1) - 2;
				self:OverrideMainFont(false)
				
				if (v2.icon) then
					local icon = v2.icon;
					local iconWidth = height;
					local iconHeight = height;
					local posX = x - 48 - (iconWidth + 2);
					local posY = oY - (iconHeight / 2) + 1;
					
					surface.SetDrawColor(255, 255, 255, alpha);
					surface.SetMaterial(Clockwork.kernel:GetMaterial(icon));
					surface.DrawTexturedRect(posX, posY, iconWidth, iconHeight);
				end;
			else
				if (var and max) then
					name = name..": ["..var.."/"..max.."]"
				end;
				
				local oY = y;
				
				self:OverrideMainFont("smawwer")
					self:DrawSimpleText(name, x - 1, y + 1, Color(0, 0, 0, halfAlpha), 1, 1, nil, 1);
					y = self:DrawSimpleText(name, x, y + 1, v2.textColor or color, 1, 1, nil, 1);
				self:OverrideMainFont(false)
				
				if (v2.icon) then
					local icon = v2.icon;
					local iconWidth = height;
					local iconHeight = height;
					local posX = x - 48 - (iconWidth + 2);
					local posY = oY - (iconHeight / 2) + 1;
					
					surface.SetDrawColor(255, 255, 255, alpha);
					surface.SetMaterial(Clockwork.kernel:GetMaterial(icon));
					surface.DrawTexturedRect(posX, posY, iconWidth, iconHeight);
				end;
			end;
		end;
	end;
end;




	for k, v in pairs(self.ESPInfo) do
		local position = v.position:ToScreen();
		local text, color, height;
		
		if (isnumber(v.text)) then
			v.text = tostring(v.text)
		end;

		if (position) then
			if (type(v.text) == "string") then
				self:DrawSimpleText(v.text, position.x, position.y, v.color or colorWhite, 1, 1);
			else
				for k2, v2 in ipairs(v.text) do	
					local barValue;
					local maximum = 100;
					
					if (type(v2) == "string") then
						text = v2;
						color = v.color;
					else
						text = v2.text;
						color = v2.color;
							local barNumbers = v2.bar;
							if (type(barNumbers) == "table") then
							barValue = barNumbers.value;
							maximum = barNumbers.max;
							
							if barValue > maximum then
								barValue = maximum;
							end
						else
							barValue = barNumbers;
						end;
					end;
					
					local font = "TargetIDSmall"

					if (k2 > 1) then
						self:OverrideMainFont(font);
						height = draw.GetFontHeight(font);
					else
						self:OverrideMainFont(false);
						height = draw.GetFontHeight(Clockwork.option:GetFont("main_text"));
					end;
					
					if (v2.icon) then
						local icon = "icon16/exclamation.png";
						local width = surface.GetTextSize(text);
						local iconWidth = height;
						local iconHeight = height;
						local posX = position.x - (width * 0.40) - height
						local posY = position.y - height * 0.5;
							if (type(v2.icon == "string") and v2.icon != "") then
							icon = v2.icon;
						end;
						
						if (string.find(icon, "flags")) then
							iconWidth = height * 1.5;
							iconHeight = iconHeight - 2;
							posX = posX - (width / 6);
							posY = posY + 2;
						end;
							surface.SetDrawColor(255, 255, 255, 255);
						surface.SetMaterial(Clockwork.kernel:GetMaterial(icon));
						surface.DrawTexturedRect(posX, posY, iconWidth, iconHeight);
					end;
					
					if (barValue) then
						local barHeight = height * 0.80 + 2;
						local barColor = v2.barColor or self:GetValueColor(barValue);
						local grayColor = Color(10, 10, 10, 170);
						local progress = 100 * (barValue / maximum);
							if progress < 0 then
							progress = 0;
						end;
						
						draw.RoundedBox(0, position.x - 50 - 1, position.y - (barHeight * 0.45) - 1, math.floor(progress) + 2, barHeight + 4, Color(90, 90, 90));
						draw.RoundedBox(0, position.x - 50, position.y - (barHeight * 0.45), 100, barHeight + 2, grayColor);
						draw.RoundedBox(0, position.x - 50, position.y - (barHeight * 0.45), math.floor(progress), barHeight + 2, barColor);
					end;
					if (type(text) == "string") then
						self:DrawSimpleText(text, position.x, position.y, color or colorWhite, 1, 1);
					end;

						position.y = position.y + height + 4;
					end;
				end;			
			end;
		end;
--]]