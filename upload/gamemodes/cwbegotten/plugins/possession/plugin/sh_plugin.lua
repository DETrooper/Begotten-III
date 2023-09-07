--[[
	Begotten III: Jesus Wept
--]]

PLUGIN:SetGlobalAlias("cwPossession");

Clockwork.kernel:IncludePrefixed("cl_hooks.lua");
Clockwork.kernel:IncludePrefixed("sv_plugin.lua");
Clockwork.kernel:IncludePrefixed("sv_hooks.lua");

function cwPossession:StartCommand(player, ucmd)
	if IsValid(player) then
		local possessor;
		local victim;
		
		if SERVER then
			possessor = player.possessor;
			victim = player.victim;
		else
			if player.possessor then
				possessor = player.possessor;
				victim = player;
			elseif player.victim then
				possessor = player;
				victim = player.victim;
			end
		end
		
		if IsValid(victim) then 
			if victim:Alive() then
				player.attacking = ucmd:KeyDown(IN_ATTACK)
				player.blocking = ucmd:KeyDown(IN_ATTACK2);
				player.parrying = ucmd:KeyDown(IN_RELOAD)
				player.changeStance = ucmd:KeyDown(IN_ATTACK2) and ucmd:KeyDown(IN_USE);
				player.use = ucmd:KeyDown(IN_USE);
				player.jumping = ucmd:KeyDown(IN_JUMP)
				player.crouching = ucmd:KeyDown(IN_DUCK)
				player.running = ucmd:KeyDown(IN_SPEED);
				player.forward = ucmd:KeyDown(IN_FORWARD)
				player.backward = ucmd:KeyDown(IN_BACK)
				player.left = ucmd:KeyDown(IN_MOVELEFT)
				player.right = ucmd:KeyDown(IN_MOVERIGHT)
				player.movementForward = ucmd:GetForwardMove()
				player.sidewaysMovement = ucmd:GetSideMove()
				player.upMove = ucmd:GetUpMove()
				player.MouseX = ucmd:GetMouseX()
				player.MouseY = ucmd:GetMouseY()
				
				if SERVER then
					player.demonMove = ucmd
				end

				ucmd:SetViewAngles(victim:EyeAngles())
				player:SetPos(victim:GetPos() + victim:GetAimVector() * 10)
				
				if SERVER then
					ucmd:ClearButtons()
					player:Spectate(OBS_MODE_IN_EYE)
					player:SpectateEntity(victim)
				end
			end
		elseif IsValid(possessor) then
			-- The victim has ceased to be.
			if SERVER and !IsValid(possessor.victim) then
				possessor:Spectate(0);
				possessor:UnSpectate();
		
				cwObserverMode:MakePlayerEnterObserverMode(possessor);
				
				for i = 1, #cwPossession.possessedPlayers do
					if !IsValid(cwPossession.possessedPlayers[i]) then
						table.remove(cwPossession.possessedPlayers, i);
						break;
					end
				end
			end
			
			victim = player;
		end
			
		if player == victim and IsValid(possessor) and victim:Alive() then
			ucmd:ClearButtons();
			ucmd:ClearMovement();
			
			if possessor.attacking then
				ucmd:SetButtons(ucmd:GetButtons() + IN_ATTACK)
			end
			
			if possessor.blocking then
				ucmd:SetButtons(ucmd:GetButtons() + IN_ATTACK2)
			end
			
			if possessor.parrying then
				ucmd:SetButtons(ucmd:GetButtons() + IN_RELOAD)
			end
			
			if SERVER then
				local curTime = CurTime();
				
				if possessor.changeStance then
					local activeWeapon = player:GetActiveWeapon();
					
					if IsValid(activeWeapon) then
						local attacktable = GetTable(activeWeapon.AttackTable);

						if (attackTable and attackTable["canaltattack"] == true) then
							if !possessor.changeStanceTimer or possessor.changeStanceTimer <= curTime then
								possessor.changeStanceTimer = curTime + 1;
								
								if player:GetNWBool("ThrustStance") == false then
									if activeWeapon.CanSwipeAttack == true then
										player:SetNWBool( "ThrustStance", true )
										player:PrintMessage(HUD_PRINTTALK, "*** Switched to swiping stance.")
										possessor:PrintMessage(HUD_PRINTTALK, "*** Switched to swiping stance.")
									else
										player:SetNWBool( "ThrustStance", true )
										player:PrintMessage(HUD_PRINTTALK, "*** Switched to thrusting stance.")
										possessor:PrintMessage(HUD_PRINTTALK, "*** Switched to thrusting stance.")
									end
								else
									if activeWeapon.CanSwipeAttack == true then
										player:SetNWBool( "ThrustStance", false )
										player:PrintMessage(HUD_PRINTTALK, "*** Switched to thrusting stance.")
										possessor:PrintMessage(HUD_PRINTTALK, "*** Switched to thrusting stance.")
									elseif attacktable["dmgtype"] == 128 then
										player:SetNWBool( "ThrustStance", false )
										player:PrintMessage(HUD_PRINTTALK, "*** Switched to bludgeoning stance.")
										possessor:PrintMessage(HUD_PRINTTALK, "*** Switched to bludgeoning stance.")
									else
										player:SetNWBool( "ThrustStance", false )
										player:PrintMessage(HUD_PRINTTALK, "*** Switched to slashing stance.")
										possessor:PrintMessage(HUD_PRINTTALK, "*** Switched to slashing stance.")
									end
								end
							end
						end
					end
				end
				
				if possessor.jumping and victim:IsRagdolled() then
					if (victim:GetRagdollState() == RAGDOLL_FALLENOVER and Clockwork.player:GetAction(victim) != "unragdoll") then
						if (hook.Run("PlayerCanGetUp", victim)) then
							local get_up_time = 5;
							
							if cwBeliefs and victim:HasBelief("dexterity") then
								get_up_time = get_up_time * 0.67;
							end
							
							Clockwork.player:SetUnragdollTime(victim, get_up_time);
							hook.Run("PlayerStartGetUp", victim);
						end;
					end;
				end
			end
			
			if(possessor.crouching and !ucmd:KeyDown(IN_DUCK)) and !possessor.changeStance then ucmd:SetButtons(ucmd:GetButtons() + IN_DUCK) end
			if(possessor.jumping and !ucmd:KeyDown(IN_JUMP)) then ucmd:SetButtons(ucmd:GetButtons() + IN_JUMP) end
			if(possessor.running and !ucmd:KeyDown(IN_SPEED)) then ucmd:SetButtons(ucmd:GetButtons() + IN_SPEED) end
			if(possessor.use and !ucmd:KeyDown(IN_USE)) and !possessor.changeStance then ucmd:SetButtons(ucmd:GetButtons() + IN_USE) end
			
			if CLIENT and player == victim then
				possessor.viewAngles = possessor:EyeAngles();
			else
				possessor.viewAngles = Angle(possessor.viewAngles.p + possessor.MouseY / 30, possessor.viewAngles.y - possessor.MouseX / 30, 0)
				ucmd:SetForwardMove(possessor.movementForward)
				ucmd:SetSideMove(possessor.sidewaysMovement)
				ucmd:SetUpMove(possessor.upMove)
			end

			possessor.viewAngles.p = math.Clamp(possessor.viewAngles.p, -89, 89)
			ucmd:SetViewAngles(possessor.viewAngles)
		end
	end
