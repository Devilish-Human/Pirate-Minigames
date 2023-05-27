-- File: ObbyRunaway
-- Authors: PirateNinja Studios / PirateNinja Twelve
-- Date: 05/25/2023

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage:FindFirstChild("Packages").Knit)
local Janitor = require(ReplicatedStorage:FindFirstChild("Packages").Janitor)

local Minigame = require(script.Parent)
local DataService

local ObbyRunaway = Minigame.new {
	Name = "ObbyRunaway",
	Objective = "Complete the obby to win.",
	Type = "Race",
	Reward = {
		Points = 5,
		Exp = 6,
	},
}
ObbyRunaway.__index = ObbyRunaway


function ObbyRunaway.new(instance: Instance)
	local self = setmetatable({}, ObbyRunaway)
	self._janitor = Janitor.new()
	self.Instance = instance
	self.Finished = false;
	return self
end

function ObbyRunaway:Init()
	DataService = Knit.GetService("DataService")
end

function ObbyRunaway:Get()
	return self.Instance
end

function ObbyRunaway:Start()
	self._janitor:Add(self.Instance.Game.FinishLine.Touch:Connect(function(hit)
		local char = hit.Parent
		local human = char:FindFirstChild("Humanoid")

		if (human) then
			local player = game:GetService("Players"):GetPlayerFromCharacter(human)
			if (player) then
				self:_awardWinners(player)
			end
		end
	end))
end

function ObbyRunaway:_awardWinners(player)
	if (#self.Winners <= 1) then
		DataService:Update(player, "Coins", function(money)
			return money + (self.Reward.Points * 1.25)
		end)
	else
		DataService:Update(player, "Coins", function(money)
			return money + (self.Reward.Points)
		end)
	end
	DataService:Update(player, "Win", function(money)
		return money + 1
	end)
end

function ObbyRunaway:Stop()
	local message = "Won."
	if (#self.Winners <= 1) then
		for _,winner in ipairs(self.Winners) do
			self.RoundResult[winner.Name] = {
				Won = true,
				Message = message,
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

	task.wait(1)

	self._beginLine:Destroy()
	self.Winners = {}
	self.Players = {}
	self.Contestants = {}
end

function ObbyRunaway:GetContestants()
	return self.Contestants
end

function ObbyRunaway:GetPlayers()
	return self.Players
end

function ObbyRunaway:Destroy()
	self:Stop()
	print("Minigame ended..")
	Janitor:Cleanup()
end

return ObbyRunaway
