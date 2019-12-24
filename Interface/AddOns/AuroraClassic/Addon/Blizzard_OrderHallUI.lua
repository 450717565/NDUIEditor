local F, C = unpack(select(2, ...))

C.themes["Blizzard_OrderHallUI"] = function()
	OrderHallTalentFrame.OverlayElements:Hide()

	F.ReskinFrame(OrderHallTalentFrame)
	F.ReskinIcon(OrderHallTalentFrame.Currency.Icon)
	F.ReskinButton(OrderHallTalentFrame.BackButton)

	hooksecurefunc(OrderHallTalentFrame, "RefreshAllData", function(self)
		F.StripTextures(self)

		if self.CloseButton.Border then self.CloseButton.Border:SetAlpha(0) end
		if self.CurrencyBG then self.CurrencyBG:SetAlpha(0) end

		for i = 1, self:GetNumChildren() do
			local bu = select(i, self:GetChildren())
			if bu and bu.talent then
				F.ReskinBorder(bu.Border, bu, true)

				if not bu.bg then
					bu.bg = F.ReskinIcon(bu.Icon)
					F.ReskinTexture(bu.Highlight, bu.bg)
				end
			end
		end
	end)
end