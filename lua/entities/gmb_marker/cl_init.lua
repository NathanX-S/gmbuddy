include('shared.lua')

function ENT:Draw()
	render.PushFlashlightMode(false)
	render.SetLightingMode(1)
	self:DrawModel()
	render.SetLightingMode(0)
	render.PopFlashlightMode()
end
