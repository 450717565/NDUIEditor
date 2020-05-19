local B, C, L, DB = unpack(select(2, ...))

C.themes["Blizzard_AdventureMap"] = function()
	local ChoiceDialog = AdventureMapQuestChoiceDialog

	B.ReskinFrame(ChoiceDialog)
	B.ReskinButton(ChoiceDialog.AcceptButton)
	B.ReskinButton(ChoiceDialog.DeclineButton)
	B.ReskinScroll(ChoiceDialog.Details.ScrollBar)

	ChoiceDialog:HookScript("OnShow", function(self)
		if not self.styled then
			for i = 6, 7 do
				local bu = select(i, self:GetChildren())
				if bu then
					bu.ItemNameBG:Hide()

					local icbg = B.ReskinIcon(bu.Icon)
					B.CreateBGFrame(bu.ItemNameBG, 2, 0, -5, 0, icbg)
				end
			end

			local Child = self.Details.Child
			Child.TitleHeader:SetTextColor(1, .8, 0)
			Child.ObjectivesHeader:SetTextColor(1, .8, 0)

			self.styled = true
		end
	end)
end