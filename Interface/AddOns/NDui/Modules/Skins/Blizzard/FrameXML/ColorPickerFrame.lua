local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	B.CreateBD(ColorPickerFrame)
	B.CreateSD(ColorPickerFrame)
	B.StripTextures(ColorPickerFrame.Header)

	B.ReskinSlider(OpacitySliderFrame, true)
	B.ReskinButton(ColorPickerOkayButton)
	B.ReskinButton(ColorPickerCancelButton)

	ColorPickerFrame.Border:Hide()
	ColorPickerFrame.Header:ClearAllPoints()
	ColorPickerFrame.Header:SetPoint("TOP", 0, 5)
	ColorPickerOkayButton:ClearAllPoints()
	ColorPickerOkayButton:SetPoint("BOTTOMRIGHT", ColorPickerFrame, "BOTTOM", -1, 5)
	ColorPickerCancelButton:ClearAllPoints()
	ColorPickerCancelButton:SetPoint("BOTTOMLEFT", ColorPickerFrame, "BOTTOM", 1, 5)
end)