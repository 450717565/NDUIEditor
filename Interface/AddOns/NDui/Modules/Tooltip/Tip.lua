local _, ns = ...
local B, C, L, DB = unpack(ns)
local TT = B:RegisterModule("Tooltip")

local strfind, format, strupper, strlen, pairs, unpack = string.find, string.format, string.upper, string.len, pairs, unpack
local ICON_LIST = ICON_LIST
local HIGHLIGHT_FONT_COLOR = HIGHLIGHT_FONT_COLOR
local PVP, LEVEL, FACTION_HORDE, FACTION_ALLIANCE = PVP, LEVEL, FACTION_HORDE, FACTION_ALLIANCE
local YOU, TARGET, AFK, DND, DEAD, PLAYER_OFFLINE = YOU, TARGET, AFK, DND, DEAD, PLAYER_OFFLINE
local FOREIGN_SERVER_LABEL, INTERACTIVE_SERVER_LABEL = FOREIGN_SERVER_LABEL, INTERACTIVE_SERVER_LABEL
local LE_REALM_RELATION_COALESCED, LE_REALM_RELATION_VIRTUAL = LE_REALM_RELATION_COALESCED, LE_REALM_RELATION_VIRTUAL
local IsShiftKeyDown = IsShiftKeyDown
local UnitIsPVP, UnitFactionGroup, UnitRealmRelationship, UnitGUID = UnitIsPVP, UnitFactionGroup, UnitRealmRelationship, UnitGUID
local UnitIsConnected, UnitIsDeadOrGhost, UnitIsAFK, UnitIsDND = UnitIsConnected, UnitIsDeadOrGhost, UnitIsAFK, UnitIsDND
local InCombatLockdown, IsShiftKeyDown, GetMouseFocus, GetItemInfo = InCombatLockdown, IsShiftKeyDown, GetMouseFocus, GetItemInfo
local GetCreatureDifficultyColor, UnitCreatureType, UnitClassification = GetCreatureDifficultyColor, UnitCreatureType, UnitClassification
local UnitIsWildBattlePet, UnitIsBattlePetCompanion, UnitBattlePetLevel = UnitIsWildBattlePet, UnitIsBattlePetCompanion, UnitBattlePetLevel
local UnitIsPlayer, UnitName, UnitPVPName, UnitClass, UnitRace, UnitLevel = UnitIsPlayer, UnitName, UnitPVPName, UnitClass, UnitRace, UnitLevel
local GetRaidTargetIndex, UnitGroupRolesAssigned, GetGuildInfo, IsInGuild = GetRaidTargetIndex, UnitGroupRolesAssigned, GetGuildInfo, IsInGuild
local C_PetBattles_GetNumAuras, C_PetBattles_GetAuraInfo = C_PetBattles.GetNumAuras, C_PetBattles.GetAuraInfo
local C_ChallengeMode_GetDungeonScoreRarityColor = C_ChallengeMode.GetDungeonScoreRarityColor
local C_PlayerInfo_GetPlayerMythicPlusRatingSummary = C_PlayerInfo.GetPlayerMythicPlusRatingSummary

local fontOutline
local cr, cg, cb = DB.cr, DB.cg, DB.cb
local reputationsList = {}
local reputationsColor = {}

function TT:UpdateReputations()
	for i = 1, GetNumFactions() do
		local name, _, standingID, barMin, barMax, barValue, _, _, isHeader, _, _, _, _, factionID = GetFactionInfo(i)
		local curValue, maxValue = barValue - barMin, barMax - barMin
		local label = _G["FACTION_STANDING_LABEL"..standingID]

		if name and factionID then
			local friendID, _, _, _, _, _, friendTextLevel = GetFriendshipReputation(factionID)
			local currentValue, threshold = C_Reputation.GetFactionParagonInfo(factionID)
			local isParagon = C_Reputation.IsFactionParagon(factionID)

			if currentValue then
				reputationsList[name] = format("%s %d / %d", L["Paragon"]..floor(currentValue/threshold), mod(currentValue, threshold), threshold)
			elseif maxValue > 0 then
				reputationsList[name] = format("%s %d / %d", friendTextLevel or label, curValue, maxValue)
			else
				reputationsList[name] = format("%s", friendTextLevel or label)
			end

			local r, g, b = B.SmoothColor(standingID, MAX_REPUTATION_REACTION)
			if isParagon then
				r, g, b = 0, .6, 1
			elseif friendID then
				r, g, b = 0, 1, 1
			end

			reputationsColor[name] = {fr = r, fg = g, fb = b}
		end
	end
