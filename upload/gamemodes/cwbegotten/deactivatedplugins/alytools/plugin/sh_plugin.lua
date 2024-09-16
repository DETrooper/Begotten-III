--[[
	Script written by Aly for Begotten III: Jesus Wept
	Unauthorized tampering will result in immediate corpsing
--]]

--[[
	A plugin for providing various tools, commands and mechanics for messing with people.
	The "loyalty" system here is to encourage people to form groups around themselves and secret allegiances.
	It also serves to provide higher leveled characters with more value to others, possibly encouraging using skilled
	characteras as slaves rather than corpsing them on the spot.
--]]

PLUGIN:SetGlobalAlias("cwAlyTools");

Clockwork.kernel:IncludePrefixed("cl_hooks.lua");
Clockwork.kernel:IncludePrefixed("sv_plugin.lua");
Clockwork.kernel:IncludePrefixed("sv_hooks.lua");

local playerMeta = FindMetaTable("Player")

-- Teleport a player with a visual effect.
function playerMeta:Teleport(originpos, targetpos)
	util.BlastDamage( self, self, targetpos, 32, 99999 )
	local effectData = EffectData()
	effectData:SetScale(1)
	effectData:SetOrigin(self:GetPos())
	effectData:SetMagnitude(1)
	self:ScreenFade( SCREENFADE.OUT, Color(20,255,0), 0.5, 0.1 )
	timer.Simple( 0.5, function() 
		if self:IsRagdolled() then
			ragd = self:GetRagdollEntity()
			ragd:SetPos(targetpos)
		else
			self:SetPos(targetpos)
		end
		self:ScreenFade( SCREENFADE.IN, Color(20,255,0), 1, 0 ) 
	end )
	util.Effect("camera_flash", effectData, true, true)
	util.Effect("ThumperDust", effectData, true, true)
	--util.Effect("VortDispel", effectData, true, true)
	local effectData2 = EffectData()
	effectData2:SetScale(1)
	effectData2:SetOrigin(targetpos)
	effectData2:SetMagnitude(1)
	self:EmitSound( "ambient/levels/citadel/weapon_disintegrate3.wav")
	util.Effect("camera_flash", effectData2, true, true)
	util.Effect("ThumperDust", effectData2, true, true)
	--util.Effect("VortDispel", effectData2, true, true)
end

-- Teleport a player with a visual effect. This is for shitty broken peasant teleporters.
function playerMeta:ShitTeleport(originpos, targetpos)
	util.BlastDamage( self, self, targetpos, 32, 99999 )
	local effectData = EffectData()
	effectData:SetScale(1)
	effectData:SetOrigin(self:GetPos())
	effectData:SetMagnitude(1)
	local helldrill = self:StartLoopingSound( "hl1/ambience/alien_minddrill.wav" )
	self:ScreenFade( SCREENFADE.OUT, Color(255,0,0), 0.5, 3.5 )
	self:Lock();
	self:SetNoDraw( true )
	self:SetPos(Vector(math.random(-600,600),math.random(-600,600),2000))
	timer.Simple( 4, function() 
		if self:IsRagdolled() then
			ragd = self:GetRagdollEntity()
			ragd:SetPos(targetpos)
		end
		self:StopLoopingSound( helldrill )
		self:SetPos(targetpos)
		self:UnLock();
		self:SetNoDraw( false )
		local canTeleport = false;
		if canTeleport then
			self:ScreenFade( SCREENFADE.IN, Color(255,0,0), 3, 0 ) 
		else
			self:ScreenFade( SCREENFADE.IN, Color(255,0,0), 30, 0 ) 
		end
		self:ScreenFade( SCREENFADE.IN, Color(255,0,0), 30, 0 ) 
		self:EmitSound( "ambient/energy/zap9.wav")
		
	end )
	util.Effect("camera_flash", effectData, true, true)
	util.Effect("ThumperDust", effectData, true, true)
	--util.Effect("VortDispel", effectData, true, true)
	local effectData2 = EffectData()
	effectData2:SetScale(1)
	effectData2:SetOrigin(targetpos)
	effectData2:SetMagnitude(1)
	self:EmitSound( "ambient/energy/zap9.wav")
	util.Effect("camera_flash", effectData2, true, true)
	util.Effect("ThumperDust", effectData2, true, true)
	--util.Effect("VortDispel", effectData2, true, true)
