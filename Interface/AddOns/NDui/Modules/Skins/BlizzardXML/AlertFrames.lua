local _, ns = ...
local B, C, L, DB = unpack(ns)
local S = B:GetModule("Skins")

local tL, tR, tT, tB = unpack(DB.TexCoord)

-- Strip Textures
local Textures = {
	"Background",
	"Background2",
	"Background3",
	"BaseQualityBorder",
	"BGAtlas",
	"Blank",
	"BorderGlow",
	"FollowerBG",
	"glow",
	"GuildBanner",
	"GuildBorder",
	"IconBG",
	"IconBorder",
	"OldAchievement",
	"PvPBackground",
	"Sheen",
	"shine",
	"SpecRing",
	"UpgradeQualityBorder",
}

local function Strip_Textures(self)
	for _, texture in pairs(Textures) do
		local tex = self[texture]
		if tex then
			tex:SetAlpha(0)
			tex:SetTexture("")
		end
	end

	if self.Icon then
		if self.Icon.Bling then self.Icon.Bling:SetTexture("") end
		if self.Icon.Overlay then self.Icon.Overlay:SetTexture("") end
	end

	if self.glowFrame then
		if self.glowFrame.glow then self.glowFrame.glow:SetTexture("") end
	end
end

-- Fix Alertframe bg
local lists = {"bg", "icbg", "sibg"}
local function Fix_Color(self)
	local BGColor = C.db["Skins"]["BGColor"]
	local BGAlpha = C.db["Skins"]["BGAlpha"]
	local SDColor = C.db["Skins"]["SDColor"]
	local SDAlpha = C.db["Skins"]["SDAlpha"]

	for _, list in pairs(lists) do
		local BG = self[list]
		if BG then
			BG:SetBackdropColor(BGColor.r, BGColor.g, BGColor.b, BGAlpha)
			if BG.sdTex then
				BG.sdTex:SetBackdropBorderColor(SDColor.r, SDColor.g, SDColor.b, SDAlpha)
			end
		end
	end
end

local function Fix_BG(self)
	if self:IsObjectType("AnimationGroup") then
		self = self:GetParent()
	end

	Fix_Color(self)
end

local function Fix_ParentBG(self)
	self = self:GetParent():GetParent()

	Fix_Color(self)
end

local function Fix_Anim(self)
	if self.hooked then return end

	self:HookScript("OnEnter", Fix_BG)
	self:HookScript("OnShow", Fix_BG)
	self.animIn:HookScript("OnFinished", Fix_BG)
	if self.animArrows then
		self.animArrows:HookScript("OnPlay", Fix_BG)
		self.animArrows:HookScript("OnFinished", Fix_BG)
	end
	if self.Arrows and self.Arrows.ArrowsAnim then
		self.Arrows.ArrowsAnim:HookScript("OnPlay", Fix_ParentBG)
		self.Arrows.ArrowsAnim:HookScript("OnFinished", Fix_ParentBG)
	end

	self.hookded = true
end

