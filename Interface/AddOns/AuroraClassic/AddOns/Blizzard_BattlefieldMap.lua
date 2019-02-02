local F, C = unpack(select(2, ...))

C.themes["Blizzard_BattlefieldMap"] = function()
	local BorderFrame = BattlefieldMapFrame.BorderFrame
	F.StripTextures(BorderFrame)
	F.ReskinClose(BorderFrame.CloseButton)
	F.SetBDFrame(BattlefieldMapFrame, -C.mult, C.mult*2, -C.mult, C.mult*2)

	F.ReskinFrame(OpacityFrame)
	F.ReskinSlider(OpacityFrameSlider, true)
end