local _, ns = ...
local B, C, L, DB = unpack(ns)

local oUF = ns.oUF
local UF = B:GetModule("UnitFrames")
local format, tostring = string.format, tostring

-- Units
local function SetUnitFrameSize(self, unit)
	local width = C.db["UFs"][unit.."Width"]
	local height = C.db["UFs"][unit.."Height"] + C.db["UFs"][unit.."PowerHeight"] + C.mult
	self:SetSize(width, height)
end

local function CreatePlayerStyle(self)
	self.mystyle = "player"
	SetUnitFrameSize(self, "Player")

	UF:CreateHeader(self)
	UF:CreateHealthBar(self)
	UF:CreateHealthText(self)
	UF:CreatePowerBar(self)
	UF:CreatePowerText(self)
	UF:CreatePortrait(self)
	UF:CreateCastBar(self)
	UF:CreateRaidMark(self)
	UF:CreateIcons(self)
	UF:CreatePrediction(self)
	UF:CreateFCT(self)
	UF:CreateAddPower(self)
	UF:CreateQuestSync(self)

	if C.db["UFs"]["Castbars"] then
		UF:ReskinMirrorBars()
		UF:ReskinTimerTrakcer(self)
	end
	if C.db["UFs"]["ClassPower"] and not C.db["Nameplate"]["ShowPlayerPlate"] then
		UF:CreateClassPower(self)
		UF:StaggerBar(self)
	end
	if not C.db["Misc"]["ExpRep"] then UF:CreateExpRepBar(self) end
	if C.db["UFs"]["PlayerDebuff"] then UF:CreateDebuffs(self) end
	if C.db["UFs"]["SwingBar"] then UF:CreateSwing(self) end
	if C.db["UFs"]["QuakeTimer"] then UF:CreateQuakeTimer(self) end
end

local function CreateTargetStyle(self)
	self.mystyle = "target"
	SetUnitFrameSize(self, "Player")

	UF:CreateHeader(self)
	UF:CreateHealthBar(self)
	UF:CreateHealthText(self)
	UF:CreatePowerBar(self)
	UF:CreatePowerText(self)
	UF:CreatePortrait(self)
	UF:CreateCastBar(self)
	UF:CreateRaidMark(self)
	UF:CreateIcons(self)
	UF:CreatePrediction(self)
	UF:CreateFCT(self)
	UF:CreateAuras(self)
end

local function CreateFocusStyle(self)
	self.mystyle = "focus"
	SetUnitFrameSize(self, "Focus")

	UF:CreateHeader(self)
	UF:CreateHealthBar(self)
	UF:CreateHealthText(self)
	UF:CreatePowerBar(self)
	UF:CreatePowerText(self)
	UF:CreatePortrait(self)
	UF:CreateCastBar(self)
	UF:CreateRaidMark(self)
	UF:CreateIcons(self)
	UF:CreatePrediction(self)
	UF:CreateDebuffs(self)
end

local function CreateToTStyle(self)
	self.mystyle = "tot"
	SetUnitFrameSize(self, "Pet")

	UF:CreateHeader(self)
	UF:CreateHealthBar(self)
	UF:CreateHealthText(self)
	UF:CreatePowerBar(self)
	UF:CreateRaidMark(self)

	if C.db["UFs"]["ToTAuras"] then UF:CreateDebuffs(self) end
end

local function CreateFoTStyle(self)
	self.mystyle = "fot"
	SetUnitFrameSize(self, "Pet")

	UF:CreateHeader(self)
	UF:CreateHealthBar(self)
	UF:CreateHealthText(self)
	UF:CreatePowerBar(self)
	UF:CreateRaidMark(self)
end

local function CreatePetStyle(self)
	self.mystyle = "pet"
	SetUnitFrameSize(self, "Pet")

	UF:CreateHeader(self)
	UF:CreateHealthBar(self)
	UF:CreateHealthText(self)
	UF:CreatePowerBar(self)
	UF:CreateRaidMark(self)
end

local function CreateBossStyle(self)
	self.mystyle = "boss"
	SetUnitFrameSize(self, "Boss")

	UF:CreateHeader(self)
	UF:CreateHealthBar(self)
	UF:CreateHealthText(self)
	UF:CreatePowerBar(self)
	UF:CreatePowerText(self)
	UF:CreatePortrait(self)
	UF:CreateCastBar(self)
	UF:CreateRaidMark(self)
	UF:CreateAltPower(self)
	UF:CreateBuffs(self)
	UF:CreateDebuffs(self)
	UF:CreateClickSets(self)
