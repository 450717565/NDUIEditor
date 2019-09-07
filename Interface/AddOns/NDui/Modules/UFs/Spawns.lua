local _, ns = ...
local B, C, L, DB = unpack(ns)

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
	UF:CreateCastBar(self)
	UF:CreateRaidMark(self)
	UF:CreateIcons(self)
	UF:CreatePrediction(self)
	UF:CreateFCT(self)
	UF:CreateAddPower(self)

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

local function CreateTargetStyle(self)
	self.mystyle = "target"
	self:SetSize(NDuiDB["UFs"]["PlayerWidth"], NDuiDB["UFs"]["PlayerHeight"])

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
	self:SetSize(NDuiDB["UFs"]["FocusWidth"], NDuiDB["UFs"]["FocusHeight"])

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
	self:SetSize(NDuiDB["UFs"]["PetWidth"], NDuiDB["UFs"]["PetHeight"])

	UF:CreateHeader(self)
	UF:CreateHealthBar(self)
	UF:CreateHealthText(self)
	UF:CreatePowerBar(self)
	UF:CreateRaidMark(self)

	if NDuiDB["UFs"]["ToTAuras"] then UF:CreateDebuffs(self) end
end

local function CreateFoTStyle(self)
	self.mystyle = "fot"
	self:SetSize(NDuiDB["UFs"]["PetWidth"], NDuiDB["UFs"]["PetHeight"])

	UF:CreateHeader(self)
	UF:CreateHealthBar(self)
	UF:CreateHealthText(self)
	UF:CreatePowerBar(self)
	UF:CreateRaidMark(self)
end

local function CreatePetStyle(self)
	self.mystyle = "pet"
	self:SetSize(NDuiDB["UFs"]["PetWidth"], NDuiDB["UFs"]["PetHeight"])

	UF:CreateHeader(self)
	UF:CreateHealthBar(self)
	UF:CreateHealthText(self)
	UF:CreatePowerBar(self)
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
	UF:CreateCastBar(self)
	UF:CreateRaidMark(self)
	UF:CreateAltPower(self)
	UF:CreateBuffs(self)
	UF:CreateDebuffs(self)
	UF:CreatePortrait(self)
	UF:CreateTargetBorder(self)
end

local function CreateArenaStyle(self)
	self.mystyle = "arena"
	self:SetSize(NDuiDB["UFs"]["BossWidth"], NDuiDB["UFs"]["BossHeight"])

	UF:CreateHeader(self)
	UF:CreateHealthBar(self)
	UF:CreateHealthText(self)
	UF:CreatePowerBar(self)
	UF:CreateCastBar(self)
	UF:CreateRaidMark(self)
	UF:CreateBuffs(self)
	UF:CreateDebuffs(self)
	UF:CreatePVPClassify(self)
	UF:CreatePortrait(self)
	UF:CreateTargetBorder(self)
end

function UF:ResizeRaidFrame()
	for _, frame in pairs(oUF.objects) do
		if frame.mystyle == "raid" and not frame.isPartyFrame then
			if NDuiDB["UFs"]["SimpleMode"] then
				frame:SetSize(100*NDuiDB["UFs"]["RaidScale"], 20*NDuiDB["UFs"]["RaidScale"])
			else
				frame:SetSize(NDuiDB["UFs"]["RaidWidth"], NDuiDB["UFs"]["RaidHeight"])
			end
		end
	end
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
	UF:CreateRaidDebuffs(self)
	UF:CreateThreatBorder(self)
	UF:CreateAuras(self)
	UF:CreateBuffIndicator(self)
end

function UF:ResizePartyFrame()
	for _, frame in pairs(oUF.objects) do
		if frame.isPartyFrame then
			frame:SetSize(NDuiDB["UFs"]["PartyWidth"], NDuiDB["UFs"]["PartyHeight"])
		end
	end
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
	UF:CreateRaidMark(self)
	UF:CreateIcons(self)
	UF:CreateTargetBorder(self)
	UF:CreateRaidIcons(self)
	UF:CreatePrediction(self)
	UF:CreateClickSets(self)
	UF:CreateThreatBorder(self)

	if NDuiDB["UFs"]["PartyWatcher"] then
		UF:CreateRaidDebuffs(self)
		UF:CreateAuras(self)
		UF:CreateBuffIndicator(self)
		UF:InterruptIndicator(self)
	else
		UF:CreateDebuffs(self)
		UF:CreatePortrait(self)
	end
end

