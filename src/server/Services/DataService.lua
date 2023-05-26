-- File: DataService
-- Author: PirateNinja Twelve
-- Date: 07/16/2021
-- Revision: 05/25/2023

local Knit = require(game:GetService("ReplicatedStorage").Knit)
local RemoteSignal = require(Knit.Util.Remote.RemoteSignal)

local ProfileService = require(Knit.Modules.ProfileService)

local Players = game:GetService("Players")

-- Creating a new service
local DataService = Knit.CreateService {
    Name = "DataService";
    Client = {
        CoinsChanged = RemoteSignal.new();
        WinsChanged = RemoteSignal.new();
        LevelChanged = RemoteSignal.new();
    };
}

local ProfileTemplate = {
    -- Stats
    Coins = 0;
    Wins = 0;
    Level = 1;
}

local GameProfileStore = ProfileService.GetProfileStore(
    "PlayerData-dev2",
    ProfileTemplate
)

local Profiles = {}

-- Loading Data
local OnPlayerAdded = function(player: Player)
    print(player.UserId)

    local isAFK = Instance.new"BoolValue"
    isAFK.Name = "isAFK"
    isAFK.Value = false
    isAFK.Parent = player

    local profile = GameProfileStore:LoadProfileAsync(
        "player_" .. player.UserId,
        "ForceLoad"
    )

    if (profile) then
        profile:ListenToRelease(function()
            Profiles[player] = nil
            player:Kick()
        end)

        if (player:IsDescendantOf(Players)) then
            Profiles[player] = profile
        else
            profile:Release()
        end
    else
        player:Kick("Failed to retrieve data. Please rejoin the game!")
    end

    task.spawn(function()
        while task.wait(0.35) do
            local coins = DataService:GetData (player, "Coins")
            DataService.Client.CoinsChanged:Fire (player, coins)
        end
    end)
end

-- Saving Data
local OnPlayerRemoving = function (player: Player)
    local profile = Profiles[player]

    if (profile) then
        profile:Release()
    end
end

function DataService:GetProfile (player)
    local profile = Profiles[player]
    if (profile) then
        return profile.Data
    end
end

function DataService:GetData (player: Player, dataName: string)
    local profile = self:GetProfile(player)
    if (profile) then
        return profile[dataName] or 0
    end
end

function DataService:GetInventoryData (player: Player, inventoryName: string)
    local profile = self:GetProfile (player)
    if (profile) then
        return profile.Inventory[inventoryName]
    end
end

function DataService:ChangeData (player: Player, dataName: string, value: any)
    local profile = self:GetProfile(player)

    if profile then
        profile[dataName] = value
    end
end

function DataService:AddToInventory (player: Player, inventoryName: string, itemName: string)
    local inventoryData = self:GetInventoryData (player, inventoryName)
    inventoryData[itemName] = false
end

function DataService:ResetData (player: Player)
    local profile = Profiles[player]
    if (profile) then
        profile = ProfileTemplate
    end
end

function DataService.Client:GetData (player: Player, dataName: string)
    return self.Server:GetData (player, dataName)
end

function DataService.Client:GetInventoryData (player: Player, inventoryName: string)
    return self.Server:GetInventoryData (player, inventoryName)
end


function DataService:KnitStart ()
    for _, plr in pairs (game:GetService("Players"):GetChildren()) do
        if plr then
            OnPlayerAdded(plr)
        end
    end
end

function DataService:KnitInit()
    Players.PlayerAdded:Connect(OnPlayerAdded)
    Players.PlayerRemoving:Connect(OnPlayerRemoving)
end

return DataService