local groupTags = {
    [255] = {
		TagText = "Owner",
		TagColor = Color3.fromRGB (255, 8, 0)
	};
    [245] = {
        TagText = "Developer",
        TagColor = Color3.fromRGB (255, 100, 60)
    };
    [200] = {
        TagText = "Game Tester",
        TagColor = Color3.fromRGB (255, 196, 0)
    };
    [70] = {
        TagText = "Fan",
        TagColor = Color3.fromRGB (0, 255, 64)
    }
}

local groupColors = {
    [255] = Color3.fromRGB (255, 187, 0);
    [245] = Color3.fromRGB (255, 115, 0);
}


local userTags = {
    [74633861] = {
        TagText = "PirateNinja";
        TagColor = Color3.fromRGB(122, 255, 166)
    }
}

local userColor = {
    [0] = Color3.fromRGB (255, 187, 0);
    [1] = Color3.fromRGB (255, 115, 0);
}

return {
    GroupTags = groupTags;
    GroupColors = groupColors;
    UserTags = userTags;
    UserColor = userColor;
}