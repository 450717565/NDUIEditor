local _, ns = ...
local B, C, L, DB = unpack(ns)
local GUI = B:RegisterModule("GUI")

local tonumber, pairs, ipairs, next, type, tinsert = tonumber, pairs, ipairs, next, type, tinsert
local cr, cg, cb = DB.cr, DB.cg, DB.cb
local guiTab, guiPage, f = {}, {}

-- Default Settings
GUI.DefaultSettings = {
	BFA = false,
	Mover = {},
	InternalCD = {},
	AuraWatchMover = {},
	TempAnchor = {},
	AuraWatchList = {
		Switcher = {},
		IgnoreSpells = {},
	},
	ActionBar = {
		Enable = true,
		Bar4Fade = false,
		Bar5Fade = false,
		BindType = 1,
		Cooldown = true,
		Count = true,
		Hotkeys = true,
		Macro = true,
		MicroMenu = true,
		StanceBar = true,
		OverrideWA = false,
		BarScale = 1,
		BarStyle = 1,

		CustomBar = false,
		CustomBarFader = false,
		CustomBarButtonSize = 34,
		CustomBarNumButtons = 12,
		CustomBarNumPerRow = 12,
	},
	Bags = {
		Enable = true,
		AutoDeposit = false,
		BagsiLvl = true,
		BagSortMode = 1,
		BagsScale = 1,
		BagsSlot = true,
		BagsWidth = 16,
		BankWidth = 16,
		DeleteButton = false,
		FavouriteItems = {},
		GatherEmpty = true,
		IconSize = 34,
		iLvlToShow = 1,
		ItemFilter = true,
		ShowNewItem = true,
		SpecialBagsColor = false,
		SplitCount = 1,

		FilterAzerite = true,
		FilterCollection = true,
		FilterConsumable = true,
		FilterEquipment = true,
		FilterEquipSet = true,
		FilterFavourite = true,
		FilterGoods = true,
		FilterJunk = true,
		FilterLegendary = true,
		FilterQuest = true,
	},
	Auras = {
		BuffSize = 30,
		BuffsPerRow = 16,
		ClassAuras = true,
		DebuffSize = 30,
		DebuffsPerRow = 16,
		Reminder = true,
		ReverseBuffs = false,
		ReverseDebuffs = false,
		Totems = true,
		TotemSize = 32,
		VerticalTotems = false,
	},
	AuraWatch = {
		Enable = true,
		ClickThrough = false,
		IconScale = 1,
		DeprecatedAuras = false,
		QuakeRing = false,
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
		DispellOnly = false,
		RaidIconScale = 1,
		SpecRaidPos = false,
		RaidHealthColor = 1,
		HorizonRaid = false,
		HorizonParty = false,
		ReverseRaid = false,
		ShowSolo = false,
		RaidHPMode = 1,
		AurasClickThrough = false,
		CombatText = true,
		HotsDots = true,
		AutoAttack = true,
		FCTOverHealing = false,
		FCTFontSize = 18,
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
		PWOtherSide = false,
		PartyPetFrame = false,
		HealthColor = 1,
		BuffIndicatorType = 2,
		BuffIndicatorScale = 1,
		UFTextScale = 1,
		PartyAltPower = true,
		PartyWatcherSync = true,
		SmoothAmount = .3,
		RaidTextScale = 1,
		FrequentHealth = false,
		HealthFrequency = .2,
		TargetAurasPerRow = 9,

		RaidAurasMode = true,

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

		SimpleRaidScale = 10,
		RaidWidth = 80,
		RaidHeight = 32,
		RaidPowerHeight = 2,

		PartyWidth = 120,
		PartyHeight = 40,
		PartyPowerHeight = 2,
		PartyPetWidth = 80,
		PartyPetHeight = 22,
		PartyPetPowerHeight = 2,

		CastingColor = {r=.3, g=.7, b=1},
		NotInterruptColor = {r=1, g=.5, b=.5},
		PlayerCBWidth = 280,
		PlayerCBHeight = 20,
		TargetCBWidth = 300,
		TargetCBHeight = 20,
		FocusCBWidth = 320,
		FocusCBHeight = 20,
	},
	Chat = {
		AllowFriends = true,
		BlockAddonAlert = true,
		BlockStranger = false,
		Chatbar = true,
		ChatBGType = 3,
		ChatHeight = 190,
		ChatWidth = 380,
		ChatItemLevel = true,
		ChatMenu = true,
		EnableFilter = true,
		Freedom = true,
		GuildInvite = true,
		Invite = true,
		Keyword = "raid",
		Lock = true,
		Matches = 1,
		Oldname = true,
		Sticky = true,
		WhisperColor = true,
	},
	Map = {
		EnableMap = true,
		Calendar = false,
		Clock = false,
		CombatPulse = true,
		MapReveal = true,
		MapRevealGlow = true,
		MapScale = 1,
		MaxMapScale = 1,
		MinimapScale = 1.4,
		ShowRecycleBin = true,
		WhoPings = true,
	},
	Nameplate = {
		Enable = true,
		MaxAuras = 12,
		AuraPerRow = 6,
		AuraFilter = 3,
		FriendlyCC = false,
		HostileCC = true,
		TankMode = false,
		TargetIndicator = 4,
		InsideView = true,
		PlateWidth = 200,
		PlateHeight = 12,
		CustomUnitColor = true,
		CustomColor = {r=0, g=.8, b=.3},
		UnitList = "",
		ShowPowerList = "",
		VerticalSpacing = .8,
		ShowPlayerPlate = false,
		PPWidth = 175,
		PPBarHeight = 5,
		PPHealthHeight = 5,
		PPPowerHeight = 5,
		PPPowerText = false,
		SecureColor = {r=1, g=0, b=1},
		TransColor = {r=1, g=.8, b=0},
		InsecureColor = {r=1, g=0, b=0},
		OffTankColor = {r=.2, g=.7, b=.5},
		DPSRevertThreat = false,
		ExplosivesScale = false,
		AKSProgress = true,
		PPFadeout = true,
		PPFadeoutAlpha = 0,
		PPOnFire = false,
		NameplateClassPower = false,
		NameTextSize = 14,
		HealthTextSize = 16,
		MinScale = 1,
		MinAlpha = .8,
		QuestIndicator = true,
		NameOnlyMode = false,
		PPGCDTicker = true,
		ExecuteRatio = 0,
		ColoredTarget = false,
		TargetColor = {r=0, g=.6, b=1},
		ColoredFocus = false,
		FocusColor = {r=1, g=.8, b=0},
		CastGlow = true,
		CastTarget = true,

		NPsHPMode = 1,
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
		SkinShadow = true,
		SkinTexture = false,
		CCShadow = true,

		FontScale = 1,
		GSDirection = 1,
		SkinStyle = 1,
		ToggleDirection = 1,

		BGAlpha = .5,
		SDAlpha = .25,
		FSAlpha = .3,
		GSAlpha1 = .3,
		GSAlpha2 = .6,
		BGColor = {r=0, g=0, b=0},
		SDColor = {r=0, g=0, b=0},
		FSColor = {r=.6, g=.6, b=.6},
		GSColor1 = {r=.6, g=.6, b=.6},
		GSColor2 = {r=.3, g=.3, b=.3},
		LineColor = {r=.5, g=.5, b=.5},
	},
	Tooltip = {
		CombatHide = false,
		Cursor = true,
		ColorBorder = true,
		HideRank = false,
		FactionIcon = true,
		LFDRole = false,
		TargetBy = true,
		TTScale = 1,
		SpecLevelByShift = false,
		HideRealm = false,
		HideTitle = false,
		HideJunkGuild = true,
		AzeriteArmor = true,
		OnlyArmorIcons = false,
		ConduitInfo = true,
		HideAllID = false,
	},
	Misc = {
		Mail = true,
		ItemLevel = true,
		GemNEnchant = true,
		AzeriteTraits = true,
		MissingStats = true,
		SoloInfo = true,
		Focuser = true,
		ExpRep = true,
		Screenshot = true,
		TradeTabs = true,
		Interrupt = false,
		OwnInterrupt = true,
		AlertInInstance = true,
		BrokenSpell = false,
		FasterLoot = true,
		AutoQuest = false,
		HideTalking = false,
		HideBossBanner = true,
		HideBossEmote = false,
		PetFilter = true,
		QuestNotification = false,
		QuestProgress = false,
		OnlyCompleteRing = false,
		ExplosiveCount = false,
		ExplosiveCache = {},
		CastAlert = true,
		RareAlertInWild = false,
		ParagonRep = true,
		InstantDelete = true,
		RaidTool = true,
		RunesCheck = false,
		DBMCount = "10",
		EasyMarkKey = 1,
		ShowMarkerBar = 4,
		BlockInvite = false,
		NzothVision = true,
		SendActionCD = false,
		MawThreatBar = true,
		MDGuildBest = true,
		FasterSkip = false,
		EnhanceDressup = true,

		RareAlerter = true,
		RareAlertMode = 2,
	},
	Tutorial = {
		Complete = false,
	},
	Extras = {
		AfkDelight = true,
		AutoCollapse = true,
		GuildWelcome = true,
		FreeMountCD = true,

		Progression = true,
		ProgRaids = true,
		ProgDungeons = true,
		ProgAchievement = true,

		LootMonitor = true,
		LootMonitorBonusRewards = false,
		LootMonitorInGroup = true,
		LootMonitorQuality = 4,

		iLvlTools = true,
		ShowCharacterItemSheet = true,
		ShowOwnFrameWhenInspecting = true,

		GlobalFade = false,
		GlobalFadeActionBar = true,
		GlobalFadeUnitFrame = true,
		GlobalFadeAlpha = .1,
		GlobalFadeDuration = .3,
		GlobalFadeCombat = true,
		GlobalFadeTarget = true,
		GlobalFadeCast = true,
		GlobalFadeHealth = true,
	},
}

