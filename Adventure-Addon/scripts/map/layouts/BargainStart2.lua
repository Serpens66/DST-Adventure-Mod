require("constants")
local StaticLayout = require("map/static_layout")

return  StaticLayout.Get("map/static_layouts/bargain_start2", {
							-- fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN,
                            start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN,
                            fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
						})
