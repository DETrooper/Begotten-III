--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

include("shared.lua");

-- Called when the entity should be drawn opaquely.
function ENT:Draw()
	if (IsValid(self.Entity:GetParent()) and self.Entity:GetParent():GetMoveType() != MOVETYPE_NOCLIP) then
		self.Entity:DrawModel();
	end;

	self.Entity:DrawShadow(true);
end;


-- A function to scale a bone.
function ENT:ScaleBone(self, realBoneID, scale)
	local boneMatrix = self:GetBoneMatrix(realBoneID);
	
	if (boneMatrix) then
		boneMatrix:Scale(Vector(scale, scale, scale));
		
		self:SetBoneMatrix(realBoneID, boneMatrix);
	end;
end;

local torso = {
	"ValveBiped.Bip01_Head1",
	"ValveBiped.Bip01_L_Hand",
	"ValveBiped.Bip01_R_Hand",
	"ValveBiped.Bip01_L_Finger0",
	"ValveBiped.Bip01_L_Finger1",
	"ValveBiped.Bip01_L_Finger2",
	"ValveBiped.Bip01_L_Finger3",
	"ValveBiped.Bip01_L_Finger4",
	"ValveBiped.Bip01_L_Finger01",
	"ValveBiped.Bip01_L_Finger02",
	"ValveBiped.Bip01_L_Finger11",
	"ValveBiped.Bip01_L_Finger12",
	"ValveBiped.Bip01_L_Finger21",
	"ValveBiped.Bip01_L_Finger22",
	"ValveBiped.Bip01_L_Finger31",
	"ValveBiped.Bip01_L_Finger32",
	"ValveBiped.Bip01_L_Finger41",
	"ValveBiped.Bip01_L_Finger42",
	"ValveBiped.Bip01_R_Finger0",
	"ValveBiped.Bip01_R_Finger1",
	"ValveBiped.Bip01_R_Finger2",
	"ValveBiped.Bip01_R_Finger3",
	"ValveBiped.Bip01_R_Finger4",
	"ValveBiped.Bip01_R_Finger01",
	"ValveBiped.Bip01_R_Finger02",
	"ValveBiped.Bip01_R_Finger11",
	"ValveBiped.Bip01_R_Finger12",
	"ValveBiped.Bip01_R_Finger21",
	"ValveBiped.Bip01_R_Finger22",
	"ValveBiped.Bip01_R_Finger31",
	"ValveBiped.Bip01_R_Finger32",
	"ValveBiped.Bip01_R_Finger41",
	"ValveBiped.Bip01_R_Finger42",
	"ValveBiped.Bip01_R_Thigh",
	"ValveBiped.Bip01_R_Calf",
	"ValveBiped.Bip01_R_Foot",
	"ValveBiped.Bip01_R_Toe0",
	"ValveBiped.Bip01_L_Thigh",
	"ValveBiped.Bip01_L_Calf",
	"ValveBiped.Bip01_L_Foot",
	"ValveBiped.Bip01_L_Toe0",
	--"ValveBiped.Bip01_Pelvis"
}

local glovesHands = {
	"ValveBiped.Bip01_L_Finger0",
	"ValveBiped.Bip01_L_Finger1",
	"ValveBiped.Bip01_L_Finger2",
	"ValveBiped.Bip01_L_Finger3",
	"ValveBiped.Bip01_L_Finger4",
	"ValveBiped.Bip01_L_Finger01",
	"ValveBiped.Bip01_L_Finger02",
	"ValveBiped.Bip01_L_Finger11",
	"ValveBiped.Bip01_L_Finger12",
	"ValveBiped.Bip01_L_Finger21",
	"ValveBiped.Bip01_L_Finger22",
	"ValveBiped.Bip01_L_Finger31",
	"ValveBiped.Bip01_L_Finger32",
	"ValveBiped.Bip01_L_Finger41",
	"ValveBiped.Bip01_L_Finger42",
	"ValveBiped.Bip01_R_Finger0",
	"ValveBiped.Bip01_R_Finger1",
	"ValveBiped.Bip01_R_Finger2",
	"ValveBiped.Bip01_R_Finger3",
	"ValveBiped.Bip01_R_Finger4",
	"ValveBiped.Bip01_R_Finger01",
	"ValveBiped.Bip01_R_Finger02",
	"ValveBiped.Bip01_R_Finger11",
	"ValveBiped.Bip01_R_Finger12",
	"ValveBiped.Bip01_R_Finger21",
	"ValveBiped.Bip01_R_Finger22",
	"ValveBiped.Bip01_R_Finger31",
	"ValveBiped.Bip01_R_Finger32",
	"ValveBiped.Bip01_R_Finger41",
	"ValveBiped.Bip01_R_Finger42",
	"ValveBiped.Bip01_L_Hand",
	"ValveBiped.Bip01_R_Hand"
}