end
B:RegisterEvent("PLAYER_LOGIN", TT.UpdateReputations)
B:RegisterEvent("PLAYER_ENTERING_WORLD", TT.UpdateReputations)
B:RegisterEvent("UPDATE_FACTION", TT.UpdateReputations)

function TT:GetFactionLine()
	for i = 2, self:NumLines() do
		local tiptext = _G["GameTooltipTextLeft"..i]
		local linetext = tiptext:GetText()
		local factionString = linetext and reputationsList[linetext]
		local factionColors = linetext and reputationsColor[linetext]
		if factionString then
			return tiptext, linetext, factionString, factionColors
		end
	end
end

local classification = {
	elite = " |cffFFFF00"..ELITE.."|r",
	rare = " |cffFF00FF"..L["Rare"].."|r",
	rareelite = " |cff00FFFF"..L["Rare"]..ELITE.."|r",
	worldboss = " |cffFF0000"..BOSS.."|r",
}

function TT:GetUnit()
	local _, unit = self and self:GetUnit()
	if not unit then
		local mFocus = GetMouseFocus()
		unit = mFocus and (mFocus.unit or (mFocus.GetAttribute and mFocus:GetAttribute("unit"))) or "mouseover"
	end
	return unit
end

function TT:HideLines()
	for i = 3, self:NumLines() do
		local tiptext = _G["GameTooltipTextLeft"..i]
		local linetext = tiptext:GetText()
		if linetext then
			if linetext == PVP then
				tiptext:SetText("")
				tiptext:Hide()
			elseif linetext == FACTION_HORDE then
				if C.db["Tooltip"]["FactionIcon"] then
					tiptext:SetText("")
					tiptext:Hide()
				else
					tiptext:SetText("|cffFF5040"..linetext.."|r")
				end
			elseif linetext == FACTION_ALLIANCE then
				if C.db["Tooltip"]["FactionIcon"] then
					tiptext:SetText("")
					tiptext:Hide()
				else
					tiptext:SetText("|cff4080FF"..linetext.."|r")
				end
			end
		end
	end
end

function TT:GetLevelLine()
	for i = 2, self:NumLines() do
		local tiptext = _G["GameTooltipTextLeft"..i]
		local linetext = tiptext:GetText()
		if linetext and strfind(linetext, LEVEL) then
			return tiptext
		end
	end
end

function TT:GetTarget(unit)
	if UnitIsUnit(unit, "player") then
		return format("|cffFF0000%s|r", ">"..strupper(YOU).."<")
	else
		return B.HexRGB(B.GetUnitColor(unit))..UnitName(unit).."|r"
	end
end

function TT:InsertFactionFrame(faction)
	if not self.logo then
		local logo = self:CreateTexture(nil, "OVERLAY")
		B.UpdatePoint(logo, "BOTTOMRIGHT", self, "BOTTOMRIGHT", 10, 0)
		logo:SetBlendMode("ADD")
		logo:SetScale(.25)
		self.logo = logo
	end
	self.logo:SetTexture("Interface\\Timer\\"..faction.."-Logo")
	self.logo:SetAlpha(.5)
end

local roleTex = {
	["HEALER"] = {.066, .222, .133, .445},
	["TANK"] = {.375, .532, .133, .445},
	["DAMAGER"] = {.660, .813, .133, .445},
}

function TT:InsertRoleFrame(role)
	if not self.role then
		local role = self:CreateTexture(nil, "OVERLAY")
		B.UpdatePoint(role, "TOPRIGHT", self, "TOPLEFT", -C.margin, -1)
		role:SetSize(25, 25)
		role:SetTexture("Interface\\LFGFrame\\UI-LFG-ICONS-ROLEBACKGROUNDS")
		self.role = role

		self.icbg = B.CreateBDFrame(role, 1, -C.mult)
	end
	self.role:SetTexCoord(unpack(roleTex[role]))
	self.role:SetAlpha(1)
	self.icbg:SetAlpha(1)
