local _, ns = ...
local B, C, L, DB = unpack(ns)
local G = B:RegisterModule("GUI")

local tonumber, tostring, pairs, ipairs, next, select, type = tonumber, tostring, pairs, ipairs, next, select, type
local tinsert, strsplit, strfind = table.insert, string.split, string.find
local cr, cg, cb = DB.r, DB.g, DB.b
local guiTab, guiPage, f, dataFrame = {}, {}

-- Default Settings
local defaultSettings = {
	BFA = false,
	Mover = {},
	InternalCD = {},
	AuraWatchMover = {},
	RaidClickSets = {},
	TempAnchor = {},
	AuraWatchList = {
		Switcher = {},
	},
	Actionbar = {
		Enable = true,
		Hotkeys = true,
		Macro = true,
		Count = true,
		Classcolor = false,
		Cooldown = true,
		Style = 1,
		Bar4Fade = false,
		Bar5Fade = false,
		Scale = 1,
		BindType = 1,
		OverrideWA = false,
		MicroMenu = true,
	},
	Bags = {
		Enable = true,
		BagsScale = 1,
		IconSize = 34,
		BagsWidth = 14,
		BankWidth = 18,
		BagsiLvl = true,
		ReverseSort = false,
		ItemFilter = true,
		ItemSetFilter = true,
		DeleteButton = false,
		FavouriteItems = {},
		GatherEmpty = true,
		ShowNewItem = true,
		SplitCount = 1,
		SpecialBagsColor = false,
		iLvlToShow = 1,

		FilterJunk = true,
		FilterConsumable = true,
		FilterAzerite = true,
		FilterEquipment = true,
		FilterLegendary = true,
		FilterMount = true,
		FilterFavourite = true,
		FilterGoods = true,

		BagsSlot = true,
	},
	Auras = {
		Reminder = true,
		Totems = true,
		DestroyTotems = true,
		Statue = true,
		ClassAuras = true,
		ReverseBuffs = false,
		BuffSize = 30,
		BuffsPerRow = 16,
		ReverseDebuffs = false,
		DebuffSize = 30,
		DebuffsPerRow = 16,
	},
	AuraWatch = {
		Enable = true,
		ClickThrough = false,
		IconScale = 1,
		DeprecatedAuras = false,
		QuakeRing = true,
	},
	UFs = {
		Enable = true,
		Portrait = true,
		PlayerDebuff = true,
		ToTAuras = true,
		Arena = true,
		Castbars = true,
		SwingBar = false,
		SwingTimer = false,
		RaidFrame = true,
		AutoRes = true,
		NumGroups = 8,
		SimpleMode = false,
		SMUnitsPerColumn = 20,
		SMGroupByIndex = 1,
		InstanceAuras = true,
		RaidDebuffScale = 1,
		SpecRaidPos = false,
		RaidHPColor = 1,
		HorizonRaid = true,
		ReverseRaid = false,
		SimpleRaidScale = 10,
		RaidWidth = 80,
		RaidHeight = 32,
		RaidPowerHeight = 2,
		RaidHPMode = 1,
		AurasClickThrough = false,
		CombatText = true,
		HotsDots = false,
		AutoAttack = false,
		FCTOverHealing = false,
		PetCombatText = true,
		RaidClickSets = false,
		ShowTeamIndex = false,
		ClassPower = true,
		QuakeTimer = true,
		LagString = false,
		RuneTimer = true,
		RaidBuffIndicator = true,
		PartyFrame = true,
		PartyWatcher = true,
		PWOnRight = true,
		PartyWidth = 200,
		PartyHeight = 30,
		PartyPowerHeight = 2,
		PartyPetFrame = false,
		PartyPetWidth = 120,
		PartyPetHeight = 24,
		PartyPetPowerHeight = 2,
		UFsHPColor = 1,
		BuffIndicatorType = 2,
		BuffIndicatorScale = 1,
		UFTextScale = 1,
		PartyAltPower = true,
		PartyWatcherSync = true,
		SmoothAmount = .4,
		RaidTextScale = 1,
		FrequentHealth = false,
		HealthFrequency = .25,
		TargetAurasPerRow = 9,

		PlayerWidth = 250,
		PlayerHeight = 34,
		PlayerPowerHeight = 2,
		PlayerPowerOffset = 0,
		FocusWidth = 200,
		FocusHeight = 30,
		FocusPowerHeight = 2,
		FocusPowerOffset = 0,
		PetWidth = 120,
		PetHeight = 24,
		PetPowerHeight = 2,
		BossWidth = 150,
		BossHeight = 32,
		BossPowerHeight = 2,
		BossPowerOffset = 0,

		CastingColor = {r=.3, g=.7, b=1},
		NotInterruptColor = {r=1, g=.5, b=.5},
		PlayerCBWidth = 280,
		PlayerCBHeight = 20,
		TargetCBWidth = 300,
		TargetCBHeight = 20,
		FocusCBWidth = 320,
		FocusCBHeight = 20,

		OnlyCombatText = false,
		ShowYourself = false,
	},
	Chat = {
		Sticky = true,
		Lock = true,
		Invite = false,
		Freedom = true,
		Keyword = "raid",
		Oldname = true,
		GuildInvite = false,
		EnableFilter = false,
		Matches = 1,
		BlockAddonAlert = true,
		ChatMenu = true,
		WhisperColor = true,
		ChatItemLevel = true,
		Chatbar = true,
		ChatWidth = 380,
		ChatHeight = 195,
		BlockStranger = false,
		AllowFriends = true,
	},
	Map = {
		Coord = true,
		Clock = false,
		CombatPulse = true,
		MapScale = 1,
		MinimapScale = 1.2,
		ShowRecycleBin = true,
		WhoPings = true,
		MapReveal = true,
		Calendar = false,
	},
	Nameplate = {
		Enable = true,
		maxAuras = 12,
		AurasPerRow = 6,
		AuraFilter = 3,
		FriendlyCC = false,
		HostileCC = true,
		TankMode = false,
		TargetIndicator = 4,
		InsideView = true,
		Distance = 42,
		PlateWidth = 200,
		PlateHeight = 12,
		CustomUnitColor = true,
		CustomColor = {r=0, g=1, b=0},
		UnitList = "",
		ShowPowerList = "",
		VerticalSpacing = .8,
		ShowPlayerPlate = false,
		PPBarWidth = 175,
		PPBarHeight = 5,
		PPPowerText = false,
		NPsHPMode = 1,
		SecureColor = {r=1, g=0, b=1},
		TransColor = {r=1, g=1, b=0},
		InsecureColor = {r=1, g=0, b=0},
		OffTankColor = {r=0, g=0, b=1},
		DPSRevertThreat = false,
		ExplosivesScale = false,
		AKSProgress = true,
		PPFadeout = true,
		NameplateClassPower = false,
		NameTextSize = 12,
		HealthTextSize = 16,
		MinScale = .8,
		MinAlpha = .8,
		ColorBorder = true,
		QuestIndicator = true,
		NameOnlyMode = false,
		PPGCDTicker = true,

		PPCPHeight = 10,
		ArrowColor = 1,
		HighlightColor = {r=1, g=1, b=1},
		SelectedColor = {r=0, g=1, b=1},
	},
	Skins = {
		Bigwigs = true,
		DeadlyBossMods = true,
		Details = true,
		Skada = true,
		TellMeWhen = true,
		WeakAuras = true,

		ChatLine = true,
		ClassLine = true,
		InfobarLine = true,
		MenuLine = true,

		BlizzardSkins = true,
		FontOutline = true,
		FontScale = 1,
		SkinShadow = false,
		SkinStyle = 3,
		SkinTexture = true,
		ToggleDirection = 1,

		BGAlpha = .5,
		BGColor = {r=0, g=0, b=0},
		FSColor = {r=.3, g=.3, b=.3},
		GSColor1 = {r=.6, g=.6, b=.6},
		GSColor2 = {r=.3, g=.3, b=.3},
		LineColor = {r=.5, g=.5, b=.5},
	},
	Tooltip = {
		CombatHide = false,
		Cursor = true,
		ClassColor = true,
		HideRank = false,
		FactionIcon = true,
		LFDRole = false,
		TargetBy = true,
		Scale = 1,
		SpecLevelByShift = false,
		HideRealm = false,
		HideTitle = false,
		HideJunkGuild = true,
		AzeriteArmor = true,
		OnlyArmorIcons = false,
		CorruptionRank = true,
	},
	Misc = {
		Mail = true,
		ItemLevel = true,
		GemNEnchant = true,
		AzeriteTraits = true,
		MissingStats = true,
		HideErrors = true,
		SoloInfo = true,
		RareAlerter = true,
		Focuser = true,
		ExpRep = true,
		Screenshot = true,
		TradeTabs = true,
		Interrupt = false,
		OwnInterrupt = false,
		AlertInInstance = true,
		BrokenSpell = false,
		FasterLoot = true,
		AutoQuest = false,
		HideTalking = false,
		HideBanner = true,
		HideBossEmote = false,
		PetFilter = true,
		QuestNotifier = true,
		QuestProgress = false,
		OnlyCompleteRing = false,
		ExplosiveCount = true,
		ExplosiveCache = {},
		PlacedItemAlert = true,
		RareAlertInWild = true,
		ParagonRep = true,
		InstantDelete = true,
		RaidTool = true,
		RMRune = false,
		DBMCount = "5",
		EasyMarking = true,
		BlockInvite = false,
		NzothVision = true,

		MaxTiers = 4,
	},
	Tutorial = {
		Complete = false,
	},
	Extras = {
		AfkDelight = true,
		AutoCollapse = true,
		FavouriteButton = false,
		GuildWelcome = true,
		iLvlTools = true,
		LootMonitor = true,
		LootMonitorBonusRewards = false,
		LootMonitorInGroup = true,
		LootMonitorQuality = 4,
		ShowCharacterItemSheet = true,
		ShowOwnFrameWhenInspecting = true,
	},
}

