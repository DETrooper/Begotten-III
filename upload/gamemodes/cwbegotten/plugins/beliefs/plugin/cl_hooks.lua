--[[
	Begotten 3
	Created by cash wednesday, gabs, DETrooper and alyousha35
--]]

local assassinDist = (800 * 800);
local bannerDist = (1024 * 1024);
local markedDist = (384 * 384);
local overlay;

function cwBeliefs:GetEntityMenuOptions(entity, options)
	if (entity:GetClass() == "prop_ragdoll") then
		local player = Clockwork.entity:GetPlayer(entity);

		if (!player or !player:Alive()) then
			if (self:HasBelief("savage")) then
				options["Mutilate"] = "cwCorpseMutilate";
			end;
			
			if (self:HasBelief("heart_eater")) then
				options["Eat Heart"] = "cwEatHeart";
			end;
			
			if (self:HasBelief("primeval")) then
				options["Harvest Bones"] = "cwHarvestBones";
			end;
		end;
	end;
end;

function cwBeliefs:AddEntityOutlines(outlines)
	if self.highlightTargetOverride then
		if IsValid(self.highlightTargetOverride) then
			self:DrawPlayerOutline(self.highlightTargetOverride, outlines, Color(180, 0, 0, 255));
		end
	end

	if self.upgradedWarcryActive then
		if self.trout then
			for k, v in pairs(_player.GetAll()) do
				if v.warcryTarget then
					self:DrawPlayerOutline(v, outlines, Color(120, 120, 120, 255));
				end;
			end;
		else
			for k, v in pairs(_player.GetAll()) do
				if v.warcryTarget and v:GetColor().a > 0 then
					self:DrawPlayerOutline(v, outlines, Color(180, 0, 0, 255));
				end
			end;
		end
	elseif Clockwork.Client:GetSharedVar("faith") == "Faith of the Dark" then
		local hasAssassin = self:HasBelief("assassin");
		
		for k, v in pairs(_player.GetAll()) do
			if v ~= Clockwork.Client and v:HasInitialized() and v:Alive() then
				if hasAssassin and v:Health() < v:GetMaxHealth() / 4 or v:GetRagdollState() == RAGDOLL_FALLENOVER then
					if (v:GetPos():DistToSqr(Clockwork.Client:GetPos()) <= assassinDist) then
						self:DrawPlayerOutline(v, outlines, Color(180, 0, 0, 255));
						
						return;
					end
				end
			
				if v:GetSharedVar("yellowBanner") == true then
					if (v:GetPos():DistToSqr(Clockwork.Client:GetPos()) <= bannerDist) then
						self:DrawPlayerOutline(v, outlines, Color(200, 200, 0, 255));
						
						return;
					end
				end
				
				if v:GetSharedVar("markedBySatanist") == true then
					if (v:GetPos():DistToSqr(Clockwork.Client:GetPos()) <= markedDist) then
						self:DrawPlayerOutline(v, outlines, Color(150, 0, 150, 255));
						
						return;
					end
				end
			end;
		end;
	end
end

function cwBeliefs:DrawPlayerOutline(player, outlines, color)
	if (player:GetMoveType() == MOVETYPE_WALK) then
		outlines:Add(player, color, 2, true);
	elseif player:IsRagdolled() then
		outlines:Add(player:GetRagdollEntity(), color, 2, true);
	end;
end;

-- Called when the target's marked status should be drawn.
function cwBeliefs:DrawTargetPlayerMarked(target, alpha, x, y)
	if target:GetSharedVar("markedBySatanist") == true then
		if (target:Alive()) then
			if Clockwork.Client:GetSharedVar("faith") == "Faith of the Dark" then
				local gender = "He";
				
				if (target:GetGender() == GENDER_FEMALE) then
					gender = "She";
				end;
			
				y = Clockwork.kernel:DrawInfo(Clockwork.kernel:ParseData(gender.." is marked for death for transgressions against the Dark Lord!"), x, y, Color(200, 0, 0), alpha);
				
				return y;
			end
		end
	end
end;

netstream.Hook("DeceitfulHighlight", function(data)
	if IsValid(data) and data:IsPlayer() then
		cwBeliefs.highlightTargetOverride = data;
	end
	
	if timer.Exists("deceitfulHighlightTimer_"..data:EntIndex()) then
		timer.Destroy("deceitfulHighlightTimer_"..data:EntIndex());
	end
	
	timer.Create("deceitfulHighlightTimer_"..data:EntIndex(), 30, 1, function()
		cwBeliefs.highlightTargetOverride = nil;
	end);
end);

netstream.Hook("TasteofBloodHighlight", function(data)
	if IsValid(data) and data:IsPlayer() then
		cwBeliefs.highlightTargetOverride = data;
	end
	
	timer.Create("tasteOfBloodTimer", 180, 1, function()
		cwBeliefs.highlightTargetOverride = nil;
	end);
end);

netstream.Hook("UpgradedWarcry", function(data)
	cwBeliefs.upgradedWarcryActive = true;
	
	local faith = Clockwork.Client:GetSharedVar("faith");
	
	for k, v in pairs(_player.GetAll()) do
		if v ~= Clockwork.Client and (v:HasInitialized()) then
			if v:GetSharedVar("faith") ~= faith then
				if (v:GetPos():DistToSqr(Clockwork.Client:GetPos()) <= (800 * 800)) then
					v.warcryTarget = true;
				end;
			end
		end;
	end;
	
	if cwBeliefs:HasBelief("fearsome_wolf") then		
		timer.Simple(20, function()
			cwBeliefs.upgradedWarcryActive = false;
			
			for k, v in pairs(_player.GetAll()) do
				v.warcryTarget = false;
			end;
		end);
	else
		if cwBeliefs:HasBelief("daring_trout") then
			cwBeliefs.trout = true;
		end
	
		timer.Simple(15, function()
			if cwBeliefs.trout then
				cwBeliefs.trout = false;
			end
			
			cwBeliefs.upgradedWarcryActive = false;
			
			for k, v in pairs(_player.GetAll()) do
				v.warcryTarget = false;
			end;
		end);
	end
end);