end

function TT:OnTooltipCleared()
	if self.logo and self.logo:GetAlpha() ~= 0 then
		self.logo:SetAlpha(0)
	end
	if self.role and self.role:GetAlpha() ~= 0 then
		self.role:SetAlpha(0)
		self.icbg:SetAlpha(0)
	end
end

function TT:ShowUnitMythicPlusScore(unit)
	if not C.db["Tooltip"]["MDScore"] then return end

	local summary = C_PlayerInfo_GetPlayerMythicPlusRatingSummary(unit)
	local score = summary and summary.currentSeasonScore
	if score and score > 0 then
		local color = C_ChallengeMode_GetDungeonScoreRarityColor(score) or HIGHLIGHT_FONT_COLOR
		GameTooltip:AddLine(format(L["MythicScore"], color:WrapTextInColorCode(score)))
	end
end

function TT:OnTooltipSetUnit()
	if self:IsForbidden() then return end
	if C.db["Tooltip"]["CombatHide"] and InCombatLockdown() then self:Hide() return end
	TT.HideLines(self)

	local unit = TT.GetUnit(self)
	if UnitExists(unit) then
		local guid = UnitGUID(unit)
		local npcID = B.GetNPCID(guid)
		local name, realm = UnitName(unit)
		local dead = UnitIsDeadOrGhost(unit)

		local ricon = GetRaidTargetIndex(unit)
		local text = GameTooltipTextLeft1:GetText()
		if ricon and ricon > 8 then ricon = nil end
		if ricon and text then
			GameTooltipTextLeft1:SetFormattedText(("%s %s"), ICON_LIST[ricon].."18|t", text)
		end

		local isPlayer = UnitIsPlayer(unit)
		if isPlayer then
			local pvpName = UnitPVPName(unit)
			local relationship = UnitRealmRelationship(unit)
			if not C.db["Tooltip"]["HideTitle"] and pvpName then
				name = pvpName
			end
			if realm and realm ~= "" then
				if IsShiftKeyDown() or not C.db["Tooltip"]["HideRealm"] then
					name = name.."-"..realm
				elseif relationship == LE_REALM_RELATION_COALESCED then
					name = name..FOREIGN_SERVER_LABEL
				elseif relationship == LE_REALM_RELATION_VIRTUAL then
					name = name..INTERACTIVE_SERVER_LABEL
				end
			end

			local status = (UnitIsAFK(unit) and AFK) or (UnitIsDND(unit) and DND) or (not UnitIsConnected(unit) and PLAYER_OFFLINE)
			if status then
				status = format(" |cffFFFF00<%s>|r", status)
			end
			GameTooltipTextLeft1:SetFormattedText("%s", name..(status or ""))

			if C.db["Tooltip"]["FactionIcon"] then
				local faction = UnitFactionGroup(unit)
				if faction and faction ~= "Neutral" then
					TT.InsertFactionFrame(self, faction)
				end
			end

			if C.db["Tooltip"]["LFDRole"] then
				local role = UnitGroupRolesAssigned(unit)
				if role ~= "NONE" then
					TT.InsertRoleFrame(self, role)
				end
			end

			local guildName, rank, rankIndex, guildRealm = GetGuildInfo(unit)
			local hasText = GameTooltipTextLeft2:GetText()
			if guildName and hasText then
				local myGuild, _, _, myGuildRealm = GetGuildInfo("player")
				if IsInGuild() and guildName == myGuild and guildRealm == myGuildRealm then
					B.ReskinText(GameTooltipTextLeft2, .25, 1, .25)
				else
					B.ReskinText(GameTooltipTextLeft2, .6, .8, 1)
				end

				rankIndex = rankIndex + 1
				if C.db["Tooltip"]["HideRank"] then rank = "" end
				if guildRealm and IsShiftKeyDown() then
					guildName = guildName.."-"..guildRealm
				end
				if C.db["Tooltip"]["HideJunkGuild"] and not IsShiftKeyDown() then
					if strlen(guildName) > 31 then guildName = "..." end
				end
				GameTooltipTextLeft2:SetText("<"..guildName.."> "..rank.."("..rankIndex..")")
			end
		else
			local tiptextFaction, factionName, factionString, factionColors = TT.GetFactionLine(self)
			if tiptextFaction then
				tiptextFaction:SetFormattedText("%s %s", factionName, factionString)
				tiptextFaction:SetTextColor(factionColors.fr, factionColors.fg, factionColors.fb)
			end

			if DB.isDeveloper and IsShiftKeyDown() and npcID then
				print(format("|cff00FF00%s %s|r", name, npcID))
			end
		end

		local r, g, b = B.GetUnitColor(unit)
		local hexColor = B.HexRGB(r, g, b)
		local line = GameTooltipTextLeft1:GetText()
		GameTooltipTextLeft1:SetFormattedText("%s", hexColor..line)

		local level
		if UnitIsWildBattlePet(unit) or UnitIsBattlePetCompanion(unit) then
			level = UnitBattlePetLevel(unit)
		else
			level = UnitLevel(unit)
		end

		if level then
			local boss
			if level <= 0 then boss = "|cffFF0000"..BOSS.."|r" end

			local diff = GetCreatureDifficultyColor(level)
			local classify = UnitClassification(unit)
			local textLevel = format("%s%s%s|r", B.HexRGB(diff), boss or format("%d", level), classification[classify] or "")
			local tiptextLevel = TT.GetLevelLine(self)
			if tiptextLevel then
				local pvpFlag = isPlayer and UnitIsPVP(unit) and format(" |cffFF0000%s|r", PVP) or ""
				local unitClass = isPlayer and format("%s %s", hexColor..(UnitClass(unit) or "").."|r", UnitRace(unit) or "") or UnitCreatureType(unit) or ""
				tiptextLevel:SetFormattedText(("%s%s %s %s%s"), textLevel, pvpFlag, unitClass, (not isPlayer and DB.InfoColor..npcID.."|r" or ""), (dead and " |cffC0C0C0"..DEAD.."|r" or ""))
			end
		end

		if UnitExists(unit.."target") then
			local tarRicon = GetRaidTargetIndex(unit.."target")
			if tarRicon and tarRicon > 8 then tarRicon = nil end
			local tar = format("%s%s", (tarRicon and ICON_LIST[tarRicon].."10|t") or "", TT:GetTarget(unit.."target"))
			self:AddLine(TARGET.."："..tar)
		end

		TT.InspectUnitSpecAndLevel(self, unit)
		TT.ShowUnitMythicPlusScore(self, unit)

		self.StatusBar:SetStatusBarColor(r, g, b)
	else
		self.StatusBar:SetStatusBarColor(0, .9, 0)
	end
