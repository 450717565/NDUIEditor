local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	if not AuroraConfig.objectiveTracker then return end

	local cr, cg, cb = C.r, C.g, C.b

	-- Reskin Quest Icons
	local function reskinQuestIcon(_, block)
		local button = block.rightButton or block.itemButton

		if button and not button.styled then
			F.CleanTextures(button)

			local bg = F.CreateBDFrame(button.icon or button.Icon, .25)
			F.ReskinTexture(button, bg)

			if button.icon then
				button.icon:SetTexCoord(.08, .92, .08, .92)
			end

			if button.Icon then
				button.Icon:SetPoint("CENTER")
				button.Icon:SetSize(18, 18)
				bg:SetPoint("TOPLEFT", 2, -2)
				bg:SetPoint("BOTTOMRIGHT", -2, 2)
			end

			button.styled = true
		end
	end
	hooksecurefunc(QUEST_TRACKER_MODULE, "SetBlockHeader", reskinQuestIcon)
	hooksecurefunc(WORLD_QUEST_TRACKER_MODULE, "AddObjective", reskinQuestIcon)

	-- Reskin Headers
	local function reskinHeader(self)
		self.Background:Hide()

		local width, height = self:GetWidth()/2+10, C.mult*2

		local left = CreateFrame("Frame", nil, self)
		left:SetPoint("TOPRIGHT", self, "BOTTOM", 5, 0)
		F.CreateGA(left, width, height, "Horizontal", cr, cg, cb, 0, .8)

		local right = CreateFrame("Frame", nil, self)
		right:SetPoint("TOPLEFT", self, "BOTTOM", 5, 0)
		F.CreateGA(right, width, height, "Horizontal", cr, cg, cb, .8, 0)

		local Text = self.Text
		Text:SetTextColor(cr, cg, cb)
		Text:ClearAllPoints()
		Text:SetPoint("BOTTOMLEFT", left, "TOPLEFT", 15, 6)
	end

	local headers = {
		ObjectiveTrackerFrame.BlocksFrame.UIWidgetsHeader,
		ObjectiveTrackerBlocksFrame.AchievementHeader,
		ObjectiveTrackerBlocksFrame.ScenarioHeader,
		ObjectiveTrackerBlocksFrame.QuestHeader,
		BONUS_OBJECTIVE_TRACKER_MODULE.Header,
		WORLD_QUEST_TRACKER_MODULE.Header,
	}
	for _, header in pairs(headers) do reskinHeader(header) end

	-- Reskin Bars
	local function reskinBarTemplate(self)
		F.StripTextures(self)
		F.CreateBDFrame(self, .25)
		self:SetStatusBarTexture(C.media.normTex)
		self:SetStatusBarColor(cr, cg, cb, .8)
	end

	local function reskinProgressbar(_, _, line)
		local progressBar = line.ProgressBar
		local bar = progressBar.Bar
		local icon = bar.Icon

		if not bar.styled then
			reskinBarTemplate(bar)

			bar:ClearAllPoints()
			bar:SetPoint("LEFT", 22, 0)

			if icon then
				icon:SetMask(nil)
				icon.bg = F.ReskinIcon(icon)
				icon:ClearAllPoints()
				icon:SetPoint("TOPLEFT", bar, "TOPRIGHT", 5, 0)
				icon:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", bar:GetHeight()+5, 0)
			end

			bar.styled = true
		end

		if icon and icon.bg then
			icon.bg:SetShown(icon:IsShown() and icon:GetTexture() ~= nil)
		end
	end

	local Pmoduls = {
		QUEST_TRACKER_MODULE,
		SCENARIO_TRACKER_MODULE,
		WORLD_QUEST_TRACKER_MODULE,
		BONUS_OBJECTIVE_TRACKER_MODULE,
	}
	for _, Pmodul in pairs(Pmoduls) do
		hooksecurefunc(Pmodul, "AddProgressBar", reskinProgressbar)
	end

	local function reskinTimerBar(_, _, line)
		local timerBar = line.TimerBar
		local bar = timerBar.Bar

		if not bar.styled then
			reskinBarTemplate(bar)

			bar.styled = true
		end
	end

	local Tmoduls = {
		QUEST_TRACKER_MODULE,
		SCENARIO_TRACKER_MODULE,
		ACHIEVEMENT_TRACKER_MODULE,
	}
	for _, Tmodul in pairs(Tmoduls) do
		hooksecurefunc(Tmodul, "AddTimerBar", reskinTimerBar)
	end

	-- Reskin Blocks
	hooksecurefunc("ScenarioStage_CustomizeBlock", function(block)
		if not block.styled then
			F.StripTextures(block)

			local bg = F.CreateBDFrame(block.GlowTexture, .25)
			bg:SetPoint("TOPLEFT", block.GlowTexture, 4, -2)
			bg:SetPoint("BOTTOMRIGHT", block.GlowTexture, -4, 0)

			block.styled = true
		end
	end)

	hooksecurefunc(SCENARIO_CONTENT_TRACKER_MODULE, "Update", function()
		local widgetContainer = ScenarioStageBlock.WidgetContainer
		if not widgetContainer then return end

		local widgetFrame = widgetContainer:GetChildren()
		if widgetFrame and widgetFrame.Frame then
			widgetFrame.Frame:SetAlpha(0)

			local child = {widgetFrame.CurrencyContainer:GetChildren()}
			for _, bu in pairs(child) do
				if bu and not bu.styled then
					F.ReskinIcon(bu.Icon)

					bu.styled = true
				end
			end
		end
	end)

	hooksecurefunc("Scenario_ChallengeMode_ShowBlock", function()
		local block = ScenarioChallengeModeBlock
		if not block.styled then
			F.StripTextures(block)

			block.StatusBar:SetHeight(10)
			F.ReskinStatusBar(block.StatusBar)

			local bg = F.CreateBDFrame(block, .25)
			bg:SetPoint("TOPLEFT", block, 4, -2)
			bg:SetPoint("BOTTOMRIGHT", block, -4, 0)

			block.styled = true
		end
	end)

	hooksecurefunc("Scenario_ChallengeMode_SetUpAffixes", F.ReskinAffixes)

	-- Minimize Button
	local MinimizeButton = ObjectiveTrackerFrame.HeaderMenu.MinimizeButton
	F.ReskinExpandOrCollapse(MinimizeButton)
	MinimizeButton:GetNormalTexture():SetAlpha(0)
	MinimizeButton.expTex:SetTexCoord(.5625, 1, 0, .4375)
	hooksecurefunc("ObjectiveTracker_Collapse", function() MinimizeButton.expTex:SetTexCoord(0, .4375, 0, .4375) end)
	hooksecurefunc("ObjectiveTracker_Expand", function() MinimizeButton.expTex:SetTexCoord(.5625, 1, 0, .4375) end)
end)