end

-- Teleport a player with a visual effect. This is for shitty broken peasant teleporters.
function cwAlyTools:Vaporize(entity)
	entity.isBeingVaporized = entity.isBeingVaporized or false
	if not entity.isBeingVaporized then
		target = entity;
		if entity:IsPlayer() then
			entity:Kill();
			if (entity:GetRagdollEntity()) then
				target = entity:GetRagdollEntity()
				timer.Simple( 1, function() 
					if target:IsValid() then
						target:SetMoveType(MOVETYPE_FLYGRAVITY)
						target:SetGravity( -0.01 )
					end;
				end )
			end;
		end
		target:EmitSound("ambient/levels/citadel/weapon_disintegrate2.wav")
		entity.isBeingVaporized = true
		target:SetMaterial("models/alyx/emptool_glow")
		target:SetMoveType(MOVETYPE_FLYGRAVITY)
		target:SetGravity( -0.01 )
		timer.Simple( 3, function() 
			if target:IsValid() then
				entity.isBeingVaporized = false
				target:Remove()
			end;
		end )
	end
end

function cwAlyTools:Transport(entity, originpos, targetpos, silent)
	local physobj = entity:GetPhysicsObject()
	local velocity = Vector(0,0,0)
	local silent = silent or false;
	if (SERVER) then
		velocity = physobj:GetVelocity()
	end
	util.BlastDamage( entity, entity, targetpos, 20, 99999 )
	if IsValid(entity.cwHoldingGrab) then
		if IsValid(entity.cwHoldingGrab.cwPlayer) then
			if entity.cwHoldingGrab.cwPlayer:IsPlayer() then
				entity.cwHoldingGrab.cwPlayer:Teleport(originpos, targetpos)
			end
		end		
	end
	local effectData = EffectData()
	effectData:SetScale(1)
	if not (silent) then
		entity:SetNoDraw( true )
	end
	effectData:SetOrigin(entity:GetPos())
	effectData:SetMagnitude(1)
	timer.Simple( 2, function() 
		entity:SetPos(targetpos)
		if not (silent) then
			entity:SetNoDraw( false )
		end
		physobj:SetVelocity( velocity )
	end )
	if not (silent) then
		util.Effect("camera_flash", effectData, true, true)
		util.Effect("ThumperDust", effectData, true, true)
		--util.Effect("VortDispel", effectData, true, true)
		local effectData2 = EffectData()
		effectData2:SetScale(1)
		effectData2:SetOrigin(targetpos)
		effectData2:SetMagnitude(1)
		entity:EmitSound( "ambient/levels/citadel/weapon_disintegrate3.wav")
		util.Effect("camera_flash", effectData2, true, true)
		util.Effect("ThumperDust", effectData2, true, true)
		--util.Effect("VortDispel", effectData2, true, true)
	end
end

function cwAlyTools:FuckedTransport(entity, originpos, targetpos, silent)
	local physobj = entity:GetPhysicsObject()
	local velocity = Vector(0,0,0)
	local silent = silent or false;
	if (SERVER) then
		velocity = physobj:GetVelocity()
	end
	util.BlastDamage( entity, entity, targetpos, 20, 99999 )
	if IsValid(entity.cwHoldingGrab) then
		if IsValid(entity.cwHoldingGrab.cwPlayer) then
			if entity.cwHoldingGrab.cwPlayer:IsPlayer() then
				entity.cwHoldingGrab.cwPlayer:ShitTeleport(originpos, targetpos)
			end
		end		
	end
	local effectData = EffectData()
	effectData:SetScale(1)
	if not (silent) then
		entity:SetNoDraw( true )
	end
	effectData:SetOrigin(entity:GetPos())
	effectData:SetMagnitude(1)
	timer.Simple( 2, function() 
		entity:SetPos(targetpos)
		if not (silent) then
			entity:SetNoDraw( false )
		end
		physobj:SetVelocity( velocity )
	end )
	if not (silent) then
		util.Effect("camera_flash", effectData, true, true)
		util.Effect("ThumperDust", effectData, true, true)
		local effectData2 = EffectData()
		effectData2:SetScale(1)
		effectData2:SetOrigin(targetpos)
		effectData2:SetMagnitude(1)
		entity:EmitSound( "ambient/energy/zap9.wav")
		util.Effect("camera_flash", effectData2, true, true)
		util.Effect("ThumperDust", effectData2, true, true)
	end
