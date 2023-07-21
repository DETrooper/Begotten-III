-- Misc --

function math.DrG_Cycle(min, max, rate, offset)
  if not isnumber(min) then min = 0 end
  if not isnumber(max) then max = min+1 end
  if min > max then return math.DrG_Cycle(max, min, rate, offset) end
  local pi2 = math.pi*2
  return (((math.sin(((CurTime()-(offset or 0))*pi2*(rate or 1))%pi2)+1)/2)*(max-min))+min
end
