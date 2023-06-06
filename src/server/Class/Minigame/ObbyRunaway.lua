-- File: ObbyRunaway
-- Authors: PirateNinja Studios / PirateNinja Twelve
-- Date: 05/25/2023

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage:FindFirstChild("Packages").Knit)
local Janitor = require(ReplicatedStorage:FindFirstChild("Packages").Janitor)

local Minigame = require(script.Parent)
local DataService, GameService, MinigameService

local ObbyRunaway = Minigame.new {
	Name = "ObbyRunaway",
	Objective = "Complete the obby to win.",
	Type = "Race",
	Reward = {
		Points = 10,
		Exp = 6,
	},
}
ObbyRunaway.__index = ObbyRunaway


function ObbyRunaway.new(instance: Instance)
	local self = setmetatable({}, ObbyRunaway)
	self._janitor = Janitor.new()
	self.Instance = instance
	self.Finished = false;
	self.Length = 60
	return self
end

function ObbyRunaway:Init()
	DataService = Knit.GetService("DataService")
	GameService = Knit.GetService("GameService")
	MinigameService = Knit.GetService("MinigameService")

	MinigameService.SetFinished:Connect(function(state)
		self.Finished = state

		self.Instance:SetAttribute("Finished", self.Finished)
	end)
end

function ObbyRunaway:Get()
	return self.Instance
end

function ObbyRunaway:Start()
	self._beginLine = self.Instance:FindFirstChild("BeginLine")
	local debounce = false
	self._janitor:Add(self.Instance:FindFirstChild("FinishLine").Touched:Connect(function(hit)
		debounce = true
		local char = hit.Parent
		local human = char:FindFirstChild("Humanoid")

		if (human) then
			local player = game:GetService("Players"):GetPlayerFromCharacter(human.Parent)
			if (player and debounce == true) then
				self:_addWinner(player)
				self:_awardPlayer(player)
				player:LoadCharacter()
				table.remove(self.Contestants, 1)
			end
		end

		task.wait(3)
		print(self.Winners)
		debounce = false
	end))
	
	for i = 10, 1, -1 do
		task.wait(1)
		--print(`Minigame will start in {i} seconds.`)
		GameService.Client.StatusChanged:FireAll(`Minigame will start in {i} seconds.`)

		if (i == 1) then
			GameService.Client.StatusChanged:FireAll("Setting up minigame.")
		end
	end
	
	print(self.Players)
	print(self.Contestants)
	
	self._beginLine:Destroy()
	for i = self.Length, 1, -1 do
		task.wait(1)
		--print(`Minigame will end in {i} seconds.`)
		GameService.Client.StatusChanged:FireAll(`Minigame will end in {i} seconds.`)

		if (#self.Contestants <= 0) then
			break
		end
	end

	-- Clean up
	MinigameService.SetFinished:Fire(true)
	print("Mining has ended.")
end

function ObbyRunaway:_addWinner(player: Player)
	if (self.Contestants[player] and not self.Winners[player]) then
		table.insert(self.Winners, player)
	end
end

function ObbyRunaway:_awardPlayer(player: Player)
	if (#self.Winners == 1) then
		DataService:Update(self.Winners[1], "Coins", function(money)
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

function ObbyRunaway:Stop()
	local message = "Won."

	for index,player in ipairs(self.Winners) do
		if (table.find(self.Contestants, index)) then
			self:_awardWinners(player)
		end
	end

	if (#self.Winners == 1) then
		for _,winner in ipairs(self.Winners) do
			self.RoundResult[winner.Name] = {
				Won = true,
				Message = "Sole Winner",
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

function ObbyRunaway:GetContestants()
	return self.Contestants
end

function ObbyRunaway:GetPlayers()
	return self.Players
end

function ObbyRunaway:Destroy()
	table.clear(self.Players)
	table.clear(self.Contestants)
	table.clear(self.Winners)

	Janitor:Cleanup()
end

return ObbyRunaway
