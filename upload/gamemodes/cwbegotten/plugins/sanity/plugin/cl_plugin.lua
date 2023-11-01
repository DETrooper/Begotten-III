--[[
	Begotten III: Jesus Wept
--]]

local playerMeta = FindMetaTable("Player")

cwSanity.slowDownSpeechSounds = {
	"vo/npc/male01/answer03.wav",
	"vo/npc/male01/answer07.wav",
	"vo/npc/male01/answer09.wav",
	"vo/npc/male01/answer11.wav",
	"vo/npc/male01/answer13.wav",
	"vo/npc/male01/answer20.wav",
	"vo/npc/male01/answer22.wav",
	"vo/npc/male01/answer25.wav",
	"vo/npc/male01/answer30.wav",
	"vo/npc/male01/answer32.wav",
	"vo/npc/male01/answer33.wav",
	"vo/npc/male01/answer34.wav",
	"vo/npc/male01/answer36.wav",
	"vo/npc/male01/answer32.wav",
	"vo/npc/male01/answer40.wav",
};

cwSanity.backpackSayings = {
	"Let us out of here!", "Hello? Can anyone hear me?", "Let me go!", "Hey! I know you can hear me! Let us out!", "We just want to go home, let us out!", "We want to leave! Let us go!", "Someone help us, we're being kidnapped!", "Get us out of here!",
};

cwSanity.cannibalSayings = {
	"Mmmmm, don't I just look delectable?", "You ever had our sausages?", "Fresh meat, right here!", "Come on and chow down!", "Why don't you come over here and take a bite of me?", "Yummy meats, right here!", "I'm the best cut of meat you'll ever have!", "Dig in!",
};

cwSanity.corpseSayings = {
	"Help me up, would you!?", "I don't feel so good...", "What's happening to me...?", "Help me!", "I can't feel my legs!", "Hey you! Give me a hand!", "Won't you stay with me a while?", "Please...", "Hello, friend!", "Why... why me...?", "Say, you wouldn't happen to know who killed me, right?",
};

cwSanity.itemSayings = {
	["Drinks"] = {"Slurp me up mister!", "Slurp my juicies!", "Want a drink?"},
	["Firearms"] = {"Hey, you should use me to blow your brains out.", "I just wanna shoot and kill and blow fucklets away!", "Why don't you use me to kill those friends of yours?"},
	["Food"] = {"Don't eat me, please! I have a family!", "I don't want to die! Please don't eat me!", "Stay away from me!"},
	["Junk"] = {"Hahahahaha!", "Am I just junk to you? Why am I not good enough?", "Hey! You! Stop ignoring me and pick me up!", "I keep hearing voices in my head.", "WAKE UP!"},
	["Melee"] = {"How's it going, friend?", "Pick me up already! What are you waiting for?!", "It's a fine day to stab some people, huh?"},
};

cwSanity.radioSayings = {
	"DO YOU HEAR THEM?", "THE MOON SEES ME.", "AAAAAAAAAAAAAAAAAAAAAAAAAAAA!!!!!", "I DEMAND WHO IS THE MAN WITH NO EYES.", "STANDING IN THE DARK ROOM, THE BABY YELLS. MAKE THE BABY SLEEP ONCE MORE.", "THE SCREAMING, THE SCREAMING.", "WILL THEY KNOW?", "I SEE YOU.",
};

-- A function to get the local player's sanity level.
function playerMeta:Sanity()
	return self:GetNetVar("sanity", 100);
end

