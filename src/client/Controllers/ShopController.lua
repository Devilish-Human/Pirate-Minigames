local Knit = require(game:GetService("ReplicatedStorage").Knit)

local ShopController = Knit.CreateController { Name = "ShopController" }

local shopItems = game:GetService("ReplicatedStorage").ShopItems

local GameUIController
local ShopService, DataService
local shopManager

local prompt = require(Knit.Modules.Prompt)
local convertComma = require(Knit.Modules.ConvertComma)

local gameUI
local infoFrame

local function createItemButton ()
    local Item = Instance.new("ImageButton")
    local UICorner = Instance.new("UICorner")
    local Name = Instance.new("TextLabel")

    Item.Name = "Item"
    Item.Active = false
    Item.BackgroundColor3 = Color3.fromRGB(85, 255, 255)
    Item.Selectable = false
    Item.Size = UDim2.new(0.200000003, 0, 0.100000001, 0)

    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = Item

    Name.Name = "Title"
    Name.Parent = Item
    Name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Name.BackgroundTransparency = 1.000
    Name.BorderSizePixel = 0
    Name.Position = UDim2.new(0, 5, 0, 7)
    Name.Size = UDim2.new(1, -10, 0.035263136, 25)
    Name.Font = Enum.Font.SourceSans
    Name.Text = ""
    Name.TextColor3 = Color3.fromRGB(255, 255, 255)
    Name.TextScaled = true
    Name.TextSize = 14.000
    Name.TextStrokeTransparency = 0.000
    Name.TextWrapped = true

    return Item
end

local selected

function ProcessButtonPresses()
    local activePage
    
    local UIGridLayout = Instance.new("UIGridLayout")

    UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIGridLayout.CellPadding = UDim2.new(0, 2, 0, 3)
    UIGridLayout.CellSize = UDim2.new(0, 110, 0, 100)
    UIGridLayout.FillDirectionMaxCells = 5
    
    gameUI.ShopFrame.Content.Items:ClearAllChildren()
    UIGridLayout:Clone().Parent = gameUI.ShopFrame.Content.Items
    for _, button in pairs (gameUI.ShopFrame.PageButtons:GetChildren()) do

        if button:IsA("GuiButton") then
            button.MouseButton1Click:Connect(function()
                gameUI.ShopFrame.Content.Items:ClearAllChildren()
                if button.Name == "Store" then
                    gameUI.ShopFrame.Content.Store.Visible = true
                    gameUI.ShopFrame.Content.Items.Visible = false
                else
                    UIGridLayout:Clone().Parent = gameUI.ShopFrame.Content.Items
                    if (gameUI.ShopFrame.Content.Items.Visible == false) then
                        gameUI.ShopFrame.Content.Store.Visible = false
                        gameUI.ShopFrame.Content.Items.Visible = true
                    end
                    ShopController:LoadItems(button.Name)
                end
            end)
        end
    end
end

function ShopController:LoadItems(Category)
    for i, currItem in pairs (shopItems[Category]:GetChildren()) do
        local button = createItemButton()
        button.Name = currItem.Name
        button.Title.Text = currItem:GetAttribute("Name")
        button.Image = ""
        button.Parent = gameUI.ShopFrame.Content.Items

        button.MouseButton1Click:Connect(function()
            selected = currItem
            gameUI.ShopFrame.infoFrame.itemName.Text = currItem:GetAttribute("Name")
            gameUI.ShopFrame.infoFrame.itemDescription.Text = currItem:GetAttribute("Description")

            if Knit.Player.Inventory[Category]:FindFirstChild(currItem.Name) then
                if Knit.Player.Inventory[Category]:FindFirstChild(currItem.Name).Value then
                    gameUI.ShopFrame.infoFrame.purchaseButton.Coins.CoinsLabel.Text = "Unequip"
                else
                    gameUI.ShopFrame.infoFrame.purchaseButton.Coins.CoinsLabel.Text = "Equip"
                end
                gameUI.ShopFrame.infoFrame.purchaseButton.Coins.ImageTransparency = 1
                gameUI.ShopFrame.infoFrame.purchaseButton.Coins.CoinsLabel.Position = UDim2.new(0.25, 0, 0.143, 0)
            else
                gameUI.ShopFrame.infoFrame.purchaseButton.Coins.ImageTransparency = 0
                gameUI.ShopFrame.infoFrame.purchaseButton.Coins.CoinsLabel.Position = UDim2.new(1.214, 0, 0, 0)
                gameUI.ShopFrame.infoFrame.purchaseButton.Coins.CoinsLabel.Text = convertComma(currItem:GetAttribute("Cost"))
            end
        end)
    end
end

function ShopController:KnitStart()
    gameUI = GameUIController:GetGameUI()

    ProcessButtonPresses()

    gameUI.ShopFrame.infoFrame.purchaseButton.MouseButton1Click:Connect(function()
        if (gameUI.ShopFrame.infoFrame.purchaseButton.Coins.CoinsLabel.Text == "Equip") then
            ShopService:EquipItem(selected.Name)
        else
            ShopService:PurchaseItem(selected.Name)
        end
    end)

    self:LoadItems("Gear")
end
function ShopController:KnitInit()
    GameUIController = Knit.GetController("GameUIController")
    ShopService = Knit.GetService("ShopService")

    ShopService.PrompEvent:Connect(function(messageType, ...)
        if (messageType) == "Error" then
            local content = {...}
            prompt:Create {
                Title = content[1], -- This will be the title of our prompt
                Text = content[2], -- This will be the body of our prompt
                
                -- V These are optional V --
                
                AcceptButton = { -- This table will allow us to create an AcceptButton
                    Text = "Accept", -- This will be the Text of the AcceptButton
                    Callback = function() -- This function will run when the player clicks the AcceptButton
                        return
                    end,
                }
            }
        end
    end)
end


return ShopController