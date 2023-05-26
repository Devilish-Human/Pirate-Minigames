-- File: Player
-- Authors: PirateNinja Studios / PirateNinja Twelve
-- Date: 05/25/2023

local Player = {}
Player.__index = Player

function Player.new()
    local self = setmetatable({}, Player)
    return Player
end

function Player:Destroy()
    
end

return Player