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

function SwordClash:Start()
    
end

function SwordClash:Stop()
    
end

function SwordClash:Destroy()
    self._janitor:Cleanup()
end

return SwordClash