local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage:FindFirstChild("Packages").Knit)

local ShopController = Knit.CreateController({ Name = "ShopController" })

local GameUIController
local ShopService, DataService


function ShopController:KnitStart()
	GameUIController = Knit.GetController("GameUIController")
end
function ShopController:KnitInit() end

return ShopController