local gloves = {
	"ValveBiped.Bip01_L_Finger0",
	"ValveBiped.Bip01_L_Finger1",
	"ValveBiped.Bip01_L_Finger2",
	"ValveBiped.Bip01_L_Finger3",
	"ValveBiped.Bip01_L_Finger4",
	"ValveBiped.Bip01_L_Finger01",
	"ValveBiped.Bip01_L_Finger02",
	"ValveBiped.Bip01_L_Finger11",
	"ValveBiped.Bip01_L_Finger12",
	"ValveBiped.Bip01_L_Finger21",
	"ValveBiped.Bip01_L_Finger22",
	"ValveBiped.Bip01_L_Finger31",
	"ValveBiped.Bip01_L_Finger32",
	"ValveBiped.Bip01_L_Finger41",
	"ValveBiped.Bip01_L_Finger42",
	"ValveBiped.Bip01_R_Finger0",
	"ValveBiped.Bip01_R_Finger1",
	"ValveBiped.Bip01_R_Finger2",
	"ValveBiped.Bip01_R_Finger3",
	"ValveBiped.Bip01_R_Finger4",
	"ValveBiped.Bip01_R_Finger01",
	"ValveBiped.Bip01_R_Finger02",
	"ValveBiped.Bip01_R_Finger11",
	"ValveBiped.Bip01_R_Finger12",
	"ValveBiped.Bip01_R_Finger21",
	"ValveBiped.Bip01_R_Finger22",
	"ValveBiped.Bip01_R_Finger31",
	"ValveBiped.Bip01_R_Finger32",
	"ValveBiped.Bip01_R_Finger41",
	"ValveBiped.Bip01_R_Finger42"
}

local pants = {
	"ValveBiped.Bip01_Pelvis",
	"ValveBiped.Bip01_R_Thigh",
	"ValveBiped.Bip01_R_Calf",
	"ValveBiped.Bip01_R_Foot",
	"ValveBiped.Bip01_R_Toe0",
	"ValveBiped.Bip01_L_Thigh",
	"ValveBiped.Bip01_L_Calf",
	"ValveBiped.Bip01_L_Foot",
	"ValveBiped.Bip01_L_Toe0"
};

