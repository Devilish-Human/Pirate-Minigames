local Roact = require(game:GetService("ReplicatedStorage").Roact)

local Status = Roact.Component:extend("Status")

function Status:render()
	return Roact.createElement("Frame", {
		BackgroundColor3 = Color3.fromRGB(48, 48, 48),
		BackgroundTransparency = 0.8,
		Size = UDim2.fromScale(1, 0.05),
	  }, {
		status = Roact.createElement("TextLabel", {
		  FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
		  TextColor3 = Color3.fromRGB(255, 255, 255),
		  TextSize = 22,
		  TextStrokeTransparency = 0.5,
		  BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		  BackgroundTransparency = 1,
		  Size = UDim2.fromScale(1, 1),
		}),
	  })
end

return Status
