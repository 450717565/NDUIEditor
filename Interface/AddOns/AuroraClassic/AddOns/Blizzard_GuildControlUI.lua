local F, C = unpack(select(2, ...))

C.themes["Blizzard_GuildControlUI"] = function()
	F.ReskinFrame(GuildControlUI)

	F.StripTextures(GuildControlUIRankBankFrameInset)
	F.StripTextures(GuildControlUIRankBankFrameInsetScrollFrame)
	F.ReskinScroll(GuildControlUIRankBankFrameInsetScrollFrameScrollBar)
	F.ReskinButton(GuildControlUIRankOrderFrameNewButton)
	F.ReskinInput(GuildControlUIRankSettingsFrameGoldBox, false, 20)

	local OfficerCB = GuildControlUIRankSettingsFrameOfficerCheckbox
	F.ReskinCheck(OfficerCB)
	OfficerCB:SetSize(24, 24)

	local OfficerBg = GuildControlUIRankSettingsFrameOfficerBg

	local RosterBg = GuildControlUIRankSettingsFrameRosterBg
	RosterBg:ClearAllPoints()
	RosterBg:SetPoint("TOP", OfficerBg, "BOTTOM", 0, 15)

	local BankBg = GuildControlUIRankSettingsFrameBankBg
	BankBg:ClearAllPoints()
	BankBg:SetPoint("TOP", RosterBg, "BOTTOM", 0, -15)

	local lists = {GuildControlUIHbar, OfficerBg, RosterBg, BankBg}
	for _, list in pairs(lists) do
		list:Hide()
	end

	local dropdowns = {GuildControlUINavigationDropDown, GuildControlUIRankSettingsFrameRankDropDown, GuildControlUIRankBankFrameRankDropDown}
	for _, dropdown in pairs(dropdowns) do
		F.ReskinDropDown(dropdown)
	end

	for i = 1, NUM_RANK_FLAGS do
		local checbox = _G["GuildControlUIRankSettingsFrameCheckbox"..i]
		if checbox then
			checbox:SetSize(24, 24)
			F.ReskinCheck(checbox)
		end
	end

	hooksecurefunc("GuildControlUI_BankTabPermissions_Update", function()
		for i = 1, GetNumGuildBankTabs() + 1 do
			local bu = _G["GuildControlBankTab"..i]
			if bu and not bu.styled then
				F.StripTextures(bu)
				F.ReskinButton(bu.buy.button)

				local ownedTab = bu.owned
				F.ReskinIcon(ownedTab.tabIcon)
				F.ReskinInput(ownedTab.editBox)

				ownedTab.tabIcon:ClearAllPoints()
				ownedTab.tabIcon:SetPoint("TOPLEFT", ownedTab, "TOPLEFT", 6, -6)

				ownedTab.editBox:ClearAllPoints()
				ownedTab.editBox:SetPoint("BOTTOMLEFT", ownedTab, "BOTTOMLEFT", 6, 4)

				ownedTab.depositCB:ClearAllPoints()
				ownedTab.depositCB:SetPoint("TOP", ownedTab.viewCB, "BOTTOM", 0, 2)

				ownedTab.infoCB:ClearAllPoints()
				ownedTab.infoCB:SetPoint("TOP", ownedTab.depositCB, "BOTTOM", 0, 2)

				for _, checbox in pairs({ownedTab.viewCB, ownedTab.depositCB, ownedTab.infoCB}) do
					checbox:SetSize(24, 24)
					F.ReskinCheck(checbox)
				end

				bu.styled = true
			end
		end
	end)

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
				F.ReskinInput(rank.nameBox, false, 20)

				rank.styled = true
			end
		end
	end
	hooksecurefunc("GuildControlUI_RankOrder_Update", updateGuildRanks)
	GuildControlUIRankOrderFrame:HookScript("OnUpdate", updateGuildRanks)
end