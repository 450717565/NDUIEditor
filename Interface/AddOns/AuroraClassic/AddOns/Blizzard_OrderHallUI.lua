local F, C = unpack(select(2, ...))

C.themes["Blizzard_OrderHallUI"] = function()
	OrderHallTalentFrame.OverlayElements:Hide()
	F.ReskinIcon(OrderHallTalentFrame.Currency.Icon)
	F.ReskinButton(OrderHallTalentFrame.BackButton)

	hooksecurefunc(OrderHallTalentFrame, "RefreshAllData", function(self)
		F.ReskinFrame(OrderHallTalentFrame)

		for i = 1, self:GetNumChildren() do
			local bu = select(i, self:GetChildren())
			if bu and bu.talent then
				F.ReskinBorder(bu.Border, bu, true)

				if not bu.bg then
					bu.bg = F.ReskinIcon(bu.Icon)
					F.ReskinTexture(bu.Highlight, bu.bg, false)
				end
			end
		end
	end)
end