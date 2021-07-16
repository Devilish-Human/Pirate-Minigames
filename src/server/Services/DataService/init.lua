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
    local data = UData.new(player)
    DataService.UDataPool[player] = data

    data:AddToInventory("Gear of Moderation")
    data:AddToInventory("Trail of Testing")
    data:AddToInventory("Effect of Punishment")
    data:AddToInventory("King of Pir'Te")

    print(data)
end
function OnPlayerRemoving (player: Player)
    print (player)
end
-- End Player Events //
-- // Data Methods
function DataService:GetPlayer (player: Player)
    return self.UDataPool[player]
end
-- // Coins
function DataService:GetData (player: Player, dataName: string)
    local data = self:GetPlayer(player)
    return data:GetStatValue (dataName)
end
function DataService.Client:GetData (player: Player, dataName: string)
    return self:GetData(player, dataName)
end
-- End Coins //
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