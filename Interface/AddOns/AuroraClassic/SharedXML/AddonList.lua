local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.ReskinFrame(AddonList)
	F.ReskinButton(AddonListEnableAllButton)
	F.ReskinButton(AddonListDisableAllButton)
	F.ReskinButton(AddonListCancelButton)
	F.ReskinButton(AddonListOkayButton)
	F.ReskinCheck(AddonListForceLoad)
	F.ReskinDropDown(AddonCharacterDropDown)
	F.ReskinScroll(AddonListScrollFrameScrollBar)

	AddonListForceLoad:SetScale(.8)
	AddonListCancelButton:SetWidth(120)
	AddonListOkayButton:SetWidth(120)
	AddonCharacterDropDown:SetWidth(170)

	local r, g, b = C.r, C.g, C.b
	hooksecurefunc("AddonList_Update", function()
		for i = 1, MAX_ADDONS_DISPLAYED do
			local checkbox = _G["AddonListEntry"..i.."Enabled"]
			if not checkbox.styled then
				F.ReskinCheck(checkbox)
				checkbox.styled = true
			end
			local ch = checkbox:GetCheckedTexture()
			ch:SetDesaturated(true)
			ch:SetVertexColor(r, g, b)
			F.ReskinButton(_G["AddonListEntry"..i.."Load"])
		end
	end)
end)