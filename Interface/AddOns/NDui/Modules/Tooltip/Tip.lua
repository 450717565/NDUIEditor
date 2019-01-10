local _, ns = ...
local B, C, L, DB = unpack(ns)
local module = B:RegisterModule("Tooltip")

function module:OnLogin()
	self:ExtraTipInfo()
	self:TargetedInfo()
	self:AzeriteArmor()
end

local cr, cg, cb = DB.r, DB.g, DB.b

local classification = {
	elite = " |cffFFFF00"..ELITE.."|r",
	rare = " |cffFF00FF"..L["Rare"].."|r",
	rareelite = " |cff00FFFF"..L["Rare"]..ELITE.."|r",
	worldboss = " |cffFF0000"..BOSS.."|r",
}

local strfind, format, strupper, strsplit, pairs = string.find, string.format, string.upper, string.split, pairs
local COALESCED_REALM_TOOLTIP1 = strsplit(FOREIGN_SERVER_LABEL, COALESCED_REALM_TOOLTIP)
local INTERACTIVE_REALM_TOOLTIP1 = strsplit(INTERACTIVE_SERVER_LABEL, INTERACTIVE_REALM_TOOLTIP)

local function getUnit(self)
	local _, unit = self and self:GetUnit()
	if not unit then
		local mFocus = GetMouseFocus()
		unit = mFocus and (mFocus.unit or (mFocus.GetAttribute and mFocus:GetAttribute("unit"))) or "mouseover"
	end
	return unit
end

local function hideLines(self)
	for i = 3, self:NumLines() do
		local tiptext = _G["GameTooltipTextLeft"..i]
		local linetext = tiptext:GetText()
		if linetext then
			if NDuiDB["Tooltip"]["HidePVP"] and linetext == PVP_ENABLED then
				tiptext:SetText(nil)
				tiptext:Hide()
			elseif strfind(linetext, COALESCED_REALM_TOOLTIP1) or strfind(linetext, INTERACTIVE_REALM_TOOLTIP1) then
				tiptext:SetText(nil)
				tiptext:Hide()
				local pretiptext = _G["GameTooltipTextLeft"..i-1]
				pretiptext:SetText(nil)
				pretiptext:Hide()
				self:Show()
			elseif linetext == FACTION_HORDE then
				if NDuiDB["Tooltip"]["HideFaction"] then
					tiptext:SetText(nil)
					tiptext:Hide()
				else
					tiptext:SetText("|cffff5040"..linetext.."|r")
				end
			elseif linetext == FACTION_ALLIANCE then
				if NDuiDB["Tooltip"]["HideFaction"] then
					tiptext:SetText(nil)
					tiptext:Hide()
				else
					tiptext:SetText("|cff4080ff"..linetext.."|r")
				end
			end
		end
	end
end

local function getTarget(unit)
	if UnitIsUnit(unit, "player") then
		return format("|cffff0000%s|r", ">"..strupper(YOU).."<")
	else
		return B.HexRGB(B.UnitColor(unit))..UnitName(unit).."|r"
	end
end

local function InsertFactionFrame(self, faction)
	if not self.factionFrame then
		local f = self:CreateTexture(nil, "OVERLAY")
		f:SetPoint("TOPRIGHT", 0, -5)
		f:SetBlendMode("ADD")
		self.factionFrame = f
	end
	self.factionFrame:SetTexture("Interface\\FriendsFrame\\PlusManz-"..faction)
	self.factionFrame:SetAlpha(.5)
end

local roleTex = {
	["HEALER"] = {.066, .222, .133, .445},
	["TANK"] = {.375, .532, .133, .445},
	["DAMAGER"] = {.66, .813, .133, .445},
}

local function InsertRoleFrame(self, role)
	if not self.roleFrame then
		local f = self:CreateTexture(nil, "OVERLAY")
		f:SetPoint("TOPRIGHT", self, "TOPLEFT", -2, -2)
		f:SetSize(20, 20)
		f:SetTexture("Interface\\LFGFrame\\UI-LFG-ICONS-ROLEBACKGROUNDS")
		B.CreateSD(f, 3, 3)
		self.roleFrame = f
	end
	self.roleFrame:SetTexCoord(unpack(roleTex[role]))
	self.roleFrame:SetAlpha(1)
	self.roleFrame.Shadow:SetAlpha(1)
end

