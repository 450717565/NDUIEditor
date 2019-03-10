local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	local cr, cg, cb = C.r, C.g, C.b

	F.ReskinFrame(AddonList)
	F.ReskinButton(AddonListEnableAllButton)
	F.ReskinButton(AddonListDisableAllButton)
	F.ReskinButton(AddonListCancelButton)
	F.ReskinButton(AddonListOkayButton)
	F.ReskinCheck(AddonListForceLoad)
	F.ReskinDropDown(AddonCharacterDropDown)
	F.ReskinScroll(AddonListScrollFrameScrollBar)

	AddonListCancelButton:SetWidth(120)
	AddonListOkayButton:SetWidth(120)
	AddonCharacterDropDown:SetWidth(170)

	hooksecurefunc("AddonList_Update", function()
		for i = 1, MAX_ADDONS_DISPLAYED do
			local check = _G["AddonListEntry"..i.."Enabled"]
			local button = _G["AddonListEntry"..i.."Load"]

			if not check.styled then
				F.ReskinCheck(check)
				F.ReskinButton(button)

				check.styled = true
			end

			local ch = check:GetCheckedTexture()
			ch:SetDesaturated(true)
			ch:SetVertexColor(cr, cg, cb)
		end
	end)
end)