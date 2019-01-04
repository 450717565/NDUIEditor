local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	ReputationDetailCorner:Hide()
	ReputationDetailDivider:Hide()
	ReputationListScrollFrame:GetRegions():Hide()
	select(2, ReputationListScrollFrame:GetRegions()):Hide()

	ReputationDetailFrame:SetPoint("TOPLEFT", ReputationFrame, "TOPRIGHT", 2, -28)

	local function UpdateFactionSkins()
		for i = 1, GetNumFactions() do
			local repbar = _G["ReputationBar"..i]
			local normTex = _G["ReputationBar"..i.."ReputationBar"]

			if normTex then
				if not normTex.reskinned then
					F.ReskinStatusBar(normTex, false, true)
					normTex.reskinned = true
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

	F.CreateBD(ReputationDetailFrame)
	F.CreateSD(ReputationDetailFrame)
	F.ReskinClose(ReputationDetailCloseButton)
	F.ReskinCheck(ReputationDetailAtWarCheckBox)
	F.ReskinCheck(ReputationDetailInactiveCheckBox)
	F.ReskinCheck(ReputationDetailMainScreenCheckBox)
	F.ReskinCheck(ReputationDetailLFGBonusReputationCheckBox)
	F.ReskinScroll(ReputationListScrollFrameScrollBar)
	select(3, ReputationDetailFrame:GetRegions()):Hide()
end)