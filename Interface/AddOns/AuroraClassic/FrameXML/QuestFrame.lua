local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.ReskinFrame(QuestFrame)

	QuestDetailScrollFrame:SetWidth(302)

	local BreakLine = QuestGreetingFrameHorizontalBreak
	BreakLine:SetTexture(C.media.bdTex)
	BreakLine:SetColorTexture(1, 1, 1, .25)
	BreakLine:SetHeight(C.mult)

	local lists = {QuestFrameDetailPanel, QuestDetailScrollFrame, QuestFrameProgressPanel, QuestProgressScrollFrame, QuestFrameRewardPanel, QuestRewardScrollFrame, QuestGreetingScrollFrame, QuestFrameGreetingPanel}
	for _, list in pairs(lists) do
		F.StripTextures(list, true)
	end

	local buttons = {QuestFrameAcceptButton, QuestFrameDeclineButton, QuestFrameCompleteQuestButton, QuestFrameCompleteButton, QuestFrameGoodbyeButton, QuestFrameGreetingGoodbyeButton}
	for _, button in pairs(buttons) do
		F.ReskinButton(button)
	end

	local scrolls = {QuestProgressScrollFrameScrollBar, QuestRewardScrollFrameScrollBar, QuestDetailScrollFrameScrollBar, QuestGreetingScrollFrameScrollBar}
	for _, scroll in pairs(scrolls) do
		F.ReskinScroll(scroll)
	end

	for i = 1, MAX_REQUIRED_ITEMS do
		local item = "QuestProgressItem"..i
		F.StripTextures(_G[item])

		local icon = _G[item.."IconTexture"]
		local icbg = F.ReskinIcon(icon)

		local bubg = F.CreateBDFrame(_G[item], 0)
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

	-- QuestNPCModel
	F.StripTextures(QuestNPCModel)
	F.StripTextures(QuestNPCModelTextFrame)
	F.ReskinScroll(QuestNPCModelTextScrollFrameScrollBar)

	local npcbd = F.CreateBDFrame(QuestNPCModel)
	npcbd:SetPoint("TOPLEFT", -1, 0)
	npcbd:SetPoint("BOTTOMRIGHT", 2, -20)
	npcbd:SetFrameLevel(0)

	local textbd = F.CreateBDFrame(QuestNPCModelTextFrame)
	textbd:SetPoint("TOPLEFT", -1, -1)
	textbd:SetPoint("BOTTOMRIGHT", 2, 5)
	textbd:SetFrameLevel(0)

	hooksecurefunc("QuestFrame_ShowQuestPortrait", function(parentFrame, _, _, _, _, x, y)
		if parentFrame == QuestLogPopupDetailFrame or parentFrame == QuestFrame then
			x = x + 3
		end

		QuestNPCModel:ClearAllPoints()
		QuestNPCModel:SetPoint("TOPLEFT", parentFrame, "TOPRIGHT", x, y)
	end)
end)