-- File: DataService
-- Author: PirateNinja
-- Date: 07/16/2021

local Knit = require(game:GetService("ReplicatedStorage").Knit)
local UData = require(script.UserData)

local Players = game:GetService("Players")

local DataService = Knit.CreateService {
    Name = "DataService";
    Client = {};
}

DataService.UDataPool = {}

-- // Player Events
function OnPlayerAdded (player: Player)
    -- TODO:
    -- Better handling for data loads
    -- Handle data checks
    local data = UData.new(player)
    DataService.UDataPool[player] = data

    print(data)
end
function OnPlayerRemoving (player: Player)
    -- // TODO:
    -- Handle saving
    -- Handle data checks
    print (player)
end
-- End Player Events //
-- // Data Methods
function DataService:GetPlayer (player: Player)
    return self.UDataPool[player]
end
function DataService:GetData (player: Player, dataName: string)
    local data = self:GetPlayer(player)
    return data:GetStatValue (dataName)
end
-- // TODO: Better client communication for data
function DataService.Client:GetData (player: Player, dataName: string)
    return self:GetData(player, dataName)
end
-- End Data Methods //
-- // Knit
function DataService:KnitStart()
    Players.PlayerAdded:Connect(OnPlayerAdded)
    Players.PlayerRemoving:Connect(OnPlayerRemoving)
end
function DataService:KnitInit()
end
-- End Knit //

return DataService