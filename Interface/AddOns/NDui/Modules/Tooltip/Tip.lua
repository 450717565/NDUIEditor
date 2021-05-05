local _, ns = ...
local B, C, L, DB = unpack(ns)
local TT = B:RegisterModule("Tooltip")

local strfind, format, strupper, strlen, pairs, unpack = string.find, string.format, string.upper, string.len, pairs, unpack
local ICON_LIST = ICON_LIST
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
				tiptext:SetText(nil)
				tiptext:Hide()
			elseif linetext == FACTION_HORDE then
				if C.db["Tooltip"]["FactionIcon"] then
					tiptext:SetText(nil)
					tiptext:Hide()
				else
					tiptext:SetText("|cffff5040"..linetext.."|r")
				end
			elseif linetext == FACTION_ALLIANCE then
				if C.db["Tooltip"]["FactionIcon"] then
					tiptext:SetText(nil)
					tiptext:Hide()
				else
					tiptext:SetText("|cff4080ff"..linetext.."|r")
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
		return B.HexRGB(B.UnitColor(unit))..UnitName(unit).."|r"
	end
end

function TT:InsertFactionFrame(faction)
	if not self.factionFrame then
		local f = self:CreateTexture(nil, "OVERLAY")
		f:ClearAllPoints()
		f:SetPoint("BOTTOMRIGHT", 10, 0)
		f:SetBlendMode("ADD")
		f:SetScale(.25)
		self.factionFrame = f
	end
	self.factionFrame:SetTexture("Interface\\Timer\\"..faction.."-Logo")
	self.factionFrame:SetAlpha(.5)
end

local roleTex = {
	["HEALER"] = {.066, .222, .133, .445},
	["TANK"] = {.375, .532, .133, .445},
	["DAMAGER"] = {.660, .813, .133, .445},
}

function TT:InsertRoleFrame(role)
	if not self.role then
		local role = self:CreateTexture(nil, "OVERLAY")
		role:ClearAllPoints()
		role:SetPoint("TOPRIGHT", self, "TOPLEFT", -C.margin, -1)
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
	if self.factionFrame and self.factionFrame:GetAlpha() ~= 0 then
		self.factionFrame:SetAlpha(0)
	end
	if self.role and self.role:GetAlpha() ~= 0 then
		self.role:SetAlpha(0)
		self.icbg:SetAlpha(0)
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
				status = format(" |cffFFCC00<%s>|r", status)
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

		local r, g, b = B.UnitColor(unit)
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

		self.StatusBar:SetStatusBarColor(r, g, b)
	else
		self.StatusBar:SetStatusBarColor(0, .9, 0)
	end

	TT.InspectUnitSpecAndLevel(self)
end

function TT:StatusBar_OnValueChanged(value)
	if self:IsForbidden() or not value then return end
	local min, max = self:GetMinMaxValues()
	if (value < min) or (value > max) then return end

	if not self.text then
		self.text = B.CreateFS(self, 12, "", false, "CENTER", 1, 1)
	end

	if value > 0 and max == 1 then
		self.text:SetFormattedText("%d%%", value*100)
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
	self:SetBackdrop(nil)
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
		self:ClearAllPoints()
		self:SetPoint("BOTTOMRIGHT", mover)
	end
end

-- Fix comparison error on cursor
function TT:GameTooltip_ComparisonFix(anchorFrame, shoppingTooltip1, shoppingTooltip2, _, secondaryItemShown)
	local point = shoppingTooltip1:GetPoint(2)
	if secondaryItemShown then
		if point == "TOP" then
			shoppingTooltip1:ClearAllPoints()
			shoppingTooltip1:SetPoint("TOPLEFT", anchorFrame, "TOPRIGHT", 3, 0)
			shoppingTooltip2:ClearAllPoints()
			shoppingTooltip2:SetPoint("TOPLEFT", shoppingTooltip1, "TOPRIGHT", 3, 0)
		elseif point == "RIGHT" then
			shoppingTooltip1:ClearAllPoints()
			shoppingTooltip1:SetPoint("TOPRIGHT", anchorFrame, "TOPLEFT", -3, 0)
			shoppingTooltip2:ClearAllPoints()
			shoppingTooltip2:SetPoint("TOPRIGHT", shoppingTooltip1, "TOPLEFT", -3, 0)
		end
	else
		if point == "LEFT" then
			shoppingTooltip1:ClearAllPoints()
			shoppingTooltip1:SetPoint("TOPLEFT", anchorFrame, "TOPRIGHT", 3, 0)
		elseif point == "RIGHT" then
			shoppingTooltip1:ClearAllPoints()
			shoppingTooltip1:SetPoint("TOPRIGHT", anchorFrame, "TOPLEFT", -3, 0)
		end
	end
