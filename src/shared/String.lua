local String = {}

function String:_format (...)
    return ("%02i"):format(...)
end

function String:ToMS (seconds: number)
    local m = (seconds - (seconds%60)) / 60
    seconds = seconds - m*60
    return self:_format(m) .. ":" .. self:_format(seconds)
end

return String