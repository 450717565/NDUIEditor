local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	local r, g, b = C.r, C.g, C.b

	if AuroraConfig.loot then
		F.ReskinFrame(LootFrame)
		F.ReskinArrow(LootFrameUpButton, "up")
		F.ReskinArrow(LootFrameDownButton, "down")

		hooksecurefunc("LootFrame_UpdateButton", function(index)
			local ic = _G["LootButton"..index.."IconTexture"]

			if not ic.bg then
				local quest = _G["LootButton"..index.."IconQuestTexture"]
				quest:SetAlpha(0)

				local name = _G["LootButton"..index.."NameFrame"]
				name:Hide()

				local bu = _G["LootButton"..index]
				bu:SetNormalTexture("")
				bu:SetPushedTexture("")

				local icbg = F.ReskinIcon(ic)
				F.ReskinTexture(bu, icbg, false)

				ic.bg = icbg
			end
		end)

		LootFrameDownButton:ClearAllPoints()
		LootFrameDownButton:SetPoint("BOTTOMRIGHT", -8, 6)
		LootFramePrev:ClearAllPoints()
		LootFramePrev:SetPoint("LEFT", LootFrameUpButton, "RIGHT", 4, 0)
		LootFrameNext:ClearAllPoints()
		LootFrameNext:SetPoint("RIGHT", LootFrameDownButton, "LEFT", -4, 0)
	end

	-- Bonus roll
	F.StripTextures(BonusRollFrame)
	F.ReskinFrame(BonusRollFrame, true)

	BonusRollFrame.BlackBackgroundHoist:Hide()

	local PromptFrame = BonusRollFrame.PromptFrame
	PromptFrame.Timer.Bar:SetTexture(C.media.normTex)
	PromptFrame.Timer.Bar:SetVertexColor(r, g, b)
	F.CreateBDFrame(PromptFrame.Timer, 0)
	F.ReskinIcon(PromptFrame.Icon)

	local SpecIcon = BonusRollFrame.SpecIcon
	SpecIcon:ClearAllPoints()
	SpecIcon:SetPoint("RIGHT", PromptFrame.InfoFrame, "RIGHT", -5, 0)

	local bg = F.ReskinIcon(SpecIcon)
	bg:SetFrameLevel(BonusRollFrame:GetFrameLevel() + 1)
	hooksecurefunc("BonusRollFrame_StartBonusRoll", function()
		bg:SetShown(SpecIcon:IsShown())
	end)

	local from, to = "|T.+|t", "|T%%s:14:14:0:0:64:64:5:59:5:59|t"
	BONUS_ROLL_COST = BONUS_ROLL_COST:gsub(from, to)
	BONUS_ROLL_CURRENT_COUNT = BONUS_ROLL_CURRENT_COUNT:gsub(from, to)
end)