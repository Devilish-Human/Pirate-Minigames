local Knit = require(game:GetService("ReplicatedStorage").Knit)
local Roact = require(Knit.Shared.Roact)

local Status = Roact.Component:extend("Status")

function Status:render()
	return Roact.createElement("TextLabel", {
		Size = UDim2.fromScale(1, 0.075),
		Position = UDim2.fromScale(1, -0.03),
		Text = "Pirate Minigame Engine v0.15.1",
		BackgroundColor3 = Color3.fromRGB(30, 30, 30),
		BorderSizePixel = 1,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		FontSize = 20,
	})
end

return Status
