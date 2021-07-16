-- File: KnitRuntimeServer
-- Author: PirateNinja
-- Date: 07/16/2021

local Knit = require(game:GetService("ReplicatedStorage").Knit)
local Component = require(Knit.Util.Component)

Knit.Modules = script.Parent.Modules
Knit.Shared = game:GetService("ReplicatedStorage").Shared

Knit.Config = require(Knit.Shared.Config)

-- Load all services within 'Services':
Knit.AddServicesDeep(script.Parent.Services)

Knit.Start():Then(function()
    Component.Auto(script.Parent.Components)
end):Catch(warn)