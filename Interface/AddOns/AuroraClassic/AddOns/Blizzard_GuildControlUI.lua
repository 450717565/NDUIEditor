local F, C = unpack(select(2, ...))

C.themes["Blizzard_GuildControlUI"] = function()
	F.ReskinFrame(GuildControlUI)

	F.StripTextures(GuildControlUIRankBankFrameInset, true)
	F.StripTextures(GuildControlUIRankBankFrameInsetScrollFrame, true)
	F.ReskinButton(GuildControlUIRankOrderFrameNewButton)
	F.ReskinScroll(GuildControlUIRankBankFrameInsetScrollFrameScrollBar)
	F.ReskinDropDown(GuildControlUINavigationDropDown)
	F.ReskinDropDown(GuildControlUIRankSettingsFrameRankDropDown)
	F.ReskinDropDown(GuildControlUIRankBankFrameRankDropDown)
	F.ReskinInput(GuildControlUIRankSettingsFrameGoldBox, 20)
	F.ReskinCheck(GuildControlUIRankSettingsFrameOfficerCheckbox)

	local lists = {GuildControlUIHbar, GuildControlUIRankSettingsFrameOfficerBg, GuildControlUIRankSettingsFrameRosterBg, GuildControlUIRankSettingsFrameBankBg}
	for _, list in next, lists do
		list:Hide()
	end

	do
		local function updateGuildRanks()
			for i = 1, GuildControlGetNumRanks() do
				local rank = _G["GuildControlUIRankOrderFrameRank"..i]
				if not rank.styled then
					rank.upButton:ClearAllPoints()
					rank.upButton:SetPoint("LEFT", rank.nameBox, "RIGHT", 10, 0)

					rank.downButton:ClearAllPoints()
					rank.downButton:SetPoint("LEFT", rank.upButton, "RIGHT", 5, 0)

					rank.deleteButton:ClearAllPoints()
					rank.deleteButton:SetPoint("TOPLEFT", rank.downButton, "TOPRIGHT", 5, 0)
					rank.deleteButton:SetPoint("BOTTOMRIGHT", rank.downButton, "BOTTOMRIGHT", 0, 0)

					F.ReskinArrow(rank.upButton, "up")
					F.ReskinArrow(rank.downButton, "down")
					F.ReskinClose(rank.deleteButton)
					F.ReskinInput(rank.nameBox, 20)

					rank.styled = true
				end
			end
		end

		local f = CreateFrame("Frame")
		f:RegisterEvent("GUILD_RANKS_UPDATE")
		f:SetScript("OnEvent", updateGuildRanks)
		hooksecurefunc("GuildControlUI_RankOrder_Update", updateGuildRanks)
	end

	hooksecurefunc("GuildControlUI_BankTabPermissions_Update", function()
		for i = 1, GetNumGuildBankTabs() + 1 do
			local bu = _G["GuildControlBankTab"..i]
			if bu and not bu.styled then
				F.StripTextures(bu, true)
				F.ReskinButton(bu.buy.button)

				local bg = F.CreateBDFrame(bu, .25)
				bg:SetPoint("TOPLEFT", C.mult, -C.mult)
				bg:SetPoint("BOTTOMRIGHT", -C.mult, C.mult)

				local ownedTab = bu.owned
				ownedTab.tabIcon:ClearAllPoints()
				ownedTab.tabIcon:SetPoint("TOPLEFT", ownedTab, "TOPLEFT", 6, -5)
				F.ReskinIcon(ownedTab.tabIcon, true)
				F.ReskinInput(ownedTab.editBox)

				for _, ch in next, {ownedTab.viewCB, ownedTab.depositCB, ownedTab.infoCB} do
					F.ReskinCheck(ch)
				end

				bu.styled = true
			end
		end
	end)

	for i = 1, 20 do
		local checbox = _G["GuildControlUIRankSettingsFrameCheckbox"..i]
		if checbox then
			F.ReskinCheck(checbox)
		end
	end
end