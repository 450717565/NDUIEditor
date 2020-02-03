local B, C, L, DB = unpack(select(2, ...))

C.themes["Blizzard_AlliedRacesUI"] = function()
	B.ReskinFrame(AlliedRacesFrame)
	B.StripTextures(AlliedRacesFrame.ModelFrame, true)

	local RaceInfoFrame = AlliedRacesFrame.RaceInfoFrame
	RaceInfoFrame.AlliedRacesRaceName:SetTextColor(1, .8, 0)

	local ScrollFrame = RaceInfoFrame.ScrollFrame
	B.ReskinScroll(ScrollFrame.ScrollBar)
	ScrollFrame.Child.RaceDescriptionText:SetTextColor(1, 1, 1)
	ScrollFrame.Child.RacialTraitsLabel:SetTextColor(1, .8, 0)

	AlliedRacesFrame:HookScript("OnShow", function()
		local Child = ScrollFrame.Child
		B.StripTextures(Child.ObjectivesFrame)

		for i = 1, Child:GetNumChildren() do
			local bu = select(i, Child:GetChildren())

			if not bu.styled then
				if bu.Icon then
					B.ReskinIcon(bu.Icon)
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