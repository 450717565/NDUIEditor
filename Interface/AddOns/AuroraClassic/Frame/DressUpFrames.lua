local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	-- DressupFrame
	F.ReskinFrame(DressUpFrame)
	F.ReskinMinMax(MaximizeMinimizeFrame)

	MaximizeMinimizeFrame:ClearAllPoints()
	MaximizeMinimizeFrame:SetPoint("RIGHT", DressUpFrameCloseButton, "LEFT", 8, 0)

	local DropDown = DressUpFrameOutfitDropDown
	F.ReskinDropDown(DropDown)
	DropDown:SetHeight(32)

	local SaveButton = DropDown.SaveButton
	F.ReskinButton(SaveButton)
	SaveButton:ClearAllPoints()
	SaveButton:SetPoint("LEFT", DropDown, "RIGHT", -13, 2)

	local CancelButton = DressUpFrameCancelButton
	F.ReskinButton(CancelButton)
	CancelButton:SetSize(75, 22)
	CancelButton:ClearAllPoints()
	CancelButton:SetPoint("BOTTOMRIGHT", -14, 5)

	local ResetButton = DressUpFrameResetButton
	F.ReskinButton(ResetButton)
	ResetButton:SetSize(75, 22)
	ResetButton:ClearAllPoints()
	ResetButton:SetPoint("RIGHT", CancelButton, "LEFT", -2, 0)

	-- SideDressUp
	F.ReskinFrame(SideDressUpFrame)
	F.ReskinButton(SideDressUpFrame.ResetButton)

	SideDressUpFrame:HookScript("OnShow", function(self)
		SideDressUpFrame:ClearAllPoints()
		SideDressUpFrame:SetPoint("LEFT", self:GetParent(), "RIGHT", 3, 0)
	end)
end)
