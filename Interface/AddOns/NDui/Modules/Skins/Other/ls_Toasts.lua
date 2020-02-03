local B, C, L, DB = unpack(select(2, ...))
local S = B:GetModule("Skins")

function S:ls_Toasts()
	local E = unpack(ls_Toasts)
	E:RegisterSkin("ndui", {
		name = "NDui",
		border = {
			offset = 0,
			size = B.Scale(1.5),
			texture = {1, 1, 1, 1},
		},
		title = {
			flags = DB.Font[3],
			shadow = false,
		},
		text = {
			flags = DB.Font[3],
			shadow = false,
		},
		bonus = {
			hidden = false,
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
	})
end