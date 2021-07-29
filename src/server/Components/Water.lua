local Knit = require(game:GetService("ReplicatedStorage").Knit)
local Maid = require(Knit.Util.Maid)

local Players = game:GetService("Players")

local Water = {}
Water.__index = Water

Water.Tag = "Water"


function Water.new(instance)
    
    local self = setmetatable({}, Water)
    
    self._maid = Maid.new()
    self.color = Color3.fromRGB(13, 106, 172)
    self.material = Enum.Material.Sand
    return self
end

function Water:Init()
    self.Instance.Color = self.color;
    self.Instance.Material = self.material

    self._maid:GiveTask (self.Instance.Touched:Connect(function(hit)
        local object = hit.Parent
        local player = Players:GetPlayerFromCharacter(object)
        if (player) then
            if workspace.Game:GetChildren()[1] then
                workspace.Game:GetChildren()[1].Players.InGame:FindFirstChild(player.Name):Destroy();
            end
            player:LoadCharacter();
        end
    end))
end

function Water:Destroy()
    self._maid:Destroy()
end


return Water