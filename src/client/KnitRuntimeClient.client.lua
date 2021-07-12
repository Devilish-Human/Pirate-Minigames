local Knit = require(game:GetService("ReplicatedStorage").Knit)
local Component = require(Knit.Util.Component)
local Promise = require(Knit.Util.Promise)

Knit.Modules = script.Parent.Modules
Knit.Shared = game:GetService("ReplicatedStorage").Shared

Knit.AddControllersDeep (script.Parent.Controllers)

Knit.OnStart():Then(function()
    Component.Auto(script.Parent.Components)
end):Catch(warn)