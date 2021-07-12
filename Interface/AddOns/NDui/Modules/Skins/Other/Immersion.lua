local _, ns = ...
local B, C, L, DB = unpack(ns)
local SKIN = B:GetModule("Skins")

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

	self.iLvl:SetText("")
	self.iSlot:SetText("")

	local quality
	if self.objectType == "item" then
		quality = select(4, GetQuestItemInfo(self.type, self:GetID()))

		local itemLink = GetQuestItemLink(self.type, self:GetID())
		if itemLink then
			local itemID = GetItemInfoInstant(itemLink)

			if B.GetItemMultiplier(itemID) then
				local mult = B.GetItemMultiplier(itemID)
				local total = self.count * mult
				self.iSlot:SetText(total)
			else
				local level = B.GetItemLevel(itemLink)
				self.iLvl:SetText(level or "")

				local slot = B.GetItemSlot(itemLink)
				self.iSlot:SetText(slot or "")
			end

			if C_Item.IsAnimaItemByID(itemID) then
				self.Icon:SetTexture(3528288)
			end
		end
	elseif self.objectType == "currency" then
		quality = select(4, GetQuestCurrencyInfo(self.type, self:GetID()))
	else
		self.icbg:SetBackdropBorderColor(0, 0, 0)
		self.bubg:SetBackdropBorderColor(0, 0, 0)
	end

	local r, g, b = B.GetQualityColor(quality)
	self.icbg:SetBackdropBorderColor(r, g, b)
	self.bubg:SetBackdropBorderColor(r, g, b)
end

local function Reskin_RewardButton(self)
	if self and not self.styled then
		B.StripTextures(self, 1)

		self.icbg = B.ReskinIcon(self.Icon)
		self.bubg = B.CreateBGFrame(self, C.margin, 0, -6, 0, self.icbg)

		self.iLvl = B.CreateFS(self, 20)
		self.iLvl:SetJustifyH("RIGHT")
		B.UpdatePoint(self.iLvl, "BOTTOMRIGHT", self.icbg, "BOTTOMRIGHT", -1, 0)

		self.iSlot = B.CreateFS(self, 20)
		self.iSlot:SetJustifyH("LEFT")
		B.UpdatePoint(self.iSlot, "TOPLEFT", self.icbg, "TOPLEFT", 1, -3)

		if self.Count then
			self.Count:SetJustifyH("RIGHT")
			self.Count:SetFontObject(Game20Font)
			B.UpdatePoint(self.Count, "BOTTOMRIGHT", self.icbg, "BOTTOMRIGHT", -1, 0)
		end

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
		B.ReskinButton(button, true)
		B.ReskinText(button.Label, 1, .8, 0)

		button.styled = true
	end

	if index > 1 then
		B.UpdatePoint(button, "TOP", self.Buttons[index-1], "BOTTOM", 0, -C.margin)
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

				B.ReskinFollowerPortrait(portrait)

				local bubg = B.CreateBGFrame(followerReward, 0, -3, 2, 7)
				B.UpdatePoint(portrait, "LEFT", bubg, "LEFT", 4, 0)

				if class then
					B.ReskinFollowerClass(class, 36, "RIGHT", -4, 0, bubg)
				end

				followerReward.styled = true
			end

			if portrait then
				B.UpdateFollowerQuality(portrait)
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

local function Reskin_ShowItems(self)
	for tooltip in self.Inspector.tooltipFramePool:EnumerateActive() do
		if tooltip and not tooltip.styled then
			B.StripTextures(tooltip)
			B.StripTextures(tooltip.Hilite)

			local button = tooltip.Button
			B.StripTextures(button)
			B.ReskinButton(button, true)
			button.bgTex:SetFrameLevel(button:GetFrameLevel()-1)

			local icon = tooltip.Icon
			B.StripTextures(icon, 1)
			B.ReskinIcon(icon.Texture)
			B.UpdatePoint(icon.Texture, "TOPLEFT", button.bgTex, "TOPRIGHT", 3, -C.mult)

			tooltip.styled = true
		end
	end
end

function SKIN:Immersion()
	if not IsAddOnLoaded("Immersion") then return end

	local TalkBox = ImmersionFrame.TalkBox
	B.StripTextures(TalkBox.PortraitFrame)
	B.StripTextures(TalkBox.BackgroundFrame)
	B.StripTextures(TalkBox.Hilite)

	local hilite = B.CreateBDFrame(TalkBox.Hilite, 0, 0, true)
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
	ReputationBar.icon:Hide()
	B.ReskinStatusBar(ReputationBar)
	B.UpdatePoint(ReputationBar, "BOTTOM", MainFrame, "TOP", 0, C.margin)

	local Indicator = MainFrame.Indicator
	Indicator:SetScale(1.25)
	B.UpdatePoint(Indicator, "RIGHT", MainFrame.CloseButton, "LEFT", -3, 0)

	hooksecurefunc(ImmersionFrame, "ShowItems", Reskin_ShowItems)
	hooksecurefunc(ImmersionFrame, "AddQuestInfo", Reskin_AddQuestInfo)
	hooksecurefunc(ImmersionFrame, "QUEST_PROGRESS", Reskin_QuestProgres)
	hooksecurefunc(ImmersionFrame.TitleButtons, "GetButton", Reskin_TitleButton)
end

C.OnLoginThemes["Immersion"] = SKIN.Immersion