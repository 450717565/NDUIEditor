local B, C, L, DB = unpack(select(2, ...))

C.themes["Blizzard_BarbershopUI"] = function()
	B.StripTextures(BarberShopFrame)
	B.CreateBG(BarberShopFrame, 45, -75, -48, 45)

	B.ReskinFrame(BarberShopAltFormFrame)
	BarberShopAltFormFrame:ClearAllPoints()
	BarberShopAltFormFrame:SetPoint("BOTTOM", BarberShopFrame, "TOP", 0, -70)

	B.StripTextures(BarberShopFrameMoneyFrame)
	B.ReskinButton(BarberShopFrameOkayButton)
	B.ReskinButton(BarberShopFrameCancelButton)
	B.ReskinButton(BarberShopFrameResetButton)

	for i = 1, #BarberShopFrame.Selector do
		local prevBtn, nextBtn = BarberShopFrame.Selector[i]:GetChildren()
		B.ReskinArrow(prevBtn, "left")
		B.ReskinArrow(nextBtn, "right")
	end

	-- [[ Banner frame ]]
	B.StripTextures(BarberShopBannerFrame, 0)
	B.CreateBG(BarberShopBannerFrame, 25, -80, -20, 75)
end