--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

-- A function to get the maximum weight a player can carry.
function cwBeliefs:PlayerAdjustMaxWeight(player, weight)
	local new_weight = weight;
	local subfaction = player:GetSubfaction();
	if subfaction == "Auxiliary" or subfaction == "Inquisition" or subfaction == "Rekh-khet-sa" or subfaction == "Clan Shagalax" or subfaction == "Servus" or subfaction == "The Guild" or subfaction == "House Caelvora"or subfaction == "Order Of The Writ" or subfaction == "Crypt Walkers" then
		new_weight = new_weight + 5;
	elseif subfaction == "Clan Grock" then
		new_weight = new_weight + 10;
	elseif subfaction == "House Herrera" then
		new_weight = new_weight + 8;
	end
	
	if player:HasBelief("might") then
		new_weight = new_weight + (weight * 0.25);
	end
	
	if player:HasBelief("prowess_finisher") then
		new_weight = new_weight + (weight * 0.4);
	end
	
	if player.GetCharmEquipped and player:GetCharmEquipped("spine_soldier") then
		new_weight = new_weight + (weight * 0.35);
	end
	
	weight = math.Round(new_weight);
	
	return weight;
end