local accountSettings = {
	ChatFilterList = "%*",
	ChatFilterWhiteList = "",
	TimestampFormat = 1,
	NameplateFilter = {[1]={}, [2]={}},
	RaidDebuffs = {},
	Changelog = {},
	totalGold = {},
	RepairType = 1,
	AutoSell = true,
	GuildSortBy = 1,
	GuildSortOrder = true,
	DetectVersion = DB.Version,
	ResetDetails = true,
	LockUIScale = false,
	UIScale = .78,
	NumberFormat = 2,
	VersionCheck = false,
	DBMRequest = false,
	SkadaRequest = false,
	BWRequest = false,
	RaidAuraWatch = {},
	CornerBuffs = {},
	TexStyle = 1,
	KeystoneInfo = {},
	AutoBubbles = false,
	DisableInfobars = false,
	PartyWatcherSpells = {},
	ContactList = {},
	CustomJunkList = {},
}

local function InitialSettings(source, target, fullClean)
	for i, j in pairs(source) do
		if type(j) == "table" then
			if target[i] == nil then target[i] = {} end
			for k, v in pairs(j) do
				if target[i][k] == nil then
					target[i][k] = v
				end
			end
		else
			if target[i] == nil then target[i] = j end
		end
	end

	for i, j in pairs(target) do
		if source[i] == nil then target[i] = nil end
		if fullClean and type(j) == "table" then
			for k, v in pairs(j) do
				if type(v) ~= "table" and source[i] and source[i][k] == nil then
					target[i][k] = nil
				end
			end
		end
	end
end

local loader = CreateFrame("Frame")
loader:RegisterEvent("ADDON_LOADED")
loader:SetScript("OnEvent", function(self, _, addon)
	if addon ~= "NDui" then return end
	if not NDuiDB["BFA"] then
		NDuiDB = {}
		NDuiDB["BFA"] = true
	end

	InitialSettings(defaultSettings, NDuiDB, true)
	InitialSettings(accountSettings, NDuiADB)
	B.SetupUIScale(true)
	DB.normTex = "Interface\\Addons\\NDui\\Media\\Texture\\texture_"..NDuiADB["TexStyle"]

	self:UnregisterAllEvents()
end)

-- Callbacks
local function setupBagFilter()
	G:SetupBagFilter(guiPage[2])
end

local function setupUnitFrame()
	G:SetupUnitFrame(guiPage[3])
end

local function setupCastbar()
	G:SetupCastbar(guiPage[3])
end

local function setupRaidFrame()
	G:SetupRaidFrame(guiPage[4])
end

local function setupRaidDebuffs()
	G:SetupRaidDebuffs(guiPage[4])
end

local function setupClickCast()
	G:SetupClickCast(guiPage[4])
end

local function setupBuffIndicator()
	G:SetupBuffIndicator(guiPage[4])
end

local function setupPartyWatcher()
	G:SetupPartyWatcher(guiPage[4])
end

local function setupNameplateFilter()
	G:SetupNameplateFilter(guiPage[5])
end

local function setupAuraWatch()
	f:Hide()
	SlashCmdList["NDUI_AWCONFIG"]()
end

local function updateBagSortOrder()
	SetSortBagsRightToLeft(not NDuiDB["Bags"]["ReverseSort"])
end

local function updateBagStatus()
	B:GetModule("Bags"):UpdateAllBags()

	local label = BAG_FILTER_EQUIPMENT
	if NDuiDB["Bags"]["ItemSetFilter"] then
		label = L["Equipement Set"]
	end
	_G.NDui_BackpackEquipment.label:SetText(label)
	_G.NDui_BackpackBankEquipment.label:SetText(label)
end

local function updateActionbarScale()
	B:GetModule("Actionbar"):UpdateAllScale()
end

local function updateReminder()
	B:GetModule("Auras"):InitReminder()
end

local function updateChatSticky()
	B:GetModule("Chat"):ChatWhisperSticky()
end

local function updateWhisperList()
	B:GetModule("Chat"):UpdateWhisperList()
end

local function updateFilterList()
	B:GetModule("Chat"):UpdateFilterList()
end

local function updateFilterWhiteList()
	B:GetModule("Chat"):UpdateFilterWhiteList()
end

local function updateChatSize()
	B:GetModule("Chat"):UpdateChatSize()
end

local function updateToggleDirection()
	B:GetModule("Skins"):RefreshToggleDirection()
end

local function updatePlateInsideView()
	B:GetModule("UnitFrames"):PlateInsideView()
end

local function updatePlateSpacing()
	B:GetModule("UnitFrames"):UpdatePlateSpacing()
end

local function updatePlateRange()
	B:GetModule("UnitFrames"):UpdatePlateRange()
end

local function updateCustomUnitList()
	B:GetModule("UnitFrames"):CreateUnitTable()
end

local function updatePowerUnitList()
	B:GetModule("UnitFrames"):CreatePowerUnitTable()
end

local function refreshNameplates()
	B:GetModule("UnitFrames"):RefreshAllPlates()
end

local function togglePlatePower()
	B:GetModule("UnitFrames"):TogglePlatePower()
end

local function togglePlateVisibility()
	B:GetModule("UnitFrames"):TogglePlateVisibility()
end

local function toggleGCDTicker()
	B:GetModule("UnitFrames"):ToggleGCDTicker()
end

local function updatePlateScale()
	B:GetModule("UnitFrames"):UpdatePlateScale()
end

local function updatePlateAlpha()
	B:GetModule("UnitFrames"):UpdatePlateAlpha()
end

local function updateRaidTextPoint()
	B:GetModule("UnitFrames"):UpdateRaidTextPoint()
end

local function updateUFTextScale()
	B:GetModule("UnitFrames"):UpdateUFTextScale()
end

local function updateRaidTextScale()
	B:GetModule("UnitFrames"):UpdateRaidTextScale()
end

local function refreshRaidFrameIcons()
	B:GetModule("UnitFrames"):RefreshRaidFrameIcons()
end

local function updateTargetFrameAuras()
	B:GetModule("UnitFrames"):UpdateTargetAuras()
end

local function updateSimpleModeGroupBy()
	local UF = B:GetModule("UnitFrames")
	if UF.UpdateSimpleModeHeader then
		UF:UpdateSimpleModeHeader()
	end
end

local function updateRaidHealthMethod()
	B:GetModule("UnitFrames"):UpdateRaidHealthMethod()
end

local function updateSmoothingAmount()
	B.SetSmoothingAmount(NDuiDB["UFs"]["SmoothAmount"])
end

local function updateMinimapScale()
	B:GetModule("Maps"):UpdateMinimapScale()
end

local function showMinimapClock()
	B:GetModule("Maps"):ShowMinimapClock()
end

local function showCalendar()
	B:GetModule("Maps"):ShowCalendar()
end

local function updateInterruptAlert()
	B:GetModule("Misc"):InterruptAlert()
end

local function updateExplosiveAlert()
	B:GetModule("Misc"):ExplosiveAlert()
end

local function updateRareAlert()
	B:GetModule("Misc"):RareAlert()
end

local function updateSoloInfo()
	B:GetModule("Misc"):SoloInfo()
end

local function updateQuestNotifier()
	B:GetModule("Misc"):QuestNotifier()
end

local function updateScreenShot()
	B:GetModule("Misc"):UpdateScreenShot()
end

local function updateFasterLoot()
	B:GetModule("Misc"):UpdateFasterLoot()
end

local function updateErrorBlocker()
	B:GetModule("Misc"):UpdateErrorBlocker()
end

local function toggleBossBanner()
	B:GetModule("Misc"):ToggleBossBanner()
end

local function toggleBossEmote()
	B:GetModule("Misc"):ToggleBossEmote()
end

local function updateSkinAlpha()
	local BGColor = NDuiDB["Skins"]["BGColor"]
	local BGAlpha = NDuiDB["Skins"]["BGAlpha"]

	for _, frame in pairs(C.frames) do
		B.SetBackdropColor(frame, BGColor.r, BGColor.g, BGColor.b, BGAlpha)
	end
end

