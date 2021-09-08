local Knit = require(game:GetService("ReplicatedStorage").Knit)

local DataStoreService = game:GetService("DataStoreService")

local InventoryService = Knit.CreateService {
    Name = "InventoryService";
    Client = {};
}

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
    titleFolder.Name = "Tags"
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

                    if itemCat == "Gears" then
                        itemCheck.Parent = gearFolder
                        if itemCheck.Value then
                            local gearItem = game.ServerStorage.Assets.ShopItems["Gears"]:FindFirstChild(itemCheck.Name)
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
end


return InventoryService