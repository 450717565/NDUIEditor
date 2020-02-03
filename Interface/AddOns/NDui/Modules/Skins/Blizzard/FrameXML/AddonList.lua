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

	hooksecurefunc("AddonList_Update", function()
		for i = 1, MAX_ADDONS_DISPLAYED do
			local entry = "AddonListEntry"..i

			local check = _G[entry.."Enabled"]
			local button = _G[entry.."Load"]

			if not check.styled then
				B.ReskinCheck(check)
				B.ReskinButton(button)

				check.styled = true
			end

			local ch = check:GetCheckedTexture()
			ch:SetDesaturated(true)
			ch:SetVertexColor(cr, cg, cb)
		end
	end)
end)