--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

if (SERVER) then
	AddCSLuaFile("shared.lua")
end;

SWEP.base = "weapon_base";

SWEP.PrintName = "Lantern";
SWEP.Author = "Buu342/cash wednesday";
SWEP.Purpose = "Illuminating dark areas.";
SWEP.Instructions = "";
SWEP.Category = "Lights";

SWEP.ViewModelFOV = 54;
SWEP.ViewModel 	= "models/weapons/c_lantern.mdl" 
SWEP.WorldModel = "models/weapons/w_begotten_melee.mdl"
SWEP.HoldType = "wos-begotten_1h" 

SWEP.Slot = 0;
SWEP.SlotPos = 0;
SWEP.DrawAmmo = false;
SWEP.DrawCrosshair = false;

SWEP.Spawnable = true;
SWEP.AdminSpawnable = true;

SWEP.Primary.Ammo 	= ""
SWEP.Secondary.Ammo = ""
SWEP.Primary.ClipSize 	= -1
SWEP.Secondary.ClipSize = -1
SWEP.Primary.DefaultClip 	= -1
SWEP.Secondary.DefaultClip 	= -1
 
SWEP.UseHands 		= true

SWEP.Offset = {
	Pos = {Right = 3, Forward = 1, Up = -16},
	Ang = {Right = 0, Forward = -5, Up = 78},
	Scale = Vector(.5, .5, .5)
};

SWEP.NoIronSightFovChange 	= true;
SWEP.NoIronSightAttack 		= true;
SWEP.IronSightPos 			= Vector(0, 0, 0);
SWEP.IronSightAng 			= Vector(0, 0, 0);
SWEP.NeverRaised 			= false;
SWEP.LoweredAngles 			= Angle(0, 0, -22)

SWEP.ViewModelFlip = false
SWEP.ShowViewModel = true

SWEP.ViewModelBoneMods = {
	["Bone04"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, -10.431), angle = Angle(-10.502, 0, 0) }
}