end;

local COMMAND = Clockwork.command:New("DemonHeal");
	COMMAND.tip = "Use demonic powers to heal the injuries of a vessel, should only be used on possessed people and is a very public occurrence.";
	COMMAND.text = "<string Name>";
	COMMAND.access = "s";
	COMMAND.optionalArguments = 1;

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = player;
		
		if not arguments[1] then
			if player.victim then
				target = player.victim;
			end
		else
			target = Clockwork.player:FindByID(arguments[1]);
		end
		
		if target then
			local curTime = CurTime();
			
			if !player.nextDemonHeal or player.nextDemonHeal < curTime then
				player.nextDemonHeal = curTime + 10;
				
				local max_poise = target:GetMaxPoise();
				local max_stability = target:GetMaxStability();
				local max_stamina = target:GetMaxStamina();
				
				target:ResetInjuries();
				target:SetHealth(target:GetMaxHealth() or 100);
				target:SetNeed("thirst", 0);
				target:SetNeed("hunger", 0);
				target:SetNeed("sleep", 0);
				target:SetCharacterData("Stamina", max_stamina);
				target:SetNWInt("Stamina", max_stamina);
				target:SetCharacterData("stability", max_stability);
				target:SetNWInt("stability", max_stability);
				--target:SetCharacterData("meleeStamina", max_poise);
				target:SetNWInt("meleeStamina", max_poise);
				target:SetNWInt("freeze", 0);
				target:SetBloodLevel(5000);
				target:StopAllBleeding();
				Clockwork.limb:HealBody(target, 100);
				Clockwork.player:SetAction(target, "die", false);
				Clockwork.player:SetAction(target, "die_bleedout", false);
				
				if target:IsRagdolled() then
					Clockwork.player:SetRagdollState(target, RAGDOLL_NONE);
				end
				
				Clockwork.chatBox:AddInTargetRadius(target, "me", "is suddenly and miraculously healed of their wounds! Your eyes seem almost to deceive you as you watch their wounds disappear.", target:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
			else
				Schema:EasyText(player, "peru", "You cannot use this command for another "..tostring(math.ceil(player.nextDemonHeal - curTime)).." seconds!");
			end
		else
			Schema:EasyText(player, "grey", arguments[1].." is not a valid character!");
		end
	end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("DemonShriek");
COMMAND.tip = "If possessing a player, let out a blood-curdling shriek that disorients nearby players and drains their sanity.";
COMMAND.access = "s";
COMMAND.alias = {"Shriek"};

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if player.victim then
		local curTime = CurTime();
	
		if !player.nextDemonShriek or player.nextDemonShriek < curTime then
			player.nextDemonShriek = curTime + 60;
			
			player.victim:EmitSound("possession/caverns_scream.wav", 160);
			
			for k, v in pairs(ents.FindInSphere(player.victim:GetPos(), 512)) do
				if v:IsPlayer() and v:HasInitialized() and v:Alive() then
					v:Disorient(5);
					
					if !v.cwObserverMode and !v.victim and !v.possessor then
						v:HandleSanity(-10);
					end
				end
			end
			
			Clockwork.chatBox:AddInTargetRadius(player.victim, "me", "lets out an unholy and blood-curdling shriek!", player.victim:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
		else
			Schema:EasyText(player, "peru", "You cannot use this command for another "..tostring(math.ceil(player.nextDemonShriek - curTime)).." seconds!");
		end
	else
		Schema:EasyText(player, "grey", "You must be possessing someone to use this command!");
	end
end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("DemonTalk");
COMMAND.tip = "Send a message to a player as a demon.";
COMMAND.text = "<string Name> <string Message>";
COMMAND.access = "s";
COMMAND.arguments = 2;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);

	if (target) then
		local message = string.upper("\""..table.concat(arguments, " ", 2).."\"");

		if target ~= player then
			Clockwork.chatBox:SetMultiplier(1.25);
			Clockwork.chatBox:Add(target, nil, "demontalk", message);
		end
		
		Clockwork.chatBox:SetMultiplier(1.25);
		Clockwork.chatBox:Add(player, nil, "demontalk", message);
		
		Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You have demontalked \""..message.."\" to "..target:Name()..".");
	else
		Schema:EasyText(player, "grey", "["..self.name.."] "..arguments[1].." is not a valid player!");
	end;
