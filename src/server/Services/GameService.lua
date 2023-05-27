-- File: GameService
-- Author: PirateNinja
-- Date: 07/16/2021

-- // Roblox Services \\ --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")

local Knit = require(ReplicatedStorage:FindFirstChild("Packages").Knit)

-- // Utilities \\ --

-- // Shared Modules
-- End Shared Modules //

local Chosen
local MinigameService

local GameService = Knit.CreateService({
	Name = "GameService",
	Client = {},
})

-- Knit
function GameService:KnitStart()

end

function GameService:KnitInit()
	MinigameService = Knit.GetService("MinigameService")
end
-- End Knit //
return GameService