StaticPopupDialogs["RESET_DETAILS"] = {
	text = L["Reset Details check"],
	button1 = YES,
	button2 = NO,
	OnAccept = function()
		NDuiADB["ResetDetails"] = true
		ReloadUI()
	end,
	whileDead = 1,
}
local function resetDetails()
	StaticPopup_Show("RESET_DETAILS")
end

-- Config
local tabList = {
	L["Actionbar"],
	L["Bags"],
	L["Unitframes"],
	L["RaidFrame"],
	L["Nameplate"],
	L["PlayerPlate"],
	L["Auras"],
	L["Raid Tools"],
	L["ChatFrame"],
	L["Maps"],
	L["Skins"],
	L["Tooltip"],
	L["Misc"],
	L["UI Settings"],
	L["Extras"],
}

local optionList = { -- type, key, value, name, horizon, doubleline
	[1] = {
		{1, "Actionbar", "Enable", DB.MyColor..L["Enable Actionbar"]},
		{1, "Actionbar", "MicroMenu", L["Micromenu"], true},
		{},--blank
		{1, "Actionbar", "Bar4Fade", L["Bar4 Fade"]},
		{1, "Actionbar", "Bar5Fade", L["Bar5 Fade"], true},
		{4, "Actionbar", "Style", L["Actionbar Style"], false, {L["BarStyle1"], L["BarStyle2"], L["BarStyle3"], L["BarStyle4"], L["BarStyle5"]}},
		{3, "Actionbar", "Scale", L["Actionbar Scale"].."*", true, {.5, 1.5, .01}, updateActionbarScale},
		{},--blank
		{1, "Actionbar", "Hotkeys", L["Actionbar Hotkey"]},
		{1, "Actionbar", "Macro", L["Actionbar Macro"], true},
		{1, "Actionbar", "Count", L["Actionbar Item Counts"]},
		{1, "Actionbar", "Classcolor", L["ClassColor BG"], true},
		{},--blank
		{1, "Actionbar", "Cooldown", DB.MyColor..L["Show Cooldown"]},
		{1, "Actionbar", "OverrideWA", L["HideCooldownOnWA"].."*", true},
	},
	[2] = {
		{1, "Bags", "Enable", DB.MyColor..L["Enable Bags"]},
		{},--blank
		{1, "Bags", "ItemFilter", L["Bags ItemFilter"].."*", nil, setupBagFilter, updateBagStatus},
		{1, "Bags", "ItemSetFilter", L["Use ItemSetFilter"].."*", true, nil, updateBagStatus, L["ItemSetFilterTips"]},
		{1, "Bags", "GatherEmpty", L["Bags GatherEmpty"].."*", nil, nil, updateBagStatus},
		{1, "Bags", "ReverseSort", L["Bags ReverseSort"].."*", true, nil, updateBagSortOrder},
		{1, "Bags", "SpecialBagsColor", L["SpecialBagsColor"].."*", nil, nil, updateBagStatus, L["SpecialBagsColorTip"]},
		{1, "Bags", "BagsiLvl", L["Bags Itemlevel"], true, nil, updateBagStatus},
		{1, "Bags", "ShowNewItem", L["Bags ShowNewItem"]},
		{1, "Bags", "DeleteButton", L["Bags DeleteButton"]},
		{3, "Bags", "iLvlToShow", L["iLvlToShow"].."*", true, {1, 500, 1}, updateBagStatus, L["iLvlToShowTip"]},
		{1, "Bags", "BagsSlot", L["Bags ItemSlot"], false, nil, updateBagStatus},
		{},--blank
		{3, "Bags", "BagsScale", L["Bags Scale"], false, {.5, 1.5, .01}},
		{3, "Bags", "IconSize", L["Bags IconSize"], true, {30, 42, 1}},
		{3, "Bags", "BagsWidth", L["Bags Width"], false, {12, 40, 1}},
		{3, "Bags", "BankWidth", L["Bank Width"], true, {12, 40, 1}},
	},
	[3] = {
		{1, "UFs", "Enable", DB.MyColor..L["Enable UFs"], nil, setupUnitFrame, nil, L["HideUFWarning"]},
		{},--blank
		{1, "UFs", "Castbars", DB.MyColor..L["UFs Castbar"], nil, setupCastbar},
		{1, "UFs", "SwingBar", L["UFs SwingBar"]},
		{1, "UFs", "SwingTimer", L["UFs SwingTimer"], true, nil, nil, L["SwingTimer Tip"]},
		{1, "UFs", "LagString", L["Castbar LagString"]},
		{1, "UFs", "QuakeTimer", L["UFs QuakeTimer"], true},
		{},--blank
		{1, "UFs", "Arena", L["Arena Frame"]},
		{1, "UFs", "Portrait", L["UFs Portrait"], true},
		{1, "UFs", "ClassPower", L["UFs ClassPower"]},
		{1, "UFs", "RuneTimer", L["UFs RuneTimer"], true},
		{1, "UFs", "PlayerDebuff", L["Player Debuff"]},
		{1, "UFs", "ToTAuras", L["ToT Debuff"], true},
		{4, "UFs", "UFsHPColor", L["HP Bar Color"], nil, {L["Default Dark"], L["ClassColorHP"], L["GradientHP"]}},
		{3, "UFs", "TargetAurasPerRow", L["TargetAurasPerRow"].."*", true, {5, 10, 1}, updateTargetFrameAuras},
		{3, "UFs", "UFTextScale", L["UFTextScale"].."*", nil, {.5, 1.5, .01}, updateUFTextScale},
		{3, "UFs", "SmoothAmount", DB.MyColor..L["SmoothAmount"].."*", true, {.2, .8, .05}, updateSmoothingAmount, L["SmoothAmountTip"]},
		{},--blank
		{1, "UFs", "CombatText", DB.MyColor..L["UFs CombatText"]},
		{1, "UFs", "OnlyCombatText", L["Only Combat Text"], true},
		{1, "UFs", "AutoAttack", L["CombatText AutoAttack"]},
		{1, "UFs", "PetCombatText", L["CombatText ShowPets"], true},
		{1, "UFs", "HotsDots", L["CombatText HotsDots"]},
		{1, "UFs", "FCTOverHealing", L["CombatText OverHealing"], true},
	},
	[4] = {
		{1, "UFs", "RaidFrame", DB.MyColor..L["UFs RaidFrame"], nil, setupRaidFrame, nil, L["RaidFrameTip"]},
		{},--blank
		{1, "UFs", "PartyFrame", DB.MyColor..L["UFs PartyFrame"]},
		{1, "UFs", "PartyPetFrame", DB.MyColor..L["UFs PartyPetFrame"], true},
		{1, "UFs", "PartyAltPower", L["UFs PartyAltPower"], nil, nil, nil, L["PartyAltPowerTip"]},
		{1, "UFs", "ShowYourself", L["PartyFrame Show Yourself"], true},
		{1, "UFs", "PartyWatcher", L["UFs PartyWatcher"], nil, setupPartyWatcher, nil, L["PartyWatcherTip"]},
		{1, "UFs", "PartyWatcherSync", L["PartyWatcherSync"], true, nil, nil, L["PartyWatcherSyncTip"]},
		{1, "UFs", "PWOnRight", L["PartyWatcherOnRight"]},
		{},--blank
		{1, "UFs", "RaidBuffIndicator", DB.MyColor..L["RaidBuffIndicator"], nil, setupBuffIndicator, nil, L["RaidBuffIndicatorTip"]},
		{4, "UFs", "BuffIndicatorType", L["BuffIndicatorType"].."*", nil, {L["BI_Blocks"], L["BI_Icons"], L["BI_Numbers"]}, refreshRaidFrameIcons},
		{3, "UFs", "BuffIndicatorScale", L["BuffIndicatorScale"].."*", true, {.5, 1.5, .01}, refreshRaidFrameIcons},
		{1, "UFs", "RaidClickSets", DB.MyColor..L["Enable ClickSets"], nil, setupClickCast},
		{1, "UFs", "InstanceAuras", DB.MyColor..L["Instance Auras"], nil, setupRaidDebuffs},
		{3, "UFs", "RaidDebuffScale", L["RaidDebuffScale"].."*", true, {.5, 1.5, .01}, refreshRaidFrameIcons},
		{1, "UFs", "AurasClickThrough", L["RaidAuras ClickThrough"], nil, nil, nil, L["ClickThroughTip"]},
		{1, "UFs", "AutoRes", L["UFs AutoRes"], true},
		{},--blank
		{1, "UFs", "ShowTeamIndex", L["RaidFrame TeamIndex"]},
		{1, "UFs", "HorizonRaid", L["Horizon RaidFrame"], true},
		{1, "UFs", "SpecRaidPos", L["Spec RaidPos"]},
		{1, "UFs", "ReverseRaid", L["Reverse RaidFrame"], true},
		{4, "UFs", "RaidHPColor", L["HP Bar Color"], nil, {L["Default Dark"], L["ClassColorHP"], L["GradientHP"]}},
		{4, "UFs", "RaidHPMode", L["HP Val Mode"].."*", true, {L["DisableRaidHP"], L["RaidHPPercent"], L["RaidHPCurrent"], L["RaidHPLost"]}, updateRaidTextPoint},
		{3, "UFs", "NumGroups", L["Num Groups"], nil, {4, 8, 1}},
		{1, "UFs", "FrequentHealth", DB.MyColor..L["FrequentHealth"].."*", true, nil, updateRaidHealthMethod, L["FrequentHealthTip"]},
		{3, "UFs", "RaidTextScale", L["UFTextScale"].."*", nil, {.5, 1.5, .01}, updateRaidTextScale},
		{3, "UFs", "HealthFrequency", L["HealthFrequency"].."*", true, {.1, .5, .05}, updateRaidHealthMethod, L["HealthFrequencyTip"]},
		{},--blank
		{1, "UFs", "SimpleMode", DB.MyColor..L["SimpleRaidFrame"], nil, nil, nil, L["SimpleRaidFrameTip"]},
		{3, "UFs", "SMUnitsPerColumn", L["SimpleMode Column"], nil, {5, 40, 1}},
		{4, "UFs", "SMGroupByIndex", L["SimpleMode GroupBy"].."*", true, {GROUP, CLASS, ROLE}, updateSimpleModeGroupBy},
		{nil, true},-- FIXME: dirty fix for now
		{nil, true},
	},
	[5] = {
		{1, "Nameplate", "Enable", DB.MyColor..L["Enable Nameplate"], nil, setupNameplateFilter},
		{5, "Nameplate", "HighlightColor", L["Highlight Color"], 2},
		{5, "Nameplate", "SelectedColor", L["Selected Color"], 3},
		{1, "Nameplate", "NameOnlyMode", L["NameOnlyMode"].."*", nil, nil, nil, L["NameOnlyModeTip"]},
		{},--blank
		{4, "Nameplate", "NPsHPMode", L["HP Val Mode"].."*", nil, {L["Only Percent"], L["Only Number"], L["Num and Per"]}, refreshNameplates},
		{4, "Nameplate", "AuraFilter", L["NameplateAuraFilter"].."*", true, {L["BlackNWhite"], L["PlayerOnly"], L["IncludeCrowdControl"]}, refreshNameplates},
		{4, "Nameplate", "TargetIndicator", L["TargetIndicator"].."*", nil, {DISABLE, L["TopArrow"], L["RightArrow"], L["TargetGlow"], L["TopNGlow"], L["RightNGlow"]}, refreshNameplates},
		{4, "Nameplate", "ArrowColor", L["Arrow Color"], true, {L["Cyan"], L["Green"], L["Red"]}},
		{},--blank
		{1, "Nameplate", "FriendlyCC", L["Friendly CC"]},
		{1, "Nameplate", "HostileCC", L["Hostile CC"], true},
		{1, "Nameplate", "ColorBorder", L["ColorBorder"].."*", nil, nil, refreshNameplates},
		{1, "Nameplate", "InsideView", L["Nameplate InsideView"].."*", true, nil, updatePlateInsideView},
		{1, "Nameplate", "ExplosivesScale", L["ExplosivesScale"]},
		{1, "Nameplate", "QuestIndicator", L["QuestIndicator"], true},
		{1, "Nameplate", "AKSProgress", L["AngryKeystones Progress"]},
		{},--blank
		{1, "Nameplate", "CustomUnitColor", DB.MyColor..L["CustomUnitColor"].."*", nil, nil, updateCustomUnitList, L["CustomUnitColorTip"]},
		{5, "Nameplate", "CustomColor", L["Custom Color"].."*", 2},
		{2, "Nameplate", "UnitList", L["UnitColor List"].."*", nil, nil, updateCustomUnitList, L["CustomUnitTips"]},
		{2, "Nameplate", "ShowPowerList", L["ShowPowerList"].."*", true, nil, updatePowerUnitList, L["CustomUnitTips"]},
		{1, "Nameplate", "TankMode", DB.MyColor..L["Tank Mode"].."*", nil, nil, nil, L["TankModeTip"]},
		{1, "Nameplate", "DPSRevertThreat", L["DPS Revert Threat"].."*", true},
		{5, "Nameplate", "SecureColor", L["Secure Color"].."*"},
		{5, "Nameplate", "TransColor", L["Trans Color"].."*", 1},
		{5, "Nameplate", "InsecureColor", L["Insecure Color"].."*", 2},
		{5, "Nameplate", "OffTankColor", L["OffTank Color"].."*", 3},
		{},--blank
		{3, "Nameplate", "VerticalSpacing", L["NP VerticalSpacing"].."*", false, {.5, 1.5, .01}, updatePlateSpacing},
		--{3, "Nameplate", "Distance", L["Nameplate Distance"].."*", true, {20, 100, 1}, updatePlateRange},
		{3, "Nameplate", "MinScale", L["Nameplate MinScale"].."*", false, {.5, 1, .01}, updatePlateScale},
		{3, "Nameplate", "MinAlpha", L["Nameplate MinAlpha"].."*", true, {.5, 1, .01}, updatePlateAlpha},
		{3, "Nameplate", "PlateWidth", L["NP Width"].."*", false, {100, 300, 1}, refreshNameplates},
		{3, "Nameplate", "PlateHeight", L["NP Height"].."*", true, {5, 30, 1}, refreshNameplates},
		{3, "Nameplate", "NameTextSize", L["NameTextSize"].."*", false, {10, 30, 1}, refreshNameplates},
		{3, "Nameplate", "HealthTextSize", L["HealthTextSize"].."*", true, {10, 30, 1}, refreshNameplates},
		{3, "Nameplate", "maxAuras", L["Max Auras"].."*", false, {0, 12, 1}, refreshNameplates},
		{3, "Nameplate", "AurasPerRow", L["Auto Per Row"].."*", true, {3, 6, 1}, refreshNameplates},
	},
	[6] = {
		{1, "Nameplate", "ShowPlayerPlate", DB.MyColor..L["Enable PlayerPlate"]},
		{},--blank
		{1, "Auras", "ClassAuras", L["Enable ClassAuras"]},
		{1, "Nameplate", "NameplateClassPower", L["Nameplate ClassPower"], true},
		{1, "Nameplate", "PPPowerText", L["PlayerPlate PowerText"].."*", nil, nil, togglePlatePower},
		{1, "Nameplate", "PPFadeout", L["PlayerPlate Fadeout"].."*", true, nil, togglePlateVisibility},
		{1, "Nameplate", "PPGCDTicker", L["PlayerPlate GCDTicker"].."*", nil, nil, toggleGCDTicker},
		{},--blank
		{3, "Nameplate", "PPBarWidth", L["PlayerPlate Bar Width"].."*", false, {150, 300, 1}, refreshNameplates},
		{3, "Nameplate", "PPBarHeight", L["PlayerPlate Bar Height"].."*", true, {5, 20, 1}, refreshNameplates},
		{3, "Nameplate", "PPCPHeight", L["PlayerPlate CP Height"].."*", false, {10, 30, 1}, refreshNameplates},
	},
	[7] = {
		{1, "AuraWatch", "Enable", DB.MyColor..L["Enable AuraWatch"], nil, setupAuraWatch},
		{1, "AuraWatch", "DeprecatedAuras", L["DeprecatedAuras"], true},
		{1, "AuraWatch", "QuakeRing", L["QuakeRing"].."*"},
		{1, "AuraWatch", "ClickThrough", L["AuraWatch ClickThrough"], nil, nil, nil, L["ClickThroughTip"]},
		{3, "AuraWatch", "IconScale", L["AuraWatch IconScale"], true, {.5, 1.5, .01}},
		{},--blank
		{1, "Auras", "Statue", L["Enable Statue"]},
		{1, "Auras", "Totems", L["Enable Totems"], true},
		{1, "Auras", "Reminder", L["Enable Reminder"].."*", nil, nil, updateReminder, L["ReminderTip"]},
		{},--blank
		{1, "Auras", "ReverseBuffs", L["ReverseBuffs"]},
		{1, "Auras", "ReverseDebuffs", L["ReverseDebuffs"], true},
		{3, "Auras", "BuffSize", L["BuffSize"], nil, {24, 50, 1}},
		{3, "Auras", "DebuffSize", L["DebuffSize"], true, {24, 50, 1}},
		{3, "Auras", "BuffsPerRow", L["BuffsPerRow"], nil, {10, 20, 1}},
		{3, "Auras", "DebuffsPerRow", L["DebuffsPerRow"], true, {10, 20, 1}},
	},
	[8] = {
		{1, "Misc", "RaidTool", DB.MyColor..L["Raid Manger"]},
		{1, "Misc", "RMRune", L["Runes Check"].."*"},
		{1, "Misc", "EasyMarking", L["Easy Mark"].."*"},
		{2, "Misc", "DBMCount", L["Countdown Sec"].."*", true},
		{},--blank
		{1, "Misc", "QuestNotifier", DB.MyColor..L["QuestNotifier"].."*", nil, nil, updateQuestNotifier},
		{1, "Misc", "QuestProgress", L["QuestProgress"].."*"},
		{1, "Misc", "OnlyCompleteRing", L["OnlyCompleteRing"].."*", true},
		{},--blank
		{1, "Misc", "Interrupt", DB.MyColor..L["Interrupt Alert"].."*", nil, nil, updateInterruptAlert},
		{1, "Misc", "AlertInInstance", L["Alert In Instance"].."*", true},
		{1, "Misc", "OwnInterrupt", L["Own Interrupt"].."*"},
		{1, "Misc", "BrokenSpell", L["Broken Spell"].."*", true, nil, nil, L["BrokenSpellTip"]},
		{},--blank
		{1, "Misc", "ExplosiveCount", L["Explosive Alert"].."*", nil, nil, updateExplosiveAlert},
		{1, "Misc", "PlacedItemAlert", L["Placed Item Alert"].."*", true},
		{1, "Misc", "SoloInfo", L["SoloInfo"].."*", nil, nil, updateSoloInfo},
		{1, "Misc", "NzothVision", DB.MyColor..L["NzothVision"], true},
		{},--blank
		{1, "Misc", "RareAlerter", DB.MyColor..L["Rare Alert"].."*", nil, nil, updateRareAlert},
		{1, "Misc", "RareAlertInWild", L["RareAlertInWild"].."*", true},
	},
	[9] = {
		{1, "Chat", "Lock", DB.MyColor..L["Lock Chat"]},
		{3, "Chat", "ChatWidth", L["LockChatWidth"].."*", nil, {200, 600, 1}, updateChatSize},
		{3, "Chat", "ChatHeight", L["LockChatHeight"].."*", true, {100, 500, 1}, updateChatSize},
		{},--blank
		{1, "Chat", "Oldname", L["Default Channel"]},
		{1, "Chat", "Sticky", L["Chat Sticky"].."*", true, nil, updateChatSticky},
		{1, "Chat", "Chatbar", L["ShowChatbar"]},
		{1, "Chat", "WhisperColor", L["Differ WhisperColor"].."*", true},
		{1, "Chat", "ChatItemLevel", L["ShowChatItemLevel"]},
		{1, "Chat", "Freedom", L["Language Filter"]},
		{4, "ACCOUNT", "TimestampFormat", L["TimestampFormat"].."*", true, {DISABLE, "03:27 PM", "03:27:32 PM", "15:27", "15:27:32"}},
		{},--blank
		{1, "Chat", "EnableFilter", DB.MyColor..L["Enable Chatfilter"]},
		{1, "Chat", "BlockAddonAlert", L["Block Addon Alert"], true},
		{1, "Chat", "AllowFriends", L["AllowFriendsSpam"].."*", nil, nil, nil, L["AllowFriendsSpamTip"]},
		{1, "Chat", "BlockStranger", DB.MyColor..L["BlockStranger"].."*", nil, nil, nil, L["BlockStrangerTip"]},
		{2, "ACCOUNT", "ChatFilterWhiteList", DB.MyColor..L["ChatFilterWhiteList"].."*", true, nil, updateFilterWhiteList, L["ChatFilterWhiteListTip"]},
		{3, "Chat", "Matches", L["Keyword Match"].."*", false, {1, 3, 1}},
		{2, "ACCOUNT", "ChatFilterList", L["Filter List"].."*", true, nil, updateFilterList, L["FilterListTip"]},
		{},--blank
		{1, "Chat", "Invite", DB.MyColor..L["Whisper Invite"]},
		{1, "Chat", "GuildInvite", L["Guild Invite Only"].."*"},
		{2, "Chat", "Keyword", L["Whisper Keyword"].."*", true, nil, updateWhisperList},
	},
	[10] = {
		{1, "Map", "Coord", L["Map Coords"]},
		{},--blank
		{1, "Map", "Calendar", L["Minimap Calendar"].."*", nil, nil, showCalendar},
		{1, "Map", "Clock", L["Minimap Clock"].."*", true, nil, showMinimapClock},
		{1, "Map", "CombatPulse", L["Minimap Pulse"]},
		{1, "Map", "WhoPings", L["Show WhoPings"], true},
		{1, "Map", "ShowRecycleBin", L["Show RecycleBin"]},
		{1, "Misc", "ExpRep", L["Show Expbar"], true},
		{},--blank
		{3, "Map", "MapScale", L["Map Scale"], false, {.5, 1.5, .01}},
		{3, "Map", "MinimapScale", L["Minimap Scale"].."*", true, {.5, 1.5, .01}, updateMinimapScale},
	},
	[11] = {
		{1, "Skins", "BlizzardSkins", DB.MyColor..L["BlizzardSkins"], false, nil, nil, L["BlizzardSkinsTips"]},
		{1, "Skins", "FontOutline", L["Font Outline"], true},
		{1, "Skins", "SkinShadow", L["Skin Shadow"]},
		{1, "Skins", "SkinTexture", L["Skin Texture"]},
		{3, "Skins", "FontScale", L["GlobalFontScale"], true, {.5, 1.5, .01}},
		{4, "Skins", "SkinStyle", L["Skin Style"], false, {L["ClassColor Style"], L["Flat Style"], L["Gradient Style"]}},
		{3, "Skins", "BGAlpha", L["Backdrop Alpha"].."*", true, {0, 1, .01}, updateSkinAlpha},
		{5, "Skins", "FSColor", L["Flat Color"]},
		{5, "Skins", "GSColor1", L["Gradient Color 1"], 1},
		{5, "Skins", "GSColor2", L["Gradient Color 2"], 2},
		{5, "Skins", "BGColor", L["Backdrop Color"], 3},
		{},--blank
		{1, "Skins", "InfobarLine", L["Infobar Line"]},
		{1, "Skins", "ChatLine", L["Chat Line"], true},
		{1, "Skins", "MenuLine", L["Menu Line"]},
		{1, "Skins", "ClassLine", L["ClassColor Line"], true},
		{5, "Skins", "LineColor", L["Line Color"], 3},
		{},--blank
		{1, "Skins", "Skada", L["Skada Skin"]},
		{1, "Skins", "Details", L["Details Skin"], nil, resetDetails},
		{4, "Skins", "ToggleDirection", L["ToggleDirection"].."*", true, {L["LEFT"], L["RIGHT"], L["TOP"], L["BOTTOM"]}, updateToggleDirection},
		{1, "Skins", "DeadlyBossMods", L["DeadlyBossMods Skin"]},
		{1, "Skins", "Bigwigs", L["Bigwigs Skin"], true},
		{1, "Skins", "TellMeWhen", L["TellMeWhen Skin"]},
		{1, "Skins", "WeakAuras", L["WeakAuras Skin"], true},
	},
	[12] = {
		{1, "Tooltip", "CombatHide", L["Hide Tooltip"].."*"},
		{1, "Tooltip", "Cursor", L["Follow Cursor"].."*"},
		{1, "Tooltip", "ClassColor", L["Classcolor Border"].."*"},
		{3, "Tooltip", "Scale", L["Tooltip Scale"].."*", true, {.5, 1.5, .01}},
		{},--blank
		{1, "Tooltip", "HideTitle", L["Hide Title"].."*"},
		{1, "Tooltip", "HideRank", L["Hide Rank"].."*", true},
		{1, "Tooltip", "FactionIcon", L["FactionIcon"].."*"},
		{1, "Tooltip", "HideJunkGuild", L["HideJunkGuild"].."*", true},
		{1, "Tooltip", "HideRealm", L["Hide Realm"].."*"},
		{1, "Tooltip", "SpecLevelByShift", L["Show SpecLevelByShift"].."*", true},
		{1, "Tooltip", "LFDRole", L["Group Roles"].."*"},
		{1, "Tooltip", "TargetBy", L["Show TargetedBy"].."*", true},
		{},--blank
		{1, "Tooltip", "AzeriteArmor", DB.MyColor..L["Show AzeriteArmor"]},
		{1, "Tooltip", "OnlyArmorIcons", L["Armor icons only"].."*", true},
		{1, "Tooltip", "CorruptionRank", DB.MyColor..L["ShowCorruptionRank"]},
	},
	[13] = {
		{1, "Misc", "ItemLevel", DB.MyColor..L["Show ItemLevel"]},
		{1, "Misc", "GemNEnchant", L["Show GemNEnchant"].."*"},
		{1, "Misc", "AzeriteTraits", L["Show AzeriteTraits"].."*"},
		{3, "Misc", "MaxTiers", L["Max Tiers"], true, {1, 4, 1}},
		{},--blank
		{1, "Misc", "HideTalking", L["No Talking"]},
		{1, "ACCOUNT", "AutoBubbles", L["AutoBubbles"], true},
		{1, "Misc", "HideBossEmote", L["HideBossEmote"].."*", nil, nil, toggleBossEmote},
		{1, "Misc", "HideBanner", L["Hide Bossbanner"].."*", true, nil, toggleBossBanner},
		{1, "Misc", "InstantDelete", L["InstantDelete"].."*"},
		{1, "Misc", "HideErrors", L["Hide Error"].."*", true, nil, updateErrorBlocker},
		{},--blank
		{1, "Misc", "MissingStats", L["Show MissingStats"]},
		{1, "Misc", "ParagonRep", L["ParagonRep"], true},
		{1, "Misc", "Mail", L["Mail Tool"]},
		{1, "Misc", "TradeTabs", L["TradeTabs"], true},
		{1, "Misc", "PetFilter", L["Show PetFilter"]},
		{1, "Misc", "Screenshot", L["Auto ScreenShot"].."*", true, nil, updateScreenShot},
		{1, "Misc", "FasterLoot", L["Faster Loot"].."*", nil, nil, updateFasterLoot},
		{1, "Misc", "Focuser", L["Easy Focus"], true},
		{1, "Misc", "BlockInvite", DB.MyColor..L["BlockInvite"].."*"},
	},
	[14] = {
		{1, "ACCOUNT", "VersionCheck", L["Version Check"]},
		{1, "ACCOUNT", "DisableInfobars", L["DisableInfobars"], true},
		{},--blank
		{3, "ACCOUNT", "UIScale", L["Setup UIScale"], false, {.4, 1.15, .01}},
		{1, "ACCOUNT", "LockUIScale", DB.MyColor..L["Lock UIScale"], true},
		{},--blank
		{4, "ACCOUNT", "NumberFormat", L["Numberize"], false, {L["Number Type1"], L["Number Type2"], L["Number Type3"]}},
		{3, "ACCOUNT", "TexStyle", L["Texture Style"], true, {1, 58, 1}},
	},
	[15] = {
		{1, "Extras", "AutoCollapse", L["Auto Collapse"]},
		{1, "Extras", "GuildWelcome", L["Guild Welcome"], true},
		{1, "Extras", "AfkDelight", L["Afk Delight"]},
		{},--blank
		{1, "Extras", "iLvlTools", DB.MyColor..L["iLvlTools"]},
		{1, "Extras", "ShowCharacterItemSheet", L["Show Character Item Sheet"]},
		{1, "Extras", "ShowOwnFrameWhenInspecting", L["Show Own Frame When Inspecting"], true},
		{},--blank
		{1, "Extras", "LootMonitor", DB.MyColor..L["LootMonitor Title"]},
		{1, "Extras", "LootMonitorInGroup", L["LootMonitor InGroup"]},
		{1, "Extras", "LootMonitorBonusRewards", L["LootMonitor Bonus Rewards"]},
		{4, "Extras", "LootMonitorQuality", L["LootMonitor Quality"], true, {ITEM_QUALITY1_DESC, ITEM_QUALITY2_DESC, ITEM_QUALITY3_DESC, ITEM_QUALITY4_DESC}},
	},
}

