local _, ns = ...
local B, C, L, DB = unpack(ns)
local S = B:GetModule("Skins")

local cr, cg, cb = DB.cr, DB.cg, DB.cb

local function Reskin_TitleTextColor(fontString)
	B.ReskinText(fontString, 1, .8, 0)
end

local function Reskin_TextColor(fontString)
	B.ReskinText(fontString, 1, 1, 1)
end

local Fixed_ShowQuestPortrait
if DB.isNewPatch then
	Fixed_ShowQuestPortrait = function(parentFrame, _, _, _, _, _, x, y)
		if parentFrame == WorldMapFrame then
			x = 2
		else
			x = 3
		end
		QuestModelScene:ClearAllPoints()
		QuestModelScene:SetPoint("TOPLEFT", parentFrame, "TOPRIGHT", x, -25)
	end
else
	Fixed_ShowQuestPortrait = function(parentFrame, _, _, _, _, x, y)
		if parentFrame == WorldMapFrame then
			x = 2
		else
			x = 3
		end
		QuestModelScene:ClearAllPoints()
		QuestModelScene:SetPoint("TOPLEFT", parentFrame, "TOPRIGHT", x, -25)
	end
end

local function Update_ProgressItemQuality(self)
	local button = self.__owner
	local index = button.__id
	local buttonType = button.type
	local objectType = button.objectType

	local quality
	if objectType == "item" then
		quality = select(4, GetQuestItemInfo(buttonType, index))
	elseif objectType == "currency" then
		quality = select(4, GetQuestCurrencyInfo(buttonType, index))
	end

	local r, g, b = B.GetQualityColor(quality)
	button.icbg:SetBackdropBorderColor(r, g, b)
	button.bubg:SetBackdropBorderColor(r, g, b)
end

tinsert(C.XMLThemes, function()
	B.ReskinFrame(QuestFrame)
	B.ReskinText(QuestProgressRequiredItemsText, 1, 0, 0)

	QuestDetailScrollFrame:SetWidth(302)

	local horizontalBreak = QuestGreetingFrameHorizontalBreak
	horizontalBreak:SetHeight(C.mult)
	horizontalBreak:SetColorTexture(cr, cg, cb, C.alpha)

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

	-- Quest Progress Item
	for i = 1, MAX_REQUIRED_ITEMS do
		local button = _G["QuestProgressItem"..i]
		B.StripTextures(button)

		local icbg = B.ReskinIcon(button.Icon)
		local bubg = B.CreateBGFrame(button, 2, 0, -5, 0, icbg)

		button.__id = i
		button.icbg = icbg
		button.bubg = bubg
		button.Icon.__owner = button
		hooksecurefunc(button.Icon, "SetTexture", Update_ProgressItemQuality)
	end
end)