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
    local Title = Instance.new("TextLabel")
    local Coins = Instance.new("ImageLabel")
    local CoinsLabel = Instance.new("TextLabel")
    local itemIcon = Instance.new("ImageLabel")

    Item.Name = "Item"
    Item.Active = false
    Item.BackgroundColor3 = Color3.fromRGB(85, 255, 255)
    Item.Selectable = false
    Item.Size = UDim2.new(0.200000003, 0, 0.100000001, 0)

    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = Item

    Title.Name = "Title"
    Title.Parent = Item
    Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1.000
    Title.BorderSizePixel = 0
    Title.Position = UDim2.new(0, 5, 0, 0)
    Title.Size = UDim2.new(0.972727299, -10, -0.0399999805, 25)
    Title.Font = Enum.Font.SourceSans
    Title.Text = "Item"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextScaled = true
    Title.TextSize = 14.000
    Title.TextStrokeTransparency = 0.000
    Title.TextWrapped = true

    Coins.Name = "Coins"
    Coins.Parent = Item
    Coins.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Coins.BackgroundTransparency = 1.000
    Coins.Position = UDim2.new(0.0470750295, 0, 0.779999971, 0)
    Coins.Size = UDim2.new(0, 22, 0, 21)
    Coins.Image = "rbxassetid://363483133"

    CoinsLabel.Name = "CoinsLabel"
    CoinsLabel.Parent = Coins
    CoinsLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    CoinsLabel.BackgroundTransparency = 1.000
    CoinsLabel.Position = UDim2.new(1.21428609, 0, 0.285714298, 0)
    CoinsLabel.Size = UDim2.new(-2.94345188, 142, 0.714285731, 0)
    CoinsLabel.Font = Enum.Font.SourceSansBold
    CoinsLabel.Text = ""
    CoinsLabel.TextColor3 = Color3.fromRGB(255, 170, 0)
    CoinsLabel.TextScaled = true
    CoinsLabel.TextSize = 24.000
    CoinsLabel.TextStrokeTransparency = 0.600
    CoinsLabel.TextWrapped = true
    CoinsLabel.TextXAlignment = Enum.TextXAlignment.Left

    itemIcon.Name = "itemIcon"
    itemIcon.Parent = Item
    itemIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    itemIcon.BackgroundTransparency = 1.000
    itemIcon.BorderSizePixel = 0
    itemIcon.Position = UDim2.new(0.24545455, 0, 0.269999981, 0)
    itemIcon.Size = UDim2.new(0, 56, 0, 56)

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
    local list = {}
    for _, v in pairs (shopItems[Category]:GetChildren()) do
        table.insert (list, v)
    end

    table.sort(list, function(a, b) return a:GetAttribute("Cost") < b:GetAttribute("Cost") end)

    for i, currItem in pairs (list) do
        local button = createItemButton()
        button.Name = currItem.Name
        button.Title.Text = currItem:GetAttribute("Name")
        button.BackgroundColor3 = shopItems[Category]:GetAttribute("Color")
        button.itemIcon.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=" .. currItem:GetAttribute("Id") .. "&width=420&height=420&format=png"
        button.Coins.CoinsLabel.Text = ShopService:AlreadyOwnsItem(currItem) and "Owned" or tostring(currItem:GetAttribute("Cost"))
        button.Parent = gameUI.ShopFrame.Content.Items

        button.MouseButton1Click:Connect(function()

            if not gameUI.ShopFrame.infoFrame.Visible then
                gameUI.ShopFrame.infoFrame.Visible = true
            end
            selected = currItem
            gameUI.ShopFrame.infoFrame.itemName.Text = currItem:GetAttribute("Name")
            gameUI.ShopFrame.infoFrame.itemIcon.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=" .. selected:GetAttribute("Id") .. "&width=420&height=420&format=png"
            gameUI.ShopFrame.infoFrame.itemDescription.Text = currItem:GetAttribute("Description")

            if Knit.Player.Inventory[Category]:FindFirstChild(currItem.Name) then
                if Knit.Player.Inventory[Category]:FindFirstChild(currItem.Name).Value then
                    gameUI.ShopFrame.infoFrame.purchaseButton.Coins.CoinsLabel.Text = "Unequip"
                    button.Coins.CoinsLabel.Text = "Equipped"
                else
                    gameUI.ShopFrame.infoFrame.purchaseButton.Coins.CoinsLabel.Text = "Equip"
                end
                button.Coins.CoinsLabel.Text = "Owned"
                gameUI.ShopFrame.infoFrame.purchaseButton.Coins.ImageTransparency = 1
                gameUI.ShopFrame.infoFrame.purchaseButton.Coins.CoinsLabel.Position = UDim2.new(0.25, 0, 0.143, 0)
                gameUI.ShopFrame.infoFrame.purchaseButton.Coins.CoinsLabel.TextXAlignment = Enum.TextXAlignment.Center
            else
                gameUI.ShopFrame.infoFrame.purchaseButton.Coins.ImageTransparency = 0
                gameUI.ShopFrame.infoFrame.purchaseButton.Coins.CoinsLabel.Position = UDim2.new(1.214, 0, 0, 0)
                gameUI.ShopFrame.infoFrame.purchaseButton.Coins.CoinsLabel.TextXAlignment = Enum.TextXAlignment.Left
                gameUI.ShopFrame.infoFrame.purchaseButton.Coins.CoinsLabel.Text = convertComma(currItem:GetAttribute("Cost"))
            end
        end)
    end
end

function ShopController:KnitStart()
    gameUI = GameUIController:GetGameUI()

    ProcessButtonPresses()
    gameUI.ShopFrame.infoFrame.Visible = true

    gameUI.ShopFrame.infoFrame.purchaseButton.MouseButton1Click:Connect(function()
        if (gameUI.ShopFrame.infoFrame.purchaseButton.Coins.CoinsLabel.Text == "Equip") then
            ShopService:EquipItem(selected.Name)
            gameUI.ShopFrame.infoFrame.purchaseButton.Coins.CoinsLabel.Text = "Unequip"
        elseif (gameUI.ShopFrame.infoFrame.purchaseButton.Coins.CoinsLabel.Text == "Unequip") then
            ShopService:UnequipItem(selected.Name)
            gameUI.ShopFrame.infoFrame.purchaseButton.Coins.CoinsLabel.Text = "Equip"
        else
            ShopService:PurchaseItem(selected.Name)
            gameUI.ShopFrame.infoFrame.purchaseButton.Coins.CoinsLabel.Text = "Owned"
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
                    end
                }
            }
        end
    end)
end


return ShopController