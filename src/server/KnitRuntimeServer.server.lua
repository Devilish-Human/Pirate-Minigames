-- File: KnitRuntimeServer
-- Author: PirateNinja
-- Date: 07/16/2021

local Knit = require(game:GetService("ReplicatedStorage").Knit)
local Component = require(Knit.Util.Component)

Knit.Modules = script.Parent.Modules
Knit.Shared = game:GetService("ReplicatedStorage").Shared

Knit.Config = require(Knit.Shared.Config)

function Knit:Wait (...)
    return require(Knit.Shared.RBXWait)(...)
end
-- Load all services within 'Services':
Knit.AddServicesDeep(script.Parent.Services)

Knit.Start():Then(function()
    for _,v in pairs(workspace:GetChildren()) do
        if (v.Name == "Nodes" and v:IsA("Folder")) then
            v:Destroy()
        end
    end

    for _,v in pairs (game:GetService("ServerStorage").Assets.MinigameSource:GetChildren()) do
       if (v) then
           v.Disabled = true
       end
    end

    Component.Auto(script.Parent.Components)
end):Catch(warn)

--Sodalicious