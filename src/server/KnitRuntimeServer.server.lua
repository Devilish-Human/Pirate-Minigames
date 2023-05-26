-- File: KnitRuntimeServer
-- Author: PirateNinja
-- Date: 07/16/2021

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage:FindFirstChild("Packages").Knit)
local KnitUtil = require(ReplicatedStorage:FindFirstChild("Packages").KnitUtil)
local Component = require(ReplicatedStorage:FindFirstChild("Packages").Component)

Knit.Modules = {}
Knit.Shared = game:GetService("ReplicatedStorage").Shared

Knit.Config = require(Knit.Shared.Config)

function Knit.Wait(...)
	return require(Knit.Shared.RBXWait)(...)
end
-- Load all services within 'Services':

Knit.Start()
	:Then(function()
		for _, v in pairs(workspace:GetChildren()) do
			if v.Name == "Nodes" and v:IsA("Folder") then
				v:Destroy()
			end
		end
		KnitUtil.LoadComponents(script.Parent.Components)
	end)
	:Catch(warn)

--Sodalicious
