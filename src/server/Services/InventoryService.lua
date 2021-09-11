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
            for itemCat, Table in pairs (Inventory) do
                for item, value in pairs (Table) do
                    local itemCheck = Instance.new("BoolValue")
                    itemCheck.Name = item
                    itemCheck.Value = value

                    if itemCat == "Gear" then
                        itemCheck.Parent = gearFolder
                        if itemCheck.Value then
                            local gearItem = shopItems["Gears"]:FindFirstChild(itemCheck.Name)
                            local bpck = gearItem:Clone()
                            local strtpck = gearItem:Clone()

                            bpck.Parent = player.Backpack
                            strtpck.Parent = player.StarterPack
                        end
                    elseif itemCat == "Effect" then
                        itemCheck.Parent = effectFolder
                    elseif itemCat == "Title" then
                        itemCheck.Parent = titleFolder
                    else
                        itemCheck.Parent = characterFolder
                    end
                end
            end
        end
    end)
end
function SavePlayer (player: Player)
    local playerInventory = InventoryService:GetInventory(player)

    local saveTable = {}
    for _, v in pairs (playerInventory:GetChildren()) do
        saveTable[v.Name] = {}
        for _, item in pairs (v:GetChildren()) do
            saveTable[v.Name][item.Name] = item.Value
        end
    end

    inventoryData:SetAsync("player_" .. player.UserId, saveTable)
end

function InventoryService:GetInventory(player)
    return player.Inventory
end

function InventoryService:AddToInventory (player: Player, itemToPurchase)
    local playerInventory = self:GetInventory(player)

    local itemCheck = Instance.new("BoolValue")
    itemCheck.Name = itemToPurchase.Name
    itemCheck.Value = true
    itemCheck.Parent = player.Inventory:FindFirstChild(itemToPurchase:GetAttribute("Category"))

    for i,v in pairs(self:GetInventory(player):GetChildren()) do
        print(i,v)
    end
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
end


return InventoryService