GUI.AccountSettings = {
	ChatFilterList = "%*",
	ChatFilterWhiteList = "",
	TimestampFormat = 1,
	NameplateFilter = {[1]={}, [2]={}},
	RaidDebuffs = {},
	Changelog = {},
	totalGold = {},
	ShowSlots = false,
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
	RaidClickSets = {},
	TexStyle = 4,
	KeystoneInfo = {},
	AutoBubbles = false,
	DisableInfobars = false,
	ContactList = {},
	CustomJunkList = {},
	ProfileIndex = {},
	ProfileNames = {},
	Help = {},
	PartySpells = {},
	CornerSpells = {},
	CustomTex = "",
	MajorSpells = {},
}

-- Initial settings
GUI.TextureList = {
	[1] = {texture = DB.normTex, name = L["Highlight"]},
	[2] = {texture = DB.gradTex, name = L["Gradient"]},
	[3] = {texture = DB.flatTex, name = L["Flat"]},
	[4] = {texture = DB.rhomTex, name = L["Rhomb"]},
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

	InitialSettings(GUI.AccountSettings, NDuiADB)
	if not next(NDuiPDB) then
		for i = 1, 5 do NDuiPDB[i] = {} end
	end

	if not NDuiADB["ProfileIndex"][DB.MyFullName] then
		NDuiADB["ProfileIndex"][DB.MyFullName] = 1
	end

	if NDuiADB["ProfileIndex"][DB.MyFullName] == 1 then
		C.db = NDuiDB
		if not C.db["BFA"] then
			wipe(C.db)
			C.db["BFA"] = true
		end
	else
		C.db = NDuiPDB[NDuiADB["ProfileIndex"][DB.MyFullName] - 1]
	end
	InitialSettings(GUI.DefaultSettings, C.db, true)

	B.SetupUIScale(true)
	if NDuiADB["CustomTex"] ~= "" then
		DB.normTex = "Interface\\"..NDuiADB["CustomTex"]
	else
		if not GUI.TextureList[NDuiADB["TexStyle"]] then
			NDuiADB["TexStyle"] = 4 -- reset value if not exists
		end
		DB.normTex = GUI.TextureList[NDuiADB["TexStyle"]].texture
	end

	self:UnregisterAllEvents()
end)

-- Callbacks
local function setupBagFilter()
	GUI:SetupBagFilter(guiPage[2])
end

local function setupUnitFrame()
	GUI:SetupUnitFrame(guiPage[3])
end

local function setupCastbar()
	GUI:SetupCastbar(guiPage[3])
end

local function setupRaidFrame()
	GUI:SetupRaidFrame(guiPage[4])
end

local function setupRaidDebuffs()
	GUI:SetupRaidDebuffs(guiPage[4])
end

local function setupClickCast()
	GUI:SetupClickCast(guiPage[4])
end

local function setupBuffIndicator()
	GUI:SetupBuffIndicator(guiPage[4])
end

local function setupPartyWatcher()
	GUI:SetupPartyWatcher(guiPage[4])
end

local function setupNameplateFilter()
	GUI:SetupNameplateFilter(guiPage[5])
end

local function setupPlateCastGlow()
	GUI:PlateCastGlow(guiPage[5])
end

local function setupAuraWatch()
	f:Hide()
	SlashCmdList["NDUI_AWCONFIG"]()
end

local function updateBagSortOrder()
	SetSortBagsRightToLeft(C.db["Bags"]["BagSortMode"] == 1)
end

local function updateBagStatus()
	B:GetModule("Bags"):UpdateAllBags()
end

local function updateActionbarScale()
	B:GetModule("ActionBar"):UpdateAllScale()
end

local function updateCustomBar()
	B:GetModule("ActionBar"):UpdateCustomBar()
end

local function updateHotkeys()
	local Bar = B:GetModule("ActionBar")
	for _, button in pairs(Bar.buttons) do
		if button.UpdateHotkeys then
			button:UpdateHotkeys(button.buttonType)
		end
	end
end

local function updateBuffFrame()
	local Auras = B:GetModule("Auras")
	Auras:UpdateOptions()
	Auras:UpdateHeader(Auras.BuffFrame)
	Auras.BuffFrame.mover:SetSize(Auras.BuffFrame:GetSize())
end

local function updateDebuffFrame()
	local Auras = B:GetModule("Auras")
	Auras:UpdateOptions()
	Auras:UpdateHeader(Auras.DebuffFrame)
	Auras.DebuffFrame.mover:SetSize(Auras.DebuffFrame:GetSize())
end

local function updateReminder()
	B:GetModule("Auras"):InitReminder()
end

local function refreshTotemBar()
	if not C.db["Auras"]["Totems"] then return end
	B:GetModule("Auras"):TotemBar_Init()
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

local function toggleChatBackground()
	B:GetModule("Chat"):ToggleChatBackground()
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

local function updateRaidNameText()
	B:GetModule("UnitFrames"):UpdateRaidNameText()
end

local function updateUFTextScale()
	B:GetModule("UnitFrames"):UpdateTextScale()
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
	B.SetSmoothingAmount(C.db["UFs"]["SmoothAmount"])
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

local function updateQuestNotification()
	B:GetModule("Misc"):QuestNotification()
end

local function updateScreenShot()
	B:GetModule("Misc"):UpdateScreenShot()
