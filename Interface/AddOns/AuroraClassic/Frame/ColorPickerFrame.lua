local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.CreateBD(ColorPickerFrame)

	if not C.isNewPatch then
		ColorPickerFrameHeader:SetAlpha(0)
	end

	F.ReskinSlider(OpacitySliderFrame, true)
	F.ReskinButton(ColorPickerOkayButton)
	F.ReskinButton(ColorPickerCancelButton)
	F.ReskinHeader(ColorPickerFrame)

	ColorPickerFrame.Border:Hide()
	ColorPickerOkayButton:ClearAllPoints()
	ColorPickerOkayButton:SetPoint("BOTTOMRIGHT", ColorPickerFrame, "BOTTOM", -1, 5)
	ColorPickerCancelButton:ClearAllPoints()
	ColorPickerCancelButton:SetPoint("BOTTOMLEFT", ColorPickerFrame, "BOTTOM", 1, 5)
end)