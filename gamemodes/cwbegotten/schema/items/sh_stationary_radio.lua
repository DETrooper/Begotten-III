--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

local ITEM = Clockwork.item:New();
	ITEM.name = "Stationary Radio";
	ITEM.model = "models/props_lab/citizenradio_remake.mdl";
	ITEM.weight = 5;
	ITEM.category = "Communication"
	ITEM.description = "An antique radio, do you think this'll still work?";

	-- Called when a player uses the item.
	function ITEM:OnUse(player, itemEntity)
		local trace = player:GetEyeTraceNoCursor();
		
		if (trace.HitPos:Distance( player:GetShootPos() ) <= 192) then
			local entity = ents.Create("cw_radio");
			
			Clockwork.player:GiveProperty(player, entity);
			
			entity:SetModel(self.model);
			entity:SetPos(trace.HitPos);
			entity:Spawn();
			
			if ( IsValid(itemEntity) ) then
				local physicsObject = itemEntity:GetPhysicsObject();
				
				entity:SetPos( itemEntity:GetPos() );
				entity:SetAngles( itemEntity:GetAngles() );
				
				if ( IsValid(physicsObject) ) then
					if ( !physicsObject:IsMoveable() ) then
						physicsObject = entity:GetPhysicsObject();
						
						if ( IsValid(physicsObject) ) then
							physicsObject:EnableMotion(false);
						end;
					end;
				end;
			else
				Clockwork.entity:MakeFlushToGround(entity, trace.HitPos, trace.HitNormal);
			end;
		else
			Schema:EasyText(player, "firebrick", "You cannot drop a radio that far away!");
			
			return false;
		end;
	end;

	-- Called when a player drops the item.
	function ITEM:OnDrop(player, position) end;
ITEM:Register();