end

local function updateFasterLoot()
	B:GetModule("Misc"):UpdateFasterLoot()
end

local function toggleBossBanner()
	B:GetModule("Misc"):ToggleBossBanner()
end

local function toggleBossEmote()
	B:GetModule("Misc"):ToggleBossEmote()
end

local function updateMarkerGrid()
	B:GetModule("Misc"):RaidTool_UpdateGrid()
end

local function updateSkinAlpha()
	local BGColor = C.db["Skins"]["BGColor"]
	local BGAlpha = C.db["Skins"]["BGAlpha"]

	for _, frame in pairs(C.frames) do
		frame:SetBackdropColor(BGColor.r, BGColor.g, BGColor.b, BGAlpha)
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

local function AddTextureToOption(parent, index)
	local tex = parent[index]:CreateTexture()
	tex:SetInside(nil, 4, 4)
	tex:SetTexture(GUI.TextureList[index].texture)
	tex:SetVertexColor(cr, cg, cb)
end

-- Config
local NewFeatureTag = "|TInterface\\OptionsFrame\\UI-OptionsFrame-NewFeatureIcon:0|t"

GUI.TabList = {
	L["ActionBar"],
	L["Bags"],
	L["Unitframes"],
	NewFeatureTag..L["RaidFrame"],
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
	L["Profile"],
	L["Extras"],
}

