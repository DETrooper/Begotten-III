function timer.DrG_Simple(delay, callback, ...)
	local args, n = table.DrG_Pack(...)
	timer.Simple(delay, function()
		callback(table.DrG_Unpack(args, n))
	end)
end

function timer.DrG_Loop(delay, callback, ...)
	local args, n = table.DrG_Pack(...)
	timer.Simple(delay, function()
		local res = callback(table.DrG_Unpack(args, n))
		if res == false then return end
		if isnumber(res) then
			timer.DrG_Loop(res, callback, table.DrG_Unpack(args, n))
		else timer.DrG_Loop(delay, callback, table.DrG_Unpack(args, n)) end
	end)
end
