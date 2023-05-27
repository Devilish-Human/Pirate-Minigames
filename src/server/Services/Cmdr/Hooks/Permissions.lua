local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

local Admins = {
    44821621,
    74633861,
    135459427,
}

return function (registery)
    registery:RegisterHook("BeforeRun", function(context)
        local CmdrService = Knit.GetService("CmdrService")
        if context.Group == "DefaultAdmin" and not CmdrService.Admins[context.Executor.UserId] then
            return "You don't have permissions to run this command."
        end
    end)
end