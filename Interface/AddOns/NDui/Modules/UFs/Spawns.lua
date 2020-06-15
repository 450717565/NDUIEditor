local _, ns = ...
local B, C, L, DB = unpack(ns)

local oUF = ns.oUF or oUF
local UF = B:GetModule("UnitFrames")
local format, tostring = string.format, tostring

-- Units
local function SetUnitFrameSize(self, unit)
	self:SetSize(NDuiDB["UFs"][unit.."Width"], NDuiDB["UFs"][unit.."Height"])
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
	UF:CreatePrediction(self)
	UF:CreateAddPower(self)
	UF:CreateCastBar(self)
	UF:CreateFCT(self)
	UF:CreateIcons(self)
	UF:CreateRaidMark(self)
	UF:CreateQuestSync(self)

	if NDuiDB["UFs"]["Castbars"] then
		UF:ReskinMirrorBars()
		UF:ReskinTimerTrakcer(self)
	end
	if NDuiDB["UFs"]["ClassPower"] and not NDuiDB["Nameplate"]["ShowPlayerPlate"] then
		UF:CreateClassPower(self)
		UF:StaggerBar(self)
	end
	if not NDuiDB["Misc"]["ExpRep"] then UF:CreateExpRepBar(self) end
	if NDuiDB["UFs"]["PlayerDebuff"] then UF:CreateDebuffs(self) end
	if NDuiDB["UFs"]["SwingBar"] then UF:CreateSwing(self) end
	if NDuiDB["UFs"]["QuakeTimer"] then UF:CreateQuakeTimer(self) end
end

local function CreatePetStyle(self)
	self.mystyle = "pet"
	SetUnitFrameSize(self, "Pet")

	UF:CreateHeader(self)
	UF:CreateHealthBar(self)
	UF:CreateHealthText(self)
	UF:CreatePowerBar(self)
	UF:CreateClickSets(self)
	UF:CreateRaidMark(self)
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
	UF:CreatePrediction(self)
	UF:CreateAuras(self)
	UF:CreateCastBar(self)
	UF:CreateFCT(self)
	UF:CreateIcons(self)
	UF:CreateRaidMark(self)
end

local function CreateToTStyle(self)
	self.mystyle = "tot"
	SetUnitFrameSize(self, "Pet")

	UF:CreateHeader(self)
	UF:CreateHealthBar(self)
	UF:CreateHealthText(self)
	UF:CreatePowerBar(self)
	UF:CreateClickSets(self)
	UF:CreateRaidMark(self)

	if NDuiDB["UFs"]["ToTAuras"] then UF:CreateDebuffs(self) end
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
	UF:CreatePrediction(self)
	UF:CreateCastBar(self)
	UF:CreateClickSets(self)
	UF:CreateDebuffs(self)
	UF:CreateIcons(self)
	UF:CreateRaidMark(self)
end

local function CreateFoTStyle(self)
	self.mystyle = "fot"
	SetUnitFrameSize(self, "Pet")

	UF:CreateHeader(self)
	UF:CreateHealthBar(self)
	UF:CreateHealthText(self)
	UF:CreatePowerBar(self)
	UF:CreateClickSets(self)
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
	UF:CreateAltPower(self)
	UF:CreateBuffs(self)
	UF:CreateCastBar(self)
	UF:CreateClickSets(self)
	UF:CreateDebuffs(self)
	UF:CreateRaidMark(self)
	UF:CreateTargetBorder(self)
end

local function CreateArenaStyle(self)
	self.mystyle = "arena"
	SetUnitFrameSize(self, "Boss")

	UF:CreateHeader(self)
	UF:CreateHealthBar(self)
	UF:CreateHealthText(self)
	UF:CreatePowerBar(self)
	UF:CreatePortrait(self)
	UF:CreateBuffs(self)
	UF:CreateCastBar(self)
	UF:CreateClickSets(self)
	UF:CreateDebuffs(self)
	UF:CreatePVPClassify(self)
	UF:CreateRaidMark(self)
	UF:CreateTargetBorder(self)
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
	UF:CreatePrediction(self)
	UF:CreateAuras(self)
	UF:CreateBuffIndicator(self)
	UF:CreateClickSets(self)
	UF:CreateIcons(self)
	UF:CreateRaidDebuffs(self)
	UF:CreateRaidIcons(self)
	UF:CreateRaidMark(self)
	UF:CreateTargetBorder(self)
	UF:CreateThreatBorder(self)