GUI.OptionList = { -- type, key, value, name, horizon, doubleline
	[1] = {
		{1, "ActionBar", "Enable", DB.MyColor..L["Enable ActionBar"]},
		{},--blank
		{1, "ActionBar", "MicroMenu", L["Micro Menu"]},
		{1, "ActionBar", "StanceBar", L["Stance Bar"], true},
		{1, "ActionBar", "Bar4Fade", L["Bar4 Fade"]},
		{1, "ActionBar", "Bar5Fade", L["Bar5 Fade"], true},
		{4, "ActionBar", "BarStyle", L["ActionBar Style"], false, {L["BarStyle1"], L["BarStyle2"], L["BarStyle3"], L["BarStyle4"], L["BarStyle5"]}},
		{3, "ActionBar", "BarScale", L["ActionBar Scale"].."*", true, {.5, 1.5, .01}, updateActionbarScale},
		{},--blank
		{1, "ActionBar", "CustomBar", DB.MyColor..L["Enable CustomBar"], nil, nil, nil, L["CustomBar Tip"]},
		{1, "ActionBar", "CustomBarFader", L["CustomBar Fader"]},
		{3, "ActionBar", "CustomBarButtonSize", L["CustomBar ButtonSize"].."*", true, {24, 60, 1}, updateCustomBar},
		{3, "ActionBar", "CustomBarNumButtons", L["CustomBar NumButtons"].."*", nil, {1, 12, 1}, updateCustomBar},
		{3, "ActionBar", "CustomBarNumPerRow", L["CustomBar NumPerRow"].."*", true, {1, 12, 1}, updateCustomBar},
		{},--blank
		{1, "ActionBar", "Cooldown", DB.MyColor..L["Show Cooldown"]},
		{1, "ActionBar", "OverrideWA", L["Override WA"].."*", true},
		{1, "Misc", "SendActionCD", DB.MyColor..L["Send ActionCD"].."*", false, nil, nil, L["Send Action CD Tip"]},
		{},--blank
		{1, "ActionBar", "Hotkeys", L["ActionBar Hotkey"].."*", nil, nil, updateHotkeys},
		{1, "ActionBar", "Macro", L["ActionBar Macro"], true},
		{1, "ActionBar", "Count", L["ActionBar Counts"]},
	},
	[2] = {
		{1, "Bags", "Enable", DB.MyColor..L["Enable Bags"]},
		{1, "Bags", "ItemFilter", L["Bags ItemFilter"].."*", true, setupBagFilter, updateBagStatus},
		{},--blank
		{1, "Bags", "GatherEmpty", L["Bags GatherEmpty"], false},
		{1, "Bags", "SpecialBagsColor", L["SpecialBags Color"].."*", true, nil, updateBagStatus, L["Special Bags Color Tip"]},
		{1, "Bags", "DeleteButton", L["Bags DeleteButton"], false},
		{1, "Bags", "ShowNewItem", L["Bags ShowNewItem"], true},
		{1, "Bags", "BagsiLvl", L["Bags Itemlevel"], false},
		{1, "Bags", "BagsSlot", L["Bags ItemSlot"], true, nil, updateBagStatus},
		{3, "Bags", "iLvlToShow", L["Bags iLvlToShow"].."*", false, {1, 500, 1}, nil, L["iLvlToShowTip"]},
		{4, "Bags", "BagSortMode", L["Bag SortMode"].."*", true, {L["Forward"], L["Backward"], DISABLE}, updateBagSortOrder, L["BagSortTip"]},
		{},--blank
		{3, "Bags", "BagsScale", L["Bags Scale"], false, {.5, 1.5, .01}},
		{3, "Bags", "IconSize", L["Bags IconSize"], true, {30, 42, 1}},
		{3, "Bags", "BagsWidth", L["Bags Width"], false, {10, 40, 1}},
		{3, "Bags", "BankWidth", L["Bank Width"], true, {10, 40, 1}},
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
		{4, "UFs", "HealthColor", L["HealthColor"].."*", nil, {L["Default Dark"], L["ClassColorHP"], L["GradientHP"]}, updateUFTextScale},
		{3, "UFs", "TargetAurasPerRow", L["TargetAurasPerRow"].."*", true, {5, 10, 1}, updateTargetFrameAuras},
		{3, "UFs", "UFTextScale", L["UFTextScale"].."*", nil, {.5, 1.5, .01}, updateUFTextScale},
		{3, "UFs", "SmoothAmount", DB.MyColor..L["SmoothAmount"].."*", true, {.2, .6, .01}, updateSmoothingAmount, L["SmoothAmountTip"]},
		{},--blank
		{1, "UFs", "CombatText", DB.MyColor..L["UFs CombatText"]},
		{1, "UFs", "AutoAttack", L["CombatText AutoAttack"].."*"},
		{1, "UFs", "PetCombatText", L["CombatText ShowPets"].."*", true},
		{1, "UFs", "HotsDots", L["CombatText HotsDots"].."*"},
		{1, "UFs", "FCTOverHealing", L["CombatText OverHealing"].."*"},
		{3, "UFs", "FCTFontSize", L["FCTFontSize"].."*", true, {12, 40, 1}},
	},
	[4] = {
		{1, "UFs", "RaidFrame", DB.MyColor..L["UFs RaidFrame"], nil, setupRaidFrame, nil, L["RaidFrameTip"]},
		{},--blank
		{1, "UFs", "PartyFrame", DB.MyColor..L["UFs PartyFrame"]},
		{1, "UFs", "PartyPetFrame", DB.MyColor..L["UFs PartyPetFrame"], true},
		{1, "UFs", "HorizonParty", L["Horizon PartyFrame"]},
		{1, "UFs", "PartyAltPower", L["UFs PartyAltPower"], true, nil, nil, L["PartyAltPowerTip"]},
		{1, "UFs", "PartyWatcher", DB.MyColor..L["UFs PartyWatcher"], nil, setupPartyWatcher, nil, L["PartyWatcherTip"]},
		{1, "UFs", "PWOtherSide", L["PartyWatcherOnRight"], true},
		{1, "UFs", "PartyWatcherSync", L["PartyWatcherSync"], nil, nil, nil, L["PartyWatcherSyncTip"]},
		{},--blank
		{1, "UFs", "RaidClickSets", DB.MyColor..L["Enable ClickSets"], nil, setupClickCast},
		{1, "UFs", "AutoRes", L["UFs AutoRes"], true},
		{1, "UFs", "RaidBuffIndicator", DB.MyColor..L["RaidBuffIndicator"], nil, setupBuffIndicator, nil, L["RaidBuffIndicatorTip"]},
		{1, "UFs", "RaidAurasMode", L["RaidAurasMode"], true, nil, nil, L["RaidAurasModeTip"]},
		{4, "UFs", "BuffIndicatorType", L["BuffIndicatorType"].."*", nil, {L["BI_Blocks"], L["BI_Icons"], L["BI_Numbers"]}, refreshRaidFrameIcons},
		{3, "UFs", "BuffIndicatorScale", L["BuffIndicatorScale"].."*", true, {.5, 2, .01}, refreshRaidFrameIcons},
		{1, "UFs", "InstanceAuras", DB.MyColor..L["Instance Auras"], nil, setupRaidDebuffs, nil, L["InstanceAurasTip"]},
		{1, "UFs", "DispellOnly", L["DispellableOnly"], nil, nil, nil, L["DispellableOnlyTip"]},
		{1, "UFs", "AurasClickThrough", L["RaidAuras ClickThrough"], nil, nil, nil, L["ClickThroughTip"]},
		{3, "UFs", "RaidIconScale", L["Raid Icon Scale"].."*", true, {.5, 2, .01}, refreshRaidFrameIcons},
		{},--blank
		{1, "UFs", "ShowSolo", L["ShowSolo"], nil, nil, nil, L["ShowSoloTip"]},
		{1, "UFs", "SpecRaidPos", L["Spec RaidPos"], true, nil, nil, L["SpecRaidPosTip"]},
		{1, "UFs", "ShowTeamIndex", L["RaidFrame TeamIndex"]},
		{1, "UFs", "FrequentHealth", DB.MyColor..L["FrequentHealth"].."*", true, nil, updateRaidHealthMethod, L["FrequentHealthTip"]},
		{1, "UFs", "HorizonRaid", L["Horizon RaidFrame"]},
		{1, "UFs", "ReverseRaid", L["Reverse RaidFrame"]},
		{3, "UFs", "HealthFrequency", L["HealthFrequency"].."*", true, {.05, .25, .01}, updateRaidHealthMethod, L["HealthFrequencyTip"]},
		{3, "UFs", "NumGroups", L["Num Groups"], nil, {4, 8, 1}},
		{3, "UFs", "RaidTextScale", L["UFTextScale"].."*", true, {.5, 1.5, .01}, updateRaidTextScale},
		{4, "UFs", "RaidHealthColor", L["HealthColor"].."*", nil, {L["Default Dark"], L["ClassColorHP"], L["GradientHP"]}, updateRaidTextScale},
		{4, "UFs", "RaidHPMode", L["RaidHPMode"].."*", true, {L["DisableRaidHP"], L["RaidHPPercent"], L["RaidHPCurrent"], L["RaidHPLost"]}, updateRaidNameText},
		{},--blank
		{1, "UFs", "SimpleMode", DB.MyColor..L["SimpleRaidFrame"], nil, nil, nil, L["SimpleRaidFrameTip"]},
		{3, "UFs", "SMUnitsPerColumn", L["SimpleMode Column"], nil, {10, 40, 1}},
		{4, "UFs", "SMGroupByIndex", L["SimpleMode GroupBy"].."*", true, {GROUP, CLASS, ROLE}, updateSimpleModeGroupBy},
		{nil, true},-- FIXME: dirty fix for now
		{nil, true},
	},
	[5] = {
		{1, "Nameplate", "Enable", DB.MyColor..L["Enable Nameplate"], nil, setupNameplateFilter},
		{1, "Nameplate", "NameOnlyMode", L["NameOnlyMode"].."*", true, nil, nil, L["NameOnlyModeTip"]},
		{4, "Nameplate", "TargetIndicator", L["TargetIndicator"].."*", nil, {DISABLE, L["TopArrow"], L["RightArrow"], L["TargetGlow"], L["TopNGlow"], L["RightNGlow"]}, refreshNameplates},
		{4, "Nameplate", "ArrowColor", L["Arrow Color"], true, {L["Cyan"], L["Green"], L["Red"]}},
		{4, "Nameplate", "NPsHPMode", L["HP Val Mode"].."*", false, {L["Only Percent"], L["Only Number"], L["Num and Per"]}, refreshNameplates},
		{4, "Nameplate", "AuraFilter", L["NameplateAuraFilter"].."*", true, {L["BlackNWhite"], L["PlayerOnly"], L["IncludeCrowdControl"]}, refreshNameplates},
		{},--blank
		{1, "Nameplate", "CastGlow", DB.MyColor..L["PlateCastGlow"].."*", nil, setupPlateCastGlow, nil, L["PlateCastGlowTip"]},
		{1, "Nameplate", "CastTarget", L["PlateCastTarget"].."*", true, nil, nil, L["PlateCastTargetTip"]},
		{1, "Nameplate", "FriendlyCC", L["Friendly CC"].."*"},
		{1, "Nameplate", "HostileCC", L["Hostile CC"].."*", true},
		{1, "Nameplate", "InsideView", L["Nameplate InsideView"].."*", nil, nil, updatePlateInsideView},
		{1, "Nameplate", "AKSProgress", L["AngryKeystones Progress"], true},
		{1, "Nameplate", "QuestIndicator", L["QuestIndicator"]},
		{1, "Nameplate", "ExplosivesScale", L["Explosives Scale"], true, nil, nil, L["Explosives Scale Tip"]},
		{},--blank
		{5, "Nameplate", "HighlightColor", L["Highlight Color"]},
		{5, "Nameplate", "SelectedColor", L["Selected Color"], 2},
		{1, "Nameplate", "ColoredTarget", DB.MyColor..L["ColoredTarget"].."*", nil, nil, nil, L["ColoredTargetTip"]},
		{1, "Nameplate", "ColoredFocus", DB.MyColor..L["ColoredFocus"].."*", true, nil, nil, L["ColoredFocusTip"]},
		{5, "Nameplate", "TargetColor", L["TargetNP Color"].."*"},
		{5, "Nameplate", "FocusColor", L["FocusNP Color"].."*", 2},
		{},--blank
		{1, "Nameplate", "CustomUnitColor", DB.MyColor..L["CustomUnitColor"].."*", nil, nil, updateCustomUnitList, L["CustomUnitColorTip"]},
		{5, "Nameplate", "CustomColor", L["Custom Color"].."*", 2},
		{2, "Nameplate", "UnitList", L["UnitColor List"].."*", nil, nil, updateCustomUnitList, L["CustomUnitTips"]},
		{2, "Nameplate", "ShowPowerList", L["ShowPowerList"].."*", true, nil, updatePowerUnitList, L["CustomUnitTips"]},
		{},--blank
		{1, "Nameplate", "TankMode", DB.MyColor..L["Tank Mode"].."*", nil, nil, nil, L["TankModeTip"]},
		{1, "Nameplate", "DPSRevertThreat", L["DPS Revert Threat"].."*", true, nil, nil, L["Revert Threat Tip"]},
		{5, "Nameplate", "SecureColor", L["Secure Color"].."*"},
		{5, "Nameplate", "TransColor", L["Trans Color"].."*", 1},
		{5, "Nameplate", "InsecureColor", L["Insecure Color"].."*", 2},
		{5, "Nameplate", "OffTankColor", L["OffTank Color"].."*", 3},
		{},--blank
		{3, "Nameplate", "ExecuteRatio", DB.MyColor..L["ExecuteRatio"].."(%)*", nil, {0, 90, 1}, nil, L["ExecuteRatioTip"]},
		{3, "Nameplate", "VerticalSpacing", L["NP VerticalSpacing"].."*", true, {.5, 1.5, .01}, updatePlateSpacing},
		{3, "Nameplate", "MinScale", L["Nameplate MinScale"].."*", false, {.5, 1, .01}, updatePlateScale},
		{3, "Nameplate", "MinAlpha", L["Nameplate MinAlpha"].."*", true, {.5, 1, .01}, updatePlateAlpha},
		{3, "Nameplate", "PlateWidth", L["NP Width"].."*", false, {50, 250, 1}, refreshNameplates},
		{3, "Nameplate", "PlateHeight", L["NP Height"].."*", true, {5, 30, 1}, refreshNameplates},
		{3, "Nameplate", "NameTextSize", L["NameTextSize"].."*", false, {10, 30, 1}, refreshNameplates},
		{3, "Nameplate", "HealthTextSize", L["HealthTextSize"].."*", true, {10, 30, 1}, refreshNameplates},
		{3, "Nameplate", "MaxAuras", L["Max Auras"].."*", false, {0, 12, 1}, refreshNameplates},
		{3, "Nameplate", "AuraPerRow", L["Aura PerRow"].."*", true, {3, 6, 1}, refreshNameplates},
	},
	[6] = {
		{1, "Nameplate", "ShowPlayerPlate", DB.MyColor..L["Enable PlayerPlate"]},
		{},--blank
		{1, "Auras", "ClassAuras", L["Enable ClassAuras"]},
		{1, "Nameplate", "PPOnFire", L["PlayerPlate OnFire"], true, nil, nil, L["PPOnFireTip"]},
		{1, "Nameplate", "NameplateClassPower", L["Nameplate ClassPower"], nil},
		{1, "Nameplate", "PPFadeout", L["PlayerPlate Fadeout"].."*", true, nil, togglePlateVisibility},
		{1, "Nameplate", "PPPowerText", L["PlayerPlate PowerText"].."*", nil, nil, togglePlatePower},
		{1, "Nameplate", "PPGCDTicker", L["PlayerPlate GCDTicker"].."*", nil, nil, toggleGCDTicker},
		{3, "Nameplate", "PPFadeoutAlpha", L["PlayerPlate FadeoutAlpha"].."*", true, {0, .5, .01}, togglePlateVisibility},
		{},--blank
		{3, "Nameplate", "PPWidth", L["PlayerPlate HPWidth"].."*", false, {150, 300, 1}, refreshNameplates},
		{3, "Nameplate", "PPBarHeight", L["PlayerPlate CPHeight"].."*", true, {5, 15, 1}, refreshNameplates},
		{3, "Nameplate", "PPHealthHeight", L["PlayerPlate HPHeight"].."*", false, {5, 15, 1}, refreshNameplates},
		{3, "Nameplate", "PPPowerHeight", L["PlayerPlate MPHeight"].."*", true, {5, 15, 1}, refreshNameplates},
	},
	[7] = {
		{1, "AuraWatch", "Enable", DB.MyColor..L["Enable AuraWatch"], nil, setupAuraWatch},
		{1, "AuraWatch", "DeprecatedAuras", L["DeprecatedAuras"], true},
		{1, "AuraWatch", "QuakeRing", L["QuakeRing"].."*"},
		{1, "AuraWatch", "ClickThrough", L["AuraWatch ClickThrough"], nil, nil, nil, L["ClickThroughTip"]},
		{3, "AuraWatch", "IconScale", L["AuraWatch IconScale"], true, {.5, 2, .01}},
		{},--blank
		{1, "Auras", "Totems", DB.MyColor..L["Enable Totembar"]},
		{1, "Auras", "VerticalTotems", L["VerticalTotems"].."*", nil, nil, refreshTotemBar},
		{3, "Auras", "TotemSize", L["TotemSize"].."*", true, {24, 60, 1}, refreshTotemBar},
		{},--blank
		{1, "Auras", "Reminder", L["Enable Reminder"].."*", nil, nil, updateReminder, L["ReminderTip"]},
		{},--blank
		{1, "Auras", "ReverseBuffs", L["ReverseBuffs"].."*", nil, nil, updateBuffFrame},
		{1, "Auras", "ReverseDebuffs", L["ReverseDebuffs"].."*", true, nil, updateDebuffFrame},
		{3, "Auras", "BuffSize", L["BuffSize"].."*", nil, {24, 50, 1}, updateBuffFrame},
		{3, "Auras", "DebuffSize", L["DebuffSize"].."*", true, {24, 50, 1}, updateDebuffFrame},
		{3, "Auras", "BuffsPerRow", L["BuffsPerRow"].."*", nil, {10, 20, 1}, updateBuffFrame},
		{3, "Auras", "DebuffsPerRow", L["DebuffsPerRow"].."*", true, {10, 16, 1}, updateDebuffFrame},
	},
	[8] = {
		{1, "Misc", "RaidTool", DB.MyColor..L["Raid Manger"]},
		{1, "Misc", "RunesCheck", L["Runes Check"].."*"},
		{2, "Misc", "DBMCount", L["DBM Count"].."*", true, nil, nil, L["DBM Count Tip"]},
		{4, "Misc", "EasyMarkKey", L["Easy Mark"].."*", nil, {"CTRL", "ALT", "SHIFT", DISABLE}, nil, L["EasyMarkTip"]},
		{4, "Misc", "ShowMarkerBar", L["ShowMarkerBar"].."*", true, {L["Grids"], L["Horizontal"], L["Vertical"], DISABLE}, updateMarkerGrid, L["ShowMarkerBarTip"]},
		{},--blank
		{1, "Misc", "QuestNotification", DB.MyColor..L["QuestNotification"].."*", nil, nil, updateQuestNotification},
		{1, "Misc", "QuestProgress", L["QuestProgress"].."*"},
		{1, "Misc", "OnlyCompleteRing", L["OnlyCompleteRing"].."*", true},
		{},--blank
		{1, "Misc", "Interrupt", DB.MyColor..L["Interrupt Alert"].."*", nil, nil, updateInterruptAlert},
		{1, "Misc", "AlertInInstance", L["Alert In Instance"].."*", true},
		{1, "Misc", "OwnInterrupt", L["Own Interrupt"].."*"},
		{1, "Misc", "BrokenSpell", L["Broken Spell"].."*", true, nil, nil, L["BrokenSpellTip"]},
		{},--blank
		{1, "Misc", "ExplosiveCount", L["Explosive Alert"].."*", nil, nil, updateExplosiveAlert, L["ExplosiveAlertTip"]},
		{1, "Misc", "CastAlert", L["Cast Alert"].."*", true},
		{1, "Misc", "SoloInfo", L["SoloInfo"].."*", nil, nil, updateSoloInfo},
		{1, "Misc", "NzothVision", L["NzothVision"], true},
		{},--blank
		{1, "Misc", "RareAlerter", DB.MyColor..L["Rare Alert"].."*", nil, nil, updateRareAlert},
		{1, "Misc", "RareAlertInWild", L["Rare Alert InWild"].."*"},
		{4, "Misc", "RareAlertMode", L["Rare Alert Mode"].."*", true, {DISABLE, L["Alert Mode 1"], L["Alert Mode 2"]}},
	},
	[9] = {
		{1, "Chat", "Lock", DB.MyColor..L["Lock Chat"]},
		{3, "Chat", "ChatWidth", L["Lock ChatWidth"].."*", nil, {200, 600, 1}, updateChatSize},
		{3, "Chat", "ChatHeight", L["Lock ChatHeight"].."*", true, {100, 500, 1}, updateChatSize},
		{},--blank
		{1, "Chat", "Oldname", L["Default Channel"]},
		{1, "Chat", "Sticky", L["Chat Sticky"].."*", true, nil, updateChatSticky},
		{1, "Chat", "Chatbar", L["Show Chatbar"]},
		{1, "Chat", "WhisperColor", L["Differ WhisperColor"].."*", true},
		{1, "Chat", "ChatItemLevel", L["Show ChatItemLevel"]},
		{1, "Chat", "Freedom", L["Language Filter"], true},
		{4, "ACCOUNT", "TimestampFormat", L["Timestamp Format"].."*", nil, {DISABLE, "03:27 PM", "03:27:32 PM", "15:27", "15:27:32"}},
		{4, "Chat", "ChatBGType", L["Chat BGType"].."*", true, {DISABLE, L["Default Dark"], L["Gradient"]}, toggleChatBackground},
		{},--blank
		{1, "Chat", "EnableFilter", DB.MyColor..L["Enable Chatfilter"]},
		{1, "Chat", "BlockAddonAlert", L["Block AddonAlert"], true},
		{1, "Chat", "AllowFriends", L["Allow FriendsSpam"].."*", nil, nil, nil, L["AllowFriendsSpamTip"]},
		{1, "Chat", "BlockStranger", DB.MyColor..L["Block Stranger"].."*", nil, nil, nil, L["BlockStrangerTip"]},
		{2, "ACCOUNT", "ChatFilterWhiteList", DB.MyColor..L["Filter WhiteList"].."*", true, nil, updateFilterWhiteList, L["ChatFilterWhiteListTip"]},
		{3, "Chat", "Matches", L["Keyword Match"].."*", false, {1, 3, 1}},
		{2, "ACCOUNT", "ChatFilterList", L["Filter List"].."*", true, nil, updateFilterList, L["FilterListTip"]},
		{},--blank
		{1, "Chat", "Invite", DB.MyColor..L["Whisper Invite"]},
		{1, "Chat", "GuildInvite", L["Guild Invite Only"].."*"},
		{2, "Chat", "Keyword", L["Whisper Keyword"].."*", true, nil, updateWhisperList, L["WhisperKeywordTip"]},
	},
	[10] = {
		{1, "Map", "EnableMap", DB.MyColor..L["Enable Map"], nil, nil, nil, L["EnableMapTip"]},
		{1, "Map", "MapRevealGlow", L["Map RevealGlow"].."*", true, nil, nil, L["MapRevealGlowTip"]},
		{3, "Map", "MapScale", L["Map Scale"].."*", false, {.5, 1.5, .01}},
		{3, "Map", "MaxMapScale", L["Maximize Map Scale"].."*", true, {.5, 1.5, .01}},
		{},--blank
		{1, "Map", "Calendar", L["Minimap Calendar"].."*", nil, nil, showCalendar, L["MinimapCalendarTip"]},
		{1, "Map", "Clock", L["Minimap Clock"].."*", true, nil, showMinimapClock},
		{1, "Map", "CombatPulse", L["Minimap Pulse"]},
		{1, "Map", "WhoPings", L["Show WhoPings"], true},
		{1, "Map", "ShowRecycleBin", L["Show RecycleBin"]},
		{1, "Misc", "ExpRep", L["Show Expbar"]},
		{3, "Map", "MinimapScale", L["Minimap Scale"].."*", true, {1, 2, .01}, updateMinimapScale},
	},
	[11] = {
		{1, "Skins", "BlizzardSkins", DB.MyColor..L["BlizzardSkins"], false, nil, nil, L["BlizzardSkinsTips"]},
		{1, "Skins", "FontOutline", L["Font Outline"]},
		{1, "Skins", "SkinTexture", L["Skin Texture"]},
		{3, "Skins", "FontScale", L["Font Scale"], true, {.5, 1.5, .01}},
		{1, "Skins", "SkinShadow", L["Skin Shadow"]},
		{1, "Skins", "CCShadow", L["ClassColor Shadow"]},
		{3, "Skins", "SDAlpha", L["Shadow Alpha"], true, {0, 1, .01}},
		{5, "Skins", "SDColor", L["Shadow Color"], 1},
		{},--blank
		{4, "Skins", "SkinStyle", L["Skin Style"], false, {L["Flat Style"], L["Gradient Style"]}},
		{4, "Skins", "GSDirection", L["Gradient Direction"], true, {L["Horizontal"], L["Vertical"]}},
		{3, "Skins", "FSAlpha", L["Flat Alpha"], false, {0, 1, .01}},
		{3, "Skins", "GSAlpha1", L["Gradient Alpha 1"], true, {0, 1, .01}},
		{3, "Skins", "BGAlpha", L["Backdrop Alpha"].."*", false, {0, 1, .01}, updateSkinAlpha},
		{3, "Skins", "GSAlpha2", L["Gradient Alpha 2"], true, {0, 1, .01}},
		{5, "Skins", "FSColor", L["Flat Color"]},
		{5, "Skins", "BGColor", L["Backdrop Color"], 1},
		{5, "Skins", "GSColor1", L["Gradient Color 1"], 2},
		{5, "Skins", "GSColor2", L["Gradient Color 2"], 3},
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
		{1, "Tooltip", "ColorBorder", L["Color Border"].."*"},
		{3, "Tooltip", "TTScale", L["Tooltip Scale"].."*", true, {.5, 1.5, .01}},
		{},--blank
		{1, "Tooltip", "HideTitle", L["Hide Title"].."*"},
		{1, "Tooltip", "HideRank", L["Hide Rank"].."*", true},
		{1, "Tooltip", "FactionIcon", L["FactionIcon"].."*"},
		{1, "Tooltip", "HideJunkGuild", L["HideJunkGuild"].."*", true},
		{1, "Tooltip", "HideRealm", L["Hide Realm"].."*"},
		{1, "Tooltip", "SpecLevelByShift", L["Show SpecLevelByShift"].."*", true},
		{1, "Tooltip", "LFDRole", L["Group Roles"].."*"},
		{1, "Tooltip", "TargetBy", L["Show TargetedBy"].."*", true},
		{1, "Tooltip", "HideAllID", DB.MyColor..L["HideAllID"]},
		{},--blank
		{1, "Tooltip", "AzeriteArmor", DB.MyColor..L["Show AzeriteArmor"]},
		{1, "Tooltip", "OnlyArmorIcons", L["Armor icons only"].."*", true},
		{1, "Tooltip", "ConduitInfo", DB.MyColor..L["Show ConduitInfo"]},
	},
	[13] = {
		{1, "Misc", "ItemLevel", DB.MyColor..L["Show ItemLevel"], nil, nil, nil, L["ItemLevelTip"]},
		{1, "Misc", "GemNEnchant", L["Show GemNEnchant"].."*"},
		{1, "Misc", "AzeriteTraits", L["Show AzeriteTraits"].."*", true},
		{},--blank
		{1, "Misc", "HideTalking", L["No Talking"]},
		{1, "ACCOUNT", "AutoBubbles", L["AutoBubbles"], true},
		{1, "Misc", "HideBossEmote", L["HideBossEmote"].."*", nil, nil, toggleBossEmote},
		{1, "Misc", "HideBossBanner", L["Hide Bossbanner"].."*", true, nil, toggleBossBanner},
		{1, "Misc", "InstantDelete", L["InstantDelete"].."*"},
		{1, "Misc", "FasterLoot", L["Faster Loot"].."*", true, nil, updateFasterLoot},
		{1, "Misc", "BlockInvite", DB.MyColor..L["BlockInvite"].."*", nil, nil, nil, L["BlockInviteTip"]},
		{1, "Misc", "FasterSkip", L["FasterMovieSkip"], true, nil, nil, L["FasterMovieSkipTip"]},
		{},--blank
		{1, "Misc", "MissingStats", L["Show MissingStats"]},
		{1, "Misc", "ParagonRep", L["ParagonRep"], true},
		{1, "Misc", "Mail", L["Mail Tool"]},
		{1, "Misc", "TradeTabs", L["TradeTabs"], true},
		{1, "Misc", "PetFilter", L["Show PetFilter"]},
		{1, "Misc", "Screenshot", L["Auto ScreenShot"].."*", true, nil, updateScreenShot},
		{1, "Misc", "Focuser", L["Easy Focus"]},
		{1, "Misc", "MDGuildBest", L["MDGuildBest"], true, nil, nil, L["MDGuildBestTip"]},
		{1, "Misc", "MawThreatBar", L["MawThreatBar"], nil, nil, nil, L["MawThreatBarTip"]},
		{1, "Misc", "EnhanceDressup", L["EnhanceDressup"], true, nil, nil, L["EnhanceDressupTip"]},
	},
	[14] = {
		{1, "ACCOUNT", "VersionCheck", L["Version Check"]},
		{1, "ACCOUNT", "DisableInfobars", L["DisableInfobars"], true},
		{},--blank
		{3, "ACCOUNT", "UIScale", L["Setup UIScale"], false, {.4, 1.15, .01}},
		{1, "ACCOUNT", "LockUIScale", DB.MyColor..L["Lock UIScale"], true},
		{},--blank
		{4, "ACCOUNT", "TexStyle", L["Texture Style"], false, {}},
		{4, "ACCOUNT", "NumberFormat", L["Numberize"], true, {L["Number Type1"], L["Number Type2"], L["Number Type3"]}},
		{2, "ACCOUNT", "CustomTex", L["CustomTex"], nil, nil, nil, L["CustomTexTip"]},
	},
	[15] = {
	},
	[16] = {
		{1, "Extras", "AutoCollapse", L["Auto Collapse"]},
		{1, "Extras", "GuildWelcome", L["Guild Welcome"], true},
		{1, "Extras", "AfkDelight", L["Afk Delight"]},
		{1, "Extras", "FreeMountCD", L["Free Mount CD"], true},
		{},--blank
		{1, "Extras", "iLvlTools", DB.MyColor..L["iLvlTools"]},
		{1, "Extras", "ShowCharacterItemSheet", L["Show Character Item Sheet"]},
		{1, "Extras", "ShowOwnFrameWhenInspecting", L["Show Own Frame When Inspecting"], true},
		{},--blank
		{1, "Extras", "Progression", DB.MyColor..L["Progression"].."*", nil, nil, nil, L["ProgressionTip"]},
		{1, "Extras", "ProgRaids", RAIDS},
		{1, "Extras", "ProgDungeons", MYTHIC_DUNGEONS, true},
		{1, "Extras", "ProgAchievement", L["Special Achievement"]},
		{},--blank
		{1, "Extras", "LootMonitor", DB.MyColor..L["LootMonitor Title"]},
		{1, "Extras", "LootMonitorInGroup", L["LootMonitor InGroup"]},
		{1, "Extras", "LootMonitorBonusRewards", L["LootMonitor Bonus Rewards"]},
		{4, "Extras", "LootMonitorQuality", L["LootMonitor Quality"], true, {ITEM_QUALITY1_DESC, ITEM_QUALITY2_DESC, ITEM_QUALITY3_DESC, ITEM_QUALITY4_DESC}},
		{},--blank
		{1, "Extras", "GlobalFade", DB.MyColor..L["Global Fade"]},
		{1, "Extras", "GlobalFadeUnitFrame", L["Global Fade UnitFrame"]},
		{1, "Extras", "GlobalFadeActionBar", L["Global Fade ActionBar"], true},
		{3, "Extras", "GlobalFadeAlpha", L["Global Fade Alpha"], false, {.1, .9, .01}},
		{3, "Extras", "GlobalFadeDuration", L["Global Fade Duration"], true, {.1, .9, .01}},
		{1, "Extras", "GlobalFadeCombat", L["Global Fade Combat"]},
		{1, "Extras", "GlobalFadeTarget", L["Global Fade Target"], true},
		{1, "Extras", "GlobalFadeCast", L["Global Fade Cast"]},
		{1, "Extras", "GlobalFadeHealth", L["Global Fade Health"], true},
	},
}

