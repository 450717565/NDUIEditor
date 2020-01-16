local F, C = unpack(select(2, ...))

C.themes["Blizzard_TrainerUI"] = function()
	F.ReskinFrame(ClassTrainerFrame)
	F.ReskinButton(ClassTrainerTrainButton)
	F.ReskinScroll(ClassTrainerScrollFrameScrollBar)
	F.ReskinDropDown(ClassTrainerFrameFilterDropDown)
	F.ReskinStatusBar(ClassTrainerStatusBar)

	ClassTrainerStatusBar:ClearAllPoints()
	ClassTrainerStatusBar:SetPoint("RIGHT", ClassTrainerFrameFilterDropDown, "LEFT", 0, 2)

	hooksecurefunc("ClassTrainerFrame_SetServiceButton", function(skillButton, skillIndex)
		local texture = select(3, GetTrainerServiceInfo(skillIndex))
		skillButton.name:SetWordWrap(false)
		skillButton.subText:SetWordWrap(false)

		if not skillButton.styled then
			F.StripTextures(skillButton)
			skillButton.icon:SetTexture(texture)

			local icbg = F.ReskinIcon(skillButton.icon)
			local bubg = F.CreateBDFrame(skillButton, 0)
			bubg:SetPoint("TOPLEFT", icbg, "TOPRIGHT", 2, 0)
			bubg:SetPoint("BOTTOMRIGHT", 0, 4)

			if skillButton == ClassTrainerFrame.skillStepButton then
				bubg:SetPoint("TOPLEFT", icbg, "TOPRIGHT", 2, 0)
				bubg:SetPoint("BOTTOMRIGHT", -18, 1.5)
			end

			F.ReskinTexture(skillButton, bubg, true)
			F.ReskinTexture(skillButton.selectedTex, bubg, true)

			skillButton.disabledBG:SetPoint("TOPLEFT", bubg, C.mult, -C.mult)
			skillButton.disabledBG:SetPoint("BOTTOMRIGHT", bubg, -C.mult, C.mult)

			skillButton.name:ClearAllPoints()
			skillButton.name:SetPoint("TOPLEFT", bubg, "TOPLEFT", 3, -5)

			skillButton.subText:ClearAllPoints()
			skillButton.subText:SetPoint("BOTTOMLEFT", bubg, "BOTTOMLEFT", 3, -5)

			skillButton.money:ClearAllPoints()
			skillButton.money:SetPoint("TOPRIGHT", bubg, "TOPRIGHT", 10, -5)

			skillButton.styled = true
		end
	end)
end