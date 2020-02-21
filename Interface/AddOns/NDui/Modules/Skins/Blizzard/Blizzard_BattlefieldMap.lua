local B, C, L, DB = unpack(select(2, ...))

C.themes["Blizzard_BattlefieldMap"] = function()
	local BorderFrame = BattlefieldMapFrame.BorderFrame

	local bg = B.ReskinFrame(BorderFrame)
	bg:SetParent(BattlefieldMapFrame)
	bg:SetOutside(BattlefieldMapFrame.ScrollContainer)

	B.ReskinTab(BattlefieldMapTab)
	B.ReskinFrame(OpacityFrame)
	B.ReskinSlider(OpacityFrameSlider, true)
end