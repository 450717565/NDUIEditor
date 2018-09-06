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

	F.StripTextures(OrderHallTalentFrame.StyleFrame, true)
	F.StripTextures(ClassHallTalentInset, true)

	F.Reskin(OrderHallTalentFrame.BackButton)
	OrderHallTalentFrame.Currency.Icon:SetTexCoord(.08, .92, .08, .92)
	F.CreateBDFrame(OrderHallTalentFrame.Currency.Icon, .25)

	hooksecurefunc(OrderHallTalentFrame, "RefreshAllData", function()
		F.StripTextures(OrderHallTalentFrame, true)

		F.CreateBD(OrderHallTalentFrame)
		F.CreateSD(OrderHallTalentFrame)
		F.ReskinClose(OrderHallTalentFrameCloseButton)

		for i = 1, OrderHallTalentFrame:GetNumChildren() do
			local bu = select(i, OrderHallTalentFrame:GetChildren())
			if bu and bu.talent then
				if not bu.bg then
					bu.Icon:SetTexCoord(.08, .92, .08, .92)
					bu.Border:SetAlpha(0)
					bu.Highlight:SetColorTexture(1, 1, 1, .25)
					bu.bg = F.CreateBDFrame(bu.Icon, .25)
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