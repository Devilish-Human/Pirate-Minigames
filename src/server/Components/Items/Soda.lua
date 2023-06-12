local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage:FindFirstChild("Packages")
local Knit = require(Packages.Knit)
local Component = require(Packages.Component)

local Soda = Component.new({
    Tag = "Soda",
    Ancestors = {workspace},
})

-- Optional if UpdateRenderStepped should use BindToRenderStep:
Soda.RenderPriority = Enum.RenderPriority.Camera.Value

function Soda:Construct()
    self.MyData = "Hello"
end

function Soda:Start()
end

function Soda:Stop()
    self.MyData = "Goodbye"
end

function Soda:HeartbeatUpdate(dt)
end

function Soda:SteppedUpdate(dt)
end

function Soda:RenderSteppedUpdate(dt)
end
return Soda