end

local function CreateArenaStyle(self)
	self.mystyle = "arena"
	SetUnitFrameSize(self, "Boss")

	UF:CreateHeader(self)
	UF:CreateHealthBar(self)
	UF:CreateHealthText(self)
	UF:CreatePowerBar(self)
	UF:CreatePowerText(self)
	UF:CreatePortrait(self)
	UF:CreateCastBar(self)
	UF:CreateRaidMark(self)
	UF:CreateBuffs(self)
	UF:CreateDebuffs(self)
	UF:CreatePVPClassify(self)
end

local function CreateRaidStyle(self)
	self.mystyle = "raid"
	self.Range = {
		insideAlpha = 1, outsideAlpha = .4,
	}

	UF:CreateHeader(self)
	UF:CreateHealthBar(self)
	UF:CreateHealthText(self)
	UF:CreatePowerBar(self)
	UF:CreateRaidMark(self)
	UF:CreateIcons(self)
	UF:CreateTargetBorder(self)
	UF:CreateRaidIcons(self)
	UF:CreatePrediction(self)
	UF:CreateClickSets(self)
	UF:CreateThreatBorder(self)
	UF:CreateAuraIndicator(self)

	if C.db["UFs"]["RaidAuraIndicator"] then
		if C.db["UFs"]["RaidAurasType"] == 2 then
			UF:CreateAuras(self)
			UF:CreateRaidDebuffs(self)
		end
	else
		if C.db["UFs"]["RaidAurasType"] == 2 then
			UF:CreateAuras(self)
			UF:CreateRaidDebuffs(self)
		elseif C.db["UFs"]["RaidAurasType"] == 3 then
			UF:CreateBuffs(self)
		elseif C.db["UFs"]["RaidAurasType"] == 4 then
			UF:CreateDebuffs(self)
		elseif C.db["UFs"]["RaidAurasType"] == 5 then
			UF:CreateBuffs(self)
			UF:CreateDebuffs(self)
		end
	end

	UF:RefreshAurasByCombat(self)
end

local function CreatePartyStyle(self)
	self.isPartyFrame = true
	CreateRaidStyle(self)

	UF:InterruptIndicator(self)
	UF:CreatePartyAltPower(self)
end

local function CreatePartyPetStyle(self)
	self.mystyle = "raid"
	self.isPartyPet = true
	self.Range = {
		insideAlpha = 1, outsideAlpha = .4,
	}

	UF:CreateHeader(self)
	UF:CreateHealthBar(self)
	UF:CreateHealthText(self)
	UF:CreatePowerBar(self)
	UF:CreateRaidMark(self)
	UF:CreateTargetBorder(self)
	UF:CreatePrediction(self)
	UF:CreateClickSets(self)
	UF:CreateThreatBorder(self)
end

-- Spawns
local function GetPartyVisibility()
	local visibility = "[group:party,nogroup:raid] show;hide"
	if C.db["UFs"]["SmartRaid"] then
		visibility = "[@raid6,noexists,group] show;hide"
	end
	if C.db["UFs"]["ShowSolo"] then
		visibility = "[nogroup] show;"..visibility
	end
	return visibility
end

local function GetRaidVisibility()
	local visibility
	if C.db["UFs"]["PartyFrame"] then
		if C.db["UFs"]["SmartRaid"] then
			visibility = "[@raid6,exists] show;hide"
		else
			visibility = "[group:raid] show;hide"
		end
	else
		if C.db["UFs"]["ShowSolo"] then
			visibility = "show"
		else
			visibility = "[group] show;hide"
		end
	end
	return visibility
end

function UF:UpdateAllHeaders()
	if not UF.headers then return end

	for _, header in pairs(UF.headers) do
		if header.groupType == "party" then
			RegisterStateDriver(header, "visibility", GetPartyVisibility())
		elseif header.groupType == "raid" then
			RegisterStateDriver(header, "visibility", GetRaidVisibility())
		end
	end
end

