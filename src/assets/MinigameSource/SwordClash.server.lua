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

local AMOUNT_TO_GIVE = 20

local SWORDS = game:GetService("ServerStorage").Assets.Objects.Swords

for _, v in pairs (ingamePlayersFolder:GetChildren()) do
    if v.Value then
        for _, gear in pairs (v.Value:FindFirstChild("Backpack"):GetChildren()) do
            if gear then
                gear:Destroy()
            end
        end

        for _, v in pairs (v.Value.Character:GetChildren()) do
            if v:IsA("Tool") then
                v:Destroy()
            end
        end
    end
end

cleanJanitor:Add(game.Players.PlayerRemoving:Connect(function(plr)
	if ingamePlayersFolder:FindFirstChild(plr.Name) then
		ingamePlayersFolder:FindFirstChild(plr.Name):Destroy()
	end
end))
print("Line 30: A")

for i = 5, 1, -1 do
	Knit:Wait(1)
	GameService:fireStatus (("Minigame will start in %s seconds"):format(tostring(i)))
end

print ("Line 36: A")

for i,v in pairs (ingamePlayersFolder:GetChildren()) do
    print("Line 38: A")
    if v.Value then
        print("Line 40: A")
        local player = v.Value

        if player and player.Character then
            print("A")
            local sword = SWORDS.Cutlass:Clone()
            print("B")
            sword.Parent = player.Backpack
            print("C")
        end
    end
end
print("D")

wait()
for i = minigameObject:GetAttribute("Length"), 1, -1 do
	GameService:fireStatus(("The minigame will end in %s seconds!"):format(tostring(i)))
	if (#ingamePlayersFolder:GetChildren() <= 1) then
		break;
	end
	Knit:Wait(1)
end

print("Line 70: A")
for i, v in pairs(ingamePlayersFolder:GetChildren()) do
	local player = v.Value
	if player and not table.find(gameManager.Winners, v) then
		gameManager:awardPlayer(player, "Coins", 10)
		gameManager:awardPlayer(player, "Wins", 1)

		player:LoadCharacter()
	end
end

local RoundResults = {}

for i, v in pairs (allPlayersFolder:GetChildren()) do
	if (v.Value ~= nil) then

        if (game:GetService("Players"):FindFirstChild(v.Value.Name)) then
            RoundResults[v.Value.Name] = {
                Won = false,
                Message = "Died.",
                Coins = 0
            }
        else
            RoundResults[v.Value.Name] = {
                Won = false,
                Message = "Left the game.",
                Coins = 0
            }
        end
	end
end

if (#ingamePlayersFolder:GetChildren() > 1) then
    for i, v in pairs (ingamePlayersFolder:GetChildren()) do

        RoundResults[v.Value.Name] = {
            Won = true,
            Message = "Survived.",
            Coins = 10
        }

        v.Value:LoadCharacter()
    end
elseif #ingamePlayersFolder:GetChildren() == 1 then
    gameManager:addWinner (ingamePlayersFolder:GetChildren()[1].Value)
end

for i, v in pairs (gameManager.Winners) do
	print("Awarding!")
	if (v) then

        gameManager:awardPlayer(v, "Coins", 20)
        gameManager:awardPlayer(v, "Wins", 1)

		RoundResults[v.Name] = {
			Won = true,
			Message = "Last one standing.",
			Coins = 20
		}
	end
end

local tempResults = {}

for i,v in pairs (RoundResults) do
	if v.Won then
		tempResults[i] = v
	end
end

for i,v in pairs (RoundResults) do
	if v.Won == false then
		tempResults[i] = v
	end
end

RoundResults = tempResults

wait(1)
GameService.Client.ShowResults:FireAll (RoundResults)
gameManager:SetAttribute("hasEnded", true)
cleanJanitor:Cleanup()