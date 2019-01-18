local F, C = unpack(select(2, ...))

C.themes["Blizzard_BattlefieldMap"] = function()
	local BorderFrame = BattlefieldMapFrame.BorderFrame
	F.StripTextures(BorderFrame, true)
	F.ReskinClose(BorderFrame.CloseButton)
	F.SetBD(BattlefieldMapFrame, -C.mult, C.mult, -C.mult, C.mult)

	F.ReskinFrame(OpacityFrame)
	F.ReskinSlider(OpacityFrameSlider, true)
end