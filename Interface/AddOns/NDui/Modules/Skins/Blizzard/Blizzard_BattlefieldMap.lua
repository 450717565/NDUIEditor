local B, C, L, DB = unpack(select(2, ...))

C.themes["Blizzard_BattlefieldMap"] = function()
	local BorderFrame = BattlefieldMapFrame.BorderFrame
	local bg = B.ReskinFrame(BorderFrame)
	bg:SetPoint("TOPLEFT", -C.mult, 2+C.mult)
	bg:SetPoint("BOTTOMRIGHT", -(1+C.mult), 2+C.mult)

	B.ReskinFrame(OpacityFrame)
	B.ReskinSlider(OpacityFrameSlider, true)
end