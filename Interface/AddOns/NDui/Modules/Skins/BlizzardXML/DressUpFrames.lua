local _, ns = ...
local B, C, L, DB = unpack(ns)

local cr, cg, cb = DB.cr, DB.cg, DB.cb

local function Update_FrameAnchor(self)
	self:ClearAllPoints()
	self:SetPoint("LEFT", self:GetParent(), "RIGHT", 3, 0)
end

tinsert(C.XMLThemes, function()
	-- DressupFrame
	B.ReskinFrame(DressUpFrame)

	local mizeFrame = DressUpFrame.MaximizeMinimizeFrame
	B.ReskinMinMax(mizeFrame)
	mizeFrame:ClearAllPoints()
	mizeFrame:SetPoint("RIGHT", DressUpFrameCloseButton, "LEFT", 8, 0)

	local DropDown = DressUpFrameOutfitDropDown
	B.ReskinDropDown(DropDown)
	DropDown:SetHeight(32)

	local SaveButton = DropDown.SaveButton
	B.ReskinButton(SaveButton)
	SaveButton:ClearAllPoints()
	SaveButton:SetPoint("LEFT", DropDown, "RIGHT", -13, 2)

	local CancelButton = DressUpFrameCancelButton
	B.ReskinButton(CancelButton)
	CancelButton:SetSize(75, 22)
	CancelButton:ClearAllPoints()
	CancelButton:SetPoint("BOTTOMRIGHT", -14, 5)

	local ResetButton = DressUpFrameResetButton
	B.ReskinButton(ResetButton)
	ResetButton:SetSize(75, 22)
	ResetButton:ClearAllPoints()
	ResetButton:SetPoint("RIGHT", CancelButton, "LEFT", -2, 0)

	-- SideDressUp
	B.ReskinFrame(SideDressUpFrame)
	B.ReskinButton(SideDressUpFrame.ResetButton)

	SideDressUpFrame:HookScript("OnShow", Update_FrameAnchor)

	-- TransmogAndMountDressupFrame
	B.ReskinCheck(TransmogAndMountDressupFrame.ShowMountCheckButton)
end)

-- WardrobeOutfitFrame
local function Reskin_WardrobeOutfitFrame(self)
	for i = 1, C_TransmogCollection.GetNumMaxOutfits() do
		local button = self.Buttons[i]
		if button and button:IsShown() then
			if not button.styled then
				button.Selection:SetColorTexture(cr, cg, cb, .25)
				button.Highlight:SetColorTexture(cr, cg, cb, .25)

				B.ReskinIcon(button.Icon)

				button.styled = true
			end
		end
	end
end

tinsert(C.XMLThemes, function()
	B.ReskinFrame(WardrobeOutfitFrame)
	B.ReskinFrame(WardrobeOutfitEditFrame)

	B.ReskinButton(WardrobeOutfitEditFrame.AcceptButton)
	B.ReskinButton(WardrobeOutfitEditFrame.CancelButton)
	B.ReskinButton(WardrobeOutfitEditFrame.DeleteButton)
	B.ReskinInput(WardrobeOutfitEditFrame.EditBox)

	hooksecurefunc(WardrobeOutfitFrame, "Update", Reskin_WardrobeOutfitFrame)
end)
