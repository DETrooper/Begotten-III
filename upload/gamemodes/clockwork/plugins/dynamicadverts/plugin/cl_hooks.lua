--[[
	BEGOTTEN III: Developed by DETrooper, cash wednesday, gabs & alyousha35
--]]

-- Called just after the translucent renderables have been drawn.
function cwDynamicAdverts:PostDrawTranslucentRenderables(bDrawingDepth, bDrawingSkybox)
	if (bDrawingSkybox or bDrawingDepth) then return end

	local eyePos = EyePos()
	local eyeAngles = EyeAngles()

	for k, v in pairs(self.storedList) do
		if (v.material) then
			cam.Start3D2D(v.position, v.angles, v.scale or 0.25)
				render.PushFilterMin(TEXFILTER.ANISOTROPIC)
				render.PushFilterMag(TEXFILTER.ANISOTROPIC)
					surface.SetDrawColor(255, 255, 255)
					surface.SetMaterial(v.material)
					surface.DrawTexturedRect(0, 0, v.width, v.height)
				render.PopFilterMag()
				render.PopFilterMin()
			cam.End3D2D()
		end
	end
end