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

	step:SetHighlightTexture(C.media.backdrop)
	local hl = step:GetHighlightTexture()
	hl:SetVertexColor(r, g, b, .25)
	hl:SetPoint("TOPLEFT", bg, "TOPLEFT", 1, -1)
	hl:SetPoint("BOTTOMRIGHT", bg, "BOTTOMRIGHT", -1, 1)

	step.selectedTex:SetTexture(C.media.backdrop)
	step.selectedTex:SetVertexColor(r, g, b, .25)
	step.selectedTex:SetPoint("TOPLEFT", bg, "TOPLEFT", 1, -1)
	step.selectedTex:SetPoint("BOTTOMRIGHT", bg, "BOTTOMRIGHT", -1, 1)

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

				bu:SetHighlightTexture(C.media.backdrop)
				local hl = bu:GetHighlightTexture()
				hl:SetVertexColor(r, g, b, .25)
				hl:SetPoint("TOPLEFT", bg, "TOPLEFT", 1, -1)
				hl:SetPoint("BOTTOMRIGHT", bg, "BOTTOMRIGHT", -1, 1)

				bu.selectedTex:SetTexture(C.media.backdrop)
				bu.selectedTex:SetVertexColor(r, g, b, .25)
				bu.selectedTex:SetPoint("TOPLEFT", bg, "TOPLEFT", 1, -1)
				bu.selectedTex:SetPoint("BOTTOMRIGHT", bg, "BOTTOMRIGHT", -1, 1)

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