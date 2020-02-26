local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	local cr, cg, cb = DB.r, DB.g, DB.b

	B.ReskinFrame(AddonList)
	B.ReskinButton(AddonListEnableAllButton)
	B.ReskinButton(AddonListDisableAllButton)
	B.ReskinButton(AddonListCancelButton)
	B.ReskinButton(AddonListOkayButton)
	B.ReskinCheck(AddonListForceLoad)
	B.ReskinDropDown(AddonCharacterDropDown)
	B.ReskinScroll(AddonListScrollFrameScrollBar)

	AddonListCancelButton:SetWidth(120)
	AddonListOkayButton:SetWidth(120)
	AddonCharacterDropDown:SetWidth(170)

	for i = 1, MAX_ADDONS_DISPLAYED do
		local Enabled = _G["AddonListEntry"..i.."Enabled"]
		B.ReskinCheck(Enabled, true)

		local Load = _G["AddonListEntry"..i.."Load"]
		B.ReskinButton(Load)
	end
end)