--[[
	BEGOTTEN III: Developed by DETrooper, cash wednesday, gabs & alyousha35
--]]

netstream.Hook("DynamicAdverts", function(data)
	for k, v in ipairs(data) do
		cwDynamicAdverts:CacheMaterial(v)
	end

	cwDynamicAdverts.storedList = data
end)

netstream.Hook("DynamicAdvertAdd", function(data)
	cwDynamicAdverts:CacheMaterial(data)

	cwDynamicAdverts.storedList[#cwDynamicAdverts.storedList + 1] = data
end)

netstream.Hook("DynamicAdvertRemove", function(data)
	for k, v in ipairs(cwDynamicAdverts.storedList) do
		if (v.position == data) then
			table.remove(cwDynamicAdverts.storedList, k)
		end
	end
end)

function cwDynamicAdverts:CacheMaterial(data)
	if (data.material) then return end

	local exploded = string.Explode("/", data.url)
	local extension = "."..string.GetExtensionFromFilename(exploded[#exploded])
	local path = "clockwork/schemas/"..Clockwork.kernel:GetSchemaFolder().."/plugins/adverts/"..game.GetMap().."/"..util.CRC(data.url)..extension

	if (_file.Exists(path, "DATA")) then
		data.material = Material("../data/"..path, "noclamp smooth")
		return
	end

	local directories = string.Explode("/", path)
	local currentPath = ""

	for k, v in pairs(directories) do
		if (k < #directories) then
			currentPath = currentPath..v.."/"
			file.CreateDir(currentPath)
		end
	end

	http.Fetch(data.url, function(body, length, headers, code)
		path = path:gsub(".jpeg", ".jpg")
		file.Write(path, body)
		data.material = Material("../data/"..path, "noclamp smooth")
	end)
end