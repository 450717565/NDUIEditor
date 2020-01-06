local F, C = unpack(select(2, ...))

C.themes["Blizzard_BattlefieldMap"] = function()
	local BorderFrame = BattlefieldMapFrame.BorderFrame
	local bg = F.ReskinFrame(BorderFrame)
	bg:SetPoint("TOPLEFT", -C.mult, C.pixel)
	bg:SetPoint("BOTTOMRIGHT", -C.mult, C.pixel)

	F.ReskinFrame(OpacityFrame)
	F.ReskinSlider(OpacityFrameSlider, true)
end