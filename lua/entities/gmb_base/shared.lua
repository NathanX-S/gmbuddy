ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.GMBuddy = true
ENT.Spawnable = false

function ENT:ConsumeOptions(options)
	for k, v in pairs(options) do
		self:ConsumeOption(k, v)
	end
end

function ENT:ConsumeOption(key, value)
	return false
end