local F, C = unpack(select(2, ...))

C.themes["Blizzard_AdventureMap"] = function()
	local dialog = AdventureMapQuestChoiceDialog

	F.ReskinFrame(dialog)
	F.ReskinButton(dialog.AcceptButton)
	F.ReskinButton(dialog.DeclineButton)
	F.ReskinScroll(dialog.Details.ScrollBar)

	dialog:HookScript("OnShow", function(self)
		if self.styled then return end

		for i = 6, 7 do
			local bu = select(i, dialog:GetChildren())
			if bu then
				local bg = F.ReskinIcon(bu.Icon)
				bg:SetPoint("BOTTOMRIGHT")
				bu.ItemNameBG:Hide()
			end
		end
		dialog.Details.Child.TitleHeader:SetTextColor(1, 1, 1)
		dialog.Details.Child.ObjectivesHeader:SetTextColor(1, 1, 1)

		self.styled = true
	end)
end