local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.CreateBD(ColorPickerFrame)
	F.StripTextures(ColorPickerFrame.Header)

	F.ReskinSlider(OpacitySliderFrame, true)
	F.ReskinButton(ColorPickerOkayButton)
	F.ReskinButton(ColorPickerCancelButton)

	ColorPickerFrame.Border:Hide()
	ColorPickerFrame.Header:ClearAllPoints()
	ColorPickerFrame.Header:SetPoint("TOP", 0, 5)
	ColorPickerOkayButton:ClearAllPoints()
	ColorPickerOkayButton:SetPoint("BOTTOMRIGHT", ColorPickerFrame, "BOTTOM", -1, 5)
	ColorPickerCancelButton:ClearAllPoints()
	ColorPickerCancelButton:SetPoint("BOTTOMLEFT", ColorPickerFrame, "BOTTOM", 1, 5)
end)