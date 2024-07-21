
pac.AddHook("RenderScene", "eyeangles_eyepos", function(pos, ang)
	pac.EyePos = pos
	pac.EyeAng = ang
end)

pac.AddHook("DrawPhysgunBeam", "physgun_event", function(ply, wep, enabled, target, bone, hitpos)

	if enabled then
		ply.pac_drawphysgun_event = {ply, wep, enabled, target, bone, hitpos}
	else
		ply.pac_drawphysgun_event = nil
	end

	if ply.pac_drawphysgun_event_part and ply.pac_drawphysgun_event_part:IsValid() then
		ply.pac_drawphysgun_event_part:OnThink()
	end


	if ply.pac_hide_physgun_beam then
		return false
	end
end)

do
	pac.AddHook("UpdateAnimation", "event_part", function(ply)
		if not ply:IsValid() then return end
		local plyTable = ply:GetTable();

		if plyTable.pac_death_physics_parts and ply:Alive() and plyTable.pac_physics_died then
			pac.CallPartEvent("become_physics")
			plyTable.pac_physics_died = false
		end

		local tbl = plyTable.pac_pose_params

		if tbl then
			for _, data in pairs(tbl) do
				ply:SetPoseParameter(data.key, data.val)
			end
		end

		tbl = plyTable.pac_flex_params

		if tbl then
			for flex, weight in pairs(tbl) do
				ply:SetFlexWeight(flex, weight)
			end
		end

		local animrate = 1

		if plyTable.pac_global_animation_rate and plyTable.pac_global_animation_rate ~= 1 then
			if plyTable.pac_global_animation_rate == 0 then
				animrate = ply:GetModelScale() * 2
			elseif plyTable.pac_global_animation_rate ~= 1 then
				ply:SetCycle((pac.RealTime * plyTable.pac_global_animation_rate)%1)
				animrate = plyTable.pac_global_animation_rate
			end
		end

		if plyTable.pac_animation_sequences then
			local part, thing = next(plyTable.pac_animation_sequences)

			if part and part:IsValid() then

				if part.OwnerCycle then
					if part.Rate == 0 then
						animrate = 1
						ply:SetCycle(part.Offset % 1)
					else
						animrate = animrate * part.Rate
					end
				else
					part:UpdateAnimation(ply)
				end
			elseif part and not part:IsValid() then
				plyTable.pac_animation_sequences[part] = nil
			end
		end

		if animrate ~= 1 then
			ply:SetCycle((pac.RealTime * animrate) % 1)
			return true
		end

		if plyTable.pac_holdtype_alternative_animation_rate then
			local length = ply:GetVelocity():Dot(ply:EyeAngles():Forward()) > 0 and 1 or -1
			local scale = ply:GetModelScale() * 2

			if scale ~= 0 then
				ply:SetCycle(pac.RealTime / scale * length)
			else
				ply:SetCycle(0)
			end

			return true
		end

		if plyTable.pac_last_vehicle then
			local vehicle = ply:GetVehicle()

			if plyTable.pac_last_vehicle ~= vehicle then
				if plyTable.pac_last_vehicle ~= nil then
					pac.CallPartEvent("vehicle_changed", ply, vehicle)
				end
				
				plyTable.pac_last_vehicle = vehicle
			end
		end
	end)
end

local MOVETYPE_NOCLIP = MOVETYPE_NOCLIP
local IN_SPEED = IN_SPEED
local IN_WALK = IN_WALK
local IN_DUCK = IN_DUCK

local function mod_speed(cmd, speed)
	if speed and speed ~= 0 then
		local forward = cmd:GetForwardMove()
		forward = forward > 0 and speed or forward < 0 and -speed or 0

		local side = cmd:GetSideMove()
		side = side > 0 and speed or side < 0 and -speed or 0


		cmd:SetForwardMove(forward)
		cmd:SetSideMove(side)
	end
end

pac.AddHook("CreateMove", "events", function(cmd)
	if cmd:KeyDown(IN_SPEED) then
		mod_speed(cmd, pac.LocalPlayer.pac_sprint_speed)
	elseif cmd:KeyDown(IN_WALK) then
		mod_speed(cmd, pac.LocalPlayer.pac_walk_speed)
	elseif cmd:KeyDown(IN_DUCK) then
		mod_speed(cmd, pac.LocalPlayer.pac_crouch_speed)
	else
		mod_speed(cmd, pac.LocalPlayer.pac_run_speed)
	end
end)

pac.AddHook("TranslateActivity", "events", function(ply, act)
	if ply:IsValid() then
		local plyTable = ply:GetTable();
		
		-- animation part
		if plyTable.pac_animation_sequences and next(plyTable.pac_animation_sequences) then
			-- dont do any holdtype stuff if theres a sequence
			return
		end

		if plyTable.pac_animation_holdtypes then
			local key, val = next(plyTable.pac_animation_holdtypes)
			if key then
				if not val.part:IsValid() then
					plyTable.pac_animation_holdtypes[key] = nil
				else
					return val[act]
				end
			end
		end

		-- holdtype part
		if plyTable.pac_holdtypes then
			local key, act_table = next(plyTable.pac_holdtypes)

			if key then
				if not act_table.part:IsValid() then
					plyTable.pac_holdtypes[key] = nil
				else

					if act_table[act] and act_table[act] ~= -1 then
						return act_table[act]
					end

					if ply:GetVehicle():IsValid() and ply:GetVehicle():GetClass() == "prop_vehicle_prisoner_pod" then
						return act_table.sitting
					end

					if act_table.noclip ~= -1 and ply:GetMoveType() == MOVETYPE_NOCLIP then
						return act_table.noclip
					end

					if act_table.air ~= -1 and ply:GetMoveType() ~= MOVETYPE_NOCLIP and not ply:IsOnGround() then
						return act_table.air
					end

					if act_table.fallback ~= -1 then
						return act_table.fallback
					end
				end
			end
		end
	end
end)

pac.AddHook("CalcMainActivity", "events", function(ply, act)
	local plyTable = ply:GetTable();
	
	if ply:IsValid() and plyTable.pac_animation_sequences then
		local key, val = next(plyTable.pac_animation_sequences)

		if not key then return end

		if not val.part:IsValid() then
			plyTable.pac_animation_sequences[key] = nil
			return
		end

		return val.seq, val.seq
	end
end)

pac.AddHook("pac_PlayerFootstep", "events", function(ply, pos, snd, vol)
	local plyTable = ply:GetTable();
	
	plyTable.pac_last_footstep_pos = pos

	if plyTable.pac_footstep_override then
		for _, part in pairs(plyTable.pac_footstep_override) do
			if not part:IsHidden() then
				part:PlaySound(snd, vol)
			end
		end
	end

	if plyTable.pac_mute_footsteps then
		return true
	end
end)

net.Receive("pac_effect_precached", function()
	local name = net.ReadString()
	pac.CallHook("EffectPrecached", name)
end)
