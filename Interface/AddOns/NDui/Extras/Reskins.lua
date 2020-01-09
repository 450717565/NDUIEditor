local B, C, L, DB, F = unpack(select(2, ...))
local Extras = B:GetModule("Extras")

local cr, cg, cb = DB.r, DB.g, DB.b

function Extras:Reskins()
	if IsAddOnLoaded("!BaudErrorFrame") then
		F.CreateBD(BaudErrorFrame)

		B.StripTextures(BaudErrorFrameListScrollBox)
		B.StripTextures(BaudErrorFrameDetailScrollBox)
		F.CreateBDFrame(BaudErrorFrameListScrollBox, 0)
		F.CreateBDFrame(BaudErrorFrameDetailScrollBox, 0)

		local boxHL = BaudErrorFrameListScrollBoxHighlightTexture
		boxHL:SetTexture(DB.bdTex)
		boxHL:SetVertexColor(cr, cg, cb, .25)

		local buttons = {BaudErrorFrameClearButton, BaudErrorFrameCloseButton, BaudErrorFrameReloadUIButton}
		for _, button in pairs(buttons) do
			F.ReskinButton(button)
			button.Text:SetTextColor(cr, cg, cb)
		end
	end

	if IsAddOnLoaded("DungeonWatchDog") then
		select(11, LFGListFrame.SearchPanel:GetChildren()):Hide()
	end

	if IsAddOnLoaded("ls_Toasts") then
		local E = unpack(ls_Toasts)
		E:RegisterSkin("ndui", {
			name = "NDui",
			border = {
				offset = 0,
				size = C.pixel,
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
				tex_coords = {.08, .92, .08, .92},
			},
			icon_border = {
				offset = 0,
				size = C.pixel,
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
				tex_coords = {.08, .92, .08, .92},
			},
			slot_border = {
				offset = 0,
				size = C.pixel,
				texture = {1, 1, 1, 1},
			},
		})
	end

	if IsAddOnLoaded("PremadeGroupsFilter") then
		local rebtn = LFGListFrame.SearchPanel.RefreshButton
		UsePFGButton:SetSize(32, 32)
		UsePFGButton:ClearAllPoints()
		UsePFGButton:SetPoint("RIGHT", rebtn, "LEFT", -55, 0)
		UsePFGButton.text:SetText(FILTER)
		UsePFGButton.text:SetWidth(UsePFGButton.text:GetStringWidth())

		local dialog = PremadeGroupsFilterDialog
		dialog.Defeated.Title:ClearAllPoints()
		dialog.Defeated.Title:SetPoint("LEFT", dialog.Defeated.Act, "RIGHT", 2, 0)
	end
end