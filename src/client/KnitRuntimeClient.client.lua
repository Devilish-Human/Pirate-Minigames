repeat task.wait() until game:IsLoaded()

local Knit = require(game:GetService("ReplicatedStorage").Knit)
local Component = require(Knit.Util.Component)

Knit.Modules = script.Parent.Modules
Knit.RoactComponents = script.Parent.RoactComponents
Knit.Shared = game:GetService("ReplicatedStorage").Shared

-- Load all services within 'Services':
Knit.AddControllersDeep(script.Parent.Controllers)

function Knit:Wait(...)
    return require(Knit.Shared.RBXWait) (...)
end

Knit.Start():Then(function()
    Component.Auto(script.Parent.Components)
end):Catch(warn)