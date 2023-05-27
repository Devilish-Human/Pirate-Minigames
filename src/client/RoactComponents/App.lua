local Roact = require(game:GetService("ReplicatedStorage").Roact)

local App = Roact.Component:extend("App")

local Status = require(script.Parent.Status)

function App:render()
    return Roact.createElement("ScreenGui", {}, {
        StatusBar = Roact.createElement(Status, {
            Value = `PirateNinja Studios`
        })
    })
end

return App
