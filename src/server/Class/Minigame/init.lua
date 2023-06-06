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
	Type: string?,
	Team: MTeam?,
	Objective: string,
	Length: number,
	Reward: {
		any: any,
	},
}

function Minigame.new(Properties: MinigameProperties)
	local self = setmetatable({}, Minigame)
	self.Instance = CollectionService:GetTagged("Minigame")

	self.Name = Properties.Name
	self.Objective = Properties.Objective
	self.Length = Properties.Length or 30
	self.Type = Properties.Type
	self.Team = Properties.Team or {}
	self.Reward = Properties.Reward or {
		Points = 5,
		Exp = 10,
	}

	self.Players = {} -- All players alive & dead
	self.Contestants = {} -- Alive players or winners
	self.Winners = {} -- Winners of the minigame

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
