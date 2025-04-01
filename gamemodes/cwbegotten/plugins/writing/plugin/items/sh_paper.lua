--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "Paper";
ITEM.uniqueID = "paper";
ITEM.cost = 50;
ITEM.model = "models/items/magic/scrolls/scroll_rolled.mdl";
ITEM.weight = 0.25;
ITEM.category = "Tools";
ITEM.stackable = true;
ITEM.description = "A blank piece of paper, likely procured by the Hierarchy. It can be used to write on.";
ITEM.iconoverride = "materials/begotten/ui/itemicons/scroll.png";
ITEM.fireplaceFuel = 30;

ITEM.itemSpawnerInfo = {category = "City Junk", rarity = 100, onGround = false, bNoSupercrate = true};

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	local trace = player:GetEyeTraceNoCursor();
	
	if (trace.HitPos:Distance( player:GetShootPos() ) <= 192) then
		local entity = ents.Create("cw_paper");
		
		Clockwork.player:GiveProperty(player, entity);
		
		entity:SetPos(trace.HitPos);
		entity:Spawn();
		
		if (IsValid(itemEntity)) then
			local physicsObject = itemEntity:GetPhysicsObject();
			
			entity:SetPos( itemEntity:GetPos() );
			entity:SetAngles( itemEntity:GetAngles() );
			
			if (IsValid(physicsObject)) then
				if (!physicsObject:IsMoveable()) then
					physicsObject = entity:GetPhysicsObject();
					
					if (IsValid(physicsObject)) then
						physicsObject:EnableMotion(false);
					end;
				end;
			end;
		else
			Clockwork.entity:MakeFlushToGround(entity, trace.HitPos, trace.HitNormal);
		end;
	else
		Schema:EasyText(player, "firebrick", "You cannot drop paper that far away!");
		
		return false;
	end;
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();