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
					Clockwork.player:SetSafePosition(target, destination);
					util.Decal("PentagramBurn", trace.HitPos + trace.HitNormal, trace.HitPos - trace.HitNormal);
					util.Decal("PentagramBurn", origin, origin + Vector(0, 0, -256));
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
	if string.find(arguments[1], "cw_") then
		local npc = scripted_ents.GetStored(arguments[1]);
		
		if npc then
			local trace = player:GetEyeTraceNoCursor();
			
			if (trace.Hit) then
				local destination = trace.HitPos;
				
				ParticleEffect("teleport_fx", destination, Angle(0,0,0));
				sound.Play("misc/summon.wav", destination, 100, 100);
				
				timer.Simple(0.75, function()
					if IsValid(player) then
						npc.t:SpawnFunction(player, trace);
						
						if IsValid(npc) then
							util.Decal("PentagramBurn", trace.HitPos + trace.HitNormal, trace.HitPos - trace.HitNormal);
						end
					end
				end);
			else
				Schema:EasyText(player, "darkgrey", "Look at a valid spot!");
			end;
		else
			Schema:EasyText(player, "grey", arguments[1].." is not a valid npc!");
		end
	else
		local npc = ents.Create(arguments[1]);
		
		if IsValid(npc) then
			local trace = player:GetEyeTraceNoCursor();
			
			if (trace.Hit) then
				local destination = trace.HitPos;
				
				ParticleEffect("teleport_fx", destination, Angle(0,0,0));
				sound.Play("misc/summon.wav", destination, 100, 100);
				
				timer.Simple(0.75, function()
					if IsValid(player) then
						npc:SetPos(destination + Vector(0, 0, 16));
						npc:Spawn();
						npc:Activate();
						
						if IsValid(npc) then
							util.Decal("PentagramBurn", trace.HitPos + trace.HitNormal, trace.HitPos - trace.HitNormal);
						end
					end
				end);
			else
				Schema:EasyText(player, "darkgrey", "Look at a valid spot!");
			end;
		else
			Schema:EasyText(player, "grey", arguments[1].." is not a valid npc!");
		end
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
			end
		end);
    else
        Schema:EasyText(player, "darkgrey", "Look at a valid spot!");
    end;
end;

COMMAND:Register();