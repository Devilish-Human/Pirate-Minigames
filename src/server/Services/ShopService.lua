local Knit = require(game:GetService("ReplicatedStorage").Knit)
local RemoteSignal = require(Knit.Util.Remote.RemoteSignal)

local ShopService = Knit.CreateService {
    Name = "ShopService";
    Client = {
        PrompEvent = RemoteSignal.new()
    };
}

local shopItems = game:GetService("ServerStorage").Assets.ShopItems

local DataService, InventoryService
function ShopService:PurchaseItem (player: Player, itemName: string)
    local profile = DataService:GetProfile(player)

    local itemToPurchase
    if profile then
        for i,v in pairs(shopItems:GetChildren()) do
            for _, item in pairs (v:GetChildren()) do
                if item.Name == itemName then
                    if (item == nil) then
                        return
                    end
                    itemToPurchase = item
                end
            end
        end
        --
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
    local character = player.Character or player.CharacterAdded:Wait()
    
    if (item:GetAttribute("Category") == "Tag") then
        if character then
            local tag = item:Clone()
            tag.Parent = character:FindFirstChild("Head")
        end
    end
end

function ShopService:AlreadyOwnsItem (player, item)
    if (InventoryService:GetInventory(player)[item:GetAttribute("Category")]:FindFirstChild(item.Name)) then
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