local Knit = require(game:GetService("ReplicatedStorage").Knit)
local Maid = require(Knit.Util.Maid)

local ObbyRunaway = {}
ObbyRunaway.__index = ObbyRunaway

ObbyRunaway.Tag = "ObbyRunaway"

local GameService = Knit.Services.GameService

function ObbyRunaway.new(instance)
    local self = setmetatable({}, ObbyRunaway)
    self._maid = Maid.new()
    print("HI")
    return self
end

function ObbyRunaway:_processMinigame()
    for i = 60, 1, -1 do
        GameService:fireStatus (("The minigame will end in %s seconds"):format(i))
        Knit:Wait(1)
        print(i, os.clock())
        if (#self.Instance.Players.InGame:GetChildren() <= 0) then
            break;
        end
    end
    GameService.hasRoundEnded = true
end

function ObbyRunaway:Init()
    self:_processMinigame ()
end


function ObbyRunaway:Deinit()
end

function ObbyRunaway:Destroy()
    self._maid:Destroy()
end


return ObbyRunaway