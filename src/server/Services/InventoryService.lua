local Knit = require(game:GetService("ReplicatedStorage").Knit)

local DataStoreService = game:GetService("DataStoreService")

local InventoryService = Knit.CreateService {
    Name = "InventoryService";
    Client = {};
}

local inventoryData = DataStoreService:GetDataStore ("InventoryData-dev2")

 -- Inventory
 Inventory = {
    Gears = {};
    Effects = {};
    Titles = {};
    Characters = {};
};

--[[ Equipped_Tag = "Tag of Testing",
Equipped_Character = "",
Equipped_Effect = "",
Equipped_Gear = {}]]

function LoadPlayer (player: Player)
    local inventoryFolder = Instance.new("Folder")
    inventoryFolder.Name = "Inventory"
    inventoryFolder.Parent = player
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