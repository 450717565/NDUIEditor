local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	-- Dressup Frame
	F.StripTextures(DressUpFrame, true)
	F.StripTextures(DressUpFrameInset, true)
	F.StripTextures(MaximizeMinimizeFrame, true)
	F.SetBD(DressUpFrame, 5, 5, -5, 0)

	F.Reskin(DressUpFrameOutfitDropDown.SaveButton)
	F.Reskin(DressUpFrameCancelButton)
	F.Reskin(DressUpFrameResetButton)
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
	F.StripTextures(SideDressUpModelCloseButton, true)
	F.CreateBD(SideDressUpModel)
	F.CreateSD(SideDressUpModel)
	F.Reskin(SideDressUpModelResetButton)
	F.ReskinClose(SideDressUpModelCloseButton)

	SideDressUpModel:HookScript("OnShow", function(self)
		self:ClearAllPoints()
		self:SetPoint("LEFT", self:GetParent():GetParent(), "RIGHT", 4, 0)
	end)
end)
