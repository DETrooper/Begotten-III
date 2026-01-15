local Clockwork = Clockwork;

local COMMAND = Clockwork.command:New("SummonItem");
COMMAND.tip = "Spawn an item where you are looking.";
COMMAND.text = "<string Item>";
COMMAND.access = "s";
COMMAND.types = {"SpawnItem"}
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
    local itemTable = Clockwork.item:FindByID(arguments[1]);
				
    if (itemTable and !itemTable.isBaseItem) then
        local trace = player:GetEyeTraceNoCursor();
        
        if (trace.Hit) then
            local itemTable = Clockwork.item:CreateInstance(itemTable("uniqueID"));
            local entity = Clockwork.entity:CreateItem(player, itemTable, trace.HitPos);
			
			entity:SetRenderMode(RENDERMODE_TRANSCOLOR);
			entity:SetColor(Color(255, 255, 255, 0));
			
            ParticleEffect("teleport_fx", trace.HitPos, Angle(0,0,0), entity);
            sound.Play("misc/summon.wav", trace.HitPos, 100, 100);
			
            timer.Create("summonitem"..CurTime(), 0.75, 1, function()
                if (IsValid(entity)) then
                    Clockwork.entity:MakeFlushToGround(entity, trace.HitPos, trace.HitNormal);
					entity:SetColor(Color(255, 255, 255, 255));
                end;
				
				util.Decal("PentagramBurn", trace.HitPos + trace.HitNormal, trace.HitPos - trace.HitNormal);
            end);
        else
            Schema:EasyText(player, "darkgrey", "Look at a valid spot! The item can't be spawned there.");
        end;
    else
        Schema:EasyText(player, "grey", "This isn't a valid item!");
    end;
end;

COMMAND:Register();