GameTooltip:HookScript("OnTooltipCleared", function(self)
	if self.factionFrame and self.factionFrame:GetAlpha() ~= 0 then
		self.factionFrame:SetAlpha(0)
	end
	if self.roleFrame and self.roleFrame:GetAlpha() ~= 0 then
		self.roleFrame:SetAlpha(0)
		self.roleFrame.Shadow:SetAlpha(0)
	end
end)

GameTooltip:HookScript("OnTooltipSetUnit", function(self)
	if NDuiDB["Tooltip"]["CombatHide"] and InCombatLockdown() then
		return self:Hide()
	end
	hideLines(self)

	local unit = getUnit(self)
	if UnitExists(unit) then
		local hexColor = B.HexRGB(B.UnitColor(unit))
		local ricon = GetRaidTargetIndex(unit)
		if ricon and ricon > 8 then ricon = nil end
		if ricon then
			local text = GameTooltipTextLeft1:GetText()
			GameTooltipTextLeft1:SetFormattedText(("%s %s"), ICON_LIST[ricon].."18|t", text)
		end

		if UnitIsPlayer(unit) then
			local relationship = UnitRealmRelationship(unit)
			if relationship == LE_REALM_RELATION_VIRTUAL then
				self:AppendText(format("|cffcccccc%s|r", INTERACTIVE_SERVER_LABEL))
			end

			local status = (UnitIsAFK(unit) and AFK) or (UnitIsDND(unit) and DND) or (not UnitIsConnected(unit) and PLAYER_OFFLINE)
			if status then
				self:AppendText(format(" |cff00cc00<%s>|r", status))
			end

			if NDuiDB["Tooltip"]["FactionIcon"] then
				local faction = UnitFactionGroup(unit)
				if faction and faction ~= "Neutral" then
					InsertFactionFrame(self, faction)
				end
			end

			if NDuiDB["Tooltip"]["LFDRole"] then
				local role = UnitGroupRolesAssigned(unit)
				if role ~= "NONE" then
					InsertRoleFrame(self, role)
				end
			end

			local guildName, rank, rankIndex, guildRealm = GetGuildInfo(unit)
			local text = GameTooltipTextLeft2:GetText()
			if rank and text then
				rankIndex = rankIndex + 1
				if NDuiDB["Tooltip"]["HideRank"] then
					GameTooltipTextLeft2:SetText("<"..text..">")
				else
					GameTooltipTextLeft2:SetText("<"..text.."> "..rank.."("..rankIndex..")")
				end

				local myGuild, _, _, myGuildRealm = GetGuildInfo("player")
				if IsInGuild() and guildName == myGuild and guildRealm == myGuildRealm then
					GameTooltipTextLeft2:SetTextColor(.25, 1, .25)
				else
					GameTooltipTextLeft2:SetTextColor(.6, .8, 1)
				end
			end
		end

		local line1 = GameTooltipTextLeft1:GetText()
		GameTooltipTextLeft1:SetFormattedText("%s", hexColor..line1)

		local alive = not UnitIsDeadOrGhost(unit)
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
			local tiptextLevel
			for i = 2, self:NumLines() do
				local tiptext = _G["GameTooltipTextLeft"..i]
				local linetext = tiptext:GetText()
				if linetext and strfind(linetext, LEVEL) then
					tiptextLevel = tiptext
				end
			end

			local creature = not UnitIsPlayer(unit) and UnitCreatureType(unit) or ""
			local unitClass = UnitIsPlayer(unit) and format("%s %s", UnitRace(unit) or "", hexColor..(UnitClass(unit) or "").."|r") or ""
			if tiptextLevel then
				tiptextLevel:SetFormattedText(("%s %s%s %s"), textLevel, creature, unitClass, (not alive and "|cffCCCCCC"..DEAD.."|r" or ""))
			end
		end

		if UnitExists(unit.."target") then
			local tarRicon = GetRaidTargetIndex(unit.."target")
			if tarRicon and tarRicon > 8 then tarRicon = nil end
			local tar = format("%s%s", (tarRicon and ICON_LIST[tarRicon].."10|t") or "", getTarget(unit.."target"))
			self:AddLine(TARGET..L[":"]..tar)
		end

		if alive then
			GameTooltipStatusBar:SetStatusBarColor(B.UnitColor(unit))
		else
			GameTooltipStatusBar:Hide()
		end
	else
		GameTooltipStatusBar:SetStatusBarColor(0, .9, 0)
	end

	if GameTooltipStatusBar:IsShown() then
		GameTooltipStatusBar:ClearAllPoints()
		GameTooltipStatusBar:SetPoint("BOTTOMLEFT", self, "TOPLEFT", C.mult, C.mult*2)
		GameTooltipStatusBar:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", -C.mult, C.mult*2)
		if C.mult and not GameTooltipStatusBar.bg then
			GameTooltipStatusBar:SetStatusBarTexture(DB.normTex)
			GameTooltipStatusBar:SetHeight(5)
			local bg = B.CreateBG(GameTooltipStatusBar)
			B.SetBackground(bg)
			GameTooltipStatusBar.bg = bg
		end
	end
end)

