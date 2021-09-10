local Knit = require(game:GetService("ReplicatedStorage").Knit)

local ShopController = Knit.CreateController { Name = "ShopController" }


local ShopService, DataService
local shopManager
local prompt = require(Knit.Modules.Prompt)

function ShopController:KnitStart()
    ShopService.PrompEvent:Connect(function(messageType, ...)
        if (messageType) == "Error" then
            local content = {...}
            prompt:Create {
                Title = content[1], -- This will be the title of our prompt
                Text = content[2], -- This will be the body of our prompt
                
                -- V These are optional V --
                
                AcceptButton = { -- This table will allow us to create an AcceptButton
                    Text = "Accept", -- This will be the Text of the AcceptButton
                    Callback = function() -- This function will run when the player clicks the AcceptButton
                        return
                    end,
                }
            }
        end
    end)
    ShopService:PurchaseItem ("Tag of Testing")
end
function ShopController:KnitInit()
    ShopService = Knit.GetService("ShopService")
end


return ShopController