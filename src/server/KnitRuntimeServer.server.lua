-- File: KnitRuntimeServer
-- Author: PirateNinja
-- Date: 07/16/2021

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage:FindFirstChild("Packages").Knit)
Knit.Shared = ReplicatedStorage:FindFirstChild("Shared")

Knit.Loaded = false
Knit.Modules = {}
Knit.Components = {}
Knit.Class = {
    Minigame = {}
}

local SERVERTAG = "[SERVER]"
local KNITTAG = "[KNIT]"

for _, v in ipairs(script.Parent:GetDescendants()) do
    local IsModule = v:IsA("ModuleScript")
    local IsService = v:IsDescendantOf(script.Parent.Services) and v.Name:match("Service$")
    local IsComponent = v:IsDescendantOf(script.Parent.Components) and v.Name:match("Component$")

    if (IsModule) then
            if (IsService) then
                require(v)
                print(`{SERVERTAG} Loaded service {v.Name}.`)
            else if (IsComponent) then
                Knit.Components[v.Name] = require(v)
                print(`{SERVERTAG} Loaded component {v.Name}.`)
            else
                Knit.Modules[v.Name] = v
            end
        end
    end
end

for _,v in ipairs(script.Parent.Class.Minigame.Parent:GetDescendants()) do
    if (v:IsA("ModuleScript")) then
        Knit.Class.Minigame[v.Name] = require(v)
    end
end

print(Knit.Components)

Knit.Start():andThen(function()
    print(`{KNITTAG} Knit::Framework has been successfully loaded.`)
    Knit.Loaded = true
end):catch(warn)
--Sodalicious
