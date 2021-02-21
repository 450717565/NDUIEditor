if select(4, GetBuildInfo()) < 9e4 then return end

local Nine, _, T = {}, ...
T.Nine = Nine

function Nine.GetCurrencyInfo(id)
	local t = C_CurrencyInfo.GetCurrencyInfo(id)
	return t.name, t.quantity, t.iconFileID, nil, nil, t.maxQuantity, t.discovered, t.quality
end
function Nine.GetCurrencyLink(...)
	return C_CurrencyInfo.GetCurrencyLink(...)
end

Nine.C_Garrison = setmetatable({}, {__index=C_Garrison})

function Nine.C_Garrison.GetMissionInfo(mid)
	local mt = C_Garrison.GetMissionDeploymentInfo(mid)
	return mt.location, mt.xp, mt.environment, mt.environmentDesc, mt.environmentTexture, mt.locTextureKit, mt.isExhausting, mt.enemies
end

if (GARRISON_LANDING_COVIEW_PATCH_VERSION or 0) < 1 then
	GARRISON_LANDING_COVIEW_PATCH_VERSION = 1
	local lastNineMode = nil
	hooksecurefunc("ShowGarrisonLandingPage", function(pg)
		if GARRISON_LANDING_COVIEW_PATCH_VERSION ~= 1 then
			return
		end
		pg = (pg or C_Garrison.GetLandingPageGarrisonType() or 0)
		local thisNineMode = pg == 111 and 9 or 8
		if thisNineMode ~= 9 and GarrisonLandingPage.SoulbindPanel then
			GarrisonLandingPage.FollowerTab.autoSpellPool:ReleaseAll()
			GarrisonLandingPage.FollowerTab.autoCombatStatsPool:ReleaseAll()
			GarrisonLandingPage.FollowerTab.AbilitiesFrame:Layout()
			GarrisonLandingPage.FollowerTab.CovenantFollowerPortraitFrame:Hide()
		end
		if pg > 2 and GarrisonThreatCountersFrame then
			GarrisonThreatCountersFrame:Hide()
		end
		if lastNineMode and thisNineMode ~= lastNineMode then
			for i=1,#GarrisonLandingPageFollowerList.listScroll.buttons do
				GarrisonLandingPageFollowerList.listScroll.buttons[i]:Hide()
			end
			wipe(GarrisonLandingPageFollowerList.listScroll.buttons)
			GarrisonLandingPageFollowerList.listScroll.buttons = nil
			GarrisonLandingPageFollowerList:Initialize(GarrisonLandingPageFollowerList.followerType)
		end
		if GarrisonLandingPageReport.Sections then
			GarrisonLandingPageReport.Sections:SetShown(thisNineMode == 9)
		end
		lastNineMode = thisNineMode
	end)
end