SWEP.VElements = {
	["element_name"] = { type = "Model", model = "models/weapons/w_lantern.mdl", bone = "Bone_Righthand", rel = "", pos = Vector(-4.189, -1.446, 8.227), angle = Angle(28.252, 28.072, 179.923), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["w_lantern"] = { type = "Model", model = "models/weapons/w_lantern.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(1, 2.9, 13), angle = Angle(5.843, -15.195, -171.818), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

function SWEP:Deploy()
	self.Owner:SetNetVar("lanternOnHip", false);
end;

function SWEP:Initialize()
	self:SetHoldType(self.HoldType);
	
	if CLIENT then
		self.WElements = table.FullCopy( self.WElements )
		self:CreateModels(self.WElements) // create worldmodels
		
		if IsValid(self.Owner) and self.Owner:IsPlayer() then
			local vm = self.Owner:GetViewModel()
			
			if IsValid(vm) then
				self:ResetBonePositions(vm)
			end
		end
	end
end

function SWEP:Holster()
	--[[if CLIENT and IsValid(self.Owner) then
		local vm = self.Owner:GetViewModel()
		
		if IsValid(vm) then
			self:ResetBonePositions(vm)
		end
	end]]--
	
	return true
end

function SWEP:OnRemove()
	self:Holster()
end

function SWEP:Think()
	if SERVER then
		local curTime = CurTime();
		local player = self.Owner;
		
		-- Last ditch effort to fix the clientside itemtable desync.
		if !self.nextItemSend or self.nextItemSend <= curTime then
			if IsValid(player) and player:IsPlayer() then
				local itemTable = item.GetByWeapon(self);
					
				if itemTable then
					item.SendToPlayer(player, itemTable);
				end
			end
			
			self.nextItemSend = curTime + math.random(1, 5);
		end
		
		if (IsValid(player)) then
			if (player:IsNPC() or player:IsNextBot()) then
				player:StripWeapon(self:GetClass());
				
				return;
			end;
		end;
	end
end;

if CLIENT then
	SWEP.wRenderOrder = nil

	function SWEP:DrawWorldModel()
		if (!self.wRenderOrder) then
			self.wRenderOrder = {}

			for k, v in pairs( self.WElements ) do
				if (v.type == "Model") then
					table.insert(self.wRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.wRenderOrder, k)
				end
			end
		end
		
		if (IsValid(self.Owner)) then
			bone_ent = self.Owner
		else
			bone_ent = self
		end
		
		for k, name in pairs( self.wRenderOrder ) do
			local v = self.WElements[name]
			
			if (!v) then self.wRenderOrder = nil break end
			if (v.hide) then continue end
			
			local pos, ang
			
			if (v.bone) then
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent )
			else
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent, "ValveBiped.Bip01_R_Hand" )
			end
			
			if (!pos) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (v.type == "Model" and IsValid(model)) then
				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				model:SetAngles(ang)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix( "RenderMultiply", matrix )
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end
				
				if IsValid(self.Owner) then
					if !self.Owner:IsWeaponRaised(self) then
						model:SetSkin(0)
					else
						model:SetSkin(1)
					end
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
			elseif (v.type == "Sprite" and sprite) then
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				
			elseif (v.type == "Quad" and v.draw_func) then
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()
			end
		end
	end;

	function SWEP:GetBoneOrientation( basetab, tab, ent, bone_override )
		
		local bone, pos, ang
		if (tab.rel and tab.rel != "") then
			
			local v = basetab[tab.rel]
			
			if (!v) then return end

			pos, ang = self:GetBoneOrientation( basetab, v, ent )
			
			if (!pos) then return end
			
			pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
		else
		
			bone = ent:LookupBone(bone_override or tab.bone)

			if (!bone) then return end
			
			pos, ang = Vector(0,0,0), Angle(0,0,0)
			local m = ent:GetBoneMatrix(bone)
			if (m) then
				pos, ang = m:GetTranslation(), m:GetAngles()
			end
			
			if (IsValid(self.Owner) and self.Owner:IsPlayer() and 
				ent == self.Owner:GetViewModel() and self.ViewModelFlip) then
				ang.r = -ang.r 
			end
		
		end
		
		return pos, ang
	end

	function SWEP:CreateModels( tab )

		if (!tab) then return end

		for k, v in pairs( tab ) do
			if (v.type == "Model" and v.model and v.model != "" and (!IsValid(v.modelEnt) or v.createdModel != v.model) and 
					string.find(v.model, ".mdl") and file.Exists (v.model, "GAME") ) then
				
				v.modelEnt = ClientsideModel(v.model, RENDER_GROUP_VIEW_MODEL_OPAQUE)
				if (IsValid(v.modelEnt)) then
					v.modelEnt:SetPos(self:GetPos())
					v.modelEnt:SetAngles(self:GetAngles())
					v.modelEnt:SetParent(self)
					v.modelEnt:SetNoDraw(true)
					v.createdModel = v.model
				else
					v.modelEnt = nil
				end
				
			elseif (v.type == "Sprite" and v.sprite and v.sprite != "" and (!v.spriteMaterial or v.createdSprite != v.sprite) 
				and file.Exists ("materials/"..v.sprite..".vmt", "GAME")) then
				
				local name = v.sprite.."-"
				local params = { ["$basetexture"] = v.sprite }
				local tocheck = { "nocull", "additive", "vertexalpha", "vertexcolor", "ignorez" }
				for i, j in pairs( tocheck ) do
					if (v[j]) then
						params["$"..j] = 1
						name = name.."1"
					else
						name = name.."0"
					end
				end

				v.createdSprite = v.sprite
				v.spriteMaterial = CreateMaterial(name,"UnlitGeneric",params)
				
			end
		end
		
	end

	local allbones
	local hasGarryFixedBoneScalingYet = false

	function SWEP:UpdateBonePositions(vm)
		
		if self.ViewModelBoneMods then
			
			if (!vm:GetBoneCount()) then return end
			
			local loopthrough = self.ViewModelBoneMods
			if (!hasGarryFixedBoneScalingYet) then
				allbones = {}
				for i=0, vm:GetBoneCount() do
					local bonename = vm:GetBoneName(i)
					if (self.ViewModelBoneMods[bonename]) then 
						allbones[bonename] = self.ViewModelBoneMods[bonename]
					else
						allbones[bonename] = { 
							scale = Vector(1,1,1),
							pos = Vector(0,0,0),
							angle = Angle(0,0,0)
						}
					end
				end
				
				loopthrough = allbones
			end
			// !! ----------- !! //
			
			for k, v in pairs( loopthrough ) do
				local bone = vm:LookupBone(k)
				if (!bone) then continue end
				
				// !! WORKAROUND !! //
				local s = Vector(v.scale.x,v.scale.y,v.scale.z)
				local p = Vector(v.pos.x,v.pos.y,v.pos.z)
				local ms = Vector(1,1,1)
				if (!hasGarryFixedBoneScalingYet) then
					local cur = vm:GetBoneParent(bone)
					while(cur >= 0) do
						local pscale = loopthrough[vm:GetBoneName(cur)].scale
						ms = ms * pscale
						cur = vm:GetBoneParent(cur)
					end
				end
				
				s = s * ms
				// !! ----------- !! //
				
				if vm:GetManipulateBoneScale(bone) != s then
					vm:ManipulateBoneScale( bone, s )
				end
				if vm:GetManipulateBoneAngles(bone) != v.angle then
					vm:ManipulateBoneAngles( bone, v.angle )
				end
				if vm:GetManipulateBonePosition(bone) != p then
					vm:ManipulateBonePosition( bone, p )
				end
			end
		else
			self:ResetBonePositions(vm)
		end
		   
	end
	 
	function SWEP:ResetBonePositions(vm)
		
		if (!vm:GetBoneCount()) then return end
		for i=0, vm:GetBoneCount() do
			vm:ManipulateBoneScale( i, Vector(1, 1, 1) )
			vm:ManipulateBoneAngles( i, Angle(0, 0, 0) )
			vm:ManipulateBonePosition( i, Vector(0, 0, 0) )
		end
		
	end
end

/**************************
	Global utility code
**************************/

function table.FullCopy( tab )

	if (!tab) then return nil end
	
	local res = {}
	for k, v in pairs( tab ) do
		if (type(v) == "table") then
			res[k] = table.FullCopy(v) // recursion ho!
		elseif (type(v) == "Vector") then
			res[k] = Vector(v.x, v.y, v.z)
		elseif (type(v) == "Angle") then
			res[k] = Angle(v.p, v.y, v.r)
		else
			res[k] = v
		end
	end
	
	return res
	
end

SWEP.RunArmOffset = Vector(0, 0, 0)				-- For realism
SWEP.RunArmAngle = Vector(-5.417, -5.654, 0)	-- REELIZM

SWEP.BobScale = 0  -- Real men code their own bob
SWEP.SwayScale = 2 -- I'm too lazy to code my own sway, plus this one works just fine soooooo....

SWEP.CrouchPos = Vector(-2,-2,-1) -- Moves the gun when you crouch for realism

if CLIENT then
	local TestVector = Vector(0,0,0)
	local TestVectorAngle = Vector(0,0,0)
	local TestVector2 = Vector(0,0,0)
	local TestVectorAngle2 = Vector(0,0,0)
	local TestVectorTarget = Vector(0,0,0)
	local TestVectorAngleTarget = Vector(0,0,0)
	local CrouchAng=0
	local CrouchAng2=0
	local Current_Aim = Angle(0,0,0)
	local Last_Aim = Angle(0,0,0)
	
	function SWEP:GetViewModelPosition(pos, ang)
		if !IsValid(self.Owner) then return end
		local ply = LocalPlayer()
		local weapon = ply:GetActiveWeapon()
		local walkspeed = self.Owner:GetVelocity():Length() 
		
        TestVector = LerpVector(5*FrameTime(),TestVector,TestVectorTarget) 
        TestVectorAngle = LerpVector(5*FrameTime(),TestVectorAngle,TestVectorAngleTarget)
		
		ang:RotateAroundAxis(ang:Right(),TestVectorAngle.x  )
		ang:RotateAroundAxis(ang:Up(),TestVectorAngle.y )
		ang:RotateAroundAxis(ang:Forward(),TestVectorAngle.z)
		
		pos = pos + TestVector.z * ang:Up()
		pos = pos + TestVector.y * ang:Forward()
		pos = pos + TestVector.x * ang:Right()
		if !IsValid(self.Owner) then return end
		
		local walkspeed = self.Owner:GetVelocity():Length() 
		if self.Owner:KeyDown(IN_SPEED) && !self.Owner:Crouching() && self.Owner:IsOnGround() && (self.Owner:KeyDown(IN_FORWARD) || self.Owner:KeyDown(IN_BACK) || self.Owner:KeyDown(IN_MOVELEFT) ||self.Owner:KeyDown(IN_MOVERIGHT)) then 
            TestVectorTarget = self.RunArmOffset
            TestVectorAngleTarget = self.RunArmAngle
		elseif self.Owner:Crouching() then
			TestVectorTarget = self.CrouchPos
            TestVectorAngleTarget = Vector(0,0,0)
		else
            TestVectorTarget = Vector(0,0,0)
            TestVectorAngleTarget = Vector(0,0,0)
        end
		
		local BreatTime = RealTime() * walkspeed/200
		local MoveForce = CalcMoveForce(LocalPlayer())
		TestVectorTarget = TestVectorTarget + Vector(0 ,0 , 0- math.Clamp(self.Owner:GetVelocity().z / 100,-3,3))
        
		--	Current_Aim = LerpAngle(0.1,Current_Aim,ply:GetAngles())
		--ply:ChatPrint(tostring(Current_Aim))
		
        -- I don't like the way I made this. I REALLY need to redo this part
        -- Be wary of tears
		-- BreatheSpeed -> Bigger = Faster
		-- BreatheAmplitude -> Bigger = Smaller amplitude
		if (self.Owner:IsOnGround() && self.Owner:Crouching() && (self.Owner:KeyDown(IN_FORWARD) || self.Owner:KeyDown(IN_BACK) || self.Owner:KeyDown(IN_MOVELEFT) ||self.Owner:KeyDown(IN_MOVERIGHT))) then
			BreatheSpeed = 10
			BreatheAmplitude = 3
        elseif self.Owner:IsOnGround() && !self.Owner:KeyDown(IN_WALK) && !self.Owner:KeyDown(IN_SPEED) && !self.Owner:Crouching() && self.Owner:IsOnGround() && (self.Owner:KeyDown(IN_FORWARD) || self.Owner:KeyDown(IN_BACK) || self.Owner:KeyDown(IN_MOVELEFT) ||self.Owner:KeyDown(IN_MOVERIGHT)) then
			BreatheSpeed = 16
			BreatheAmplitude = 0.9
		elseif self.Owner:IsOnGround() && (self.Owner:KeyDown(IN_WALK)|| self.Owner:Crouching())&& !self.Owner:KeyDown(IN_SPEED) && self.Owner:IsOnGround() && (self.Owner:KeyDown(IN_FORWARD) || self.Owner:KeyDown(IN_BACK) || self.Owner:KeyDown(IN_MOVELEFT) ||self.Owner:KeyDown(IN_MOVERIGHT)) then
			BreatheSpeed = 10
			BreatheAmplitude = 3
		elseif self.Owner:IsOnGround() && self.Owner:KeyDown(IN_SPEED) && self.Owner:IsOnGround() && (self.Owner:KeyDown(IN_FORWARD) || self.Owner:KeyDown(IN_BACK) || self.Owner:KeyDown(IN_MOVELEFT) ||self.Owner:KeyDown(IN_MOVERIGHT)) then
			BreatheSpeed = 20
			BreatheAmplitude = 0.3
		elseif self.Owner:IsOnGround() && walkspeed < 1 && !self.Owner:Crouching() then
			BreatheSpeed = 1
			BreatheAmplitude =  7
        else
            BreatheSpeed = 0
			BreatheAmplitude =  100000
		end
		
		local BreatTime = RealTime() * BreatheSpeed
		local MoveForce = CalcMoveForce(ply)
			
		TestVectorAngleTarget = TestVectorAngleTarget - Vector(math.cos(BreatTime) / BreatheAmplitude, (math.cos(BreatTime / 2) / BreatheAmplitude),0)
		
		/*--------------------------------------------
		--				Viewmodel Sway				--
		--------------------------------------------*/
		
		self.LastEyeSpeed = self.EyeSpeed
		
		Current_Aim = LerpAngle(5*FrameTime(), Current_Aim, ply:EyeAngles())
		
		self.EyeSpeed = Current_Aim - ply:EyeAngles()
		self.EyeSpeed.y = math.AngleDifference( Current_Aim.y, ply:EyeAngles().y ) -- Thank you MushroomGuy for telling me this function even existed
		
		ang:RotateAroundAxis(ang:Right(), math.Clamp(4*self.EyeSpeed.p/60,-4,4))
		ang:RotateAroundAxis(ang:Up(), math.Clamp(-4*self.EyeSpeed.y/60,-4,4))

		pos = pos + math.Clamp((-1.5*self.EyeSpeed.p/60),-1.5,1.5) * ang:Up()
		pos = pos + math.Clamp((-1.5*self.EyeSpeed.y/60),-1.5,1.5) * ang:Right()
		return pos, ang

	end
end

function CalcMoveForce(ply)
    if !IsValid(LocalPlayer()) then return end
    local weapon = ply:GetActiveWeapon()
    MoveForce = ply:GetFOV()
    if !ply:Crouching() then
        if IsValid(weapon) then
            MoveForce = ply:GetFOV() * 10
        else
            MoveForce = ply:GetFOV() * 50
        end
    else
        MoveForce = ply:GetFOV() * 120
    end
   
    return MoveForce
end

function SWEP:PrimaryAttack() end;

function SWEP:SecondaryAttack() end;