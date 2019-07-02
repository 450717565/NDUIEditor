local F, C = unpack(select(2, ...))

C.themes["Blizzard_BattlefieldMap"] = function()
	local BorderFrame = BattlefieldMapFrame.BorderFrame
	local bg = F.ReskinFrame(BorderFrame)
	bg:SetPoint("TOPLEFT", -C.mult, C.mult*2)
	bg:SetPoint("BOTTOMRIGHT", -C.mult, C.mult*2)

	F.ReskinFrame(OpacityFrame)
	F.ReskinSlider(OpacityFrameSlider, true)
end