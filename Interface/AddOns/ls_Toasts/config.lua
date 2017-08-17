local _, addonTable = ...

-- Mine
local C, D = {}, {}
addonTable.C, addonTable.D = C, D

D.profile = {
	max_active_toasts = 12,
	scale = 1,
	strata = "DIALOG",
	fadeout_delay = 3,
	growth_direction = "UP",
	skin = "Default",
	sfx = {
		enabled = true,
	},
	colors = {
		name = true,
	},
	point = {
		p = "CENTER",
		rP = "BOTTOM",
		x = 0,
		y = 200,
	},
	types = {
		loot_special = {
			threshold = 2,
		},
		loot_common = {
			threshold = 2,
		},
		loot_gold = {
			threshold = 100000,
		},
	},
}
