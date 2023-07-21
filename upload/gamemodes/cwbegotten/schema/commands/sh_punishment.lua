--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

local COMMAND = Clockwork.command:New();
COMMAND.tip = "Punish a misbehaving player by entering their name or looking at them.";
COMMAND.text = "[string Name]";
COMMAND.access = "s";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]) or player:GetEyeTraceNoCursor().Entity;
	if (target and target:IsPlayer() and target:Alive()) then
		if (SERVER) then
			target:EmitSound("ambient/energy/ion_cannon_shot1.wav")
			target:EmitSound("ambient/energy/newspark11.wav")
			local i = Clockwork.inventory:GetAsItemsList(target:GetInventory())
			for k, v in pairs (i) do
				printp("took "..v.uniqueID);
				for i = 1, Clockwork.inventory:GetItemCountByID(target:GetInventory(), v.uniqueID) do
					target:TakeItemByID(v.uniqueID)
				end;
			end;

			
			
			local effectdata = EffectData()
			effectdata:SetOrigin(target:GetPos() + Vector(0,0,48))
			effectdata:SetScale( 20 )
			effectdata:SetMagnitude( 30 )
			util.Effect( "ElectricSpark", effectdata )
			target:Kill();
			timer.Create( "smite"..target:Name().."smoke", 5, 1, 
			function()
				model = "models/Humans/Charple01.mdl"
				target:SetCharacterData("Model", model, true);
				target:SetModel(model);
				local ragdollEntity = target:GetRagdollEntity();
				if (IsValid(ragdollEntity)) then
					ragdollEntity:SetModel(model);
				end
				game.AddParticles( "particles/bonfire.pcf" )
				PrecacheParticleSystem( "smoke" )
				target:EmitSound("ambient/energy/newspark01.wav")
				ParticleEffectAttach( "smoke", 1, target, 1 )
			end
			)
			local ragdollEntity = target:GetRagdollEntity();
			
			if (IsValid(ragdollEntity)) then
				ragdollEntity:Fire("startragdollboogie")
				ragdollEntity:Ignite(7,0)
			end
			
			for i=1, math.random(20,45) do
				timer.Create( "smite"..target:Name()..""..i, math.random(5,50)/10, 1, 
				function()
					num = string.format("%02d",math.random(1,11))
					target:EmitSound("ambient/energy/newspark"..num..".wav")
					local effectdata = EffectData()
					effectdata:SetOrigin(target:GetPos() + Vector(0+math.random(-20,20),0+math.random(-20,20),0+math.random(-20,20)))
					util.Effect( "cball_bounce", effectdata )
				end
				)
			end
			
			Clockwork.chatBox:AddInTargetRadius(target, "me", "is struck by a huge bolt of electricity, their flesh and clothes burning to a crisp as their corpse spasms wildly!", target:GetPos(), config.Get("talk_radius"):Get() * 2);
			Clockwork.player:Notify(player, "You smote "..target:Name().."!");
		end;
	else
		Clockwork.player:Notify(player, "Invalid target! Enter a name or look at a player!");
	end
end;

Clockwork.command:Register(COMMAND, "PlySmite");