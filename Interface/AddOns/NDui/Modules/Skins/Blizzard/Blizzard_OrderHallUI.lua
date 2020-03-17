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

				if not bu.bg then
					bu.bg = B.ReskinIcon(bu.Icon)
					B.ReskinHighlight(bu.Highlight, bu.bg)
				end

				if bu.talent.selected then
					bu.bg:SetBackdropBorderColor(cr, cg, cb)
				else
					bu.bg:SetBackdropBorderColor(0, 0, 0)
				end
			end
		end
	end)
end