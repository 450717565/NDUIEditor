local F, C = unpack(select(2, ...))

C.themes["Blizzard_AlliedRacesUI"] = function()
	F.ReskinPortraitFrame(AlliedRacesFrame, true)
	F.StripTextures(AlliedRacesFrame.ModelFrame, true)
	F.ReskinScroll(AlliedRacesFrame.RaceInfoFrame.ScrollFrame.ScrollBar)
	AlliedRacesFrame.RaceInfoFrame.AlliedRacesRaceName:SetTextColor(1, .8, 0)

	AlliedRacesFrame:HookScript("OnShow", function(self)
		local parent = self.RaceInfoFrame.ScrollFrame.Child
		parent.RaceDescriptionText:SetTextColor(1, .8, 0)
		parent.RacialTraitsLabel:SetTextColor(1, .8, 0)

		F.StripTextures(parent.ObjectivesFrame, true)

		for i = 1, parent:GetNumChildren() do
			local bu = select(i, parent:GetChildren())

			if not bu.styled then
				if bu.Icon then
					F.ReskinIcon(bu.Icon, true)
					select(3, bu:GetRegions()):Hide()
				end

				if bu.Text then
					bu.Text:SetTextColor(1, .8, 0)
				end

				bu.styled = true
			end
		end
	end)
end