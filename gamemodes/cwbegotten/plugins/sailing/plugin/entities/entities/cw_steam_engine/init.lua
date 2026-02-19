--[[
	Begotten III: Jesus Wept
	By: DETrooper, cash wednesday, gabs, alyousha35

	Other credits: kurozael, Alex Grist, Mr. Meow, zigbomb
--]]

Clockwork.kernel:IncludePrefixed("shared.lua");

AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

local cwSailing = cwSailing;

-- Called when the entity initializes.
function ENT:Initialize()
	self:SetModel("models/props_citizen_tech/steamengine001a.mdl");
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetUseType(SIMPLE_USE);
	self:SetSolid(SOLID_VPHYSICS);
	self.health = 100;
	
	local physicsObject = self:GetPhysicsObject();
	
	if (IsValid(physicsObject)) then
		physicsObject:Wake();
		physicsObject:EnableMotion(false);
	end;
end;

-- Called when the entity's transmit state should be updated.
function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS;
end;

function ENT:Think()
	self:NextThink(CurTime() + 5);
	
	if self:GetNWBool("turnedOn") == true then
		if self.fuel and self.fuel > 0 then			
			local ironclad = self.ironclad;
			
			if IsValid(ironclad) then
				if ironclad.location and (ironclad.location == "calm" or ironclad.location == "rough" or ironclad.location == "styx") and ironclad.destination then
					self.fuel = math.max(0, self.fuel - 1);
				else
					self.fuel = math.max(0, self.fuel - 0.25);
				end
			
				local itemID = ironclad.itemID;
				
				if itemID then
					local itemTable = item.FindInstance(itemID);
			
					if itemTable then
						itemTable:SetData("fuel", math.Round(self.fuel, 2));
					end
				end
				
				return true;
			end
			
			self.fuel = math.max(0, self.fuel - 0.25);
			
			return true;
		end
		
		self:TurnOff();
	end
	
	return true;
end

function ENT:AddFuel(itemTable)
	if itemTable and itemTable.uniqueID == "charcoal" then
		self.fuel = math.min(100, (self.fuel or 0) + math.Round(20 * ((itemTable:GetCondition() or 100) / 100)));
		
		local ironclad = self.ironclad;
		
		if IsValid(ironclad) then
			local itemID = ironclad.itemID;
			
			if itemID then
				local itemTable = item.FindInstance(ironclad.itemID);
		
				if itemTable then
					itemTable:SetData("fuel", math.Round(self.fuel, 2));
				end
			end
		end
	end
end

function ENT:TurnOn()
	if self:GetNWBool("turnedOn") then
		return false, "The steam engine is already running!";
	end
	
	if self:GetNWBool("broken") then
		return false, "The steam engine is broken and needs to be repaired before it can be reactivated!";
	end

	local fuel = self.fuel or 0;
	
	if fuel <= 0 then
		return false, "There is no fuel for the steam engine to burn!";
	end
	
	self:SetNWBool("turnedOn", true);
	
	Clockwork.chatBox:AddInRadius(nil, "itnofake", "The steam engine roars to life in a cacophony of noise!", self:GetPos(), config.Get("talk_radius"):Get() * 2);
	
	self:StartLoopingSound("ambient/machines/turbine_loop_1.wav");
	ParticleEffect("Rocket_Smoke_Trail", self:GetPos() + (self:GetForward() * 100) + Vector(0, 0, 45), Angle(0, 0, 0), self);
	
	local ironclad = self.ironclad;
	
	if IsValid(ironclad) then
		if timer.Exists("TravelTimer_"..tostring(ironclad:EntIndex())) then
			timer.UnPause("TravelTimer_"..tostring(ironclad:EntIndex()));
		end
	end
	
	return true;
end

function ENT:TurnOff()
	if !self:GetNWBool("turnedOn") then
		return false, "The steam engine is already inactive!";
	end

	self:SetNWBool("turnedOn", false);

	Clockwork.chatBox:AddInRadius(nil, "itnofake", "The steam engine falls silent!", self:GetPos(), config.Get("talk_radius"):Get() * 2);

	self:StopParticles();
	self:StopSound("ambient/machines/turbine_loop_1.wav");
	self:EmitSound("ambient/machines/steam_release_2.wav", 90);
	
	local ironclad = self.ironclad;
	
	if IsValid(ironclad) then
		if timer.Exists("SailTimer_"..tostring(ironclad:EntIndex())) then
			ironclad.destination = nil;

			timer.Remove("SailTimer_"..tostring(ironclad:EntIndex()));
		end
		
		if timer.Exists("TravelTimer_"..tostring(ironclad:EntIndex())) then
			timer.Pause("TravelTimer_"..tostring(ironclad:EntIndex()));
		end
	end
	
	return true;
end

function ENT:OnTakeDamage(damageInfo)
	if self:GetNWBool("broken") ~= true then
		local attacker = damageInfo:GetAttacker();
		
		if IsValid(attacker) and attacker:IsPlayer() then
			if damageInfo:GetDamage() >= 25 then
				self:SetNWBool("broken", true);
				self:SetNWBool("turnedOn", false);
				self:StopSound("ambient/machines/turbine_loop_1.wav");
				self:EmitSound("physics/metal/metal_box_break2.wav");
				
				local ironclad = self.ironclad;
				
				if IsValid(ironclad) then
					if timer.Exists("SailTimer_"..tostring(ironclad:EntIndex())) then
						ironclad.destination = nil;
						
						timer.Remove("SailTimer_"..tostring(ironclad:EntIndex()));
					end
					
					if timer.Exists("TravelTimer_"..tostring(ironclad:EntIndex())) then
						timer.Pause("TravelTimer_"..tostring(ironclad:EntIndex()));
					end
				end
				
				Clockwork.chatBox:AddInRadius(nil, "itnofake", "The steam engine breaks under the weight of an attack, ceasing its function!", self:GetPos(), config.Get("talk_radius"):Get() * 2);
				
				timer.Simple(FrameTime(), function()
					if IsValid(self) then
						self:StopParticles();
					end
				end);
			end
		end
	end
end

function ENT:Use(activator, caller)
	netstream.Start(caller, "OpenSteamEngineMenu", self);
end;

function ENT:OnRemove()
	self:StopParticles();
	self:StopSound("ambient/machines/turbine_loop_1.wav");
end