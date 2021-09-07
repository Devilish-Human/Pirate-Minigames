local Knit = require(game:GetService("ReplicatedStorage").Knit)

local ShopService = Knit.CreateService {
    Name = "ShopService";
    Client = {};
}

function ShopService:PurchaseItem ()
end

function ShopService:KnitStart()
end


function ShopService:KnitInit()
end


return ShopService