GameTooltipStatusBar:SetScript("OnValueChanged", function(self, value)
	if not value then return end
	local min, max = self:GetMinMaxValues()
	if (value < min) or (value > max) then return end

	local unit = getUnit(GameTooltip)
	if UnitExists(unit) then
		min, max = UnitHealth(unit), UnitHealthMax(unit)
		if not self.text then
			self.text = B.CreateFS(self, 12, "", false, "CENTER", 1, 1)
		end
		self.text:Show()
		local hp = B.Numb(min).." / "..B.Numb(max)
		self.text:SetText(hp)
	end
end)

hooksecurefunc("GameTooltip_ShowStatusBar", function(self)
	if self.statusBarPool then
		local bar = self.statusBarPool:Acquire()
		if bar and not bar.styled then
			B.StripTextures(bar, true)
			bar:SetStatusBarColor(cr*.8, cg*.8, cb*.8)

			local tex = select(3, bar:GetRegions())
			tex:SetTexture(DB.normTex)

			local bg = B.CreateBG(bar)
			B.CreateBD(bg, .25)
			B.CreateSD(bg)

			bar.styled = true
		end
	end
end)

hooksecurefunc("GameTooltip_ShowProgressBar", function(self)
	if self.progressBarPool then
		local bar = self.progressBarPool:Acquire()
		if bar and not bar.styled then
			B.StripTextures(bar.Bar, true)
			bar.Bar:SetHeight(20)
			bar.Bar:SetStatusBarTexture(DB.normTex)
			bar.Bar:SetStatusBarColor(cr*.8, cg*.8, cb*.8)
			B.CreateBD(bar.Bar, .25)
			B.CreateSD(bar.Bar)

			bar.styled = true
		end
	end
end)

-- Anchor and mover
local mover
hooksecurefunc("GameTooltip_SetDefaultAnchor", function(tooltip, parent)
	if NDuiDB["Tooltip"]["Cursor"] then
		tooltip:SetOwner(parent, "ANCHOR_CURSOR_RIGHT")
	else
		if not mover then
			mover = B.Mover(tooltip, L["Tooltip"], "GameTooltip", C.Tooltips.TipPos, 240, 120)
		end
		tooltip:SetOwner(parent, "ANCHOR_NONE")
		tooltip:ClearAllPoints()
		tooltip:SetPoint("BOTTOMRIGHT", mover)
	end
end)

-- Tooltip skin
local function getBackdrop(self) return self.bg:GetBackdrop() end
local function getBackdropColor() return 0, 0, 0, .5 end
local function getBackdropBorderColor() return 0, 0, 0 end

function B:ReskinTooltip()
	if not self then
		if DB.isDeveloper then print("Unknown tooltip spotted.") end
		return
	end
	self:SetScale(NDuiDB["Tooltip"]["Scale"])

	if not self.tipStyled then
		self:SetBackdrop(nil)
		self:DisableDrawLayer("BACKGROUND")
		local bg = B.CreateBG(self, 0)
		bg:SetFrameLevel(self:GetFrameLevel())
		B.SetBackground(bg)
		self.bg = bg

		-- other gametooltip-like support
		self.GetBackdrop = getBackdrop
		self.GetBackdropColor = getBackdropColor
		self.GetBackdropBorderColor = getBackdropBorderColor

		self.tipStyled = true
	end

	self.bg:SetBackdropBorderColor(0, 0, 0)
	if NDuiDB["Tooltip"]["ClassColor"] and self.GetItem then
		local _, item = self:GetItem()
		if item then
			local quality = select(3, GetItemInfo(item))
			local color = BAG_ITEM_QUALITY_COLORS[quality or 1]
			if color then
				self.bg:SetBackdropBorderColor(color.r, color.g, color.b)
			end
		end
	end

	if self.NumLines and self:NumLines() > 0 then
		for index = 1, self:NumLines() do
			if index == 1 then
				_G[self:GetName().."TextLeft"..index]:SetFont(DB.TipFont[1], DB.TipFont[2] + 2, DB.TipFont[3])
			else
				_G[self:GetName().."TextLeft"..index]:SetFont(unpack(DB.TipFont))
			end
			_G[self:GetName().."TextRight"..index]:SetFont(unpack(DB.TipFont))
		end
	end