end

function TT:OnValueChanged(value)
	if self:IsForbidden() or not value then return end
	local min, max = self:GetMinMaxValues()
	if (value < min) or (value > max) then return end

	if not self.text then
		self.text = B.CreateFS(self, 12, "", false, "CENTER", 1, 1)
	end

	if value > 0 and max == 1 then
		self.text:SetFormattedText("%.1f%%", value*100)
	else
		self.text:SetText(B.FormatNumb(value)..DB.Separator..B.FormatNumb(max))
	end
end

function TT:GameTooltip_ShowStatusBar()
	if not self or self:IsForbidden() then return end
	if not self.statusBarPool then return end

	local bar = self.statusBarPool:GetNextActive()
	if bar and not bar.styled then
		B.ReskinStatusBar(bar)

		bar.styled = true
	end
end

function TT:GameTooltip_ShowProgressBar()
	if not self or self:IsForbidden() then return end
	if not self.progressBarPool then return end

	local bar = self.progressBarPool:GetNextActive()
	if bar and not bar.styled then
		bar.Bar:SetHeight(20)
		B.ReskinStatusBar(bar.Bar)

		bar.styled = true
	end
end

function TT:SharedTooltip_SetBackdropStyle()
	if not self.tipStyled then return end
	self:SetBackdrop("")
end

-- Anchor and mover
local mover
function TT:GameTooltip_SetDefaultAnchor(parent)
	if self:IsForbidden() then return end
	if not parent then return end

	if C.db["Tooltip"]["Cursor"] then
		self:SetOwner(parent, "ANCHOR_CURSOR_RIGHT")
	else
		if not mover then
			mover = B.Mover(self, L["Tooltip"], "GameTooltip", C.Tooltips.TooltipPos, 240, 120)
		end
		self:SetOwner(parent, "ANCHOR_NONE")
		B.UpdatePoint(self, "BOTTOMRIGHT", mover, "BOTTOMRIGHT")
	end
