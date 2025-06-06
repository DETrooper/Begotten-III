local PLUGIN = PLUGIN

function PLUGIN:PrePACEditorOpen(player)
	if !Clockwork.player:HasFlags(player, "W") then
		return false
	end
end

function PLUGIN:InitPostEntity()
    local follow_entity = GetConVar("pac_camera_follow_entity")
    local lastEntityPos
    --local cwThirdPerson = GetConVar("cwThirdPerson")
   -- local cwthird = cwThirdPerson:GetInt()

   if pace then
		function pace.CalcView(ply, pos, ang, fov)
			if pace.editing_viewmodel then
				pace.ViewPos = pos
				pace.ViewAngles = ang
				pace.ViewFOV = fov
			return end

			if follow_entity:GetBool() then
				local ent = pace.GetViewEntity()
				local pos = ent:GetPos()
				lastEntityPos = lastEntityPos or pos
				pace.ViewPos = pace.ViewPos + pos - lastEntityPos
				lastEntityPos = pos
			else
				lastEntityPos = nil
			end

			local pos, ang, fov = pac.CallHook("EditorCalcView", pace.ViewPos, pace.ViewAngles, pace.ViewFOV)

			if pos then
				pace.ViewPos = pos
			end

			if ang then
				pace.ViewAngles = ang
			end

			if fov then
				pace.ViewFOV = fov
			end

			return
			{
				origin = pace.ViewPos,
				angles = pace.ViewAngles,
				fov = pace.ViewFOV,
				drawviewer = pace.ShouldDrawLocalPlayer(),
			}
		end

		function pace.CloseEditor()
			pace.RestoreExternalHooks()

			if pace.Editor:IsValid() then
				pace.Editor:OnRemove()
				pace.Editor:Remove()
				pace.Active = false
				pace.Call("CloseEditor")

				if pace.timeline.IsActive() then
					pace.timeline.Close()
				end
			end

			--[[if IsValid(cwThirdPerson) then
				RunConsoleCommand("cwThirdPerson", tostring(cwthird))
			end]]--

			RunConsoleCommand("pac_in_editor", "0")
			pace.SetInPAC3Editor(false)
		end

		function pace.OpenEditor()
			pace.CloseEditor()

			if hook.Run("PrePACEditorOpen", LocalPlayer()) == false then return end

			pac.Enable()

			pace.RefreshFiles()

			pace.SetLanguage()

			local editor = pace.CreatePanel("editor")
				editor:SetSize(240, ScrH())
				editor:MakePopup()
				editor.Close = function()
					editor:OnRemove()
					pace.CloseEditor()
				end
			pace.Editor = editor
			pace.Active = true

			if ctp and ctp.Disable then
				ctp:Disable()
			end

		   --[[ if IsValid(cwThirdPerson) then
				cwthird = cwThirdPerson:GetInt()
				RunConsoleCommand("cwThirdPerson", "0")
			end]]--

			RunConsoleCommand("pac_in_editor", "1")
			pace.SetInPAC3Editor(true)

			pace.DisableExternalHooks()

			pace.Call("OpenEditor")
		end

		timer.Create("pac_in_editor", 0.25, 0, function()
			if not pace.current_part:IsValid() then return end

			net.Start("pac_in_editor_posang", true)
				net.WriteVector(pace.GetViewPos())
				net.WriteAngle(pace.GetViewAngles())
				net.WriteVector((pace.mctrl.GetTargetPos()) or pace.current_part:GetDrawPosition() or vector_origin)
			net.SendToServer()
		end)

		--[[local old = pace.ClearParts
		function pace.ClearParts()
			old()

			pacx.SetModel(Clockwork.player:GetDefaultModel(LocalPlayer()))
		end]]
	end
end