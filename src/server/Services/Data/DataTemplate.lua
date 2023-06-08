export type DataType = {
    Coins: number,
    Level: number,
    Wins: number,

    Inventory: {
        Gears: {},
        Titles: {},
        Effects: {},
        [any]: {}
    };

    Equipped: {
        Gears: {};
        Titles: {};
        Effects: {};
        [any]: any
    };
}

local DataTemplate: DataType = {
    Coins = 0,
    Level = 1,
    Wins = 0,

    Inventory = {
        Gears = {},
        Titles = {},
        Effects = {}
    },

    Equipped = {
        Gears = {},
        Titles = {},
        Effects = {}
    }
}

return DataTemplate