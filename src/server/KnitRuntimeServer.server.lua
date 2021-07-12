local Knit = require(game:GetService("ReplicatedStorage").Knit)

Knit.Modules = script.Parent.Modules
Knit.Shared = game:GetService("ReplicatedStorage").Shared

-- Load all services within 'Services':
Knit.AddServicesDeep(script.Parent.Services)

-- Load all services (the Deep version scans all descendants of the passed instance):
--Knit.AddServicesDeep(script.Parent.OtherServices)

Knit.Start():Catch(warn)