Clockwork.datastream:Hook("SanitySpeech", function(data)
	if data then
		sound.Play(cwSanity.slowDownSpeechSounds[math.random(1, #cwSanity.slowDownSpeechSounds)], data, 70, 30, 0.8);
	end
end);

if (!cwSanity.cockroaches) then
	cwSanity.cockroaches = {};
else
	for k, v in pairs(cwSanity.cockroaches) do
		if (IsValid(v)) then
			v:Remove();
		end;
	end;

	cwSanity.cockroaches = {};
end;

local thunderSkeletons = {}

function cwSanity:ThunderSkeletons()
	if (#thunderSkeletons > 0) then
		for k, v in pairs(thunderSkeletons) do
			if (IsValid(v)) then
				local player = Entity(k);
				
				if (IsValid(player)) then
					player:SetColor(Color(255, 255, 255, 255));
				end;
				
				v:Remove();
			end;
		end;
		
		thunderSkeletons = {};
	end;
	
	local position = Clockwork.Client:GetPos();
	local curTime = CurTime();
	Clockwork.Client:EmitSound("begotten/slender.wav");
	--
	for k, v in pairs (ents.FindInSphere(position, 750)) do
		local moveType = v:GetMoveType();
		
		if (v:IsPlayer() and v:Alive() and (moveType == MOVETYPE_WALK or moveType == MOVETYPE_LADDER) and Clockwork.entity:CanSeePlayer(Clockwork.Client, v, 0.5)) then
			local entIndex = v:EntIndex();
			local dynamicLight = DynamicLight(entIndex);
			local playerPosition = v:GetPos();
			
			if (dynamicLight) then
				local forward = v:GetForward();
				local obbMax = v:OBBMaxs();
				local position = playerPosition + (forward * 20) + Vector(0, 0, obbMax.z * 0.8);
				
				dynamicLight.Pos = position;
				dynamicLight.Brightness = 2;
				dynamicLight.r = 200;
				dynamicLight.g = 200;
				dynamicLight.b = 255;
				dynamicLight.Size = 400;
				dynamicLight.Decay = 0.3;
				dynamicLight.DieTime = curTime + 0.1;
				dynamicLight.Style = 1;
			end;
			
			if (v != Clockwork.Client) then
				
				thunderSkeletons[entIndex] = ClientsideModel("models/skeleton/skeleton_whole.mdl", RENDERGROUP_OPAQUE);
				thunderSkeletons[entIndex]:SetParent(v);
				thunderSkeletons[entIndex]:AddEffects(EF_BONEMERGE);
				thunderSkeletons[entIndex]:SetSkin(2);
				
				v:SetRenderMode(RENDERMODE_TRANSALPHA);
				v:SetColor(Color(255, 255, 255, 50));
				
				timer.Simple(math.Rand(0.1, 0.2), function()
					for k, v in pairs(thunderSkeletons) do
						if (IsValid(v)) then
							local player = Entity(k);
							
							if (IsValid(player)) then
								player:SetColor(Color(255, 255, 255, 255));
							end;
							
							v:Remove();
						end;
					end;
				
					thunderSkeletons = {};
				end);
			end;
		end;
	end;
end;

do
local fikmaf = 2
local fras = 0.3
local frat = 1
local SANIT = 0
local ANGLESPEED = 0.5;
local y_pitch = 0
local y_roll = 0
local y_yaw = 0

local rands = 2
local grain = Material("begotten/effects/grain_overlay");



function Scaresae()

	LocalPlayer():EmitSound("begotten/npc/sle/scare"..math.random(1, 2)..".mp3")
	timer.Simple(0, function()
		LocalPlayer().Scares = CurTime() + 4;
		LocalPlayer().ScareTime = LocalPlayer().Scares - CurTime();
		LocalPlayer().Rangers1 = 50;
		LocalPlayer().Rangers2 = 25;
		LocalPlayer():EmitSound("begotten/slender.wav", 30);
	Schema:SanityZoom(0.2)
	Schema:AddStunEffect(0.1);
	CRAZYBOB = 100;
		timer.Simple(0.5, function()
			LocalPlayer():EmitSound("begotten/slender.wav", 60);
		end);
	end);
end;

concommand.Add("scarma", function()
	Scaresae()
end);

hook.Add("RenderScreenspaceEffects", "Scaresa", function()
	local curTime = CurTime();

	
	if (!LocalPlayer().Scares) then
		LocalPlayer().Scares = 0;
	end;
	
	if (LocalPlayer().Scares > curTime) then
		if (!Range1) then
			Range1 = LocalPlayer().Rangers1 or 1;
		end;
		
		if (!Range2) then
			Range2 = LocalPlayer().Rangers2 or 4;
		end;
	else
		if (Range1 and Range2) then
			if (Range1 != 0) then
				Range1 = math.Approach(Range1, 0, FrameTime() * 16);
			end;
			
			if (Range2 != 0) then
				Range2 = math.Approach(Range2, 0, FrameTime() * 16);
			end;
		end;
	end;
	
	if (Range1 and Range2 and Range1 > 0) then
		DrawSharpen(math.random(Range1, Range2), math.random(-Range1, -Range2));
		local tab = {
			[ "$pp_colour_brightness" ] = 0,
			[ "$pp_colour_contrast" ] = 0.5,
			[ "$pp_colour_colour" ] = math.Clamp(-Range2, 0, 1),
		}
		if (LocalPlayer().Asd) then
		DrawColorModify(tab); end;
	else
		if (Range1) then
			Range1 = nil;
			LocalPlayer().Asd = nil;
		end;
		
		if (Range2) then
			Range2 = nil;
		end;
	end;
end);
	
hook.Add("RenderScreenspaceEffects", "efra", function()
	if (1 + 1 == 2) then
		return
	end;
	if (!LocalPlayer().nextSy or CurTime() > LocalPlayer().nextSy) then
		LocalPlayer().nextSy = CurTime() + 0.5;
		
		for k, v in pairs (ents.FindInSphere(LocalPlayer():GetPos(), 400)) do
			if (v:GetMoveType() != MOVETYPE_NOCLIP and v:IsPlayer() and v:IsAdmin() and Clockwork.player:HasFlags(v, "4") and v:Alive()) then
					if (!LocalPlayer().HeadAchesA) then
						LocalPlayer().HeadAchesA = {};
					end;
					
					LocalPlayer().HeadAchesA[#LocalPlayer().HeadAchesA  + 1] = v;
			end;
		end;
	end;
	
	if (LocalPlayer().HeadAchesA and #LocalPlayer().HeadAchesA > 0) then
		for k, v in pairs (LocalPlayer().HeadAchesA) do
			if (!IsValid(v)) then
				LocalPlayer().HeadAchesA[k] = nil
				continue
			end;
			if (v:GetMoveType() == MOVETYPE_NOCLIP) then
				LocalPlayer().HeadAchesA[k] = nil;
			end;
		end;
	end;

	if (LocalPlayer().HeadAchesA and #LocalPlayer().HeadAchesA > 0) then
		if (math.random(1, 20) == 1) then 
			local randsa = math.random(1, 4);
			
			for k, v in pairs (LocalPlayer().HeadAchesA) do
				if (!IsValid(v) or LocalPlayer():GetPos():Distance(v:GetPos()) > 750 or v:GetMoveType() == MOVETYPE_NOCLIP) then
					LocalPlayer().HeadAchesA[k] = nil;
				end;
			end;
			
			if (randsa == 4) then
				rands = math.Clamp(rands + 1, 2, 7);
			elseif (randsa == 3) then
				rands = math.Clamp(rands - 1, 2, 7);
			end;
		end;

		for i = 1, rands * 2 do
			render.UpdateScreenEffectTexture();
			
			grain:SetFloat("$refractamount", 0);
			grain:SetFloat("$envmaptint", 0);
			grain:SetFloat("$envmap", 0);
			grain:SetFloat("$alpha", 1);
			grain:SetInt("$ignorez", 0);
			
			render.SetMaterial(grain);
			render.DrawScreenQuad();
		end;
		
		local tab = {
			[ "$pp_colour_addr" ] = 0.1,
			[ "$pp_colour_addg" ] = 0,
			[ "$pp_colour_addb" ] = -0.5,
			[ "$pp_colour_brightness" ] = 0 - rands / 128,
			[ "$pp_colour_contrast" ] = 1 - rands * 0.05,
			[ "$pp_colour_colour" ] = 1.5,
			[ "$pp_colour_mulr" ] = 0 * rands,
			[ "$pp_colour_mulg" ] = -0.2,
			[ "$pp_colour_mulb" ] = -0.2
		}
		
		DrawColorModify(tab)
		DrawMaterialOverlay("begotten/effects/blackblur", rands )
	else
		if (LocalPlayer().HeadAchesA and #LocalPlayer().HeadAchesA > 0) then
			for k, v in pairs (LocalPlayer().HeadAchesA) do
				if (!IsValid(v)) then
					LocalPlayer().HeadAchesA[k] = nil;
				end;
			end;
		end;
	end;
end);
end;