local Knit = require(game:GetService("ReplicatedStorage").Knit)
local Janitor = require(Knit.Util.Janitor)

local minigame = script.Parent

local GameService = Knit.GetService("GameService")
local gameManager = GameService:GetGameManager()

local playersFolder = minigame:FindFirstChild("Players")
local ingamePlayersFolder = playersFolder:FindFirstChild("InGame")
local allPlayersFolder = playersFolder:FindFirstChild("AllPlayers")

local cleanJanitor = Janitor.new()

local minigameObject = GameService:GetMinigameObject()

local AMOUNT_TO_GIVE = 10

cleanJanitor:Add(game.Players.PlayerRemoving:Connect(function(plr)
	if ingamePlayersFolder:FindFirstChild(plr.Name) then
		ingamePlayersFolder:FindFirstChild(plr.Name):Destroy()
	end
end))

cleanJanitor:Add(minigame.Finish.Touched:Connect(function(hit)
	local human = hit.Parent:FindFirstChild("Humanoid")
	if human then
		local player = game:GetService("Players"):GetPlayerFromCharacter(human.Parent)
		if player then
			gameManager:addWinner(player)
			gameManager:awardPlayer(player, "Coins", AMOUNT_TO_GIVE)
			gameManager:awardPlayer(player, "Wins", 1)
			player:LoadCharacter()
			if ingamePlayersFolder:FindFirstChild(player.Name) then
				ingamePlayersFolder:FindFirstChild(player.Name):Destroy()
			end
		end
	end
end))

for i = 5, 1, -1 do
	Knit:Wait(1)
	GameService:fireStatus(("Minigame will start in %s seconds"):format(tostring(i)))
end

minigame:FindFirstChild("BeginLine"):Destroy()

for i = minigameObject:GetAttribute("Length"), 1, -1 do
	GameService:fireStatus(("The minigame will end in %s seconds!"):format(tostring(i)))
	if #ingamePlayersFolder:GetChildren() <= 0 then
		break
	end
	Knit:Wait(1)
end

local RoundResults = {}

local loseMessages = { "Stayed behind.", "Did not finish.", "Ran slow." }
local wonMessages = { "Stayed ahead.", "Reached the end.", "Ran fast." }

for _, v in pairs(allPlayersFolder:GetChildren()) do
	if v.Value ~= nil and not table.find(gameManager.Winners, v.Value) then
		local message = loseMessages[math.random(1, #loseMessages)]

		if game:GetService("Players"):FindFirstChild(v.Value.Name) then
			RoundResults[v.Value.Name] = {
				Won = false,
				Message = message,
				Coins = 0,
			}
		else
			RoundResults[v.Value.Name] = {
				Won = false,
				Message = "Left the game.",
				Coins = 0,
			}
		end
	end
end

for i, v in pairs(gameManager.Winners) do
	print("Awarding!")
	if v then
		local message = wonMessages[math.random(1, #wonMessages)]
		RoundResults[v.Name] = {
			Won = true,
			Message = message,
			Coins = AMOUNT_TO_GIVE,
		}
	end
end

local tempResults = {}

for i, v in pairs(RoundResults) do
	if v.Won then
		tempResults[i] = v
	end
end

for i, v in pairs(RoundResults) do
	if v.Won == false then
		tempResults[i] = v
	end
end

RoundResults = tempResults

if RoundResults then
	GameService.Client.ShowResults:FireAll(RoundResults)
else
	return
end

gameManager:SetAttribute("hasEnded", true)
cleanJanitor:Cleanup()
