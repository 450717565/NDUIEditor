local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.ReskinFrame(ModelPreviewFrame)
	F.ReskinButton(ModelPreviewFrame.CloseButton)
	F.StripTextures(ModelPreviewFrame.Display)

	local ModelScene = ModelPreviewFrame.Display.ModelScene
	F.ReskinArrow(ModelScene.RotateLeftButton, "left")
	F.ReskinArrow(ModelScene.RotateRightButton, "right")
	F.ReskinArrow(ModelScene.CarouselLeftButton, "left")
	F.ReskinArrow(ModelScene.CarouselRightButton, "right")

	local bg = F.CreateBDFrame(ModelScene, 0)
	bg:SetPoint("TOPLEFT", -1, 0)
	bg:SetPoint("BOTTOMRIGHT", 2, -2)
end)