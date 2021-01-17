local _, ns = ...
local B, C, L, DB = unpack(ns)

local cr, cg, cb = DB.cr, DB.cg, DB.cb

local function Reskin_Header(self)
	self.Background:Hide()

	local width, height = self:GetWidth()/2+10, C.mult*2

	local left = B.CreateGA(self, "H", cr, cg, cb, 0, C.alpha, width, height)
	left:SetPoint("TOPRIGHT", self, "BOTTOM", 5, 0)

	local right = B.CreateGA(self, "H", cr, cg, cb, C.alpha, 0, width, height)
	right:SetPoint("TOPLEFT", self, "BOTTOM", 5, 0)

	local Text = self.Text
	Text:SetTextColor(cr, cg, cb)
	Text:ClearAllPoints()
	Text:SetPoint("BOTTOMLEFT", left, "TOPLEFT", 15, 6)
end

local function Reskin_Progressbar(_, _, line)
	local progressBar = line.ProgressBar
	local bar = progressBar.Bar
	local icon = bar.Icon

	if not bar.styled then
		B.ReskinStatusBar(bar)
		B.SmoothBar(bar)

		bar:ClearAllPoints()
		bar:SetPoint("LEFT", 22, 0)

		if icon then
			icon:SetMask(nil)
			icon:ClearAllPoints()
			icon:SetPoint("TOPLEFT", bar, "TOPRIGHT", C.margin, 0)
			icon:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", bar:GetHeight()+C.margin, 0)

			icon.icbg = B.ReskinIcon(icon)
		end

		bar.styled = true
	end

	if icon and icon.icbg then
		icon.icbg:SetShown(icon:IsShown() and icon:GetTexture() ~= nil)
	end
end

local function Reskin_TimerBar(_, _, line)
	local timerBar = line.TimerBar
	local bar = timerBar.Bar

	if not bar.styled then
		B.ReskinStatusBar(bar)
		B.SmoothBar(bar)

		bar.styled = true
	end
end

local function Reskin_CustomizeBlock(block)
	if not block.styled then
		B.StripTextures(block, 0)
		B.CreateBG(block.GlowTexture, 4, -2, -4, 0)

		block.styled = true
	end
end

local function Reskin_ShowBlock()
	local block = ScenarioChallengeModeBlock
	if not block.styled then
		B.StripTextures(block)

		block.StatusBar:SetHeight(10)
		B.ReskinStatusBar(block.StatusBar)
		B.CreateBG(block, 4, -2, -4, 0)

		block.styled = true
	end
end

local function Reskin_ContentTracker()
	local widgetContainer = ScenarioStageBlock.WidgetContainer
	if not widgetContainer then return end

	local widgetFrame = widgetContainer:GetChildren()
	if widgetFrame and widgetFrame.Frame then
		widgetFrame.Frame:SetAlpha(0)

		if widgetFrame.CurrencyContainer then
			local child = {widgetFrame.CurrencyContainer:GetChildren()}
			for _, button in pairs(child) do
				if button and not button.styled then
					B.ReskinIcon(button.Icon)

					button.styled = true
				end
			end
		end
	end
end

local function Reskin_QuestIcon(self)
	if not self then return end
	if not self.SetNormalTexture then return end

	if not self.styled then
		B.CleanTextures(self)

		local icbg = B.CreateBDFrame(self.icon or self.Icon)
		B.ReskinHighlight(self, icbg)

		if self.icon then
			self.icon:SetTexCoord(unpack(DB.TexCoord))
		end

		if self.Icon then
			self.Icon:SetDrawLayer("ARTWORK")
			self.Icon:SetPoint("CENTER")
			self.Icon:SetSize(18, 18)
			icbg:SetInside(nil, 2, 2)
		end

		self.styled = true
	end
end

local function Reskin_QuestIcons(_, block)
	Reskin_QuestIcon(block.itemButton)
	Reskin_QuestIcon(block.groupFinderButton)
end

