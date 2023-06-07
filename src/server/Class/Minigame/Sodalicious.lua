-- File: Sodalicious
-- Authors: PirateNinja Studios / PirateNinja Twelve
-- Date: 06/06/2023

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Knit = require(ReplicatedStorage:FindFirstChild("Packages").Knit)
local Janitor = require(ReplicatedStorage:FindFirstChild("Packages").Janitor)

local Minigame = require(script.Parent)
local DataService, GameService, MinigameService


local ASSETS_FOLDER = ServerStorage:FindFirstChild("Assets")
local SODA_FOLDER = ASSETS_FOLDER:FindFirstChild("Objects").Sodas

local Sodalicious = Minigame.new {
	Name = "Sodalicious",
	Objective = "Complete the obby to win.",
	Type = "Survival",
	Reward = {
		Points = 15,
		Exp = 6,
	},
}
Sodalicious.__index = Sodalicious

function Sodalicious.new(instance: Instance)
    local self = setmetatable({}, Sodalicious)
	self._janitor = Janitor.new()
	self.Instance = instance
	self.Finished = false;
	self._shouldTakeDamage = false
	return self
end

function Sodalicious:Initialize()
    DataService = Knit.GetService("DataService")
	GameService = Knit.GetService("GameService")
	MinigameService = Knit.GetService("MinigameService")

	self._janitor:Add(MinigameService.SetFinished:Connect(function(state)
		self.Finished = state

		self.Instance:SetAttribute("Finished", self.Finished)
	end))
	self._janitor:Add(Players.PlayerRemoving:Connect(function(plr)
		local plrIndex = table.find(self.Contestants, plr)
		if (table.find(self.Contestants, plr)) then
			table.remove(self.Contestants, plrIndex)
		end
	end))
end

function Sodalicious:Get()
	return self.Instance
end

function Sodalicious:Start()
	local function getRandomSodaSpawn()
		local sodaSpawns = self.Instance:FindFirstChild("SodaSpawns"):GetChildren()
		return sodaSpawns[math.random(1, #sodaSpawns)].CFrame
	end

	for _, v in pairs (self.Contestants) do
		if v.Value then
			local char = v.Character or v.CharacterAdded:Wait()
	
			if char then
				char:FindFirstChild("Health").Disabled = true
			end
		end
	end

	for i = 10, 1, -1 do
		task.wait(1)
		--print(`Minigame will start in {i} seconds.`)
		GameService.Client.StatusChanged:FireAll(`Minigame will start in {i} seconds.`)

		if (i == 1) then
			GameService.Client.StatusChanged:FireAll("Setting up minigame.")
		end
	end
	self._shouldTakeDamage = true

	self._janitor:Add(task.spawn(function()
		while true do
			task.wait(1)
			local sodaClone = SODA_FOLDER:GetChildren()[math.random(1, #SODA_FOLDER:GetChildren())]:Clone()
			sodaClone.Parent = self.Instance:FindFirstChild("Objects")
			sodaClone.Handle.CFrame = getRandomSodaSpawn()
			sodaClone.SodaScript.Enabled = true

			for _, plr in pairs(self.Contestants) do
				if (plr and self._shouldTakeDamage) then
					local char = plr.Character or plr.Character.CharacterAdded:Wait()
					char.Humanoid:TakeDamage(5)
				end
			end

			task.wait(1)
		end
	end))

	for i = self.Length, 1, -1 do
		task.wait(1)
		--print(`Minigame will end in {i} seconds.`)
		GameService.Client.StatusChanged:FireAll(`Minigame will end in {i} seconds.`)

		if (#self.Contestants <= 0) then
			break
		end
	end


	for i, v in self.Contestants do
		local player: Player = v

		if (player) then
			self:_addWinner(player)
			self:_awardPlayer(player)
			player:LoadCharacter()
		end
	end

	MinigameService.SetFinished:Fire(true)
end

function Sodalicious:_addWinner(player: Player)
	if (self.Contestants[player] and not self.Winners[player]) then
		table.insert(self.Winners, player)
	end
end

function Sodalicious:_awardPlayer(player: Player)
	if (#self.Winners == 1) then
		DataService:Update(player, "Coins", function(money)
			return money + (self.Reward.Points * 1.25)
		end)
	else
		DataService:Update(player, "Coins", function(money)
			return money + (self.Reward.Points)
		end)
	end
	DataService:Update(player, "Wins", function(money)
		return money + 1
	end)
end


function Sodalicious:Stop()
    local message = "Survived"

	for index,player in ipairs(self.Winners) do
		if (table.find(self.Contestants, index)) then
			self:_awardWinners(player)
		end
	end

	if (#self.Winners == 1) then
		for _,winner in ipairs(self.Winners) do
			self.RoundResult[winner.Name] = {
				Won = true,
				Message = "Sole Survivor",
				Coins = (self.Reward.Points * 1.25)
			}
		end
	else
		for _,winner in ipairs(self.Winners) do
			self.RoundResult[winner.Name] = {
				Won = true,
				Message = message,
				Coins = self.Reward.Points
			}
		end
	end
end

function Sodalicious:Destroy()
	table.clear(self.Players)
	table.clear(self.Contestants)
	table.clear(self.Winners)

    self._janitor:Cleanup()
end

return Sodalicious