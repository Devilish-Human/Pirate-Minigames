local Knit = require(game:GetService("ReplicatedStorage").Knit)
local Maid = require(Knit.Util.Maid)

local minigame = script.Parent

local GameService = Knit.GetService("GameService")
local gameManager = GameService:GetGameManager()

local playersFolder = minigame:FindFirstChild("Players")
local ingamePlayersFolder = playersFolder:FindFirstChild("InGame")
local allPlayersFolder = playersFolder:FindFirstChild("AllPlayers")

local cleanMaid = Maid.new ()

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
		end
	end
end
cleanMaid:GiveTask(minigame.Finish.Touched:Connect(onTouch))

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

local RoundResults = {}

for i, v in pairs (gameManager.Winners) do
	print("Awarding!")
	if (v) then
		gameManager:awardPlayer (v, "Coins", 10)
		RoundResults[v.Name] = {
			Won = true,
			Message = "Reached the end",
			Coins = 10
		}
		gameManager:awardPlayer (v, "Wins", 1)
	end
end

for i, v in pairs (allPlayersFolder:GetChildren()) do
	if (v.Value ~= nil) then
		gameManager:awardPlayer(v.Value, "Coins", 5)
		RoundResults[v.Value.Name] = {
			Won = false,
			Message = "DNF",
			Coins = 5
		}
	end
end

GameService.Client.ShowResults:FireAll (RoundResults)
gameManager:SetAttribute("hasEnded", true)
cleanMaid:Destroy()