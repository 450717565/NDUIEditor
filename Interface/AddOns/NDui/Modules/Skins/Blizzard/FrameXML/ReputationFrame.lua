local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	B.ReskinFrame(ReputationDetailFrame)
	B.ReskinClose(ReputationDetailCloseButton)
	B.ReskinScroll(ReputationListScrollFrameScrollBar)

	local checks = {ReputationDetailAtWarCheckBox, ReputationDetailInactiveCheckBox, ReputationDetailMainScreenCheckBox, ReputationDetailLFGBonusReputationCheckBox}
	for _, check in pairs(checks) do
		B.ReskinCheck(check)
	end

	ReputationDetailFrame:ClearAllPoints()
	ReputationDetailFrame:SetPoint("TOPLEFT", ReputationFrame, "TOPRIGHT", 3, -25)

	for i = 1, NUM_FACTIONS_DISPLAYED do
		B.ReskinExpandOrCollapse(_G["ReputationBar"..i.."ExpandOrCollapseButton"])
	end

	local function UpdateFactionSkins()
		local numFactions = GetNumFactions()
		local factionOffset = FauxScrollFrame_GetOffset(ReputationListScrollFrame)

		for i = 1, NUM_FACTIONS_DISPLAYED do
			local factionIndex = factionOffset + i
			local atWarWith = select(7, GetFactionInfo(factionIndex))
			local factionRow = _G["ReputationBar"..i]
			local factionBar = _G["ReputationBar"..i.."ReputationBar"]

			local highlight = _G["ReputationBar"..i.."ReputationBarAtWarHighlight1"]
			highlight:SetTexture(DB.bdTex)
			highlight:SetColorTexture(1, 0, 0)

			if factionIndex <= numFactions then
				if factionBar then
					B.StripTextures(factionRow)

					if not factionBar.styled then
						B.ReskinStatusBar(factionBar, true)

						factionBar.styled = true
					end
				end

				if atWarWith then
					highlight:Show()
				else
					highlight:Hide()
				end
			end
		end
	end

	hooksecurefunc("ReputationFrame_Update", UpdateFactionSkins)
end)