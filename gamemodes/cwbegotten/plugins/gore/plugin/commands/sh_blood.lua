local COMMAND = Clockwork.command:New("Blood");
	COMMAND.tip = "Make a blood effect on the entity you are looking at.";
	COMMAND.flags = CMD_DEFAULT;
	COMMAND.access = "s";

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local eyeTrace = player:GetEyeTrace();
		
		if (eyeTrace.Entity and IsValid(eyeTrace.Entity) and !eyeTrace.Entity:IsWorld()) then
			cwGore:BloodEffect(eyeTrace.Entity, eyeTrace.HitPos)
		end;
	end;
COMMAND:Register();