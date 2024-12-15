local COMMAND = Clockwork.command:New("ToggleThrall");
	COMMAND.tip = "Toggles whether or not you will die like a thrall on death. You can use this on other players, but generally you shouldn't.";
	COMMAND.text = "[string Character Name]";
	COMMAND.access = "s";
	COMMAND.alias = {"PlySetData"};

	-- Called when the command has been run.
	function COMMAND:OnRun(player, arguments)
		local target = arguments[1] and Clockwork.player:FindByID(arguments[1]) or player;

        if(!IsValid(target)) then Clockwork.player:Notify(player, arguments[1].." is not a valid player!"); return; end

		target:SetCharacterData("isThrall", !target:GetCharacterData("isThrall", false));

		local isNowThrall = target:GetCharacterData("isThrall", false);

		target:SetSharedVar("isThrall", isNowThrall);

		local model = "models/begotten/heads/"..string.lower(target:GetGender()).."_gorecap.mdl";

		if(isNowThrall) then
			target:SetCharacterData("nonThrallModel", target:GetCharacterData("Model", target:GetModel()));
			target:SetCharacterData("Model", model, true);
			target:SetModel(model);
			target:SaveCharacter();

		else
			target:SetCharacterData("Model", target:GetCharacterData("nonThrallModel", model), true);
			target:SetModel(model);
			target:SaveCharacter();

		end

        Schema:EasyText(Schema:GetAdmins(), "skyblue", player:Nick().." set "..target:Nick().." '".."isThrall".."' to '"..tostring(isNowThrall).."'.");

	end;
COMMAND:Register();