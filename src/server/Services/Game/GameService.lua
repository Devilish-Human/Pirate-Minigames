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
local MinigameService, DataService, CmdrService

local GameFolder

local GameService = Knit.CreateService({
	Name = "GameService",
	Client = {
		StatusChanged = Knit:CreateSignal()
	},
	SetMinigame = Signal.new();
})

function GameService:_intermission()
	for i = 15, 1, -1 do
		task.wait(1)
		--print(`Choosing next minigame to play in {i} seconds`)
		self.Client.StatusChanged:FireAll(`Choosing next minigame to play in {i} seconds`)

		if (ForceChosenMinigame == nil or ForceChosenMinigame == "" or ForceChosenMinigame == " ") then
			Chosen = ForceChosenMinigame
			continue
		else
			break
		end

	end

	self.SetMinigame:Connect(function(v)
		if (v and MinigameService.Minigames[v]) then
			Chosen = v
		end
	end)

	if (Chosen) then
		return
	else
		Chosen = MinigameService:ChooseMinigame()
	end

	self.Client.StatusChanged:FireAll(`Minigame chosen: {Chosen}`)
	task.wait(2)
	print(Chosen)
end

function GameService:_startGame()
	local Minigame = MinigameService:PlaceMap(Chosen)

	self.Client.StatusChanged:FireAll(`Objective: {Minigame:GetAttribute("Objective")}`)
	task.wait(2)
	
	-- Teleport players

	self.Client.StatusChanged:FireAll("Teleporting players")
	for _, plr in pairs(MinigameService:GetPlayers()) do
		if plr then
			local teleport = Minigame.Teleports:GetChildren()[math.random(1, #Minigame.Teleports:GetChildren())]
			MinigameService:TeleportPlayer(plr, teleport)

			print(plr)
		end
	end


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

function _onPlayerAdded(player: Player)
	if (CmdrService.CheckedPlayers[player]) then return end
	CmdrService.CheckedPlayers[player] = true

	--if (not CmdrService.Watchdog.Verify(player)) then return end
end

function _onPlayerRemoving(player: Player)
	CmdrService.CheckedPlayers[player] = nil
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

	Players.PlayerAdded:Connect(_onPlayerAdded)
	Players.PlayerRemoving:Connect(_onPlayerRemoving)

	task.spawn(self:Initialize())

	task.spawn(function()
		while true do
			for _, player in ipairs(Players:GetPlayers()) do
				DataService:Update(player, "Coins", function(coins)
					if (coins) then
						return coins + Random.new():NextInteger(5, 25)
					end
				end)
				print(DataService:Get(player, "Coins"))
			end
			task.wait(1)
		end
	end)

	for _, player in ipairs(Players:GetPlayers()) do
		_onPlayerAdded(player)
	end
end

function GameService:KnitInit()
	MinigameService = Knit.GetService("MinigameService")
	DataService = Knit.GetService("DataService")
	CmdrService = Knit.GetService("CmdrService")
end
-- End Knit //
return GameService
