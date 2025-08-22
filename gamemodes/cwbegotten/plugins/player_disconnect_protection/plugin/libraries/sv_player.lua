
function Clockwork.player:SetCharacterData(character, key, value)
	local oldValue = character.data[key]
	character.data[key] = value

	if (!netvars.AreEqual(value, oldValue)) then
		local characterData = self.characterData

		if (characterData[key] and characterData[key].callback2) then
			value = characterData[key].callback2(character, value)
		end

		--plugin.Call("PlayerCharacterDataChanged", self, key, oldValue, value)
		hook.Run("DisconnectedPlayerCharacterDataChanged", character, key, oldValue, value)
	end
end