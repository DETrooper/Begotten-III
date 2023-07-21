--[[
	Begotten III: Jesus Wept
--]]

-- 5th is description.
local sanityTexts = {"...", "Insane", "Losing Sanity", "Sane", "Sanity is a measure of your character's mental condition: the lower it gets the more detached from reality they will become. Witnessing or partaking in distrubing acts is detrimental to one's sanity."};

-- Called when the bars are needed.
--[[function cwSanity:GetBars(bars)
	local sanity = Clockwork.Client:GetNetVar("sanity", 100)
	
	if (sanity) then
		if (!self.sanity) then
			self.sanity = sanity
		elseif (sanity != self.sanity) then
			self.sanity = math.Approach(self.sanity, sanity, FrameTime() * (16 * math.Clamp(((self.sanity - sanity) / 10), 1, 10)))
		end
		
		if (sanity < 100) then
			bars:Add("sanity", Color(100, 50, 100), "sanity", self.sanity, 100, self.sanity < 10)
		end
	end
end]]--

-- Called when the opaque renderables are drawn.
function cwSanity:PostDrawOpaqueRenderables()
	if (Clockwork.Client:HasInitialized() and Clockwork.Client:Alive()) then
		local sanity = Clockwork.Client:Sanity() or 100;
		local position = Clockwork.Client:GetPos();
		
		if (sanity < 20) then
			for k, v in pairs (ents.FindInSphere(position, 512)) do
				local moveType = v:GetMoveType();
				
				if (IsValid(v) and v:IsPlayer() and moveType == MOVETYPE_WALK and v != Clockwork.Client) then
					local model = v:GetModel();
					
					if (string.find(model, "humans")) then
						local clientPosition = LocalPlayer():GetPos();
						local entityPosition = v:GetPos();
						local distance = clientPosition:Distance(entityPosition);
						local headBone = v:LookupBone("ValveBiped.Bip01_Head1");
						
						if (headBone and distance < 512) then
							local bonePosition, boneAngles = v:GetBonePosition(headBone);
							local eyes = v:LookupAttachment("eyes");
							local eyesAttachment = v:GetAttachment(eyes);
							
							if (bonePosition and eyesAttachment) then
								local glowColor = Color(200, 0, 0, 255);
								local eyePos = EyePos();
								local forward = eyesAttachment.Ang:Forward();
								local right = eyesAttachment.Ang:Right();
								local position = eyesAttachment.Pos
								local difference = (eyePos - position);
								local differenceAngle = difference:Angle();
								local differenceForward = differenceAngle:Forward();
								local firstEye = position + (forward * 0.6) + (right * -1.25) + (differenceForward * 1);
								local secondEye = position + (forward * 0.6) + (right * 1.25) + (differenceForward * 1);
								
								render.SetMaterial(glowMaterial);
								render.DrawSprite(firstEye, 2, 1.8, glowColor);
								render.DrawSprite(secondEye, 2, 1.8, glowColor);
							end;
						end;
					end;
				end;
			end;
		end;
	end;
end;

