local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	if not AuroraConfig.objectiveTracker then return end

	local cr, cg, cb = C.r, C.g, C.b

	local function reskinQuestIcon(_, block)
		local button = block.rightButton or block.itemButton

		if button and not button.styled then
			button:SetNormalTexture("")
			button:SetPushedTexture("")

			local bg = F.CreateBDFrame(button.icon or button.Icon, 0)
			F.ReskinTexture(button, bg, false)

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
	local function reskinHeader(header)
		header.Text:SetTextColor(cr, cg, cb)
		header.Background:Hide()
		local bg = header:CreateTexture(nil, "ARTWORK")
		bg:SetTexture("Interface\\LFGFrame\\UI-LFG-SEPARATOR")
		bg:SetTexCoord(0, .66, 0, .31)
		bg:SetVertexColor(cr, cg, cb)
		bg:SetPoint("BOTTOMLEFT", -30, -4)
		bg:SetSize(250, 30)
	end

	local headers = {
		ObjectiveTrackerBlocksFrame.QuestHeader,
		ObjectiveTrackerBlocksFrame.AchievementHeader,
		ObjectiveTrackerBlocksFrame.ScenarioHeader,
		BONUS_OBJECTIVE_TRACKER_MODULE.Header,
		WORLD_QUEST_TRACKER_MODULE.Header,
	}
	for _, header in pairs(headers) do reskinHeader(header) end

	-- Reskin Progressbars
	local function reskinProgressbar(_, _, line)
		local progressBar = line.ProgressBar
		local bar = progressBar.Bar
		local icon = bar.Icon

		if not bar.styled then
			bar.BarFrame:Hide()
			bar.BarFrame2:Hide()
			bar.BarFrame3:Hide()
			bar.BarBG:Hide()
			bar.BarGlow:Hide()
			bar.IconBG:SetTexture("")
			BonusObjectiveTrackerProgressBar_PlayFlareAnim = F.Dummy

			bar:SetPoint("LEFT", 22, 0)
			bar:SetStatusBarTexture(C.media.normTex)
			bar:SetStatusBarColor(cr, cg, cb, .8)

			local bg = F.CreateBDFrame(progressBar, .25)
			bg:SetPoint("TOPLEFT", bar, -C.mult, C.mult)
			bg:SetPoint("BOTTOMRIGHT", bar, C.mult, -C.mult)

			icon:SetMask(nil)
			icon.bg = F.ReskinIcon(icon)
			icon:ClearAllPoints()
			icon:SetPoint("TOPLEFT", bar, "TOPRIGHT", 5, 0)
			icon:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", bar:GetHeight()+5, 0)

			bar.styled = true
		end

		if icon.bg then
			icon.bg:SetShown(icon:IsShown() and icon:GetTexture() ~= nil)
		end
	end
	hooksecurefunc(BONUS_OBJECTIVE_TRACKER_MODULE, "AddProgressBar", reskinProgressbar)
	hooksecurefunc(WORLD_QUEST_TRACKER_MODULE, "AddProgressBar", reskinProgressbar)
	hooksecurefunc(SCENARIO_TRACKER_MODULE, "AddProgressBar", reskinProgressbar)

	hooksecurefunc(QUEST_TRACKER_MODULE, "AddProgressBar", function(_, _, line)
		local progressBar = line.ProgressBar
		local bar = progressBar.Bar

		if not bar.styled then
			bar:ClearAllPoints()
			bar:SetPoint("LEFT")
			for i = 1, 6 do
				select(i, bar:GetRegions()):Hide()
			end
			bar:SetStatusBarTexture(C.media.normTex)
			bar:SetStatusBarColor(cr, cg, cb, .8)
			bar.Label:Show()
			local oldBg = select(5, bar:GetRegions())
			F.CreateBDFrame(oldBg, .25)

			bar.styled = true
		end
	end)

	-- Reskin Blocks
	hooksecurefunc("ScenarioStage_CustomizeBlock", function(block)
		block.NormalBG:SetTexture("")
		if not block.bg then
			block.bg = F.CreateBDFrame(block.GlowTexture, .25)
			block.bg:SetPoint("TOPLEFT", block.GlowTexture, 4, -2)
			block.bg:SetPoint("BOTTOMRIGHT", block.GlowTexture, -4, 0)
		end
	end)

	hooksecurefunc(SCENARIO_CONTENT_TRACKER_MODULE, "Update", function()
		local widgetContainer = ScenarioStageBlock.WidgetContainer
		if not widgetContainer then return end
		local widgetFrame = widgetContainer:GetChildren()
		if widgetFrame and widgetFrame.Frame then
			widgetFrame.Frame:SetAlpha(0)
			for _, bu in pairs({widgetFrame.CurrencyContainer:GetChildren()}) do
				if bu and not bu.styled then
					F.ReskinIcon(bu.Icon)

					bu.styled = true
				end
			end
		end
	end)

	hooksecurefunc("Scenario_ChallengeMode_ShowBlock", function()
		local block = ScenarioChallengeModeBlock
		if not block.bg then
			block.TimerBG:Hide()
			block.TimerBGBack:Hide()

			block.StatusBar:SetHeight(10)
			F.ReskinStatusBar(block.StatusBar)

			select(3, block:GetRegions()):Hide()
			block.bg = F.CreateBDFrame(block, .25)
			block.bg:SetPoint("TOPLEFT", 4, -2)
			block.bg:SetPoint("BOTTOMRIGHT", -4, 0)
		end
	end)

	hooksecurefunc("Scenario_ChallengeMode_SetUpAffixes", F.ReskinAffixes)

	-- Minimize Button
	local minimize = ObjectiveTrackerFrame.HeaderMenu.MinimizeButton
	F.ReskinExpandOrCollapse(minimize)
	minimize:GetNormalTexture():SetAlpha(0)
	minimize.expTex:SetTexCoord(0.5625, 1, 0, 0.4375)
	hooksecurefunc("ObjectiveTracker_Collapse", function() minimize.expTex:SetTexCoord(0, 0.4375, 0, 0.4375) end)
	hooksecurefunc("ObjectiveTracker_Expand", function() minimize.expTex:SetTexCoord(0.5625, 1, 0, 0.4375) end)
end)