local function SelectTab(i)
	for num = 1, #GUI.TabList do
		if num == i then
			guiTab[num].bg:SetBackdropColor(cr, cg, cb, .5)
			guiTab[num].checked = true
			guiPage[num]:Show()
		else
			guiTab[num].bg:SetBackdropColor(0, 0, 0, 0)
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
	self.bg:SetBackdropColor(cr, cg, cb, .5)
end
local function tabOnLeave(self)
	if self.checked then return end
	self.bg:SetBackdropColor(0, 0, 0, 0)
end

local function CreateTab(parent, i, name)
	local tab = CreateFrame("Button", nil, parent)
	tab:SetPoint("TOPLEFT", 20, -30*i - 20 + C.mult)
	tab:SetSize(130, 28)

	local label = B.CreateFS(tab, 15, name, "system", "LEFT", 10, 0)
	if i > 15 then label:SetTextColor(cr, cg, cb) end

	local bg = B.CreateBDFrame(tab)
	tab.bg = bg
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
			C.db[key][value] = newValue
		else
			return C.db[key][value]
		end
	end
end

local function CreateOption(i)
	local parent, offset = guiPage[i].child, 20

	for _, option in pairs(GUI.OptionList[i]) do
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

			B.CreateFS(eb, 14, name, "system", "CENTER", 0, 25)
			eb.title = L["Tips"]
			local tip = L["EditBox Tip"]
			if tooltip then tip = tooltip.."|n"..tip end
			B.AddTooltip(eb, "ANCHOR_RIGHT", tip, "info")

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
			s.__default = (key == "ACCOUNT" and GUI.AccountSettings[value]) or GUI.DefaultSettings[key][value]
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
			if value == "TexStyle" then
				for _, v in ipairs(GUI.TextureList) do
					tinsert(data, v.name)
				end
			end

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
						opt[num]:SetBackdropColor(cr, cg, cb, .5)
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
				if value == "TexStyle" then
					AddTextureToOption(opt, i) -- texture preview
				end
			end

			B.CreateFS(dd, 14, name, "system", "CENTER", 0, 25)
			if tooltip then
				dd.title = L["Tips"]
				B.AddTooltip(dd, "ANCHOR_RIGHT", tooltip, "info")
			end
		-- Colorswatch
		elseif optType == 5 then
			local swatch = B.CreateColorSwatch(parent, name, NDUI_VARIABLE(key, value))
			local width = 25 + (horizon or 0)*155
			if horizon then
				swatch:SetPoint("TOPLEFT", width, -offset + 30)
			else
				swatch:SetPoint("TOPLEFT", width, -offset - 5)
				offset = offset + 35
			end
			swatch.__default = (key == "ACCOUNT" and GUI.AccountSettings[value]) or GUI.DefaultSettings[key][value]
		-- Blank, no optType
		else
			if not key then
				local line = B.CreateGA(parent, "H", cr, cg, cb, C.alpha, 0, 560, C.mult*2)
				line:SetPoint("TOPLEFT", 25, -offset - 12)
			end
			offset = offset + 35
		end
	end

	local footer = CreateFrame("Frame", nil, parent)
	footer:SetSize(20, 20)
	footer:SetPoint("TOPLEFT", 25, -offset)
