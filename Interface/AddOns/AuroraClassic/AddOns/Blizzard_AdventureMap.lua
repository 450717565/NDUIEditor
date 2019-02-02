local F, C = unpack(select(2, ...))

C.themes["Blizzard_AdventureMap"] = function()
	local ChoiceDialog = AdventureMapQuestChoiceDialog

	F.ReskinFrame(ChoiceDialog)
	F.ReskinButton(ChoiceDialog.AcceptButton)
	F.ReskinButton(ChoiceDialog.DeclineButton)
	F.ReskinScroll(ChoiceDialog.Details.ScrollBar)

	ChoiceDialog:HookScript("OnShow", function(self)
		if not self.styled then
			for i = 6, 7 do
				local bu = select(i, ChoiceDialog:GetChildren())
				if bu then
					bu.ItemNameBG:Hide()

					local icbg = F.ReskinIcon(bu.Icon)
					local bubg = F.CreateBDFrame(bu.ItemNameBG, 0)
					bubg:SetPoint("TOPLEFT", icbg, "TOPRIGHT", 2, 0)
					bubg:SetPoint("BOTTOMRIGHT", -5, -1)
				end
			end
			ChoiceDialog.Details.Child.TitleHeader:SetTextColor(1, .8, 0)
			ChoiceDialog.Details.Child.ObjectivesHeader:SetTextColor(1, .8, 0)

			self.styled = true
		end
	end)
end