end

-- Generate and update a score for a character based on the number of and level of players pledged to them, and a list of those players.
function playerMeta:CalcLoyaltyScore()
	local pledges = {};
	local points = 0;
	local charKey = self:GetCharacterKey();
	local charLoyal = self:GetCharacterData("loyaltochar", "none")
	
	for _, v in _player.Iterator() do
		if v:HasInitialized() and v:Alive() then
			local tgtLoyal = v:GetCharacterData("loyaltochar", "none")
			local tgtLevel = v:GetCharacterData("level", 1);
			local tgtKey = v:GetCharacterKey()
			if charLoyal == tgtKey then
				v:CalcLoyaltyScore()
			end
			if tgtLoyal == charKey then
				local scoretoadd = math.ceil(tgtLevel/4)/10
				points = points + scoretoadd
				local chara = {
					name = v:Name(),
					score = scoretoadd
				}
				table.insert(pledges, chara);
			end
		end
	end
	self:SetNetVar("loyaltypoints", points);
	local max_stamina = self:GetMaxStamina();
	local max_stability = self:GetMaxStability();
	local max_health = self:GetMaxHealth();
	self:SetLocalVar("maxStability", max_stability);
	--self:SetLocalVar("maxMeleeStamina", max_poise);
	self:SetLocalVar("Max_Stamina", max_stamina);
	self:SetCharacterData("Max_Stamina", max_stamina);
	return {total=points,people=pledges}
end


--Should be obvious
local COMMAND = Clockwork.command:New("CharSetLoyalty");
COMMAND.tip = "Set your loyalty to another character, empowering them slightly.";
COMMAND.access = "s";
COMMAND.alias = {"Loyalty","SetLoyal","Pledge","SetLoyalty"};

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);
	if IsValid(target) then
		if target:HasInitialized() and target:Alive() and (target ~= player) then
			local key = target:GetCharacterKey()
			local plykey = player:GetCharacterKey()
			if Clockwork.player:DoesRecognise(player, target) and key then
				if (key ~= plykey) then
					-- Make sure people can't set themselves to be loyal to each other. There can be only one.
					if (target:GetCharacterData("loyaltochar", "none") ~= plykey) then
						player:SetCharacterData("loyaltochar", key);
						Clockwork.player:Notify(player, "You have pledged your loyalty to "..target:Name().."!");
						Clockwork.player:Notify(target, player:Name().." has pledged their loyalty to you!");
					else
						Clockwork.player:Notify(player, "This person is already loyal to you!");
					end
				else
					Clockwork.player:Notify(player, "Being loyal to yourself is a good trait, but not applicable in this case.");
				end
			else
				Clockwork.player:Notify(player, "You don't know this person!");
			end
		else
			Clockwork.player:Notify(player, "Invalid argument!");
		end
	end
end;

COMMAND:Register();

--Should be obvious
local COMMAND = Clockwork.command:New("CharClearLoyalty");
COMMAND.tip = "Set your loyalty to another character, empowering them slightly.";
COMMAND.access = "s";
COMMAND.alias = {"LoyaltyClear","UnSetLoyal","ClearLoyal","ResetLoyalty","ClearLoyalty"};

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);
	if IsValid(target) then
		if target:HasInitialized() and target:Alive() and (target ~= player) then
			local key = target:GetCharacterKey()
			local plykey = player:GetCharacterKey()
			if Clockwork.player:DoesRecognise(player, target) and key then
				if (key ~= plykey) then
					-- Make sure people can't set themselves to be loyal to each other. There can be only one.
					if (target:GetCharacterData("loyaltochar", "none") ~= plykey) then
						player:SetCharacterData("loyaltochar", key);
						Clockwork.player:Notify(player, "You have pledged your loyalty to "..target:Name().."!");
						Clockwork.player:Notify(target, player:Name().." has pledged their loyalty to you!");
					else
						Clockwork.player:Notify(player, "This person is already loyal to you!");
					end
				else
					Clockwork.player:Notify(player, "Being loyal to yourself is a good trait, but not applicable in this case.");
				end
			else
				Clockwork.player:Notify(player, "You don't know this person!");
			end
		else
			Clockwork.player:Notify(player, "Invalid argument!");
		end
	end
