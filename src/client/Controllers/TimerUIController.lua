-- File: TimerUIController
-- Author: PirateNinja
-- Date: 07/16/2021

local Knit = require(game:GetService("ReplicatedStorage").Knit)
local Roact = require(Knit.Shared.Roact)

local TimerUIController = Knit.CreateController { Name = "TimerUIController" }

local DataService, GameService;

function TimerUIController:KnitStart()
    
    print("TimerUIController::KnitStart()")
end


function TimerUIController:KnitInit()
    GameService = Knit.GetService("GameService")
    DataService = Knit.GetService("DataService")
    print("TimerUIController::KnitInit()")
end


return TimerUIController