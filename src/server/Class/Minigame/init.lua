local CollectionService = game:GetService("CollectionService")

local Minigame = {}
Minigame.__index = Minigame

Minigame.Tag = "Minigame"

export type MTeam = {
	Name: string,
	Color: Color3,
	IsTeamActive: boolean,
}
export type MinigameProperties = {
	Name: string,
	Team: MTeam,
	Type: string?,
	Objective: string,
	Reward: {
		any: any,
	},
}

function Minigame.new(Properties: MinigameProperties)
	local self = setmetatable({}, Minigame)
	self.Instance = CollectionService:GetTagged("Minigame")

	self.Name = Properties.Name
	self.Objective = Properties.Objective
	self.Type = Properties.Type
	self.Team = Properties.Team or {}
	self.Reward = Properties.Reward or {
		Points = 5,
		Exp = 10,
	}

	self.Players = {} -- All players alive & dead
	self.Contestants = {} -- Alive players or winners

	return self
end

function Minigame:Get()
	return self.Instance
end

function Minigame:Start() end

function Minigame:Stop() end

function Minigame:GetContestants()
end

function Minigame:GetPlayers()
end

function Minigame:Destroy() end

return Minigame
