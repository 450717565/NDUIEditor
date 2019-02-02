local F, C = unpack(select(2, ...))

C.themes["PremadeGroupsFilter"] = function()
	local dialog = PremadeGroupsFilterDialog
	F.StripTextures(dialog.Advanced)
	F.StripTextures(dialog.Expression)
	F.ReskinFrame(dialog)
	F.ReskinButton(dialog.ResetButton)
	F.ReskinButton(dialog.RefreshButton)
	F.ReskinDropDown(dialog.Difficulty.DropDown)
	F.ReskinCheck(UsePFGButton)
	F.CreateBDFrame(dialog.Expression, 0)

	dialog.Defeated.Title:ClearAllPoints()
	dialog.Defeated.Title:SetPoint("LEFT", dialog.Defeated.Act, "RIGHT", 10, 0)
	dialog.Difficulty.DropDown:ClearAllPoints()
	dialog.Difficulty.DropDown:SetPoint("RIGHT", dialog.Difficulty, "RIGHT", 13, -3)

	local buttons = {dialog.Defeated, dialog.Difficulty, dialog.Dps, dialog.Heals, dialog.Ilvl, dialog.Members, dialog.Noilvl, dialog.Tanks}
	for _, button in next, buttons do
		local btn = button["Act"]
		local p1, p2, p3, x, y = btn:GetPoint()
		btn:SetPoint(p1, p2, p3, 0, -3)
		btn:SetSize(24, 24)
		F.ReskinCheck(btn)
	end

	local inputs = {dialog.Defeated, dialog.Dps, dialog.Heals, dialog.Ilvl, dialog.Members, dialog.Tanks}
	for _, input in next, inputs do
		local min = input["Min"]
		local max = input["Max"]
		F.ReskinInput(min)
		F.ReskinInput(max)
	end
end