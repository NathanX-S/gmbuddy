drive.Register("drive_hermes", 
{
    --
    -- Called before each move. You should use your entity and cmd to 
    -- fill mv with information you need for your move.
    --
    StartMove = function(self, mv, cmd)
        --
        -- Update move position and velocity from our entity
        --
        mv:SetOrigin(self.Entity:GetNetworkOrigin())
        mv:SetVelocity(self.Entity:GetAbsVelocity())
    end,

    --
    -- Runs the actual move. On the client when there's 
    -- prediction errors this can be run multiple times.
    -- You should try to only change mv.
    --
    Move = function(self, mv)
        --
        -- Set up a speed, go faster if shift is held down
        --
        local speed = 0.01
        if mv:KeyDown(IN_SPEED) then
            speed = 0.05
        end

        --
        -- Get information from the movedata
        --
        local ang = mv:GetMoveAngles()
        local pos = mv:GetOrigin()
        local vel = mv:GetVelocity()

        --
        -- Add velocities based on input
        --
        vel = vel + ang:Forward() * mv:GetForwardSpeed() * speed
        vel = vel + ang:Right() * mv:GetSideSpeed() * speed
        vel = vel + ang:Up() * mv:GetUpSpeed() * speed

        --
        -- Apply a maximum velocity
        --
        local maxVelocity = 1000 -- Set your desired max velocity here
        local maxVelocitySqr = maxVelocity * maxVelocity -- Compute squared max velocity

        local maxVelocityFast = 2000 -- Set your desired max velocity here
        local maxVelocitySqrFast = maxVelocityFast * maxVelocityFast -- Compute squared max velocity

        if vel:LengthSqr() > maxVelocitySqr and !mv:KeyDown(IN_SPEED) then
            vel = vel:GetNormalized() * maxVelocity
        elseif vel:LengthSqr() > maxVelocitySqrFast and mv:KeyDown(IN_SPEED) then
            vel = vel:GetNormalized() * maxVelocityFast
        end


        --
        -- Apply gradual deceleration if no keys are pressed
        --
        if math.abs(mv:GetForwardSpeed()) + math.abs(mv:GetSideSpeed()) + math.abs(mv:GetUpSpeed()) < 0.1 then
            local deceleration = 0.25
            vel = vel * (1 - deceleration)
            if vel:LengthSqr() < 0.01 then
                vel = vector_origin
            end
        end

        --
        -- Update position based on velocity and FrameTime
        --
        local frameTime = FrameTime()
        pos = pos + vel * frameTime

        --
        -- Set the newly calculated values on the movedata
        --
        mv:SetVelocity(vel)
        mv:SetOrigin(pos)
    end,

    --
    -- The move is finished. Use mv to set the new positions
    -- on your entities/players.
    --
    FinishMove = function(self, mv)
        --
        -- Update our entity!
        --
        self.Entity:SetNetworkOrigin(mv:GetOrigin())
        self.Entity:SetAbsVelocity(mv:GetVelocity())
        self.Entity:SetAngles(mv:GetMoveAngles())

        --
        -- If we have a physics object update that too. But only on the server.
        --
        if SERVER and IsValid(self.Entity:GetPhysicsObject()) then
            local phys = self.Entity:GetPhysicsObject()
            phys:EnableMotion(true)
            phys:SetPos(mv:GetOrigin())
            phys:Wake()
            phys:EnableMotion(false)
        end
    end,

    --
    -- Calculates the view when driving the entity
    --
    CalcView = function(self, view)
        --
        -- Use the utility method on drive_base.lua to give us a 3rd person view
        --
        local idealdist = math.max(10, self.Entity:BoundingRadius()) * 4
        self:CalcView_ThirdPerson(view, idealdist, 2, {self.Entity})
    end,

}, "drive_base")