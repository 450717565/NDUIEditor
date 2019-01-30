local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	ReputationDetailCorner:Hide()
	ReputationDetailDivider:Hide()
	ReputationDetailFrame:SetPoint("TOPLEFT", ReputationFrame, "TOPRIGHT", 2, -28)

	for i = 1, 2 do
		select(i, ReputationListScrollFrame:GetRegions()):Hide()
	end

	local function UpdateFactionSkins()
		for i = 1, GetNumFactions() do
			local repbar = _G["ReputationBar"..i]
			local statusbar = _G["ReputationBar"..i.."ReputationBar"]

			if statusbar then
				if not statusbar.reskinned then
					F.ReskinStatusBar(statusbar, true)
					statusbar.reskinned = true
				end

				F.StripTextures(repbar, true)
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