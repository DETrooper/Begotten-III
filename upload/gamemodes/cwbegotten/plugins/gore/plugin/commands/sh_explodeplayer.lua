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
				if (SERVER) then
					target:Kill();
					
					if (target:GetRagdollEntity()) then
						cwGore:SplatCorpse(target:GetRagdollEntity(), 60);
						
						Schema:EasyText(player, "cornflowerblue","["..self.name.."] You gored "..target:Name().."!");
					end;
				end;
			end;
		else
			Schema:EasyText(player, "grey",target.." is not a valid player!");
		end;
	end;
COMMAND:Register();