-- File: ShopService
-- Author: PirateNinja Studio
-- Date: 07/15/2023

-- // Roblox Services \\ --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")

local Packages = ReplicatedStorage:FindFirstChild("Packages")
local Knit = require(Packages.Knit)

-- Constants
local Assets = ServerStorage.Assets
local ShopItems = Assets.ShopItems

local CmdrService
local DataService

local ShopService = Knit.CreateService {
    Name = "ShopService",
    Client = {
        EquipItem = Knit.CreateSignal(); -- args: player, itemName,
        PurchaseItem = Knit.CreateSignal();
    };
}

function ShopService:GetItemCategory(item)
    local category = nil

    for _, cat in pairs(ShopItems:GetChildren()) do
        for _, obj in pairs(cat:GetChildren()) do
            if obj.Name == string.lower(item) then
                category = cat
            end
        end
    end

    return category
end

function ShopService:PurchaseItem(player, itemName)
    local category = self:GetItemCategory(itemName)
    local item = category:FindFirstChild(string.lower(itemName))

    if DataService:Get(player, "Coins") >= item:GetAttribute("Cost") then
        print(`{player} has purchased ({category}) {itemName} for {item:GetAttribute("Cost")} coins`)

        DataService:Update(player, "Coins", function(coins)
            return coins - item:GetAttribute("Cost")
        end)

        DataService:Update(player, "Inventory", function(items)
            local oldInventory = items
            local Inventory = table.clone(oldInventory)
            if (not Inventory[category][itemName]) then
                Inventory[category][itemName] = true
            end
            return Inventory
        end)
    else
        print(`{player} tried purchasing ({category}) {itemName} for {item:GetAttribute("Cost")} coins but has {DataService:Get(player, "Coins")}`)
    end
end

-- function ShopService.Client:PurchaseItem(player: Player, itemName: string)
    
-- end

function ShopService:KnitStart()
    self.Client.PurchaseItem:Connect(function(player: Player, itemName: string)
        if not CmdrService.PlayerCooldowns[player.UserId] and not CmdrService.PlayerNotes[player.UserId] then
            CmdrService.PlayerCooldowns[player.UserId] = os.time()
            CmdrService.PlayerNotes[player.UserId] = 0
        end
    
        local currentTime = os.time()
    
        if (currentTime < CmdrService.PlayerCooldowns[player.UserId] + 5) then
            CmdrService.Watchdog.Note(player, CmdrService.ServerModeratorId, "Fired purchase item before 5 seconds was up")
            CmdrService.PlayerNotes[player.UserId] += 1
    
            if (CmdrService.PlayerNotes[player.UserId] >= 3) then
                CmdrService.Watchdog.Ban(player, CmdrService.ServerModeratorId, 604800*2, "Exploiting: firing purchaseItem in under the cooldown time.")
            end
        else
            self:PurchaseItem(player, itemName)
            CmdrService.PlayerCooldowns[player.UserId] = currentTime
        end
    
        --CmdrService.Watchdog:Ban(player, )
    
        print(player)
    
        print(CmdrService.PlayerCooldowns, CmdrService.PlayerNotes)
    end)
end

function ShopService:KnitInit()
    print("ShopService initialized")

    CmdrService = Knit.GetService("CmdrService")
    DataService = Knit.GetService("DataService")
end

return ShopService