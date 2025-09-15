function cwPowerArmor:DoPowerArmorTesla(entity, bDoesDamage, bSound)
	if (IsValid(entity)) then
		local teslaData = EffectData();
		local sparkData = EffectData();
		
		if (IsValid(entity)) then
			if (bDoesDamage) then
				local damageInfo = DamageInfo();
					damageInfo:SetDamage(math.random(1, 10));
					damageInfo:SetDamageType(DMG_SHOCK);
					damageInfo:SetAttacker(entity);
					damageInfo:SetInflictor(entity);
				entity:TakeDamageInfo(damageInfo);
			end;
			
			if (bSound) then
				if (math.random(1, 2) == 2) then
					entity:EmitSound("ambient/energy/spark"..math.random(1, 6)..".wav");
				end;
			end;
			
			teslaData:SetOrigin(entity:GetPos());
			sparkData:SetOrigin(entity:GetPos() + Vector(0, 0, 30));
		end;
		
		teslaData:SetMagnitude(4);
		teslaData:SetScale(3);
		util.Effect("TeslaHitBoxes", teslaData);

		sparkData:SetMagnitude(2);
		sparkData:SetScale(1);
		util.Effect("Sparks", sparkData);
	end
end;

function cwPowerArmor:BuildUp(entity, bExplode, bGib)
	if IsValid(entity) then
		Schema:DoTesla(entity, false);
		
		entity:EmitSound("ambient/levels/citadel/zapper_warmup4.wav");
		
		timer.Simple(1, function()
			if IsValid(entity) then
				entity:EmitSound("npc/dog/dog_rollover_servos1.wav");
			end
		end);
		
		timer.Simple(2, function()
			if IsValid(entity) then
				entity:EmitSound("ambient/machines/steam_release_2.wav");
			end
		end);
		
		if (bExplode) then
			timer.Simple(3, function()
				if IsValid(entity) then
					local explosion = ents.Create("env_explosion");
					
					explosion:SetPos(entity:GetPos());
					explosion:SetKeyValue("iMagnitude", "100");
					explosion:Spawn();
					explosion:Activate();
					explosion:Fire("Explode", "", 0);
					
					for k, v in ipairs(ents.FindInSphere(entity:GetPos(), 196)) do
						if (v:IsPlayer()) then
							local damageInfo = DamageInfo();
							local realDamage = math.ceil(math.max(1000, 0));
							
							damageInfo:SetDamagePosition(entity:GetPos());
							damageInfo:SetDamageForce(VectorRand() * 5);
							damageInfo:SetDamageType(DMG_BLAST);
							damageInfo:SetDamage(realDamage);
							
							if (v:GetModel() != "models/begotten/gatekeepers/districtonearmor.mdl") then
								v:TakeDamageInfo(damageInfo)
							end;
							
							--if (bGib) then
								--timer.Simple(3, function()
									Clockwork.plugin:Call("SplatCorpse", entity, 60, damageInfo:GetDamageForce());
								--end)
							--end;
						end;
					end;
				end;
			end);
		end;
	end;
end;

function cwPowerArmor:SavePowerArmors()
	local powerArmors = {};
	
	if !self.powerArmors then
		self.powerArmors = {};
	end
	
	for k, v in pairs(self.powerArmors) do
		if (IsValid(v)) then
			local startPos = v:GetStartPosition();
			
			powerArmors[#powerArmors + 1] = {
				class = v:GetClass();
				angles = v:GetAngles(),
				position = v:GetPos(),
				startPos = startPos,
				currentCharge = v.currentCharge or 0,
			};
		end;
	end;

	Clockwork.kernel:SaveSchemaData("plugins/powerarmor/"..game.GetMap(), powerArmors);
end;

function cwPowerArmor:LoadPowerArmors()
	local powerArmors = Clockwork.kernel:RestoreSchemaData("plugins/powerarmor/"..game.GetMap());
	self.powerArmors = {};
	
	for k, v in pairs(powerArmors) do
		local entity = ents.Create(v.class or "cw_powerarmor");
		
		entity:SetAngles(v.angles);
		entity:SetPos(v.position);
		entity:Spawn();
		entity.currentCharge = v.currentCharge or 0;
		
		if (IsValid(entity:GetPhysicsObject())) then
			entity:GetPhysicsObject():EnableMotion(false);
		end;
		
		--self.powerArmors[entity] = entity;
	end;
