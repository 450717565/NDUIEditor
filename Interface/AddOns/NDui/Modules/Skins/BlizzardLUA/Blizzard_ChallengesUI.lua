local _, ns = ...
local B, C, L, DB = unpack(ns)

local styled
local function Reskin_ChallengesFrame(self)
	for i = 1, #self.maps do
		local button = self.DungeonIcons[i]
		if button and not button.styled then
			button:GetRegions():Hide()
			local bg = B.CreateBDFrame(button)
			button.Icon:SetTexCoord(unpack(DB.TexCoord))
			button.Icon:SetInside(bg)

			button.styled = true
		end

		if i == 1 then
			self.DungeonIcons[i]:ClearAllPoints()
			self.DungeonIcons[i]:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", B.Scale(2), B.Scale(2))

			local SeasonBest = self.WeeklyInfo.Child.SeasonBest
			SeasonBest:ClearAllPoints()
			SeasonBest:SetPoint("BOTTOMLEFT", self.DungeonIcons[i], "TOPLEFT", 0, 3)
		end
	end

	if IsAddOnLoaded("AngryKeystones") then
		if not styled then
			local Schedule = AngryKeystones.Modules.Schedule
			local AffixFrame = Schedule.AffixFrame
			local PartyFrame = Schedule.PartyFrame

			B.StripTextures(AffixFrame)
			B.CreateBDFrame(AffixFrame)
			if AffixFrame.Entries then
				for i = 1, 3 do
					B.ReskinAffixes(AffixFrame.Entries[i])
				end
			end

			B.StripTextures(PartyFrame)
			B.CreateBDFrame(PartyFrame)

			styled = true
		end
	end
end

local function Reskin_WeeklyInfo(self)
	local affixes = C_MythicPlus.GetCurrentAffixes()
	if affixes then
		B.ReskinAffixes(self.Child)
	end
end

local function Reskin_KeystoneFrame(self)
	self:GetRegions():Hide()
	self.InstructionBackground:Hide()
end

local function Reskin_AffixsSetUp(_, affixID)
	local _, _, texture = C_ChallengeMode.GetAffixInfo(affixID)
	if texture then
		ChallengesFrame.SeasonChangeNoticeFrame.Affix.Portrait:SetTexture(texture)
	end
end

C.LUAThemes["Blizzard_ChallengesUI"] = function()
	B.StripTextures(ChallengesFrame)

	ChallengesFrame.WeeklyInfo:SetInside()
	ChallengesFrame.Background:SetInside()

	hooksecurefunc("ChallengesFrame_Update", Reskin_ChallengesFrame)
	hooksecurefunc(ChallengesFrame.WeeklyInfo, "SetUp", Reskin_WeeklyInfo)

	local keystoneFrame = ChallengesKeystoneFrame
	B.ReskinFrame(keystoneFrame)
	B.ReskinButton(keystoneFrame.StartButton)

	hooksecurefunc(keystoneFrame, "Reset", Reskin_KeystoneFrame)
	hooksecurefunc(keystoneFrame, "OnKeystoneSlotted", B.ReskinAffixes)

	-- New season
	local season = ChallengesFrame.SeasonChangeNoticeFrame
	B.ReskinButton(season.Leave)
	B.ReskinText(season.NewSeason, 1, .8, 0)
	B.ReskinText(season.SeasonDescription, 1, 1, 1)
	B.ReskinText(season.SeasonDescription2, 1, 1, 1)
	B.ReskinText(season.SeasonDescription3, 1, .8, 0)

	local Affix = season.Affix
	B.StripTextures(Affix)
	local icbg = B.ReskinIcon(Affix.Portrait)
	icbg:SetFrameLevel(Affix:GetFrameLevel())

	hooksecurefunc(Affix, "SetUp", Reskin_AffixsSetUp)
end