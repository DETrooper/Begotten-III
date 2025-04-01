local COMMAND = Clockwork.command:New("GibRagdoll");
	COMMAND.tip = "Gib the ragdoll you are looking at to bits.";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.access = "s";

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local ragdoll = player:GetEyeTrace().Entity;
		
		if (IsValid(ragdoll) and ragdoll:GetClass() == "prop_ragdoll") then
			if (SERVER) then
				cwGore:SplatCorpse(ragdoll, 60);
			end;
		end;
	end;
COMMAND:Register();