-- Spawns
function UF:OnLogin()
	local horizonRaid = NDuiDB["UFs"]["HorizonRaid"]
	local horizonParty = NDuiDB["UFs"]["HorizonParty"]
	local numGroups = NDuiDB["UFs"]["NumGroups"]
	local raidScale = NDuiDB["UFs"]["RaidScale"]
	local raidWidth, raidHeight = NDuiDB["UFs"]["RaidWidth"], NDuiDB["UFs"]["RaidHeight"]
	local reverse = NDuiDB["UFs"]["ReverseRaid"]
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
		B.Mover(pet, L["PetUF"], "PetUF", {"BOTTOMLEFT", oUF_Player, "BOTTOMRIGHT", 5, -2})

		oUF:SetActiveStyle("Target")
		local target = oUF:Spawn("Target", "oUF_Target")
		B.Mover(target, L["TargetUF"], "TargetUF", C.UFs.TargetPos)

		oUF:SetActiveStyle("TargetTarget")
		local targettarget = oUF:Spawn("TargetTarget", "oUF_ToT")
		B.Mover(targettarget, L["ToTUF"], "ToTUF", {"BOTTOMRIGHT", oUF_Target, "BOTTOMLEFT", -5, -2})

		oUF:SetActiveStyle("Focus")
		local focus = oUF:Spawn("Focus", "oUF_Focus")
		B.Mover(focus, L["FocusUF"], "FocusUF", C.UFs.FocusPos)

		oUF:SetActiveStyle("FocusTarget")
		local focustarget = oUF:Spawn("FocusTarget", "oUF_FoT")
		B.Mover(focustarget, L["FoTUF"], "FoTUF", {"BOTTOMLEFT", oUF_Focus, "BOTTOMRIGHT", 5, -1})

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

			local xOffset = partyWatcher and -5 or 0
			local yOffset = partyWatcher and 15 or -20
			local pointF = partyWatcher and (horizonParty and "RIGHT" or "BOTTOM") or "TOP"
			local pointT = partyWatcher and (horizonParty and "LEFT" or "TOP") or "BOTTOM"
			local partyPoint = partyWatcher and "BOTTOMRIGHT" or "TOPLEFT"
			local partyWidth = partyWatcher and NDuiDB["UFs"]["PartyWidth"] or NDuiDB["UFs"]["FocusWidth"]
			local partyHeight = partyWatcher and NDuiDB["UFs"]["PartyHeight"] or NDuiDB["UFs"]["FocusHeight"]
			local moverPoint = partyWatcher and (horizonParty and {"LEFT", UIParent, 50, 0} or {"LEFT", UIParent, 350, 0}) or {"TOPLEFT", UIParent, 35, -50}
			local moverWidth = partyWatcher and (horizonParty and (partyWidth*5-xOffset*4)) or partyWidth
			local moverHeight = partyWatcher and (horizonParty and partyHeight or (partyHeight*5+yOffset*4)) or (partyHeight*4-yOffset*3)
			local showPlayer = partyWatcher or NDuiDB["Extras"]["ShowYourself"]

			local party = oUF:SpawnHeader("oUF_Party", nil, "solo,party",
			"showPlayer", showPlayer,
			"showSolo", false,
			"showParty", true,
			"showRaid", false,
			"xoffset", xOffset,
			"yOffset", yOffset,
			"groupFilter", "1",
			"groupingOrder", "TANK,HEALER,DAMAGER,NONE",
			"groupBy", "ASSIGNEDROLE",
			"sortMethod", "NAME",
			"point", pointF,
			"columnAnchorPoint", pointT,
			"oUF-initialConfigFunction", ([[
				self:SetWidth(%d)
				self:SetHeight(%d)
			]]):format(partyWidth, partyHeight))

			local partyMover = B.Mover(party, L["PartyFrame"], "PartyFrame", moverPoint, moverWidth, moverHeight)
			party:ClearAllPoints()
			party:SetPoint(partyPoint, partyMover)
		end
	end

	if NDuiDB["UFs"]["RaidFrame"] then
		UF:AddClickSetsListener()

		-- Hide Default RaidFrame
		local function HideRaid()
			if InCombatLockdown() then return end
			B.HideObject(CompactRaidFrameManager)
			local compact_raid = CompactRaidFrameManager_GetSetting("IsShown")
			if compact_raid and compact_raid ~= "0" then
				CompactRaidFrameManager_SetSetting("IsShown", "0")
			end
		end
		CompactRaidFrameManager:HookScript("OnShow", HideRaid)
		if CompactRaidFrameManager_UpdateShown then
			hooksecurefunc("CompactRaidFrameManager_UpdateShown", HideRaid)
		end
		CompactRaidFrameContainer:UnregisterAllEvents()

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
						if reverse then
							groups[i]:ClearAllPoints()
							groups[i]:SetPoint("BOTTOMLEFT", raidMover)
						end
					else
						raidMover = B.Mover(groups[i], L["RaidFrame"], "RaidFrame", {"TOPLEFT", UIParent, 35, -50}, (raidWidth+5)*numGroups, (raidHeight+10)*5)
						if reverse then
							groups[i]:ClearAllPoints()
							groups[i]:SetPoint("TOPRIGHT", raidMover)
						end
					end
				else
					if horizonRaid then
						if reverse then
							groups[i]:SetPoint("BOTTOMLEFT", groups[i-1], "TOPLEFT", 0, NDuiDB["UFs"]["ShowTeamIndex"] and 25 or 15)
						else
							groups[i]:SetPoint("TOPLEFT", groups[i-1], "BOTTOMLEFT", 0, NDuiDB["UFs"]["ShowTeamIndex"] and -25 or -15)
						end
					else
						if reverse then
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