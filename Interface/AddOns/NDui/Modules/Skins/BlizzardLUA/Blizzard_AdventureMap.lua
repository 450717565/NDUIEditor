local _, ns = ...
local B, C, L, DB = unpack(ns)

local function Reskin_ChoiceDialog(self)
	if not self.styled then
		for i = 6, 7 do
			local button = select(i, self:GetChildren())
			if button then
				button.ItemNameBG:Hide()

				local icbg = B.ReskinIcon(button.Icon)
				B.CreateBGFrame(button, 2, 0, -5, 0, icbg)
			end
		end

		local Child = self.Details.Child
		B.ReskinText(Child.TitleHeader, 1, .8, 0)
		B.ReskinText(Child.ObjectivesHeader, 1, .8, 0)

		self.styled = true
	end
end

C.LUAThemes["Blizzard_AdventureMap"] = function()
	local ChoiceDialog = AdventureMapQuestChoiceDialog

	B.ReskinFrame(ChoiceDialog)
	B.ReskinButton(ChoiceDialog.AcceptButton)
	B.ReskinButton(ChoiceDialog.DeclineButton)
	B.ReskinScroll(ChoiceDialog.Details.ScrollBar)

	ChoiceDialog:HookScript("OnShow", Reskin_ChoiceDialog)
end