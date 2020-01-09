local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	local cr, cg, cb = C.r, C.g, C.b

	if AuroraConfig.loot then
		F.ReskinFrame(LootFrame)
		F.ReskinArrow(LootFrameUpButton, "up")
		F.ReskinArrow(LootFrameDownButton, "down")

		hooksecurefunc("LootFrame_UpdateButton", function(index)
			local bu = "LootButton"..index
			local icon = _G[bu.."IconTexture"]

			if icon and not icon.bg then
				local button = _G[bu]
				F.CleanTextures(button)

				local icbg = F.ReskinIcon(icon)
				F.ReskinTexture(button, icbg)

				local border = button.IconBorder
				F.ReskinBorder(border, button)

				local quest = _G[bu.."IconQuestTexture"]
				quest:SetAlpha(0)

				local name = _G[bu.."NameFrame"]
				name:Hide()

				icon.bg = icbg
			end

			if select(7, GetLootSlotInfo(index)) then
				icon.bg:SetBackdropBorderColor(1, 1, 0)
			else
				icon.bg:SetBackdropBorderColor(0, 0, 0)
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
	F.ReskinFrame(BonusRollFrame, true)
	BonusRollFrame.BlackBackgroundHoist:Hide()

	local PromptFrame = BonusRollFrame.PromptFrame
	F.ReskinIcon(PromptFrame.Icon)

	local Timer = PromptFrame.Timer
	Timer.Bar:SetTexture(C.media.normTex)
	Timer.Bar:SetVertexColor(cr, cg, cb)
	F.CreateBDFrame(Timer, 0)

	local SpecIcon = BonusRollFrame.SpecIcon
	SpecIcon:ClearAllPoints()
	SpecIcon:SetPoint("RIGHT", PromptFrame.InfoFrame, "RIGHT", -5, 0)

	local icbg = F.ReskinIcon(SpecIcon)
	icbg:SetFrameLevel(BonusRollFrame:GetFrameLevel() + 1)
	hooksecurefunc("BonusRollFrame_StartBonusRoll", function()
		icbg:SetShown(SpecIcon:IsShown())
	end)

	local from, to = "|T.+|t", "|T%%s:14:14:0:0:64:64:5:59:5:59|t"
	BONUS_ROLL_COST = gsub(BONUS_ROLL_COST, from, to)
	BONUS_ROLL_CURRENT_COUNT = gsub(BONUS_ROLL_CURRENT_COUNT, from, to)
end)