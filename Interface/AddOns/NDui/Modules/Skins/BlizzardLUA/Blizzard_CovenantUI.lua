local _, ns = ...
local B, C, L, DB = unpack(ns)
local S = B:GetModule("Skins")

local function Reskin_CovenantPreviewFrame(self)
	B.StripTextures(self.InfoPanel)
	B.StripTextures(self.ModelSceneContainer)

	if not self.bg then
		B.ReskinButton(self.SelectButton)

		B.CreateBDFrame(self.InfoPanel)
		B.CreateBDFrame(self.ModelSceneContainer)

		local Title = self.Title
		Title:DisableDrawLayer("BACKGROUND")
		Title.Text:SetFontObject(SystemFont_Huge1)
		B.ReskinText(Title.Text, 1, .8, 0)

		self.bg = B.ReskinFrame(self)
	end

	self.CloseButton:SetPoint("TOPRIGHT", self.bg, -6, -6)
end

C.LUAThemes["Blizzard_CovenantPreviewUI"] = function()
	local InfoPanel = CovenantPreviewFrame.InfoPanel
	B.ReskinText(InfoPanel.Name, 1, .8, 0)
	B.ReskinText(InfoPanel.Location, 1, 1, 1)
	B.ReskinText(InfoPanel.Description, 1, 1, 1)
	B.ReskinText(InfoPanel.AbilitiesFrame.AbilitiesLabel, 1, .8, 0)
	B.ReskinText(InfoPanel.SoulbindsFrame.SoulbindsLabel, 1, .8, 0)
	B.ReskinText(InfoPanel.CovenantFeatureFrame.Label, 1, .8, 0)

	hooksecurefunc(CovenantPreviewFrame, "TryShow", Reskin_CovenantPreviewFrame)
end

local function Reskin_CovenantFrame(self)
	B.StripTextures(self)

	if not self.styled then
		B.ReskinFrame(self)

		if self.LevelFrame then
			B.StripTextures(self.LevelFrame)
		end

		self.styled = true
	end
end

C.LUAThemes["Blizzard_CovenantRenown"] = function()
	hooksecurefunc(CovenantRenownFrame, "SetUpCovenantData", Reskin_CovenantFrame)
end

local function Replace_Currencies(self)
	for frame in self.currencyFramePool:EnumerateActive() do
		if frame and not frame.styled then
			S.ReplaceIconString(frame.Text)

			frame.styled = true
		end
	end
end

local function Reskin_TalentsList(self)
	for frame in self.talentPool:EnumerateActive() do
		if frame and not frame.styled then
			frame.Border:SetAlpha(0)
			frame.TierBorder:SetAlpha(0)
			frame.Background:SetAlpha(0)

			local icbg = B.ReskinIcon(frame.Icon)
			B.ReskinBorder(frame.IconBorder, icbg)

			local bubg = B.CreateBGFrame(frame, 2, 0, -5, 0, icbg)
			B.ReskinHLTex(frame.Highlight, bubg, true)
			frame.bubg = bubg

			S.ReplaceIconString(frame.InfoText)

			frame.styled = true
		end

		local name = frame.Name
		name:ClearAllPoints()
		name:SetPoint("TOPLEFT", frame.bubg, "TOPLEFT", 3, -3)

		local text = frame.InfoText
		text:ClearAllPoints()
		text:SetPoint("BOTTOMLEFT", frame.bubg, "BOTTOMLEFT", 3, 3)
	end
end

C.LUAThemes["Blizzard_CovenantSanctum"] = function()
	CovenantSanctumFrame:HookScript("OnShow", Reskin_CovenantFrame)

	local UpgradesTab = CovenantSanctumFrame.UpgradesTab
	B.StripTextures(UpgradesTab, 0)
	B.CreateBDFrame(UpgradesTab.Background, 0, 1)
	B.ReskinButton(UpgradesTab.DepositButton)
	Replace_Currencies(UpgradesTab.CurrencyDisplayGroup)
	for _, frame in pairs(UpgradesTab.Upgrades) do
		if frame.TierBorder then
			frame.TierBorder:SetAlpha(0)
		end
	end

	local TalentsList = UpgradesTab.TalentsList
	B.StripTextures(TalentsList, 0)
	B.StripTextures(TalentsList.IntroBox, 0)
	B.CreateBDFrame(TalentsList, 0, 1)
	B.ReskinButton(TalentsList.UpgradeButton)
	hooksecurefunc(TalentsList, "Refresh", Reskin_TalentsList)
end