end;

COMMAND:Register();

--This command updates your score, shows your score, and lists the people who have set themselves as loyal to you.
local COMMAND = Clockwork.command:New("CharGetLoyalty");
COMMAND.tip = "See information on those who have pledged themselves to you or who you have pledged to.";
COMMAND.access = "s";
COMMAND.alias = {"CheckLoyalty","MyLoyalty","CharLoyalty","LoyaltyList","ListLoyalty"};

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local loyalscore = player:CalcLoyaltyScore()
	if loyalscore.total > 0 then
		if #loyalscore.people > 1 then
			Clockwork.player:Notify(player, "Only one person has pledged to you.");
		else
			Clockwork.player:Notify(player, #loyalscore.people.." people have pledged their loyalty to you.");
		end
		for k, v in pairs(loyalscore.people) do
			Clockwork.player:Notify(player, v.name..", worth "..v.score.."%.");
		end
		Clockwork.player:Notify(player, "Total loyalty boosts: "..loyalscore.total.."%.");
	else
		Clockwork.player:Notify(player, "Nobody has seen you worthy of pledging their allegiance.");
	end
end;

COMMAND:Register();


local COMMAND = Clockwork.command:New("CharSkyDrop");
COMMAND.tip = "Spawn an object above the head of the fucklet of your choice. Will try to spawn as high up as possible, works best in open areas. The last arguments can be a list of items, including 'cash'/'coins' for a random amount of money, and 'random' for generated loot. You can also add X[num] to the end of an ID to define the number. For example: papa_petes_ice_cold_popX24 will add 24 bottles of delicious Papa Pete's® Ice Cold Pop™!";
COMMAND.text = "<string Name> <string Model> [num CleanupTimeInSeconds] [bool Burning] [Loot ItemIDs or Random or Cash/Coins]";
COMMAND.access = "s";
COMMAND.arguments = 2;
COMMAND.alias = {"DropProp","SkyDrop","DropObject","ObjDrop"};

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);
	local dist = 4000
	local cleanuptime = tonumber(arguments[3]) or 60
	local burning = arguments[4] or "false"
	burning = string.lower(burning) == "true"
	local loot = arguments[5] or "false"
	if (target) then
		model = arguments[2] or "models/props_debris/concrete_cynderblock001.mdl"
		if !IsUselessModel(model) then
			local tgtpos = target:GetPos()
			local spawnpoint = tgtpos + Vector(0, 0, dist)
			local trace = util.TraceLine({
				endpos = spawnpoint,
				filter = target,
				start = tgtpos,
				mask = CONTENTS_SOLID + CONTENTS_MOVEABLE + CONTENTS_OPAQUE + CONTENTS_DEBRIS + CONTENTS_HITBOX + CONTENTS_MONSTER
			})
			
			
			if trace.HitWorld then
			   spawnpoint = trace.HitPos + Vector(0, 0, -32)
			end
			dropped=ents.Create("prop_physics")
			dropped:SetModel(arguments[2])
			dropped:SetPos(spawnpoint)
			dropped:Spawn()
			if burning then
				dropped:Ignite(cleanuptime,32)
			end
			dist = tgtpos:Distance( spawnpoint )

			Clockwork.player:Notify(player, "Spawned a prop ["..model.."] "..(dist*0.01905).." meters above "..target:Name()..".");
			timer.Create("SkyDrop"..target:Name()..""..math.Round(CurTime()), cleanuptime, 1, function()
				if IsValid(dropped) then
					dropped:Remove();
				else
					Clockwork.player:Notify(player, "Could not find the recently spawned object: ["..model.."] for cleanup. It might already be removed, or in need of manual cleanup.");
				end
			end);
			
			if loot ~= "false" then
				local itemcount = 0
				dropped.cwInventory = {};
				dropped.cwCash = 0;
				for i=5, #arguments do
					if arguments[i] then
						if arguments[i] == string.lower("random") then
							local itemIncrease = math.random(4, 8);
							for i = 1, math.random(3 + itemIncrease, 6 + itemIncrease) do
								local randomItem = cwItemSpawner:SelectItem(containerCategory, false, true);
								
								if randomItem then
									local itemInstance = Clockwork.item:CreateInstance(randomItem);
									
									if itemInstance then
										local category = itemInstance.category;
										
										if category == "Helms" or category == "Armor" or category == "Melee" or category == "Crafting Materials" then
											-- 75% chance for these items to spawn with less than 100% condition.
											if math.random(1, 4) ~= 1 then
												itemInstance:TakeCondition(math.random(0, 75));
											end
										elseif itemInstance.category == "Shot" and itemInstance.ammoMagazineSize and itemInstance.SetAmmoMagazine then
											itemInstance:SetAmmoMagazine(math.random(1, itemInstance.ammoMagazineSize));
										end
										
										Clockwork.inventory:AddInstance(dropped.cwInventory, itemInstance, 1);
										itemcount = itemcount + 1
									end
								end
							end
							dropped.cwCash = (dropped.cwCash+math.random(10, 50)) or math.random(10, 50);
							if math.random(1, 5) == 1 then
								dropped.cwCash = math.random(50, 100);
							end
						elseif arguments[i] == string.lower("coins") or arguments[i] == string.lower("cash") then
							dropped.cwCash = (dropped.cwCash+math.random(10, 50)) or math.random(10, 50);
						else
							local instr = arguments[i]
							local multiX = string.find(instr, "X")
							local numberof = 1
							if multiX then
								numberof = tonumber(string.sub( instr, multiX+1, -1 )) or 1
								instr = string.sub( instr, 1, multiX-1 )
							end
							local theitem = Clockwork.item:CreateInstance(instr);
							if theitem then
								Clockwork.inventory:AddInstance(dropped.cwInventory, theitem, numberof)
								Clockwork.player:Notify(player, "Added: "..theitem.name.." x"..numberof);
								itemcount = itemcount + 1
							else
								Clockwork.player:Notify(player, instr.." not found.");
							end
						end
					end
				end
				Clockwork.player:Notify(player, "Added "..itemcount.." items and "..dropped.cwCash.." coins to the object's inventory.");
			end
		else
			Clockwork.player:Notify(player, arguments[2].." is not a valid model!");
		end
	else
		Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
	end;
