local _, ns = ...
local B, C, L, DB = unpack(ns)
local Skins = B:GetModule("Skins")

local function Reskin_Frame(self)
	B.StripTextures(self.TaskBoard.List)

	local Missions = self.TaskBoard.Missions
	for i = 1, #Missions do
		local button = Missions[i]
		if not button.styled then
			B.ReskinText(button.XPReward, 0, 1, 1)
			B.ReskinText(button.Description, 1, 1, 1)
			B.ReskinText(button.CDTDisplay, 1, 1, 0)

			local Groups = button.Groups
			if Groups then
				for j = 1, #Groups do
					local group = Groups[j]
					B.ReskinButton(group)
					B.ReskinText(group.Features, 0, 1, 0)
				end
			end

			local Rewards = button.Rewards
			if Rewards then
				for j = 1, #Rewards do
					local reward = Rewards[j]
					reward.RarityBorder:Hide()
					reward.Quantity:SetJustifyH("RIGHT")
					reward.Quantity:ClearAllPoints()
					reward.Quantity:SetPoint("BOTTOMRIGHT", reward, "BOTTOMRIGHT", -1, 1)

					local r, g, b = 1, 1, 1
					if reward.currencyID then
						if reward.currencyID == 0 then
							r, g, b = 1, 1, 0
						else
							local ci_1 = C_CurrencyInfo.GetBasicCurrencyInfo(reward.currencyID)
							local ci_2 = C_CurrencyInfo.GetCurrencyInfo(reward.currencyID)
							r, g, b = B.GetQualityColor((ci_1 and ci_1.quality) or (ci_2 and ci_2.quality))
						end
					elseif reward.itemID then
						local itemQuality = select(3, GetItemInfo(reward.itemLink or reward.itemID))
						r, g, b = B.GetQualityColor(itemQuality)
					end

					if reward.Icon then
						if not reward.icbg then
							reward.icbg = B.ReskinIcon(reward.Icon)
						end

						reward.icbg:SetBackdropBorderColor(r, g, b)
					end
				end
			end

			button.styled = true
		end
	end
end

function Skins:WarPlan()
	if not IsAddOnLoaded("WarPlan") then return end

	C_Timer.After(.1, function()
		local WarPlanFrame = _G.WarPlanFrame
		if not WarPlanFrame then return end

		B.ReskinFrame(WarPlanFrame)

		local ArtFrame = WarPlanFrame.ArtFrame
		B.StripTextures(ArtFrame)
		B.ReskinClose(ArtFrame.CloseButton)
		B.ReskinText(ArtFrame.TitleText, 1, .8, 0)

		Reskin_Frame(WarPlanFrame)
		WarPlanFrame:HookScript("OnShow", Reskin_Frame)
		B.ReskinButton(WarPlanFrame.TaskBoard.AllPurposeButton)

		local Entries = WarPlanFrame.HistoryFrame.Entries
		for i = 1, #Entries do
			local entry = Entries[i]
			entry:DisableDrawLayer("BACKGROUND")
			entry.Name:SetFontObject("Number12Font")
			entry.Detail:SetFontObject("Number12Font")

			B.ReskinIcon(entry.Icon)
		end
	end)
end

C.OnLoginThemes["Blizzard_GarrisonUI"] = Skins.WarPlan