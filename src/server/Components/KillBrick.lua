local Players = game:GetService("Players")

local Knit = require(game:GetService("ReplicatedStorage").Knit)
local Maid = require(Knit.Util.Maid)
local Option = require(Knit.Util.Option)

local KillBrick = {}
KillBrick.__index = KillBrick

KillBrick.Tag = "KillBrick"


function KillBrick.new(instance)
    
    local self = setmetatable({}, KillBrick)
    
    self._maid = Maid.new()
    
    return self
    
end


function KillBrick:_setupKillBricks ()
    local function GetPlayerFromPart(part)
        return Option.Wrap(Players:GetPlayerFromCharacter(part.Parent))
    end

    local function GetHumanoid (player)
        if (player.Character) then
            local humanoid = player.Character:FindFirstChildWhichIsA("Humanoid")
            return Option.Wrap(humanoid)
        end
        return Option.None
    end

    local function SetCorrectColor ()
        self.Instance.Color = Color3.fromRGB( 255, 0 , 0 )
    end

    self._maid:GiveTask(self.Instance.Touched:Connect(function(part)
        GetPlayerFromPart(part):Match {
            Some = function(player)
                if (player) then
                    GetHumanoid (player):Match {
                        Some = function(humanoid)
                            humanoid.Health = 0
                        end
                    }
                end
            end;
            None = function() end
        }
    end))

    SetCorrectColor()
end

function KillBrick:Init()
    self:_setupKillBricks()
end


function KillBrick:Deinit()
end


function KillBrick:Destroy()
    self._maid:Destroy()
end


return KillBrick