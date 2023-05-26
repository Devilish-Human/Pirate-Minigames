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

local AMOUNT_TO_GIVE = 15
local function getRandomSodaSpawn()
	local sodaSpawns = minigame:FindFirstChild("SodaSpawns"):GetChildren()
	return sodaSpawns[math.random(1, #sodaSpawns)].CFrame
end

local INTERVAL = 3
local SODA_OBJECTS = game.ServerStorage:FindFirstChild("Assets").Objects.Sodas:GetChildren()

local shouldTakeDamage

for _, v in pairs(ingamePlayersFolder:GetChildren()) do
	if v.Value then
		local char = v.Value.Character or v.Value.CharacterAdded:Wait()

		if char then
			char:FindFirstChild("Health").Disabled = true
		end

		for _, gear in pairs(v.Value:FindFirstChild("Backpack"):GetChildren()) do
			if gear then
				gear:Destroy()
			end
		end
	end
end

cleanJanitor:Add(game.Players.PlayerRemoving:Connect(function(plr)
	if ingamePlayersFolder:FindFirstChild(plr.Name) then
		ingamePlayersFolder:FindFirstChild(plr.Name):Destroy()
	end
end))

for i = 5, 1, -1 do
	Knit:Wait(1)
	GameService:fireStatus(("Minigame will start in %s seconds"):format(tostring(i)))
end
shouldTakeDamage = true

coroutine.wrap(function()
	while wait() do
		local clone = SODA_OBJECTS[math.random(1, #SODA_OBJECTS)]:Clone()
		local randomPos = getRandomSodaSpawn()
		clone.Parent = minigame:FindFirstChild("Objects")
		clone.Handle.CFrame = randomPos
		wait(INTERVAL)

		for _, v in pairs(ingamePlayersFolder:GetChildren()) do
			if v.Value and shouldTakeDamage then
				local char = v.Value.Character or v.Value.CharacterAdded:Wait()

				char.Humanoid:TakeDamage(5)
			end
		end
	end
end)()

for i = minigameObject:GetAttribute("Length"), 1, -1 do
	GameService:fireStatus(("The minigame will end in %s seconds!"):format(tostring(i)))
	if #ingamePlayersFolder:GetChildren() <= 0 then
		break
	end
	Knit:Wait(1)
end

for i, v in pairs(ingamePlayersFolder:GetChildren()) do
	local player = v.Value
	if player then
		print("Awarding")
		gameManager:awardPlayer(player, "Coins", AMOUNT_TO_GIVE)
		gameManager:awardPlayer(player, "Wins", 1)
		gameManager:addWinner(player)
		player:LoadCharacter()
		print("Awarded")
	end
end

local RoundResults = {}

local loseMessages = { "Dehydrated.", "Didn't drink." }
local wonMessages = { "Hydrated.", "Kept drinking." }

for i, v in pairs(allPlayersFolder:GetChildren()) do
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

for _, v in pairs(ingamePlayersFolder:GetChildren()) do
	if v.Value then
		local char = v.Value.Character or v.Value.CharacterAdded:Wait()

		if char then
			char:FindFirstChild("Health").Disabled = false
		end
	end
end
shouldTakeDamage = false

wait(2)
GameService.Client.ShowResults:FireAll(RoundResults)
gameManager:SetAttribute("hasEnded", true)
cleanJanitor:Cleanup()
