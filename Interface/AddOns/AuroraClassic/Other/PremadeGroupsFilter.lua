local F, C = unpack(select(2, ...))

C.themes["PremadeGroupsFilter"] = function()
	local dialog = PremadeGroupsFilterDialog
	F.ReskinFrame(dialog)

	F.StripTextures(dialog.Advanced)
	F.StripTextures(dialog.Expression)
	F.ReskinButton(dialog.ResetButton)
	F.ReskinButton(dialog.RefreshButton)
	F.ReskinCheck(UsePFGButton)
	F.ReskinDropDown(dialog.Difficulty.DropDown)
	F.CreateBDFrame(dialog.Expression, 0)

	dialog.Defeated.Title:ClearAllPoints()
	dialog.Defeated.Title:SetPoint("LEFT", dialog.Defeated.Act, "RIGHT", 10, 0)
	dialog.Difficulty.DropDown:ClearAllPoints()
	dialog.Difficulty.DropDown:SetPoint("RIGHT", dialog.Difficulty, "RIGHT", 13, -3)

	local names = {"Difficulty", "Ilvl", "Noilvl", "Defeated", "Members", "Tanks", "Heals", "Dps"}
	for _, name in pairs(names) do
		local check = dialog[name].Act
		if check then
			check:ClearAllPoints()
			check:SetPoint("TOPLEFT", 5, -2)
			check:SetSize(26, 26)
			F.ReskinCheck(check)
		end

		local input = dialog[name].Min
		if input then
			F.ReskinInput(input)
			F.ReskinInput(dialog[name].Max)
		end
	end

	hooksecurefunc(PremadeGroupsFilterDialog, "SetPoint", function(self, _, parent)
		if parent ~= LFGListFrame then
			self:ClearAllPoints()
			self:SetPoint("TOPLEFT", LFGListFrame, "TOPRIGHT", 5, 0)
			self:SetPoint("BOTTOMLEFT", LFGListFrame, "BOTTOMRIGHT", 5, 0)
		end
	end)

	local styled
	hooksecurefunc(PremadeGroupsFilter.Debug, "PopupMenu_Initialize", function()
		if styled then return end
		for i = 1, 15 do
			local child = select(i, PremadeGroupsFilterDialog:GetChildren())
			if child and child.Shadow then
				F.ReskinTooltip(child)

				styled = true
				break
			end
		end
	end)
end