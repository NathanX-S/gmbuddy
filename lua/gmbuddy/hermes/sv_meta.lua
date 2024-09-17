local meta = FindMetaTable("Player")
function meta:SetHermes(state)
    print("setHermes", state)
    if state then
		--self:Lock()
		--self:SetAbsVelocity(Vector(0,0,0))
		self:ResetSequence("idle")
        
        if IsValid(self.HermesCam) then
            self.HermesCam:Remove()
        end
        self.HermesCam = ents.Create("gmb_cam")
        local camera_pos = nil
        local camera_ang = nil
        if !self.HermesCamPos then
            local tr = util.TraceLine({
                start = self:GetPos(),
                endpos = self:GetPos() + self:GetAngles():Up() * 100000,
                mask = MASK_NPCWORLDSTATIC,
            })
            camera_pos = tr.HitPos
            camera_pos.z = math.min(tr.HitPos.z, 1000)
            camera_ang = Angle(45, self:EyeAngles().yaw, 0)
        else
            camera_pos = self.HermesCamPos
            camera_ang = self.HermesCamAng
        end
        self.HermesCam:SetPos(camera_pos)
        self.HermesCam:SetAngles(camera_ang)
        self.HermesCam:Spawn()
        table.RemoveByValue(GMBuddy.HermesUsers, self)
        table.insert(GMBuddy.HermesUsers, self)
        -- is this running??
        print(self, self.HermesCam, "BALLING TOO HARD")
        drive.PlayerStartDriving(self, self.HermesCam, "drive_hermes")
	else
        drive.PlayerStopDriving(self)
        self.HermesCam:Remove()
        table.RemoveByValue(GMBuddy.HermesUsers, self)
		--self:UnLock()
	end
    self:SetCanZoom(!state)
    self:SetNoTarget(state)
	self.bHermes = state
    
	print("setting state", self, state)
	self:SetNWBool("GMBuddy.bHermes", state)
end