end

-- Fix comparison error on cursor
function TT:GameTooltip_AnchorComparisonTooltips(anchorFrame, shoppingTooltip1, shoppingTooltip2, _, secondaryItemShown)
	local point = shoppingTooltip1:GetPoint(2)
	if secondaryItemShown then
		if point == "TOP" then
			B.UpdatePoint(shoppingTooltip1, "TOPLEFT", anchorFrame, "TOPRIGHT", 3, 0)
			B.UpdatePoint(shoppingTooltip2, "TOPLEFT", shoppingTooltip1, "TOPRIGHT", 3, 0)
		elseif point == "RIGHT" then
			B.UpdatePoint(shoppingTooltip1, "TOPRIGHT", anchorFrame, "TOPLEFT", -3, 0)
			B.UpdatePoint(shoppingTooltip2, "TOPRIGHT", shoppingTooltip1, "TOPLEFT", -3, 0)
		end
	else
		if point == "LEFT" then
			B.UpdatePoint(shoppingTooltip1, "TOPLEFT", anchorFrame, "TOPRIGHT", 3, 0)
		elseif point == "RIGHT" then
			B.UpdatePoint(shoppingTooltip1, "TOPRIGHT", anchorFrame, "TOPLEFT", -3, 0)
		end
	end
end

local function TooltipSetFont(font, size)
	font:SetFont(DB.Font[1], size, fontOutline)
end

function TT:SetupTooltipFonts()
	local textSize = DB.Font[2] + 2
	local headerSize = DB.Font[2] + 4

	TooltipSetFont(GameTooltipHeaderText, headerSize)
	TooltipSetFont(GameTooltipText, textSize)
	TooltipSetFont(GameTooltipTextSmall, textSize)

	if GameTooltip.hasMoney then
		for i = 1, GameTooltip.numMoneyFrames do
			TooltipSetFont(_G["GameTooltipMoneyFrame"..i.."PrefixText"], textSize)
			TooltipSetFont(_G["GameTooltipMoneyFrame"..i.."SuffixText"], textSize)
		end
	else
		SetTooltipMoney(GameTooltip, 1, nil, "", "")
		SetTooltipMoney(GameTooltip, 1, nil, "", "")
		GameTooltip_ClearMoney(GameTooltip)
	end

	for _, tt in pairs(GameTooltip.shoppingTooltips) do
		local regions = {tt:GetRegions()}
		for _, region in pairs(regions) do
			if region and region:IsObjectType("FontString") then
				TooltipSetFont(region, textSize)
			end
		end
	end
end

function TT:OnTooltipSetItem()
	for i = 1, self:NumLines() do
		local line = _G["GameTooltipTextLeft"..i]
		if not line.fixed then
			if line:GetWrappedWidth() <= line:GetStringWidth() then
				line:SetWidth(line:GetWidth() + 2)
			end

			line.fixed = true
		end
	end
end

function TT:GameTooltip_AddWidgetSet()
	if self.widgetContainer then
		for frame in self.widgetContainer.widgetPools:EnumerateActive() do
			local text = frame.Text
			if not frame.fixed then
				if text:GetWrappedWidth() <= text:GetStringWidth() then
					text:SetWidth(text:GetWidth() + 2)
				end

				frame.fixed = true
			end
		end
	end
end

