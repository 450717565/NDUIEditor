local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	B.StripTextures(ModelPreviewFrame)
	B.CreateBD(ModelPreviewFrame)
	B.CreateSD(ModelPreviewFrame)

	B.ReskinClose(ModelPreviewFrameCloseButton)
	B.ReskinButton(ModelPreviewFrame.CloseButton)
	B.StripTextures(ModelPreviewFrame.Display)
	B.CreateBDFrame(ModelPreviewFrame.Display, 0)

	local ModelScene = ModelPreviewFrame.Display.ModelScene
	B.ReskinArrow(ModelScene.RotateLeftButton, "left")
	B.ReskinArrow(ModelScene.RotateRightButton, "right")
	B.ReskinArrow(ModelScene.CarouselLeftButton, "left")
	B.ReskinArrow(ModelScene.CarouselRightButton, "right")
end)