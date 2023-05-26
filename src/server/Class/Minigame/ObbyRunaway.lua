-- File: ObbyRunaway
-- Authors: PirateNinja Studios / PirateNinja Twelve
-- Date: 05/25/2023

local Minigame = require(script.Parent)

local ObbyRunaway = Minigame.new {
    Name = "ObbyRunaway",
    Objective = "Complete the obby to win.",
    Type = "Race",
    Reward = {
        Points = 5,
        Exp = 6
    }
}
ObbyRunaway.__index = ObbyRunaway

function ObbyRunaway.new(instance: Instance)
    local self = setmetatable({}, ObbyRunaway)
    self.Instance = instance
    return self
end

function ObbyRunaway:Get()
    return self.Instance
end

function ObbyRunaway:Start()
    
end

function ObbyRunaway:Stop()
    
end

function ObbyRunaway:GetPlayersRemaining()
    
end

function ObbyRunaway:Destroy()
    print("Minigame ended..")
end

return ObbyRunaway