-- File: UserData
-- Author: PirateNinja
-- Date: 07/16/2021

-- A basic data system created in 20-30 minutes

--local DDS = game:GetService("DataStoreService")
--local playerDataStore = DDS:GetDataStore("UData-test")

local UData = {};
UData.__index = UData

function UData.new (player: Player)
   return setmetatable({
       -- Stats
       Coins = 0;
       Wins = 0;
       Level = 1;

       -- Inventory
      Inventory = {};

       -- Info
       LastSaved = 0;
       SaveId = 0;

    }, UData)
end

function UData:AddStatValue (dataName: string, amount: number)
    amount = tonumber(amount) or 1;
    self[dataName] += amount;
end

function UData:GetStatValue (dataName: string)
    return self[dataName]
end

function UData:AddToInventory (itemName: string)
    if (itemName == nil or itemName == "" or itemName == " ") then return end
    self.Inventory[itemName] = itemName
end

function UData:GetItemFromInventory (itemName: string)
    return self.Inventory[itemName]
end

return UData