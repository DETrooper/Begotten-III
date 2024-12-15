--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

include("shared.lua");

local function CreateMenu()
	if (IsValid(menu)) then
		menu:Remove();
	end;
	
	local menu;
	local subMenu;
	local itemList = Clockwork.inventory:GetItemsAsList(Clockwork.inventory:GetClient());
	local fuelItems = {};
	
	for k, v in pairs(itemList) do
		if v.fireplaceFuel and !table.HasValue(fuelItems, v.uniqueID) then
			if !subMenu then
				menu = DermaMenu();
					
				menu:SetMinimumWidth(150);
				subMenu = menu:AddSubMenu("Add Fuel...");
			end
			
			subMenu:AddOption(v.name.. "("..tostring(v.fireplaceFuel).." seconds)", function()
				Clockwork.kernel:RunCommand("FireplaceAddFuel", v.uniqueID);
			end);
			
			table.insert(fuelItems, v.uniqueID);
		end
	end
	
	if menu then
		local scrW = ScrW();
		local scrH = ScrH();
	
		menu:Open();
		menu:SetPos(scrW / 2 - (menu:GetWide() / 2), scrH / 2 - (menu:GetTall() / 2));
	end
end

netstream.Hook("OpenFireplaceMenu", function()
	CreateMenu();
end);

function ENT:Think()
	local curTime = CurTime();
	
	if !IsValid(self.fire) then
		for i, v in ipairs(ents.FindInSphere(self:GetPos(), 64)) do
			if v:GetClass() == "env_fire" then
				self.fire = v;
				
				break;
			end
		end
	end
	
	if !self.nextSoundCheck or self.nextSoundCheck < curTime then
		if Clockwork.Client:GetPos():DistToSqr(self:GetPos()) < (666 * 666) and IsValid(self.fire) then
			if !self.Sound then
				self.Sound = CreateSound(self, "ambient/fire/fire_small_loop1.wav");
				self.Sound:PlayEx(0.7, 100);
			end
		elseif self.Sound then
			self.Sound:Stop();
			self.Sound = nil;
		end
		
		self.nextSoundCheck = curTime + 0.5;
	end
	
	if !self.nextLightCheck or self.nextLightCheck < curTime then
		if IsValid(self.fire) then
			local light = DynamicLight(self:EntIndex())
			
			if (light) then
				light.Pos = self:GetPos() + self:GetUp() * 15
				light.R = 255
				light.G = 100
				light.B = 0
				light.Brightness = 1.7 * (self:GetNWFloat("firesize") or 1)
				light.Size = 2250
				light.Decay = 400
				light.DieTime = curTime + 1
			end
			
			self.nextLightCheck = curTime + 0.2;
		end
	end
end

function ENT:OnRemove()
	if self.Sound then
		self.Sound:Stop();
	end
end;