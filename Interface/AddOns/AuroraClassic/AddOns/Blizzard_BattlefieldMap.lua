local F, C = unpack(select(2, ...))

C.themes["Blizzard_BattlefieldMap"] = function()
	local BorderFrame = BattlefieldMapFrame.BorderFrame

	F.ReskinPortraitFrame(BorderFrame)
	F.SetBD(BattlefieldMapFrame, -C.mult, C.mult, -C.mult, C.mult)

	F.ReskinPortraitFrame(OpacityFrame, true)
	F.ReskinSlider(OpacityFrameSlider, true)
end