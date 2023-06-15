-- File: ObbyRunaway
-- Authors: PirateNinja Studios / PirateNinja Twelve
-- Date: 05/25/2023

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage:FindFirstChild("Packages").Knit)
local Janitor = require(ReplicatedStorage:FindFirstChild("Packages").Janitor)

local Minigame = require(script.Parent)
local DataService, GameService, MinigameService

local debounce = false

local ObbyRunaway = Minigame.new {
	Name = "ObbyRunaway",
	Objective = "Complete the obby to win.",
	Type = "Race",
	Reward = {
		Points = 10,
		Exp = 6,
	},
	Length = 60
}
ObbyRunaway.__index = ObbyRunaway


function ObbyRunaway.new(instance: Instance)
	local self = setmetatable({}, ObbyRunaway)
	self._janitor = Janitor.new()
	self.Instance = instance
	self.Finished = false;
	return self
end

function ObbyRunaway:Initialize()
	DataService = Knit.GetService("DataService")
	GameService = Knit.GetService("GameService")
	MinigameService = Knit.GetService("MinigameService")

	self._janitor:Add(MinigameService.SetFinished:Connect(function(state)
		self.Finished = state

		self.Instance:SetAttribute("Finished", self.Finished)
	end))
	self._janitor:Add(game:GetService("Players").PlayerRemoving:Connect(function(plr)
		local plrIndex = table.find(self.Contestants, plr)
		if (table.find(self.Contestants, plr)) then
			table.remove(self.Contestants, plrIndex)
		end
	end))
end

function ObbyRunaway:Get()
	return self.Instance
end

function ObbyRunaway:Start()
	self._beginLine = self.Instance:FindFirstChild("BeginLine")
	self._janitor:Add(self.Instance:FindFirstChild("FinishLine").Touched:Connect(function(hit)
		debounce = true
		local char = hit.Parent
		local human = char:FindFirstChild("Humanoid")
		if (human) then
			local player = Players:GetPlayerFromCharacter(human.Parent)
			if (player and debounce == true) then
				self:_addWinner(player)
				print(char)
				print(human.Parent.Name)
				self:_awardPlayer(player)
				player:LoadCharacter()
				table.remove(self.Contestants, 1)
			end
		end
		task.wait(3)
		debounce = false
	end))
	
	for i = 10, 1, -1 do
		task.wait(1)
		--print(`Minigame will start in {i} seconds.`)
		GameService.Client.StatusChanged:FireAll(`Minigame will start in {i} seconds.`)
	end

	for i = self.Length, 1, -1 do
		task.wait(1)
		--print(`Minigame will end in {i} seconds.`)
		GameService.Client.StatusChanged:FireAll(`Minigame will end in {i} seconds.`)

		if (i == self.Length) then
			self._beginLine:Destroy()
		end

		if (#self.Contestants <= 0) then
			break
		end
	end

	-- award winners
	for _, v in self.Winners do
		print(self.Winners, v)
	end

	task.wait(2)
	-- Clean up
	MinigameService.SetFinished:Fire(true)
	print("Mining has ended.")

	task.wait(3)

	table.clear(self.Players)
	table.clear(self.Contestants)
	table.clear(self.Winners)
end

function ObbyRunaway:_addWinner(player: Player)
	if (self.Contestants[player] and not self.Winners[player]) then
		table.insert(self.Winners, player)
	end
end

function ObbyRunaway:_awardPlayer(player: Player)
	DataService:Update(player, "Coins", function(Coins)
		local bonus = (#self.Winners == 1 and self.Reward.Points * 1.25 or 0)
		local reward = (self.Reward.Points + bonus)

		return Coins + reward
	end)
	DataService:Update(player, "Wins", function(Wins)
		return Wins + 1
	end)
end

function ObbyRunaway:Stop()
	local message = "Won."

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
	Janitor:Cleanup()
end

return ObbyRunaway
