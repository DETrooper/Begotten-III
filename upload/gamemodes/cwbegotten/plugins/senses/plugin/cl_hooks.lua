--[[
	Begotten III: Jesus Wept
--]]

cwSenses.heatwaveMaterial = Material("sprites/heatwave");
cwSenses.heatwaveMaterial:SetFloat("$refractamount", 0);
cwSenses.shinyMaterial = Material("models/shiny");

-- Called when screen space effects should be rendered.
function cwSenses:RenderScreenspaceEffects()
	local senses = Clockwork.Client:GetNWBool("senses");

	if !Clockwork.kernel:IsChoosingCharacter() then	
		if (senses) then
			local hasThermal = Clockwork.Client:GetNWBool("hasThermal");
			local hasNV = Clockwork.Client:GetNWBool("hasNV");
			
			if (hasThermal) then
				local modulation = {1, 0, 0};
				local voltismModulation = {0, 1, 1};

				local colorModify = {};
					colorModify["$pp_colour_brightness"] = 0;
					colorModify["$pp_colour_contrast"] = 1;
					colorModify["$pp_colour_colour"] = 0.1;
					colorModify["$pp_colour_addr"] = 0;
					colorModify["$pp_colour_addg"] = 0.1;
					colorModify["$pp_colour_addb"] = 0.1;
					colorModify["$pp_colour_mulr"] = 15;
					colorModify["$pp_colour_mulg"] = 0;
					colorModify["$pp_colour_mulb"] = 5;
				DrawColorModify(colorModify);
			
				cam.Start3D(EyePos(), EyeAngles());
				
				local players = _player.GetAll();

				for i, v in ipairs(players) do
					if (v:Alive() and v:HasInitialized() and !v:IsNoClipping()) then
						local ragdollEntity = v:GetRagdollEntity();
						
						render.SuppressEngineLighting(true);
						
						if v:GetNetVar("subfaith") == "Voltism" then
							render.SetColorModulation(unpack(voltismModulation));
						else
							render.SetColorModulation(unpack(modulation));
						end
						
						self.heatwaveMaterial:SetFloat("$refractamount", -0.0007);
						
						render.MaterialOverride(self.shinyMaterial);
						
						if IsValid(ragdollEntity) then
							ragdollEntity:DrawModel();
							
							if IsValid(ragdollEntity.clothesEnt) then
								ragdollEntity.clothesEnt:DrawModel();
							end
						else
							v:DrawModel();
							
							if IsValid(v.clothesEnt) then
								v.clothesEnt:DrawModel();
							end
						end
						
						render.MaterialOverride(false);
						
						render.SetColorModulation(1, 1, 1);
						render.SuppressEngineLighting(false);
					end;
				end;
			
				cam.End3D();
			elseif hasNV then
				local colorModify = {};
					colorModify["$pp_colour_addg"] = 0.1;
					colorModify["$pp_colour_mulr"] = 0.1;
					colorModify["$pp_colour_mulg"] = 10;
					colorModify["$pp_colour_mulb"] = 0.1;
				DrawColorModify(colorModify);
				
				local curTime = CurTime();
				local dynamicLight = DynamicLight(Clockwork.Client:EntIndex());
				local shotPos = Clockwork.Client:EyePos();

				if (dynamicLight) then
					dynamicLight.brightness = 0.5;
					dynamicLight.Size = 2048;
					dynamicLight.pos = shotPos;
					dynamicLight.r = 200;
					dynamicLight.g = 200;
					dynamicLight.b = 255;
					dynamicLight.Decay = 0;
					dynamicLight.DieTime = curTime + 0.05;
				end;
			else
				local curTime = CurTime();
				local frameTime = FrameTime();
				local creature_of_the_dark = (cwBeliefs and cwBeliefs:HasBelief("creature_of_the_dark"));
				local the_black_sea = (cwBeliefs and cwBeliefs:HasBelief("the_black_sea"));
				local sensesModify = {};
				
				if creature_of_the_dark then
					sensesModify = {
						["$pp_colour_addr"] = 0.2,
						["$pp_colour_addg"] = 0.4,
						["$pp_colour_addb"] = 0.5,
						["$pp_colour_brightness"] = -0.35,
						["$pp_colour_contrast"] = 1.2,
						["$pp_colour_colour"] = 0.025,
						["$pp_colour_mulr"] = 0,
						["$pp_colour_mulg"] = 0,
						["$pp_colour_mulb"] = 0.1
					};
				else
					sensesModify = {
						["$pp_colour_addr"] = 0.2,
						["$pp_colour_addg"] = 0.4,
						["$pp_colour_addb"] = 0.5,
						["$pp_colour_brightness"] = -0.6,
						["$pp_colour_contrast"] = 1.4,
						["$pp_colour_colour"] = 0.025,
						["$pp_colour_mulr"] = 0,
						["$pp_colour_mulg"] = 0,
						["$pp_colour_mulb"] = 0.1
					};
				end
				
				DrawColorModify(sensesModify);
				
				local dynamicLight = DynamicLight(Clockwork.Client:EntIndex());
				local shotPos = Clockwork.Client:EyePos();

				if (dynamicLight) then
					if creature_of_the_dark or the_black_sea then
						dynamicLight.brightness = 0;
						dynamicLight.Size = 2048;
					else
						dynamicLight.brightness = 2.5;
						dynamicLight.Size = 320;
					end
					
					dynamicLight.pos = shotPos;
					dynamicLight.r = 200;
					dynamicLight.g = 200;
					dynamicLight.b = 255;
					dynamicLight.Decay = 0;
					dynamicLight.DieTime = curTime + 0.1;
				end;

				DrawMaterialOverlay("begotten/effects/blur_overlay", 0);
			end
		elseif Clockwork.Client:HasTrait("blind") and !Clockwork.player:IsNoClipping(Clockwork.Client) then
			local sensesModify = {
				["$pp_colour_brightness"] = -1,
			};
			
			DrawColorModify(sensesModify);
		end;
	end;
