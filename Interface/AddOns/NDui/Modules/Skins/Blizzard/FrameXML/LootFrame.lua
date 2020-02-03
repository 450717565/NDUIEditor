local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	local cr, cg, cb = DB.r, DB.g, DB.b
	-- Bonus roll
	B.ReskinFrame(BonusRollFrame, "noKill")
	BonusRollFrame.BlackBackgroundHoist:Hide()

	local PromptFrame = BonusRollFrame.PromptFrame
	B.ReskinIcon(PromptFrame.Icon)

	local Timer = PromptFrame.Timer
	Timer.Bar:SetTexture(DB.normTex)
	Timer.Bar:SetVertexColor(cr, cg, cb)
	B.CreateBDFrame(Timer, 0)

	local SpecIcon = BonusRollFrame.SpecIcon
	SpecIcon:ClearAllPoints()
	SpecIcon:SetPoint("RIGHT", PromptFrame.InfoFrame, "RIGHT", -5, 0)

	local icbg = B.ReskinIcon(SpecIcon)
	icbg:SetFrameLevel(BonusRollFrame:GetFrameLevel() + 1)
	hooksecurefunc("BonusRollFrame_StartBonusRoll", function()
		icbg:SetShown(SpecIcon:IsShown())
	end)

	local from, to = "|T.+|t", "|T%%s:14:14:0:0:64:64:5:59:5:59|t"
	BONUS_ROLL_COST = gsub(BONUS_ROLL_COST, from, to)
	BONUS_ROLL_CURRENT_COUNT = gsub(BONUS_ROLL_CURRENT_COUNT, from, to)

	if not NDuiDB["Skins"]["Loot"] then return end

	B.ReskinFrame(LootFrame)
	B.ReskinArrow(LootFrameUpButton, "up")
	B.ReskinArrow(LootFrameDownButton, "down")

	hooksecurefunc("LootFrame_UpdateButton", function(index)
		local bu = "LootButton"..index
		local icon = _G[bu.."IconTexture"]

		if icon and not icon.bg then
			local button = _G[bu]
			B.CleanTextures(button)

			local icbg = B.ReskinIcon(icon)
			B.ReskinTexture(button, icbg)

			local border = button.IconBorder
			B.ReskinBorder(border, button)

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
end)