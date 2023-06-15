local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")
local Knit = require(ReplicatedStorage:FindFirstChild("Packages").Knit)
local Signal = require(ReplicatedStorage:FindFirstChild("Packages").Signal)

local MinigameService = Knit.CreateService({
	Name = "MinigameService",
	Client = {},

    StartMinigame = Signal.new();
    StopMinigame = Signal.new();
    SetFinished = Signal.new();
    Minigames = require(script.Parent.MinigameData);
})

--local Minigames = require(script.Parent.MinigameData)

local MapsFolder = ServerStorage:FindFirstChild("Assets"):FindFirstChild("Maps")

local GameService

function MinigameService:GetPlayers()
    local Players = {}
    for _, player in next, game:GetService("Players"):GetChildren() do
        if (player:FindFirstChild("isAFK") and not player:FindFirstChild("isAFK").Value) then
            table.insert(Players, player)
        end
    end
    return Players
end

function MinigameService:ChooseMinigame()
    local minigame = self.Minigames[math.random(1, #self.Minigames)]
    return minigame
end

local Minigame
function MinigameService:PlaceMap(minigame: string)
    local minigameMaps = MapsFolder[minigame]:GetChildren()
    local chosenMap = minigameMaps[math.random(1, #minigameMaps)]:Clone()
    local MinigameModule = require(ServerScriptService.Framework.Class.Minigame:FindFirstChild(minigame))


    if (MinigameModule) then
        Minigame = MinigameModule.new(chosenMap)

        
        chosenMap:SetAttribute("Name", Minigame.Name)
        chosenMap:SetAttribute("Objective", Minigame.Objective)
        chosenMap:SetAttribute("Type", Minigame.Type)
        chosenMap:SetAttribute("Finished", false)
        
        Minigame:Initialize()
        
        local connection = workspace.ChildRemoved:Connect(function(child)
            if (child.Name == chosenMap.Name) then
                Minigame:Destroy()
            end
        end)

        self.StartMinigame:Connect(function ()
            Minigame:Start()
        end)
        self.StopMinigame:Connect(function ()
            connection:Disconnect()
            Minigame:Destroy()
        end)
    end

    chosenMap.Parent = workspace.Game

    return chosenMap
end

function MinigameService:TeleportPlayer(player: Player, teleportLocation)
    if player and player.Character and player.Character.PrimaryPart ~= nil then
        player.Character.PrimaryPart.CFrame = teleportLocation.CFrame * CFrame.new(0, 5, 0)
        teleportLocation:Destroy()

        table.insert(Minigame.Contestants, player)
        table.insert(Minigame.Players, player)

        player.Character.Humanoid.Died:Connect(function()
            table.remove(Minigame.Contestants, 1)
        end)

        GameService.Client.ShowObjective:Fire(player, Minigame.Name, Minigame.Objective)

        print(Minigame.Contestants)
        print(Minigame.Players)
    end
end

function MinigameService:KnitInit()
    GameService = Knit.GetService("GameService")
end

return MinigameService