end;

-- Called just before the skybox is drawn.
--[[function cwSenses:PreDrawSkyBox()
	if !Clockwork.kernel:IsChoosingCharacter() then
		local senses = Clockwork.Client:GetNWBool("senses");
		
		if (senses) then
			render.Clear(0, 0, 0, 255);
			return true;
		end;
	end;
end

-- Called just after the skybox is drawn.
function cwSenses:PostDrawSkyBox()
	if !Clockwork.kernel:IsChoosingCharacter() then
		local senses = Clockwork.Client:GetNWBool("senses");
		
		if (senses) then
			render.Clear(0, 0, 0, 255);
			return true;
		end;
	end;
end]]--

-- Called every frame.
function cwSenses:Think()
	local curTime = CurTime();
	
	if (!Clockwork.Client.cwNextSenseCheck or curTime > Clockwork.Client.cwNextSenseCheck) then
		Clockwork.Client.cwNextSenseCheck = curTime + 0.05;
		
		local senses = Clockwork.Client:GetNWBool("senses");

		if (senses) then
			local hasThermal = Clockwork.Client:GetNWBool("hasThermal");
			local hasNV = Clockwork.Client:GetNWBool("hasNV");
			
			if !hasThermal and !hasNV then
				if (!self.darknessSound) then
					self.darknessSound = CreateSound(Clockwork.Client, "begotten/ambient/special/player_darkness.mp3");
				end;
			
				if (self.darknessSound and !self.darknessSound:IsPlaying()) then
					local sanity = Clockwork.Client:GetNetVar("sanity", 100);
					local sanityDelta = math.Clamp(sanity / 60, 0, 1);
				
					self.darknessSound:PlayEx(0, 100 + (50 * (1 - sanityDelta)));
					self.darknessSound:ChangeVolume(0.4 + (0.3 * (1 - sanityDelta)), 2);
				end;
			end
		else
			if (self.darknessSound) then
				self.darknessSound:FadeOut(1);
				
				timer.Simple(1, function()
					self.darknessSound = nil;
				end);
			end;
		end;
	end;
end;

function cwSenses:ModifyStatusEffects(tab)
	if Clockwork.Client:HasTrait("blind") then
		table.insert(tab, {text = "(-) Blind", color = Color(200, 40, 40)});
	end
end