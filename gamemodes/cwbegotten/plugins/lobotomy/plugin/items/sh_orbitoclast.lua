local ITEM = Clockwork.item:New();
	ITEM.name = "Orbitoclast";
	ITEM.category = "Medical";
	ITEM.model = "models/begotten/orbitoclast.mdl";
	ITEM.weight = 0.15;
	ITEM.uniqueID = "orbitoclast";
	ITEM.description = "A mallet and large needle, used to perform lobotomies.";
	ITEM.iconoverride = "materials/begotten/ui/itemicons/orbitoclast.png";
	ITEM.stackable = false;
	ITEM.requiredBeliefs = {"surgeon"};

	ITEM.itemSpawnerInfo = {category = "Medical", rarity = 600, bNoSupercrate = true};

	ITEM.customFunctions = {"Lobotomize Self", "Lobotomize Target"};

	local useSounds = {"physics/flesh/flesh_squishy_impact_hard1.wav", "physics/flesh/flesh_squishy_impact_hard4.wav", "physics/flesh/flesh_bloody_impact_hard1.wav", "physics/flesh/flesh_bloody_impact_hard1.wav", "physics/flesh/flesh_bloody_impact_hard1.wav", "physics/flesh/flesh_bloody_break.wav"};

	local function DoTrace(player)
		local data = {}
		data.start = player:GetShootPos();
		data.endpos = data.start + player:GetAimVector() * 96;
		data.filter = player;

		return util.TraceLine(data);

	end

    if(SERVER) then
	    function ITEM:OnCustomFunction(player, name)
			if (!hook.Run("PlayerCanUseItem", player, self)) then return; end

	    	local target = player;

	    	if(name == "Lobotomize Target") then
	    		local tr = DoTrace(player);
	    		if(!IsValid(tr.Entity)) then Schema:EasyText(player, "firebrick", "You are not looking at anyone!"); return; end

	    		target = Clockwork.entity:GetPlayer(tr.Entity);
	    		if(!IsValid(target)) then Schema:EasyText(player, "firebrick", "You are not looking at anyone!"); return; end

	    		if(!target:IsRagdolled()) then Schema:EasyText(player, "chocolate", "To perform surgery on someone, they must be fallen over."); return; end

                if(target:HasTrait("lobotomite")) then Schema:EasyText(player, "chocolate", "They are already lobotomized!"); return; end

	    		Clockwork.chatBox:AddInTargetRadius(player, "me", "positions the needle towards their patient's brain, carefully hammering it into their skull.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);

	    	else
                if(player:HasTrait("lobotomite")) then Schema:EasyText(player, "chocolate", "You are already lobotomized!"); return; end

                Clockwork.chatBox:AddInTargetRadius(player, "me", "positions the needle towards their own brain, carefully hammering it into their skull.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
            
            end

	    	player:SetWeaponRaised(false);

	    	local consumeTime = 15;
	    	if(player:HasBelief("dexterity")) then consumeTime = consumeTime * 0.67; end

	    	local timerName = "lobotomy"..player:EntIndex();
	    	local index = 1;
	    	timer.Create(timerName, (consumeTime / #useSounds), #useSounds, function()
	    		if(!IsValid(player) or Clockwork.player:GetAction(player) != "lobotomy") then timer.Remove(timerName); return; end

	    		local trEntity = DoTrace(player).Entity;
	    		if(player != target and (!IsValid(target) or !IsValid(trEntity) or Clockwork.entity:GetPlayer(trEntity) != target)) then Clockwork.player:SetAction(player, false); timer.Remove(timerName); return; end

	    		player:EmitSound(useSounds[index], 75, math.random(97, 103));

                if(target:GetRagdollState() != RAGDOLL_KNOCKEDOUT) then target:TakeDamage(5); end

	    		index = index + 1;
            
	    	end);

	    	Clockwork.player:SetAction(player, "lobotomy", consumeTime,  _, function()
	    		if(!IsValid(target)) then Schema:EasyText(player, "firebrick", "You are not looking at anyone!"); return; end
	    		if(!player:HasItemByID("orbitoclast")) then Schema:EasyText(player, "firebrick", "You don't have the item for this action!"); return; end

	    		if(target:GetRagdollState() != RAGDOLL_KNOCKEDOUT) then
	    			Clockwork.chatBox:AddInTargetRadius(target, "me", "screams out in pain as part of their brain is brutally severed!", target:GetPos(), Clockwork.config:Get("talk_radius"):Get() * 2);
	    			target:TakeDamage(25);
	    			target:EmitSound("physics/body/body_medium_break3.wav");

	    		else target:EmitSound("physics/flesh/flesh_squishy_impact_hard1.wav"); end

	    		target:GiveTrait("lobotomite");

                if(!target:HasTrait("marked")) then
                    target:RemoveTrait("imbecile");
                    target:RemoveTrait("possessed");

                end

	    		player:HandleXP(50);

	    	end);

	    end

    end

	function ITEM:OnDrop(player, position) end

ITEM:Register();