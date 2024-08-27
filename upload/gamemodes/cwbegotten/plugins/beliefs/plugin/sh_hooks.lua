--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

-- A function to get the maximum weight a player can carry.
function cwBeliefs:PlayerAdjustMaxWeight(player, weight)
	local new_weight = weight;
	
	if player:HasBelief("might") then
		new_weight = new_weight + (weight * 0.5);
	end
	
	if player:HasBelief("prowess_finisher") then
		new_weight = new_weight + (weight * 0.5);
	end
	
	if player.GetCharmEquipped and player:GetCharmEquipped("spine_soldier") then
		new_weight = new_weight + (weight * 0.25);
	end
	
	weight = math.Round(new_weight);
	
	return weight;
end