-- File: ConveyorFrenzy
-- Authors: PirateNinja Studios / PirateNinja Twelve
-- Date: 06/08/2023

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Knit = require(ReplicatedStorage:FindFirstChild("Packages").Knit)
local Janitor = require(ReplicatedStorage:FindFirstChild("Packages").Janitor)

local Minigame = require(script.Parent)
local DataService, GameService, MinigameService

local ASSETS_FOLDER = ServerStorage:FindFirstChild("Assets")
local SODA_FOLDER = ASSETS_FOLDER:FindFirstChild("Objects").Sodas

local ConveyorFrenzy = Minigame.new {
	Name = "ConveyorFrenzy",
	Objective = "Surive the incoming conveyor speeds and don't get knocked off.",
	Type = "Survival",
	Reward = {
		Points = 15,
		Exp = 6,
	},
}
ConveyorFrenzy.__index = ConveyorFrenzy

function ConveyorFrenzy:Get()
   return self.Instance
end

function ConveyorFrenzy:_spawnRandomPart()
    local touchConnection
	if canSpawnBlocks then
		local rotations = { 0, 90 }
		local randomRotation = rotations[math.random(1, #rotations)]

		local allParts = game:GetService("ServerStorage").Assets.Objects.Parts:GetChildren()

		--local partModel = allParts[math.random(1, #allParts)]:Clone()
		local part = allParts[math.random(1, #allParts)]:Clone()

		--local part = Instance.new("Part")
		part.Parent = self.Instance.Blocks

		local xPos, zPos, yRotate, xSize, zSize

		xPos = math.random(488, 516)
		--zPos = math.random(-154, 9)

		yRotate = randomRotation

		--xSize = math.random(37, 40)
		--zSize = math.random(4, 10)
		part.Position = Vector3.new(xPos, 31.76, -155)
		part.Rotation = Vector3.new(0, yRotate, 0)

		part.Color = Color3.fromRGB(math.random(1, 255), math.random(1, 255), math.random(1, 255))

		debounce = false
		part.Touched:Connect(function(hit)
			if not debounce then
				debounce = true
				local humanoid = hit.Parent:FindFirstChild("Humanoid")
				if humanoid then
					humanoid:TakeDamage(10)
				end
				wait(0.75)
				debounce = false
			end
		end)
	else
		if self.Instance.Conveyor:GetAttribute("Speed") > 0 and self.Instance.Conveyor:GetAttribute("Speed") <= 6 then
			canSpawnBlocks = false
		end
		for _, v in pairs(self.Instance.Blocks:GetChildren()) do
			if v.Name == "P1" or v.Name == "P2" then
				--v:Destroy()
				return
			end
		end
	end
end

function ConveyorFrenzy:Initialize()
    GameService = Knit.CreateService("GameService")
    DataService = Knit.CreateService("DataService")
    MinigameService = Knit.CreateService("MinigameService")
end

function ConveyorFrenzy:Start()
    
end

function ConveyorFrenzy:Stop()
    
end

function ConveyorFrenzy:Destroy()
    
end

return ConveyorFrenzy