local Knit = require(game:GetService("ReplicatedStorage").Knit)
local Maid = require(Knit.Util.Maid)

local GameManager = {}
GameManager.__index = GameManager

GameManager.Tag = "GameManager"

local GameService, DataService

function GameManager.new(instance)
    local self = setmetatable({}, GameManager)
    self._maid = Maid.new()
    print("GameManager::new")
    return self
end

function GameManager:isContestant (player: Player)
    self._maid:GiveTask (function()
        for i, v in pairs (self.Instance.Players.AllPlayers:GetChildren()) do
            if (v.Value == player and self.Instance.Players.InGame:FindFirstChild(player.Name)) then
                return v
            end
        end
        return false
    end)
end

function GameManager:isWinner (player: Player)
    self._maid:GiveTask(function()
        for i, v in pairs (GameService.Winners) do
            if (v == player) then
                return v
            end
        end
        return nil
    end)
end

function GameManager:addWinner (player: Player)
    self._maid:GiveTask (function()
        if (self:isContestant(player) and not self:isWinner (player)) then
            table.insert(GameService.Winners, player)
        end
    end)
end

function GameManager:awardReward (player: Player, rewardType: string, rewardValue: number)
    if (player) then
        local playerData = DataService:GetProfile (player)
        if (playerData) then
            playerData[rewardType] += rewardValue
        end
    end
end

function GameManager:SetAttribute (attribute, value)
    return self.Instance:SetAttribute(attribute, value)
end

function GameManager:GetAttribute (attribute)
    return self.Instance:GetAttribute(attribute)
end

function GameManager:_setupObserver ()
    self._maid:GiveTask(self.Instance.ChildAdded:Connect(function(child)
        self.Instance:SetAttribute("CurrentMinigame", child.Name)
        self.Instance:SetAttribute("CurrentMap", child:GetAttribute("Map"))
        self.Instance:SetAttribute("Teams", game:GetService("ServerStorage").Assets.Maps:FindFirstChild(child.Name):GetAttribute("Team"))
        self.Instance:SetAttribute("hasEnded", false)

        if (self.Instance:GetAttribute("Teams")) then
            local teamsFolder = Instance.new("Folder")
            teamsFolder.Name = "Teams"
            teamsFolder.Parent = self.Instance:FindFirstChild(self.Instance:GetAttribute("CurrentMinigame"))

            local team1 = Instance.new("Folder")
            team1.Name = "Pirates"
            team1.Parent = teamsFolder
            team1:SetAttribute("Color", Color3.fromRGB(116, 61, 61))

            local team2 = Instance.new("Folder")
            team2.Name = "Ninjas"
            team2.Parent = teamsFolder
            team2:SetAttribute("Color", Color3.fromRGB(49, 49, 49))
        end
    end))
    self._maid:GiveTask(self.Instance.ChildRemoved:Connect(function(child)
        self.Instance:SetAttribute("CurrentMinigame", "")
        self.Instance:SetAttribute("CurrentMap", "")
        self.Instance:SetAttribute("Teams", false)
        self.Instance:SetAttribute("hasEnded", false)

        if (child:FindFirstChild("Teams")) then
            child:FindFirstChild("Teams"):Destroy()
        end

        GameService.Winners = {}
    end))
end

function GameManager:Init()
    GameService = Knit.Services.GameService
    DataService = Knit.Services.DataService
    GameService.Winners = {}
    
    self:_setupObserver()
    print("GameManager::init")
end

function GameManager:Deinit()
    print("GameManager::deinit")
end

function GameManager:Destroy()
    self._maid:Destroy()
    print("GameManager::destroy")
end


return GameManager