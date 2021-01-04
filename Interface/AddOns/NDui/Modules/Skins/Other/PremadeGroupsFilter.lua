local _, ns = ...
local B, C, L, DB = unpack(ns)
local Skins = B:GetModule("Skins")
local TT = B:GetModule("Tooltip")

local function Update_OnShowPoint(self, _, parent)
	if parent ~= LFGListFrame then
		self:ClearAllPoints()
		self:SetPoint("TOPLEFT", LFGListFrame, "TOPRIGHT", 3, 0)
		self:SetPoint("BOTTOMLEFT", LFGListFrame, "BOTTOMRIGHT", 3, 0)
	end
end

function Skins:PremadeGroupsFilter()
	if not IsAddOnLoaded("PremadeGroupsFilter") then return end

	local dialog = PremadeGroupsFilterDialog
	B.ReskinFrame(dialog)
	B.ReskinMinMax(dialog)

	B.StripTextures(dialog.Advanced)
	B.StripTextures(dialog.Expression)
	B.ReskinButton(dialog.ResetButton)
	B.ReskinButton(dialog.RefreshButton)
	B.ReskinDropDown(dialog.Difficulty.DropDown)
	B.CreateBDFrame(dialog.Expression)
	B.ReskinCheck(UsePFGButton)

	dialog.MoveableToggle:Hide()
	dialog.Defeated.Title:ClearAllPoints()
	dialog.Defeated.Title:SetPoint("LEFT", dialog.Defeated.Act, "RIGHT", 2, 0)
	dialog.Difficulty.DropDown:ClearAllPoints()
	dialog.Difficulty.DropDown:SetPoint("RIGHT", dialog.Difficulty, "RIGHT", 13, -3)

	dialog.MaximizeButton:ClearAllPoints()
	dialog.MaximizeButton:SetPoint("RIGHT", dialog.CloseButton, "LEFT", -2, 0)
	dialog.MinimizeButton:ClearAllPoints()
	dialog.MinimizeButton:SetPoint("RIGHT", dialog.CloseButton, "LEFT", -2, 0)

	local RefreshButton = LFGListFrame.SearchPanel.RefreshButton
	UsePFGButton:SetSize(32, 32)
	UsePFGButton:ClearAllPoints()
	UsePFGButton:SetPoint("RIGHT", RefreshButton, "LEFT", -55, 0)
	UsePFGButton.text:SetText(FILTER)
	UsePFGButton.text:SetWidth(UsePFGButton.text:GetStringWidth())

	local names = {
		"Dps",
		"Ilvl",
		"Tanks",
		"Heals",
		"Noilvl",
		"Members",
		"Defeated",
		"Difficulty",
	}
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

	hooksecurefunc(PremadeGroupsFilterDialog, "SetPoint", Update_OnShowPoint)

	local tipStyled
	hooksecurefunc(PremadeGroupsFilter.Debug, "PopupMenu_Initialize", function()
		if tipStyled then return end
		for i = 1, PremadeGroupsFilterDialog:GetNumChildren() do
			local child = select(i, PremadeGroupsFilterDialog:GetChildren())
			if child and child.Shadow then
				TT.ReskinTooltip(child)

				tipStyled = true
				break
			end
		end
	end)
end