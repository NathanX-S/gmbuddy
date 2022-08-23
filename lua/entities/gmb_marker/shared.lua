ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "GMBuddy Marker"
ENT.Author = "Eris"
ENT.Spawnable = false

function ENT:Initialize()
	self:SetRenderMode(RENDERMODE_TRANSCOLOR)
	self:DrawShadow(false)
	self:SetModel("models/hunter/misc/cone1x1.mdl")
	self:SetColor(GMBuddy.Config.Colors["Marker"])
	self:SetAngles(Angle(0, 0, 180))
	self:SetMaterial("models/debug/debugwhite")
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion(false)
	end
end