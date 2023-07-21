--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

library.New("time", Clockwork)
library.New("date", Clockwork)

-- A function to get the time minute.
function Clockwork.time:GetMinute()
	if (CLIENT) then
		return netvars.GetNetVar("minute", 0)
	else
		return self.minute or 0
	end
end

-- A function to get the time hour.
function Clockwork.time:GetHour()
	if (CLIENT) then
		return netvars.GetNetVar("hour", 0)
	else
		return self.hour or 0
	end
end

-- A function to get the time day.
function Clockwork.time:GetDay()
	if (CLIENT) then
		return netvars.GetNetVar("day", 1)
	else
		return self.day or 1
	end
end

-- A function to get the day name.
function Clockwork.time:GetDayName()
	local defaultDays = {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"};

	if (defaultDays) then
		return defaultDays[tonumber(self:GetDay())] or "Unknown"
	end
end

if (SERVER) then
	function Clockwork.time:GetSaveData()
		return {
			minute = self:GetMinute(),
			hour = self:GetHour(),
			day = self:GetDay()
		}
	end

	-- A function to get the date save data.
	function Clockwork.date:GetSaveData()
		return {
			month = self:GetMonth(),
			year = self:GetYear(),
			day = self:GetDay()
		}
	end

	-- A function to get the date year.
	function Clockwork.date:GetYear()
		return self.year
	end

	-- A function to get the date month.
	function Clockwork.date:GetMonth()
		return self.month
	end

	-- A function to get the date day.
	function Clockwork.date:GetDay()
		return self.day
	end
else
	function Clockwork.date:GetString()
		return netvars.GetNetVar("date")
	end

	-- A function to get the time as a string.
	function Clockwork.time:GetString()
		local minute = Clockwork.kernel:ZeroNumberToDigits(self:GetMinute(), 2)
		local hour = Clockwork.kernel:ZeroNumberToDigits(self:GetHour(), 2)

		if (CW_CONVAR_TWELVEHOURCLOCK:GetInt() == 1) then
			hour = tonumber(hour)

			if (hour >= 12) then
				if (hour > 12) then
					hour = hour - 12
				end

				return Clockwork.kernel:ZeroNumberToDigits(hour, 2)..":"..minute.."pm"
			else
				return Clockwork.kernel:ZeroNumberToDigits(hour, 2)..":"..minute.."am"
			end
		else
			return hour..":"..minute
		end
	end
end