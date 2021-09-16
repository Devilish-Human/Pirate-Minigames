local Players = game:GetService("Players")
local Knit = require(game:GetService("ReplicatedStorage").Knit)

local DataStoreService = game:GetService("DataStoreService")

local InventoryService = Knit.CreateService {
    Name = "InventoryService";
    Client = {};
}

local shopItems = game:GetService("ReplicatedStorage").ShopItems

local inventoryData = DataStoreService:GetDataStore ("InventoryData-dev2")

local toInstance = require(Knit.Modules.ToInstance)

function LoadPlayer (player: Player)
    local inventoryFolder = Instance.new("Folder")
    inventoryFolder.Name = "Inventory"
    inventoryFolder.Parent = player

    local gearFolder = Instance.new("Folder")
    gearFolder.Name = "Gear"
    gearFolder.Parent = inventoryFolder

    local effectFolder = Instance.new("Folder")
    effectFolder.Name = "Effect"
    effectFolder.Parent = inventoryFolder

    local titleFolder = Instance.new("Folder")
    titleFolder.Name = "Tag"
    titleFolder.Parent = inventoryFolder

    local characterFolder = Instance.new("Folder")
    characterFolder.Name = "Character"
    characterFolder.Parent = inventoryFolder

    pcall(function()
        local Inventory = inventoryData:GetAsync ("player_" .. player.UserId)

        if Inventory then
            for name, Table in pairs (Inventory) do
                for i,v in pairs (Table) do
                    local Bool = Instance.new("BoolValue")
                    Bool.Name = i
                    Bool.Value = v

                    Bool.Parent = inventoryFolder[name]

                    if (name == "Gear") then
                        if Bool.Value then
                            local gear = game.ReplicatedStorage.ShopItems.Gear:FindFirstChild(Bool.Name)
                            local clone = gear:Clone()
                            local clone2 = gear:Clone()
    
                            clone.Parent = player.Backpack
                            clone2.Parent = player.StarterGear
                        end
                    elseif (name == "Tag") then
                        if Bool.Value then
                            local tag = game.ReplicatedStorage.ShopItems.Tag:FindFirstChild(Bool.Name)
                            local clone = tag:Clone()
                            clone.Title.Text = tag:GetAttribute("Name")
                            clone.Title.TextSize = 25
    
                            clone.Parent = player.Character

                            player.CharacterAdded:Connect(function(char)
                                local clone2 = tag:Clone()
                                clone2.Title.Text = tag:GetAttribute("Name")
                                clone2.Title.TextSize = 25
                                clone2.Parent = char
                            end)
                        end
                    end
                end
            end
        end
    end)
end
function SavePlayer (player: Player)
    local playerInventory = InventoryService:GetInventory(player)

    pcall(function()
        local inventoryTable = {}
        for i,v in pairs (playerInventory:GetChildren()) do
            inventoryTable[v.Name] = {}
            for _, item in pairs (v:GetChildren()) do
                inventoryTable[v.Name][item.Name] = item.Value
            end
        end

        inventoryData:SetAsync("player_" .. player.UserId, inventoryTable)
    end)
end

function InventoryService:GetInventory(player)
    return player.Inventory
end

function InventoryService:AddToInventory (player: Player, itemToPurchase)
    local playerInventory = self:GetInventory(player)

    local itemCheck = Instance.new("BoolValue")
    itemCheck.Name = itemToPurchase.Name
    itemCheck.Value = false
    itemCheck.Parent = playerInventory:FindFirstChild(itemToPurchase:GetAttribute("Category"))

    SavePlayer(player)
end

function InventoryService:KnitStart()
    for _, plr in pairs (game:GetService("Players"):GetChildren()) do
        if plr then
            LoadPlayer(plr)
        end
    end
end


function InventoryService:KnitInit()
    game:GetService("Players").PlayerAdded:Connect (LoadPlayer)
    game:GetService("Players").PlayerRemoving:Connect (SavePlayer)

    task.spawn(function()
        while wait(30) do
            for _, player in pairs(game.Players:GetPlayers()) do
                SavePlayer(player)
            end
        end
    end)
end


return InventoryService