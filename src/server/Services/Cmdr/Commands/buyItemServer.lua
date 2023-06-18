local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

return function (context, itemName)
    local ShopService = Knit.GetService("ShopService")

    ShopService:PurchaseItem(context.Executor, itemName)

    return `{itemName} purchased for {ShopService:GetItemCategory(string.lower(itemName)):GetAttribute("Cost")}`
end