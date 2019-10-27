local _, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	if not AuroraConfig.reskinFont then return end

	local function ReskinFont(font, size, white)
		local oldSize = select(2, font:GetFont())
		size = size or oldSize
		local fontSize = floor(size*AuroraConfig.fontScale + .5) -- round number
		font:SetFont(C.media.font, fontSize, white and "" or "OUTLINE")
		font:SetShadowColor(0, 0, 0, 0)
	end

	local fontList = {
		AchievementCriteriaFont,
		AchievementDescriptionFont,
		AchievementFont_Small,
		CoreAbilityFont,
		DestinyFontHuge,
		DestinyFontLarge,
		DestinyFontMed,
		Fancy12Font,
		Fancy14Font,
		Fancy16Font,
		Fancy18Font,
		Fancy20Font,
		Fancy22Font,
		Fancy24Font,
		Fancy27Font,
		Fancy30Font,
		Fancy32Font,
		Fancy48Font,
		FriendsFont_11,
		FriendsFont_Large,
		FriendsFont_Normal,
		FriendsFont_Small,
		FriendsFont_UserText,
		Game11Font,
		Game120Font,
		Game12Font,
		Game13Font,
		Game13FontShadow,
		Game15Font,
		Game16Font,
		Game18Font,
		Game20Font,
		Game24Font,
		Game27Font,
		Game30Font,
		Game32Font,
		Game36Font,
		Game42Font,
		Game46Font,
		Game48Font,
		Game48FontShadow,
		Game60Font,
		Game72Font,
		GameFont_Gigantic,
		GameFontNormalHuge2,
		GameTooltipHeader,
		HelpFrameKnowledgebaseNavBarHomeButtonText,
		InvoiceFont_Med,
		InvoiceFont_Small,
		MailFont_Large,
		NumberFont_GameNormal,
		NumberFont_Normal_Med,
		NumberFont_Outline_Large,
		NumberFont_Outline_Med,
		NumberFont_OutlineThick_Mono_Small,
		NumberFont_Shadow_Med,
		NumberFont_Shadow_Small,
		NumberFont_Shadow_Tiny,
		NumberFont_Small,
		QuestFont_Enormous,
		QuestFont_Huge,
		QuestFont_Large,
		QuestFont_Shadow_Huge,
		QuestFont_Shadow_Small,
		QuestFont_Super_Huge,
		RaidBossEmoteFrame.slot1,
		RaidBossEmoteFrame.slot2,
		RaidWarningFrame.slot1,
		RaidWarningFrame.slot2,
		ReputationDetailFont,
		SpellFont_Small,
		SplashHeaderFont,
		System_IME,
		SystemFont_Huge1,
		SystemFont_Huge2,
		SystemFont_InverseShadow_Small,
		SystemFont_Large,
		SystemFont_Med1,
		SystemFont_Med2,
		SystemFont_Med3,
		SystemFont_Outline,
		SystemFont_Outline_Small,
		SystemFont_OutlineThick_Huge2,
		SystemFont_OutlineThick_Huge4,
		SystemFont_OutlineThick_WTF,
		SystemFont_Shadow_Huge1,
		SystemFont_Shadow_Huge2,
		SystemFont_Shadow_Huge3,
		SystemFont_Shadow_Large,
		SystemFont_Shadow_Large_Outline,
		SystemFont_Shadow_Large2,
		SystemFont_Shadow_Med1,
		SystemFont_Shadow_Med1_Outline,
		SystemFont_Shadow_Med2,
		SystemFont_Shadow_Med3,
		SystemFont_Shadow_Outline_Huge2,
		SystemFont_Shadow_Small,
		SystemFont_Shadow_Small2,
		SystemFont_Small,
		SystemFont_Small2,
		SystemFont_Tiny,
		SystemFont_Tiny2,
		Tooltip_Med,
		Tooltip_Small,
	}
	for _, font in pairs(fontList) do
		ReskinFont(font)
	end

	ReskinFont(ChatBubbleFont, 13)
	ReskinFont(SystemFont_LargeNamePlate, 12)
	ReskinFont(SystemFont_LargeNamePlateFixed, 12)
	ReskinFont(SystemFont_NamePlate, 12)
	ReskinFont(SystemFont_NamePlateFixed, 12)
	ReskinFont(SystemFont_World, 64)
	ReskinFont(SystemFont_World_ThickOutline, 64)
	ReskinFont(SystemFont_WTF2, 64)

	-- Refont RaidFrame Health
	hooksecurefunc("CompactUnitFrame_UpdateStatusText", function(frame)
		if frame:IsForbidden() then return end
		if not frame.statusText then return end

		local options = DefaultCompactUnitFrameSetupOptions
		frame.statusText:ClearAllPoints()
		frame.statusText:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 3, options.height/3 - 5)
		frame.statusText:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -3, options.height/3 - 5)

		if not frame.fontStyled then
			local fontName, fontSize = frame.statusText:GetFont()
			frame.statusText:SetFont(fontName, fontSize, "OUTLINE")
			frame.statusText:SetTextColor(.7, .7, .7)
			frame.statusText:SetShadowColor(0, 0, 0, 0)
			frame.fontStyled = true
		end
	end)

	-- Refont Titles Panel
	hooksecurefunc("PaperDollTitlesPane_UpdateScrollFrame", function()
		local bu = PaperDollTitlesPane.buttons
		for i = 1, #bu do
			if not bu[i].fontStyled then
				ReskinFont(bu[i].text, 14)
				bu[i].fontStyled = true
			end
		end
	end)

	-- WhoFrame LevelText
	hooksecurefunc("WhoList_Update", function()
		local buttons = WhoListScrollFrame.buttons
		for i = 1, #buttons do
			local button = buttons[i]
			local level = button.Level
			if level and not level.fontStyled then
				level:SetWidth(32)
				level:SetJustifyH("CENTER")
				level.fontStyled = true
			end
		end
	end)

	-- Text color
	GameFontBlackMedium:SetTextColor(1, 1, 1)
	CoreAbilityFont:SetTextColor(1, 1, 1)
end)