end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("DemonNiceTalk");
COMMAND.tip = "Send a message to a player as a demon pretending to be something nicer.";
COMMAND.text = "<string Name> <string Message>";
COMMAND.access = "s";
COMMAND.arguments = 2;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);

	if (target) then
		local message = string.upper("\""..table.concat(arguments, " ", 2).."\"");

		if target ~= player then
			Clockwork.chatBox:SetMultiplier(1.25);
			Clockwork.chatBox:Add(target, nil, "demonnicetalk", message);
		end
		
		Clockwork.chatBox:SetMultiplier(1.25);
		Clockwork.chatBox:Add(player, nil, "demonnicetalk", message);
		
		Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You have demonnicetalked \""..message.."\" to "..target:Name()..".");
	else
		Schema:EasyText(player, "grey", "["..self.name.."] "..arguments[1].." is not a valid player!");
	end;
end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("DemonWhisper");
COMMAND.tip = "Whisper a message into a player's ear.";
COMMAND.text = "<string Name> <string Message>";
COMMAND.access = "s";
COMMAND.arguments = 2;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);

	if (target) then
		local message = table.concat(arguments, " ", 2);

		if target ~= player then
			Clockwork.chatBox:Add(target, nil, "whispersomeone", message);
		end
		
		Clockwork.chatBox:Add(player, nil, "whispersomeone", "[TO "..string.upper(target:Name())..":"..message);
		Schema:EasyText(player, "cornflowerblue", "["..self.name.."] You have demonwhispered \""..message.."\" to "..target:Name()..".");
	else
		Schema:EasyText(player, "grey", "["..self.name.."] "..arguments[1].." is not a valid player!");
	end;
