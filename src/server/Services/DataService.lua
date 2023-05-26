-- File: DataService
-- Author: PirateNinja Twelve
-- Date: 07/16/2021
-- Revision: 05/25/2023

local Knit = require(game:GetService("ReplicatedStorage").Knit)

local ProfileService = require(Knit.Modules.ProfileService)

local Players = game:GetService("Players")

-- Creating a new service
local DataService = Knit.CreateService({
	Name = "DataService",
	Client = {
	},
})

local ProfileTemplate = {
	-- Stats
	Coins = 0,
	Level = 1,
	Wins = 0,

	Inventory = {
		Gear = {},
		Title = {},
	}
}

local GameProfileStore = ProfileService.GetProfileStore("PlayerData-dev2", ProfileTemplate)

DataService.Profiles = {}

-- Loading Data
local _onPlayerAdded = function(player: Player)
	print(player.UserId)

	local isAFK = Instance.new("BoolValue")
	isAFK.Name = "isAFK"
	isAFK.Value = false
	isAFK.Parent = player

	local profile = GameProfileStore:LoadProfileAsync("player_" .. player.UserId, "ForceLoad")

	if profile then
		profile:ListenToRelease(function()
			DataService.Profiles[player.UserId] = nil
			player:Kick()
		end)

		if player:IsDescendantOf(Players) then
			DataService.Profiles[player.UserId] = profile
		else
			profile:Release()
		end
	else
		player:Kick("Failed to retrieve data. Please rejoin the game!")
	end
end

function DataService:GetProfile(player: Player)
	return self.Profiles[player.UserId]
end

function DataService:Get(player: Player, data: string)
	local profile = self:GetProfile(player)
	return profile.Data[data]
end

function DataService:Set(player: Player, data: string, value: any)
	local profile = self:GetProfile(player)
	profile.Data[data] = value
end

function DataService:Update(player: Player, data: string, callback)
	local oldData = self:Get(data)
	local newData = callback(oldData)
	self:Set(player, data, newData)
end

-- Saving Data
local _onPlayerRemoving = function(player: Player)
	local profile = DataService:GetProfile(player)

	if profile then
		profile:Release()
	end
end

function DataService:KnitStart()
	for _, plr in pairs(game:GetService("Players"):GetChildren()) do
		if plr then
			_onPlayerAdded(plr)
		end
	end
end

function DataService:KnitInit()
	Players.PlayerAdded:Connect(_onPlayerAdded)
	Players.PlayerRemoving:Connect(_onPlayerRemoving)
end

return DataService
