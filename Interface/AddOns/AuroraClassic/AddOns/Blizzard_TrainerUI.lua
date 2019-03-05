local F, C = unpack(select(2, ...))

C.themes["Blizzard_TrainerUI"] = function()
	F.ReskinFrame(ClassTrainerFrame)
	F.ReskinButton(ClassTrainerTrainButton)
	F.ReskinScroll(ClassTrainerScrollFrameScrollBar)
	F.ReskinDropDown(ClassTrainerFrameFilterDropDown)

	F.ReskinStatusBar(ClassTrainerStatusBar)
	ClassTrainerStatusBar:ClearAllPoints()
	ClassTrainerStatusBar:SetPoint("RIGHT", ClassTrainerFrameFilterDropDown, "LEFT", 0, 2)
	ClassTrainerStatusBarSkillRank:ClearAllPoints()
	ClassTrainerStatusBarSkillRank:SetPoint("CENTER")

	local function reskinDBG(bu, bg)
		bu.disabledBG:SetPoint("TOPLEFT", bg, C.mult, -C.mult)
		bu.disabledBG:SetPoint("BOTTOMRIGHT", bg, -C.mult, C.mult)
	end

	local step = ClassTrainerFrameSkillStepButton
	F.StripTextures(step)

	local stepic = F.ReskinIcon(ClassTrainerFrameSkillStepButtonIcon)

	local stepbg = F.CreateBDFrame(step, 0)
	stepbg:SetPoint("TOPLEFT", stepic, "TOPRIGHT", 2, 0)
	stepbg:SetPoint("BOTTOMRIGHT", -18, 0)

	F.ReskinTexture(step, stepbg, true)
	F.ReskinTexture(step.selectedTex, stepbg, true)

	reskinDBG(step, stepbg)

	step.name:ClearAllPoints()
	step.name:SetPoint("TOPLEFT", stepic, "TOPRIGHT", 5, -5)
	step.subText:ClearAllPoints()
	step.subText:SetPoint("BOTTOMLEFT", stepic, "BOTTOMRIGHT", 5, -5)

	hooksecurefunc("ClassTrainerFrame_Update", function()
		for _, bu in pairs(ClassTrainerFrame.scrollFrame.buttons) do
			if not bu.styled then
				bu:SetNormalTexture("")

				local ic = F.ReskinIcon(bu.icon)

				local bg = F.CreateBDFrame(bu, 0)
				bg:SetPoint("TOPLEFT", ic, "TOPRIGHT", 2, 0)
				bg:SetPoint("BOTTOMRIGHT", 0, 4)

				F.ReskinTexture(bu, bg, true)
				F.ReskinTexture(bu.selectedTex, bg, true)

				reskinDBG(bu, bg)

				bu.name:SetWordWrap(false)
				bu.name:ClearAllPoints()
				bu.name:SetPoint("TOPLEFT", bu.icon, "TOPRIGHT", 5, -5)

				bu.subText:SetWordWrap(false)
				bu.subText:ClearAllPoints()
				bu.subText:SetPoint("BOTTOMLEFT", bu.icon, "BOTTOMRIGHT", 5, -5)

				bu.money:ClearAllPoints()
				bu.money:SetPoint("TOPRIGHT", bu, "TOPRIGHT", 10, -10)

				bu.styled = true
			end
		end
	end)
end