local Knit = require(game:GetService("ReplicatedStorage").Knit)

local TimerUIController = Knit.CreateController { Name = "TimerUIController" }

-- TimerUI Stuff
local TimerUI = Knit.Player.PlayerGui:FindFirstChild("TimerUI")

local GameService;

function TimerUIController:KnitStart()
    local StatusFrame = TimerUI.Status
    local StatusLabel = StatusFrame.StatusLabel
    local TimerLabel = StatusFrame.TimerLabel
    
    TimerLabel.Text = GameService:GetLength()
    StatusLabel.Text = GameService:GetStatus()
    while wait(1 * 0.1) do
        TimerLabel.Text = GameService:GetLength()
        StatusLabel.Text = GameService:GetStatus()
    end
end


function TimerUIController:KnitInit()
    GameService = Knit.GetService("GameService")
end


return TimerUIController