local glovesHead = {
	"ValveBiped.Bip01_L_Finger0",
	"ValveBiped.Bip01_L_Finger1",
	"ValveBiped.Bip01_L_Finger2",
	"ValveBiped.Bip01_L_Finger3",
	"ValveBiped.Bip01_L_Finger4",
	"ValveBiped.Bip01_L_Finger01",
	"ValveBiped.Bip01_L_Finger02",
	"ValveBiped.Bip01_L_Finger11",
	"ValveBiped.Bip01_L_Finger12",
	"ValveBiped.Bip01_L_Finger21",
	"ValveBiped.Bip01_L_Finger22",
	"ValveBiped.Bip01_L_Finger31",
	"ValveBiped.Bip01_L_Finger32",
	"ValveBiped.Bip01_L_Finger41",
	"ValveBiped.Bip01_L_Finger42",
	"ValveBiped.Bip01_R_Finger0",
	"ValveBiped.Bip01_R_Finger1",
	"ValveBiped.Bip01_R_Finger2",
	"ValveBiped.Bip01_R_Finger3",
	"ValveBiped.Bip01_R_Finger4",
	"ValveBiped.Bip01_R_Finger01",
	"ValveBiped.Bip01_R_Finger02",
	"ValveBiped.Bip01_R_Finger11",
	"ValveBiped.Bip01_R_Finger12",
	"ValveBiped.Bip01_R_Finger21",
	"ValveBiped.Bip01_R_Finger22",
	"ValveBiped.Bip01_R_Finger31",
	"ValveBiped.Bip01_R_Finger32",
	"ValveBiped.Bip01_R_Finger41",
	"ValveBiped.Bip01_R_Finger42",
	"ValveBiped.Bip01_Head1",
	"ValveBiped.Bip01_Neck1",
	"Bip01_ponytail",
	"Bip01_ponytail1",
	"Bip01_ponytail2",
	"Bip01_ponytail3",
	"Bip01_ponytail4",
	"HairN",
	"LMomi01N",
	"LMomi02N",
	"Ponytail01N",
	"Ponytail02N",
	"Ponytail03N",
	"RMomi01N",
	"RMomi02N",
	"ValveBiped.Bip01_hair10",
	"ValveBiped.Bip01_hair20",
	"ValveBiped.Bip01_hair30",
	"ValveBiped.Bip01_hair40",
	"ValveBiped.Bip01_hair1",
	"ValveBiped.Bip01_hair2",
	"ValveBiped.Bip01_hair3",
	"ValveBiped.Bip01_hair4",
	"ValveBiped.Bip01_hair5",
	"ValveBiped.Bip01_hair6",
	"ValveBiped.Bip01_hair7",
	"ValveBiped.Bip01_hair8",
	"ValveBiped.Bip01_hair9",
	"ValveBiped.Bip01_hair11",
	"ValveBiped.Bip01_hair12",
	"ValveBiped.Bip01_hair13",
	"ValveBiped.Bip01_hair14",
	"ValveBiped.Bip01_hair15",
	"ValveBiped.Bip01_hair16",
	"ValveBiped.Bip01_hair17",
	"ValveBiped.Bip01_hair18",
	"ValveBiped.Bip01_hair19",
	"ValveBiped.Bip01_hair21",
	"ValveBiped.Bip01_hair22",
	"ValveBiped.Bip01_hair23",
	"ValveBiped.Bip01_hair24",
	"ValveBiped.Bip01_hair25",
	"ValveBiped.Bip01_hair26",
	"ValveBiped.Bip01_hair27",
	"ValveBiped.Bip01_hair28",
	"ValveBiped.Bip01_hair29",
	"ValveBiped.Bip01_hair31",
	"ValveBiped.Bip01_hair32",
	"ValveBiped.Bip01_hair33",
	"ValveBiped.Bip01_hair34",
	"ValveBiped.Bip01_hair35",
	"ValveBiped.Bip01_hair36",
	"ValveBiped.Bip01_hair37",
	"ValveBiped.Bip01_hair38",
	"ValveBiped.Bip01_hair39",
	"ValveBiped.Bip01_hair41",
	"ValveBiped.Bip01_hair42",
	"ValveBiped.Bip01_hair43",
	"ValveBiped.Bip01_hair44",
	"ValveBiped.Bip01_hair45",
	"Head",
	"headBase",
	"brow_Left",
	"brow_right",
	"eyeBlink_Right",
	"outBrow_left",
	"outBrow_Right",
	"underEye_left",
	"underEye_Right",
	"mouthBase",
	"cheek_Left",
	"cheek_right",
	"innerUpperLip_Left",
	"upperLip_Left",
	"innerUpperLip_right",
	"upperLip_right",
	"jawBone",
	"innerLowLip_right",
	"lowerLip_right",
	"innerLowLip_left",
	"lowerLip_Left",
	"LowerCheek_left",
	"lowerCheek_right",
	"Tongue",
	"outerUpperLip_left",
	"LipCorner_Left",
	"outerUpperLip_right",
	"LipCorner_right",
	"Eye_Right",
	"Eye_Left",
	"lowLid_Right",
	"eyeBlink_Left",
	"lowLid_Left",
	"Sneer",
	"Neck",
	"Neck1"
};