function TT:OnLogin()
	fontOutline = C.db["Skins"]["FontOutline"] and "OUTLINE" or ""

	TT:SetupTooltipFonts()

	GameTooltip.StatusBar = GameTooltipStatusBar
	GameTooltip.StatusBar:SetScript("OnValueChanged", TT.OnValueChanged)
	GameTooltip:HookScript("OnTooltipCleared", TT.OnTooltipCleared)
	GameTooltip:HookScript("OnTooltipSetItem", TT.OnTooltipSetItem)
	GameTooltip:HookScript("OnTooltipSetUnit", TT.OnTooltipSetUnit)
	hooksecurefunc("GameTooltip_AddWidgetSet", TT.GameTooltip_AddWidgetSet)
	hooksecurefunc("GameTooltip_AnchorComparisonTooltips", TT.GameTooltip_AnchorComparisonTooltips)
	hooksecurefunc("GameTooltip_SetDefaultAnchor", TT.GameTooltip_SetDefaultAnchor)
	hooksecurefunc("GameTooltip_ShowProgressBar", TT.GameTooltip_ShowProgressBar)
	hooksecurefunc("GameTooltip_ShowStatusBar", TT.GameTooltip_ShowStatusBar)
	hooksecurefunc("SharedTooltip_SetBackdropStyle", TT.SharedTooltip_SetBackdropStyle)

	-- Elements
	TT:ReskinTooltipIcons()
	TT:SetupTooltipID()
	TT:TargetedInfo()
	TT:AzeriteArmor()
	TT:ConduitCollectionData()
end

-- Tooltip Skin Registration
local tipTable = {}
function TT:RegisterTooltips(addon, func)
	tipTable[addon] = func
end
local function addonStyled(_, addon)
	if tipTable[addon] then
		tipTable[addon]()
		tipTable[addon] = nil
	end
end
B:RegisterEvent("ADDON_LOADED", addonStyled)

TT:RegisterTooltips("NDui", function()
	local tooltips = {
		AutoCompleteBox,
		BattlePetTooltip,
		ChatMenu,
		EmbeddedItemTooltip,
		EmoteMenu,
		FloatingBattlePetTooltip,
		FloatingGarrisonFollowerAbilityTooltip,
		FloatingGarrisonFollowerTooltip,
		FloatingGarrisonMissionTooltip,
		FloatingGarrisonShipyardFollowerTooltip,
		FloatingPetBattleAbilityTooltip,
		FriendsTooltip,
		GameTooltip,
		GarrisonFollowerAbilityTooltip,
		GarrisonFollowerTooltip,
		GarrisonShipyardFollowerTooltip,
		GeneralDockManagerOverflowButtonList,
		IMECandidatesFrame,
		ItemRefShoppingTooltip1,
		ItemRefShoppingTooltip2,
		ItemRefTooltip,
		LanguageMenu,
		NamePlateTooltip,
		PetBattlePrimaryAbilityTooltip,
		PetBattlePrimaryUnitTooltip,
		QuestScrollFrame.CampaignTooltip,
		QuestScrollFrame.StoryTooltip,
		QueueStatusFrame,
		QuickKeybindTooltip,
		ReputationParagonTooltip,
		ShoppingTooltip1,
		ShoppingTooltip2,
		VoiceMacroMenu,
	}
	for _, tip in pairs(tooltips) do
		tip:HookScript("OnShow", B.ReskinTooltip)
	end

	ItemRefTooltip:HookScript("OnShow", function(self)
		if ItemRefCloseButton and not self.styled then
			B.ReskinClose(ItemRefCloseButton)

			self.styled = true
		end
	end)

	-- IME
	IMECandidatesFrame.selection:SetVertexColor(cr, cg, cb)

	-- Pet Tooltip
	PetBattlePrimaryUnitTooltip:HookScript("OnShow", function(self)
		if not self.styled then
			if self.glow then self.glow:Hide() end
			B.ReskinTTReward(self)

			self.styled = true
		end
	end)

	hooksecurefunc("PetBattleUnitTooltip_UpdateForUnit", function(self)
		local nextBuff, nextDebuff = 1, 1
		for i = 1, C_PetBattles_GetNumAuras(self.petOwner, self.petIndex) do
			local _, _, _, isBuff = C_PetBattles_GetAuraInfo(self.petOwner, self.petIndex, i)
			if isBuff and self.Buffs then
				local frame = self.Buffs.frames[nextBuff]
				if frame and not frame.styled then
					B.ReskinIcon(frame.Icon)

					frame.styled = true
				end
				nextBuff = nextBuff + 1
			elseif (not isBuff) and self.Debuffs then
				local frame = self.Debuffs.frames[nextDebuff]
				if frame and not frame.styled then
					local icbg = B.ReskinIcon(frame.Icon)
					B.ReskinBorder(frame.DebuffBorder, icbg, nil, true)

					frame.styled = true
				end
				nextDebuff = nextDebuff + 1
			end
		end
	end)

	-- Others
	C_Timer.After(5, function()
		-- BagSync
		if BSYC_EventAlertTooltip then
			B.ReskinTooltip(BSYC_EventAlertTooltip)
		end
		-- Libs
		if LibDBIconTooltip then
			B.ReskinTooltip(LibDBIconTooltip)
		end
		if AceConfigDialogTooltip then
			B.ReskinTooltip(AceConfigDialogTooltip)
		end
		-- TomTom
		if TomTomTooltip then
			B.ReskinTooltip(TomTomTooltip)
		end
		-- RareScanner
		if RSMapItemToolTip then
			B.ReskinTooltip(RSMapItemToolTip)
		end
		if LootBarToolTip then
			B.ReskinTooltip(LootBarToolTip)
		end
		-- Narcissus
		if NarciGameTooltip then
			B.ReskinTooltip(NarciGameTooltip)
		end
	end)

	if IsAddOnLoaded("BattlePetBreedID") then
		hooksecurefunc("BPBID_SetBreedTooltip", function(parent)
			if parent == FloatingBattlePetTooltip then
				B.ReskinTooltip(BPBID_BreedTooltip2)
			else
				B.ReskinTooltip(BPBID_BreedTooltip)
			end
		end)
	end

	if IsAddOnLoaded("MythicDungeonTools") then
		hooksecurefunc(MDT, "ShowInterface", function(self)
			if not self.styled then
				B.ReskinTooltip(MDT.tooltip)
				B.ReskinTooltip(MDT.pullTooltip)

				self.styled = true
			end
		end)
	end
end)

