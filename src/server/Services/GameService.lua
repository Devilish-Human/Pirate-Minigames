-- File: GameService
-- Author: PirateNinja
-- Date: 07/16/2021

local Knit = require(game:GetService("ReplicatedStorage").Knit)

-- // Utilities \\ --
local Signal = require(Knit.Util.Signal)
local RemoteSignal = require(Knit.Util.Remote.RemoteSignal)
local Component = require(Knit.Util.Component)

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
        Obj.Value.Character.Humanoid.WalkSpeed = 0
        Obj.Value.Character.Humanoid.JumpPower = 0
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
    local gameManager = self:GetGameManager()
    self:fireStatus("Minigame has been chosen: " .. Chosen.Name)
    Chosen.Parent = workspace:FindFirstChild("Game")
    while (#Players:GetPlayers() < Knit.Config.minPlayers) do
        self:_intermission()
    end
    wait(1)
    local a = minigame:GetAttribute("Objective")
    self:fireStatus("Teleporting players..")
    for _, player in pairs(Players:GetPlayers()) do
        TeleportPlayer(player)
    end
    wait(1)
    --self:setStatus ("Game")
    self:fireStatus("Minigame will began shortly")
    self.Client.ShowObjUI:FireAll (minigame:GetAttribute("Name"), minigame:GetAttribute("Objective"))
    wait(1.25)
    for i, v in pairs (Chosen.Players.InGame:GetChildren()) do
        v.Value.Character.Humanoid.WalkSpeed = 16
        v.Value.Character.Humanoid.JumpPower = 50
    end
    Chosen:FindFirstChild("MinigameScript").Disabled = false
    repeat
        wait(1)
    until gameManager:GetAttribute("hasRoundEnded")
    print("A")
    Chosen:Destroy()
end
function GameService:GetGameManager()
    return Component.FromTag("GameManager"):GetFromInstance(workspace.Game)
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