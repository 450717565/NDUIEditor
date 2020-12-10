local B, C, L, DB = unpack(select(2, ...))
local Skins = B:GetModule("Skins")

function Skins:ls_Toasts()
	if not IsAddOnLoaded("ls_Toasts") then return end

	local LE, LC, LL = unpack(ls_Toasts)
	LE:RegisterSkin("ndui", {
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

	LC.db.profile.skin = "ndui"
	LC.options.args.general.args.skin.disabled = true
end