end

-- Tooltip rewards icon
function TT:ReskinRewardIcon()
	local icon = self.Icon or self.icon
	local border = self.Border or self.IconBorder

	if not self.iconStyled then
		if icon then self.icbg = B.ReskinIcon(icon, 1) end
		if border then B.ReskinBorder(border, self.icbg) end

		self.iconStyled = true
	end
end

-- Tooltip status bar
function TT:ReskinStatusBar()
	if not self.StatusBar then return end

	self.StatusBar:ClearAllPoints()
	self.StatusBar:SetPoint("BOTTOMLEFT", self, "TOPLEFT", C.mult, C.margin)
	self.StatusBar:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", -C.mult, C.margin)
	self.StatusBar:SetHeight(6)

	B.ReskinStatusBar(self.StatusBar, true)
end

-- Tooltip skin
local fakeBg = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
fakeBg:SetBackdrop({ bgFile = DB.bgTex, edgeFile = DB.bgTex, edgeSize = 1 })

local function __GetBackdrop() return fakeBg:GetBackdrop() end
local function __GetBackdropColor() return 0, 0, 0, .5 end
local function __GetBackdropBorderColor() return 0, 0, 0 end

function TT:ReskinTooltip()
	if not self then
		if DB.isDeveloper then print("Unknown tooltip spotted.") end
		return
	end

	if self:IsForbidden() then return end
	self:SetScale(C.db["Tooltip"]["TTScale"])

	local frameName = self:GetDebugName()

	if not self.tipStyled then
		if self.SetBackdrop then self:SetBackdrop(nil) end
		self:DisableDrawLayer("BACKGROUND")

		self.bg = B.CreateBG(self)

		TT.ReskinRewardIcon(self)
		TT.ReskinStatusBar(self)

		local closeButton = self.CloseButton or (frameName and _G[frameName.."CloseButton"])
		if closeButton then B.ReskinClose(closeButton) end

		local scrollBar = self.ScrollBar or self.scrollBar
		if scrollBar then B.ReskinScroll(scrollBar) end

		if self.GetBackdrop then
			self.GetBackdrop = __GetBackdrop
			self.GetBackdropColor = __GetBackdropColor
			self.GetBackdropBorderColor = __GetBackdropBorderColor
		end

		self.tipStyled = true
	end

	self.bg:SetBackdropBorderColor(0, 0, 0)
	if C.db["Tooltip"]["ColorBorder"] and self.GetItem then
		local _, item = self:GetItem()
		if item then
			local quality = select(3, GetItemInfo(item))
			local r, g, b = GetItemQualityColor(quality or 1)
			self.bg:SetBackdropBorderColor(r, g, b)
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
			TooltipSetFont(_G["GameTooltipMoneyFrame"..i.."GoldButtonText"], textSize)
			TooltipSetFont(_G["GameTooltipMoneyFrame"..i.."SilverButtonText"], textSize)
			TooltipSetFont(_G["GameTooltipMoneyFrame"..i.."CopperButtonText"], textSize)
		end
	end

	for _, tt in ipairs(GameTooltip.shoppingTooltips) do
		for _, region in pairs {tt:GetRegions()} do
			if region and region:IsObjectType("FontString") then
				TooltipSetFont(region, textSize)
			end
		end
	end
end

