/*--------------------------------------------------
	=============== Animals Autorun ===============
	*** Copyright (c) 2012-2015 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
INFO: Used to load autorun file for Animals
--------------------------------------------------*/
-- Addon Information(Important!):
	local PublicAddonName = "Animals"
	local AddonName = "Animals"
	local AddonType = "SNPC"
-- Don't edit anything below this! ------------------------------------------------

local VJExists = "lua/autorun/vj_base_autorun.lua"

if( file.Exists( VJExists, "GAME" ) ) then
	include('autorun/vj_controls.lua')
	AddCSLuaFile("autorun/vj_an_autorun.lua")
	AddCSLuaFile("autorun/vj_an_convar.lua")
	AddCSLuaFile("autorun/vj_an_spawn.lua")
	VJ.AddAddonProperty(AddonName,AddonType)
end

--[[
if CLIENT then
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then
	chat.AddText(Color(0,200,200),PublicAddonName,
	Color(0,255,0)," was unable to install, you are missing ",
	Color(255,100,0),"VJ Base!"
	)
	end
	hook.Add("AddToolMenuTabs", "VJ_CREATETOOLTABbs", function()
		spawnmenu.AddToolTab("DrVrej", "DrVrej", "vj_base/icons/animals.png")  
 
	end)	
	
end

timer.Simple(1,function()
	if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then
	if not VJF then
	if CLIENT then
	VJF = vgui.Create('DFrame')
	VJF:SetTitle("VJ Base is not installed")
	VJF:SetSize(900, 800)
	VJF:SetPos((ScrW() - VJF:GetWide()) / 2, (ScrH() - VJF:GetTall()) / 2)
	VJF:MakePopup()
	VJF.Paint = function()
	draw.RoundedBox( 8, 0, 0, VJF:GetWide(), VJF:GetTall(), Color( 200, 0, 0, 150 ) )
	end
	local VJURL = vgui.Create('DHTML')
	VJURL:SetParent(VJF)
	VJURL:SetPos(VJF:GetWide()*0.005, VJF:GetTall()*0.03)
	local x,y = VJF:GetSize()
	VJURL:SetSize(x*0.99,y*0.96)
	VJURL:SetAllowLua(true)
	VJURL:OpenURL('https://sites.google.com/site/vrejgaming/vjbasemissing')
	elseif SERVER then
	timer.Create("VJBASEMissing", 5, 0, function() print("VJ Base is Missing! Download it from the workshop!") end)
   end
  end
 end
end)
--]]