local _, ns = ...
local B, C, L, DB = unpack(ns)
local Skins = B:GetModule("Skins")

local cr, cg, cb = DB.cr, DB.cg, DB.cb

local function Reset_Highlight()
	for _, button in pairs(ImmersionFrame.TalkBox.Elements.Content.RewardsFrame.Buttons) do
		button.bubg:SetBackdropColor(0, 0, 0, 0)
	end
end

local function Update_Highlight(self)
	Reset_Highlight()

	local _, frame = self:GetPoint()
	if frame then
		frame.bubg:SetBackdropColor(cr, cg, cb, .5)
	end
end

local function Update_RewardBorder(self)
	if not self.icbg and not self.bubg then return end

	if self.objectType == "item" then
		local itemQuality = select(4, GetQuestItemInfo(self.type, self:GetID()))
		local r, g, b = GetItemQualityColor(itemQuality or 1)
		self.icbg:SetBackdropBorderColor(r, g, b)
		self.bubg:SetBackdropBorderColor(r, g, b)
	elseif self.objectType == "currency" then
		local name, texture, numItems, quality = GetQuestCurrencyInfo(self.type, self:GetID())
		if name and texture and numItems and quality then
			local currencyID = GetQuestCurrencyID(self.type, self:GetID())
			local currencyQuality = select(4, CurrencyContainerUtil.GetCurrencyContainerInfo(currencyID, numItems, name, texture, quality))
			local r, g, b = GetItemQualityColor(currencyQuality or 1)
			self.icbg:SetBackdropBorderColor(r, g, b)
			self.bubg:SetBackdropBorderColor(r, g, b)
		end
	else
		self.icbg:SetBackdropBorderColor(0, 0, 0)
		self.bubg:SetBackdropBorderColor(0, 0, 0)
	end
end

local function Reskin_RewardButton(self)
	if self and not self.styled then
		B.StripTextures(self, 1)

		self.icbg = B.ReskinIcon(self.Icon)
		self.bubg = B.CreateBGFrame(self, 2, 0, -6, 0, self.icbg)

		self.styled = true
	end

	Update_RewardBorder(self)
end

local function Reskin_TitleButton(self, index)
	local button = self.Buttons[index]
	if button and not button.styled then
		button.Hilite:Hide()
		button.Overlay:Hide()

		B.StripTextures(button)
		B.ReskinButton(button)
		B.CreateBT(button.bgTex)
		B.ReskinText(button.Label, 1, .8, 0)

		button.styled = true
	end

	if index > 1 then
		button:ClearAllPoints()
		button:SetPoint("TOP", self.Buttons[index-1], "BOTTOM", 0, -3)
	end
end

local function Reskin_AddQuestInfo(self)
	local RewardsFrame = self.TalkBox.Elements.Content.RewardsFrame

	-- Item Rewards
	for i = 1, #RewardsFrame.Buttons do
		local itemReward = RewardsFrame.Buttons[i]
		Reskin_RewardButton(itemReward)
	end

	if GetNumRewardSpells() > 0 then
		-- Spell Rewards
		for spellReward in RewardsFrame.spellRewardPool:EnumerateActive() do
			Reskin_RewardButton(spellReward)
		end

		-- Follower Rewards
		for followerReward in RewardsFrame.followerRewardPool:EnumerateActive() do
			local class = followerReward.Class
			local portrait = followerReward.PortraitFrame

			if not followerReward.styled then
				followerReward.BG:Hide()

				Skins.ReskinFollowerPortrait(portrait)

				local bubg = B.CreateBGFrame(followerReward, 0, -3, 2, 7)
				portrait:ClearAllPoints()
				portrait:SetPoint("LEFT", bubg, "LEFT", 3, -4)

				if class then
					Skins.ReskinFollowerClass(class, 36, "RIGHT", -4, 0, bubg)
				end

				followerReward.styled = true
			end

			if portrait then
				Skins.UpdateFollowerQuality(portrait)
			end
		end
	end
end

local function Reskin_QuestProgres(self)
	local buttons = self.TalkBox.Elements.Progress.Buttons
	for i = 1, #buttons do
		local button = buttons[i]
		Reskin_RewardButton(button)
	end
end

function Skins:Immersion()
	if not IsAddOnLoaded("Immersion") then return end

	local TalkBox = ImmersionFrame.TalkBox
	B.StripTextures(TalkBox.PortraitFrame)
	B.StripTextures(TalkBox.BackgroundFrame)
	B.StripTextures(TalkBox.Hilite)

	local hilite = B.CreateBDFrame(TalkBox.Hilite)
	hilite:SetFrameLevel(TalkBox:GetFrameLevel())
	hilite:SetAllPoints(TalkBox)
	hilite:SetBackdropColor(cr, cg, cb, .5)
	hilite:SetBackdropBorderColor(cr, cg, cb, 1)

	local Elements = TalkBox.Elements
	B.StripTextures(Elements)
	B.CreateBG(Elements, 10, -10, -15, 5)

	local ItemHighlight = Elements.Content.RewardsFrame.ItemHighlight
	B.StripTextures(ItemHighlight)
	hooksecurefunc(ItemHighlight, "SetPoint", Update_Highlight)
	ItemHighlight:HookScript("OnShow", Update_Highlight)
	ItemHighlight:HookScript("OnHide", Reset_Highlight)

	local MainFrame = TalkBox.MainFrame
	B.ReskinFrame(MainFrame, "none")
	B.StripTextures(MainFrame.Model)
	B.CreateBDFrame(MainFrame.Model, 0, -C.mult)

	local ReputationBar = TalkBox.ReputationBar
	B.ReskinStatusBar(ReputationBar)
	ReputationBar.icon:Hide()
	ReputationBar:ClearAllPoints()
	ReputationBar:SetPoint("BOTTOM", MainFrame, "TOP", 0, 3)

	local Indicator = MainFrame.Indicator
	Indicator:SetScale(1.25)
	Indicator:ClearAllPoints()
	Indicator:SetPoint("RIGHT", MainFrame.CloseButton, "LEFT", -3, 0)

	for i = 1, 4 do
		local notch = _G["ImmersionFrameNotch"..i]
		if notch then
			notch:SetColorTexture(0, 0, 0)
			notch:SetSize(C.mult, 16)
		end
	end

	hooksecurefunc(ImmersionFrame, "AddQuestInfo", Reskin_AddQuestInfo)
	hooksecurefunc(ImmersionFrame, "QUEST_PROGRESS", Reskin_QuestProgres)
	hooksecurefunc(ImmersionFrame.TitleButtons, "GetButton", Reskin_TitleButton)
end