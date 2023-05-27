local Cmdr = require(game:GetService("ReplicatedStorage").CmdrClient)
local Roact = require(game:GetService("ReplicatedStorage").Packages.Roact)


local Status = require(script.Parent.RoactComponents.Status)

print("Hello world, from client!")

local PlayerGui = game.Players.LocalPlayer.PlayerGui

Cmdr:SetActivationKeys({ Enum.KeyCode.F2 })


local function App(props)
    return Roact.createElement("ScreenGui", {
        IgnoreGuiInset = true
    }, {
        StatusBar = Roact.createElement(Status, {
            Status = props.Status
        })
    })
end
local MainApp = Roact.createElement(App, {
    Status = "Welcome to my game."
})

local handle = Roact.mount(MainApp, PlayerGui, "MainApp")

local t = 30
while (t <= 0) do
    t = t - 1
    print(t)
    
    handle = Roact.update(handle, Roact.createElement(MainApp, {
        Status = `Time remaining: {t}`
    }))
    task.wait(1)
end