end

local function CreatePartyStyle(self)
	self.mystyle = "party"
	self.Range = {
		insideAlpha = 1, outsideAlpha = .4,
	}

	UF:CreateHeader(self)
	UF:CreateHealthBar(self)
	UF:CreateHealthText(self)
	UF:CreatePowerBar(self)
	UF:CreatePortrait(self)
	UF:CreatePrediction(self)
	UF:CreateAuras(self)
	UF:CreateBuffIndicator(self)
	UF:CreateClickSets(self)
	UF:CreateIcons(self)
	UF:CreateRaidDebuffs(self)
	UF:CreateRaidIcons(self)
	UF:CreateRaidMark(self)
	UF:CreateTargetBorder(self)
	UF:CreateThreatBorder(self)
	UF:CreatePartyAltPower(self)
	UF:InterruptIndicator(self)
end

local function CreatePartyPetStyle(self)
	self.mystyle = "partypet"
	self.Range = {
		insideAlpha = 1, outsideAlpha = .4,
	}

	UF:CreateHeader(self)
	UF:CreateHealthBar(self)
	UF:CreateHealthText(self)
	UF:CreatePowerBar(self)
	UF:CreateClickSets(self)
	UF:CreateRaidMark(self)
	UF:CreateTargetBorder(self)
	UF:CreateThreatBorder(self)
end

