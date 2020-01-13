local _, ns = ...
local B, C, L, DB, F = unpack(ns)

local oUF = ns.oUF or oUF
local UF = B:GetModule("UnitFrames")
local format, tostring = string.format, tostring

-- Units
local function CreatePlayerStyle(self)
	self.mystyle = "player"
	self:SetSize(NDuiDB["UFs"]["PlayerWidth"], NDuiDB["UFs"]["PlayerHeight"])

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
	self:SetSize(NDuiDB["UFs"]["PetWidth"], NDuiDB["UFs"]["PetHeight"])

	UF:CreateHeader(self)
	UF:CreateHealthBar(self)
	UF:CreateHealthText(self)
	UF:CreatePowerBar(self)
	UF:CreateClickSets(self)
	UF:CreateRaidMark(self)
end

local function CreateTargetStyle(self)
	self.mystyle = "target"
	self:SetSize(NDuiDB["UFs"]["PlayerWidth"], NDuiDB["UFs"]["PlayerHeight"])

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
	self:SetSize(NDuiDB["UFs"]["PetWidth"], NDuiDB["UFs"]["PetHeight"])

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
	self:SetSize(NDuiDB["UFs"]["FocusWidth"], NDuiDB["UFs"]["FocusHeight"])

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
	self:SetSize(NDuiDB["UFs"]["PetWidth"], NDuiDB["UFs"]["PetHeight"])

	UF:CreateHeader(self)
	UF:CreateHealthBar(self)
	UF:CreateHealthText(self)
	UF:CreatePowerBar(self)
	UF:CreateClickSets(self)
	UF:CreateRaidMark(self)
end

local function CreateBossStyle(self)
	self.mystyle = "boss"
	self:SetSize(NDuiDB["UFs"]["BossWidth"], NDuiDB["UFs"]["BossHeight"])

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
	self:SetSize(NDuiDB["UFs"]["BossWidth"], NDuiDB["UFs"]["BossHeight"])

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
	UF:CreateBuffs(self)
	UF:CreateClickSets(self)
	UF:CreateDebuffs(self)
	UF:CreateIcons(self)
	UF:CreateRaidIcons(self)
	UF:CreateRaidMark(self)
	UF:CreateTargetBorder(self)
	UF:CreateThreatBorder(self)
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

function UF:ResizeRaidFrame()
	for _, frame in pairs(oUF.objects) do
		if frame.mystyle == "raid" then
			if NDuiDB["UFs"]["SimpleMode"] then
				frame:SetSize(100*NDuiDB["UFs"]["RaidScale"], 20*NDuiDB["UFs"]["RaidScale"])
			else
				frame:SetSize(NDuiDB["UFs"]["RaidWidth"], NDuiDB["UFs"]["RaidHeight"])
			end
		end
	end
end

function UF:ResizePartyFrame()
	for _, frame in pairs(oUF.objects) do
		if frame.mystyle == "party" then
			frame:SetSize(NDuiDB["UFs"]["PartyWidth"], NDuiDB["UFs"]["PartyHeight"])
		end
	end
end

function UF:ResizePartyPetFrame()
	for _, frame in pairs(oUF.objects) do
		if frame.mystyle == "partypet" then
			frame:SetSize(NDuiDB["UFs"]["PartyPetWidth"], NDuiDB["UFs"]["PartyPetHeight"])
		end
	end
end

