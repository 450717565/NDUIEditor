local F, C = unpack(select(2, ...))

C.themes["Blizzard_OrderHallUI"] = function()
	local r, g, b = C.r, C.g, C.b

	-- Orderhall tooltips
	if AuroraConfig.tooltips then
		GarrisonFollowerAbilityWithoutCountersTooltip:DisableDrawLayer("BACKGROUND")
		F.CreateBDFrame(GarrisonFollowerAbilityWithoutCountersTooltip)
		GarrisonFollowerMissionAbilityWithoutCountersTooltip:DisableDrawLayer("BACKGROUND")
		F.CreateBDFrame(GarrisonFollowerMissionAbilityWithoutCountersTooltip)
	end

	OrderHallTalentFrame.OverlayElements:Hide()
	F.ReskinIcon(OrderHallTalentFrame.Currency.Icon, true)
	F.Reskin(OrderHallTalentFrame.BackButton)

	hooksecurefunc(OrderHallTalentFrame, "RefreshAllData", function()
		F.ReskinPortraitFrame(OrderHallTalentFrame, true)

		for i = 1, OrderHallTalentFrame:GetNumChildren() do
			local bu = select(i, OrderHallTalentFrame:GetChildren())
			if bu and bu.talent then
				bu.Border:SetAlpha(0)

				if not bu.bg then
					bu.bg = F.ReskinIcon(bu.Icon, true)
					F.ReskinTexture(bu.Highlight, false, bu.bg)
				end

				if bu.talent.selected then
					bu.bg:SetBackdropBorderColor(r, g, b)
					bu.bg.Shadow:SetBackdropBorderColor(r, g, b)
				else
					bu.bg:SetBackdropBorderColor(0, 0, 0)
					bu.bg.Shadow:SetBackdropBorderColor(0, 0, 0)
				end
			end
		end
	end)
end