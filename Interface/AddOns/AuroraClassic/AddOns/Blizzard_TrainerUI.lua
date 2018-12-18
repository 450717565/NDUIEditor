local F, C = unpack(select(2, ...))

C.themes["Blizzard_TrainerUI"] = function()
	local r, g, b = C.r, C.g, C.b

	F.ReskinPortraitFrame(ClassTrainerFrame, true)
	F.StripTextures(ClassTrainerFrameBottomInset, true)
	F.Reskin(ClassTrainerTrainButton)
	F.ReskinScroll(ClassTrainerScrollFrameScrollBar)
	F.ReskinDropDown(ClassTrainerFrameFilterDropDown)

	F.ReskinStatusBar(ClassTrainerStatusBar, true, true)
	ClassTrainerStatusBar:ClearAllPoints()
	ClassTrainerStatusBar:SetPoint("RIGHT", ClassTrainerFrameFilterDropDown, "LEFT", 0, 2)
	ClassTrainerStatusBarSkillRank:ClearAllPoints()
	ClassTrainerStatusBarSkillRank:SetPoint("CENTER")

	local step = ClassTrainerFrameSkillStepButton
	F.StripTextures(step)

	local bg = F.CreateBDFrame(step, .25)
	bg:SetPoint("TOPLEFT", ClassTrainerFrameSkillStepButtonIcon, "TOPRIGHT", 2, 2)
	bg:SetPoint("BOTTOMRIGHT")

	F.ReskinTexture(step, "sl", true, bg)
	F.ReskinTexture(step, "hl", true, bg)

	step.disabledBG:SetPoint("TOPLEFT", bg, C.mult, -C.mult)
	step.disabledBG:SetPoint("BOTTOMRIGHT", bg, -C.mult, C.mult)

	step.name:ClearAllPoints()
	step.name:SetPoint("TOPLEFT", ClassTrainerFrameSkillStepButtonIcon, "TOPRIGHT", 5, -5)
	step.subText:ClearAllPoints()
	step.subText:SetPoint("BOTTOMLEFT", ClassTrainerFrameSkillStepButtonIcon, "BOTTOMRIGHT", 5, -5)

	local stepic = ClassTrainerFrameSkillStepButtonIcon
	stepic:SetTexCoord(.08, .92, .08, .92)
	F.CreateBDFrame(stepic, .25)

	hooksecurefunc("ClassTrainerFrame_Update", function()
		for _, bu in next, ClassTrainerFrame.scrollFrame.buttons do
			if not bu.styled then
				bu:SetNormalTexture("")
				bu:SetHighlightTexture("")
				bu.disabledBG:Hide()
				bu.disabledBG.Show = F.dummy

				local bg = F.CreateBDFrame(bu, .25)
				bg:SetPoint("TOPLEFT", bu.icon, "TOPRIGHT", 2, 2)
				bg:SetPoint("BOTTOMRIGHT", 0, 3)

				F.ReskinTexture(bu, "sl", true, bg)
				F.ReskinTexture(bu, "hl", true, bg)

				bu.name:SetWordWrap(false)
				bu.name:ClearAllPoints()
				bu.name:SetPoint("TOPLEFT", bu.icon, "TOPRIGHT", 5, -5)

				bu.subText:SetWordWrap(false)
				bu.subText:ClearAllPoints()
				bu.subText:SetPoint("BOTTOMLEFT", bu.icon, "BOTTOMRIGHT", 5, -5)

				bu.money:ClearAllPoints()
				bu.money:SetPoint("TOPRIGHT", bu, "TOPRIGHT", 10, -10)

				bu.icon:SetTexCoord(.08, .92, .08, .92)
				F.CreateBDFrame(bu.icon, .25)

				bu.styled = true
			end
		end
	end)
end