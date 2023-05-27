-- File: KnitRuntimeServer
-- Author: PirateNinja
-- Date: 05/26/2023

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage:FindFirstChild("Packages").Knit)
Knit.Shared = ReplicatedStorage:FindFirstChild("Shared")

Knit.Loaded = false
Knit.Modules = {}
Knit.Components = {}

local CLIENTTAG = "[CLIENT]"
local KNITTAG = "[KNIT]"

for _, v in ipairs(script.Parent:GetDescendants()) do
    local IsModule = v:IsA("ModuleScript")
    local IsService = v:IsDescendantOf(script.Parent.Controllers) and v.Name:match("Controller$")
    local IsComponent = v:IsDescendantOf(script.Parent.Components) and v.Name:match("Component$")

    if (IsModule) then
            if (IsService) then
                require(v)
                print(`{CLIENTTAG} Loaded controller {v.Name}.`)
            else if (IsComponent) then
                Knit.Components[v.Name] = require(v)
                print(`{CLIENTTAG} Loaded component {v.Name}.`)
            else
                Knit.Modules[v.Name] = v
            end
        end
    end
end
print(Knit.Components)

Knit.Start():andThen(function()
    print(`{KNITTAG} Knit::Framework has been successfully loaded.`)
    Knit.Loaded = true
end):catch(warn)
--Sodalicious
