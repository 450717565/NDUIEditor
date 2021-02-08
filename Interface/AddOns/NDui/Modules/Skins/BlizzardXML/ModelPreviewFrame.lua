local _, ns = ...
local B, C, L, DB = unpack(ns)

tinsert(C.XMLThemes, function()
	B.StripTextures(ModelPreviewFrame)
	B.CreateBG(ModelPreviewFrame)

	B.ReskinClose(ModelPreviewFrameCloseButton)
	B.ReskinButton(ModelPreviewFrame.CloseButton)
	B.StripTextures(ModelPreviewFrame.Display)

	local ModelScene = ModelPreviewFrame.Display.ModelScene
	B.CreateBDFrame(ModelScene, 0, -C.mult)
	B.ReskinArrow(ModelScene.RotateLeftButton, "left")
	B.ReskinArrow(ModelScene.RotateRightButton, "right")
	B.ReskinArrow(ModelScene.CarouselLeftButton, "left")
	B.ReskinArrow(ModelScene.CarouselRightButton, "right")
end)