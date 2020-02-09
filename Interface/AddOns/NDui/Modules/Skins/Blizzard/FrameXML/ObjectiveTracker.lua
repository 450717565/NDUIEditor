local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	local cr, cg, cb = DB.r, DB.g, DB.b

	-- Reskin Quest Icons
	local function reskinQuestIcon(_, block)
		local button = block.rightButton or block.itemButton

		if button and not button.styled then
			B.CleanTextures(button)

			local bg = B.CreateBDFrame(button.icon or button.Icon, 0)
			B.ReskinTexture(button, bg)

			if button.icon then
				button.icon:SetTexCoord(unpack(DB.TexCoord))
			end

			if button.Icon then
				button.Icon:SetPoint("CENTER")
				button.Icon:SetSize(18, 18)
				bg:SetInside(nil, 2, 2)
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
		B.CreateGA(left, width, height, "Horizontal", cr, cg, cb, 0, .8)

		local right = CreateFrame("Frame", nil, self)
		right:SetPoint("TOPLEFT", self, "BOTTOM", 5, 0)
		B.CreateGA(right, width, height, "Horizontal", cr, cg, cb, .8, 0)

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
	local function reskinProgressbar(_, _, line)
		local progressBar = line.ProgressBar
		local bar = progressBar.Bar
		local icon = bar.Icon

		if not bar.styled then
			B.ReskinStatusBar(bar)

			bar:ClearAllPoints()
			bar:SetPoint("LEFT", 22, 0)

			if icon then
				icon:SetMask(nil)
				icon:ClearAllPoints()
				icon:SetPoint("TOPLEFT", bar, "TOPRIGHT", 3, 0)
				icon:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", bar:GetHeight()+3, 0)

				icon.bg = B.ReskinIcon(icon)
			end

			bar.styled = true
		end

		if icon and icon.bg then
			icon.bg:SetShown(icon:IsShown() and icon:GetTexture() ~= nil)
		end
	end

	local progressbar = {
		QUEST_TRACKER_MODULE,
		SCENARIO_TRACKER_MODULE,
		WORLD_QUEST_TRACKER_MODULE,
		BONUS_OBJECTIVE_TRACKER_MODULE,
	}
	for _, modul in pairs(progressbar) do
		hooksecurefunc(modul, "AddProgressBar", reskinProgressbar)
	end

	local function reskinTimerBar(_, _, line)
		local timerBar = line.TimerBar
		local bar = timerBar.Bar

		if not bar.styled then
			B.ReskinStatusBar(bar)

			bar.styled = true
		end
	end

	local timerBar = {
		QUEST_TRACKER_MODULE,
		SCENARIO_TRACKER_MODULE,
		ACHIEVEMENT_TRACKER_MODULE,
	}
	for _, modul in pairs(timerBar) do
		hooksecurefunc(modul, "AddTimerBar", reskinTimerBar)
	end

	-- Reskin Blocks
	hooksecurefunc("ScenarioStage_CustomizeBlock", function(block)
		if not block.styled then
			B.StripTextures(block, true)
			B.SetBDFrame(block.GlowTexture, 4, -2, -4, 0)

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
					B.ReskinIcon(bu.Icon)

					bu.styled = true
				end
			end
		end
	end)

	hooksecurefunc("Scenario_ChallengeMode_ShowBlock", function()
		local block = ScenarioChallengeModeBlock
		if not block.styled then
			B.StripTextures(block)

			block.StatusBar:SetHeight(10)
			B.ReskinStatusBar(block.StatusBar)
			B.SetBDFrame(block, 4, -2, -4, 0)

			block.styled = true
		end
	end)

	hooksecurefunc("Scenario_ChallengeMode_SetUpAffixes", B.ReskinAffixes)

	-- Minimize Button
	local MinimizeButton = ObjectiveTrackerFrame.HeaderMenu.MinimizeButton
	B.ReskinExpandOrCollapse(MinimizeButton)
	MinimizeButton:GetNormalTexture():SetAlpha(0)
	MinimizeButton.expTex:SetTexCoord(.5625, 1, 0, .4375)
	hooksecurefunc("ObjectiveTracker_Collapse", function() MinimizeButton.expTex:SetTexCoord(0, .4375, 0, .4375) end)
	hooksecurefunc("ObjectiveTracker_Expand", function() MinimizeButton.expTex:SetTexCoord(.5625, 1, 0, .4375) end)
end)