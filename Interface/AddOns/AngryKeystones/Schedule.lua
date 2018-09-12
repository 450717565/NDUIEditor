--if GetBuildInfo() == "8.0.1" then return end
local ADDON, Addon = ...
local Mod = Addon:NewModule('Schedule')

local rowCount = 4

local requestKeystoneCheck

-- 1: 溢出, 2: 无常, 3: 火山, 4: 死疽, 5: 繁盛, 6: 暴怒, 7: 激励, 8: 血池, 9: 残暴, 10: 强韧, 11: 崩裂, 12: 重伤, 13: 易爆, 14: 震荡, 15: 冷酷, 16: 共生
local affixSchedule = {
	{  6,  3,  9, 16 },
	{  5, 13, 10, 16 },
	{  7, 12,  9, 16 },
	{  8,  4, 10, 16 },
	{ 11,  2,  9, 16 },
	{  5, 14, 10, 16 },
	{  6,  4,  9, 16 },
	{  7,  2, 10, 16 },
	{  5,  3,  9, 16 },
	{  8, 12, 10, 16 },
	{  7, 13,  9, 16 },
	{ 11, 14, 10, 16 },
}
local currentWeek
local affixOrder = {
	[1] = 3,
	[2] = 1,
	[3] = 2,
	[4] = 4,
}

local function UpdateAffixes()
	if requestKeystoneCheck then
		Mod:CheckInventoryKeystone()
	end
	if currentWeek then
		for i = 1, rowCount do
			local entry = Mod.Frame.Entries[i]
			entry:Show()

			local scheduleWeek = (currentWeek - 2 + i) % (#affixSchedule) + 1
			local affixes = affixSchedule[scheduleWeek]
			for j = 1, #affixes do
				local affix = entry.Affixes[j]
				affix:SetUp(affixes[affixOrder[j]])
			end
		end
		Mod.Frame.Label:Hide()
	else
		for i = 1, rowCount do
			Mod.Frame.Entries[i]:Hide()
		end
		Mod.Frame.Label:Show()
	end
end

local function makeAffix(parent)
	local frame = CreateFrame("Frame", nil, parent)
	frame:SetSize(16, 16)

	local border = frame:CreateTexture(nil, "OVERLAY")
	border:SetAllPoints()
	border:SetAtlas("ChallengeMode-AffixRing-Sm")
	frame.Border = border

	local portrait = frame:CreateTexture(nil, "ARTWORK")
	portrait:SetSize(14, 14)
	portrait:SetPoint("CENTER", border)
	frame.Portrait = portrait

	frame.SetUp = ScenarioChallengeModeAffixMixin.SetUp
	frame:SetScript("OnEnter", ScenarioChallengeModeAffixMixin.OnEnter)
	frame:SetScript("OnLeave", GameTooltip_Hide)

	return frame
end

function Mod:Blizzard_ChallengesUI()
	local frame = CreateFrame("Frame", nil, ChallengesFrame)
	frame:SetSize(170, 110)
	frame:SetPoint("BOTTOMLEFT", 6, 80)
	Mod.Frame = frame

	local bg = frame:CreateTexture(nil, "BACKGROUND")
	bg:SetAllPoints()
	bg:SetAtlas("ChallengeMode-guild-background")
	bg:SetAlpha(.4)

	local title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	title:SetText(Addon.Locale.scheduleTitle)
	title:SetPoint("TOPLEFT", 10, -9)

	local line = frame:CreateTexture(nil, "ARTWORK")
	line:SetSize(160, 1)
	line:SetColorTexture(.5, .5, .5)
	line:SetPoint("TOP", 0, -27)

	local entries = {}
	for i = 1, rowCount do
		local entry = CreateFrame("Frame", nil, frame)
		entry:SetSize(150, 18)

		local text = entry:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		text:SetWidth(100)
		text:SetJustifyH("LEFT")
		text:SetWordWrap(false)
		text:SetText( Addon.Locale["scheduleWeek"..i] )
		text:SetPoint("LEFT")
		entry.Text = text

		local affixes = {}
		local prevAffix
		for j = 4, 1, -1 do
			local affix = makeAffix(entry)
			if prevAffix then
				affix:SetPoint("RIGHT", prevAffix, "LEFT", -4, 0)
			else
				affix:SetPoint("RIGHT")
			end
			prevAffix = affix
			affixes[j] = affix
		end
		entry.Affixes = affixes

		if i == 1 then
			entry:SetPoint("TOP", line, "BOTTOM", 0, -3)
		else
			entry:SetPoint("TOP", entries[i-1], "BOTTOM")
		end

		entries[i] = entry
	end
	frame.Entries = entries

	local label = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	label:SetPoint("TOPLEFT", line, "BOTTOMLEFT", 10, 0)
	label:SetPoint("TOPRIGHT", line, "BOTTOMRIGHT", -10, 0)
	label:SetJustifyH("CENTER")
	label:SetJustifyV("MIDDLE")
	label:SetHeight(72)
	label:SetWordWrap(true)
	label:SetText(Addon.Locale.scheduleMissingKeystone)
	frame.Label = label

	hooksecurefunc("ChallengesFrame_Update", UpdateAffixes)
end

function Mod:CheckInventoryKeystone()
	currentWeek = nil

	C_MythicPlus.RequestCurrentAffixes()
	local affixIds = C_MythicPlus.GetCurrentAffixes()
	if not affixIds then return end
	for index, affixes in ipairs(affixSchedule) do
		if affixIds[1] == affixes[1] and affixIds[2] == affixes[2] then
			currentWeek = index
		end
	end

	requestKeystoneCheck = false
end

function Mod:Startup()
	self:RegisterAddOnLoaded("Blizzard_ChallengesUI")
	requestKeystoneCheck = true
end
