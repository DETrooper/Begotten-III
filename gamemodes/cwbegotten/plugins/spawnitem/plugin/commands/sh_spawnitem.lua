local Clockwork = Clockwork;

local COMMAND = Clockwork.command:New("SpawnItem");
COMMAND.tip = "Spawn an item where you are looking.";
COMMAND.text = "<string Item>";
COMMAND.access = "s";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
		local itemTable = Clockwork.item:FindByID(arguments[1]);
				
				if (itemTable and !itemTable.isBaseItem) then
					local trace = player:GetEyeTraceNoCursor();
					
					if (player:GetShootPos():Distance(trace.HitPos) <= 192) then
						local itemTable = Clockwork.item:CreateInstance(itemTable("uniqueID"));
						local entity = Clockwork.entity:CreateItem(player, itemTable, trace.HitPos);
						
						if (IsValid(entity)) then
							Clockwork.entity:MakeFlushToGround(entity, trace.HitPos, trace.HitNormal);
						end;
					else
						Schema:EasyText(player, "firebrick", "You cannot drop your weapon that far away!");
					end;
			
			
				else
					Schema:EasyText(player, "grey", "This is not a valid item!");
				end;
end;

COMMAND:Register();