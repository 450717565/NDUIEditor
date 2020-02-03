local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	local cr, cg, cb = DB.r, DB.g, DB.b

	B.ReskinFrame(TokenFramePopup)
	B.ReskinCheck(TokenFramePopupInactiveCheckBox)
	B.ReskinCheck(TokenFramePopupBackpackCheckBox)
	B.ReskinScroll(TokenFrameContainerScrollBar)

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
				bu.bg = B.ReskinIcon(bu.icon)

				if bu.expandIcon then
					bu.expBg = B.CreateBDFrame(bu.expandIcon, 0, 3)
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