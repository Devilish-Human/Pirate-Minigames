local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage:FindFirstChild("Packages").Knit)
local Janitor = require(ReplicatedStorage:FindFirstChild("Packages").Janitor)

local Players = game:GetService("Players")

local Water = {}
Water.__index = Water

Water.Tag = "Water"

function Water.new(instance)
	local self = setmetatable({}, Water)

	self._janitor = Janitor.new()
	self._color = Color3.fromRGB(13, 106, 172)
	self._material = Enum.Material.Sand

	return self
end

function Water:Init()
	self.Instance.Color = self._color
	self.Instance.Material = self._material

	self._janitor:Add(self.Instance.Touched:Connect(function(hit)
		local object = hit.Parent
		local player = Players:GetPlayerFromCharacter(object)
		if player then
			if
				workspace.Game:GetChildren()[1]
				and workspace.Game:GetChildren()[1].Players.InGame:FindFirstChild(player.Name)
			then
				workspace.Game:GetChildren()[1].Players.InGame:FindFirstChild(player.Name):Destroy()
			end
			player:LoadCharacter()
		end
	end))
end

function Water:Destroy()
	self._janitor:Cleanup()
end

return Water