local function Reskin_AlertFrame(_, frame)
	if frame.queue == AchievementAlertSystem then
		if not frame.bg then
			frame.bg = B.CreateBG(frame, 0, -7, 0, 8)
			frame.icbg = B.ReskinIcon(frame.Icon.Texture)

			if DB.isNewPatch then
				frame.bg:SetPoint("TOPLEFT", 0, -17)
				frame.bg:SetPoint("BOTTOMRIGHT", 0, 14)
			else
				frame.bg:SetPoint("TOPLEFT", 0, -7)
				frame.bg:SetPoint("BOTTOMRIGHT", 0, 8)
			end

			frame.Unlocked:SetTextColor(1, .8, 0)
			frame.Unlocked:SetFontObject(NumberFont_GameNormal)
			frame.GuildName:ClearAllPoints()
			frame.GuildName:SetPoint("TOPLEFT", 50, -14)
			frame.GuildName:SetPoint("TOPRIGHT", -50, -14)
		end

		frame.Shield.Icon:Show()
		frame.Shield.Points:Show()
	elseif frame.queue == CriteriaAlertSystem then
		if not frame.bg then
			frame.bg = B.CreateBG(frame, -18, 5, 18, -1)
			frame.icbg = B.ReskinIcon(frame.Icon.Texture)

			if DB.isNewPatch then
				frame.bg:SetPoint("TOPLEFT", frame, 28, -7)
				frame.bg:SetPoint("BOTTOMRIGHT", frame, 18, 10)
			else
				frame.bg:SetPoint("TOPLEFT", frame, -18, 5)
				frame.bg:SetPoint("BOTTOMRIGHT", frame, 18, -1)
				frame.Icon:SetScale(.8)
			end

			frame.Unlocked:SetTextColor(1, .8, 0)
			frame.Unlocked:SetFontObject(NumberFont_GameNormal)
		end
	elseif frame.queue == LootAlertSystem then
		local lootItem = frame.lootItem
		if not frame.bg then
			frame.bg = B.CreateBG(frame, 13, -15, -13, 13)
			frame.icbg = B.ReskinIcon(lootItem.Icon)
			frame.sibg = B.ReskinIcon(lootItem.SpecIcon)

			lootItem.SpecIcon:ClearAllPoints()
			lootItem.SpecIcon:SetPoint("TOPLEFT", lootItem.Icon, -5, 5)
		end

		Strip_Textures(lootItem)
		frame.sibg:SetShown(lootItem.SpecIcon:IsShown() and lootItem.SpecIcon:GetTexture() ~= nil)
	elseif frame.queue == LootUpgradeAlertSystem then
		if not frame.bg then
			frame.bg = B.CreateBG(frame, 10, -13, -12, 11)
			frame.icbg = B.ReskinIcon(frame.Icon)

			frame.Icon:ClearAllPoints()
			frame.Icon:SetPoint("CENTER", frame.BaseQualityBorder)
			frame.BaseQualityBorder:SetSize(52, 52)
			frame.BaseQualityBorder:SetTexture(DB.bgTex)
			frame.UpgradeQualityBorder:SetTexture(DB.bgTex)
			frame.UpgradeQualityBorder:SetSize(52, 52)
		end
	elseif frame.queue == MoneyWonAlertSystem or frame.queue == HonorAwardedAlertSystem then
		if not frame.bg then
			frame.bg = B.CreateBG(frame, 7, -7, -7, 7)
			frame.icbg = B.ReskinIcon(frame.Icon)
		end
	elseif frame.queue == NewRecipeLearnedAlertSystem then
		if not frame.bg then
			frame.bg = B.CreateBG(frame, 10, -5, -10, 5)
			B.CreateBDFrame(frame.Icon, 0, -C.mult)
		end

		frame:GetRegions():SetTexture("")
		frame.Icon:SetMask(nil)
		frame.Icon:SetTexCoord(tL, tR, tT, tB)
	elseif frame.queue == WorldQuestCompleteAlertSystem then
		if not frame.bg then
			frame.bg = B.CreateBG(frame, 4, -7, -4, 8)
			frame.icbg = B.ReskinIcon(frame.QuestTexture)

			frame:DisableDrawLayer("BORDER")
			frame.ToastText:SetFontObject(NumberFont_GameNormal)
		end
	elseif frame.queue == GarrisonTalentAlertSystem then
		if not frame.bg then
			frame.bg = B.CreateBG(frame, 8, -8, -8, 11)
			frame.icbg = B.ReskinIcon(frame.Icon)

			frame:GetRegions():Hide()
		end
	elseif frame.queue == GarrisonFollowerAlertSystem then
		if not frame.bg then
			frame.bg = B.CreateBG(frame, 16, -3, -16, 16)
			S.ReskinFollowerPortrait(frame.PortraitFrame)

			frame:GetRegions():Hide()
			select(5, frame:GetRegions()):Hide()
			frame.PortraitFrame:ClearAllPoints()
			frame.PortraitFrame:SetPoint("TOPLEFT", 22, -8)
		end
	elseif frame.queue == GarrisonMissionAlertSystem or frame.queue == GarrisonRandomMissionAlertSystem or frame.queue == GarrisonShipMissionAlertSystem or frame.queue == GarrisonShipFollowerAlertSystem then
		if not frame.bg then
			frame.bg = B.CreateBG(frame, 8, -8, -8, 10)
		end

		-- Anchor fix in 8.2
		if frame.Level then
			frame.Level:ClearAllPoints()
			frame.ItemLevel:ClearAllPoints()
			frame.Rare:ClearAllPoints()

			if frame.ItemLevel:IsShown() and frame.Rare:IsShown() then
				frame.Level:SetPoint("TOP", frame, "TOP", -115, -14)
				frame.ItemLevel:SetPoint("TOP", frame, "TOP", -115, -37)
				frame.Rare:SetPoint("TOP", frame, "TOP", -115, -48)
			elseif frame.Rare:IsShown() then
				frame.Level:SetPoint("TOP", frame, "TOP", -115, -19)
				frame.Rare:SetPoint("TOP", frame, "TOP", -115, -45)
			elseif frame.ItemLevel:IsShown() then
				frame.Level:SetPoint("TOP", frame, "TOP", -115, -19)
				frame.ItemLevel:SetPoint("TOP", frame, "TOP", -115, -45)
			else
				frame.Level:SetPoint("TOP", frame, "TOP", -115, -28)
			end
		end
	elseif frame.queue == GarrisonBuildingAlertSystem then
		if not frame.bg then
			frame.bg = B.CreateBG(frame, 9, -9, -9, 11)
			frame.icbg = B.ReskinIcon(frame.Icon)

			frame:GetRegions():Hide()
		end
	elseif frame.queue == DigsiteCompleteAlertSystem then
		if not frame.bg then
			frame.bg = B.CreateBG(frame, 8, -8, -8, 8)

			frame:GetRegions():Hide()
		end
	elseif frame.queue == GuildChallengeAlertSystem then
		if not frame.bg then
			frame.bg = B.CreateBG(frame, 8, -12, -8, 13)
		end

		select(2, frame:GetRegions()):SetTexture("")
	elseif frame.queue == DungeonCompletionAlertSystem then
		if not frame.bg then
			frame.bg = B.CreateBG(frame, 3, -8, -3, 8)
			frame.icbg = B.ReskinIcon(frame.dungeonTexture)

			frame:DisableDrawLayer("Border")
		end
	elseif frame.queue == ScenarioAlertSystem then
		if not frame.bg then
			frame.bg = B.CreateBG(frame, 5, -5, -5, 5)
			frame.icbg = B.ReskinIcon(frame.dungeonTexture)

			frame:GetRegions():Hide()
			select(3, frame:GetRegions()):Hide()
		end
	elseif frame.queue == LegendaryItemAlertSystem then
		if not frame.bg then
			frame.bg = B.CreateBG(frame, 25, -22, -25, 22)
			frame.icbg = B.ReskinIcon(frame.Icon)

			frame:HookScript("OnUpdate", Fix_BG)
			frame.Icon:ClearAllPoints()
			frame.Icon:SetPoint("TOPLEFT", frame.bg, 12, -12)
		end
	elseif frame.queue == NewPetAlertSystem or frame.queue == NewMountAlertSystem or frame.queue == NewToyAlertSystem or frame.queue == NewRuneforgePowerAlertSystem then
		if not frame.bg then
			frame.bg = B.CreateBG(frame, 12, -13, -12, 10)
			frame.icbg = B.ReskinIcon(frame.Icon)
		end
	elseif frame.queue == InvasionAlertSystem then
		if not frame.bg then
			local bg, icon = frame:GetRegions()
			bg:Hide()

			frame.bg = B.CreateBG(frame, 6, -6, -6, 6)
			frame.icbg = B.ReskinIcon(icon)
		end
	end

	Strip_Textures(frame)
	Fix_Anim(frame)