local function SelectTab(i)
	for num = 1, #tabList do
		if num == i then
			guiTab[num]:SetBackdropColor(cr, cg, cb, .25)
			guiTab[num].checked = true
			guiPage[num]:Show()
		else
			guiTab[num]:SetBackdropColor(0, 0, 0, 0)
			guiTab[num].checked = false
			guiPage[num]:Hide()
		end
	end
end

local function tabOnClick(self)
	PlaySound(SOUNDKIT.GS_TITLE_OPTION_OK)
	SelectTab(self.index)
end
local function tabOnEnter(self)
	if self.checked then return end
	self:SetBackdropColor(cr, cg, cb, .25)
end
local function tabOnLeave(self)
	if self.checked then return end
	self:SetBackdropColor(0, 0, 0, 0)
end

local function CreateTab(parent, i, name)
	local tab = CreateFrame("Button", nil, parent)
	tab:SetPoint("TOPLEFT", 20, -30*i - 20 + C.mult)
	tab:SetSize(130, 28)
	B.CreateBD(tab, 0)
	B.CreateSD(tab)
	B.CreateGF(tab)
	local label = B.CreateFS(tab, 15, name, "system", "LEFT", 10, 0)
	if i > 14 then
		label:SetTextColor(cr, cg, cb)
	end
	tab.index = i

	tab:SetScript("OnClick", tabOnClick)
	tab:SetScript("OnEnter", tabOnEnter)
	tab:SetScript("OnLeave", tabOnLeave)

	return tab
