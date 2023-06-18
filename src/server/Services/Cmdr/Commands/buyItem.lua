return {
    Name = "buy";
	Aliases = {"buyItem"};
	Description = "Purchase an item from the shop.";
	Group = "Guest";
	Args = {
		{
			Type = "string";
			Name = "itemName";
			Description = "name of the item.";
		},
	};
}