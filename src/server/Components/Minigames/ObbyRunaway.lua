local Knit = require(game:GetService("ReplicatedStorage").Knit)
local Maid = require(Knit.Util.Maid)

local ObbyRunaway = {}
ObbyRunaway.__index = ObbyRunaway

ObbyRunaway.Tag = "ObbyRunaway"


function ObbyRunaway.new(instance)
    local self = setmetatable({}, ObbyRunaway)
    self._maid = Maid.new()
    return self
end

function ObbyRunaway:_processMinigame()
    self:_setupPlayerFolders()
    self._maid:GiveTask(function()
        print("Game Ended")
    end)
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
end


return ObbyRunaway