local Knit = require(game:GetService("ReplicatedStorage").Knit)
local Component = require(Knit.Util.Component)

Knit.Modules = script.Parent.Modules
Knit.RoactComponents = script.Parent.RoactComponents
Knit.Shared = game:GetService("ReplicatedStorage").Shared

-- Load all services within 'Services':
Knit.AddControllersDeep(script.Parent.Controllers)

Knit.Start():Then(function()
    Component.Auto(script.Parent.Components)
end):Catch(warn)