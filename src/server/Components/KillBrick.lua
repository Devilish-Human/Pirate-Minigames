local Players = game:GetService("Players")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage:FindFirstChild("Packages").Knit)
local Janitor = require(ReplicatedStorage:FindFirstChild("Packages").Janitor)

local KillBrick = {}
KillBrick.__index = KillBrick

KillBrick.Tag = "KillBrick"

function KillBrick.new(instance)
	local self = setmetatable({}, KillBrick)

	self._janitor = Janitor.new()

	return self
end

function KillBrick:_setupKillBricks()

end

function KillBrick:Init()
	self:_setupKillBricks()
end

function KillBrick:Deinit() end

function KillBrick:Destroy()
	self._janitor:Cleanup()
end

return KillBrick
