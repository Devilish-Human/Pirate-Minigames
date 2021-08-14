local Knit = require(game:GetService("ReplicatedStorage").Knit)

local minigame = script.Parent

local GameService = Knit.Services.GameService
local gameManager = GameService:GetGameManager()

local playersFolder = minigame:FindFirstChild("Players")
local ingamePlayersFolder = playersFolder:FindFirstChild("InGame")
local allPlayersFolder = playersFolder:FindFirstChild("AllPlayers")

local minigameObject = game.ServerStorage:FindFirstChild"Assets":FindFirstChild"Maps":FindFirstChild"Sweeper"

minigame.BeginLine:Destroy()

for i = minigameObject:GetAttribute("Length"), 1, -1 do
	GameService:fireStatus(("The minigame will end in %s seconds!"):format(tostring(i)))
	if (#ingamePlayersFolder:GetChildren() <= 1) then
		break
	end
	wait(1)
end

for i, v in pairs (gameManager.Winners) do
	print("Awarding!")
	if (v) then
		gameManager:awardPlayer (v, "Coins", 10)
		gameManager:awardPlayer (v, "Wins", 1)
	end
end

gameManager:SetAttribute("hasEnded", true)