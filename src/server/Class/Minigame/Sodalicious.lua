-- File: Sodalicious
-- Authors: PirateNinja Studios / PirateNinja Twelve
-- Date: 06/06/2023

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage:FindFirstChild("Packages").Knit)
local Janitor = require(ReplicatedStorage:FindFirstChild("Packages").Janitor)

local Minigame = require(script.Parent)
local DataService, GameService, MinigameService

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
	self.Length = 60
	return self
end

function Sodalicious:Start()
    
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
    self._janitor:Cleanup()
end

return Sodalicious