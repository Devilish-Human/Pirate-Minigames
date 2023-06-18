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

    ServerModeratorId = -1;
    Watchdog = require(script.Parent.Watchdog),
    WDSetting = require(script.Parent.Watchdog.Settings);
    CheckedPlayers = {},
    PlayerCooldowns = {};
    PlayerNotes = {};
}

function CmdrService:KnitInit()
    Cmdr:RegisterDefaultCommands()
    Cmdr:RegisterCommandsIn(script.Parent.Commands)
    Cmdr:RegisterHooksIn(script.Parent.Hooks)
end

return CmdrService