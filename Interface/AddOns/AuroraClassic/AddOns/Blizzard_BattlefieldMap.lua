local F, C = unpack(select(2, ...))

C.themes["Blizzard_BattlefieldMap"] = function()
	local BorderFrame = BattlefieldMapFrame.BorderFrame

	F.StripTextures(BorderFrame, true)
	F.SetBD(BattlefieldMapFrame, -1, 1, -1, 2)
	F.ReskinClose(BorderFrame.CloseButton)

	F.StripTextures(OpacityFrame, true)
	F.SetBD(OpacityFrame)
	F.ReskinSlider(OpacityFrameSlider, true)
end