function UF:OnLogin()
	local showTeamIndex = C.db["UFs"]["ShowTeamIndex"]
	local numGroups = C.db["UFs"]["NumGroups"]
	local reverseRaid = C.db["UFs"]["ReverseRaid"]
	local horizonRaid = C.db["UFs"]["HorizonRaid"]
	local raidScale = C.db["UFs"]["SimpleRaidScale"]/10
	local raidWidth, raidHeight = C.db["UFs"]["RaidWidth"], C.db["UFs"]["RaidHeight"]

	local horizonParty = C.db["UFs"]["HorizonParty"]
	local partyWidth, partyHeight = C.db["UFs"]["PartyWidth"], C.db["UFs"]["PartyHeight"]
	local petWidth, petHeight = C.db["UFs"]["PartyPetWidth"], C.db["UFs"]["PartyPetHeight"]

	local offset = C.margin
	local xOffset = showTeamIndex and 30 or 20
	local yOffset = showTeamIndex and -50 or -40

	if C.db["Nameplate"]["Enable"] then
		UF:SetupCVars()
		UF:BlockAddons()
		UF:CreateUnitTable()
		UF:CreatePowerUnitTable()
		UF:CheckExplosives()
		UF:AddInterruptInfo()
		UF:UpdateGroupRoles()
		UF:QuestIconCheck()
		UF:RefreshPlateOnFactionChanged()
		UF:RefreshMajorSpells()

		oUF:RegisterStyle("Nameplates", UF.CreateNamePlates)
		oUF:SetActiveStyle("Nameplates")
		oUF:SpawnNamePlates("oUF_NPs", UF.PostUpdatePlates)
	end

	if C.db["Nameplate"]["ShowPlayerPlate"] then
		oUF:RegisterStyle("PlayerPlate", UF.CreatePlayerPlate)
		oUF:SetActiveStyle("PlayerPlate")
		local plate = oUF:Spawn("player", "oUF_PlayerPlate", true)
		plate.mover = B.Mover(plate, L["PlayerPlate"], "PlayerPlate", C.UFs.PlayerPlate)
	end

	-- Default Clicksets for RaidFrame
	UF:DefaultClickSets()

	if C.db["UFs"]["Enable"] then
		-- Register
		oUF:RegisterStyle("Player", CreatePlayerStyle)
		oUF:RegisterStyle("Target", CreateTargetStyle)
		oUF:RegisterStyle("TargetTarget", CreateToTStyle)
		oUF:RegisterStyle("Focus", CreateFocusStyle)
		oUF:RegisterStyle("FocusTarget", CreateFoTStyle)
		oUF:RegisterStyle("Pet", CreatePetStyle)

		-- Loader
		oUF:SetActiveStyle("Player")
		local player = oUF:Spawn("Player", "oUF_Player")
		B.Mover(player, L["PlayerUF"], "PlayerUF", C.UFs.PlayerPos)

		oUF:SetActiveStyle("Pet")
		local pet = oUF:Spawn("Pet", "oUF_Pet")
		B.Mover(pet, L["PetUF"], "PetUF", {"BOTTOMLEFT", oUF_Player, "BOTTOMRIGHT", 5, 0})

		oUF:SetActiveStyle("Target")
		local target = oUF:Spawn("Target", "oUF_Target")
		B.Mover(target, L["TargetUF"], "TargetUF", C.UFs.TargetPos)

		oUF:SetActiveStyle("TargetTarget")
		local targettarget = oUF:Spawn("TargetTarget", "oUF_ToT")
		B.Mover(targettarget, L["ToTUF"], "ToTUF", {"BOTTOMRIGHT", oUF_Target, "BOTTOMLEFT", -5, 0})

		oUF:SetActiveStyle("Focus")
		local focus = oUF:Spawn("Focus", "oUF_Focus")
		B.Mover(focus, L["FocusUF"], "FocusUF", C.UFs.FocusPos)

		oUF:SetActiveStyle("FocusTarget")
		local focustarget = oUF:Spawn("FocusTarget", "oUF_FoT")
		B.Mover(focustarget, L["FoTUF"], "FoTUF", {"BOTTOMLEFT", oUF_Focus, "BOTTOMRIGHT", 5, 0})

		oUF:RegisterStyle("Boss", CreateBossStyle)
		oUF:SetActiveStyle("Boss")
		local boss = {}
		local bossYOffset = C.db["UFs"]["BossHeight"] + C.db["UFs"]["BossPowerHeight"] + C.mult + C.margin*2 + 10
		for i = 1, MAX_BOSS_FRAMES do
			boss[i] = oUF:Spawn("boss"..i, "oUF_Boss"..i)
			if i == 1 then
				boss[i].mover = B.Mover(boss[i], L["BossFrame"]..i, "Boss1", {"TOPRIGHT", Minimap, "BOTTOMLEFT", 75, -120})
			else
				boss[i].mover = B.Mover(boss[i], L["BossFrame"]..i, "Boss"..i, {"TOP", boss[i-1], "BOTTOM", 0, -bossYOffset})
			end
		end

		if C.db["UFs"]["Arena"] then
			oUF:RegisterStyle("Arena", CreateArenaStyle)
			oUF:SetActiveStyle("Arena")
			local arena = {}
			for i = 1, 5 do
				arena[i] = oUF:Spawn("arena"..i, "oUF_Arena"..i)
				arena[i]:SetPoint("TOPLEFT", boss[i].mover)
			end
		end

		UF:UpdateTextScale()
	end

	if C.db["UFs"]["RaidFrame"] then
		UF:AddClickSetsListener()
		UF:UpdateCornerSpells()
		UF.headers = {}

		-- Hide Default RaidFrame
		if CompactRaidFrameManager_SetSetting then
			CompactRaidFrameManager_SetSetting("IsShown", "0")
			UIParent:UnregisterEvent("GROUP_ROSTER_UPDATE")
			CompactRaidFrameManager:UnregisterAllEvents()
			CompactRaidFrameManager:SetParent(B.HiddenFrame)
		end

		-- Group Styles
		local partyMover
		if C.db["UFs"]["PartyFrame"] then
			UF:SyncWithZenTracker()
			UF:UpdatePartyWatcherSpells()

			oUF:RegisterStyle("Party", CreatePartyStyle)
			oUF:SetActiveStyle("Party")

			local partyFrameHeight = partyHeight + C.db["UFs"]["PartyPowerHeight"] + C.mult
			local moverWidth = horizonParty and (partyWidth*5+offset*4) or partyWidth
			local moverHeight = horizonParty and partyFrameHeight or (partyFrameHeight*5+offset*4)
			local groupingOrder = horizonParty and "TANK,HEALER,DAMAGER,NONE" or "NONE,DAMAGER,HEALER,TANK"

			local party = oUF:SpawnHeader("oUF_Party", nil, nil,
			"showPlayer", true,
			"showSolo", true,
			"showParty", true,
			"showRaid", true,
			"xOffset", offset,
			"yOffset", offset,
			"groupingOrder", groupingOrder,
			"groupBy", "ASSIGNEDROLE",
			"sortMethod", "NAME",
			"point", horizonParty and "LEFT" or "BOTTOM",
			"columnAnchorPoint", "LEFT",
			"oUF-initialConfigFunction", ([[
			self:SetWidth(%s)
			self:SetHeight(%s)
			]]):format(partyWidth, partyFrameHeight))

			party.groupType = "party"
			tinsert(UF.headers, party)
			RegisterStateDriver(party, "visibility", GetPartyVisibility())

			partyMover = B.Mover(party, L["PartyFrame"], "PartyFrame", {"LEFT", UIParent, 350, 70}, moverWidth, moverHeight)
			party:ClearAllPoints()
			party:SetPoint("BOTTOMLEFT", partyMover)

			if C.db["UFs"]["PartyPetFrame"] then
				oUF:RegisterStyle("PartyPet", CreatePartyPetStyle)
				oUF:SetActiveStyle("PartyPet")

				local petFrameHeight = petHeight + C.db["UFs"]["PartyPetPowerHeight"] + C.mult
				local petMoverWidth = horizonParty and (petWidth*5+offset*4) or petWidth
				local petMoverHeight = horizonParty and petFrameHeight or (petFrameHeight*5+offset*4)

				local partyPet = oUF:SpawnHeader("oUF_PartyPet", nil, nil,
				"showPlayer", true,
				"showSolo", true,
				"showParty", true,
				"showRaid", true,
				"xOffset", offset,
				"yOffset", offset,
				"point", horizonParty and "LEFT" or "BOTTOM",
				"columnAnchorPoint", "LEFT",
				"oUF-initialConfigFunction", ([[
				self:SetWidth(%s)
				self:SetHeight(%s)
				self:SetAttribute("unitsuffix", "pet")
				]]):format(petWidth, petFrameHeight))

				partyPet.groupType = "party"
				tinsert(UF.headers, partyPet)
				RegisterStateDriver(partyPet, "visibility", GetPartyVisibility())

				local moverAnchor = horizonParty and {"TOPLEFT", partyMover, "BOTTOMLEFT", 0, -20} or {"BOTTOMRIGHT", partyMover, "BOTTOMLEFT", -10, 0}
				local petMover = B.Mover(partyPet, L["PartyPetFrame"], "PartyPetFrame", moverAnchor, petMoverWidth, petMoverHeight)
				partyPet:ClearAllPoints()
				partyPet:SetPoint("BOTTOMLEFT", petMover)
			end
		end

		oUF:RegisterStyle("Raid", CreateRaidStyle)
		oUF:SetActiveStyle("Raid")

		local raidMover
		if C.db["UFs"]["SimpleMode"] then
			local unitsPerColumn = C.db["UFs"]["SMUnitsPerColumn"]
			local maxColumns = B.Round(numGroups*5 / unitsPerColumn)
			local width, height = 100*raidScale, 20*raidScale + 2*raidScale + C.mult

			local function CreateGroup(name, i)
				local group = oUF:SpawnHeader(name, nil, nil,
				"showPlayer", true,
				"showSolo", true,
				"showParty", true,
				"showRaid", true,
				"xOffset", offset,
				"yOffset", -offset,
				"groupFilter", tostring(i),
				"maxColumns", maxColumns,
				"unitsPerColumn", unitsPerColumn,
				"columnSpacing", 5,
				"point", "TOP",
				"columnAnchorPoint", "LEFT",
				"oUF-initialConfigFunction", ([[
				self:SetWidth(%s)
				self:SetHeight(%s)
				]]):format(width, height))

				return group
			end

			local groupFilter
			if numGroups == 4 then
				groupFilter = "1,2,3,4"
			elseif numGroups == 5 then
				groupFilter = "1,2,3,4,5"
			elseif numGroups == 6 then
				groupFilter = "1,2,3,4,5,6"
			elseif numGroups == 7 then
				groupFilter = "1,2,3,4,5,6,7"
			elseif numGroups == 8 then
				groupFilter = "1,2,3,4,5,6,7,8"
			end

			local group = CreateGroup("oUF_Raid", groupFilter)
			group.groupType = "raid"
			tinsert(UF.headers, group)
			RegisterStateDriver(group, "visibility", GetRaidVisibility())

			local moverWidth = 100*raidScale*maxColumns + offset*(maxColumns-1)
			local moverHeight = 20*raidScale*unitsPerColumn + offset*(unitsPerColumn-1)
			raidMover = B.Mover(group, L["RaidFrame"], "RaidFrame", {"TOPLEFT", UIParent, 20, -40}, moverWidth, moverHeight)

			local groupByTypes = {
				[1] = {"1,2,3,4,5,6,7,8", "GROUP", "INDEX"},
				[2] = {"DEATHKNIGHT,WARRIOR,DEMONHUNTER,ROGUE,MONK,PALADIN,DRUID,SHAMAN,HUNTER,PRIEST,MAGE,WARLOCK", "CLASS", "NAME"},
				[3] = {"TANK,HEALER,DAMAGER,NONE", "ASSIGNEDROLE", "NAME"},
			}
			function UF:UpdateSimpleModeHeader()
				local groupByIndex = C.db["UFs"]["SMGroupByIndex"]
				group:SetAttribute("groupingOrder", groupByTypes[groupByIndex][1])
				group:SetAttribute("groupBy", groupByTypes[groupByIndex][2])
				group:SetAttribute("sortMethod", groupByTypes[groupByIndex][3])
			end
			UF:UpdateSimpleModeHeader()
		else
			local raidFrameHeight = raidHeight + C.db["UFs"]["RaidPowerHeight"] + C.mult

			local function CreateGroup(name, i)
				local group = oUF:SpawnHeader(name, nil, nil,
				"showPlayer", true,
				"showSolo", true,
				"showParty", true,
				"showRaid", true,
				"xOffset", offset,
				"yOffset", -offset,
				"groupFilter", tostring(i),
				"groupingOrder", "1,2,3,4,5,6,7,8",
				"groupBy", "GROUP",
				"sortMethod", "INDEX",
				"maxColumns", 1,
				"unitsPerColumn", 5,
				"columnSpacing", 5,
				"point", horizonRaid and "LEFT" or "TOP",
				"columnAnchorPoint", "LEFT",
				"oUF-initialConfigFunction", ([[
				self:SetWidth(%s)
				self:SetHeight(%s)
				]]):format(raidWidth, raidFrameHeight))

				return group
			end

			local function CreateTeamIndex(header)
				local parent = B.GetObject(header, "UnitButton1")
				if parent and not parent.teamIndex then
					local point = {"BOTTOM", parent, "TOP", 0, offset}
					if horizonRaid then point = {"RIGHT", parent, "LEFT", -offset, 0} end

					local teamIndex = B.CreateFS(parent, 12, "T."..header.index)
					teamIndex:ClearAllPoints()
					teamIndex:SetPoint(unpack(point))
					teamIndex:SetTextColor(.6, .8, 1)

					parent.teamIndex = teamIndex
				end
			end

			local groups = {}
			for i = 1, numGroups do
				groups[i] = CreateGroup("oUF_Raid"..i, i)
				groups[i].index = i
				groups[i].groupType = "raid"
				tinsert(UF.headers, groups[i])
				RegisterStateDriver(groups[i], "visibility", GetRaidVisibility())

				if i == 1 then
					if horizonRaid then
						raidMover = B.Mover(groups[i], L["RaidFrame"], "RaidFrame", {"TOPLEFT", UIParent, xOffset, yOffset}, (raidWidth+offset)*5-offset, (raidFrameHeight+offset)*numGroups - offset)
						if reverseRaid then
							B.UpdatePoint(groups[i], "BOTTOMLEFT", raidMover, "BOTTOMLEFT")
						end
					else
						raidMover = B.Mover(groups[i], L["RaidFrame"], "RaidFrame", {"TOPLEFT", UIParent, xOffset, yOffset}, (raidWidth+offset)*numGroups-offset, (raidFrameHeight+offset)*5-offset)
						if reverseRaid then
							B.UpdatePoint(groups[i], "TOPRIGHT", raidMover, "TOPRIGHT")
						end
					end
				else
					if horizonRaid then
						if reverseRaid then
							B.UpdatePoint(groups[i], "BOTTOMLEFT", groups[i-1], "TOPLEFT", 0, offset)
						else
							B.UpdatePoint(groups[i], "TOPLEFT", groups[i-1], "BOTTOMLEFT", 0, -offset)
						end
					else
						if reverseRaid then
							B.UpdatePoint(groups[i], "TOPRIGHT", groups[i-1], "TOPLEFT", -offset, 0)
						else
							B.UpdatePoint(groups[i], "TOPLEFT", groups[i-1], "TOPRIGHT", offset, 0)
						end
					end
				end

				if showTeamIndex then
					CreateTeamIndex(groups[i])
					groups[i]:HookScript("OnShow", CreateTeamIndex)
				end
			end
		end

		UF:UpdateRaidHealthMethod()

		if C.db["UFs"]["SpecRaidPos"] then
			local function UpdateSpecPos(event, ...)
				local unit, _, spellID = ...
				if (event == "UNIT_SPELLCAST_SUCCEEDED" and unit == "player" and spellID == 200749) or event == "ON_LOGIN" then
					local specIndex = GetSpecialization()
					if not specIndex then return end

					if not C.db["Mover"]["RaidPos"..specIndex] then
						C.db["Mover"]["RaidPos"..specIndex] = {"TOPLEFT", "UIParent", "TOPLEFT", 20, -40}
					end
					if raidMover then
						raidMover:ClearAllPoints()
						raidMover:SetPoint(unpack(C.db["Mover"]["RaidPos"..specIndex]))
					end

					if not C.db["Mover"]["PartyPos"..specIndex] then
						C.db["Mover"]["PartyPos"..specIndex] = {"LEFT", "UIParent", "LEFT", 350, 0}
					end
					if partyMover then
						partyMover:ClearAllPoints()
						partyMover:SetPoint(unpack(C.db["Mover"]["PartyPos"..specIndex]))
					end
				end
			end
			UpdateSpecPos("ON_LOGIN")
			B:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", UpdateSpecPos)

			if raidMover then
				raidMover:HookScript("OnDragStop", function()
					local specIndex = GetSpecialization()
					if not specIndex then return end
					C.db["Mover"]["RaidPos"..specIndex] = C.db["Mover"]["RaidFrame"]
				end)
			end
			if partyMover then
				partyMover:HookScript("OnDragStop", function()
					local specIndex = GetSpecialization()
					if not specIndex then return end
					C.db["Mover"]["PartyPos"..specIndex] = C.db["Mover"]["PartyFrame"]
				end)
			end
		end
	end
end