TT:RegisterTooltips("Blizzard_DebugTools", function()
	B.ReskinTooltip(FrameStackTooltip)
	FrameStackTooltip:SetScale(UIParent:GetScale())
end)

TT:RegisterTooltips("Blizzard_EventTrace", function()
	B.ReskinTooltip(EventTraceTooltip)
end)

TT:RegisterTooltips("Blizzard_Collections", function()
	PetJournalPrimaryAbilityTooltip:HookScript("OnShow", B.ReskinTooltip)
	PetJournalSecondaryAbilityTooltip:HookScript("OnShow", B.ReskinTooltip)
	PetJournalPrimaryAbilityTooltip.Delimiter1:SetHeight(C.mult)
	PetJournalPrimaryAbilityTooltip.Delimiter1:SetColorTexture(0, 0, 0, 1)
	PetJournalPrimaryAbilityTooltip.Delimiter2:SetHeight(C.mult)
	PetJournalPrimaryAbilityTooltip.Delimiter2:SetColorTexture(0, 0, 0, 1)
end)

TT:RegisterTooltips("Blizzard_GarrisonUI", function()
	local garrisonTips = {
		GarrisonBonusAreaTooltip,
		GarrisonBuildingFrame.BuildingLevelTooltip,
		GarrisonFollowerAbilityWithoutCountersTooltip,
		GarrisonFollowerMissionAbilityWithoutCountersTooltip,
		GarrisonMissionMechanicFollowerCounterTooltip,
		GarrisonMissionMechanicTooltip,
		GarrisonShipyardMapMissionTooltip,
	}
	for _, tip in pairs(garrisonTips) do
		tip:HookScript("OnShow", B.ReskinTooltip)
	end
end)

TT:RegisterTooltips("Blizzard_PVPUI", function()
	ConquestTooltip:HookScript("OnShow", B.ReskinTooltip)
end)

TT:RegisterTooltips("Blizzard_Contribution", function()
	ContributionBuffTooltip:HookScript("OnShow", B.ReskinTooltip)
	B.ReskinTTReward(ContributionBuffTooltip)
end)

TT:RegisterTooltips("Blizzard_EncounterJournal", function()
	EncounterJournalTooltip:HookScript("OnShow", B.ReskinTooltip)
	B.ReskinTTReward(EncounterJournalTooltip.Item1)
	B.ReskinTTReward(EncounterJournalTooltip.Item2)
end)

TT:RegisterTooltips("Blizzard_Calendar", function()
	CalendarContextMenu:HookScript("OnShow", B.ReskinTooltip)
	CalendarInviteStatusContextMenu:HookScript("OnShow", B.ReskinTooltip)
end)