end

local function NDUI_VARIABLE(key, value, newValue)
	if key == "ACCOUNT" then
		if newValue ~= nil then
			NDuiADB[value] = newValue
		else
			return NDuiADB[value]
		end
	else
		if newValue ~= nil then
			NDuiDB[key][value] = newValue
		else
			return NDuiDB[key][value]
		end
	end
end

local function CreateOption(i)
	local parent, offset = guiPage[i].child, 20

	for _, option in pairs(optionList[i]) do
		local optType, key, value, name, horizon, data, callback, tooltip = unpack(option)
		-- Checkboxes
		if optType == 1 then
			local cb = B.CreateCheckBox(parent)
			cb:SetHitRectInsets(-5, -5, -5, -5)
			if horizon then
				cb:SetPoint("TOPLEFT", 330, -offset + 35)
			else
				cb:SetPoint("TOPLEFT", 20, -offset)
				offset = offset + 35
			end
			cb.name = B.CreateFS(cb, 14, name, false, "LEFT", 30, 0)
			cb:SetChecked(NDUI_VARIABLE(key, value))
			cb:SetScript("OnClick", function()
				NDUI_VARIABLE(key, value, cb:GetChecked())
				if callback then callback() end
			end)
			if data and type(data) == "function" then
				local bu = B.CreateGear(parent)
				bu:SetPoint("LEFT", cb.name, "RIGHT", -2, 1)
				bu:SetScript("OnClick", data)
			end
			if tooltip then
				cb.title = L["Tips"]
				B.AddTooltip(cb, "ANCHOR_RIGHT", tooltip, "info")
			end
		-- Editbox
		elseif optType == 2 then
			local eb = B.CreateEditBox(parent, 200, 28)
			eb:SetMaxLetters(999)
			if horizon then
				eb:SetPoint("TOPLEFT", 345, -offset + 45)
			else
				eb:SetPoint("TOPLEFT", 35, -offset - 25)
				offset = offset + 70
			end
			eb:SetText(NDUI_VARIABLE(key, value))
			eb:HookScript("OnEscapePressed", function()
				eb:SetText(NDUI_VARIABLE(key, value))
			end)
			eb:HookScript("OnEnterPressed", function()
				NDUI_VARIABLE(key, value, eb:GetText())
				if callback then callback() end
			end)
			eb.title = L["Tips"]
			local tip = L["EditBox Tip"]
			if tooltip then tip = tooltip.."|n"..tip end
			B.AddTooltip(eb, "ANCHOR_RIGHT", tip, "info")

			B.CreateFS(eb, 14, name, "system", "CENTER", 0, 25)
		-- Slider
		elseif optType == 3 then
			local min, max, step = unpack(data)
			local x, y
			if horizon then
				x, y = 350, -offset + 40
			else
				x, y = 40, -offset - 30
				offset = offset + 70
			end
			local s = B.CreateSlider(parent, name, min, max, step, x, y)
			s.__default = (key == "ACCOUNT" and accountSettings[value]) or defaultSettings[key][value]
			s:SetValue(NDUI_VARIABLE(key, value))
			s:SetScript("OnValueChanged", function(_, v)
				local current = B.Round(tonumber(v), 2)
				NDUI_VARIABLE(key, value, current)
				s.value:SetText(current)
				if callback then callback() end
			end)
			s.value:SetText(B.Round(NDUI_VARIABLE(key, value), 2))
			if tooltip then
				s.title = L["Tips"]
				B.AddTooltip(s, "ANCHOR_RIGHT", tooltip, "info")
			end
		-- Dropdown
		elseif optType == 4 then
			local dd = B.CreateDropDown(parent, 200, 28, data)
			if horizon then
				dd:SetPoint("TOPLEFT", 345, -offset + 45)
			else
				dd:SetPoint("TOPLEFT", 35, -offset - 25)
				offset = offset + 70
			end
			dd.Text:SetText(data[NDUI_VARIABLE(key, value)])

			local opt = dd.options
			dd.button:HookScript("OnClick", function()
				for num = 1, #data do
					if num == NDUI_VARIABLE(key, value) then
						opt[num]:SetBackdropColor(1, .8, 0, .25)
						opt[num].selected = true
					else
						opt[num]:SetBackdropColor(0, 0, 0, 0)
						opt[num].selected = false
					end
				end
			end)
			for i in pairs(data) do
				opt[i]:HookScript("OnClick", function()
					NDUI_VARIABLE(key, value, i)
					if callback then callback() end
				end)
			end

			B.CreateFS(dd, 14, name, "system", "CENTER", 0, 25)
		-- Colorswatch
		elseif optType == 5 then
			local f = B.CreateColorSwatch(parent, name, NDUI_VARIABLE(key, value))
			local width = 25 + (horizon or 0)*155
			if horizon then
				f:SetPoint("TOPLEFT", width, -offset + 30)
			else
				f:SetPoint("TOPLEFT", width, -offset - 5)
				offset = offset + 35
			end
		-- Blank, no optType
		else
			if not key then
				local l = CreateFrame("Frame", nil, parent)
				l:SetPoint("TOPLEFT", 25, -offset - 12)
				B.CreateGA(l, 560, C.mult*2, "Horizontal", cr, cg, cb, DB.Alpha, 0)
			end
			offset = offset + 35
		end
	end

	local footer = CreateFrame("Frame", nil, parent)
	footer:SetSize(20, 20)
	footer:SetPoint("TOPLEFT", 25, -offset)
