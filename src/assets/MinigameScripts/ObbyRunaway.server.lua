local Knit = require(game:GetService("ReplicatedStorage").Knit)

local minigame = script.Parent

local GameService = Knit.Services.GameService
local gameManager = GameService:GetGameManager()

local playersFolder = minigame:FindFirstChild("Players")
local ingamePlayersFolder = playersFolder:FindFirstChild("InGame")
local allPlayersFolder = playersFolder:FindFirstChild("AllPlayers")

local minigameObject = GameService:GetMinigameObject()

function onTouch (hit)
	local human = hit.Parent:FindFirstChild("Humanoid")
	if (human) then
		local player = game:GetService("Players"):GetPlayerFromCharacter(human.Parent)
		if (player) then
			gameManager:addWinner (player)
			player:LoadCharacter()
			if ingamePlayersFolder:FindFirstChild(player.Name) then
				ingamePlayersFolder:FindFirstChild(player.Name):Destroy()
			end
			print(gameManager.Winners)
			print(("Added winner %s!"):format(player.Name))
		end
	end
end
minigame.Finish.Touched:Connect(onTouch)

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