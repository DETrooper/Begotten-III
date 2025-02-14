--[[
	Begotten III: Jesus Wept
--]]

local cwStaticEnts = cwStaticEnts;
local Clockwork = Clockwork;

--Called when the plugin is initialized.
function cwStaticEnts:Initialize()
	Clockwork.ConVars.STATICESP = Clockwork.kernel:CreateClientConVar("cwStaticESP", 0, true, true);
	
	Clockwork.setting:AddCheckBox("Admin ESP", "Show static entities.", "cwStaticESP", "Whether or not to show static entities in the admin ESP.", function()
		return Clockwork.player:IsAdmin(Clockwork.Client);
	end);
end;

local classTranslate = {
	["gmod_light"] = "Light",
	["prop_physics"] = "Prop",
	["prop_ragdoll"] = "Ragdoll",
	["gmod_lamp"] = "Lamp"
};

-- Called when the ESP info is needed.
function cwStaticEnts:GetAdminESPInfo(info)
	local info = info;

	if (self.staticEnts) then
		if (Clockwork.ConVars.STATICESP:GetInt() == 1) then
			for k, v in ipairs(self.staticEnts) do
				local class = classTranslate[v.class] or v.class;

				table.insert(info,{
					position = v.pos + Vector(0, 0, 32),
					color = Color(0, 210, 255, 255),
					text = "[Static "..class.."]"
				});
			end;
		end;
	end;
end;

-- Called every tick.
function cwStaticEnts:Tick()
	local curTime = CurTime();

	if (Clockwork.Client.HasInitialized and Clockwork.Client:HasInitialized() and Clockwork.Client:IsAdmin()) then
		if (hook.Run("PlayerCanSeeAdminESP") ~= false and Clockwork.ConVars.STATICESP:GetInt() == 1) then
			if (!self.nextSync or curTime >= self.nextSync) then
				netstream.Request("staticESPSync", nil, function(data)
					cwStaticEnts.staticEnts = data;
				end);

				self.nextSync = curTime + 2;
			end;
		end;
	end;
end;