end

hooksecurefunc("GameTooltip_SetBackdropStyle", function(self)
	if not self.tipStyled then return end
	self:SetBackdrop(nil)
end)

local function addonStyled(_, addon)
	if addon == "Blizzard_DebugTools" then
		B.ReskinTooltip(FrameStackTooltip)
		B.ReskinTooltip(EventTraceTooltip)
		FrameStackTooltip:SetScale(UIParent:GetScale())
		EventTraceTooltip:SetParent(UIParent)
		EventTraceTooltip:SetFrameStrata("TOOLTIP")

	elseif addon == "NDui" then
		if IsAddOnLoaded("AuroraClassic") then
			local F = unpack(AuroraClassic)
			F.ReskinClose(FloatingBattlePetTooltip.CloseButton)
			F.ReskinClose(FloatingPetBattleAbilityTooltip.CloseButton)
			F.ReskinClose(FloatingGarrisonMissionTooltip.CloseButton)
			AuroraOptionstooltips:SetAlpha(0)
			AuroraOptionstooltips:Disable()
			AuroraConfig.tooltips = false
		end

		local tooltips = {
			ChatMenu,
			EmoteMenu,
			LanguageMenu,
			VoiceMacroMenu,
			GameTooltip,
			EmbeddedItemTooltip,
			ItemRefTooltip,
			ItemRefShoppingTooltip1,
			ItemRefShoppingTooltip2,
			ShoppingTooltip1,
			ShoppingTooltip2,
			AutoCompleteBox,
			FriendsTooltip,
			WorldMapTooltip,
			WorldMapCompareTooltip1,
			WorldMapCompareTooltip2,
			QuestScrollFrame.StoryTooltip,
			GeneralDockManagerOverflowButtonList,
			ReputationParagonTooltip,
			QuestScrollFrame.WarCampaignTooltip,
			NamePlateTooltip,
			LibDBIconTooltip,
			QueueStatusFrame,
			FloatingGarrisonFollowerTooltip,
			FloatingGarrisonFollowerAbilityTooltip,
			FloatingGarrisonMissionTooltip,
			GarrisonFollowerAbilityTooltip,
			GarrisonFollowerTooltip,
			FloatingGarrisonShipyardFollowerTooltip,
			GarrisonShipyardFollowerTooltip,
			BattlePetTooltip,
			PetBattlePrimaryAbilityTooltip,
			PetBattlePrimaryUnitTooltip,
			FloatingBattlePetTooltip,
			FloatingPetBattleAbilityTooltip,
			IMECandidatesFrame
		}
		for _, f in pairs(tooltips) do
			f:HookScript("OnShow", B.ReskinTooltip)
		end

		-- DropdownMenu
		local function reskinDropdown()
			for _, name in next, {"DropDownList", "L_DropDownList", "Lib_DropDownList"} do
				for i = 1, UIDROPDOWNMENU_MAXLEVELS do
					local menu = _G[name..i.."MenuBackdrop"]
					if menu and not menu.styled then
						menu:HookScript("OnShow", B.ReskinTooltip)
						menu.styled = true
					end
				end
			end
		end
		hooksecurefunc("UIDropDownMenu_CreateFrames", reskinDropdown)

		-- IME
		IMECandidatesFrame.selection:SetVertexColor(cr, cg, cb)

		-- Pet Tooltip
		PetBattlePrimaryUnitTooltip:HookScript("OnShow", function(self)
			self.Border:SetAlpha(0)
			if not self.tipStyled then
				if self.glow then self.glow:Hide() end
				self.Icon:SetTexCoord(unpack(DB.TexCoord))
				self.tipStyled = true
			end
		end)

		hooksecurefunc("PetBattleUnitTooltip_UpdateForUnit", function(self)
			local nextBuff, nextDebuff = 1, 1
			for i = 1, C_PetBattles.GetNumAuras(self.petOwner, self.petIndex) do
				local _, _, _, isBuff = C_PetBattles.GetAuraInfo(self.petOwner, self.petIndex, i)
				if isBuff and self.Buffs then
					local frame = self.Buffs.frames[nextBuff]
					if frame and frame.Icon then
						frame.Icon:SetTexCoord(unpack(DB.TexCoord))
					end
					nextBuff = nextBuff + 1
				elseif (not isBuff) and self.Debuffs then
					local frame = self.Debuffs.frames[nextDebuff]
					if frame and frame.Icon then
						frame.DebuffBorder:Hide()
						frame.Icon:SetTexCoord(unpack(DB.TexCoord))
					end
					nextDebuff = nextDebuff + 1
				end
			end
		end)

		-- MeetingShit
		if IsAddOnLoaded("MeetingStone") then
			B.ReskinTooltip(NetEaseGUI20_Tooltip51)
		end

		if IsAddOnLoaded("BattlePetBreedID") then
			hooksecurefunc("BPBID_SetBreedTooltip", function(parent)
				if parent == FloatingBattlePetTooltip then
					B.ReskinTooltip(BPBID_BreedTooltip2)
				else
					B.ReskinTooltip(BPBID_BreedTooltip)
				end
			end)
		end

		if IsAddOnLoaded("MethodDungeonTools") then
			local styledMDT
			hooksecurefunc(MethodDungeonTools, "ShowInterface", function()
				if not styledMDT then
					B.ReskinTooltip(MethodDungeonTools.tooltip)
					B.ReskinTooltip(MethodDungeonTools.pullTooltip)
					styledMDT = true
				end
			end)
		end

	elseif addon == "Blizzard_Collections" then
		PetJournalPrimaryAbilityTooltip:HookScript("OnShow", B.ReskinTooltip)
		PetJournalSecondaryAbilityTooltip:HookScript("OnShow", B.ReskinTooltip)
		PetJournalPrimaryAbilityTooltip.Delimiter1:SetHeight(1)
		PetJournalPrimaryAbilityTooltip.Delimiter1:SetColorTexture(0, 0, 0)
		PetJournalPrimaryAbilityTooltip.Delimiter2:SetHeight(1)
		PetJournalPrimaryAbilityTooltip.Delimiter2:SetColorTexture(0, 0, 0)

	elseif addon == "Blizzard_GarrisonUI" then
		local gt = {
			GarrisonMissionMechanicTooltip,
			GarrisonMissionMechanicFollowerCounterTooltip,
			GarrisonShipyardMapMissionTooltip,
			GarrisonBonusAreaTooltip,
			GarrisonBuildingFrame.BuildingLevelTooltip,
			GarrisonFollowerAbilityWithoutCountersTooltip,
			GarrisonFollowerMissionAbilityWithoutCountersTooltip
		}
		for _, f in pairs(gt) do
			f:HookScript("OnShow", B.ReskinTooltip)
		end

	elseif addon == "Blizzard_PVPUI" then
		ConquestTooltip:HookScript("OnShow", B.ReskinTooltip)

	elseif addon == "Blizzard_Contribution" then
		ContributionBuffTooltip:HookScript("OnShow", B.ReskinTooltip)
		ContributionBuffTooltip.Icon:SetTexCoord(unpack(DB.TexCoord))
		ContributionBuffTooltip.Border:SetAlpha(0)

	elseif addon == "Blizzard_EncounterJournal" then
		EncounterJournalTooltip:HookScript("OnShow", B.ReskinTooltip)
		EncounterJournalTooltip.Item1.icon:SetTexCoord(unpack(DB.TexCoord))
		EncounterJournalTooltip.Item2.icon:SetTexCoord(unpack(DB.TexCoord))

	elseif addon == "Blizzard_Calendar" then
		CalendarContextMenu:HookScript("OnShow", B.ReskinTooltip)
		CalendarInviteStatusContextMenu:HookScript("OnShow", B.ReskinTooltip)

	elseif addon == "Blizzard_IslandsQueueUI" then
		local tooltip = IslandsQueueFrameTooltip:GetParent()
		tooltip.IconBorder:SetAlpha(0)
		tooltip.Icon:SetTexCoord(unpack(DB.TexCoord))
		tooltip:GetParent():HookScript("OnShow", B.ReskinTooltip)
	end
end
B:RegisterEvent("ADDON_LOADED", addonStyled)