function cwSanity:Think()
	if Clockwork.Client:HasInitialized() then
		local curTime = CurTime()
		
		if !self.itemSpeakTimer then
			self.itemSpeakTimer = curTime + math.random(180, 480);
		end
		
		if self.itemSpeakTimer < curTime then
			self.itemSpeakTimer = curTime + math.random(120, 240);
		
			if Clockwork.Client:Alive() and Clockwork.Client:Sanity() <= 50 and Clockwork.Client:GetRagdollState() ~= RAGDOLL_KNOCKEDOUT and !Clockwork.player:IsNoClipping(Clockwork.Client) then
				local itemFound;
				local radioFound;
				
				for k, v in pairs (ents.FindInSphere(Clockwork.Client:GetPos(), 256)) do
					if (v:GetClass() == "cw_item") then
						itemFound = v;
						break;
					elseif (v:GetClass() == "cw_radio") then
						radioFound = v;
						break;
					end
				end
				
				if itemFound then
					local itemTable = itemFound:GetItemTable();
					
					if itemTable and self.itemSayings[itemTable.category] then
						local itemSaying = self.itemSayings[itemTable.category][math.random(1, #self.itemSayings[itemTable.category])];
						
						Clockwork.chatBox:Add(nil, nil, Color(255, 255, 150, 255), "The "..itemTable.name.." says \""..itemSaying.."\"");
					end
				elseif radioFound then
					Clockwork.chatBox:Add(nil, nil, Color(75, 150, 50, 255), "The radio emits: \""..self.radioSayings[math.random(1, #self.radioSayings)].."\"");
					
					sound.Play("radio/radio_out"..tostring(math.random(2, 3))..".wav", radioFound:GetPos(), 80, 100, 1);
				else
					local inventory = Clockwork.inventory:GetClient();
					
					if math.random(1, 2) == 1 and Clockwork.inventory:HasItemInstance(inventory, "handheld_radio") and Clockwork.Client.radioState then
						Clockwork.chatBox:Add(nil, nil, Color(75, 150, 50, 255), "Your handheld radio emits: \""..self.radioSayings[math.random(1, #self.radioSayings)].."\"");
						
						Clockwork.Client:EmitSound("radio/radio_out"..tostring(math.random(2, 3))..".wav");
					elseif table.Count(inventory) > 3 then
						Clockwork.chatBox:Add(nil, nil, Color(255, 255, 150, 255), "***' You hear a muffled voice coming from your backpack \""..self.backpackSayings[math.random(1, #self.backpackSayings)].."\"");
					end
				end
			end
		end
	end
end

-- Called when the screenspace effects are rendered.
function cwSanity:RenderScreenspaceEffects()
	if Clockwork.Client:HasInitialized() and !Clockwork.kernel:IsChoosingCharacter() then
		local sanity = Clockwork.Client:Sanity() or 100;
		local has_saintly_composure = (cwBeliefs and cwBeliefs:HasBelief("saintly_composure"));
		local position = Clockwork.Client:GetPos();
		local curTime = CurTime();
		local frameTime = FrameTime();

		if !self.insanitySkeletons then
			self.insanitySkeletons = {};
		end
		
		for k, v in pairs(self.insanitySkeletons) do 
			if (!IsValid(Entity(k)) or Entity(k):GetMoveType() != MOVETYPE_WALK or self.insanitySkeletons[k]:GetParent() ~= Entity(k)) then
				if (IsValid(self.insanitySkeletons[k])) then
					self.insanitySkeletons[k]:Remove();
				end;
				
				self.insanitySkeletons[k] = nil
			elseif (sanity > 20) and !has_saintly_composure then
				if (IsValid(self.insanitySkeletons[k])) then
					self.insanitySkeletons[k]:Remove();
				end;
				
				self.insanitySkeletons[k] = nil;
				Entity(k):SetRenderMode(RENDERMODE_TRANSALPHA);
				Entity(k):SetColor(Color(255, 255, 255, 255));
			end;
		end;

		if (sanity <= 20) and !has_saintly_composure then 
			local shouldPlay = false

			for k, v in pairs(player.GetAll()) do
				if (v != Clockwork.Client) then
					local playerIndex = v:EntIndex();
					local playerPosition = v:GetPos();
					local distance = playerPosition:DistToSqr(position);
					local moveType = v:GetMoveType();
					
					if moveType == MOVETYPE_WALK and distance < (750 * 750) then
						if (!IsValid(self.insanitySkeletons[playerIndex]) and v:GetColor().a > 0) then
							self.insanitySkeletons[playerIndex] = ClientsideModel("models/skeleton/skeleton_whole.mdl", RENDERGROUP_OPAQUE);
							self.insanitySkeletons[playerIndex]:SetParent(v);
							
							v:SetRenderMode(RENDERMODE_TRANSALPHA);
							v:SetColor(Color(255, 255, 255, 255));
							
							self.insanitySkeletons[playerIndex]:SetRenderMode(RENDERMODE_TRANSALPHA);
							self.insanitySkeletons[playerIndex]:SetColor(Color(255, 255, 255, 0));
							
							local repetition = 0;
							
							timer.Create(playerIndex.."_skeletonDecay", 0.01, 255, function()
								if (IsValid(self.insanitySkeletons[playerIndex]) and IsValid(v)) then
									repetition = repetition + 1;
									
									v:SetRenderMode(RENDERMODE_TRANSALPHA);
									v:SetColor(Color(255, 255, 255, 255 - math.Clamp(repetition, 0, 255)));
									self.insanitySkeletons[playerIndex]:SetColor(Color(255, 255, 255, 0 + repetition));
								end;
							end);
							
							self.insanitySkeletons[playerIndex]:AddEffects(EF_BONEMERGE);
							self.insanitySkeletons[playerIndex]:SetSkin(2);
							
							--shouldPlay = true;
						end
						
						local dynamicLight = DynamicLight(playerIndex);
						local eyePos = v:EyePos();
						local curTime = CurTime();
						
						if (dynamicLight) then
							dynamicLight.pos = eyePos;
							dynamicLight.r = 255;
							dynamicLight.g = 200;
							dynamicLight.b = 200;
							dynamicLight.brightness = 0.5;
							dynamicLight.Decay = 1000;
							dynamicLight.Size = 128;
							dynamicLight.DieTime = curTime + 1;
						end;
					end;
					
					if (shouldPlay) and !Clockwork.Client.LoadingText then
						Clockwork.Client:EmitSound("begotten/flashback_outro.wav", 500, 40);
						
						timer.Simple(0.4, function() 
							Clockwork.Client:EmitSound("begotten/flashback_outro.wav", 500, 60);
						end);
						
						shouldPlay = false;
					end;
				end;
			end;
		end;
		
		if (sanity <= 50) then
			if (!self.contrastAdd) then
				self.contrastAdd = 0;
			end;

			local sanityModify = {};
				sanityModify["$pp_colour_brightness"] = 0 + (self.contrastAdd * 0.1);
				sanityModify["$pp_colour_contrast"] = 1 + self.contrastAdd;
				sanityModify["$pp_colour_addg"] = (0 - self.contrastAdd);
				sanityModify["$pp_colour_addb"] = (0 - self.contrastAdd);
			DrawColorModify(sanityModify);
			
			self.contrastAdd = math.Approach(self.contrastAdd, math.Remap(sanity, 0, 50, 0.1, 0), frameTime * 0.25);
		end;
	end;
end;

-- Called when the F1 Text is needed.
function cwSanity:PostMainMenuRebuild(menu)
	if IsValid(menu) then
		local sanity = Clockwork.Client:GetNetVar("sanity", 100)

		self.sanity = sanity

		if IsValid(menu.statusInfo) then
			local sanityColor = Color(150 - sanity, sanity, 0, 225);
			
			menu.statusInfo.iconFrame.iconSanity:SetColor(sanityColor);
			menu.statusInfo.iconFrame.iconSanity.text:SetTextColor(sanityColor);
			menu.statusInfo.iconFrame.iconSanity.text:SetText(tostring(math.Round(sanity)).."%");
		end
	end;
end

function cwSanity:PlayerCanShowUnrecognised(player, x, y, color, alpha, flashAlpha)
	local sanity = Clockwork.Client:GetNetVar("sanity", 100)
	
	if (sanity <= 30 and sanity > 20) then
		return "All you see is a worthless fucking piggy ready to be slaughtered.";
	elseif (sanity <= 20) then
		return "...";
	end;
end;

-- A function to get sanity's markup tooltip.
function cwSanity:BuildSanityTooltip(x, y, width, height, frame)
	local sanity = Clockwork.Client:GetNetVar("sanity", 100)
	
	if sanity then
		local sanityColor = Color(100 - sanity, sanity, 0, 225);
		local selectedText = math.Clamp(math.Round(sanity / 25), 1, 4);
		
		frame:AddText("Sanity", Color(180, 20, 20), "nov_IntroTextSmallDETrooper", 1.15);
		frame:AddText(sanityTexts[5], Color(180, 170, 170), "nov_IntroTextSmallDETrooper", 0.8);
		frame:AddBar(20, {{text = tostring(sanity).."%", percentage = sanity, color = sanityColor, font = "DermaDefault", textless = true, noDisplay = true}}, sanityTexts[selectedText], sanityColor);
	end
end;

function cwSanity:SpookyScarySkeletons()
	if (!AfT) then AfT = CreateSound(Clockwork.Client, "begotten/npc/brute/music/att_brute.wav") end
	AfT:PlayEx(1, 100)
	AfT:ChangePitch(90, 6)
	timer.Simple(6.5, function()
		AfT:FadeOut(6);
	end);
	Clockwork.Client.SkelesColor = 255;
	cwDayNight:MoonTrigger(true, true)
	if (!SKELES) then
		SKELES = {}
	end;
	Clockwork.Client.CnSkele = nil
	if (SKELES) then
		for k, v in pairs (SKELES) do
			hook.Remove("Think", "t"..tostring(v:EntIndex()))
			v:Remove()
		end
	end
	timer.Simple(6.5, function()
		Clockwork.Client.CnSkele = true
	end);
	for i = 1, 5 do
		SKELES[i] = ClientsideModel("models/begotten/skeleton.mdl", RENDERGROUP_BOTH)
		SKELES[i]:ResetSequence("run_all_panicked")
		SKELES[i]:SetSkin(3)
		SKELES[i]:SetRenderMode(RENDERMODE_TRANSALPHA)
		local nt = i
		hook.Add("Think", "t"..nt, function()
			if (Clockwork.Client.CnSkele) then
				Clockwork.Client.SkelesColor = math.Approach(Clockwork.Client.SkelesColor, 0, FrameTime() * 32)
			end;
			if (IsValid(SKELES[i])) then
				if (!SKELES[i].X or !SKELES[i].Y) then
					SKELES[i].X = 100
					SKELES[i].Y = 100
				end;
				local curtime = CurTime();
				SKELES[i].X = 100 * math.sin(-curtime)
				SKELES[i].Y = math.sin(curtime) * math.sin(-curtime)
				if (!SKELES[i].offset) then
					SKELES[i].offset = math.random(-150, 150)
				end;
				local sr = {[1] = 20,[2] = 0,[3] = -20,[4] = -35,[5] = 35,}
				local srt = {[4] = 10,[5] = 10,}
				local t = Clockwork.Client:GetForward()*35;
				local p = Clockwork.Client:GetPos()
				p.x = p.x + math.Clamp(t.x, 35, 40);
				local POZA = Vector(p.x, p.y, p.z + 10);
				if (sr[i]) then
					POZA.y = POZA.y - sr[i]; 
				end;
				if (srt[i]) then
					POZA.x = POZA.x - srt[i]; 
				end;
				local sta = Clockwork.Client:GetPos() + Clockwork.Client:WorldToLocal(POZA)
				sta.z = p.z + 10
				SKELES[i]:SetPos(sta)
				SKELES[i]:SetAngles(Angle(0, ((Clockwork.Client:GetPos() - SKELES[i]:GetPos()):Angle().yaw), 0));
				if (!SKELES[i].heady) then
					SKELES[i].heady = 0
				else
					SKELES[i].heady = math.Approach(SKELES[i].heady, math.random(-180, 180), FrameTime() * 256)
					if (SKELES[i].heady >= 360) then
						SKELES[i].heady = 0;
					end;
				end;
				SKELES[i]:SetPoseParameter("head_yaw", SKELES[i].heady)
				SKELES[i]:SetPoseParameter("head_pitch", -10)
				SKELES[i]:SetPoseParameter("head_roll", -SKELES[i].heady)
				SKELES[i]:SetColor(Color(255, 255, 255, Clockwork.Client.SkelesColor))
				local dyna = DynamicLight("SKELE"..i);
				if (dyna) then
					dyna.pos = SKELES[i]:GetPos() + Vector(0, 0, 64)
					dyna.r = 100
					dyna.g = 20
					dyna.b = 20
					dyna.brightness = 0.5
					dyna.Decay = 2000
					dyna.Size = 256
					dyna.DieTime = CurTime()
				end;
				if (Clockwork.Client.SkelesColor <= 0 and IsValid(SKELES[i])) then
					SKELES[i]:Remove();
					SKELES[i] = nil;
					hook.Remove("Think", "t"..nt)
				end;
			else
				hook.Remove("Think", "t"..nt)
			end;
		end);
	end;
end;