local Knit = require(game:GetService("ReplicatedStorage").Knit)
local Maid = require(Knit.Util.Maid)

local Minigame = {}
Minigame.__index = Minigame

Minigame.Tag = "Minigame"

local GameService, DataService;

-- // The minigame class

function Minigame.new(instance)
    
    local self = setmetatable({}, Minigame)
    
    self._maid = Maid.new()
    print("Minigame initialized")
    self._maid:GiveTask(function()
        print("Minigame deinitialized")
    end)
    return self
    
end

function Minigame:isContestant (player: Player)
    self._maid:GiveTask (function()
        for i, v in pairs (self.Instance.Players.AllPlayers:GetChildren()) do
            if (v.Value == player and self.Instance.Players.InGame:FindFirstChild(player.Name)) then
                return v
            end
        end
        return false
    end)
end

function Minigame:isWinner (player: Player)
    self._maid:GiveTask(function()
        for i, v in pairs (GameService.Winners) do
            if (v == player) then
                return v
            end
        end
        return nil
    end)
end

function Minigame:addWinner (player: Player)
    self._maid:GiveTask (function()
        if (self:isContestant(player) and not self:isWinner (player)) then
            table.insert(GameService.Winners, player)
        end
    end)
end

function Minigame:awardReward (player: Player, rewardType: string, rewardValue: number)
    if (player) then
        local playerData = DataService:GetPlayer (player)
        if (playerData) then
            playerData[rewardType] += rewardValue
        end
    end
end

function Minigame:_setupPlayerFolders ()
    local playersFolder = Instance.new("Folder")
    local InGameFolder = Instance.new("Folder")
    local AllPlayers = Instance.new("Folder")

    playersFolder.Name = "Players"
    InGameFolder.Name = "InGame"
    AllPlayers.Name = "AllPlayers"

    playersFolder.Parent = self.Instance
    InGameFolder.Parent = playersFolder
    AllPlayers.Parent = playersFolder
end

function Minigame:_cleanupPlayersFolder ()
    if (self.Instance:FindFirstChild("Players")) then
        self.Instance:FindFirstChild("Players"):Destroy()
    end
end

function Minigame:Init()

    print ("Apples")
    self:_setupPlayerFolders()

    self.Instance:FindFirstChild("Teleports"):GetChildren().Transparency = 1
    GameService = Knit.Services.GameService
    DataService = Knit.Services.DataService
end

function Minigame:Deinit()
end


function Minigame:Destroy()
    self._maid:Destroy()
end


return Minigame