end

local function resetUrlBox(self)
	self:SetText(self.url)
	self:HighlightText()
end

local function CreateContactBox(parent, text, url, index)
	B.CreateFS(parent, 14, text, "system", "TOP", 0, -50 - (index-1) * 60)
	local box = B.CreateEditBox(parent, 250, 24)
	box:SetPoint("TOP", 0, -70 - (index-1) * 60)
	box.url = url
	resetUrlBox(box)
	box:SetScript("OnTextChanged", resetUrlBox)
	box:SetScript("OnCursorChanged", resetUrlBox)
end

local donationList = {
	["afdian"] = "33578473, normanvon, y368413, EK, msylgj, 夜丨灬清寒, akakai, reisen410, 其实你很帥, 萨菲尔, Antares, RyanZ, fldqw, Mario, 时光旧予, 食铁骑兵, 爱蕾丝的基总, 施然, 命运镇魂曲, 不可语上, Leo, 忘川, 刘翰承, 悟空海外党, cncj, 暗月, 汪某人, 黑手, iraq120, 嗜血未冷, 我又不是妖怪，养乐多，无人知晓，秋末旷夜，以及部分未备注名字的用户。",
	["Patreon"] = "Quentin, Julian Neigefind, silenkin, imba Villain, Zeyu Zhu.",
}
local function CreateDonationIcon(parent, texture, name, xOffset)
	local button = B.CreateButton(parent, 30, 30, true, texture)
	button:SetPoint("BOTTOM", xOffset, 45)
	button.title = format(L["Donation"], name)
	B.AddTooltip(button, "ANCHOR_TOP", "|n"..donationList[name], "info")
