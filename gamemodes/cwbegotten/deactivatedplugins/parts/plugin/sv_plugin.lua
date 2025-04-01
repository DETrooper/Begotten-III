--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

local entityMeta = FindMetaTable("Entity");

-- A function to remove all player clothing.
function entityMeta:RemoveClothing()
	if (self.Clothing) then
		for k, v in pairs(self.Clothing) do
			if (type(v) != "table") then
				if (IsValid(v)) then
					v:Remove();
					
					v = nil;
				end;
			end;
		end;
		
		self.Clothing = {};
		self.Body = nil;
		self:SetMaterial(nil);
		
		if (self:IsPlayer()) then
			self:SetModel(Clockwork.player:GetDefaultModel(self));
		else
			if (self.PreClothingModel) then
				self:SetModel(self.PreClothingModel);
			end;
		end;
	end;
end;

concommand.Add("setclothing", function(player, cmd, arguments)
	if (player:IsAdmin()) then
		local trace = player:GetEyeTrace().Entity;
		
		if (trace:GetClass() == "worldspawn") then
			trace = player;
		end;
		
		cwParts:SetClothing(trace, false, arguments[1], arguments[2], arguments[3],arguments[4], arguments[5])
	end;
end);



-- A function to set a player's clothing.
function cwParts:SetClothing(entity, bUseDefault, modelOverride, body, head, glove, pants)
	if (entity.Clothing) then
		entity:RemoveClothing();
	end;
	
	if (!body) then
		return;
	end;

	if (type(body) != "table") then
		body = {body, 0};
	else
		body = body;
	end;
	
	if (glove) then
		if (type(glove) != "table") then
			glove = {glove, 0};
		else
			glove =  glove;
		end;
	else
		glove = body;
	end;
	
	if (head) then
		if (type(head) != "table") then
			head = {head, 0};
		else
			head =  head;
		end;
	else
		head = body;
	end;

	if (pants) then
		if (type(pants) != "table") then
			pants = {pants, 0};
		else
			pants =  pants;
		end;
	else
		pants = body;
	end;
	
	local bodyModel, bodySkin = body[1], body[2];
	local headModel, headSkin = head[1], head[2];
	local gloveModel, gloveSkin = glove[1], glove[2];
	local pantsModel, pantsSkin = pants[1], pants[2];

	if (entity:IsPlayer()) then
		local model = entity:GetModel();
				
		if (bUseDefault) then
			if (!headModel or headModel == model or headModel == bodyModel) then
				headModel = Clockwork.player:GetDefaultModel(entity);
			end;
		
			if (!gloveModel or gloveModel == model or gloveModel == bodyModel) then
				gloveModel = Clockwork.player:GetDefaultModel(entity);
			end;
			
			if (!pantsModel or pantsModel == model or pantsModel == bodyModel) then
				pantsModel = Clockwork.player:GetDefaultModel(entity);
			end;
		end;
	end;

	if (bodyModel == headModel and bodyModel == gloveModel and bodyModel == pantsModel) then
		if (modelOverride) then
			self:HandleClothing(entity, bodyModel, 0, bodySkin);
		else
			entity:SetModel(bodyModel);
			
			return;
		end;
	elseif (bodyModel == headModel and bodyModel == gloveModel and bodyModel != pantsModel) then
		self:HandleClothing(entity, bodyModel, 8, bodySkin);
		self:HandleClothing(entity, pantsModel, 4, pantsSkin);
	elseif (bodyModel == headModel and bodyModel != gloveModel and bodyModel == pantsModel) then
		self:HandleClothing(entity, bodyModel, 7, bodySkin);
		self:HandleClothing(entity, gloveModel, 3, gloveSkin);
	elseif (bodyModel != headModel and bodyModel == gloveModel and bodyModel == pantsModel) then
		self:HandleClothing(entity, bodyModel, 6, bodySkin);
		self:HandleClothing(entity, headModel, 2, headSkin);
	elseif (bodyModel != headModel and bodyModel != gloveModel and bodyModel == pantsModel) then
		self:HandleClothing(entity, bodyModel, 9, bodySkin);
		self:HandleClothing(entity, headModel, 2, headSkin);
		self:HandleClothing(entity, gloveModel, 3, gloveSkin);
	elseif (bodyModel != headModel and bodyModel != gloveModel and bodyModel != pantsModel) then
		self:HandleClothing(entity, bodyModel, 1, bodySkin);
		self:HandleClothing(entity, headModel, 2, headSkin);
		self:HandleClothing(entity, gloveModel, 10, gloveSkin);
		self:HandleClothing(entity, pantsModel, 4, pantsSkin);
	else
		self:HandleClothing(entity, bodyModel, 1, bodySkin);
		self:HandleClothing(entity, headModel, 2, headSkin);
		self:HandleClothing(entity, gloveModel, 3, gloveSkin);
		self:HandleClothing(entity, pantsModel, 4, pantsSkin);
	end;
	
	if (modelOverride) then
		if (!entity:IsPlayer() and !entity.PreClothingModel) then
			entity.PreClothingModel = entity:GetModel();
 		end;
		
		entity:SetModel(modelOverride);
		entity:SetMaterial("effects/water_warp01");
	end;
	
	entity.Body = body;
end;

-- A function to handle individual player clothing.
function cwParts:HandleClothing(entity, model, clothingType, skin, bShouldReplace)
	if (!entity.Clothing) then
		entity.Clothing = {};
	end;
	
	if (!bShouldReplace) then
		if (IsValid(entity.Clothing[clothingType]) and entity.Clothing[clothingType]:GetParent() == entity) then
			entity.Clothing[clothingType]:Remove();
		end;
	end;
	
	local skin = skin or 0;
	local entitySkin = skin;
	local entityMaterial = entity:GetMaterial();
	
	if (type(skin) == "string") then
		entityMaterial = skin;
	elseif (type(skin) == "number") then
		entitySkin = skin;
	end;

	local entityIndex = entity:EntIndex();
	local entityPosition = entity:GetPos();
	local entityAngles = entity:GetAngles();
	
	entity.Clothing[clothingType] = ents.Create("cw_playerpart");
		entity.Clothing[clothingType]:SetDTInt(1, clothingType);
		entity.Clothing[clothingType]:SetDTInt(2, entityIndex);
		entity.Clothing[clothingType]:SetDTInt(3, 1);
		entity.Clothing[clothingType]:SetModel(model);
		entity.Clothing[clothingType]:SetSkin(entitySkin);
		entity.Clothing[clothingType]:SetMaterial(entityMaterial);

		entity.Clothing[clothingType].type = clothingType;
		entity.Clothing[clothingType]:SetParent(entity);
		entity.Clothing[clothingType]:SetPos(entityPosition);
		entity.Clothing[clothingType]:SetAngles(entityAngles);
		
		local physObj = entity.Clothing[clothingType]:GetPhysicsObject();
		
		if (IsValid(physObj)) then
			physObj:EnableCollisions(false);
		end;
	entity.Clothing[clothingType]:Spawn();

	return entity.Clothing[clothingType];
end;