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
            if obj.Name == item then
                category = cat
            end
        end
    end

    return category
end

function ShopService:PurchaseItem(player, itemName)
    local category = self:GetItemCategory(itemName)
    local item = category:FindFirstChild(itemName)

    print(`{player} has purchased ({category}){itemName} for {item:GetAttribute("Cost")}`)
end

function ShopService:KnitStart()
    self.Client.PurchaseItem:Connect(function(player, itemName)
        if not self.PlayerCooldowns[player] and not CmdrService.NotesPerPlayer[player] then
            self.PlayerCooldowns[player] = os.time()
            CmdrService.NotesPerPlayer[player] = 0
        end

        local currentTime = os.time()

        if (currentTime < self.PlayerCooldowns[player] + 5) then
            CmdrService.Watchdog:Note(player, -1, "Fired purchase item before 5 seconds was up")
            CmdrService.NotesPerPlayer[player] += 1

            if (CmdrService.NotesPerPlayer[player] >= 3) then
                CmdrService.Watchdog:Ban(player, -1, 14, "Exploiting")
            end
        end

        self:PurchaseItem(player, itemName)
    end)
end

function ShopService:KnitInit()
    print("ShopService initialized")

    CmdrService = Knit.GetService("CmdrService")
    DataService = Knit.GetService("DataService")
end


return ShopService