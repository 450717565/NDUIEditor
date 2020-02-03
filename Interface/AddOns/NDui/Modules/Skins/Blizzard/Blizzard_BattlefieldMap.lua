local B, C, L, DB = unpack(select(2, ...))

C.themes["Blizzard_BattlefieldMap"] = function()
	local BorderFrame = BattlefieldMapFrame.BorderFrame
	local bg = B.ReskinFrame(BorderFrame)
	bg:SetPoint("TOPLEFT", -C.mult, C.mult*2)
	bg:SetPoint("BOTTOMRIGHT", -C.mult, C.mult*2)

	B.ReskinFrame(OpacityFrame)
	B.ReskinSlider(OpacityFrameSlider, true)
end