function TT:OnLogin()
	fontOutline = C.db["Skins"]["FontOutline"] and "OUTLINE" or ""

	GameTooltip.StatusBar = GameTooltipStatusBar
	GameTooltip:HookScript("OnTooltipCleared", TT.OnTooltipCleared)
	GameTooltip:HookScript("OnTooltipSetUnit", TT.OnTooltipSetUnit)
	GameTooltip.StatusBar:SetScript("OnValueChanged", TT.StatusBar_OnValueChanged)
	hooksecurefunc("GameTooltip_ShowStatusBar", TT.GameTooltip_ShowStatusBar)
	hooksecurefunc("GameTooltip_ShowProgressBar", TT.GameTooltip_ShowProgressBar)
	hooksecurefunc("GameTooltip_SetDefaultAnchor", TT.GameTooltip_SetDefaultAnchor)
	hooksecurefunc("SharedTooltip_SetBackdropStyle", TT.SharedTooltip_SetBackdropStyle)
	hooksecurefunc("GameTooltip_AnchorComparisonTooltips", TT.GameTooltip_ComparisonFix)

	-- Elements
	TT:SetupTooltipFonts()
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
		tip:HookScript("OnShow", TT.ReskinTooltip)
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
			TT.ReskinRewardIcon(self)

			self.styled = true
		end
	end)

	hooksecurefunc("PetBattleUnitTooltip_UpdateForUnit", function(self)
		local nextBuff, nextDebuff = 1, 1
		for i = 1, C_PetBattles_GetNumAuras(self.petOwner, self.petIndex) do
			local _, _, _, isBuff = C_PetBattles_GetAuraInfo(self.petOwner, self.petIndex, i)
			if isBuff and self.Buffs then
				local frame = self.Buffs.frames[nextBuff]
				if frame and frame.Icon then
					B.ReskinIcon(frame.Icon)
				end
				nextBuff = nextBuff + 1
			elseif (not isBuff) and self.Debuffs then
				local frame = self.Debuffs.frames[nextDebuff]
				if frame and frame.Icon then
					local icbg = B.ReskinIcon(frame.Icon)
					B.ReskinSpecialBorder(frame.DebuffBorder, icbg)
				end
				nextDebuff = nextDebuff + 1
			end
		end
	end)

	-- Others
	C_Timer.After(5, function()
		-- BagSync
		if BSYC_EventAlertTooltip then
			TT.ReskinTooltip(BSYC_EventAlertTooltip)
		end
		-- Libs
		if LibDBIconTooltip then
			TT.ReskinTooltip(LibDBIconTooltip)
		end
		if AceConfigDialogTooltip then
			TT.ReskinTooltip(AceConfigDialogTooltip)
		end
		-- TomTom
		if TomTomTooltip then
			TT.ReskinTooltip(TomTomTooltip)
		end
		-- RareScanner
		if RSMapItemToolTip then
			TT.ReskinTooltip(RSMapItemToolTip)
		end
		if LootBarToolTip then
			TT.ReskinTooltip(LootBarToolTip)
		end
		-- Narcissus
		if NarciGameTooltip then
			TT.ReskinTooltip(NarciGameTooltip)
		end
	end)

	if IsAddOnLoaded("BattlePetBreedID") then
		hooksecurefunc("BPBID_SetBreedTooltip", function(parent)
			if parent == FloatingBattlePetTooltip then
				TT.ReskinTooltip(BPBID_BreedTooltip2)
			else
				TT.ReskinTooltip(BPBID_BreedTooltip)
			end
		end)
	end

	if IsAddOnLoaded("MythicDungeonTools") then
		hooksecurefunc(MDT, "ShowInterface", function(self)
			if not self.styled then
				TT.ReskinTooltip(MDT.tooltip)
				TT.ReskinTooltip(MDT.pullTooltip)

				self.styled = true
			end
		end)
	end
end)

TT:RegisterTooltips("Blizzard_DebugTools", function()
	TT.ReskinTooltip(FrameStackTooltip)
	FrameStackTooltip:SetScale(UIParent:GetScale())
	if not DB.isNewPatch then
		TT.ReskinTooltip(EventTraceTooltip)
		EventTraceTooltip:SetParent(UIParent)
		EventTraceTooltip:SetFrameStrata("TOOLTIP")
	end
end)

TT:RegisterTooltips("Blizzard_EventTrace", function()
	TT.ReskinTooltip(EventTraceTooltip)
end)

TT:RegisterTooltips("Blizzard_Collections", function()
	PetJournalPrimaryAbilityTooltip:HookScript("OnShow", TT.ReskinTooltip)
	PetJournalSecondaryAbilityTooltip:HookScript("OnShow", TT.ReskinTooltip)
	PetJournalPrimaryAbilityTooltip.Delimiter1:SetHeight(1)
	PetJournalPrimaryAbilityTooltip.Delimiter1:SetColorTexture(0, 0, 0)
	PetJournalPrimaryAbilityTooltip.Delimiter2:SetHeight(1)
	PetJournalPrimaryAbilityTooltip.Delimiter2:SetColorTexture(0, 0, 0)
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
		tip:HookScript("OnShow", TT.ReskinTooltip)
	end
end)

TT:RegisterTooltips("Blizzard_PVPUI", function()
	ConquestTooltip:HookScript("OnShow", TT.ReskinTooltip)
end)

TT:RegisterTooltips("Blizzard_Contribution", function()
	ContributionBuffTooltip:HookScript("OnShow", TT.ReskinTooltip)
	TT.ReskinRewardIcon(ContributionBuffTooltip)
end)

TT:RegisterTooltips("Blizzard_EncounterJournal", function()
	EncounterJournalTooltip:HookScript("OnShow", TT.ReskinTooltip)
	TT.ReskinRewardIcon(EncounterJournalTooltip.Item1)
	TT.ReskinRewardIcon(EncounterJournalTooltip.Item2)
end)

TT:RegisterTooltips("Blizzard_Calendar", function()
	CalendarContextMenu:HookScript("OnShow", TT.ReskinTooltip)
	CalendarInviteStatusContextMenu:HookScript("OnShow", TT.ReskinTooltip)
end)