end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("DemonFakeTalk");
COMMAND.tip = "Make a player think another player is saying something.";
COMMAND.text = "<string Target Name> <string Speaker Name> <string Message>";
COMMAND.access = "s";
COMMAND.arguments = 3;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);
	local speaker = Clockwork.player:FindByID(arguments[2]);
	local message = table.concat(arguments, " ", 3);
	
	if (target) then
		if (speaker) then
			if (message) ~= "" then
				Clockwork.chatBox:Add(target, speaker, "ic", message);
				Clockwork.chatBox:Add(player, speaker, "ic", "[TO "..string.upper(target:Name()).." FROM "..string.upper(speaker:Name())..": "..message);
			else
				Schema:EasyText(player, "darkgrey", "["..self.name.."] ".."This is not a valid message!");
			end
		else
			Schema:EasyText(player, "grey", "["..self.name.."] "..arguments[2].." is not a valid player!");
		end
	else
		Schema:EasyText(player, "grey", "["..self.name.."] "..arguments[1].." is not a valid player!");
	end;
end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("DemonFakeWhisper");
COMMAND.tip = "Make a player think another player is whispering something.";
COMMAND.text = "<string Target Name> <string Speaker Name> <string Message>";
COMMAND.access = "s";
COMMAND.arguments = 3;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);
	local speaker = Clockwork.player:FindByID(arguments[2]);
	local message = table.concat(arguments, " ", 3);
	
	if (target) then
		if (speaker) then
			if (message) ~= "" then
				Clockwork.chatBox:Add(target, speaker, "whisper", message);
				Clockwork.chatBox:Add(player, speaker, "whisper", "[TO "..string.upper(target:Name()).." FROM "..string.upper(speaker:Name())..": "..message);
			else
				Schema:EasyText(player, "darkgrey", "["..self.name.."] ".."This is not a valid message!");
			end
		else
			Schema:EasyText(player, "grey", "["..self.name.."] "..arguments[2].." is not a valid player!");
		end
	else
		Schema:EasyText(player, "grey", "["..self.name.."] "..arguments[1].." is not a valid player!");
	end;
end;


COMMAND:Register();

