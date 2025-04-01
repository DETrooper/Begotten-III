local Clockwork = Clockwork;

local COMMAND = Clockwork.command:New("SummonPlayer");
COMMAND.tip = "Summon a player to your targeted point.";
COMMAND.text = "<string Name>";
COMMAND.access = "s";
COMMAND.arguments = 1;
COMMAND.alias = {"SummonCharacter", "PlySummon", "CharSummon"};

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);
	local trace = player:GetEyeTraceNoCursor();
    
    if (trace.Hit) then
        if (target) then
            local origin = target:GetPos();
            local destination = trace.HitPos;
			
            ParticleEffect("teleport_fx", origin, Angle(0,0,0), target);
            sound.Play("misc/summon.wav", origin, 100, 100);
            ParticleEffect("teleport_fx", destination, Angle(0,0,0));
            sound.Play("misc/summon.wav", destination, 100, 100);
			
            timer.Create("summonplayer_"..tostring(target:EntIndex()), 0.75, 1, function()
				if IsValid(target) then
					if cwPickupObjects then
						cwPickupObjects:ForceDropEntity(target)
					end
				
					Clockwork.player:SetSafePosition(target, destination);
					util.Decal("PentagramBurn", trace.HitPos + trace.HitNormal, trace.HitPos - trace.HitNormal);
					util.Decal("PentagramBurn", origin, origin + Vector(0, 0, -256));
					
					hook.Run("PlayerTeleported", target);
				end
            end);
        else
            Schema:EasyText(player, "grey", "["..self.name.."] "..arguments[1].." is not a valid player!");
        end;
    else
        Schema:EasyText(player, "darkgrey", "Look at a valid spot!");
    end;
end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("SummonNPC");
COMMAND.tip = "Summon an NPC at your targeted point.";
COMMAND.text = "<string NPC>";
COMMAND.access = "s";
COMMAND.arguments = 1;
COMMAND.alias = {"SpawnNPC"};

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local entity = ents.Create(arguments[1]);
	
	if IsValid(entity) and (entity:IsNPC() or entity:IsNextBot()) then
		local trace = player:GetEyeTraceNoCursor();
		
		if (trace.Hit) then
			local destination = trace.HitPos;
			local spawnDelay = math.Rand(1, 2);
			
			sound.Play("begotten/npc/tele2_fadeout2.ogg", destination, 80, math.random(95, 105));
			
			timer.Simple(spawnDelay, function()
				ParticleEffect("teleport_fx", destination, Angle(0,0,0));
				sound.Play("misc/summon.wav", destination, 100, 100);
				
				timer.Simple(0.2, function()
					local flash = ents.Create("light_dynamic")
					flash:SetKeyValue("brightness", "2")
					flash:SetKeyValue("distance", "256")
					flash:SetPos(destination + Vector(0, 0, 8));
					flash:Fire("Color", "255 100 0")
					flash:Spawn()
					flash:Activate()
					flash:Fire("TurnOn", "", 0)
					timer.Simple(0.5, function() if IsValid(flash) then flash:Remove() end end)
					
					util.ScreenShake(destination, 10, 100, 0.4, 1000, true);
				end);
		
				timer.Simple(0.75, function()
					local npc = ents.Create(arguments[1]);
				
					if IsValid(npc) then
						npc:SetPos(destination + Vector(0, 0, 16));
						npc:Spawn();
						npc:Activate();
						
						util.Decal("PentagramBurn", trace.HitPos + trace.HitNormal, trace.HitPos - trace.HitNormal);
						
						if IsValid(player) then
							undo.Create("Summoned "..(npc.PrintName or npc:GetClass()))
							undo.SetPlayer(player)
							undo.AddEntity(npc)
							undo.Finish()
						end
					end
				end);
			end);
		else
			Schema:EasyText(player, "darkgrey", "Look at a valid spot!");
		end;
	else
		Schema:EasyText(player, "grey", arguments[1].." is not a valid npc!");
	end
	
	if IsValid(entity) then
		entity:Remove();
	end
end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("SummonSelf");
COMMAND.tip = "Summon yourself to your targeted point. This will take you out of observer.";
COMMAND.access = "s";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local trace = player:GetEyeTraceNoCursor();
    
    if (trace.Hit) then
		local destination = trace.HitPos;
		
		ParticleEffect("teleport_fx", destination, Angle(0,0,0));
		sound.Play("misc/summon.wav", destination, 100, 100);
		
		timer.Create("summonplayer_"..tostring(player:EntIndex()), 0.75, 1, function()
			if IsValid(player) then
				Clockwork.player:SetSafePosition(player, destination);
				cwObserverMode:MakePlayerExitObserverMode(player);
				util.Decal("PentagramBurn", trace.HitPos + trace.HitNormal, trace.HitPos - trace.HitNormal);
				
				hook.Run("PlayerTeleported", player);
			end
		end);
    else
        Schema:EasyText(player, "darkgrey", "Look at a valid spot!");
    end;
end;

COMMAND:Register();

local COMMAND = Clockwork.command:New("Summon");
COMMAND.tip = "Summon a miscreant to your position, if you are of sufficient authority. Note that they must already be in Hell.";
COMMAND.text = "<string Name>";
COMMAND.arguments = 1;
COMMAND.faction = "Children of Satan";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if player:GetFaction() ~= "Children of Satan" then
		Schema:EasyText(player, "chocolate", "You are not the correct faction to do this!");
	
		return false;
	end

	if Schema:GetRankTier("Children of Satan", player:GetCharacterData("rank", 1)) < 4 then
		Schema:EasyText(player, "chocolate", "You are not high enough in rank to use this command!");
	
		return false;
	end

	local target = Clockwork.player:FindByID(arguments[1]);
	local trace = player:GetEyeTraceNoCursor();
    
    if (trace.Hit) then
        if (target) then
			local faction = target:GetFaction();
			
			if faction == "Children of Satan" and Schema:GetRankTier(faction, target:GetCharacterData("rank", 1)) < 4 and (target:GetCharacterData("LastZone") == "hell" or target:GetCharacterData("LastZone") == "manor") then
				local curTime = CurTime();
				
				if !player.nextSummon or player.nextSummon < curTime then
					player.nextSummon = curTime + 10;
					
					local origin = target:GetPos();
					local destination = trace.HitPos;
					
					ParticleEffect("teleport_fx", origin, Angle(0,0,0), target);
					sound.Play("misc/summon.wav", origin, 100, 100);
					ParticleEffect("teleport_fx", destination, Angle(0,0,0));
					sound.Play("misc/summon.wav", destination, 100, 100);
					
					timer.Create("summonplayer_"..tostring(target:EntIndex()), 0.75, 1, function()
						if IsValid(target) then
							if cwPickupObjects then
								cwPickupObjects:ForceDropEntity(target)
							end
						
							Clockwork.player:SetSafePosition(target, destination);
							util.Decal("PentagramBurn", trace.HitPos + trace.HitNormal, trace.HitPos - trace.HitNormal);
							util.Decal("PentagramBurn", origin, origin + Vector(0, 0, -256));
							
							hook.Run("PlayerTeleported", target);
						end
					end);
				else
					Schema:EasyText(player, "grey", "You cannot summon for another "..math.ceil(player.nextSummon - CurTime()).." seconds!");
				end
			else
				Schema:EasyText(player, "firebrick", target:Name().." cannot be summoned!");
			end
        else
            Schema:EasyText(player, "grey", "["..self.name.."] "..arguments[1].." is not a valid player!");
        end;
    else
        Schema:EasyText(player, "darkgrey", "Look at a valid spot!");
    end;
end;

COMMAND:Register();