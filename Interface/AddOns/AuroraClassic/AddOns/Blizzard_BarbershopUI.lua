local F, C = unpack(select(2, ...))

C.themes["Blizzard_BarbershopUI"] = function()
	F.StripTextures(BarberShopFrame, true)
	F.StripTextures(BarberShopAltFormFrame, true)
	F.StripTextures(BarberShopFrameMoneyFrame, true)

	BarberShopAltFormFrame:ClearAllPoints()
	BarberShopAltFormFrame:SetPoint("BOTTOM", BarberShopFrame, "TOP", 0, -74)

	F.SetBDFrame(BarberShopFrame, 45, -75, -45, 45)
	F.ReskinFrame(BarberShopAltFormFrame)

	F.ReskinButton(BarberShopFrameOkayButton)
	F.ReskinButton(BarberShopFrameCancelButton)
	F.ReskinButton(BarberShopFrameResetButton)

	for i = 1, #BarberShopFrame.Selector do
		local prevBtn, nextBtn = BarberShopFrame.Selector[i]:GetChildren()
		F.ReskinArrow(prevBtn, "left")
		F.ReskinArrow(nextBtn, "right")
	end

	-- [[ Banner frame ]]

	F.StripTextures(BarberShopBannerFrame, true)
	F.SetBDFrame(BarberShopBannerFrame, 25, -80, -20, 75)
end