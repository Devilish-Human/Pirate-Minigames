local Players = game:GetService("Players")

local Knit = require(game:GetService("ReplicatedStorage").Knit)
local Signal = require(Knit.Util.Signal)
local Janitor = require(Knit.Util.Janitor)

local GameManager = {}
GameManager.__index = GameManager

GameManager.Tag = "GameManager"

local GameService, DataService

function GameManager.new(instance)
	local self = setmetatable({}, GameManager)

	self._janitor = Janitor.new()
	self.Winners = {}
	self.RoundResults = {}

	return self
end

function GameManager:isContestant(player: Player)
	for i, v in
		pairs(self.Instance:FindFirstChild(self:GetAttribute("CurrentMinigame")).Players.AllPlayers:GetChildren())
	do
		if
			v.Value == player
			and self.Instance
				:FindFirstChild(self:GetAttribute("CurrentMinigame")).Players.InGame
				:FindFirstChild(player.Name)
		then
			return v
		end
	end
	return false
end

function GameManager:isWinner(player: Player)
	for i, v in pairs(self.Winners) do
		if v == player then
			return v
		end
	end
	return nil
end

function GameManager:addWinner(player: Player)
	if self:isContestant(player) and not self:isWinner(player) then
		table.insert(self.Winners, player)
	end
end

function GameManager:awardPlayer(player: Player, dataName: string, dataValue: any)
	local profile = DataService:GetProfile(player)

	if profile then
		if type(dataValue) == "number" then
			profile[dataName] = profile[dataName] + dataValue
		elseif type(dataValue) == "table" then
			table.insert(profile[dataName], dataValue)
		else
			profile[dataName] = dataValue
		end
	end
end

function GameManager:ForceStop()
	for i, v in pairs(self.Instance:FindFirstChild(self:GetAttribute("CurrentMinigame").Players.InGame:GetChildren())) do
		if v then
			v:Destroy()
		end
	end
	self.Started = false
end

function GameManager:SetAttribute(attribute, value)
	return self.Instance:SetAttribute(attribute, value)
end

function GameManager:GetAttribute(attribute)
	return self.Instance:GetAttribute(attribute)
end

function GameManager:_setupObserver()
	self._janitor:Add(self.Instance.ChildAdded:Connect(function(child)
		self.Instance:SetAttribute("CurrentMinigame", child.Name)
		self.Instance:SetAttribute("CurrentMap", child:GetAttribute("Id"))
		self.Instance:SetAttribute(
			"Teams",
			game:GetService("ServerStorage").Assets.Maps:FindFirstChild(child.Name):GetAttribute("Team")
		)
		self.Instance:SetAttribute("hasEnded", false)

		if self.Instance:GetAttribute("Teams") then
			local teamsFolder = Instance.new("Folder")
			teamsFolder.Name = "Teams"
			teamsFolder.Parent = self.Instance:FindFirstChild(self.Instance:GetAttribute("CurrentMinigame"))

			local team1 = Instance.new("Folder")
			team1.Name = "Pirates"
			team1.Parent = teamsFolder
			team1:SetAttribute("Color", Color3.fromRGB(116, 61, 61))

			local team2 = Instance.new("Folder")
			team2.Name = "Ninjas"
			team2.Parent = teamsFolder
			team2:SetAttribute("Color", Color3.fromRGB(49, 49, 49))
		end
	end))
	self._janitor:Add(self.Instance.ChildRemoved:Connect(function(child)
		if child:FindFirstChild("MinigameScript") then
			child:FindFirstChild("MinigameScript"):Destroy()
		end
		self.Instance:SetAttribute("CurrentMinigame", "")
		self.Instance:SetAttribute("CurrentMap", "")
		self.Instance:SetAttribute("Teams", false)
		self.Instance:SetAttribute("hasEnded", false)

		if child:FindFirstChild("Teams") then
			child:FindFirstChild("Teams"):Destroy()
		end

		self.Started = false
		self.Winners = {}
	end))
end

function GameManager:Init()
	GameService = Knit.Services.GameService
	DataService = Knit.Services.DataService
	self.Winners = {}
	self.Started = false

	self:_setupObserver()
end

function GameManager:ChangeMinigameProperty(Minigame, propertyName, value)
	return game:GetService("ServerStorage").Assets.Maps:FindFirstChild(Minigame):SetAttribute(propertyName, value)
end

function GameManager:GetCurrentMinigame()
	return script:FindFirstChild(self:GetAttribute("CurrentMinigame"))
end

function GameManager:Deinit() end

function GameManager:Destroy()
	self._janitor:Cleanup()
end

return GameManager
