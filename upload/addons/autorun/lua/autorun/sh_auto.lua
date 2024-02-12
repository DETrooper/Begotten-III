timer.Create("LoadSH", 1, 0, function()
if (Clockwork) then
timer.Destroy("LoadSH")

properties.Remove = function(name)
	name = name:lower()
	
	properties.List[name] = nil;
end

-- Remove drive so admins don't accidentally possess props or items.
properties.Remove("drive");

if SERVER then
	concommand.Add("botfill", function(player, command, arguments)
		if player:IsAdmin() then
			for i = 1, game.MaxPlayers() - _player.GetCount() do
				game.ConsoleCommand("bot\n")
			end;
		else
			Schema:EasyText(GetAdmins(), "lightslategrey", player:Name().." has tried to run the botfill console command!");
		end;
	end);

	concommand.Add("botfullequip", function(player, command, arguments)
		if player:IsAdmin() then
			for k, v in pairs (_player.GetAll()) do
				local pos = v:GetPos();
				
				if (v:IsBot()) then
					Clockwork.player:SetRagdollState(v, nil)
					v:Spawn();
					
					local ass = pos
					v:SetPos(ass)
					
					local items_to_give = {
						"begotten_1h_glazicus",
						"shield11",
						"begotten_javelin_pilum",
						"gatekeeper_plate",
						"gatekeeper_helmet",
						"backpack_survivalist"
					};
					
					for i = 1, #items_to_give do
						local instance = Clockwork.item:CreateInstance(items_to_give[i]);
						
						v:GiveItem(instance, true);
						Clockwork.item:Use(v, instance, true);
					end
					
					v:SelectWeapon("begotten_1h_glazicus");
					v:SetWeaponRaised(true);
					
			--		v:SelectWeapon("begotten_polearm_glazicbanner");
				end;
			end;
		else
			Schema:EasyText(GetAdmins(), "lightslategrey", player:Name().." has tried to run the botfullequip console command!");
		end;
	end);

	concommand.Add("botdistortedring", function(player, command, arguments)
		if player:IsAdmin() then
			for k, v in pairs (_player.GetAll()) do
				if (v:IsBot()) then
					local pos = v:GetPos();
					
					Clockwork.player:SetRagdollState(v, nil)
					v:Spawn();
					v:Freeze(true);
					v:SetPos(pos + Vector(0, 0, 16));
					
					local hasItem = Clockwork.inventory:HasItemByID(v:GetInventory(), "ring_distorted");
					
					if !hasItem then
						local instance = Clockwork.item:CreateInstance("ring_distorted");
						
						v:GiveItem(instance, true);
						Clockwork.item:Use(v, instance, true);
					end
				end;
			end;
		else
			Schema:EasyText(GetAdmins(), "lightslategrey", player:Name().." has tried to run the botdistortedring console command!");
		end;
	end);
end
end
end)