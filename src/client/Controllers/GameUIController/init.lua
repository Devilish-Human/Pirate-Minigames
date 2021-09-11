local Knit = require(game:GetService("ReplicatedStorage").Knit)

local Janitor = require(Knit.Util.Janitor)

local Tween = game:GetService("TweenService")
local TweenService = game:GetService("TweenService")

local Prompt = require(Knit.Modules.Prompt)
local ConvertComma = require(Knit.Modules.ConvertComma)
local Icon = require(Knit.Shared.TopbarPlus)

local GameUIController = Knit.CreateController { Name = "GameUIController" }

local DataService, GameService

function GameUIController:GetGameUI ()
    return Knit.Player.PlayerGui.GameUI
end

local UIJanitor = Janitor.new()

function GameUIController:Spectate()
    
end

function GameUIController:KnitStart()
    repeat
        wait()
    until Knit.Player.Character

    local GameUI = Knit.Player.PlayerGui.GameUI

    local shopFrame = GameUI:FindFirstChild("ShopFrame")

    Icon.new()
        :setName("CoinIcon")
        :setImage(363483133)
        :setLabel(DataService.GetData("Coins") or 0)
        :setRight()
        :lock()
        :give(function(icon)
            return DataService.CoinsChanged:Connect(function(coins)
                icon:setLabel(tostring(coins))
                if coins >= 1000 then
                    icon:setLabel(ConvertComma(tostring(coins)))
                end
            end)
        end)
    Icon.new()
        :setName ("ShopIcon")
        :setImage(4882429582)
        :setLabel("Shop")
        :bindEvent("selected", function()
            print("Selected")
            TweenService:Create(shopFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Position = UDim2.new(0.5, 0, 0.5, 0) }):Play()
        end)
        :bindEvent("deselected", function()
            print("Deselected!")
            TweenService:Create(shopFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Position = UDim2.new(0.5, 0, 1.5, 0) }):Play()
        end)

    local afkButton = GameUI:FindFirstChild("Buttons"):FindFirstChild("afkButton")
    local isAFKToggled = Knit.Player:FindFirstChild("isAFK")

    local function updateAFK ()
        if (isAFKToggled.Value) then
            afkButton.TextLabel.Text = "AFK"
        else
            afkButton.TextLabel.Text = "Playing"
        end
    end

    UIJanitor:Add(afkButton.MouseButton1Click:Connect(function()
        GameService:ToggleAFK()
        updateAFK()
    end))
end


function GameUIController:KnitInit()
    DataService = Knit.GetService("DataService")
    GameService = Knit.GetService("GameService")

    UIJanitor:Cleanup()
end

return GameUIController