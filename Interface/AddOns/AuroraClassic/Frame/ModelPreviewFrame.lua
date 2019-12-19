local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.StripTextures(ModelPreviewFrame)
	F.CreateBD(ModelPreviewFrame)
	F.CreateSD(ModelPreviewFrame)

	F.ReskinClose(ModelPreviewFrameCloseButton)
	F.ReskinButton(ModelPreviewFrame.CloseButton)
	F.StripTextures(ModelPreviewFrame.Display)
	F.CreateBDFrame(ModelPreviewFrame.Display, 0)

	local ModelScene = ModelPreviewFrame.Display.ModelScene
	F.ReskinArrow(ModelScene.RotateLeftButton, "left")
	F.ReskinArrow(ModelScene.RotateRightButton, "right")
	F.ReskinArrow(ModelScene.CarouselLeftButton, "left")
	F.ReskinArrow(ModelScene.CarouselRightButton, "right")
end)