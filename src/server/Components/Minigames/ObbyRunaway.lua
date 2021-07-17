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
    local function func_44821621()
        --local startPart = self.Instance:FindFirstChild("Start")
        --local beginLinePart = self.Instance:FindFirstChild("BeginLine")
        local endPart = self.Instance:FindFirstChild("Finish")

        self._maid:GiveTask(endPart.Touched:Connect(function(hit)
            print(hit.Name)
        end))
        --self._maid:GiveTask(beginLinePart:Destroy())
    end
    repeat
        func_44821621()
    until GameService.hasRoundEnded == true
end

function ObbyRunaway:Init()
    self:_processMinigame ()
    self:_setupPlayerFolders()
end


function ObbyRunaway:Deinit()
end

function ObbyRunaway:Destroy()
    self._maid:Destroy()
    self.Instance:Destroy()
end


return ObbyRunaway