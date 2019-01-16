local _, addonTable = ...

-- Mine
local C, D = {}, {}
addonTable.C, addonTable.D = C, D

D.profile = {
	strata = "DIALOG",
	skin = "default",
	font = {
		-- name = nil,
		size = 16,
	},
	colors = {
		name = true,
		border = true,
		icon_border = true,
		threshold = 2,
	},
	point = {
		p = "BOTTOM",
		rP = "BOTTOM",
		x = 0,
		y = 150,
	},
	types = {
		loot_common = {
			threshold = 2,
		},
		loot_special = {
			threshold = 2,
		},
		loot_gold = {
			threshold = 100000,
		},
	},
	anchors = {
		[1] = {
			fadeout_delay = 2,
			growth_direction = "UP",
			growth_offset_x = 26,
			growth_offset_y = 14,
			max_active_toasts = 12,
			scale = 1,
			point = {
				p = "BOTTOM",
				rP = "BOTTOM",
				x = 0,
				y = 150,
			},
		},
	},
}
