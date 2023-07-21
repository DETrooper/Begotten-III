--[[
	Begotten Code
--]]

-- Called when a player attempts to barricade a door.
function cwBarricades:PlayerCanBarricade(player, door)
	return true;
end;

-- Called when a player uses an entity.
function cwBarricades:PlayerUse(player, entity)
	if (entity:GetClass() == "prop_door_rotating") then
		local eyeTrace = player:GetEyeTrace();
		local hitPos = eyeTrace.HitPos;
		local model = entity:GetModel();
		
		if model == "models/props_c17/door01_left.mdl" or model == "models/props_c17/door03_left.mdl" then
			if ((entity:GetBodygroup(0) != 2) and entity:WorldToLocal(hitPos):Distance(Vector(-1.0313, 41.8047, -8.1611)) > 8) then
				return false;
			end;
		end
		
		if (entity.Barricades) then
			local hasBarricades = false;
			
			for k, v in pairs(entity.Barricades) do
				if (IsValid(v)) then
					hasBarricades = true;
					
					break;
				end;
			end;
			
			if (hasBarricades) then
				entity:Fire("close");
				entity:Fire("lock", 1, 0.1);
			else
				entity:Fire("unlock");
				entity.Barricades = nil;
			end;
			
			return;
		end;
	end;
end;