local head = {
	"ValveBiped.Bip01_Head1",
	"ValveBiped.Bip01_Neck1",
	"Bip01_ponytail",
	"Bip01_ponytail1",
	"Bip01_ponytail2",
	"Bip01_ponytail3",
	"Bip01_ponytail4",
	"HairN",
	"LMomi01N",
	"LMomi02N",
	"Ponytail01N",
	"Ponytail02N",
	"Ponytail03N",
	"RMomi01N",
	"RMomi02N",
	"ValveBiped.Bip01_hair10",
	"ValveBiped.Bip01_hair20",
	"ValveBiped.Bip01_hair30",
	"ValveBiped.Bip01_hair40",
	"ValveBiped.Bip01_hair1",
	"ValveBiped.Bip01_hair2",
	"ValveBiped.Bip01_hair3",
	"ValveBiped.Bip01_hair4",
	"ValveBiped.Bip01_hair5",
	"ValveBiped.Bip01_hair6",
	"ValveBiped.Bip01_hair7",
	"ValveBiped.Bip01_hair8",
	"ValveBiped.Bip01_hair9",
	"ValveBiped.Bip01_hair11",
	"ValveBiped.Bip01_hair12",
	"ValveBiped.Bip01_hair13",
	"ValveBiped.Bip01_hair14",
	"ValveBiped.Bip01_hair15",
	"ValveBiped.Bip01_hair16",
	"ValveBiped.Bip01_hair17",
	"ValveBiped.Bip01_hair18",
	"ValveBiped.Bip01_hair19",
	"ValveBiped.Bip01_hair21",
	"ValveBiped.Bip01_hair22",
	"ValveBiped.Bip01_hair23",
	"ValveBiped.Bip01_hair24",
	"ValveBiped.Bip01_hair25",
	"ValveBiped.Bip01_hair26",
	"ValveBiped.Bip01_hair27",
	"ValveBiped.Bip01_hair28",
	"ValveBiped.Bip01_hair29",
	"ValveBiped.Bip01_hair31",
	"ValveBiped.Bip01_hair32",
	"ValveBiped.Bip01_hair33",
	"ValveBiped.Bip01_hair34",
	"ValveBiped.Bip01_hair35",
	"ValveBiped.Bip01_hair36",
	"ValveBiped.Bip01_hair37",
	"ValveBiped.Bip01_hair38",
	"ValveBiped.Bip01_hair39",
	"ValveBiped.Bip01_hair41",
	"ValveBiped.Bip01_hair42",
	"ValveBiped.Bip01_hair43",
	"ValveBiped.Bip01_hair44",
	"ValveBiped.Bip01_hair45",
	"Head",
	"headBase",
	"brow_Left",
	"brow_right",
	"eyeBlink_Right",
	"outBrow_left",
	"outBrow_Right",
	"underEye_left",
	"underEye_Right",
	"mouthBase",
	"cheek_Left",
	"cheek_right",
	"innerUpperLip_Left",
	"upperLip_Left",
	"innerUpperLip_right",
	"upperLip_right",
	"jawBone",
	"innerLowLip_right",
	"lowerLip_right",
	"innerLowLip_left",
	"lowerLip_Left",
	"LowerCheek_left",
	"lowerCheek_right",
	"Tongue",
	"outerUpperLip_left",
	"LipCorner_Left",
	"outerUpperLip_right",
	"LipCorner_right",
	"Eye_Right",
	"Eye_Left",
	"lowLid_Right",
	"eyeBlink_Left",
	"lowLid_Left",
	"Sneer",
	"Neck",
	"Neck1"
};

local headAddUp = {
	["ValveBiped.Bip01_Head1"] = 3,
	["ValveBiped.Bip01_Neck1"] = 3
};

--[[
	-- 0: Entire model
	-- 1: Only torso
	-- 2: Only head
	-- 3: Only hands
	-- 4: Only pants
	-- 5: No torso
	-- 6: No head
	-- 7: No hands
	-- 8: No pants
--]]

--lrs "cwParts:HandleClothing(Clockwork.player:FindByID('NAME'), 'models/gman_high.mdl', 6)"
--lrs "local sa = Clockwork.player:FindByID('NAME') cwParts:HandleClothing(sa, 'models/Humans/Group01/Male_Cheaple.mdl', 2, 0, true)"
--lrs "Clockwork.player:FindByID('NAME'):SetMaterial('effects/water_warp01');"

-- Called when the entity initializes.
function ENT:Initialize()	
	self:AddCallback("BuildBonePositions", function(self, numBones)
		if (IsValid(self)) then
			local partType = self.Entity:GetDTInt(1);
			local inverse = false;
			local headInflate = {};
			local exceptions = {};
			local boneTable = {};
			local index = 0;

			if (partType == 0) then
				inverse = true;
			elseif (partType == 1) then
				exceptions = torso;
				inverse = true;
			elseif (partType == 2) then
				exceptions = head;
			elseif (partType == 3) then
				exceptions = gloves;
			elseif (partType == 4) then
				exceptions = pants;
			elseif (partType == 5) then
				exceptions = torso;
			elseif (partType == 6) then
				exceptions = head;
				inverse = true;
			elseif (partType == 7) then
				exceptions = gloves;
				inverse = true;
			elseif (partType == 8) then
				exceptions = pants;
				inverse = true;
			elseif (partType == 9) then
				exceptions = glovesHead;
				inverse = true;
			elseif (partType == 10) then
				exceptions = glovesHands;
				inverse = false;
			end;
			
			for k, v in pairs(exceptions) do
				index = self.Entity:LookupBone(v);
				
				table.insert(boneTable, index);
			end;
			
			for k, v in pairs(headAddUp) do
				index = self.Entity:LookupBone(k);

				headInflate[k] = index;
			end;

			for i = 0, numBones do
				if (inverse) then
					if (table.HasValue(boneTable, i)) then
						self:ScaleBone(self, i, 0);
					end;
				else
					if (!table.HasValue(boneTable, i, 0)) then
						self:ScaleBone(self, i, 0);
					end;
					
					if (table.HasValue(headInflate, i)) then
						for k, v in pairs(headInflate) do
							if (i == v) then
								self:ScaleBone(self, i, self.Entity:GetDTInt(headAddUp[k]));
								
								break;
							end;
						end;
					end;
				end;
			end;
		end;
	end);
end;