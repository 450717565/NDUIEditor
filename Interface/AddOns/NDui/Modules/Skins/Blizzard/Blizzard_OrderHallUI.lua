local B, C, L, DB = unpack(select(2, ...))

C.themes["Blizzard_OrderHallUI"] = function()
	local cr, cg, cb = DB.r, DB.g, DB.b

	OrderHallTalentFrame.OverlayElements:Hide()

	B.ReskinFrame(OrderHallTalentFrame)
	B.ReskinIcon(OrderHallTalentFrame.Currency.Icon)
	B.ReskinButton(OrderHallTalentFrame.BackButton)

	hooksecurefunc(OrderHallTalentFrame, "RefreshAllData", function(self)
		B.StripTextures(self)

		if self.CloseButton.Border then self.CloseButton.Border:SetAlpha(0) end
		if self.CurrencyBG then self.CurrencyBG:SetAlpha(0) end

		for i = 1, self:GetNumChildren() do
			local bu = select(i, self:GetChildren())
			if bu and bu.talent then
				bu.Border:SetAlpha(0)

				if not bu.icbg then
					bu.icbg = B.ReskinIcon(bu.Icon)
					B.ReskinHighlight(bu.Highlight, bu.icbg)
				end

				if bu.talent.selected then
					bu.icbg:SetBackdropBorderColor(cr, cg, cb)
				else
					bu.icbg:SetBackdropBorderColor(0, 0, 0)
				end
			end
		end
	end)
end