-- Spawns
function UF:OnLogin()
	if NDuiDB["Nameplate"]["Enable"] then
		self:SetupCVars()
		self:BlockAddons()
		self:CreateUnitTable()
		self:CreatePowerUnitTable()
		self:CheckExplosives()
		self:AddInterruptInfo()
		self:UpdateGroupRoles()
		self:QuestIconCheck()

		oUF:RegisterStyle("Nameplates", UF.CreatePlates)
		oUF:SetActiveStyle("Nameplates")
		oUF:SpawnNamePlates("oUF_NPs", UF.PostUpdatePlates)
	end

	if NDuiDB["Nameplate"]["ShowPlayerPlate"] then
		oUF:RegisterStyle("PlayerPlate", UF.CreatePlayerPlate)
		oUF:SetActiveStyle("PlayerPlate")

		local plate = oUF:Spawn("player", "oUF_PlayerPlate", true)
		B.Mover(plate, L["PlayerNP"], "PlayerPlate", C.UFs.PlayerPlate, plate:GetWidth(), plate:GetHeight())
	end

	-- Default Clicksets for RaidFrame
	self:DefaultClickSets()

	if NDuiDB["UFs"]["Enable"] then
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
		local bossYOffset = NDuiDB["UFs"]["BossHeight"] + NDuiDB["UFs"]["BossPowerHeight"] + B.Scale(9) + 10
		for i = 1, MAX_BOSS_FRAMES do
			boss[i] = oUF:Spawn("Boss"..i, "oUF_Boss"..i)
			if i == 1 then
				boss[i].mover = B.Mover(boss[i], L["BossFrame"]..i, "Boss1", {"TOPRIGHT", Minimap, "BOTTOMLEFT", 75, -120})
			else
				boss[i].mover = B.Mover(boss[i], L["BossFrame"]..i, "Boss"..i, {"TOP", boss[i-1].Power, "BOTTOM", 0, -bossYOffset})
			end
		end

		if NDuiDB["UFs"]["Arena"] then
			oUF:RegisterStyle("Arena", CreateArenaStyle)
			oUF:SetActiveStyle("Arena")
			local arena = {}
			for i = 1, 5 do
				arena[i] = oUF:Spawn("Arena"..i, "oUF_Arena"..i)
				arena[i]:SetPoint("TOPLEFT", boss[i].mover)
			end
		end

		UF:UpdateUFTextScale()
	end

	if NDuiDB["UFs"]["RaidFrame"] then
		UF:AddClickSetsListener()

		-- Hide Default RaidFrame
		if CompactRaidFrameManager_SetSetting then
			CompactRaidFrameManager_SetSetting("IsShown", "0")
			UIParent:UnregisterEvent("GROUP_ROSTER_UPDATE")
			CompactRaidFrameManager:UnregisterAllEvents()
			CompactRaidFrameManager:SetParent(B.HiddenFrame)
		end

		-- Group Styles
		local partyMover, partyMover
		if NDuiDB["UFs"]["PartyFrame"] then
			UF:SyncWithZenTracker()

			oUF:RegisterStyle("Party", CreatePartyStyle)
			oUF:SetActiveStyle("Party")

			local showPlayer = NDuiDB["UFs"]["ShowYourself"]
			local partyWidth = NDuiDB["UFs"]["PartyWidth"]
			local partyHeight = NDuiDB["UFs"]["PartyHeight"]
			local partyPowerHeight = NDuiDB["UFs"]["PartyPowerHeight"]
			local moverWidth = partyWidth
			local moverHeight = (partyHeight+partyPowerHeight+B.Scale(3)+10)*(showPlayer and 5 or 4)-10
			local partyYOffset = partyPowerHeight+B.Scale(3)+10

			local party = oUF:SpawnHeader("oUF_Party", nil, "solo,party",
			"showPlayer", showPlayer,
			"showSolo", false,
			"showParty", true,
			"showRaid", false,
			"xoffset", 0,
			"yOffset", -partyYOffset,
			"groupingOrder", "TANK,HEALER,DAMAGER,NONE",
			"groupBy", "ASSIGNEDROLE",
			"sortMethod", "NAME",
			"point", "TOP",
			"columnAnchorPoint", "BOTTOM",
			"oUF-initialConfigFunction", ([[
				self:SetWidth(%d)
				self:SetHeight(%d)
			]]):format(partyWidth, partyHeight))

			partyMover = B.Mover(party, L["PartyFrame"], "PartyFrame", {"TOPLEFT", UIParent, 35, -50}, moverWidth, moverHeight)
			party:ClearAllPoints()
			party:SetPoint("TOPLEFT", partyMover)

			if NDuiDB["UFs"]["PartyPetFrame"] then
				oUF:RegisterStyle("PartyPet", CreatePartyPetStyle)
				oUF:SetActiveStyle("PartyPet")

				local petWidth = NDuiDB["UFs"]["PartyPetWidth"]
				local petHeight = NDuiDB["UFs"]["PartyPetHeight"]
				local petPowerHeight = NDuiDB["UFs"]["PartyPetPowerHeight"]
				local petMoverWidth = petWidth
				local petMoverHeight = (petHeight+petPowerHeight+B.Scale(3)+10)*(showPlayer and 5 or 4)-10
				local petYOffset = petPowerHeight+B.Scale(3)+10

				local partyPet = oUF:SpawnHeader("oUF_PartyPet", nil, "solo,party",
				"showPlayer", true,
				"showSolo", false,
				"showParty", true,
				"showRaid", false,
				"xoffset", 0,
				"yOffset", -petYOffset,
				"point", "TOP",
				"columnAnchorPoint", "BOTTOM",
				"oUF-initialConfigFunction", ([[
				self:SetWidth(%d)
				self:SetHeight(%d)
				self:SetAttribute("unitsuffix", "pet")
				]]):format(petWidth, petHeight))

				petMover = B.Mover(partyPet, L["PartyPetFrame"], "PartyPetFrame", {"TOPLEFT", partyMover, "BOTTOMLEFT", 0, -20}, petMoverWidth, petMoverHeight)
				partyPet:ClearAllPoints()
				partyPet:SetPoint("TOPLEFT", petMover)
			end
		end

		oUF:RegisterStyle("Raid", CreateRaidStyle)
		oUF:SetActiveStyle("Raid")

		local raidMover
		local partyFrame = NDuiDB["UFs"]["PartyFrame"]
		local horizonRaid = NDuiDB["UFs"]["HorizonRaid"]
		local numGroups = NDuiDB["UFs"]["NumGroups"]
		local raidScale = NDuiDB["UFs"]["SimpleRaidScale"]/10
		local raidWidth = NDuiDB["UFs"]["RaidWidth"]
		local raidHeight = NDuiDB["UFs"]["RaidHeight"]
		local raidPowerHeight = NDuiDB["UFs"]["RaidPowerHeight"]
		local reverseRaid = NDuiDB["UFs"]["ReverseRaid"]
		local showTeamIndex = NDuiDB["UFs"]["ShowTeamIndex"]
		local raidYOffset = raidPowerHeight+B.Scale(3)+5
		if NDuiDB["UFs"]["SimpleMode"] then
			local unitsPerColumn = NDuiDB["UFs"]["SMUnitsPerColumn"]
			local maxColumns = B.Round(numGroups*5 / unitsPerColumn)

			local function CreateGroup(name, i)
				local group = oUF:SpawnHeader(name, nil, "solo,party,raid",
				"showPlayer", true,
				"showSolo", false,
				"showParty", not partyFrame,
				"showRaid", true,
				"xoffset", 5,
				"yOffset", -raidYOffset,
				"groupFilter", tostring(i),
				"maxColumns", maxColumns,
				"unitsPerColumn", unitsPerColumn,
				"columnSpacing", 5,
				"point", "TOP",
				"columnAnchorPoint", "LEFT",
				"oUF-initialConfigFunction", ([[
					self:SetWidth(%d)
					self:SetHeight(%d)
				]]):format(100*raidScale, 20*raidScale))
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
			local moverWidth = 100*raidScale*maxColumns + 5*(maxColumns-1)
			local moverHeight = (20*raidScale+2*raidScale+B.Scale(3))*unitsPerColumn + 5*(unitsPerColumn-1)
			raidMover = B.Mover(group, L["RaidFrame"], "RaidFrame", {"TOPLEFT", UIParent, 35, -50}, moverWidth, moverHeight)

			local groupByTypes = {
				[1] = {"1,2,3,4,5,6,7,8", "GROUP", "INDEX"},
				[2] = {"DEATHKNIGHT,WARRIOR,DEMONHUNTER,ROGUE,MONK,PALADIN,DRUID,SHAMAN,HUNTER,PRIEST,MAGE,WARLOCK", "CLASS", "NAME"},
				[3] = {"TANK,HEALER,DAMAGER,NONE", "ASSIGNEDROLE", "NAME"},
			}
			function UF:UpdateSimpleModeHeader()
				local groupByIndex = NDuiDB["UFs"]["SMGroupByIndex"]
				group:SetAttribute("groupingOrder", groupByTypes[groupByIndex][1])
				group:SetAttribute("groupBy", groupByTypes[groupByIndex][2])
				group:SetAttribute("sortMethod", groupByTypes[groupByIndex][3])
			end
			UF:UpdateSimpleModeHeader()
		else
			local function CreateGroup(name, i)
				local group = oUF:SpawnHeader(name, nil, "solo,party,raid",
				"showPlayer", true,
				"showSolo", false,
				"showParty", not partyFrame,
				"showRaid", true,
				"xoffset", 5,
				"yOffset", -raidYOffset,
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
					self:SetWidth(%d)
					self:SetHeight(%d)
				]]):format(raidWidth, raidHeight))
				return group
			end

			local groups = {}
			local raidMoverHeight = raidHeight + raidPowerHeight + B.Scale(3)
			for i = 1, numGroups do
				groups[i] = CreateGroup("oUF_Raid"..i, i)
				if i == 1 then
					if horizonRaid then
						raidMover = B.Mover(groups[i], L["RaidFrame"], "RaidFrame", {"TOPLEFT", UIParent, showTeamIndex and 45 or 35, -50}, (raidWidth+5)*5-5, (raidMoverHeight+5)*numGroups-5)
						if reverseRaid then
							groups[i]:ClearAllPoints()
							groups[i]:SetPoint("BOTTOMLEFT", raidMover)
						end
					else
						raidMover = B.Mover(groups[i], L["RaidFrame"], "RaidFrame", {"TOPLEFT", UIParent, 35, -50}, (raidWidth+5)*numGroups-5, (raidMoverHeight+5)*5-5)
						if reverseRaid then
							groups[i]:ClearAllPoints()
							groups[i]:SetPoint("TOPRIGHT", raidMover)
						end
					end
				else
					if horizonRaid then
						if reverseRaid then
							groups[i]:SetPoint("BOTTOMLEFT", groups[i-1], "TOPLEFT", 0, raidYOffset)
						else
							groups[i]:SetPoint("TOPLEFT", groups[i-1], "BOTTOMLEFT", 0, -raidYOffset)
						end
					else
						if reverseRaid then
							groups[i]:SetPoint("TOPRIGHT", groups[i-1], "TOPLEFT", -5, 0)
						else
							groups[i]:SetPoint("TOPLEFT", groups[i-1], "TOPRIGHT", 5, 0)
						end
					end
				end

				if showTeamIndex then
					local parent = _G["oUF_Raid"..i.."UnitButton1"]
					local point = {"BOTTOMLEFT", parent, "TOPLEFT", 0, 5}
					if horizonRaid then point = {"TOPRIGHT", parent, "TOPLEFT", -5, 0} end

					local teamIndex = B.CreateFS(parent, 12, format(GROUP_NUMBER, i))
					teamIndex:ClearAllPoints()
					teamIndex:SetPoint(unpack(point))
					teamIndex:SetTextColor(.6, .8, 1)
				end
			end
		end

		if not NDuiDB["UFs"]["SpecRaidPos"] then return end
		if raidMover or partyMover or petMover then
			local function UpdateSpecPos(event, ...)
				local unit, _, spellID = ...
				if (event == "UNIT_SPELLCAST_SUCCEEDED" and unit == "player" and spellID == 200749) or event == "PLAYER_ENTERING_WORLD" then
					if not GetSpecialization() then return end
					local specIndex = GetSpecialization()

					if raidMover then
						if not NDuiDB["Mover"]["RaidPos"..specIndex] then
							NDuiDB["Mover"]["RaidPos"..specIndex] = {"TOPLEFT", "UIParent", "TOPLEFT", 35, -50}
						end
						raidMover:ClearAllPoints()
						raidMover:SetPoint(unpack(NDuiDB["Mover"]["RaidPos"..specIndex]))
					end
					if partyMover then
						if not NDuiDB["Mover"]["PartyPos"..specIndex] then
							NDuiDB["Mover"]["PartyPos"..specIndex] = {"TOPLEFT", "UIParent", "TOPLEFT", 35, -50}
						end
						partyMover:ClearAllPoints()
						partyMover:SetPoint(unpack(NDuiDB["Mover"]["PartyPos"..specIndex]))
					end
					if petMover then
						if not NDuiDB["Mover"]["PetPos"..specIndex] then
							NDuiDB["Mover"]["PetPos"..specIndex] = {"TOPLEFT", partyMover, "BOTTOMLEFT", 0, -20}
						end
						petMover:ClearAllPoints()
						petMover:SetPoint(unpack(NDuiDB["Mover"]["PetPos"..specIndex]))
					end
				end
			end
			B:RegisterEvent("PLAYER_ENTERING_WORLD", UpdateSpecPos)
			B:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", UpdateSpecPos)

			if raidMover then
				raidMover:HookScript("OnDragStop", function()
					if not GetSpecialization() then return end
					local specIndex = GetSpecialization()
					NDuiDB["Mover"]["RaidPos"..specIndex] = NDuiDB["Mover"]["RaidFrame"]
				end)
			end
			if partyMover then
				partyMover:HookScript("OnDragStop", function()
					if not GetSpecialization() then return end
					local specIndex = GetSpecialization()
					NDuiDB["Mover"]["PartyPos"..specIndex] = NDuiDB["Mover"]["PartyFrame"]
				end)
			end
			if petMover then
				petMover:HookScript("OnDragStop", function()
					if not GetSpecialization() then return end
					local specIndex = GetSpecialization()
					NDuiDB["Mover"]["PetPos"..specIndex] = NDuiDB["Mover"]["PartyPetFrame"]
				end)
			end
		end
	end
end