local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	B.ReskinFrame(QuestFrame)

	QuestDetailScrollFrame:SetWidth(302)

	local BreakLine = QuestGreetingFrameHorizontalBreak
	BreakLine:SetTexture(DB.bdTex)
	BreakLine:SetColorTexture(1, 1, 1, .25)
	BreakLine:SetHeight(C.mult)

	local lists = {QuestFrameDetailPanel, QuestFrameProgressPanel, QuestFrameRewardPanel, QuestFrameGreetingPanel}
	for _, list in pairs(lists) do
		B.StripTextures(list, true)
	end

	local buttons = {QuestFrameAcceptButton, QuestFrameDeclineButton, QuestFrameCompleteQuestButton, QuestFrameCompleteButton, QuestFrameGoodbyeButton, QuestFrameGreetingGoodbyeButton}
	for _, button in pairs(buttons) do
		B.ReskinButton(button)
	end

	local scrolls = {QuestProgressScrollFrameScrollBar, QuestRewardScrollFrameScrollBar, QuestDetailScrollFrameScrollBar, QuestGreetingScrollFrameScrollBar}
	for _, scroll in pairs(scrolls) do
		B.ReskinScroll(scroll)
	end

	for i = 1, MAX_REQUIRED_ITEMS do
		local item = "QuestProgressItem"..i
		B.StripTextures(_G[item])

		local icon = _G[item.."IconTexture"]
		local icbg = B.ReskinIcon(icon)

		local bubg = B.CreateBDFrame(_G[item], 0)
		bubg:SetPoint("TOPLEFT", icbg, "TOPRIGHT", 2, 0)
		bubg:SetPoint("BOTTOMRIGHT", -5, 0)
	end

	-- TextColor
	QuestProgressRequiredItemsText:SetTextColor(1, .8, 0)

	hooksecurefunc(QuestProgressRequiredMoneyText, "SetTextColor", function(self, r)
		if r == 0 then
			self:SetTextColor(1, 0, 0)
		elseif r == .2 then
			self:SetTextColor(0, 1, 0)
		end
	end)

	hooksecurefunc("QuestFrame_SetTitleTextColor", function(fontString)
		fontString:SetTextColor(1, .8, 0)
	end)

	hooksecurefunc("QuestFrame_SetTextColor", function(fontString)
		fontString:SetTextColor(1, 1, 1)
	end)

	-- QuestModelScene
	B.StripTextures(QuestModelScene)
	B.StripTextures(QuestNPCModelNameTooltipFrame)
	B.StripTextures(QuestNPCModelTextFrame)
	B.ReskinScroll(QuestNPCModelTextScrollFrameScrollBar)
	hooksecurefunc("QuestFrame_ShowQuestPortrait", function(parentFrame, _, _, _, _, x, y)
		if parentFrame == WorldMapFrame then
			x = 2
		else
			x = 3
		end
		QuestModelScene:ClearAllPoints()
		QuestModelScene:SetPoint("TOPLEFT", parentFrame, "TOPRIGHT", x, -25)
	end)
	QuestNPCModelNameTooltipFrame:SetSize(198, 20)
	QuestNPCModelNameTooltipFrame:ClearAllPoints()
	QuestNPCModelNameTooltipFrame:SetPoint("TOP", QuestModelScene, "BOTTOM", 0, -4)
	QuestNPCModelNameText:ClearAllPoints()
	QuestNPCModelNameText:SetPoint("CENTER", QuestNPCModelNameTooltipFrame, 0, 0)
	QuestNPCModelTextFrame:ClearAllPoints()
	QuestNPCModelTextFrame:SetPoint("TOP", QuestNPCModelNameTooltipFrame, "BOTTOM", 0, -4)
	local boss = B.ReskinFrame(QuestModelScene)
	boss:SetFrameLevel(0)
	local name = B.ReskinFrame(QuestNPCModelNameTooltipFrame)
	name:SetFrameLevel(0)
	local text = B.ReskinFrame(QuestNPCModelTextFrame)
	text:SetFrameLevel(0)
end)