require("constants")

return 	{
            type = LAYOUT.CIRCLE_EDGE,
            start_mask = PLACE_MASK.NORMAL,
            fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
            layout_position = LAYOUT_POSITION.CENTER,
            ground_types = {GROUND.ROCKY},
            defs = 
                {
                    rocks = {"basalt"},
                },
            count = 
                {
                    rocks = 60,
                },
            scale = 4.0,
        }

