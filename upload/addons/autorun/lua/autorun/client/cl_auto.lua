local length = 0.5 -- animation length.
local ease = 0.25 -- easing animation IN and OUT.
local amount = 25 -- scroll amount.

hook.Add( "PreGamemodeLoaded", "Reloaded_DVScrollBar_Control", function()
	local dermaCtrs = vgui.GetControlTable( "DVScrollBar" )

	local tScroll = 0
	local newerT = 0

	function dermaCtrs:AddScroll( dlta )

		local OldScroll = self:GetScroll()

		dlta = dlta * amount
		
		local anim = self:NewAnimation( length, 0, ease )
		anim.StartPos = OldScroll
		anim.TargetPos = OldScroll + dlta + tScroll
		tScroll = tScroll + dlta

		local ctime = CurTime()
		newerT = ctime
		
		anim.Think = function( anim, pnl, fraction )
			if ctime == newerT then
				self:SetScroll( Lerp( fraction, anim.StartPos, anim.TargetPos ) )
				tScroll = tScroll - (tScroll * fraction)
			end
		end

		return OldScroll != self:GetScroll()

	end

	derma.DefineControl( "DVScrollBar", "Smooth Scrollbar", dermaCtrs, "Panel" )
end )

concommand.Add("testarc", function()
	if LocalPlayer():IsAdmin() then
		local pos = LocalPlayer():GetShootPos();
		local aimVector = LocalPlayer():GetAimVector();
		local meleeArc = GetTable(LocalPlayer():GetActiveWeapon().AttackTable).meleearc;
		local meleeRange = GetTable(LocalPlayer():GetActiveWeapon().AttackTable).meleerange / 10;

		debugoverlay.Line(pos, pos + (aimVector * meleeRange), 5);
		
		for i = 1, meleeArc - 1 do
			local newAimVector = Vector(aimVector);
		
			if (i % 2 == 0) then
				-- If even go left.
				newAimVector:Rotate(Angle(0, math.Round(i / 2), 0));
			else
				-- If odd go right.
				newAimVector:Rotate(Angle(0, -math.Round(i / 2), 0));
			end
			
			debugoverlay.Line(pos, pos + (newAimVector * meleeRange), 5);
		end
	end
end);