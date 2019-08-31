local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.CreateBD(ColorPickerFrame)
	F.CreateSD(ColorPickerFrame)

	F.ReskinSlider(OpacitySliderFrame, true)
	F.ReskinButton(ColorPickerOkayButton)
	F.ReskinButton(ColorPickerCancelButton)

	ColorPickerFrame.Border:Hide()
	ColorPickerFrameHeader:SetAlpha(0)

	ColorPickerFrameHeader:ClearAllPoints()
	ColorPickerFrameHeader:SetPoint("TOP", ColorPickerFrame, 0, 10)
	ColorPickerOkayButton:ClearAllPoints()
	ColorPickerOkayButton:SetPoint("BOTTOMRIGHT", ColorPickerFrame, "BOTTOM", -1, 5)
	ColorPickerCancelButton:ClearAllPoints()
	ColorPickerCancelButton:SetPoint("BOTTOMLEFT", ColorPickerFrame, "BOTTOM", 1, 5)
end)