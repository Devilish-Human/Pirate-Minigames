-- File: GameService
-- Author: PirateNinja
-- Date: 07/16/2021

local Knit = require(game:GetService("ReplicatedStorage").Knit)

-- // Utilities \\ --
local Signal = require(Knit.Util.Signal)
local RemoteSignal = require(Knit.Util.Remote.RemoteSignal)
local Thread = require(Knit.Util.Thread)

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
}

-- // Game Loop
function GameService:_intermission ()
    while (#Players:GetPlayers() < Knit.Config.minPlayers) do
        wait()
        self:setStatus ("Waiting for enough players")
    end
    self:setStatus ("Intermission")
    for i = INTERMISSION_TIME, 1, -1 do
        self:setTime (i)
        self.Client.DisplayStatus:FireAll (self:getStatus() .. ' (' .. i .. ')')
    end
    self:setStatus ("Choosing a minigame")
    Chosen = MinigameService:ChooseMinigame()
    minigame = maps:FindFirstChild(Chosen.Name)
    self:setStatus("Minigame has been chosen: " .. Chosen.Name)
end
function GameService:_startGame ()
    Chosen.Parent = workspace:FindFirstChild("Game")
    while (#Players:GetPlayers() < Knit.Config.minPlayers) do
        self:_intermission()
    end
    self:setStatus ("Game")
    print(minigame:GetAttribute("Objective"))
    self.Client.ShowObjUI:FireAll (Chosen.Name, minigame:GetAttribute("Objective"))
    for i = minigame:GetAttribute("Length"), 1, -1 do
        self:setTime (i)
        wait(1)
        self.Client.DisplayStatus:FireAll (self:getStatus() .. ' (' .. i .. ')')
    end
    Chosen:Destroy()
    Chosen = nil
end
-- End Game Loop //

-- // Status
function GameService:setStatus (status: string)
    Status.Value = status
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
-- // Client
function GameService.Client:getTime ()
    return self.Server:getTime ()
end
function GameService.Client:getStatus ()
    return self.Server:getStatus ()
end
-- End Client //
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