local _, ns = ...
local B, C, L, DB = unpack(ns)
local SKIN = B:GetModule("Skins")

function SKIN:ls_Toasts()
	if not IsAddOnLoaded("ls_Toasts") then return end

	local LE, LC = unpack(ls_Toasts)
	LE:RegisterSkin("ndui", {
		name = "NDui",
		bonus = {
			hidden = false,
		},
		border = {
			offset = 0,
			size = B.Scale(1.5),
			texture = {1, 1, 1, 1},
		},
		dragon = {
			hidden = false,
		},
		icon = {
			tex_coords = DB.TexCoord,
		},
		icon_border = {
			offset = 0,
			size = B.Scale(1.5),
			texture = {1, 1, 1, 1},
		},
		icon_highlight = {
			hidden = true,
		},
		icon_text_1 = {
			flags = DB.Font[3],
			shadow = false,
		},
		icon_text_2 = {
			flags = DB.Font[3],
			shadow = false,
		},
		skull = {
			hidden = false,
		},
		slot = {
			tex_coords = DB.TexCoord,
		},
		slot_border = {
			offset = 0,
			size = B.Scale(1.5),
			texture = {1, 1, 1, 1},
		},
		text = {
			flags = DB.Font[3],
			shadow = false,
		},
		title = {
			flags = DB.Font[3],
			shadow = false,
		},
	})

	LC.options.args.general.args.skin.disabled = true

	LC.db.profile.skin = "ndui"
	LC.db.profile.font.size = 16
	LC.db.profile.strata = "DIALOG"
	LC.db.profile.types.loot_common.quest = true
	LC.db.profile.types.loot_common.threshold = 2
	LC.db.profile.types.loot_special.threshold = 2
	LC.db.profile.types.loot_gold.threshold = 100000
	LC.db.profile.colors = {name = true, border = true, icon_border = true, threshold = 2}
	LC.db.profile.anchors[1] = {
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
	}
end

C.OnLoginThemes["ls_Toasts"] = SKIN.ls_Toasts