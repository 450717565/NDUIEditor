local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	-- Dressup Frame
	F.StripTextures(DressUpFrame, true)
	F.StripTextures(MaximizeMinimizeFrame, true)
	F.SetBDFrame(DressUpFrame, 5, 5, -5, 0)

	F.ReskinButton(DressUpFrameOutfitDropDown.SaveButton)
	F.ReskinButton(DressUpFrameCancelButton)
	F.ReskinButton(DressUpFrameResetButton)
	F.ReskinDropDown(DressUpFrameOutfitDropDown)
	F.ReskinClose(DressUpFrameCloseButton, "TOPRIGHT", DressUpFrame, "TOPRIGHT", -10, 0)

	DressUpFrameOutfitDropDown:SetHeight(32)
	DressUpFrameOutfitDropDown.SaveButton:SetPoint("LEFT", DressUpFrameOutfitDropDown, "RIGHT", -13, 2)
	DressUpFrameCancelButton:SetSize(75, 22)
	DressUpFrameCancelButton:SetPoint("BOTTOMRIGHT", -9, 4)
	DressUpFrameResetButton:SetSize(75, 22)
	DressUpFrameResetButton:SetPoint("RIGHT", DressUpFrameCancelButton, "LEFT", -2, 0)

	F.ReskinMinMax(MaximizeMinimizeFrame)

	-- SideDressUp
	F.StripTextures(SideDressUpFrame, true)
	F.ReskinFrame(SideDressUpModel)
	F.ReskinButton(SideDressUpModelResetButton)

	SideDressUpModel:HookScript("OnShow", function(self)
		self:ClearAllPoints()
		self:SetPoint("LEFT", self:GetParent():GetParent(), "RIGHT", 4, 0)
	end)
end)
