local RunService = game:GetService("RunService")
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
    local player = Knit.Player
    local cam = game.Workspace.CurrentCamera

    local gui = self:GetGameUI()
    local spectateBtn = gui.Buttons:FindFirstChild("spectateButton")
    local spectateFr = gui:FindFirstChild("SpectateFrame")
    
    local spectating = false
    local index = 1

    local function changeState(bool)
        if (bool == nil) then
            spectating = not spectating
        else
            spectating = false
        end

        if spectating then
            spectateBtn.TextLabel.Text = "Stop Spectating"
            spectateFr.Visible = true
        else
            spectateBtn.TextLabel.Text = "Spectate"
            spectateFr.Visible = false
        end
    end

    local function GetMinigame()
        return game.Workspace.Game:GetChildren()[1]
    end

    local function View(player)
        if (player and player.Character and cam.CameraSubject ~= player.Character) then
            cam.CameraSubject = player.Character
        end

        spectateFr.spectatePlayerName.Text = player.Name
    end

    local function changeIndex(indexNum)
        local newIndex = index + indexNum

        local MG = GetMinigame()
        local PlayersFolder = MG.Players
        local PlayersIG = PlayersFolder.InGame:GetChildren()

        if (newIndex > #PlayersIG) then
            newIndex = 1
        elseif newIndex < 1 then
            newIndex = #PlayersIG
        end

        index = newIndex
    end

    game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessedEvent)
        if spectateFr.Visible then
            if (input.KeyCode == Enum.KeyCode.Q) then
                changeIndex(-1)
            elseif (input.KeyCode == Enum.KeyCode.E) then
                changeIndex(1)
            end
        end
    end)
    
    spectateFr.nextBtn.MouseButton1Click:Connect(function()
        changeIndex(1)
    end)
    spectateFr.prevBtn.MouseButton1Click:Connect(function()
        changeIndex(-1)
    end)

    game:GetService("RunService").RenderStepped:Connect(function()
        local MG = GetMinigame()

        if MG ~= nil then
            local InGamePlayers = MG:WaitForChild("Players").InGame
            if (not InGamePlayers:FindFirstChild(player.Name)) then
                spectateBtn.Visible = true
                if spectating then
                    changeIndex(0)
                    View(InGamePlayers:GetChildren()[index].Value)
                else
                    View(game.Players.LocalPlayer)
                end
            else
                spectateBtn.Visible = false
                changeState(false)
            end
        else
            spectateBtn.Visible = false
            changeState(false)
        end
    end)

    spectateBtn.MouseButton1Click:Connect(function()
        changeState()
    end)
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
            TweenService:Create(shopFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Position = UDim2.new(0.5, -50, 0.5, 0) }):Play()
        end)
        :bindEvent("deselected", function()
            print("Deselected!")
            TweenService:Create(shopFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Position = UDim2.new(0.5, -50, 1.5, 0) }):Play()
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
    self:Spectate()
end


function GameUIController:KnitInit()
    DataService = Knit.GetService("DataService")
    GameService = Knit.GetService("GameService")

    UIJanitor:Cleanup()
end

return GameUIController