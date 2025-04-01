--[[
	Begotten III: Jesus Wept
--]]

PLUGIN:SetGlobalAlias("cwSanity");

Clockwork.kernel:IncludePrefixed("cl_plugin.lua");
Clockwork.kernel:IncludePrefixed("cl_hooks.lua");
Clockwork.kernel:IncludePrefixed("sv_plugin.lua");
Clockwork.kernel:IncludePrefixed("sv_hooks.lua");

-- Called when the Clockwork shared variables are added.
function cwSanity:ClockworkAddSharedVars(globalVars, playerVars)
	playerVars:Number("sanity");
end;

local playerMeta = FindMetaTable("Player");

-- A function to get a player's sanity level.
function playerMeta:GetSanity()
	return self:GetNetVar("sanity");
end;

-- A function to get the player's sanity level.
function playerMeta:GetMaxSanity()
	return self.maxSanity or 100;
end;

local COMMAND = Clockwork.command:New("CharSetSanity");
COMMAND.tip = "Set a players Sanity level.";
COMMAND.text = "<string Name> [number Amount]";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";
COMMAND.arguments = 1;
COMMAND.optionalArguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);

	if (target) then
		local amount = arguments[2];
		
		if (!amount or !tonumber(amount)) then
			amount = 0;
		else
			amount = math.Clamp(tonumber(amount), 0, 100);
		end;

		target:SetCharacterData("sanity", amount);
		target:SetNetVar("sanity", amount);

		if (player != target)	then
			Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You have set "..target:Name().."'s sanity to "..amount..".");
		else
			Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You have set your own sanity to "..amount..".");
		end;
	else
		Schema:EasyText(player, "grey", "["..self.name.."] "..arguments[1].." is not a valid player!");
	end;
end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyScare");
COMMAND.tip = "Scare a player and reduce their sanity by 10. Leave argument blank to scare the player you are looking at.";
COMMAND.text = "<string Name>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";
COMMAND.optionalArguments = 1;
COMMAND.alias = {"ScarePlayer", "CharScare", "Scare", "Jumpscare"};

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);
	
	if !target then
		local ent = player:GetEyeTraceNoCursor().Entity;
		
		if ent:IsPlayer() then
			target = ent;
		end
	end

	if (target) then
		target:HandleSanity(-10);

		if (player != target) then
			netstream.Start({player, target}, "ScarePlayer");
		
			Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You have scared "..target:Name().."!");
		else
			netstream.Start(player, "ScarePlayer");
			
			Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You have scared yourself!");
		end;
	end;
end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyScareDoor");
COMMAND.tip = "Scare a player with a door jumpscare.";
COMMAND.text = "<string Name>";
COMMAND.access = "s";
COMMAND.arguments = 1;
COMMAND.alias = {"DoorScare", "ScarePlayerDoor", "CharScareDoor", "ScareDoor", "JumpscareDoor"}

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);

	if (target) then
		local entity = nil;
		
		for k, v in pairs (ents.FindInSphere(target:GetPos(), 750)) do
			if (v:GetClass() == "prop_door_rotating") then
				entity = v;
				
				break;
			end;
		end;
		
		if (!entity) then
			Clockwork.player:Notify(player, target.." is not near any doors. Aborting.");
			
			return;
		end;
	
		if (SERVER) then
			target:SendLua([[cwSanity:DoDoorJumpscare()]]);
			
			if player ~= target then
				player:SendLua([[cwSanity:DoDoorJumpscare()]])
			end
		end;
	else
		Clockwork.player:Notify(player, target.." is not a valid player!");
	end;
end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("BlowDoor");
COMMAND.tip = "Blow down a door.";
COMMAND.access = "s";
COMMAND.alias = {"DoorBlow", "BreakDoor"}

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local door = player:GetEyeTrace().Entity;

		if (!IsValid(door)) then return	end;
		if door:GetClass() ~= "prop_door_rotating" then return end;

		door:EmitSound("physics/wood/wood_crate_impact_hard2.wav");
		door:EmitSound("physics/wood/wood_panel_impact_hard1.wav", 100, math.random(70, 130));
		door:EmitSound("physics/wood/wood_box_impact_hard3.wav");
		door:SetNotSolid(true);
		door:DrawShadow(false);
		door:SetNoDraw(true);
		door:Fire("Unlock", "", 0);
		door:Fire("Open", "", 0);
		local position = door:GetPos();
		local angles = door:GetAngles();
		local model = door:GetModel();
		local skin = door:GetSkin();

		local fakeDoor = ents.Create("prop_physics");
			fakeDoor:SetPos(position);
			fakeDoor:SetAngles(angles);
			fakeDoor:SetModel(model);
			fakeDoor:SetSkin(skin);
			fakeDoor:SetCollisionGroup(COLLISION_GROUP_DEBRIS);
			fakeDoor:DrawShadow(false);
		fakeDoor:Spawn();

		local position = player:GetPos();
		local doorPosition = fakeDoor:GetPos();

		fakeDoor:SetVelocity(Vector((position - doorPosition) * -40000, (position - doorPosition) * -40000, 0))	;

		timer.Simple(180, function()
			fakeDoor:Remove();

			if (IsValid(door)) then
				door:SetNotSolid(false);
				door:DrawShadow(true);
				door:SetNoDraw(false);
				
				door.health = nil;
			end;
		end);

		local physObj = fakeDoor:GetPhysicsObject();

		if (IsValid(physObj)) then
			physObj:ApplyForceOffset((doorPosition - position) * 1000, position);
		end;

		for k, v in pairs (ents.FindInSphere(doorPosition, 250)) do
			if (v:GetClass() == "prop_physics") then
				local physObj = v:GetPhysicsObject();

				if (IsValid(physObj)) then
					physObj:ApplyForceOffset((v:GetPos() - position) * 1000, position);
				end;
			end;
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("ToggleHellSanityLoss");
COMMAND.tip = "Toggle Hell's residual sanity loss.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if cwSanity.hellZoneSanityDisabled then
		cwSanity.hellZoneSanityDisabled = false;
		Schema:EasyText(player, "cornflowerblue", "Residual sanity loss in Hell has been disabled.");
	else
		cwSanity.hellZoneSanityDisabled = true;
		Schema:EasyText(player, "cornflowerblue", "Residual sanity loss in Hell has been enabled.");
	end
end;

COMMAND:Register();