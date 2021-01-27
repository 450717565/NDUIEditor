local _, ns = ...
local B, C, L, DB = unpack(ns)

local function Reskin_BankTabPermissions()
	for i = 1, GetNumGuildBankTabs() + 1 do
		local button = _G["GuildControlBankTab"..i]
		if button and not button.styled then
			B.StripTextures(button)
			B.ReskinButton(button.buy.button)

			local ownedTab = button.owned
			B.ReskinIcon(ownedTab.tabIcon)
			B.ReskinInput(ownedTab.editBox)

			ownedTab.tabIcon:ClearAllPoints()
			ownedTab.tabIcon:SetPoint("TOPLEFT", ownedTab, "TOPLEFT", 6, -6)

			ownedTab.editBox:ClearAllPoints()
			ownedTab.editBox:SetPoint("BOTTOMLEFT", ownedTab, "BOTTOMLEFT", 6, 4)

			ownedTab.depositCB:ClearAllPoints()
			ownedTab.depositCB:SetPoint("TOP", ownedTab.viewCB, "BOTTOM", 0, 2)

			ownedTab.infoCB:ClearAllPoints()
			ownedTab.infoCB:SetPoint("TOP", ownedTab.depositCB, "BOTTOM", 0, 2)

			local checboxs = {ownedTab.viewCB, ownedTab.depositCB, ownedTab.infoCB}
			for _, checbox in pairs(checboxs) do
				checbox:SetSize(24, 24)
				B.ReskinCheck(checbox)
			end

			button.styled = true
		end
	end
end

local function Reskin_RankOrder()
	for i = 1, GuildControlGetNumRanks() do
		local rank = _G["GuildControlUIRankOrderFrameRank"..i]
		if rank and not rank.styled then
			rank.upButton:ClearAllPoints()
			rank.upButton:SetPoint("LEFT", rank.nameBox, "RIGHT", 10, 0)

			rank.downButton:ClearAllPoints()
			rank.downButton:SetPoint("LEFT", rank.upButton, "RIGHT", 5, 0)

			rank.deleteButton:ClearAllPoints()
			rank.deleteButton:SetPoint("TOPLEFT", rank.downButton, "TOPRIGHT", 5, 0)
			rank.deleteButton:SetPoint("BOTTOMRIGHT", rank.downButton, "BOTTOMRIGHT", 0, 0)

			B.ReskinArrow(rank.upButton, "up")
			B.ReskinArrow(rank.downButton, "down")
			B.ReskinClose(rank.deleteButton)
			B.ReskinInput(rank.nameBox, 20)

			rank.styled = true
		end
	end
end

C.LUAThemes["Blizzard_GuildControlUI"] = function()
	B.ReskinFrame(GuildControlUI)

	B.StripTextures(GuildControlUIRankBankFrameInset)
	B.ReskinScroll(GuildControlUIRankBankFrameInsetScrollFrameScrollBar)
	B.ReskinButton(GuildControlUIRankOrderFrameNewButton)
	B.ReskinInput(GuildControlUIRankSettingsFrameGoldBox, 20)

	local OfficerCB = GuildControlUIRankSettingsFrameOfficerCheckbox
	B.ReskinCheck(OfficerCB)
	OfficerCB:SetSize(24, 24)

	local OfficerBg = GuildControlUIRankSettingsFrameOfficerBg

	local RosterBg = GuildControlUIRankSettingsFrameRosterBg
	RosterBg:ClearAllPoints()
	RosterBg:SetPoint("TOP", OfficerBg, "BOTTOM", 0, 15)

	local BankBg = GuildControlUIRankSettingsFrameBankBg
	BankBg:ClearAllPoints()
	BankBg:SetPoint("TOP", RosterBg, "BOTTOM", 0, -15)

	local lists = {
		GuildControlUIHbar,
		OfficerBg,
		RosterBg,
		BankBg
	}
	for _, list in pairs(lists) do
		list:Hide()
	end

	local dropdowns = {
		GuildControlUINavigationDropDown,
		GuildControlUIRankSettingsFrameRankDropDown,
		GuildControlUIRankBankFrameRankDropDown,
	}
	for _, dropdown in pairs(dropdowns) do
		B.ReskinDropDown(dropdown)
	end

	for i = 1, NUM_RANK_FLAGS do
		local checbox = _G["GuildControlUIRankSettingsFrameCheckbox"..i]
		if checbox then
			checbox:SetSize(24, 24)
			B.ReskinCheck(checbox)
		end
	end

	hooksecurefunc("GuildControlUI_BankTabPermissions_Update", Reskin_BankTabPermissions)
	hooksecurefunc("GuildControlUI_RankOrder_Update", Reskin_RankOrder)
	GuildControlUIRankOrderFrame:HookScript("OnUpdate", Reskin_RankOrder)
end