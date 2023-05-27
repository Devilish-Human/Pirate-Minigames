local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage:FindFirstChild("Packages").Knit)

local module = {}

-- function module:EquipEffect(player: Player, name: string)
-- 	if player then
-- 		if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
-- 			local shopManager = ShopService:GetShopManager()

-- 			local tFromShop = shopManager:GetShopData("Trail"):FindFirstChild(name)
-- 			local trail = DataService:GetInventoryData(player, "Trail")
-- 			if trail and tFromShop then
-- 				self:RemoveAllTrails(player)
-- 				local tClone = tFromShop:Clone()
-- 				tClone.Parent = player.Character.HumanoidRootPart
-- 			end
-- 		end
-- 	end
-- end

-- function module:RemoveAllEffects(player: Player)
-- 	if player then
-- 		if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
-- 			for i, v in pairs(player.Character.HumanoidRootPart:GetChildren()) do
-- 				if v:IsA("ParticleEmitter") then
-- 					v:Destroy()
-- 				end
-- 			end
-- 			for i, v in pairs(DataService:GetInventoryData(player, "Trail")) do
-- 				i[v] = false
-- 			end
-- 		end
-- 	end
-- end
return module