end;

COMMAND:Register();

--Should be obvious
local COMMAND = Clockwork.command:New("CharSetDemonic");
COMMAND.tip = "Permanently enhance your active character's stats.";
COMMAND.access = "s";
COMMAND.alias = {"SetDemon","MakeDemon"};

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if player:HasInitialized() and player:Alive() then
		cwAlyTools:SetStatMultiplier(player)
		player:SetCharacterData("isDemon", true);
		Clockwork.player:Notify(player, "Set your stats to demonic!");
		
	else
		Clockwork.player:Notify(player, "Invalid!");
	end
end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("MarkPoint")
COMMAND.tip = "Designate a specific spot you're looking at for later use."
COMMAND.flags = CMD_DEFAULT
COMMAND.access = "a"

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	plytrace = player:GetEyeTraceNoCursor();
	if plytrace.Hit then
		local position = plytrace.HitPos
		local height = 4000
		local markpos = plytrace.HitPos
		local roof = markpos + Vector(0, 0, height)
		local skytrace = util.TraceLine({
			endpos = roof,
			filter = target,
			start = markpos,
			mask = MASK_BLOCKLOS_AND_NPCS
		})
		
		if skytrace.HitWorld or skytrace.HitSky then
			roof = skytrace.HitPos
		end
		
		player:SetNetVar("markedpoint", {
			valid = true,
			corepos = position,
			rooftgt = roof,
			plytgt = position + Vector(0, 0, 32),
			headroom = height * skytrace.Fraction,
			indoors = ((skytrace.HitWorld) and (not skytrace.HitSky ))
		});
		Schema:EasyText(player, "cornflowerblue", "Point designated!")
	else
		Schema:EasyText(player, "grey", "Invalid position!")
	end
