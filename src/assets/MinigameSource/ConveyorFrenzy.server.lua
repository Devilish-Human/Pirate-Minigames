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

local spawnDelay = 0.15
local canSpawnBlocks = false

local function setSpeedWithTime (remainingTime)
	if (remainingTime < 90 and remainingTime >= 75) then
		minigame.Conveyor:SetAttribute("Speed", 8)
	elseif remainingTime < 75 and remainingTime >= 55 then
		minigame.Conveyor:SetAttribute("Speed", 12)
	elseif remainingTime < 55 and remainingTime >= 35 then
		minigame.Conveyor:SetAttribute("Speed", 16)
	elseif remainingTime < 35 and remainingTime >= 5 then
		minigame.Conveyor:SetAttribute("Speed", 20)
	elseif remainingTime < 5 and remainingTime >= 4 then
		minigame.Conveyor:SetAttribute("Speed", 7)
	else
		minigame.Conveyor:SetAttribute("Speed", 0)
	end
end

cleanJanitor:Add(game.Players.PlayerRemoving:Connect(function(plr)
	if ingamePlayersFolder:FindFirstChild(plr.Name) then
		ingamePlayersFolder:FindFirstChild(plr.Name):Destroy()
	end
end))

for i = 5, 1, -1 do
	Knit:Wait(1)
	GameService:fireStatus (("Minigame will start in %s seconds"):format(tostring(i)))
end
canSpawnBlocks = true

for _,v in pairs(ingamePlayersFolder:GetChildren()) do
	if v.Value.Character then
		local human = v.Value.Character:FindFirstChild("Humanoid")
		if human and human.RigType == Enum.HumanoidRigType.R6 then
			human.JumpPower = 0
		else
			human.JumpHeight = 0
		end
	end
end


local function setVelocity()
	local conveyorVelocity = 1 * minigame.Conveyor:GetAttribute("ConveyorSpeed")
	minigame.Conveyor.AssemblyLinearVelocity = conveyorVelocity
end

setVelocity()
minigame.Conveyor:GetAttributeChangedSignal("ConveyorSpeed"):Connect(setVelocity)

function SpawnRandomPart ()
	local touchConnection
	if (canSpawnBlocks) then
		local rotations = { 0, 90 }
		local randomRotation = rotations[math.random(1, #rotations)]
		
		local allParts = game:GetService("ServerStorage").Assets.Objects.Parts:GetChildren()
		
		--local partModel = allParts[math.random(1, #allParts)]:Clone()
		local part = allParts[math.random(1, #allParts)]:Clone()
		
		--local part = Instance.new("Part")
		part.Parent = minigame.Blocks
		
		local xPos, zPos, yRotate, xSize, zSize
		
		xPos = math.random(488, 516)
		--zPos = math.random(-154, 9)
		
		yRotate = randomRotation
		
		--xSize = math.random(37, 40)
		--zSize = math.random(4, 10)
		part.Position = Vector3.new(xPos, 31.76, -155)
		part.Rotation = Vector3.new(0, yRotate, 0)
		
		part.Color = Color3.fromRGB(math.random(1, 255),math.random(1, 255), math.random(1, 255))
		
		debounce = false
		cleanJanitor:Add(part.Touched:Connect(function(hit)
			if not debounce then
				debounce = true
				local humanoid = hit.Parent:FindFirstChild("Humanoid")
				if humanoid then
					humanoid:TakeDamage(10)
				end
				wait(.75)
				debounce = false
			end
		end))
	else
		if (minigame.Conveyor:GetAttribute("Speed") > 0 and minigame.Conveyor:GetAttribute("Speed") <= 6) then canSpawnBlocks = false end
		for _,v in pairs(minigame.Blocks:GetChildren()) do
			if (v.Name == "P1" or v.Name == "P2") then
				--v:Destroy()
				return
			end
		end
	end
end

task.spawn(function()
	while canSpawnBlocks do
		for i = 1, 3, 1 do
			SpawnRandomPart()
			Knit:Wait(1)
		end
		Knit:Wait(spawnDelay * 3)
	end
end)

for i = minigameObject:GetAttribute("Length"), 1, -1 do
	GameService:fireStatus(("The minigame will end in %s seconds!"):format(tostring(i)))
	if (#ingamePlayersFolder:GetChildren() <= 0) then
		break
	end
	setSpeedWithTime(i)
	Knit:Wait(1)
end

for i, v in pairs(ingamePlayersFolder:GetChildren()) do
	local player = v.Value
	if player then
		gameManager:awardPlayer(player, "Coins", 15)
		gameManager:awardPlayer(player, "Wins", 1)
		player:LoadCharacter()
	end
end
task.wait(2)

for _,plr in pairs(game.Players:GetPlayers()) do
	if plr.Character then
		local human = plr.Character:FindFirstChild("Humanoid")
		if human and human.RigType == Enum.HumanoidRigType.R6 then
			human.JumpPower = 50
		else
			human.JumpHeight = 7.2
		end
	end
end

local RoundResults = {}

local loseMessages = { "Fell into the void", "Got pushed off." }
local wonMessages = { "Survived the blocks", "Didn't get pushed" }

for i, v in pairs (allPlayersFolder:GetChildren()) do
	if (v.Value ~= nil) then
		gameManager:awardPlayer (v.Value, "Coins", 0)

		local message = loseMessages[math.random(1, #loseMessages)]

		RoundResults[v.Value.Name] = {
			Won = false,
			Message = message,
			Coins = 0
		}
	end
end

for i, v in pairs (gameManager.Winners) do
	print("Awarding!")
	if (v) then
		gameManager:awardPlayer (v, "Coins", 5)
		local message = wonMessages[math.random(1, #wonMessages)]
		RoundResults[v.Name] = {
			Won = true,
			Message = message,
			Coins = 15
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

canSpawnBlocks = false
--GameService.Client.ShowResults:FireAll (RoundResults)
gameManager:SetAttribute("hasEnded", true)
cleanJanitor:Cleanup()