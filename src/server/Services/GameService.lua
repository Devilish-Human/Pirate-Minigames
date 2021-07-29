-- File: GameService
-- Author: PirateNinja
-- Date: 07/16/2021

local Knit = require(game:GetService("ReplicatedStorage").Knit)

-- // Utilities \\ --
local Signal = require(Knit.Util.Signal)
local RemoteSignal = require(Knit.Util.Remote.RemoteSignal)
local Thread = require(Knit.Util.Thread)
local RBXWait = require(Knit.Shared.RBXWait)

-- // Shared Modules
local Number = require(Knit.Shared.Number)
local String = require(Knit.Shared.String)
-- End Shared Modules //

-- // Roblox Services \\ --
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local RoundInfo = ReplicatedStorage.Round
local Status: StringValue = RoundInfo.Status
local Timer: IntValue = RoundInfo.Time

local maps = ServerStorage.Assets.Maps
local minigame

local INTERMISSION_TIME = 15;

local Chosen;
local MinigameService;

local GameService = Knit.CreateService {
    Name = "GameService";
    Client = {
        ShowObjUI = RemoteSignal.new ();
        DisplayStatus = RemoteSignal.new ()
    };
    hasRoundEnded = false;
    Winners = {};
}

-- // Private Function
function TeleportPlayer(player)
    if player and player.Character and player.Character.PrimaryPart ~= nil then
        local teleport = Chosen.Teleports:GetChildren()[math.random(1, #Chosen.Teleports:GetChildren())]
        player.Character:SetPrimaryPartCFrame(teleport.CFrame * CFrame.new(0, 5, 0))
        teleport:Destroy()

        local Obj = Instance.new("ObjectValue")
        Obj.Name = player.Name
        Obj.Value = player
        Obj.Parent = Chosen.Players.InGame
        local Obj2 = Instance.new("ObjectValue")
        Obj2.Name = player.Name
        Obj2.Value = player
        Obj2.Parent = Chosen.Players.AllPlayers
        
        player.Character.Humanoid.Died:Connect(function()
            Obj:Destroy()
        end)
    end
end
-- End Private Function //
-- // Game Loop
function GameService:_intermission ()
    while (#Players:GetPlayers() < Knit.Config.minPlayers) do
        Knit:Wait(1)
        self:fireStatus ("Waiting for enough players")
    end
    for i = INTERMISSION_TIME, 1, -1 do
        Knit:Wait(1)
        self:setTime (i)
        self:fireStatus (("Intermission (%s)"):format(i))
    end
    self:fireStatus ("Choosing a minigame")
    Knit:Wait(2)
    self.Client.DisplayStatus:FireAll (self:getStatus())
    Chosen = MinigameService:ChooseMinigame()
    minigame = maps:FindFirstChild(Chosen.Name)
end
function GameService:_startGame ()
    self:fireStatus("Minigame has been chosen: " .. Chosen.Name)
    Chosen.Parent = workspace:FindFirstChild("Game")
    while (#Players:GetPlayers() < Knit.Config.minPlayers) do
        self:_intermission()
    end
    self:fireStatus("Minigame will began shortly")
    wait(1)
    print(minigame:GetAttribute("Objective"))
    local a = minigame:GetAttribute("Objective")
    for _, player in pairs(Players:GetPlayers()) do
        TeleportPlayer(player)
    end
    --self:setStatus ("Game")
    self.Client.ShowObjUI:FireAll ()
    repeat
        wait(1)
    until self.hasRoundEnded == true
    Chosen:Destroy()
end
-- End Game Loop //
-- // Status
function GameService:fireStatus (status: any)
    self.Client.DisplayStatus:FireAll(status)
end
function GameService:getStatus ()
    return Status.Value
end
-- End Status //

-- // Timer
function GameService:setTime (seconds: number)
    Timer.Value = seconds
end
function GameService:getTime ()
    return Timer.Value
end
-- End Timer //
-- Knit
function GameService:KnitStart ()
    while true do
        self:_intermission()
        self:_startGame()
    end
end
function GameService:KnitInit ()
    MinigameService = Knit.Services.MinigameService
end
-- End Knit //

return GameService