local COMMAND = Clockwork.command:New("DemonFakeMe");
COMMAND.tip = "Make a player think another player is whispering something.";
COMMAND.text = "<string Target Name> <string Speaker Name> <string Message>";
COMMAND.access = "s";
COMMAND.arguments = 3;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);
	local speaker = Clockwork.player:FindByID(arguments[2]);
	local message = table.concat(arguments, " ", 3);
	
	if (target) then
		if (speaker) then
			if (message) ~= "" then
				Clockwork.chatBox:Add(target, speaker, "me", message);
				Clockwork.chatBox:Add(player, speaker, "me", "[TO "..string.upper(target:Name()).." FROM "..string.upper(speaker:Name())..": "..message);
			else
				Schema:EasyText(player, "darkgrey", "["..self.name.."] ".."This is not a valid message!");
			end
		else
			Schema:EasyText(player, "grey", "["..self.name.."] "..arguments[2].." is not a valid player!");
		end
	else
		Schema:EasyText(player, "grey", "["..self.name.."] "..arguments[1].." is not a valid player!");
	end;
end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("ForceSuicide");
COMMAND.tip = "Force your enemies to fucking commit suicide.";
COMMAND.text = "<string Name>";
COMMAND.access = "s";
COMMAND.arguments = 1;
COMMAND.alias = {"PlyForceSuicide", "CharForceSuicide"};

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);

	if (target) then
		target:CommitSuicide();
	else
		Schema:EasyText(player, "grey", "["..self.name.."] "..arguments[1].." is not a valid player!");
	end;
end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyMakeFreakout");
COMMAND.tip = "Make a possessed player go fucking crazy!!! Lowers the sanity of nearby players. Lasts 30 seconds and then knocks the player unconcious, though possessing them prior will abort the latter behavior. Optional argument to ignore the trait requirement.";
COMMAND.text = "<string Name> [bool IgnoreTrait]";
COMMAND.access = "s";
COMMAND.arguments = 1;
COMMAND.optionalArguments = 1;
COMMAND.alias = {"MakeFreakout", "CharMakeFreakout"};

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);
	local ignoreTrait = false;
	
	if arguments[2] then
		ignoreTrait = true;
	end
	
	if (target) then
		if target:CanBePossessed(player, ignoreTrait) then
			target:PossessionFreakout();
		end
	else
		Schema:EasyText(player, "grey", "["..self.name.."] "..arguments[1].." is not a valid player!");
	end;
