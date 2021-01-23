local _, ns = ...
local B, C, L, DB = unpack(ns)

tinsert(C.XMLThemes, function()
	B.CreateBG(ColorPickerFrame)

	B.ReskinSlider(OpacitySliderFrame, true)
	B.ReskinButton(ColorPickerOkayButton)
	B.ReskinButton(ColorPickerCancelButton)

	local Header = ColorPickerFrame.Header
	B.StripTextures(Header)
	Header:ClearAllPoints()
	Header:SetPoint("TOP", 0, 5)

	ColorPickerFrame.Border:Hide()
	ColorPickerOkayButton:ClearAllPoints()
	ColorPickerOkayButton:SetPoint("BOTTOMRIGHT", ColorPickerFrame, "BOTTOM", -1, 5)
	ColorPickerCancelButton:ClearAllPoints()
	ColorPickerCancelButton:SetPoint("BOTTOMLEFT", ColorPickerFrame, "BOTTOM", 1, 5)
end)