end

function GUI:AddContactFrame()
	if GUI.ContactFrame then GUI.ContactFrame:Show() return end

	local frame = CreateFrame("Frame", nil, UIParent)
	frame:SetSize(300, 300)
	frame:SetPoint("CENTER")
	B.CreateBG(frame)
	B.CreateWaterMark(frame)

	B.CreateFS(frame, 16, L["Contact"], true, "TOP", 0, -10)
	local ll = B.CreateGA(frame, "H", cr, cg, cb, 0, C.alpha, 80, C.mult*2)
	ll:SetPoint("TOPRIGHT", frame, "TOP", 0, -35)
	local lr = B.CreateGA(frame, "H", cr, cg, cb, C.alpha, 0, 80, C.mult*2)
	lr:SetPoint("TOPLEFT", frame, "TOP", 0, -35)

	CreateContactBox(frame, "NGA.CN", "https://bbs.nga.cn/read.php?tid=5483616", 1)
	CreateContactBox(frame, "GitHub", "https://github.com/siweia/NDui", 2)
	CreateContactBox(frame, "Discord", "https://discord.gg/WXgrfBm", 3)

	CreateDonationIcon(frame, DB.afdianTex, "afdian", -20)
	CreateDonationIcon(frame, DB.patreonTex, "Patreon", 20)

	local back = B.CreateButton(frame, 120, 20, OKAY)
	back:SetPoint("BOTTOM", 0, 15)
	back:SetScript("OnClick", function() frame:Hide() end)

	GUI.ContactFrame = frame
