local groupTags = {
	[255] = {
		TagText = "Owner",
		TagColor = Color3.fromRGB(255, 8, 0),
	},
	[240] = {
		TagText = "Developer",
		TagColor = Color3.fromRGB(255, 100, 60),
	},
	[40] = {
		TagText = "Game Tester",
		TagColor = Color3.fromRGB(255, 196, 0),
	},
	[5] = {
		TagText = "Fan",
		TagColor = Color3.fromRGB(0, 255, 64),
	},
}

local groupColors = {
	[255] = Color3.fromRGB(255, 187, 0),
	[245] = Color3.fromRGB(255, 115, 0),
}

local userTags = {
	[49287450] = {
		TagText = "Person?",
		TagColor = Color3.fromRGB(228, 156, 0),
	},
	[74633861] = {
		TagText = "PirateNinja",
		TagColor = Color3.fromRGB(122, 255, 166),
	},
}

local userColor = {
	[0] = Color3.fromRGB(255, 187, 0),
	[1] = Color3.fromRGB(255, 115, 0),
}

return {
	GroupTags = groupTags,
	GroupColors = groupColors,
	UserTags = userTags,
	UserColor = userColor,
}
