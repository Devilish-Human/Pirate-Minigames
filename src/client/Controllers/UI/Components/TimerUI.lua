local Knit = require(game:GetService("ReplicatedStorage").Knit)
local Roact = require(Knit.Shared.Roact)

local APP = Roact.createElement("ScreenGui", {}, {
    HelloWorld = Roact.createElement("TextLabel", {
        Size = UDim2.fromScale(1, 0.05),
        Text = "PirateNinja Games.",
        Position = UDim2.new(0.95, 0, 0.25, 0)
    })
})

return Roact.mount(APP, Knit.Player.PlayerGui)