end

local function Reskin_StandardRewardAlertFrame(frame)
	if frame.RewardFrames then
		for i = 1, frame.numUsedRewardFrames do
			local reward = frame.RewardFrames[i]
			if not reward.icbg then
				reward.texture:SetInside(nil, 6, 6)
				reward.icbg = B.ReskinIcon(reward.texture)
			end

			select(2, reward:GetRegions()):SetTexture("")
		end
	end
end

local function Reskin_LootWonAlertFrame(frame)
	local lootItem = frame.lootItem
	if not frame.bg then
		frame.bg = B.CreateBG(frame, 10, -10, -10, 10)
		frame.icbg = B.ReskinIcon(lootItem.Icon)
		frame.sibg = B.ReskinIcon(lootItem.SpecIcon)

		Fix_Anim(frame)

		lootItem.SpecIcon:ClearAllPoints()
		lootItem.SpecIcon:SetPoint("TOPLEFT", lootItem.Icon, -5, 5)
	end

	Strip_Textures(frame)
	Strip_Textures(lootItem)
	frame.sibg:SetShown(lootItem.SpecIcon:IsShown() and lootItem.SpecIcon:GetTexture() ~= nil)
end

local function Reskin_MoneyWonAlertFrame(frame)
	if not frame.bg then
		frame.bg = B.CreateBG(frame, 5, -5, -5, 5)
		frame.icbg = B.ReskinIcon(frame.Icon)

		Fix_Anim(frame)
	end

	Strip_Textures(frame)
end

tinsert(C.XMLThemes, function()
	if IsAddOnLoaded("ls_Toasts") then return end

	-- Fix Animation
	hooksecurefunc("AlertFrame_PauseOutAnimation", Fix_BG)

	-- Alert Frame
	hooksecurefunc(AlertFrame, "AddAlertFrame", Reskin_AlertFrame)

	-- Standard Reward
	hooksecurefunc("StandardRewardAlertFrame_AdjustRewardAnchors", Reskin_StandardRewardAlertFrame)

	-- Loot Won
	hooksecurefunc("LootWonAlertFrame_SetUp", Reskin_LootWonAlertFrame)

	-- Money Won
	hooksecurefunc("MoneyWonAlertFrame_SetUp", Reskin_MoneyWonAlertFrame)
end)