end

local bloodlustFilter = {
	[57723] = true,
	[57724] = true,
	[80354] = true,
	[264689] = true
}

local function exportData()
	local text = "NDuiSettings:"..DB.Version..":"..DB.MyName..":"..DB.MyClass
	for KEY, VALUE in pairs(NDuiDB) do
		if type(VALUE) == "table" then
			for key, value in pairs(VALUE) do
				if type(value) == "table" then
					if value.r then
						for k, v in pairs(value) do
							text = text..";"..KEY..":"..key..":"..k..":"..v
						end
					elseif key == "ExplosiveCache" then
						text = text..";"..KEY..":"..key..":EMPTYTABLE"
					elseif KEY == "AuraWatchList" then
						if key == "Switcher" then
							for k, v in pairs(value) do
								text = text..";"..KEY..":"..key..":"..k..":"..tostring(v)
							end
						else
							for spellID, k in pairs(value) do
								text = text..";"..KEY..":"..key..":"..spellID
								if k[5] == nil then k[5] = false end
								for _, v in ipairs(k) do
									text = text..":"..tostring(v)
								end
							end
						end
					elseif KEY == "Mover" or KEY == "RaidClickSets" or KEY == "InternalCD" or KEY == "AuraWatchMover" then
						text = text..";"..KEY..":"..key
						for _, v in ipairs(value) do
							text = text..":"..tostring(v)
						end
					elseif key == "FavouriteItems" then
						text = text..";"..KEY..":"..key
						for itemID in pairs(value) do
							text = text..":"..tostring(itemID)
						end
					end
				else
					if NDuiDB[KEY][key] ~= defaultSettings[KEY][key] then
						text = text..";"..KEY..":"..key..":"..tostring(value)
					end
				end
			end
		end
	end

	for KEY, VALUE in pairs(NDuiADB) do
		if KEY == "RaidAuraWatch" or KEY == "CustomJunkList" then
			text = text..";ACCOUNT:"..KEY
			for spellID in pairs(VALUE) do
				text = text..":"..spellID
			end
		elseif KEY == "RaidDebuffs" then
			for instName, value in pairs(VALUE) do
				for spellID, prio in pairs(value) do
					text = text..";ACCOUNT:"..KEY..":"..instName..":"..spellID..":"..prio
				end
			end
		elseif KEY == "NameplateFilter" then
			for index, value in pairs(VALUE) do
				text = text..";ACCOUNT:"..KEY..":"..index
				for spellID in pairs(value) do
					text = text..":"..spellID
				end
			end
		elseif KEY == "CornerBuffs" then
			for class, value in pairs(VALUE) do
				for spellID, data in pairs(value) do
					if not bloodlustFilter[spellID] and class == DB.MyClass then
						local anchor, color, filter = unpack(data)
						text = text..";ACCOUNT:"..KEY..":"..class..":"..spellID..":"..anchor..":"..color[1]..":"..color[2]..":"..color[3]..":"..tostring(filter or false)
					end
				end
			end
		elseif KEY == "PartyWatcherSpells" then
			text = text..";ACCOUNT:"..KEY
			for spellID, duration in pairs(VALUE) do
				local name = GetSpellInfo(spellID)
				if name then
					text = text..":"..spellID..":"..duration
				end
			end
		elseif KEY == "ContactList" then
			for name, color in pairs(VALUE) do
				text = text..";ACCOUNT:"..KEY..":"..name..":"..color
			end
		end
	end

	dataFrame.editBox:SetText(B:Encode(text))
	dataFrame.editBox:HighlightText()
