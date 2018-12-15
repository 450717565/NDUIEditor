local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	ColorPickerFrameHeader:SetAlpha(0)
	ColorPickerFrameHeader:ClearAllPoints()
	ColorPickerFrameHeader:SetPoint("TOP")
	F.CreateBD(ColorPickerFrame)
	F.CreateSD(ColorPickerFrame)
	F.Reskin(ColorPickerOkayButton)
	F.Reskin(ColorPickerCancelButton)
	F.ReskinSlider(OpacitySliderFrame, true)
end)