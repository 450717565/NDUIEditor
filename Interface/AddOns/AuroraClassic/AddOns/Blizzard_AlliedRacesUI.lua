local F, C = unpack(select(2, ...))

C.themes["Blizzard_AlliedRacesUI"] = function()
	F.StripTextures(AlliedRacesFrame, true)
	F.StripTextures(AlliedRacesFrame.ModelFrame, true)
	F.CreateBD(AlliedRacesFrame)
	F.CreateSD(AlliedRacesFrame)
	F.ReskinClose(AlliedRacesFrameCloseButton)
	F.ReskinScroll(AlliedRacesFrame.RaceInfoFrame.ScrollFrame.ScrollBar)
	AlliedRacesFrame.RaceInfoFrame.AlliedRacesRaceName:SetTextColor(1, .8, 0)

	AlliedRacesFrame:HookScript("OnShow", function(self)
		local parent = self.RaceInfoFrame.ScrollFrame.Child
		F.StripTextures(parent.ObjectivesFrame.HeaderButton, true)

		for i = 1, parent:GetNumChildren() do
			local bu = select(i, parent:GetChildren())

			if bu.Icon and not bu.styled then
				bu.Icon:SetTexCoord(.08, .92, .08, .92)
				select(3, bu:GetRegions()):Hide()
				F.CreateBDFrame(bu.Icon)

				bu.styled = true
			end

			if bu.Bullet and not bu.styled then
				bu.Text:SetTextColor(1, .8, 0)

				bu.styled = true
			end
		end
	end)
end