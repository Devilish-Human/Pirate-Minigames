-- File: GameService
-- Author: PirateNinja
-- Date: 07/16/2021

local Knit = require(game:GetService("ReplicatedStorage").Knit)

-- // Utilities \\ --
local Signal = require(Knit.Util.Signal)
local RemoteSignal = require(Knit.Util.Remote.RemoteSignal)
local Component = require(Knit.Util.Component)

-- // Shared Modules
-- End Shared Modules //

-- // Roblox Services \\ --
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local maps = ServerStorage.Assets.Maps
local minigame

local INTERMISSION_TIME = Knit.Config.intermissionTime;

local Chosen;
local MinigameService;

local GameService = Knit.CreateService {
    Name = "GameService";
    Client = {
        ShowObjUI = RemoteSignal.new ();
        DisplayStatus = RemoteSignal.new ();
        ShowResults = RemoteSignal.new ();
    };
}

-- // Private Function
local function GetPlayers()
    local Players = {}
    for ind, plr in next, game:GetService("Players"):GetChildren() do
        if (plr:FindFirstChild("isAFK") and not plr:FindFirstChild("isAFK").Value) then
            table.insert(Players, plr)
        end
    end
    return Players
end

local function TeleportPlayer(player)
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
    for i = INTERMISSION_TIME, 1, -1 do
        Knit:Wait(1)
        --self:setTime (i)
        self:fireStatus (("Intermission (%s)"):format(i))
    end

    self:fireStatus ("Choosing a minigame")
    Knit:Wait(2)
    
    Chosen = MinigameService:ChooseMinigame()
    minigame = maps:FindFirstChild(Chosen.Name)
end

function GameService:_startGame ()
    local gameManager = self:GetGameManager()
    self:fireStatus("Minigame has been chosen: " .. minigame:GetAttribute("Name"))
    Chosen.Parent = workspace:FindFirstChild("Game")
    Knit:Wait(2)
    local a = minigame:GetAttribute("Objective")
    self:fireStatus("Teleporting players..")
    for _, player in pairs(GetPlayers()) do
        TeleportPlayer(player)
        self.Client.ShowObjUI:Fire (player, minigame:GetAttribute("Name"), minigame:GetAttribute("Objective"))
    end
    Knit:Wait(1)
    --gameManager.HasEnded:Fire()
    Chosen:FindFirstChild("MinigameScript").Disabled = false
    repeat
        Knit:Wait(1)
    until gameManager:GetAttribute("hasEnded")
    for _, v in pairs(Chosen.Players.InGame:GetChildren()) do
        if v.Value then
            v.Value:LoadCharacter()
        end
    end
    Chosen:Destroy()
end

function GameService:GetGameManager()
    return Component.FromTag("GameManager"):GetFromInstance(workspace.Game)
end

function GameService:GetMinigameObject ()
    return minigame
end

function GameService:ToggleAFK (player: Player)
    local afkValue = player:FindFirstChild("isAFK")
    afkValue.Value = not afkValue.Value
end
-- End Game Loop //
-- // Status
function GameService:fireStatus (status: any)
    self.Client.DisplayStatus:FireAll(status)
end

function GameService.Client:ToggleAFK (player: Player)
    return self.Server:ToggleAFK (player)
end

-- Knit
function GameService:KnitStart ()
    while true do
        if (#GetPlayers() < Knit.Config.minPlayers) then
            self:fireStatus (("Waiting for enough player(s)"))
            Knit:Wait()
        else
            self:_intermission()
            self:_startGame()
        end
    end
end
function GameService:KnitInit ()
    MinigameService = Knit.GetService("MinigameService")
end
-- End Knit //
return GameService