end

local function toBoolean(value)
	if value == "true" then
		return true
	elseif value == "false" then
		return false
	end
end

local function importData()
	local profile = dataFrame.editBox:GetText()
	if B:IsBase64(profile) then profile = B:Decode(profile) end
	local options = {strsplit(";", profile)}
	local title, _, _, class = strsplit(":", options[1])
	if title ~= "NDuiSettings" then
		UIErrorsFrame:AddMessage(DB.InfoColor..L["Import data error"])
		return
	end

	for i = 2, #options do
		local option = options[i]
		local key, value, arg1 = strsplit(":", option)
		if arg1 == "true" or arg1 == "false" then
			NDuiDB[key][value] = toBoolean(arg1)
		elseif arg1 == "EMPTYTABLE" then
			NDuiDB[key][value] = {}
		elseif strfind(value, "Color") and (arg1 == "r" or arg1 == "g" or arg1 == "b") then
			local color = select(4, strsplit(":", option))
			if NDuiDB[key][value] then
				NDuiDB[key][value][arg1] = tonumber(color)
			end
		elseif key == "AuraWatchList" then
			if value == "Switcher" then
				local index, state = select(3, strsplit(":", option))
				NDuiDB[key][value][tonumber(index)] = toBoolean(state)
			else
				local idType, spellID, unit, caster, stack, amount, timeless, combat, text, flash = select(4, strsplit(":", option))
				value = tonumber(value)
				arg1 = tonumber(arg1)
				spellID = tonumber(spellID)
				stack = tonumber(stack)
				amount = toBoolean(amount)
				timeless = toBoolean(timeless)
				combat = toBoolean(combat)
				flash = toBoolean(flash)
				if not NDuiDB[key][value] then NDuiDB[key][value] = {} end
				NDuiDB[key][value][arg1] = {idType, spellID, unit, caster, stack, amount, timeless, combat, text, flash}
			end
		elseif value == "FavouriteItems" then
			local items = {select(3, strsplit(":", option))}
			for _, itemID in next, items do
				NDuiDB[key][value][tonumber(itemID)] = true
			end
		elseif key == "Mover" or key == "AuraWatchMover" then
			local relFrom, parent, relTo, x, y = select(3, strsplit(":", option))
			value = tonumber(value) or value
			x = tonumber(x)
			y = tonumber(y)
			NDuiDB[key][value] = {relFrom, parent, relTo, x, y}
		elseif key == "RaidClickSets" then
			if DB.MyClass == class then
				NDuiDB[key][value] = {select(3, strsplit(":", option))}
			end
		elseif key == "InternalCD" then
			local spellID, duration, indicator, unit, itemID = select(3, strsplit(":", option))
			spellID = tonumber(spellID)
			duration = tonumber(duration)
			itemID = tonumber(itemID)
			NDuiDB[key][spellID] = {spellID, duration, indicator, unit, itemID}
		elseif key == "ACCOUNT" then
			if value == "RaidAuraWatch" or value == "CustomJunkList" then
				local spells = {select(3, strsplit(":", option))}
				for _, spellID in next, spells do
					NDuiADB[value][tonumber(spellID)] = true
				end
			elseif value == "RaidDebuffs" then
				local instName, spellID, priority = select(3, strsplit(":", option))
				if not NDuiADB[value][instName] then NDuiADB[value][instName] = {} end
				NDuiADB[value][instName][tonumber(spellID)] = tonumber(priority)
			elseif value == "NameplateFilter" then
				local spells = {select(4, strsplit(":", option))}
				for _, spellID in next, spells do
					NDuiADB[value][tonumber(arg1)][tonumber(spellID)] = true
				end
			elseif value == "CornerBuffs" then
				local class, spellID, anchor, r, g, b, filter = select(3, strsplit(":", option))
				spellID = tonumber(spellID)
				r = tonumber(r)
				g = tonumber(g)
				b = tonumber(b)
				filter = toBoolean(filter)
				if not NDuiADB[value][class] then NDuiADB[value][class] = {} end
				NDuiADB[value][class][spellID] = {anchor, {r, g, b}, filter}
			elseif value == "PartyWatcherSpells" then
				local options = {strsplit(":", option)}
				local index = 3
				local spellID = options[index]
				while spellID do
					local duration = options[index+1]
					NDuiADB[value][tonumber(spellID)] = tonumber(duration) or 0
					index = index + 2
					spellID = options[index]
				end
			elseif value == "ContactList" then
				local name, r, g, b = select(3, strsplit(":", option))
				NDuiADB["ContactList"][name] = r..":"..g..":"..b
			end
		elseif tonumber(arg1) then
			if value == "DBMCount" then
				NDuiDB[key][value] = arg1
			else
				NDuiDB[key][value] = tonumber(arg1)
			end
		end
	end

	ReloadUI()
end

local function updateTooltip()
	local profile = dataFrame.editBox:GetText()
	if B:IsBase64(profile) then profile = B:Decode(profile) end
	local option = strsplit(";", profile)
	local title, version, name, class = strsplit(":", option)
	if title == "NDuiSettings" then
		dataFrame.version = version
		dataFrame.name = name
		dataFrame.class = class
	else
		dataFrame.version = nil
	end
end

