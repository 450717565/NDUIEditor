local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.ReskinFrame(QuestFrame)

	local frames = {QuestFrameDetailPanel, QuestDetailScrollFrame, QuestFrameProgressPanel, QuestProgressScrollFrame, QuestFrameRewardPanel, QuestRewardScrollFrame, QuestGreetingScrollFrame, QuestFrameGreetingPanel}
	for _, frame in pairs(frames) do
		F.StripTextures(frame, true)
	end

	local line = QuestFrameGreetingPanel:CreateTexture()
	line:SetColorTexture(1, 1, 1, .25)
	line:SetSize(256, C.mult)
	line:SetPoint("CENTER", QuestGreetingFrameHorizontalBreak)

	QuestGreetingFrameHorizontalBreak:SetTexture("")

	QuestFrameGreetingPanel:HookScript("OnShow", function()
		line:SetShown(QuestGreetingFrameHorizontalBreak:IsShown())
	end)

	for i = 1, MAX_REQUIRED_ITEMS do
		local icon = _G["QuestProgressItem"..i.."IconTexture"]
		icon:ClearAllPoints()
		icon:SetPoint("LEFT")

		local ic = F.ReskinIcon(icon)
		local bg = F.CreateBDFrame(_G["QuestProgressItem"..i], 0)
		bg:SetPoint("TOPLEFT", ic, "TOPRIGHT", 2, 0)
		bg:SetPoint("BOTTOMRIGHT", -5, 0)

		local name = _G["QuestProgressItem"..i.."NameFrame"]
		name:Hide()
	end

	QuestDetailScrollFrame:SetWidth(302) -- else these buttons get cut off

	hooksecurefunc(QuestProgressRequiredMoneyText, "SetTextColor", function(self, r)
		if r == 0 then
			self:SetTextColor(.8, .8, .8)
		elseif r == .2 then
			self:SetTextColor(1, 1, 1)
		end
	end)

	for _, questButton in pairs({"QuestFrameAcceptButton", "QuestFrameDeclineButton", "QuestFrameCompleteQuestButton", "QuestFrameCompleteButton", "QuestFrameGoodbyeButton", "QuestFrameGreetingGoodbyeButton"}) do
		F.ReskinButton(_G[questButton])
	end
	F.ReskinScroll(QuestProgressScrollFrameScrollBar)
	F.ReskinScroll(QuestRewardScrollFrameScrollBar)
	F.ReskinScroll(QuestDetailScrollFrameScrollBar)
	F.ReskinScroll(QuestGreetingScrollFrameScrollBar)

	-- Text colour stuff

	QuestProgressRequiredItemsText:SetTextColor(1, 1, 1)
	QuestProgressRequiredItemsText:SetShadowColor(0, 0, 0)
	QuestProgressTitleText:SetTextColor(1, 1, 1)
	QuestProgressTitleText:SetShadowColor(0, 0, 0)
	QuestProgressTitleText.SetTextColor = F.Dummy
	QuestProgressText:SetTextColor(1, 1, 1)
	QuestProgressText.SetTextColor = F.Dummy
	GreetingText:SetTextColor(1, 1, 1)
	GreetingText.SetTextColor = F.Dummy
	AvailableQuestsText:SetTextColor(1, 1, 1)
	AvailableQuestsText.SetTextColor = F.Dummy
	AvailableQuestsText:SetShadowColor(0, 0, 0)
	CurrentQuestsText:SetTextColor(1, 1, 1)
	CurrentQuestsText.SetTextColor = F.Dummy
	CurrentQuestsText:SetShadowColor(0, 0, 0)

	-- [[ Quest NPC model ]]

	F.StripTextures(QuestNPCModel, true)
	F.StripTextures(QuestNPCModelTextFrame, true)

	local npcbd = F.CreateBDFrame(QuestNPCModel)
	npcbd:SetPoint("TOPLEFT", -1, 0)
	npcbd:SetPoint("BOTTOMRIGHT", 2, -20)
	npcbd:SetFrameLevel(0)

	local textbd = F.CreateBDFrame(QuestNPCModelTextFrame)
	textbd:SetPoint("TOPLEFT", -1, -1)
	textbd:SetPoint("BOTTOMRIGHT",2 , 5)
	textbd:SetFrameLevel(0)

	hooksecurefunc("QuestFrame_ShowQuestPortrait", function(parentFrame, _, _, _, _, x, y)
		if parentFrame == QuestLogPopupDetailFrame or parentFrame == QuestFrame then
			x = x + 3
		end

		QuestNPCModel:SetPoint("TOPLEFT", parentFrame, "TOPRIGHT", x, y)
	end)

	F.ReskinScroll(QuestNPCModelTextScrollFrameScrollBar)
end)