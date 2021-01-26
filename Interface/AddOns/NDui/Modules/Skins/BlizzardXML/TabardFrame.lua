local _, ns = ...
local B, C, L, DB = unpack(ns)

tinsert(C.XMLThemes, function()
	B.ReskinFrame(TabardFrame)
	B.StripTextures(TabardFrameCostFrame)
	B.ReskinButton(TabardFrameAcceptButton)
	B.ReskinButton(TabardFrameCancelButton)
	B.ReskinArrow(TabardCharacterModelRotateLeftButton, "left")
	B.ReskinArrow(TabardCharacterModelRotateRightButton, "right")

	B.StripTextures(TabardFrameMoneyBg)
	B.StripTextures(TabardFrameMoneyInset)

	TabardFrameCustomizationBorder:Hide()
	TabardCharacterModelRotateRightButton:ClearAllPoints()
	TabardCharacterModelRotateRightButton:SetPoint("TOPLEFT", TabardCharacterModelRotateLeftButton, "TOPRIGHT", 1, 0)

	for i = 1, 5 do
		B.StripTextures(_G["TabardFrameCustomization"..i])
		B.ReskinArrow(_G["TabardFrameCustomization"..i.."LeftButton"], "left")
		B.ReskinArrow(_G["TabardFrameCustomization"..i.."RightButton"], "right")
	end
end)