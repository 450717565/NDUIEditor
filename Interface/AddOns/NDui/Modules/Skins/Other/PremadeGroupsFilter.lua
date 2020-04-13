local B, C, L, DB = unpack(select(2, ...))
local S = B:GetModule("Skins")

function S:PremadeGroupsFilter()
	if not IsAddOnLoaded("PremadeGroupsFilter") then return end

	local dialog = PremadeGroupsFilterDialog
	B.ReskinFrame(dialog)

	B.StripTextures(dialog.Advanced)
	B.StripTextures(dialog.Expression)
	B.ReskinButton(dialog.ResetButton)
	B.ReskinButton(dialog.RefreshButton)
	B.ReskinCheck(UsePFGButton)
	B.ReskinDropDown(dialog.Difficulty.DropDown)
	B.CreateBDFrame(dialog.Expression, 0)

	dialog.MoveableToggle:Hide()
	dialog.Defeated.Title:ClearAllPoints()
	dialog.Defeated.Title:SetPoint("LEFT", dialog.Defeated.Act, "RIGHT", 2, 0)
	dialog.Difficulty.DropDown:ClearAllPoints()
	dialog.Difficulty.DropDown:SetPoint("RIGHT", dialog.Difficulty, "RIGHT", 13, -3)

	local RefreshButton = LFGListFrame.SearchPanel.RefreshButton
	UsePFGButton:SetSize(32, 32)
	UsePFGButton:ClearAllPoints()
	UsePFGButton:SetPoint("RIGHT", RefreshButton, "LEFT", -55, 0)
	UsePFGButton.text:SetText(FILTER)
	UsePFGButton.text:SetWidth(UsePFGButton.text:GetStringWidth())

	local names = {"Difficulty", "Ilvl", "Noilvl", "Defeated", "Members", "Tanks", "Heals", "Dps"}
	for _, name in pairs(names) do
		local check = dialog[name].Act
		if check then
			check:ClearAllPoints()
			check:SetPoint("TOPLEFT", 5, -2)
			check:SetSize(26, 26)
			B.ReskinCheck(check)
		end

		local input = dialog[name].Min
		if input then
			B.ReskinInput(input)
			B.ReskinInput(dialog[name].Max)
		end
	end

	hooksecurefunc(PremadeGroupsFilterDialog, "SetPoint", function(self, _, parent)
		if parent ~= LFGListFrame then
			self:ClearAllPoints()
			self:SetPoint("TOPLEFT", LFGListFrame, "TOPRIGHT", 3, 0)
			self:SetPoint("BOTTOMLEFT", LFGListFrame, "BOTTOMRIGHT", 3, 0)
		end
	end)
end