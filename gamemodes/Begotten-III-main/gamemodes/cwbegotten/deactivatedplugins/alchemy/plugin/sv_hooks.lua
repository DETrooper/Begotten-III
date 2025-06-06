--[[
	Begotten 3
	Created by cash wednesday, gabs, DETrooper and alyousha35
--]]

-- Called when a player's character data should be restored.
function cwAlchemy:PlayerRestoreCharacterData(player, data)
	if (!data["cwAlchemyExposure"]) then
		data["cwAlchemyExposure"] = {}
	end
end;

-- Called when a player's character has initialized.
function cwAlchemy:PlayerCharacterInitialized(player)
	
end

-- Called when a player's character data should be saved.
function cwAlchemy:PlayerSaveCharacterData(player, data) end;

-- Runs per second.
function cwAlchemy:OnePlayerSecond(player, curTime)
	local chemicals = player:GetCharacterData("cwAlchemyExposure") or {}
	local inventory = player:GetInventory()
	chemicals["regfire"]=cwAlchemy:ProcessFire(player, chemicals, 0)
	local detonation = chemicals["regfire"]>0
	for k, v in pairs(Clockwork.inventory:GetAsItemsList(inventory)) do		
		if v:GetData("ChemContents") then
			if player:IsRunning() then
				detonation = (detonation or cwAlchemy:DisturbContainer(player, v, math.random(1,100)))
			end
			cwAlchemy:InvFire(entity, item, chemicals, detonation)
		end
	end
end

-- Called when an item entity has taken damage.
function cwAlchemy:ItemEntityTakeDamage(itemEntity, itemTable, damageInfo)
	
end