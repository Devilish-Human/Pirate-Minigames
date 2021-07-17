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
    self:_setupPlayerFolders()
    local function func_44821621()
        local startPart = self.Instance:FindFirstChild("Start")
        local beginLinePart = self.Instance:FindFirstChild("BeginLine")
        local endPart = self.Instance:FindFirstChild("Finish")

        self._maid:GiveTask(endPart.Touched:Connect(function(hit)
            print(hit.Name)
        end))
        self._maid:GiveTask(beginLinePart:Destroy())
    end
    repeat
        func_44821621()
    until GameService.hasRoundEnded == false
end

function ObbyRunaway:_setupPlayerFolders ()
    local playersFolder = Instance.new("Folder")
    playersFolder.Name = "PlayersFolder"
    playersFolder.Parent = self.Instance
    local InGameFolder = Instance.new("Folder")
    InGameFolder.Name = "InGameFolder"
    InGameFolder.Parent = playersFolder
    local allPlayers = Instance.new("Folder")
    allPlayers.Name = "All Players"
    allPlayers.Parent = playersFolder
    self._maid:GiveTask(playersFolder)
end

function ObbyRunaway:Init()
    self:_processMinigame ()
end


function ObbyRunaway:Deinit()
end


function ObbyRunaway:Destroy()
    self._maid:Destroy()
    self.Instance:Destroy()
end


return ObbyRunaway