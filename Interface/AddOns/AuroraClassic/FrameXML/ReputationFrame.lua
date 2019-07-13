local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	ReputationDetailCorner:Hide()
	ReputationDetailDivider:Hide()
	ReputationDetailFrame:ClearAllPoints()
	ReputationDetailFrame:SetPoint("TOPLEFT", ReputationFrame, "TOPRIGHT", 3, -30)

	local function UpdateFactionSkins()
		for i = 1, GetNumFactions() do
			local repbar = _G["ReputationBar"..i]
			local statusbar = _G["ReputationBar"..i.."ReputationBar"]

			if statusbar then
				if not statusbar.styled then
					F.ReskinStatusBar(statusbar, true)

					statusbar.styled = true
				end

				F.StripTextures(repbar)
			end
		end
	end

	ReputationFrame:HookScript("OnShow", UpdateFactionSkins)
	ReputationFrame:HookScript("OnEvent", UpdateFactionSkins)

	for i = 1, NUM_FACTIONS_DISPLAYED do
		local bu = _G["ReputationBar"..i.."ExpandOrCollapseButton"]
		F.ReskinExpandOrCollapse(bu)
	end

	F.ReskinFrame(ReputationDetailFrame)
	F.ReskinClose(ReputationDetailCloseButton)
	F.ReskinCheck(ReputationDetailAtWarCheckBox)
	F.ReskinCheck(ReputationDetailInactiveCheckBox)
	F.ReskinCheck(ReputationDetailMainScreenCheckBox)
	F.ReskinCheck(ReputationDetailLFGBonusReputationCheckBox)
	F.ReskinScroll(ReputationListScrollFrameScrollBar)
end)