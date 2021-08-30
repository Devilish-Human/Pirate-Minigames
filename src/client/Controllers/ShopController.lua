local Knit = require(game:GetService("ReplicatedStorage").Knit)

local ShopController = Knit.CreateController { Name = "ShopController" }


local ShopService, DataService
local shopManager
function ShopController:KnitStart()
end


function ShopController:KnitInit()
    --ShopService = Knit.GetService("ShopService")
end


return ShopController