local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	local cr, cg, cb = C.r, C.g, C.b

	F.ReskinFrame(TokenFramePopup)
	F.ReskinCheck(TokenFramePopupInactiveCheckBox)
	F.ReskinCheck(TokenFramePopupBackpackCheckBox)
	F.ReskinScroll(TokenFrameContainerScrollBar)

	local function reskinButtons()
		local buttons = TokenFrameContainer.buttons
		if not buttons then return end

		for i = 1, #buttons do
			local bu = buttons[i]
			bu.highlight:SetPoint("TOPLEFT", 1, 0)
			bu.highlight:SetPoint("BOTTOMRIGHT", -1, 0)
			bu.highlight:SetColorTexture(cr, cg, cb, .25)

			if not bu.styled then
				bu.categoryMiddle:SetAlpha(0)
				bu.categoryLeft:SetAlpha(0)
				bu.categoryRight:SetAlpha(0)

				bu.icon:SetDrawLayer("ARTWORK")
				bu.bg = F.ReskinIcon(bu.icon, true)

				if bu.expandIcon then
					bu.expBg = F.CreateBDFrame(bu.expandIcon, 0)
					bu.expBg:SetPoint("TOPLEFT", bu.expandIcon, -3, 3)
					bu.expBg:SetPoint("BOTTOMRIGHT", bu.expandIcon, 3, -3)
				end

				bu.styled = true
			end

			if bu.isHeader then
				bu.bg:Hide()
				bu.expBg:Show()
			else
				bu.bg:Show()
				bu.expBg:Hide()
			end
		end
	end

	hooksecurefunc("TokenFrame_Update", reskinButtons)
	hooksecurefunc(TokenFrameContainer, "update", reskinButtons)
end)