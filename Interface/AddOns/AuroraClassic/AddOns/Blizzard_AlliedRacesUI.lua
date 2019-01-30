local F, C = unpack(select(2, ...))

C.themes["Blizzard_AlliedRacesUI"] = function()
	F.ReskinFrame(AlliedRacesFrame)
	F.StripTextures(AlliedRacesFrame.ModelFrame, true)

	local RaceInfoFrame = AlliedRacesFrame.RaceInfoFrame
	RaceInfoFrame.AlliedRacesRaceName:SetTextColor(1, .8, 0)

	local ScrollFrame = RaceInfoFrame.ScrollFrame
	F.ReskinScroll(ScrollFrame.ScrollBar)
	ScrollFrame.Child.RaceDescriptionText:SetTextColor(1, 1, 1)
	ScrollFrame.Child.RacialTraitsLabel:SetTextColor(1, .8, 0)

	AlliedRacesFrame:HookScript("OnShow", function(self)
		local Child = ScrollFrame.Child
		F.StripTextures(Child.ObjectivesFrame)

		for i = 1, Child:GetNumChildren() do
			local bu = select(i, Child:GetChildren())

			if not bu.styled then
				if bu.Icon then
					F.ReskinIcon(bu.Icon)
					select(3, bu:GetRegions()):Hide()
				end

				if bu.Text then
					bu.Text:SetTextColor(1, 1, 1)
				end

				bu.styled = true
			end
		end
	end)
end