end;

local playerMeta = FindMetaTable("Player");

function playerMeta:Electrify()
	if (!self._nextElectrify or curTime >= self._nextElectrify) then
		for k, v in pairs (ents.FindInSphere(self:GetPos(), 50)) do
			if v:IsPlayer() or v:IsNPC() or v:IsNextBot() then
				Schema:DoTesla(v, true);
			end
		end;
		
		self._nextElectrify = curTime + 3;
	end;
end;

function playerMeta:EnterPowerArmor(entity)
	if self:IsWearingPowerArmor() then
		Schema:EasyText(self, "peru",  "You are already wearing power armor!");
		
		return false;
	end

	if IsValid(entity) then
		local clothesItem = self:GetClothesEquipped();
		
		if clothesItem then
			clothesItem:OnPlayerUnequipped(self, nil, true);
		end;
		
		local helmetItem = self:GetHelmetEquipped();
		
		if helmetItem then
			helmetItem:OnPlayerUnequipped(self);
		end
	
		self:SetModel(entity:GetModel());
		self:SetCharacterData("powerArmor", entity:GetModel());
		self.wearingPowerArmor = true;
		self:SetCharacterData("battery", entity.currentCharge or 0);
		self:SetNetVar("battery", math.Round(self:GetCharacterData("battery", 0), 0));
		
		self.nextChargeDepleted = CurTime() + 120;
		
		entity:Remove();
	end
	
	hook.Run("RunModifyPlayerSpeed", self, self.cwInfoTable, true)
end

function playerMeta:ExitPowerArmor()
	if self:IsWearingPowerArmor() then
		local model = self:GetModel();
		local powerArmorEnt = "cw_powerarmor";
		
		if model == "models/begotten/gatekeepers/magistratearmor.mdl" then
			powerArmorEnt = "cw_powerarmor_magistrate";
		elseif model == "models/begotten/wanderers/voltistpowerarmor.mdl" then
			powerArmorEnt = "cw_powerarmor_voltist";
		elseif model == "models/begotten/wanderers/scrapperking.mdl" then
			powerArmorEnt = "cw_powerarmor_scrapperking";
		end
	
		hook.Run("PlayerSetModel", self);
		
		local powerArmorEntity = ents.Create(powerArmorEnt);
		
		powerArmorEntity:SetPos(self:GetPos());
		powerArmorEntity:SetAngles(self:GetAngles());
		powerArmorEntity:Spawn();
		powerArmorEntity.currentCharge = self:GetCharacterData("battery", 0);
		
		self:SetCharacterData("powerArmor", nil);
		self:SetCharacterData("battery", 0);
		self:SetNetVar("battery", 0);
		
		self.wearingPowerArmor = false;
		
		Clockwork.player:SetSafePosition(self, self:GetPos());
	else
		Schema:EasyText(self, "chocolate",  "You are not wearing power armor!");
		
		return false;
	end
	
	hook.Run("RunModifyPlayerSpeed", self, self.cwInfoTable, true)
end

concommand.Add("cw_EnterPowerArmor", function(player, cmd, args)
	local trace = player:GetEyeTrace();

	if (trace.Entity) then
		local entity = trace.Entity;
		local class = entity:GetClass();

		if (class == "cw_powerarmor") then
			local faction = player:GetFaction();
			
			if (faction == "Holy Hierarchy" and player:GetSubfaction() ~= "Inquisition") then
				player:EnterPowerArmor(entity);
			end
		elseif (class == "cw_powerarmor_magistrate" or class == "cw_powerarmor_scrapperking") then
			player:EnterPowerArmor(entity);
		elseif (class == "cw_powerarmor_voltist") then
			if player:GetSubfaith() == "Voltism" then
				player:EnterPowerArmor(entity);
			end
		end
	end;
end);