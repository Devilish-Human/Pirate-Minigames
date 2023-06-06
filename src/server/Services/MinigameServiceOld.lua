-- local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- local Knit = require(ReplicatedStorage:FindFirstChild("Packages").Knit)

-- local MinigameService = Knit.CreateService({
-- 	Name = "MinigameService",
-- 	Client = {},
-- })

-- local Minigames = { "ObbyRunaway", "Sweeper", "Swordvival" }
-- --local Minigames = require(Knit.Modules.MinigameData)

-- local choseMinigame, chosenMap
-- function MinigameService.ChooseMinigame()
-- 	choseMinigame = Minigames[math.random(1, #Minigames)]
-- 	-- local maps = MapsFolder[choseMinigame]:GetChildren()
-- 	-- chosenMap = maps[math.random(1, #maps)]

-- 	-- local clone = chosenMap:Clone()W
-- 	-- clone.Name = choseMinigame

-- 	-- local currentMScript = ScriptsFolder:FindFirstChild(choseMinigame):Clone()
-- 	-- currentMScript.Name = "MinigameScript"
-- 	-- currentMScript.Parent = clone
-- 	-- return clone
-- 	return choseMinigame
-- end

-- function MinigameService:Start()
-- 	local module = Knit.Class[choseMinigame]
-- 	module:Start()
-- end

-- function MinigameService:KnitStart() end

-- return MinigameService
return "No"
