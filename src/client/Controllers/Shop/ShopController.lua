local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage:FindFirstChild("Packages").Knit)
local Signal = require(ReplicatedStorage:FindFirstChild("Packages").Signal)

local ShopController = Knit.CreateController {
    Name = "ShopController",
    CurrentTab = nil,
    ShopData = require(script.Parent.ShopData)
}

local GameUIController
local ShopService, DataService

function ShopController:_createTab(name, bgcolor)
    local tab = {
        Name = name,
        Color = bgcolor or Color3.fromRGB(91, 91, 91),

        Active = false,
        Hover = false,

        TabChanged = Signal.new()
    }
    do
        tab["tabTemplate"] = Instance.new("TextButton")
        tab["tabTemplate"].Name = "tabTemplate"
        tab["tabTemplate"].FontFace = Font.new("rbxasset://fonts/families/Ubuntu.json")
        tab["tabTemplate"].Text = name
        tab["tabTemplate"].TextColor3 = Color3.fromRGB(255, 255, 255)
        tab["tabTemplate"].TextSize = 14
        tab["tabTemplate"].TextStrokeTransparency = 0
        tab["tabTemplate"].BackgroundColor3 = tab.Color
        tab["tabTemplate"].Size = UDim2.new(0, 100, 1, -10)

        tab["uICorner"] = Instance.new("UICorner")
        tab["uICorner"].Name = "UICorner"
        tab["uICorner"].CornerRadius = UDim.new(0, 4)
        tab["uICorner"].Parent = tab["tabTemplate"]

        tab["page"] = Instance.new("ScrollingFrame")
        tab["page"].Name = name
        tab["page"].ScrollBarThickness = 3
        tab["page"].Active = true
        tab["page"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        tab["page"].BackgroundTransparency = 1
        tab["page"].BorderSizePixel = 0
        tab["page"].Visible = false
        tab["page"].Size = UDim2.fromScale(1, 1)

        tab["uIGridLayout"] = Instance.new("UIGridLayout")
        tab["uIGridLayout"].Name = "UIGridLayout"
        tab["uIGridLayout"].CellSize = UDim2.fromOffset(90, 95)
        tab["uIGridLayout"].FillDirectionMaxCells = 4
        tab["uIGridLayout"].SortOrder = Enum.SortOrder.LayoutOrder
        tab["uIGridLayout"].Parent = tab["page"]

        tab["uIStroke"] = Instance.new("UIStroke")
        tab["uIStroke"].Name = "UIStroke"
        tab["uIStroke"].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        tab["uIStroke"].Color = tab.Color
        tab["uIStroke"].Parent = tab["tabTemplate"]
        
        tab["tabTemplate"].Parent = Knit.Player.PlayerGui:FindFirstChild("MainUI"):WaitForChild("Shop"):FindFirstChild("TabHolder")
        tab["page"].Parent = Knit.Player.PlayerGui:FindFirstChild("MainUI"):WaitForChild("Shop"):FindFirstChild("Content")
    end

    function tab:Activate()
        if not tab.Active then
            if ShopController.CurrentTab ~= nil then
                ShopController.CurrentTab:Deactivate()
            end

            tab.Active = true
            tab.tabTemplate.BackgroundColor3 = Color3.fromRGB(0, 106, 148)
            tab["uIStroke"].Color = Color3.fromRGB(255, 255, 255)
            tab.page.Visible = true
            
            ShopController.CurrentTab = tab
            tab.TabChanged:Fire()
        end
    end
    
    function tab:Deactivate()
        if (tab.Active) then
            tab.Active = false
            tab.Hover = false

            tab.page.Visible = false
            tab["uIStroke"].Color = tab.Color
            tab.tabTemplate.BackgroundColor3 = tab.Color
        end
    end

    function tab:Clear()
        if tab == ShopController.CurrentTab then
            for _,v in pairs(self.page:GetChildren()) do
                if v:IsA("UIListLayout") or v:IsA("UIGridLayout") then return end
                v:Destroy()
            end
        end
    end

    tab.tabTemplate.MouseEnter:Connect(function()
        tab.Hover = true

        if not tab.Active then
            tab.uIStroke.Color = Color3.fromRGB(175, 175, 175)
        end
    end)

    tab.tabTemplate.MouseLeave:Connect(function()
        tab.Hover = false

        if not tab.Active then
            tab.uIStroke.Color = tab.Color
        end
    end)

    tab.tabTemplate.MouseButton1Click:Connect(function()
        if (tab.Hover) then
            tab:Activate()
        end
    end)

    if (ShopController.CurrentTab == nil) then
        tab:Activate()
    end

    return tab
end

function ShopController:_createItemButton(name: string, tab: table, itemData: table)
    itemData = itemData or {
        DisplayName = "Item",
        Description = "",
        Cost = 0,
        Id = 0
    }

    local item = {}

    item["ItemButton"] = Instance.new("ImageButton")
    item["ItemButton"].Name = name
    item["ItemButton"].Image = `rbxassetid://{itemData.Id}`
    item["ItemButton"].BackgroundColor3 = Color3.fromRGB(131, 131, 131)
    item["ItemButton"].Size = UDim2.fromOffset(100, 100)

    item["textLabel"] = Instance.new("TextLabel")
    item["textLabel"].Name = name
    item["textLabel"].FontFace = Font.new("rbxasset://fonts/families/Ubuntu.json")
    item["textLabel"].Text = itemData.DisplayName
    item["textLabel"].TextColor3 = Color3.fromRGB(255, 255, 255)
    item["textLabel"].TextScaled = true
    item["textLabel"].TextSize = 14
    item["textLabel"].TextStrokeTransparency = 0
    item["textLabel"].TextWrapped = true
    item["textLabel"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    item["textLabel"].BackgroundTransparency = 1
    item["textLabel"].Size = UDim2.fromScale(1, 0.3)
    item["textLabel"].Parent = item["imageButton"]

    item["ItemButton"].Parent = tab.page

    return item
end

local ItemList = {
    Gear = {},
    Tag = {}
}

local TabList = {}

function ShopController:_generateItems(tab)
    tab:Clear()

    for i, v in pairs(self.ShopData) do
        for item, itemData in pairs(v) do
            if (self.CurrentTab == tab) then
                ItemList[i][string.lower(item)] = self:_createItemButton(item, tab, itemData)
            end
        end
    end
end

function ShopController:KnitStart()
    for tab, items in pairs(self.ShopData) do
        TabList[tab] = self:_createTab(tab)
    end

    self.CurrentTab.TabChanged:Connect(function()
        self:_generateItems(self.CurrentTab)

        print("Current Tab", self.CurrentTab)
    end)
    
    self:_generateItems(self.CurrentTab)

    print(self.CurrentTab)
end

function ShopController:KnitInit()
    GameUIController = Knit.GetController("GameUIController")
    ShopService = Knit.GetService("ShopService")
    DataService = Knit.GetService("DataService")
end

return ShopController
