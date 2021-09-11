local Knit = require(game:GetService("ReplicatedStorage").Knit)
local RemoteSignal = require(Knit.Util.Remote.RemoteSignal)

local ShopService = Knit.CreateService {
    Name = "ShopService";
    Client = {
        PrompEvent = RemoteSignal.new(),
        ShopItemEvent = RemoteSignal.new()
    };
}

local shopItems = game:GetService("ReplicatedStorage").ShopItems

local DataService, InventoryService
function ShopService:PurchaseItem (player: Player, itemName: string)
    print("A")
    local profile = DataService:GetProfile(player)

    local itemToPurchase
    if profile then
        for i,v in pairs(shopItems:GetChildren()) do
            for _, item in pairs (v:GetChildren()) do
                if item.Name == itemName then
                    itemToPurchase = item
                end
            end
        end
        
        if (profile.Coins >= itemToPurchase:GetAttribute("Cost")) then
            if (self:AlreadyOwnsItem(player, itemToPurchase)) then
                self.Client.PrompEvent:Fire (player, "Error", "Already own item!", ("You already own this item."):format(itemName))
                return
            end
            profile.Coins -= itemToPurchase:GetAttribute("Cost")
            InventoryService:AddToInventory (player, itemToPurchase)
            print(("Deducted %s"):format(itemToPurchase:GetAttribute("Cost")))
        else
            self.Client.PrompEvent:Fire (player, "Error", "Not enough coins.", ("You do not have enough coins to buy %s. Try again later when you have enough coins."):format(itemName))
            print(("Purchased failed not enough coins. Need %s more coins"):format(itemToPurchase:GetAttribute("Cost") - profile.Coins))
        end
    end
end

function ShopService:EquipItem (player: Player, item)
    
    if (item:GetAttribute("Category") == "Gear") then
        local gear = shopItems:FindFirstChild(item.Name)

        if gear then
            if self:AlreadyOwnsItem(player, gear) and not player.StarterGear:FindFirstChild(gear.Name) then
                local bpckClone = gear:Clone()
                local strterClone = gear:Clone()

                bpckClone.Parent = player.Backpack
                strterClone.Parent = player.StarterGear
            end
        end
    end
end

function ShopService:AlreadyOwnsItem (player, item)
    if (InventoryService:GetInventory(player):FindFirstChild(item:GetAttribute("Category")):FindFirstChild(item.Name)) then
        return true
    end
    return false
end

function ShopService.Client:PurchaseItem (player: Player, ...)
    return self.Server:PurchaseItem (player, ...)
end

function ShopService.Client:EquipItem (player, ...)
    return self.Server:EquipItem(player, ...)
end

function ShopService:KnitStart()
end


function ShopService:KnitInit()
    DataService = Knit.GetService("DataService")
    InventoryService = Knit.GetService("InventoryService")
end


return ShopService