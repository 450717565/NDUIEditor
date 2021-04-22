local _, ns = ...
local B, C, L, DB = unpack(ns)

local cr, cg, cb = DB.cr, DB.cg, DB.cb
local tL, tR, tT, tB = unpack(DB.TexCoord)

local function Reskin_LootFrame()
	for index = 1, LOOTFRAME_NUMBUTTONS do
		local buttons = "LootButton"..index
		local icon = _G[buttons.."IconTexture"]

		if icon and not icon.icbg then
			local button = _G[buttons]
			B.CleanTextures(button)

			local icbg = B.ReskinIcon(icon)
			B.ReskinHighlight(button, icbg)

			local bubg = B.CreateBDFrame(button)
			bubg:SetPoint("TOPLEFT", icbg, "TOPRIGHT", 2, 0)
			bubg:SetPoint("BOTTOMRIGHT", icbg, "BOTTOMRIGHT", 114, 0)

			local border = button.IconBorder
			B.ReskinBorder(border, icbg, bubg)

			local quest = _G[buttons.."IconQuestTexture"]
			quest:SetAlpha(0)

			local name = _G[buttons.."NameFrame"]
			name:Hide()

			icon.icbg = icbg
			icon.bubg = bubg
		end

		if select(7, GetLootSlotInfo(index)) then
			icon.icbg:SetBackdropBorderColor(1, 1, 0)
			icon.bubg:SetBackdropBorderColor(1, 1, 0)
		end
	end
end

local function Reskin_BossBanner(lootFrame)
	local IconHitBox = lootFrame.IconHitBox
	if not IconHitBox.icbg then
		IconHitBox.icbg = B.CreateBDFrame(IconHitBox)
		IconHitBox.icbg:SetOutside(lootFrame.Icon)
		lootFrame.Icon:SetTexCoord(tL, tR, tT, tB)
		B.ReskinIconBorder(IconHitBox.IconBorder, IconHitBox.icbg, nil, true)
	end

	IconHitBox.IconBorder:SetTexture(nil)
end

tinsert(C.XMLThemes, function()
	-- LootFrame
	B.ReskinFrame(LootFrame)
	B.ReskinArrow(LootFrameUpButton, "up")
	B.ReskinArrow(LootFrameDownButton, "down")

	hooksecurefunc("LootFrame_Update", Reskin_LootFrame)

	LootFrameDownButton:ClearAllPoints()
	LootFrameDownButton:SetPoint("BOTTOMRIGHT", -8, 6)
	LootFramePrev:ClearAllPoints()
	LootFramePrev:SetPoint("LEFT", LootFrameUpButton, "RIGHT", 4, 0)
	LootFrameNext:ClearAllPoints()
	LootFrameNext:SetPoint("RIGHT", LootFrameDownButton, "LEFT", -4, 0)

	-- BonusRollFrame
	B.ReskinFrame(BonusRollFrame, "none")
	BonusRollFrame.BlackBackgroundHoist:Hide()

	local PromptFrame = BonusRollFrame.PromptFrame
	B.ReskinIcon(PromptFrame.Icon)

	local Timer = PromptFrame.Timer
	Timer.Bar:SetTexture(DB.normTex)
	Timer.Bar:SetVertexColor(cr, cg, cb)
	B.CreateBDFrame(Timer, 0, -C.mult)

	local SpecIcon = BonusRollFrame.SpecIcon
	SpecIcon:ClearAllPoints()
	SpecIcon:SetPoint("RIGHT", PromptFrame.InfoFrame, "RIGHT", -5, 0)

	local icbg = B.ReskinIcon(SpecIcon)
	hooksecurefunc("BonusRollFrame_StartBonusRoll", function()
		icbg:SetShown(SpecIcon:IsShown())
	end)

	local from, to = "|T.+|t", "|T%%s:14:14:0:0:64:64:5:59:5:59|t"
	BONUS_ROLL_COST = gsub(BONUS_ROLL_COST, from, to)
	BONUS_ROLL_CURRENT_COUNT = gsub(BONUS_ROLL_CURRENT_COUNT, from, to)

	-- Bossbanner
	hooksecurefunc("BossBanner_ConfigureLootFrame", Reskin_BossBanner)
end)