local function createDataFrame()
	if dataFrame then dataFrame:Show() return end

	dataFrame = CreateFrame("Frame", nil, UIParent)
	dataFrame:SetPoint("CENTER")
	dataFrame:SetSize(500, 500)
	dataFrame:SetFrameStrata("DIALOG")
	B.CreateMF(dataFrame)
	B.CreateBG(dataFrame)
	dataFrame.Header = B.CreateFS(dataFrame, 16, L["Export Header"], true, "TOP", 0, -5)

	local scrollArea = CreateFrame("ScrollFrame", nil, dataFrame, "UIPanelScrollFrameTemplate")
	scrollArea:SetPoint("TOPLEFT", 10, -30)
	scrollArea:SetPoint("BOTTOMRIGHT", -28, 40)
	B.CreateBDFrame(scrollArea, 0)
	B.ReskinScroll(scrollArea.ScrollBar)

	local editBox = CreateFrame("EditBox", nil, dataFrame)
	editBox:SetMultiLine(true)
	editBox:SetMaxLetters(99999)
	editBox:EnableMouse(true)
	editBox:SetAutoFocus(true)
	editBox:SetFont(DB.Font[1], 14)
	editBox:SetWidth(scrollArea:GetWidth())
	editBox:SetHeight(scrollArea:GetHeight())
	editBox:SetScript("OnEscapePressed", function() dataFrame:Hide() end)
	scrollArea:SetScrollChild(editBox)
	dataFrame.editBox = editBox

	StaticPopupDialogs["NDUI_IMPORT_DATA"] = {
		text = L["Import data warning"],
		button1 = YES,
		button2 = NO,
		OnAccept = function()
			importData()
		end,
		whileDead = 1,
	}
	local accept = B.CreateButton(dataFrame, 100, 20, OKAY)
	accept:SetPoint("BOTTOM", 0, 10)
	accept:SetScript("OnClick", function(self)
		if self.text:GetText() ~= OKAY and dataFrame.editBox:GetText() ~= "" then
			StaticPopup_Show("NDUI_IMPORT_DATA")
		end
		dataFrame:Hide()
	end)
	accept:HookScript("OnEnter", function(self)
		if dataFrame.editBox:GetText() == "" then return end
		updateTooltip()

		GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 10)
		GameTooltip:ClearLines()
		if dataFrame.version then
			GameTooltip:AddLine(L["Data Info"])
			GameTooltip:AddDoubleLine(L["Version"], dataFrame.version, .6,.8,1, 1,1,1)
			GameTooltip:AddDoubleLine(L["Character"], dataFrame.name, .6,.8,1, B.ClassColor(dataFrame.class))
		else
			GameTooltip:AddLine(L["Data Exception"], 1,0,0)
		end
		GameTooltip:Show()
	end)
	accept:HookScript("OnLeave", B.HideTooltip)
	dataFrame.text = accept.text
end

local function OpenGUI()
	if f then f:Show() return end

	-- Main Frame
	f = CreateFrame("Frame", "NDuiGUI", UIParent)
	tinsert(UISpecialFrames, "NDuiGUI")
	f:SetSize(800, 600)
	f:SetPoint("CENTER")
	f:SetFrameStrata("HIGH")
	f:SetFrameLevel(10)
	B.CreateMF(f)
	B.CreateBG(f)
	B.CreateFS(f, 18, L["NDui Console"], true, "TOP", 0, -10)
	B.CreateFS(f, 16, DB.Version.." ("..DB.Support..")", false, "TOP", 0, -30)

	local close = B.CreateButton(f, 80, 20, CLOSE)
	close:SetPoint("BOTTOMRIGHT", -20, 15)
	close:SetScript("OnClick", function() f:Hide() end)

	local ok = B.CreateButton(f, 80, 20, OKAY)
	ok:SetPoint("RIGHT", close, "LEFT", -10, 0)
	ok:SetScript("OnClick", function()
		B.SetupUIScale()
		f:Hide()
		StaticPopup_Show("RELOAD_NDUI")
	end)

	for i, name in pairs(tabList) do
		guiTab[i] = CreateTab(f, i, name)

		guiPage[i] = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
		guiPage[i]:SetPoint("TOPLEFT", 160, -50)
		guiPage[i]:SetSize(610, 500)
		B.CreateBDFrame(guiPage[i], 0)
		guiPage[i]:Hide()
		guiPage[i].child = CreateFrame("Frame", nil, guiPage[i])
		guiPage[i].child:SetSize(610, 1)
		guiPage[i]:SetScrollChild(guiPage[i].child)
		B.ReskinScroll(guiPage[i].ScrollBar)

		CreateOption(i)
	end

	local reset = B.CreateButton(f, 120, 20, L["NDui Reset"])
	reset:SetPoint("BOTTOMLEFT", 25, 15)
	StaticPopupDialogs["RESET_NDUI"] = {
		text = L["Reset NDui Check"],
		button1 = YES,
		button2 = NO,
		OnAccept = function()
			NDuiDB = {}
			NDuiADB = {}
			ReloadUI()
		end,
		whileDead = 1,
	}
	reset:SetScript("OnClick", function()
		StaticPopup_Show("RESET_NDUI")
	end)

	local import = B.CreateButton(f, 59, 20, L["Import"])
	import:SetPoint("BOTTOMLEFT", reset, "TOPLEFT", 0, 2)
	import:SetScript("OnClick", function()
		f:Hide()
		createDataFrame()
		dataFrame.Header:SetText(L["Import Header"])
		dataFrame.text:SetText(L["Import"])
		dataFrame.editBox:SetText("")
	end)

	local export = B.CreateButton(f, 59, 20, L["Export"])
	export:SetPoint("BOTTOMRIGHT", reset, "TOPRIGHT", 0, 2)
	export:SetScript("OnClick", function()
		f:Hide()
		createDataFrame()
		dataFrame.Header:SetText(L["Export Header"])
		dataFrame.text:SetText(OKAY)
		exportData()
	end)

	local optTip = CreateFrame("Button", nil, f)
	optTip:SetPoint("TOPLEFT", 20, -5)
	optTip:SetSize(45, 45)
	optTip.Icon = optTip:CreateTexture(nil, "ARTWORK")
	optTip.Icon:SetAllPoints()
	optTip.Icon:SetTexture(616343)
	optTip:SetHighlightTexture(616343)
	optTip:SetScript("OnEnter", function()
		GameTooltip:ClearLines()
		GameTooltip:SetOwner(f, "ANCHOR_NONE")
		GameTooltip:SetPoint("TOPRIGHT", f, "TOPLEFT", -5, -3)
		GameTooltip:AddLine(L["Tips"])
		GameTooltip:AddLine(L["Option* Tips"], .6,.8,1, 1)
		GameTooltip:Show()
	end)
	optTip:SetScript("OnLeave", B.HideTooltip)

	local credit = CreateFrame("Button", nil, f)
	credit:SetPoint("TOPRIGHT", -20, -5)
	credit:SetSize(45, 45)
	credit.Icon = credit:CreateTexture(nil, "ARTWORK")
	credit.Icon:SetAllPoints()
	credit.Icon:SetTexture(DB.creditTex)
	credit:SetHighlightTexture(DB.creditTex)
	credit:SetScript("OnEnter", function()
		GameTooltip:ClearLines()
		GameTooltip:SetOwner(f, "ANCHOR_NONE")
		GameTooltip:SetPoint("TOPLEFT", f, "TOPRIGHT", 5, -3)
		GameTooltip:AddLine("Credits:")
		GameTooltip:AddLine(GetAddOnMetadata("NDui", "X-Credits"), .6,.8,1, 1)
		GameTooltip:Show()
	end)
	credit:SetScript("OnLeave", B.HideTooltip)

	local function showLater(event)
		if event == "PLAYER_REGEN_DISABLED" then
			if f:IsShown() then
				f:Hide()
				B:RegisterEvent("PLAYER_REGEN_ENABLED", showLater)
			end
		else
			f:Show()
			B:UnregisterEvent(event, showLater)
		end
	end
	B:RegisterEvent("PLAYER_REGEN_DISABLED", showLater)

	SelectTab(1)
end

function G:OnLogin()
	local gui = CreateFrame("Button", "GameMenuFrameNDui", GameMenuFrame, "GameMenuButtonTemplate")
	gui:SetText(L["NDui Console"])
	gui:SetPoint("TOP", GameMenuButtonAddons, "BOTTOM", 0, -21)
	GameMenuFrame:HookScript("OnShow", function(self)
		GameMenuButtonLogout:SetPoint("TOP", gui, "BOTTOM", 0, -21)
		self:SetHeight(self:GetHeight() + gui:GetHeight() + 22)
	end)

	gui:SetScript("OnClick", function()
		if InCombatLockdown() then UIErrorsFrame:AddMessage(DB.InfoColor..ERR_NOT_IN_COMBAT) return end
		OpenGUI()
		HideUIPanel(GameMenuFrame)
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
	end)

	if NDuiDB["Skins"]["BlizzardSkins"] then B.ReskinButton(gui) end
end