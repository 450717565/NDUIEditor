local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.ReskinFrame(TabardFrame)
	F.StripTextures(TabardFrameCostFrame, true)
	F.CreateBDFrame(TabardFrameCostFrame, .25)
	F.ReskinButton(TabardFrameAcceptButton)
	F.ReskinButton(TabardFrameCancelButton)
	F.ReskinArrow(TabardCharacterModelRotateLeftButton, "left")
	F.ReskinArrow(TabardCharacterModelRotateRightButton, "right")

	F.StripTextures(TabardFrameMoneyBg, true)
	F.StripTextures(TabardFrameMoneyInset, true)
	TabardFrameCustomizationBorder:Hide()

	for i = 1, 5 do
		F.StripTextures(_G["TabardFrameCustomization"..i], true)
		F.ReskinArrow(_G["TabardFrameCustomization"..i.."LeftButton"], "left")
		F.ReskinArrow(_G["TabardFrameCustomization"..i.."RightButton"], "right")
	end

	TabardCharacterModelRotateRightButton:SetPoint("TOPLEFT", TabardCharacterModelRotateLeftButton, "TOPRIGHT", 1, 0)
end)