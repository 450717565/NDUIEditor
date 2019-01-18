local F, C = unpack(select(2, ...))

C.themes["Blizzard_OrderHallUI"] = function()
	local r, g, b = C.r, C.g, C.b

	OrderHallTalentFrame.OverlayElements:Hide()
	F.ReskinIcon(OrderHallTalentFrame.Currency.Icon, true)
	F.ReskinButton(OrderHallTalentFrame.BackButton)

	hooksecurefunc(OrderHallTalentFrame, "RefreshAllData", function()
		F.ReskinFrame(OrderHallTalentFrame)

		for i = 1, OrderHallTalentFrame:GetNumChildren() do
			local bu = select(i, OrderHallTalentFrame:GetChildren())
			if bu and bu.talent then
				F.ReskinTexture(bu.Border, bu, false, true)
				bu.Border:SetColorTexture(r, g, b)

				if not bu.bg then
					bu.bg = F.ReskinIcon(bu.Icon, true)
					F.ReskinTexture(bu.Highlight, bu.bg, false)
				end
			end
		end
	end)
end