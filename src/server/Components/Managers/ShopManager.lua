local Knit = require(game:GetService("ReplicatedStorage").Knit)
local Maid = require(Knit.Util.Maid)

local ShopManager = {}
ShopManager.__index = ShopManager

ShopManager.Tag = "ShopManager"


function ShopManager.new(instance)
    
    local self = setmetatable({}, ShopManager)
    
    self._maid = Maid.new()
    print ("ShopManager::new")

    return self
    
end

function ShopManager:Init()
    print ("ShopManager::init")
end

function ShopManager:GetSelected ()
    
end

function ShopManager:SetSelected (value)
    return self.Instance:SetAttribute ("Selected", value)
end

function ShopManager:Deinit()
end


function ShopManager:Destroy()
    self._maid:Destroy()
end


return ShopManager