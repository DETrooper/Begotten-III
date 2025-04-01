local COMMAND = Clockwork.command:New("ExplodePlayer");
	COMMAND.tip = "Gib a player to bits.";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.access = "s";
	COMMAND.alias = {"EP", "ExplodeCharacter", "PlyExplode", "CharExplode", "PlyGib", "CharGib"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = Clockwork.player:FindByID(arguments[1]);
		
		if (target) then
			if (!target:Alive()) then
				return;
			else
				target:Kill();
				
				if (target:GetRagdollEntity()) then
					cwGore:SplatCorpse(target:GetRagdollEntity(), 60);
					
					Schema:EasyText(player, "cornflowerblue","["..self.name.."] You gored "..target:Name().."!");
				end;
			end;
		else
			Schema:EasyText(player, "grey",target.." is not a valid player!");
		end;
	end;
COMMAND:Register();

local COMMAND = Clockwork.command:New("Expel");
	COMMAND.tip = "Expel a character's soul from Hell, violently.";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.faction = "Children of Satan";

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		if player:GetFaction() ~= "Children of Satan" then
			Schema:EasyText(player, "chocolate", "You are not the correct faction to do this!");
		
			return false;
		end

		if Schema:GetRankTier("Children of Satan", player:GetCharacterData("rank", 1)) > 3 then
			local curTime = CurTime();
			
			if player.nextExpel and player.nextExpel > curTime then
				Schema:EasyText(player, "chocolate", "You must wait another "..-math.ceil(curTime - player.nextExpel).." seconds before expelling someone again!");
			
				return false;
			end
		
			local target = player:GetEyeTraceNoCursor().Entity;
			
			if IsValid(target) and target:IsPlayer() and !target.cwObserverMode then
				if (!target:Alive()) then
					Schema:EasyText(player, "cornflowerblue", target:Name().." is already dead!");
				
					return;
				elseif target:GetFaction() ~= "Children of Satan" then
					Schema:EasyText(player, "cornflowerblue", target:Name().." is not a Child of Satan!");
				
					return;
				elseif zones and zones:GetPlayerSupraZone(target) ~= "suprahell" then
					Schema:EasyText(player, "cornflowerblue", target:Name().." must be in Hell to be expelled!");
				
					return;
				elseif Schema:GetRankTier("Children of Satan", target:GetCharacterData("rank", 1)) >= Schema:GetRankTier("Children of Satan", player:GetCharacterData("rank", 1)) then
					Schema:EasyText(player, "cornflowerblue", target:Name().." is too high of a rank to be expelled by you!");
				
					return;
				else
					player.nextExpel = CurTime() + 180;
				
					local thirdPerson = "his";
					
					if (player:GetGender() == GENDER_FEMALE) then
						thirdPerson = "her";
					end
				
					Clockwork.chatBox:AddInTargetRadius(player, "me", "snaps "..thirdPerson.." fingers.", player:GetPos(), config.Get("talk_radius"):Get() * 2);
					Clockwork.chatBox:AddInTargetRadius(target, "me", "abruptly explodes into a shower of fire and gore!", target:GetPos(), config.Get("talk_radius"):Get() * 2);
				
					target:Kill();
					
					if cwGore then
						if (target:GetRagdollEntity()) then
							cwGore:SplatCorpse(target:GetRagdollEntity(), 60, nil, true);
						end;
					end

					local pronoun = "his";
					
					if target:GetGender() == GENDER_FEMALE then
						pronoun = "her";
					end
					
					for i, v in ipairs(_player.GetAll()) do
						if v:IsAdmin() or (v:Alive() and v:GetFaction() == "Children of Satan") then
							v:SendLua([[Clockwork.Client:EmitSound("darkwhisper/darkwhisper_long"..math.random(1, 5)..".mp3", 80, 100)]]);
							Clockwork.chatBox:SetMultiplier(1.35);
							Clockwork.chatBox:Add(v, nil, "darkwhisperevent", player:Name().." has expelled "..target:Name().."'s soul to damnation for their insolence! Let "..pronoun.." sentence instill fear to all those found wanting.");
						end
					end
				end;
			else
				Schema:EasyText(player, "grey", "You must look at a valid character!");
			end;
		else
			Schema:EasyText(player, "chocolate", "You are not high enough in rank to use this command!");
		end
	end;
COMMAND:Register();