end

local function scrollBarHook(self, delta)
	local scrollBar = self.ScrollBar
	scrollBar:SetValue(scrollBar:GetValue() - delta*35)
end

StaticPopupDialogs["RELOAD_NDUI"] = {
	text = L["ReloadUI Required"],
	button1 = APPLY,
	button2 = CLASS_TRIAL_THANKS_DIALOG_CLOSE_BUTTON,
	OnAccept = function()
		ReloadUI()
	end,
}

local function OpenGUI()
	if f then f:Show() return end

	-- Main Frame
	f = CreateFrame("Frame", "NDuiGUI", UIParent)
	tinsert(UISpecialFrames, "NDuiGUI")
	f:SetSize(800, 600)
	f:SetPoint("CENTER")
	f:SetFrameStrata("HIGH")
	f:SetFrameLevel(10)
	B.CreateBG(f)
	B.CreateMF(f)
	B.CreateFS(f, 18, L["NDui Console"], true, "TOP", 0, -10)
	B.CreateFS(f, 16, DB.Version.." ("..DB.Support..")", false, "TOP", 0, -30)

	local contact = B.CreateButton(f, 130, 20, L["Contact"])
	contact:SetPoint("BOTTOMLEFT", 20, 15)
	contact:SetScript("OnClick", function()
		f:Hide()
		GUI:AddContactFrame()
	end)

	local unlock = B.CreateButton(f, 130, 20, L["UnlockUI"])
	unlock:SetPoint("BOTTOM", contact, "TOP", 0, 2)
	unlock:SetScript("OnClick", function()
		f:Hide()
		SlashCmdList["NDUI_MOVER"]()
	end)

	local close = B.CreateButton(f, 80, 20, CLOSE)
	close:SetPoint("BOTTOMRIGHT", -20, 15)
	close:SetScript("OnClick", function() f:Hide() end)

	local ok = B.CreateButton(f, 80, 20, OKAY)
	ok:SetPoint("RIGHT", close, "LEFT", -5, 0)
	ok:SetScript("OnClick", function()
		B.SetupUIScale()
		f:Hide()
		StaticPopup_Show("RELOAD_NDUI")
	end)

	for i, name in pairs(GUI.TabList) do
		guiTab[i] = CreateTab(f, i, name)

		guiPage[i] = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate")
		guiPage[i]:SetPoint("TOPLEFT", 160, -50)
		guiPage[i]:SetSize(610, 500)
		B.CreateBDFrame(guiPage[i])
		guiPage[i]:Hide()
		guiPage[i].child = CreateFrame("Frame", nil, guiPage[i])
		guiPage[i].child:SetSize(610, 1)
		guiPage[i]:SetScrollChild(guiPage[i].child)
		B.ReskinScroll(guiPage[i].ScrollBar)
		guiPage[i]:SetScript("OnMouseWheel", scrollBarHook)

		CreateOption(i)
	end

	GUI:CreateProfileGUI(guiPage[15]) -- profile GUI

	local helpInfo = B.CreateHelpInfo(f, L["Option* Tips"])
	helpInfo:SetPoint("TOPLEFT", 20, -5)
	local guiHelpInfo = {
		text = L["GUIPanelHelp"],
		buttonStyle = HelpTip.ButtonStyle.GotIt,
		targetPoint = HelpTip.Point.LeftEdgeCenter,
		onAcknowledgeCallback = B.HelpInfoAcknowledge,
		callbackArg = "GUIPanel",
	}
	if not NDuiADB["Help"]["GUIPanel"] then
		HelpTip:Show(helpInfo, guiHelpInfo)
	end

	local credit = CreateFrame("Button", nil, f)
	credit:SetPoint("TOPRIGHT", -20, -5)
	credit:SetSize(40, 40)
	credit.Icon = credit:CreateTexture(nil, "ARTWORK")
	credit.Icon:SetAllPoints()
	credit.Icon:SetTexture(DB.creditTex)
	credit:SetHighlightTexture(DB.creditTex)
	credit.title = "Credits"
	B.AddTooltip(credit, "ANCHOR_BOTTOMLEFT", "|n"..GetAddOnMetadata("NDui", "X-Credits"), "info")

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

function GUI:OnLogin()
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

	if C.db["Skins"]["BlizzardSkins"] then B.ReskinButton(gui) end
end