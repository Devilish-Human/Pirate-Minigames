export type Item = {
    DisplayName: string,
    Description: string?,
    Cost: number,
    Id: number | string?,
}

return {
    ["Gear"] = {
        ["BloxyCola"] = {
            DisplayName = "Throwing Spork",
            Description = "A cold refreshment drink on a hot day.",
            Cost = 60,
            Id = 10472779,
        },
        ["Spork"] = {
            DisplayName = "Throwing Spork",
            Description = 0,
            Cost = 250,
            Id = 107458429,
        },
        ["Cake"] = {
            DisplayName = "Cake",
            Description = "The cake was a lie",
            Cost = 60,
            Id = 16214845
        }
    },

    ["Tag"] = {
        ["Beginner"] = {
            DisplayName = "Beginner Tag",
            Description = "The beginner tag",
            Cost = 125,
            Id = "player tag"
        }
    }
}