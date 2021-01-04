local _, ns = ...
local B, C, L, DB = unpack(ns)
local S = B:GetModule("Skins")

local function Reskin_TitleTextColor(fontString)
	B.ReskinText(fontString, 1, .8, 0)
end

local function Reskin_TextColor(fontString)
	B.ReskinText(fontString, 1, 1, 1)
end

local function Fixed_ShowQuestPortrait(parentFrame, _, _, _, _, x, y)
	if parentFrame == WorldMapFrame then
		x = 2
	else
		x = 3
	end
	QuestModelScene:ClearAllPoints()
	QuestModelScene:SetPoint("TOPLEFT", parentFrame, "TOPRIGHT", x, -25)
end

tinsert(C.XMLThemes, function()
	B.ReskinFrame(QuestFrame)
	B.ReskinText(QuestProgressRequiredItemsText, 1, 0, 0)
	B.ReskinHighlight(QuestGreetingFrameHorizontalBreak)

	QuestDetailScrollFrame:SetWidth(302)
	QuestGreetingFrameHorizontalBreak:SetHeight(C.mult)

	local lists = {
		QuestFrameDetailPanel,
		QuestFrameGreetingPanel,
		QuestFrameProgressPanel,
		QuestFrameRewardPanel,
	}
	for _, list in pairs(lists) do
		B.StripTextures(list, 0)
	end

	local buttons = {
		QuestFrameAcceptButton,
		QuestFrameCompleteButton,
		QuestFrameCompleteQuestButton,
		QuestFrameDeclineButton,
		QuestFrameGoodbyeButton,
		QuestFrameGreetingGoodbyeButton,
	}
	for _, button in pairs(buttons) do
		B.ReskinButton(button)
	end

	local scrolls = {
		QuestDetailScrollFrameScrollBar,
		QuestGreetingScrollFrameScrollBar,
		QuestProgressScrollFrameScrollBar,
		QuestRewardScrollFrameScrollBar,
	}
	for _, scroll in pairs(scrolls) do
		B.ReskinScroll(scroll)
	end

	hooksecurefunc("QuestFrame_SetTextColor", Reskin_TextColor)
	hooksecurefunc("QuestFrame_SetTitleTextColor", Reskin_TitleTextColor)
	hooksecurefunc(QuestProgressRequiredMoneyText, "SetTextColor", S.ReskinRMTColor)

	-- QuestModelScene
	B.StripTextures(QuestNPCModelTextFrame)
	B.StripTextures(QuestNPCModelNameTooltipFrame)
	B.ReskinScroll(QuestNPCModelTextScrollFrameScrollBar)

	local boss = B.ReskinFrame(QuestModelScene)
	boss:SetOutside(QuestModelScene, 0, 0, QuestNPCModelTextFrame)

	hooksecurefunc("QuestFrame_ShowQuestPortrait", Fixed_ShowQuestPortrait)
end)