end

COMMAND:Register();

local COMMAND = Clockwork.command:New("MarkEntity")
COMMAND.tip = "Designate a specific entity you're looking at for tracking and aiming things at."
COMMAND.flags = CMD_DEFAULT
COMMAND.access = "s"

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	plytrace = player:GetEyeTraceNoCursor();
	if IsValid(plytrace.Entity) then
		player:SetNetVar("markedpoint", {
			entity = plytrace.Entity
		});
		Schema:EasyText(player, "cornflowerblue", "Entity designated!")
	else
		Schema:EasyText(player, "grey", "Invalid position!")
	end
end

COMMAND:Register();

local COMMAND = Clockwork.command:New("ClearMarkedPoint")
COMMAND.tip = "Clear your currently marked point."
COMMAND.flags = CMD_DEFAULT
COMMAND.access = "a"

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	player:SetNetVar("markedpoint", nil);
	Schema:EasyText(player, "cornflowerblue", "Point cleared.")
end

COMMAND:Register();

local COMMAND = Clockwork.command:New("ToggleMarkedData")
COMMAND.tip = "Designate a specific spot you're looking at for later use."
COMMAND.flags = CMD_DEFAULT
COMMAND.access = "a"
COMMAND.alias = {"MarkData","ToggleMarkData"};

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	hidedata = player:GetNetVar("markeddata",false);
	player:SetNetVar("markeddata", not hidedata)
	if hidedata then
		Schema:EasyText(player, "cornflowerblue", "Will hide marked point data!")
	else
		Schema:EasyText(player, "cornflowerblue", "Will show marked point data!")
	end
end

COMMAND:Register();

local COMMAND = Clockwork.command:New("CreateTeleporter")
COMMAND.tip = "Create a teleporter at this spot, setting the destination to a spot designated with /MarkPoint"
COMMAND.flags = CMD_DEFAULT
COMMAND.access = "s"

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local name = nil
	local rotate = tonumber(arguments[2]) or nil
	tgtpoint = cwAlyTools:UpdateMarkerTrace(player:GetNetVar("markedpoint", nil))
	if tgtpoint.valid then
		plytrace = player:GetEyeTraceNoCursor();
		if plytrace.Hit then
			height = tgtpoint.headroom or 0
			if height > 64 then
				Schema:EasyText(player, "cornflowerblue", "Adding teleporter.")
				cwAlyTools:AddTeleporter(plytrace.HitPos+ Vector(0, 0, 16),tgtpoint)
				cwAlyTools:NotifyAly(player:Name().." has spawned an admin teleporter." )
			else
				Schema:EasyText(player, "grey", "Destination is too cramped!")
			end
		else
			Schema:EasyText(player, "grey", "Invalid position!")
		end
	else
		Schema:EasyText(player, "grey", "No destination marked!")
	end
end

COMMAND:Register();

local COMMAND = Clockwork.command:New("CreateFuckedTeleporter")
COMMAND.tip = "Create a glitched teleporter at this spot, setting the destination to a spot designated with /MarkPoint"
COMMAND.flags = CMD_DEFAULT
COMMAND.access = "s"

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local name = nil
	local rotate = tonumber(arguments[2]) or nil
	tgtpoint = player:GetNetVar("markedpoint") or {
		valid = false,
		headroom = 128,
		plytgt = Vector(0,0,0)
	}
	if not tgtpoint.valid then
		Schema:EasyText(player, "grey", "No destination marked! Portal will destroy anything that enters!")
	end
	plytrace = player:GetEyeTraceNoCursor();
	if plytrace.Hit then
		height = tgtpoint.headroom or 128
		if height > 64 then
			Schema:EasyText(player, "cornflowerblue", "Adding fucked teleporter.")
			cwAlyTools:NotifyAly(player:Name().." has spawned a fucked teleporter." )
			cwAlyTools:AddFuckedTeleporter(plytrace.HitPos+ Vector(0, 0, 16),tgtpoint.plytgt)
		else
			Schema:EasyText(player, "grey", "Destination is too cramped!")
		end
	else
		Schema:EasyText(player, "grey", "Invalid position!")
	end

end

COMMAND:Register();

