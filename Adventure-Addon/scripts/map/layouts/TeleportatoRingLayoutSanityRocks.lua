require("constants")
local StaticLayout = require("map/static_layout")

return {
        type = LAYOUT.CIRCLE_EDGE,
        start_mask = PLACE_MASK.NORMAL,
        fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
        layout_position = LAYOUT_POSITION.CENTER,
        ground_types = {WORLD_TILES.GRASS},
        ground = {
                {0, 1, 1, 1, 0},
                {1, 1, 1, 1, 1},
                {1, 1, 1, 1, 1},
                {1, 1, 1, 1, 1},
                {0, 1, 1, 1, 0},
            },
        count = {
                sanityrock = 15,
            },
        layout = {
                teleportato_ring = { {x=0,y=0} },
            },

        scale = 1,
    }

