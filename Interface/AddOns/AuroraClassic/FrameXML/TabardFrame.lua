local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.ReskinFrame(TabardFrame)
	F.StripTextures(TabardFrameCostFrame)
	F.CreateBDFrame(TabardFrameCostFrame, 0)
	F.ReskinButton(TabardFrameAcceptButton)
	F.ReskinButton(TabardFrameCancelButton)
	F.ReskinArrow(TabardCharacterModelRotateLeftButton, "left")
	F.ReskinArrow(TabardCharacterModelRotateRightButton, "right")

	F.StripTextures(TabardFrameMoneyBg)
	F.StripTextures(TabardFrameMoneyInset)

	TabardFrameCustomizationBorder:Hide()
	TabardCharacterModelRotateRightButton:ClearAllPoints()
	TabardCharacterModelRotateRightButton:SetPoint("TOPLEFT", TabardCharacterModelRotateLeftButton, "TOPRIGHT", 1, 0)

	for i = 1, 5 do
		F.StripTextures(_G["TabardFrameCustomization"..i])
		F.ReskinArrow(_G["TabardFrameCustomization"..i.."LeftButton"], "left")
		F.ReskinArrow(_G["TabardFrameCustomization"..i.."RightButton"], "right")
	end
end)