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
		B.StripTextures(list, 0)
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
		B.CreateBG(_G[item], icbg, 2, 0, -5, 0)
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
	B.StripTextures(QuestNPCModelNameTooltipFrame)
	B.ReskinScroll(QuestNPCModelTextScrollFrameScrollBar)

	local boss = B.ReskinFrame(QuestModelScene)
	boss:SetPoint("TOPLEFT", QuestModelScene, "TOPLEFT", -C.mult, C.mult)
	boss:SetPoint("BOTTOMRIGHT", QuestNPCModelTextFrame, "TOPRIGHT", C.mult, -C.mult)

	local text = B.ReskinFrame(QuestNPCModelTextFrame)
	text:SetOutside()

	hooksecurefunc("QuestFrame_ShowQuestPortrait", function(parentFrame, _, _, _, _, x, y)
		if parentFrame == WorldMapFrame then
			x = 2
		else
			x = 3
		end
		QuestModelScene:ClearAllPoints()
		QuestModelScene:SetPoint("TOPLEFT", parentFrame, "TOPRIGHT", x, -25)
	end)
end)