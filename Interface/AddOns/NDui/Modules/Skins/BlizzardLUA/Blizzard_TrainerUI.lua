local _, ns = ...
local B, C, L, DB = unpack(ns)

local function Reskin_SetServiceButton(skillButton, skillIndex)
	skillButton.name:SetWordWrap(false)
	skillButton.subText:SetWordWrap(false)

	if not skillButton.styled then
		B.StripTextures(skillButton)

		local icbg = B.ReskinIcon(skillButton.icon)
		local bubg = B.CreateBGFrame(skillButton, C.margin, 0, 0, 0, icbg)

		if skillButton == ClassTrainerFrame.skillStepButton then
			bubg:SetPoint("RIGHT", 2+C.mult, 0)
		end

		B.ReskinHLTex(skillButton, bubg, true)
		B.ReskinHLTex(skillButton.selectedTex, bubg, true)

		skillButton.disabledBG:SetInside(bubg)

		skillButton.name:ClearAllPoints()
		skillButton.name:SetPoint("TOPLEFT", bubg, "TOPLEFT", 3, -5)

		skillButton.subText:ClearAllPoints()
		skillButton.subText:SetPoint("BOTTOMLEFT", bubg, "BOTTOMLEFT", 3, -5)

		skillButton.money:ClearAllPoints()
		skillButton.money:SetPoint("TOPRIGHT", bubg, "TOPRIGHT", 10, -5)

		skillButton.styled = true
	end
end

C.OnLoadThemes["Blizzard_TrainerUI"] = function()
	B.ReskinFrame(ClassTrainerFrame)
	B.ReskinButton(ClassTrainerTrainButton)
	B.ReskinScroll(ClassTrainerScrollFrameScrollBar)
	B.ReskinDropDown(ClassTrainerFrameFilterDropDown)
	B.ReskinStatusBar(ClassTrainerStatusBar)

	ClassTrainerStatusBar:ClearAllPoints()
	ClassTrainerStatusBar:SetPoint("RIGHT", ClassTrainerFrameFilterDropDown, "LEFT", 0, 2)

	hooksecurefunc("ClassTrainerFrame_SetServiceButton", Reskin_SetServiceButton)
end