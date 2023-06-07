local Players = game:GetService("Players")

local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local ProfileService = require(game:GetService("ServerScriptService").Packages.ProfileService)

local DataTemplate = require(script.Parent.DataTemplate)

local DataService = Knit.CreateService {
    Name = "DataService";
    Client = {
        CoinsChanged = Knit:CreateSignal();
        WinsChanged = Knit:CreateSignal();
    };
    Profiles = {};
}

local ProfileStore = ProfileService.GetProfileStore(
    "tPlayerData-dev",
    DataTemplate
)


function DataService:GetProfile(player: Player)
    return self.Profiles[player]
end

function DataService:Get(player: Player, dataName: string)
    local profile = self:GetProfile(player)
    if (profile) then return profile.Data[dataName] end
end

function DataService:Set(player: Player, dataName: string, dataValue: any)
    local profile = self:GetProfile(player)

    assert(profile.Data[dataName], `Data does not exist dataName: {dataName}`)
	assert(type(profile.Data[dataName]) == type(dataValue), "")
	
    if (dataName == "Coins") then
        self.Client.CoinsChanged:Fire(player, dataValue)
    elseif (dataName == "Wins") then
        self.Client.WinsChanged:Fire(player, dataValue)
    end

    profile.Data[dataName] = dataValue
end

function DataService:Update(player: Player, dataName: string, callback)
    local oldData = self:Get(player, dataName)
    local newData = callback(oldData)
    self:Set(player, dataName, newData)
end

function DataService._onPlayerJoin(player: Player)
    local profile = ProfileStore:LoadProfileAsync(`Player_{player.UserId}`, "ForceLoad")
    if profile then
        profile:AddUserId(player.UserId)
        profile:Reconcile()
        
        profile:ListenToRelease(function()
            DataService.Profiles[player] = nil
            player:Kick()
        end)

        if not player:IsDescendantOf(Players) then
            profile:Release()
        else
            DataService.Profiles[player] = profile
            print(DataService.Profiles[player].Data)
        end
    else
        player:Kick()
    end

    local isAFK = Instance.new("BoolValue")
    isAFK.Name = "isAFK"
    isAFK.Value = false
    isAFK.Parent = player
end

function DataService.Client:Get(player: Player, dataName: string)
    return self.Server:Get(player, dataName)
end

function DataService:KnitStart()
    Players.PlayerAdded:Connect(self._onPlayerJoin)
    Players.PlayerRemoving:Connect(function(player)
        local profile = self.Profiles[player]

        if profile ~= nil then
            profile:Release()
        end
    end)

    for _, player in ipairs(Players:GetPlayers()) do
        task.spawn(self._onPlayerJoin, player)
    end
end
return DataService