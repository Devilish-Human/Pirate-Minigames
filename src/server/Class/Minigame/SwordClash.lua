-- File: SwordClash
-- Authors: PirateNinja Studios / PirateNinja Twelve
-- Date: 06/06/2023

local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage:FindFirstChild("Packages").Knit)
local Janitor = require(ReplicatedStorage:FindFirstChild("Packages").Janitor)

local Minigame = require(script.Parent)

local ASSETS_FOLDER = ServerStorage:FindFirstChild("Assets")
local SWORD_FOLDER = ASSETS_FOLDER:FindFirstChild("Objects").Swords

local DataService, GameService, MinigameService

local SwordClash = Minigame.new {
    Name = "SwordClash",
    Objective = "Be the last person standing.",
    Type = "Survival",
    Length = 60,
    Reward = {
        Points = 20,
        Exp = 6
    }
}
SwordClash.__index = SwordClash

function SwordClash.new(instance)
    local self = setmetatable({}, SwordClash)
	self._janitor = Janitor.new()
	self.Instance = instance
	self.Finished = false;
	return self
end

function SwordClash:Initialize()
    GameService = Knit.GetService("GameService")
    DataService = Knit.GetService("DataService")
    MinigameService = Knit.GetService("MinigameService")
end

function SwordClash:_givePlayersSwords()
    for _, plr in pairs(self.Contestants) do
        if plr and plr.Character then
            local swordClone = SWORD_FOLDER.Cutlass:Clone()
            swordClone.Parent = plr.Backpack
        end
    end
end

function SwordClash:Start()
    -- Remove players gears
    for _, plr in pairs(self.Contestants) do
        if plr then
            for _, gear in pairs(plr:FindFirstChild("Backpack"):GetChildren()) do
                if gear then
                    gear:Destroy()
                end
            end

            for _, v in pairs(plr.Character:GetChildren()) do
                if v:IsA("Tool") then
                    v:Destroy()
                end
            end
        end
    end

    for i = 5, 1, -1 do
        task.wait(1)
        GameService.Client.StatusChanged:FireAll(`Minigame will start in {i} seconds.`)
    end

    -- Unanchor players if necessary

    for i = self.Length, 1, -1 do
        task.wait(1)
        GameService.Client.StatusChanged:FireAll(`Minigame will end in {i} seconds; {self.Objective}`)
    end

    MinigameService.SetFinished:Fire(true)

	task.wait(3)

	table.clear(self.Players)
	table.clear(self.Contestants)
	table.clear(self.Winners)
end

function SwordClash:Stop()
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

function SwordClash:_addWinner(player: Player)
	if (self.Contestants[player] and not self.Winners[player]) then
		table.insert(self.Winners, player)
	end
end

function SwordClash:_awardPlayer(player: Player)
	DataService:Update(player, "Coins", function(Coins)
		local bonus = (#self.Winners == 1 and self.Reward.Points * 1.25)
		local reward = (self.Reward.Points + bonus)

		return Coins + reward
	end)
	DataService:Update(player, "Wins", function(Wins)
		return Wins + 1
	end)
end

function SwordClash:Destroy()
    self._janitor:Cleanup()
end

return SwordClash