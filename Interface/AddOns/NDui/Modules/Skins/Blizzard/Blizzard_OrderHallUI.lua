local B, C, L, DB = unpack(select(2, ...))

C.themes["Blizzard_OrderHallUI"] = function()
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
				B.ReskinBorder(bu.Border, bu, true)

				if not bu.bg then
					bu.bg = B.ReskinIcon(bu.Icon)
					B.ReskinTexture(bu.Highlight, bu.bg)
				end
			end
		end
	end)
end