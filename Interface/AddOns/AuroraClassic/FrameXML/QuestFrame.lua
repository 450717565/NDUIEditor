local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.ReskinPortraitFrame(QuestFrame, true)

	local frames = {QuestFrameDetailPanel, QuestDetailScrollFrame, QuestFrameProgressPanel, QuestProgressScrollFrame, QuestFrameRewardPanel, QuestRewardScrollFrame, QuestGreetingScrollFrame, QuestFrameGreetingPanel}
	for _, frame in next, frames do
		F.StripTextures(frame, true)
	end

	local line = QuestFrameGreetingPanel:CreateTexture()
	line:SetColorTexture(1, 1, 1, .25)
	line:SetSize(256, 1)
	line:SetPoint("CENTER", QuestGreetingFrameHorizontalBreak)

	QuestGreetingFrameHorizontalBreak:SetTexture("")

	QuestFrameGreetingPanel:HookScript("OnShow", function()
		line:SetShown(QuestGreetingFrameHorizontalBreak:IsShown())
	end)

	for i = 1, MAX_REQUIRED_ITEMS do
		local bu = _G["QuestProgressItem"..i]
		local ic = _G["QuestProgressItem"..i.."IconTexture"]
		local na = _G["QuestProgressItem"..i.."NameFrame"]
		local co = _G["QuestProgressItem"..i.."Count"]

		ic:SetSize(40, 40)
		ic:SetTexCoord(.08, .92, .08, .92)
		ic:SetDrawLayer("OVERLAY")
		ic:ClearAllPoints()
		ic:SetPoint("LEFT")
		F.CreateBDFrame(ic)

		F.CreateBD(bu, .25)
		F.CreateSD(bu)

		na:Hide()
		co:SetDrawLayer("OVERLAY")

		local line = CreateFrame("Frame", nil, bu)
		line:SetSize(1, 40)
		line:SetPoint("RIGHT", ic, 1, 0)
		F.CreateBD(line)
		F.CreateSD(line)
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
		F.Reskin(_G[questButton])
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
	QuestProgressTitleText.SetTextColor = F.dummy
	QuestProgressText:SetTextColor(1, 1, 1)
	QuestProgressText.SetTextColor = F.dummy
	GreetingText:SetTextColor(1, 1, 1)
	GreetingText.SetTextColor = F.dummy
	AvailableQuestsText:SetTextColor(1, 1, 1)
	AvailableQuestsText.SetTextColor = F.dummy
	AvailableQuestsText:SetShadowColor(0, 0, 0)
	CurrentQuestsText:SetTextColor(1, 1, 1)
	CurrentQuestsText.SetTextColor = F.dummy
	CurrentQuestsText:SetShadowColor(0, 0, 0)

	-- [[ Quest NPC model ]]

	F.StripTextures(QuestNPCModel, true)
	F.StripTextures(QuestNPCModelTextFrame, true)

	local npcbd = CreateFrame("Frame", nil, QuestNPCModel)
	npcbd:SetPoint("TOPLEFT", -1, 0)
	npcbd:SetPoint("BOTTOMRIGHT", 0, -20)
	npcbd:SetFrameLevel(0)
	F.CreateBD(npcbd)
	F.CreateSD(npcbd)

	local textbd = CreateFrame("Frame", nil, QuestNPCModelTextFrame)
	textbd:SetPoint("TOPLEFT", -1, 1)
	textbd:SetPoint("BOTTOMRIGHT",0 , 5)
	textbd:SetFrameLevel(0)
	F.CreateBD(textbd)
	F.CreateSD(textbd)

	hooksecurefunc("QuestFrame_ShowQuestPortrait", function(parentFrame, _, _, _, _, x, y)
		if parentFrame == QuestLogPopupDetailFrame or parentFrame == QuestFrame then
			x = x + 3
		end

		QuestNPCModel:SetPoint("TOPLEFT", parentFrame, "TOPRIGHT", x, y)
	end)

	F.ReskinScroll(QuestNPCModelTextScrollFrameScrollBar)
end)