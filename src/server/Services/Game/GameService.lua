-- File: GameService
-- Author: PirateNinja
-- Date: 07/16/2021

-- // Roblox Services \\ --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")


-- // Packages \\
local Knit = require(ReplicatedStorage:FindFirstChild("Packages").Knit)
local Signal = require(ReplicatedStorage:FindFirstChild("Packages").Signal)

-- // Utilities \\ --

-- // Shared Modules \\

-------------------------

local Chosen
local ForceChosenMinigame = nil
local MinigameService

local GameFolder

local GameService = Knit.CreateService({
	Name = "GameService",
	Client = {
		StatusChanged = Knit:CreateSignal()
	},
	SetMinigame = Signal.new();
})

function GameService:_intermission()
	self.SetMinigame:Connect(function(v)
		ForceChosenMinigame = v
	end)

	for i = 15, 1, -1 do
		task.wait(1)
		print(`Choosing next minigame to play in {i} seconds`)
		self.Client.StatusChanged:FireAll(`Choosing next minigame to play in {i} seconds`)

		if (ForceChosenMinigame == nil or ForceChosenMinigame == "" or ForceChosenMinigame == " ") then
			Chosen = ForceChosenMinigame
			continue
		else
			break
		end

	end

	Chosen = MinigameService:ChooseMinigame() or ForceChosenMinigame


	print(Chosen)
end

function GameService:_startGame()
	local Minigame = MinigameService:PlaceMap(Chosen)
	
	print(Minigame)

	MinigameService.StartMinigame:Fire()

	-- for i = 60, 1, -1 do
	-- 	print(`Minigame will end in {i} seconds.`)
	-- 	if (Minigame:GetAttribute("Finished") == true) then
	-- 		MinigameService.StopMinigame:Fire()
	-- 		break
	-- 	end
	-- 	task.wait(1)
	-- end

	repeat
		task.wait(1)
	until Minigame:GetAttribute("Finished")


	MinigameService.StopMinigame:Fire()
	Minigame:Destroy()
end


function GameService:Initialize()
	while true do
		self:_intermission()
		self:_startGame();
		task.wait(1)
	end
end

-- Knit
function GameService:KnitStart()
	if (GameFolder == nil) then
		GameFolder = Instance.new("Folder")
		GameFolder.Name = "Game"
		GameFolder.Parent = workspace
	else
		GameFolder = workspace.Game
	end

	task.spawn(self:Initialize())
end

function GameService:KnitInit()
	MinigameService = Knit.GetService("MinigameService")
end
-- End Knit //
return GameService
