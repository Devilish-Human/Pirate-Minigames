-- File: String
-- Author: PirateNinja
-- Date: 07/16/2021

local String = {}

function String:_format (...)
    return ("%02i"):format(...)
end

function String:ToMS (seconds: number)
    local m = (seconds - (seconds%60)) / 60
    seconds = seconds - m*60
    if (seconds < 60) then
        return self:_format(seconds) .. 's'
    else
        return self:_format(m) .. 'm ' .. self:_format(seconds) 's'
    end
end

return String