local COMMAND = Clockwork.command:New("RemoveTeleporter")
	COMMAND.tip = "Remove any teleporters at your cursor."
	COMMAND.access = "s"
	COMMAND.optionalArguments = 1;
	COMMAND.text = "[int Distance]"

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		cwAlyTools:RemoveTeleporter(player:GetEyeTrace().HitPos, arguments[1] or 256, player);
	end
COMMAND:Register()

local COMMAND = Clockwork.command:New("RemoveAllTeleporters")
	COMMAND.tip = "Remove all teleporters."
	COMMAND.access = "s"

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		cwAlyTools:RemoveAllTeleporters(player);
	end
COMMAND:Register()

local COMMAND = Clockwork.command:New("CreatePowerCore")
COMMAND.tip = "Create a power core at this spot."
COMMAND.flags = CMD_DEFAULT
COMMAND.access = "s"

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local name = nil
	plytrace = player:GetEyeTraceNoCursor();
	if plytrace.Hit then
		Schema:EasyText(player, "cornflowerblue", "Adding teleporter.")
		cwAlyTools:AddPowerCore(plytrace.HitPos)
		cwAlyTools:NotifyAly(player:Name().." has spawned a power core." )
	else
		Schema:EasyText(player, "grey", "Invalid position!")
	end
end

COMMAND:Register();

local COMMAND = Clockwork.command:New("RemovePowerCore")
	COMMAND.tip = "Remove any power cores at your cursor."
	COMMAND.access = "s"

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		cwAlyTools:RemovePowerCore(player:GetEyeTrace().HitPos, 256, player);
	end
COMMAND:Register()

local COMMAND = Clockwork.command:New("RemoveAllPowerCores")
	COMMAND.tip = "Remove all power cores."
	COMMAND.access = "s"

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		cwAlyTools:RemoveAllPowerCores(player);
	end
COMMAND:Register()

local COMMAND = Clockwork.command:New("PortalNPC");
COMMAND.tip = "Summon an NPC at your targeted point.";
COMMAND.text = "<string NPC>";
COMMAND.access = "s";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local npc = ents.Create(arguments[1]);
	
	if IsValid(npc) then
		local trace = player:GetEyeTraceNoCursor();
		
		if (trace.Hit) then
			local destination = trace.HitPos + Vector(0,0,60);
			
			local portal = ents.Create("cw_arriveportal")
			portal:SetPos(destination)
			portal:Spawn();
			local effectData = EffectData()
			effectData:SetScale(1)
			effectData:SetOrigin(destination)
			effectData:SetMagnitude(1)
			util.Effect("camera_flash", effectData, true, true)
			util.Effect("ThumperDust", effectData, true, true)
			
			timer.Simple(1, function()
				if IsValid(player) then
					npc:SetPos(destination + Vector(0, 0, 16));
					npc:Spawn();
					npc:EmitSound( "ambient/levels/citadel/weapon_disintegrate3.wav")
					npc:Activate();
					timer.Simple(1, function()
						portal:Remove()					
					end )
				end
			end);
		else
			Schema:EasyText(player, "darkgrey", "Look at a valid spot!");
		end;
	else
		Schema:EasyText(player, "grey", arguments[1].." is not a valid npc!");
	end
end;

COMMAND:Register();

function cwAlyTools:UpdateMarkerTrace(tracedata)
	tracedata = tracedata or {valid = false};
	if IsValid(tracedata.entity) then
		local ent = tracedata.entity
		local position = ent:GetPos()
		local height = 4000
		local roof = position + Vector(0, 0, height)
		local skytrace = util.TraceLine({
			endpos = roof,
			filter = ent,
			start = position,
			mask = MASK_BLOCKLOS_AND_NPCS
		})
		
		if skytrace.HitWorld or skytrace.HitSky then
			roof = skytrace.HitPos
		end
		
		tracedata = {
			valid = true,
			entity = ent,
			corepos = position,
			rooftgt = roof,
			plytgt = position + Vector(0, 0, 32),
			headroom = height * skytrace.Fraction,
			indoors = ((skytrace.HitWorld) and (not skytrace.HitSky ))
		};
	end
	if not tracedata.valid then
		tracedata = {
			valid = false
		}
	end
	return tracedata;
end