local function Get_MawBuffsAnchor(self)
	local center = self:GetCenter()
	if center and center < GetScreenWidth()/2 then
		return "LEFT"
	else
		return "RIGHT"
	end
end

local function Update_FrameAnchor(container)
	local direc = Get_MawBuffsAnchor(container)
	if not container.lastDirec or container.lastDirec ~= direc then
		container.List:ClearAllPoints()
		if direc == "LEFT" then
			container.List:SetPoint("TOPLEFT", container, "TOPRIGHT", 15, 1)
		else
			container.List:SetPoint("TOPRIGHT", container, "TOPLEFT", 15, 1)
		end
		container.lastDirec = direc
	end
end

local function Update_MinimizeButton(button, collapsed)
	button.expTex:DoCollapse(collapsed)
end

local function Reskin_MinimizeButton(button)
	B.ReskinCollapse(button)
	button.expTex:DoCollapse(false)
	hooksecurefunc(button, "SetCollapsed", Update_MinimizeButton)
end

tinsert(C.XMLThemes, function()
	local MinimizeButton = ObjectiveTrackerFrame.HeaderMenu.MinimizeButton
	Reskin_MinimizeButton(MinimizeButton)

	-- Headers
	local headers = {
		BONUS_OBJECTIVE_TRACKER_MODULE.Header,
		ObjectiveTrackerBlocksFrame.AchievementHeader,
		ObjectiveTrackerBlocksFrame.CampaignQuestHeader,
		ObjectiveTrackerBlocksFrame.QuestHeader,
		ObjectiveTrackerBlocksFrame.ScenarioHeader,
		ObjectiveTrackerFrame.BlocksFrame.UIWidgetsHeader,
		WORLD_QUEST_TRACKER_MODULE.Header,
	}
	for _, header in pairs(headers) do
		Reskin_Header(header)

		local MinimizeButton = header.MinimizeButton
		if MinimizeButton then
			Reskin_MinimizeButton(MinimizeButton)
		end
	end

	-- ProgressBar
	local progressBar = {
		BONUS_OBJECTIVE_TRACKER_MODULE,
		CAMPAIGN_QUEST_TRACKER_MODULE,
		QUEST_TRACKER_MODULE,
		SCENARIO_TRACKER_MODULE,
		WORLD_QUEST_TRACKER_MODULE,
	}
	for _, bar in pairs(progressBar) do
		hooksecurefunc(bar, "AddProgressBar", Reskin_Progressbar)
	end

	-- TimerBar
	local timerBar = {
		ACHIEVEMENT_TRACKER_MODULE,
		QUEST_TRACKER_MODULE,
		SCENARIO_TRACKER_MODULE,
	}
	for _, bar in pairs(timerBar) do
		hooksecurefunc(bar, "AddTimerBar", Reskin_TimerBar)
	end

	-- QuestIcons
	hooksecurefunc(BONUS_OBJECTIVE_TRACKER_MODULE, "AddObjective", Reskin_QuestIcons)
	hooksecurefunc(CAMPAIGN_QUEST_TRACKER_MODULE, "AddObjective", Reskin_QuestIcons)
	hooksecurefunc(QUEST_TRACKER_MODULE, "SetBlockHeader", Reskin_QuestIcons)
	hooksecurefunc(WORLD_QUEST_TRACKER_MODULE, "AddObjective", Reskin_QuestIcons)

	-- Blocks
	hooksecurefunc("Scenario_ChallengeMode_SetUpAffixes", B.ReskinAffixes)
	hooksecurefunc("Scenario_ChallengeMode_ShowBlock", Reskin_ShowBlock)
	hooksecurefunc("ScenarioStage_CustomizeBlock", Reskin_CustomizeBlock)
	hooksecurefunc(SCENARIO_CONTENT_TRACKER_MODULE, "Update", Reskin_ContentTracker)

	-- MawBuffsBlock
	ScenarioBlocksFrame.MawBuffsBlock.Container:HookScript("OnClick", Update_FrameAnchor)
end)