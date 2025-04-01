if CLIENT then return end

local NAVAREAS_CENTERS = {}
function navmesh.DrG_GetAreaFromCenter(pos)
	return NAVAREAS_CENTERS[tostring(pos)]
end
for i, area in ipairs(navmesh.GetAllNavAreas()) do
	NAVAREAS_CENTERS[tostring(area:GetCenter())] = area
end
