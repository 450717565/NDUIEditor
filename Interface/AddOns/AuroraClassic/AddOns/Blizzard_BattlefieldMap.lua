local F, C = unpack(select(2, ...))

C.themes["Blizzard_BattlefieldMap"] = function()
	local BorderFrame = BattlefieldMapFrame.BorderFrame

	F.ReskinPortraitFrame(BorderFrame)
	F.SetBD(BattlefieldMapFrame, -1, 1, -1, 2)

	F.ReskinPortraitFrame(OpacityFrame, true)
	F.ReskinSlider(OpacityFrameSlider, true)
end