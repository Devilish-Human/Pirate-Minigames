-- File: DataService
-- Author: PirateNinja
-- Date: 07/16/2021

local Knit = require(game:GetService("ReplicatedStorage").Knit)
local Thread = require(Knit.Util.Thread)

local UData = require(Knit.Modules.UserData)

local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local RunService = game:GetService("RunService")

local PlayerDataStore = DataStoreService:GetDataStore("UData-dev")

local DataService = Knit.CreateService {
    Name = "DataService";
    Client = {};
}

DataService.UDataPool = {}

-- // Player Events
function Load (player: Player)
    -- TODO:
    -- Better handling for data loads
    -- Handle data checks
    local data = UData.new(player)
    DataService.UDataPool[player] = data

    print(player, data)
end
function Save (player: Player)
    -- // TODO:
    -- Handle saving
    -- Handle data checks
    local data = DataService.UDataPool[player]
    print("Data saving for", player)
    PlayerDataStore:SetAsync("Player_" .. player.UserId, data)
    print("Data saved for", player)
    data = nil
    print(player, DataService.UDataPool)
end

function AutoSave ()
    print("Saving")
    while wait(60) do
        for _, player in ipairs(Players:GetPlayers()) do
            coroutine.wrap(Save)(player)
        end
    end
    print("Saved")
end
function OnShutdown()
	if RunService:IsStudio() then
		wait(1)
	else
		for _, player in ipairs(Players:GetPlayers()) do
			coroutine.wrap(Save)(player)
		end
	end
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
    Players.PlayerAdded:Connect(Load)
    Players.PlayerRemoving:Connect(Save)
    Thread.SpawnNow(AutoSave)

    game:BindToClose(OnShutdown)

end
function DataService:KnitInit()
end
-- End Knit //

return DataService