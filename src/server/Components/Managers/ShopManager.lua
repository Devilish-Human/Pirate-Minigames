local Knit = require(game:GetService("ReplicatedStorage").Knit)
local Janitor = require(Knit.Util.Janitor)

local ShopManager = {}
ShopManager.__index = ShopManager

ShopManager.Tag = "ShopManager"

function ShopManager.new(instance)
	local self = setmetatable({}, ShopManager)

	self._janitor = Janitor.new()
	print("ShopManager::new")

	return self
end

function ShopManager:Init()
	print("ShopManager::init")
end

function ShopManager:GetSelected()
	return self.Instance:GetAttribute("Selected")
end

function ShopManager:SetSelected(value)
	return self.Instance:SetAttribute("Selected", value)
end

function ShopManager:Deinit() end

function ShopManager:Destroy()
	self._janitor:Cleanup()
end

return ShopManager
