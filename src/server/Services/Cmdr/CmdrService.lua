local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Cmdr = require(ReplicatedStorage:FindFirstChild("Packages").Cmdr)
local Knit = require(ReplicatedStorage:FindFirstChild("Packages").Knit)

local CmdrService = Knit.CreateService {
    Name = "CmdrService",
    Client = {},
    Admins = {
        44821621,
        74633861,
        135459427,
    },

    Watchdog = require(script.Parent.Watchdog),
    CheckedPlayers = {},
}

function CmdrService:KnitInit()
    if (not script.Parent.Types) then
        local typesFolder = Instance.new("Folder")
        typesFolder.Name = "Types"
        typesFolder.Parent = script.Parent
    end

    if (not script.Parent.Hooks) then
        local typesFolder = Instance.new("Folder")
        typesFolder.Name = "Types"
        typesFolder.Parent = script.Parent
    end

    Cmdr:RegisterDefaultCommands()
    Cmdr:RegisterCommandsIn(script.Parent.Commands)
    Cmdr:RegisterHooksIn(script.Parent.Hooks)
end

function CmdrService:KnitStart()
    
end

return CmdrService