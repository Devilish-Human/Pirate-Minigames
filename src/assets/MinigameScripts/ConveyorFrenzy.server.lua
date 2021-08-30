local Knit = require(game:GetService("ReplicatedStorage").Knit)
local Janitor = require(Knit.Util.Janitor)

local minigame = script.Parent

local GameService = Knit.GetService("GameService")
local gameManager = GameService:GetGameManager()

local playersFolder = minigame:FindFirstChild("Players")
local ingamePlayersFolder = playersFolder:FindFirstChild("InGame")
local allPlayersFolder = playersFolder:FindFirstChild("AllPlayers")

local cleanJanitor = Janitor.new ()

local minigameObject = GameService:GetMinigameObject()

local conveyorSpeed = 1
local stopConveyor

local function SetConveyorState (currentTime: number)
	if (currentTime < 90 and currentTime > 70) then
		-- ConveyorBelt.Speed = 8
	end
end

for i = 10, 1, -1 do
	Knit:Wait(1)
	GameService:fireStatus (("Minigame will start in %s seconds"):format(tostring(i)))
end

minigame:FindFirstChild("BeginLine"):Destroy()

for i = minigameObject:GetAttribute("Length"), 1, -1 do
	GameService:fireStatus(("The minigame will end in %s seconds!"):format(tostring(i)))
	if (#ingamePlayersFolder:GetChildren() <= 0) then
		break
	end
	Knit:Wait(1)
end

gameManager:SetAttribute("hasEnded", true)
cleanJanitor:Cleanup()

-- Dens;100
--Elast;1
--ElastWe;100
--Fric;2
--FricWe;100