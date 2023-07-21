local PLUGIN = PLUGIN

function PLUGIN:PrePACConfigApply(player)
	if !Clockwork.player:HasFlags(player, "W") then
		return false
	end
end

function PLUGIN:InitPostEntity()
	if pacx then
		function pacx.SetPlayerModel(ply, model)
			if model:find("^http") then
				pac.Message(ply, " wants to use ", model, " as player model")
				pac.DownloadMDL(model, function(path)
					pac.Message(model, " downloaded for ", ply)

					ply:SetModel(path)
					ply.pac_last_modifier_model = path:lower()
					ply.pac_url_playermodel = true
				end, function(err)
					pac.Message(err)
				end, ply)
			else
				if model == "" then
					model = Clockwork.player:GetDefaultModel(ply)
				else
					if not util.IsValidModel(model) then
						model = Clockwork.player:GetDefaultModel(ply)
					end
				end

				ply:SetModel(model)
				ply.pac_last_modifier_model = model:lower()
				ply.pac_url_playermodel = false
			end
		end
	end
end

function PLUGIN:PlayerCharacterLoaded(player)
	player:ConCommand("pac_clear_parts")
end;