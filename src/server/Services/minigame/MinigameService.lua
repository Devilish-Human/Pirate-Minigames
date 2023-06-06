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
})

--local Minigames = require(Knit.Modules.MinigameData)
local Minigames = {"ObbyRunaway"}
local MapsFolder = ServerStorage:FindFirstChild("Assets"):FindFirstChild("Maps")

function MinigameService:ChooseMinigame()
    local minigame = Minigames[math.random(1, #Minigames)]
    return minigame
end


function MinigameService:PlaceMap(minigame: string)
    local minigameMaps = MapsFolder[minigame]:GetChildren()
    local chosenMap = minigameMaps[math.random(1, #minigameMaps)]:Clone()
    local class = require(ServerScriptService.Framework.Class.Minigame:FindFirstChild(minigame))

    local minigameModule

    if (class) then
        minigameModule = class.new(chosenMap)

        
        chosenMap:SetAttribute("Name", minigameModule.Name)
        chosenMap:SetAttribute("Objective", minigameModule.Objective)
        chosenMap:SetAttribute("Type", minigameModule.Type)
        chosenMap:SetAttribute("Finished", false)
        
        minigameModule:Init()
        
        local connection = workspace.ChildRemoved:Connect(function(child)
            if (child.Name == chosenMap.Name) then
                minigameModule:Destroy()
            end
        end)

        self.StartMinigame:Connect(function ()
            print(minigameModule.Name)
            print(minigameModule.Objective)
            minigameModule:Start()
        end)
        self.StopMinigame:Connect(function ()
            connection:Disconnect()
            minigameModule:Destroy()
        end)

    end

    chosenMap.Parent = workspace.Game

    return chosenMap
end

return MinigameService