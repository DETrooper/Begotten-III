--[[
	Begotten Code
--]]

-- A function to add some planks to a door.
function cwBarricades:AddPlankToDoor(player, door)
	if (hook.Run("PlayerCanBarricade", player, door)) then
		if (!door.Barricades) then
			door.Barricades = {};
			
			local inventory = player:GetInventory();
			local hasItem = Clockwork.inventory:HasItemByID(inventory, "wood_plank");
			
			if (hasItem) then
				local boardItem = Clockwork.item:FindByID("wood_plank");
				local obbMin = door:OBBMins();

				if (!door.BarricadeNum) then
					door.BarricadeNum = 0;
				end;
				
				player:Freeze(true);
				player:TakeItem(boardItem);
				
				timer.Simple(1, function()
					if (IsValid(player) and IsValid(door)) then
						player:Freeze(false);
						
						local eyePos = player:EyePos();
						local aimVector = player:GetAimVector();
						local trace = {};
							trace.start = eyePos;
							trace.endpos = trace.start + aimVector * 128;
							trace.filter = player;
						local traceLine = util.TraceLine(trace);
						local position = door:GetPos() + Vector(0, 0, 0 + obbMin.z + 24 * door.BarricadeNum) + traceLine.HitNormal * 5 + door:GetRight() * -24;
						
						local plank = ents.Create("prop_physics");
							plank:SetModel("models/props_debris/wood_board04a.mdl");
							plank:SetPos(position);
							plank:SetAngles(door:GetAngles() + Angle(0, 0, 90 + math.random(-30, 30)));
						plank:Spawn();
						plank:SetName(door:EntIndex().."_plank_"..door.BarricadeNum);
						
						local physObj = plank:GetPhysicsObject();
						
						if (IsValid(physObj)) then
							physObj:EnableCollisions(false);
							physObj:EnableMotion(false);
						end;
						
						door.Barricades[#door.Barricades + 1] = plank;
						door.BarricadeNum = door.BarricadeNum + 1;
						door:EmitSound("physics/wood/wood_plank_impact_hard" .. math.random(1, 5) .. ".wav");
					end;
				end);

				door:Fire("lock");
			else
				Schema:EasyText(player, "chocolate", "You need wooden planks to barricade a door!");
			end;
		else
			Schema:EasyText(player, "peru", "This door has already been barricaded!");
		end;
	end;
end;