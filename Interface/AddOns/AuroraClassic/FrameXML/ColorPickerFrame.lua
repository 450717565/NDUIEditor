local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.ReskinFrame(ColorPickerFrame, true)
	F.ReskinSlider(OpacitySliderFrame, true)
	F.ReskinButton(ColorPickerOkayButton)
	F.ReskinButton(ColorPickerCancelButton)

	ColorPickerFrameHeader:SetAlpha(0)
	ColorPickerFrameHeader:ClearAllPoints()
	ColorPickerFrameHeader:SetPoint("TOP")
	ColorPickerOkayButton:ClearAllPoints()
	ColorPickerOkayButton:SetPoint("RIGHT", ColorPickerCancelButton, "LEFT", -1, 0)
end)