end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("PlySummonDemon");
COMMAND.tip = "Make a possessed player explode and a thrall will spawn in their place.";
COMMAND.text = "<string Name> [bool IgnoreTrait]";
COMMAND.access = "s";
COMMAND.arguments = 1;
COMMAND.alias = {"SummonDemon", "CharSummonDemon"};

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);
	
	if (target) then
		local targetPos = target:GetPos();
		
		Clockwork.chatBox:AddInTargetRadius(target, "me", "abruptly explodes into a shower of fire and gore as a fucking demon bursts from their very flesh!", targetPos, config.Get("talk_radius"):Get() * 2);
		
		target:Kill();
		
		if cwGore then
			if (target:GetRagdollEntity()) then
				cwGore:SplatCorpse(target:GetRagdollEntity(), 60);
			end;
		end
		
		local thrall;

		if target:HasTrait("marked") then
			thrall = ents.Create("npc_bgt_otis");
		else
			thrall = ents.Create("npc_bgt_brute");
		end
		
		ParticleEffect("teleport_fx",targetPos,Angle(0,0,0),thrall)
		sound.Play("misc/summon.wav",targetPos,100,100)
		thrall:EmitSound(cwPossession.laughs[math.random(1, #cwPossession.laughs)]);
		
		--[[timer.Simple(0.75, function()
			if IsValid(thrall) then]]--
				thrall:CustomInitialize();
				thrall:SetPos(targetPos);
				thrall:Spawn();
				thrall:Activate();
			--end
		--end
	else
		Schema:EasyText(player, "grey", "["..self.name.."] "..arguments[1].." is not a valid player!");
	end;
end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyMakeSay");
COMMAND.tip = "Speak through another player. Put text in quotations. You can use /me, /y, etc. in the text. Example: /plymakesay aaron \"/me begins convulsing.\"";
COMMAND.text = "<string Name> <string Text>";
COMMAND.access = "s";
COMMAND.arguments = 2;
COMMAND.alias = {"MakeSay", "CharMakeSay"};

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);

	if (target) then
		Clockwork.player:MakeSay(target, arguments[2]);
	else
		Schema:EasyText(player, "grey", "["..self.name.."] "..arguments[1].." is not a valid player!");
	end;
end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyPossess");
COMMAND.tip = "Possess a player, you should probably only do this if they have the 'Possessed' trait. Optional argument to ignore the trait requirement.";
COMMAND.text = "<string Name> [bool IgnoreTrait]";
COMMAND.access = "s";
COMMAND.arguments = 1;
COMMAND.optionalArguments = 1;
COMMAND.alias = {"Possess", "CharPossess"};

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);
	local ignoreTrait = false;
	
	if arguments[2] then
		ignoreTrait = true;
	end

	if (target) then
		if target:CanBePossessed(player, ignoreTrait) then
			target:Possess(player);
		end
	else
		Schema:EasyText(player, "grey", "["..self.name.."] "..arguments[1].." is not a valid player!");
	end;
end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyUnPossess");
COMMAND.tip = "Unpossess the player you are currently possessing.";
COMMAND.access = "s";
COMMAND.alias = {"UnPossess", "CharUnPossess"};

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if player.victim then
		if IsValid(player.victim) then
			player.victim:Unpossess();
		else
			player:Spectate(0);
			player:UnSpectate();
			
			cwObserverMode:MakePlayerEnterObserverMode(player);
			
			for i = 1, #cwPossession.possessedPlayers do
				if !IsValid(cwPossession.possessedPlayers[i]) then
					table.remove(cwPossession.possessedPlayers, i);
					break;
				end
			end
		end
	else
		Schema:EasyText(player, "grey", "You are not currently possessing a player!");
	end;
end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyTrack");
COMMAND.tip = "Set a player to actively track.";
COMMAND.text = "<string Name>";
COMMAND.access = "o";
COMMAND.arguments = 0;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);

	if (target) and (not target:IsBot()) then
		player:SetNetVar("tracktarget", target:SteamID());
		target:SetNetVar("trackedby", player:SteamID());
		Schema:EasyText(player, "cornflowerblue", "Now tracking "..target:Name()..".");
	else
		Schema:EasyText(player, "grey", "No valid target argument found.");
		if player:GetNetVar("tracktarget") then 
			for k, v in pairs (_player.GetAll()) do
				local steamID = v:SteamID();
				if steamID == player:GetNetVar("tracktarget") then
					
					Schema:EasyText(player, "cornflowerblue", "Currently tracking "..v:Name()..".");
					return;
				end
			end
			Schema:EasyText(player, "darkgrey", "Current target not connected.");
		end
	end;
end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyClearTrack");
COMMAND.tip = "Clear your set target.";
COMMAND.text = "";
COMMAND.access = "o";
COMMAND.arguments = 0;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if player:GetNetVar("tracktarget") then 
		for k, v in pairs (_player.GetAll()) do
			local steamID = v:SteamID();
			if steamID == player:GetNetVar("tracktarget") then
				player:SetNetVar("trackedby", nil);
			end
		end
		player:SetNetVar("tracktarget", nil)
		Schema:EasyText(player, "cornflowerblue", "Current target cleared.");
	end;
end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("PlyTrackGoTo");
COMMAND.tip = "Go to your currently tracked target.";
COMMAND.text = "";
COMMAND.access = "o";
COMMAND.arguments = 0;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	Schema:EasyText(player, "grey", "No valid target argument found.");
	if player:GetNetVar("tracktarget") then 
		for k, v in pairs (_player.GetAll()) do
			local steamID = v:SteamID();
			if steamID == player:GetNetVar("tracktarget") then
				
				Clockwork.player:SetSafePosition(player, v:GetPos());
				Schema:EasyText(player, "cornflowerblue", "["..self.name.."] Moved to "..v:Name().."'s position.");
				return;
			end
		end
		
		Schema:EasyText(player, "grey", "Invalid tracked player.");
	end;
end;

COMMAND:Register();