-- Spawns
function UF:OnLogin()
	local horizonRaid = NDuiDB["UFs"]["HorizonRaid"]
	local numGroups = NDuiDB["UFs"]["NumGroups"]
	local raidScale = NDuiDB["UFs"]["RaidScale"]
	local raidWidth = NDuiDB["UFs"]["RaidWidth"]
	local raidHeight = NDuiDB["UFs"]["RaidHeight"]
	local reverseRaid = NDuiDB["UFs"]["ReverseRaid"]
	local partyFrame = NDuiDB["UFs"]["PartyFrame"]
	local partyWatcher = NDuiDB["UFs"]["PartyWatcher"]

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
		B.Mover(plate, L["PlayerNP"], "PlayerPlate", C.UFs.PlayerPlate, plate:GetWidth(), 20)
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
		for i = 1, MAX_BOSS_FRAMES do
			boss[i] = oUF:Spawn("Boss"..i, "oUF_Boss"..i)
			if i == 1 then
				boss[i].mover = B.Mover(boss[i], L["BossFrame"]..i, "Boss1", {"TOPRIGHT", Minimap, "BOTTOMLEFT", 75, -100})
			else
				boss[i].mover = B.Mover(boss[i], L["BossFrame"]..i, "Boss"..i, {"TOP", boss[i-1], "BOTTOM", 0, -55})
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

		if NDuiDB["UFs"]["PartyFrame"] then
			oUF:RegisterStyle("Party", CreatePartyStyle)
			oUF:SetActiveStyle("Party")

			local showPlayer = partyWatcher or NDuiDB["Extras"]["ShowYourself"]
			local partyWidth = NDuiDB["UFs"]["PartyWidth"]
			local partyHeight = NDuiDB["UFs"]["PartyHeight"]
			local yOffset = -20
			local moverPoint = partyWatcher and {"BOTTOMRIGHT", oUF_Player, "TOP", 30, 130} or {"TOPLEFT", UIParent, 35, -50}
			local moverWidth = partyWidth
			local moverHeight = partyHeight*(showPlayer and 5 or 4)-yOffset*(showPlayer and 4 or 3)

			local party = oUF:SpawnHeader("oUF_Party", nil, "solo,party",
			"showPlayer", showPlayer,
			"showSolo", false,
			"showParty", true,
			"showRaid", false,
			"xoffset", 0,
			"yOffset", yOffset,
			"groupingOrder", "TANK,HEALER,DAMAGER,NONE",
			"groupBy", "ASSIGNEDROLE",
			"sortMethod", "NAME",
			"point", "TOP",
			"columnAnchorPoint", "BOTTOM",
			"oUF-initialConfigFunction", ([[
				self:SetWidth(%d)
				self:SetHeight(%d)
			]]):format(partyWidth, partyHeight))

			local partyMover = B.Mover(party, L["PartyFrame"], "PartyFrame", moverPoint, moverWidth, moverHeight)
			party:ClearAllPoints()
			party:SetPoint("TOPLEFT", partyMover)

			if NDuiDB["UFs"]["PartyPetFrame"] then
				oUF:RegisterStyle("PartyPet", CreatePartyPetStyle)
				oUF:SetActiveStyle("PartyPet")

				local petWidth = NDuiDB["UFs"]["PartyPetWidth"]
				local petHeight = NDuiDB["UFs"]["PartyPetHeight"]
				local petyOffset = -20
				local petMoverPoint = partyWatcher and {"BOTTOMLEFT", partyMover, "TOPLEFT", 0, -petyOffset} or {"TOPLEFT", partyMover, "BOTTOMLEFT", 0, petyOffset}
				local petMoverWidth = petWidth
				local petMoverHeight = petHeight*(showPlayer and 5 or 4)-petyOffset*(showPlayer and 4 or 3)

				local partyPet = oUF:SpawnHeader("oUF_PartyPet", nil, "solo,party",
				"showPlayer", true,
				"showSolo", false,
				"showParty", true,
				"showRaid", false,
				"xoffset", 0,
				"yOffset", petyOffset,
				"point", "TOP",
				"columnAnchorPoint", "BOTTOM",
				"oUF-initialConfigFunction", ([[
				self:SetWidth(%d)
				self:SetHeight(%d)
				self:SetAttribute("unitsuffix", "pet")
				]]):format(petWidth, petHeight))

				local petMover = B.Mover(partyPet, L["PartyPetFrame"], "PartyPetFrame", petMoverPoint, petMoverWidth, petMoverHeight)
				partyPet:ClearAllPoints()
				partyPet:SetPoint("TOPLEFT", petMover)
			end
		end

		UF:UpdateTextScale()
	end

	if NDuiDB["UFs"]["RaidFrame"] then
		UF:AddClickSetsListener()

		-- Hide Default RaidFrame
		if CompactRaidFrameManager_UpdateShown then
			local function HideRaid()
				if InCombatLockdown() then return end
				B.HideObject(CompactRaidFrameManager)
				local compact_raid = CompactRaidFrameManager_GetSetting("IsShown")
				if compact_raid and compact_raid ~= "0" then
					CompactRaidFrameManager_SetSetting("IsShown", "0")
				end
			end
			CompactRaidFrameManager:HookScript("OnShow", HideRaid)
			hooksecurefunc("CompactRaidFrameManager_UpdateShown", HideRaid)
			CompactRaidFrameContainer:UnregisterAllEvents()
			HideRaid()
		end

		oUF:RegisterStyle("Raid", CreateRaidStyle)
		oUF:SetActiveStyle("Raid")

		local raidMover
		if NDuiDB["UFs"]["SimpleMode"] then
			local groupingOrder, groupBy, sortMethod = "1,2,3,4,5,6,7,8", "GROUP", "INDEX"
			if NDuiDB["UFs"]["SimpleModeSortByRole"] then
				groupingOrder, groupBy, sortMethod = "TANK,HEALER,DAMAGER,NONE", "ASSIGNEDROLE", "NAME"
			end

			local function CreateGroup(name, i)
				local group = oUF:SpawnHeader(name, nil, "solo,party,raid",
				"showPlayer", true,
				"showSolo", false,
				"showParty", not partyFrame,
				"showRaid", true,
				"xoffset", 5,
				"yOffset", -10,
				"groupFilter", tostring(i),
				"groupingOrder", groupingOrder,
				"groupBy", groupBy,
				"sortMethod", sortMethod,
				"maxColumns", 2,
				"unitsPerColumn", 20,
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
			local moverWidth = numGroups > 4 and (100*raidScale*2 + 5) or 100
			local moverHeight = 20*raidScale*20 + 10*19
			raidMover = B.Mover(group, L["RaidFrame"], "RaidFrame", {"TOPLEFT", UIParent, 35, -50}, moverWidth, moverHeight)
		else
			local function CreateGroup(name, i)
				local group = oUF:SpawnHeader(name, nil, "solo,party,raid",
				"showPlayer", true,
				"showSolo", false,
				"showParty", not partyFrame,
				"showRaid", true,
				"xoffset", 5,
				"yOffset", -10,
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
			for i = 1, numGroups do
				groups[i] = CreateGroup("oUF_Raid"..i, i)
				if i == 1 then
					if horizonRaid then
						raidMover = B.Mover(groups[i], L["RaidFrame"], "RaidFrame", {"TOPLEFT", UIParent, 35, -50}, (raidWidth+5)*5, (raidHeight+(NDuiDB["UFs"]["ShowTeamIndex"] and 25 or 15))*numGroups)
						if reverseRaid then
							groups[i]:ClearAllPoints()
							groups[i]:SetPoint("BOTTOMLEFT", raidMover)
						end
					else
						raidMover = B.Mover(groups[i], L["RaidFrame"], "RaidFrame", {"TOPLEFT", UIParent, 35, -50}, (raidWidth+5)*numGroups, (raidHeight+10)*5)
						if reverseRaid then
							groups[i]:ClearAllPoints()
							groups[i]:SetPoint("TOPRIGHT", raidMover)
						end
					end
				else
					if horizonRaid then
						if reverseRaid then
							groups[i]:SetPoint("BOTTOMLEFT", groups[i-1], "TOPLEFT", 0, NDuiDB["UFs"]["ShowTeamIndex"] and 25 or 15)
						else
							groups[i]:SetPoint("TOPLEFT", groups[i-1], "BOTTOMLEFT", 0, NDuiDB["UFs"]["ShowTeamIndex"] and -25 or -15)
						end
					else
						if reverseRaid then
							groups[i]:SetPoint("TOPRIGHT", groups[i-1], "TOPLEFT", -5, 0)
						else
							groups[i]:SetPoint("TOPLEFT", groups[i-1], "TOPRIGHT", 5, 0)
						end
					end
				end

				if NDuiDB["UFs"]["ShowTeamIndex"] then
					local parent = _G["oUF_Raid"..i.."UnitButton1"]
					local teamIndex = B.CreateFS(parent, 12, format(GROUP_NUMBER, i))
					teamIndex:ClearAllPoints()
					teamIndex:SetPoint("BOTTOMLEFT", parent, "TOPLEFT", 0, 5)
					teamIndex:SetTextColor(.6, .8, 1)
				end
			end
		end

		if raidMover then
			if not NDuiDB["UFs"]["SpecRaidPos"] then return end

			local function UpdateSpecPos(event, ...)
				local unit, _, spellID = ...
				if (event == "UNIT_SPELLCAST_SUCCEEDED" and unit == "player" and spellID == 200749) or event == "PLAYER_ENTERING_WORLD" then
					if not GetSpecialization() then return end
					local specIndex = GetSpecialization()
					if not NDuiDB["Mover"]["RaidPos"..specIndex] then
						NDuiDB["Mover"]["RaidPos"..specIndex] = {"TOPLEFT", "UIParent", "TOPLEFT", 35, -50}
					end
					raidMover:ClearAllPoints()
					raidMover:SetPoint(unpack(NDuiDB["Mover"]["RaidPos"..specIndex]))
				end
			end
			B:RegisterEvent("PLAYER_ENTERING_WORLD", UpdateSpecPos)
			B:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", UpdateSpecPos)

			raidMover:HookScript("OnDragStop", function()
				if not GetSpecialization() then return end
				local specIndex = GetSpecialization()
				NDuiDB["Mover"]["RaidPos"..specIndex] = NDuiDB["Mover"]["RaidFrame"]
			end)
		end
	end
end