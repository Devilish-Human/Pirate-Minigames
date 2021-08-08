-- File: DataService
-- Author: PirateNinja
-- Date: 07/16/2021

local Knit = require(game:GetService("ReplicatedStorage").Knit)
local RemoteSignal = require(Knit.Util.Remote.RemoteSignal)

local ProfileService = require(Knit.Modules.ProfileService)

local Players = game:GetService("Players")

local DataService = Knit.CreateService {
    Name = "DataService";
    Client = {};
}

local GameProfileStore = ProfileService.GetProfileStore(
    "PlayerData-dev",
    {
        -- Stats
        Coins = 0;
        Wins = 0;
        Level = 1;
    
        -- Inventory
        Inventory = {};
    
        -- Info
        LastSave = 0;
        SaveId = 0;
    }
)

local Profiles = {}

local OnPlayerAdded = function(player: Player)
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

    local folder = Instance.new("Folder")
    folder.Name = "leaderstats"
    folder.Parent = player
end
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

function DataService.Client:GetData (player: Player, dataName: string)
    return self.Server:GetData (player, dataName)
end

function DataService:KnitStart ()
    Players.PlayerAdded:Connect(OnPlayerAdded)
    Players.PlayerRemoving:Connect(OnPlayerRemoving)
end

return DataService