--[[
	Begotten 3: Jesus Wept
	written by: cash wednesday, DETrooper, gabs and alyousha35.
--]]

netstream.Hook("Toothboy", function(data)
	Clockwork.Client:EmitSound("begotten/tb/tb_"..math.random(1, 40)..".mp3", 500, math.random(90, 100))

	timer.Simple(0.45, function()
		Clockwork.Client:EmitSound("begotten/tb/tb_speak.mp3", 500)
	end)
	
	timer.Simple(0.5, function()
		cwToothBoy:DoSanityZoom()
	end)
end)

-- A function to perform a vertigo zoom effect.
function cwToothBoy:DoSanityZoom(zoom, inverse)
	local zoom = zoom or -0.1
	local inverse = inverse or false
	
	if (zoom == 0) then
		zoom = -0.1
	end
	
	if (inverse and zoom > 0) then
		zoom = -zoom
	elseif (inverse and zoom < 0) then
		zoom = math.abs(zoom)
	end
	
	Clockwork.Client.SanityZoom = zoom
end