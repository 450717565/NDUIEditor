local _, ns = ...
local B, C, L, DB = unpack(ns)
local MISC = B:RegisterModule("Misc")

local _G = getfenv(0)
local select, floor, unpack, gsub = select, floor, unpack, gsub
local InCombatLockdown, IsModifiedClick, IsAltKeyDown = InCombatLockdown, IsModifiedClick, IsAltKeyDown
local GetNumArchaeologyRaces = GetNumArchaeologyRaces
local GetNumArtifactsByRace = GetNumArtifactsByRace
local GetArtifactInfoByRace = GetArtifactInfoByRace
local GetArchaeologyRaceInfo = GetArchaeologyRaceInfo
local EquipmentManager_UnequipItemInSlot = EquipmentManager_UnequipItemInSlot
local EquipmentManager_RunAction = EquipmentManager_RunAction
local GetInventoryItemTexture = GetInventoryItemTexture
local GetItemInfo = GetItemInfo
local BuyMerchantItem = BuyMerchantItem
local GetMerchantItemLink = GetMerchantItemLink
local GetMerchantItemMaxStack = GetMerchantItemMaxStack
local Screenshot = Screenshot
local GetTime, GetCVarBool, SetCVar = GetTime, GetCVarBool, SetCVar
local GetNumLootItems, LootSlot = GetNumLootItems, LootSlot
local GetNumSavedInstances = GetNumSavedInstances
local GetInstanceInfo = GetInstanceInfo
local GetSavedInstanceInfo = GetSavedInstanceInfo
local SetSavedInstanceExtend = SetSavedInstanceExtend
local RequestRaidInfo, RaidInfoFrame_Update = RequestRaidInfo, RaidInfoFrame_Update
local IsGuildMember, C_BattleNet_GetGameAccountInfoByGUID, C_FriendList_IsFriend = IsGuildMember, C_BattleNet.GetGameAccountInfoByGUID, C_FriendList.IsFriend
local C_UIWidgetManager_GetDiscreteProgressStepsVisualizationInfo = C_UIWidgetManager.GetDiscreteProgressStepsVisualizationInfo
local C_UIWidgetManager_GetTextureWithAnimationVisualizationInfo = C_UIWidgetManager.GetTextureWithAnimationVisualizationInfo
local C_QuestLog_GetLogIndexForQuestID = C_QuestLog.GetLogIndexForQuestID
local GetOverrideBarSkin, GetActionInfo, GetSpellInfo = GetOverrideBarSkin, GetActionInfo, GetSpellInfo

--[[
	Miscellaneous 各种有用没用的小玩意儿
]]
local MISC_LIST = {}

function MISC:RegisterMisc(name, func)
	if not MISC_LIST[name] then
		MISC_LIST[name] = func
	end
end

function MISC:OnLogin()
	for name, func in pairs(MISC_LIST) do
		if name and type(func) == "function" then
			func()
		end
	end

	-- Init
	MISC:BlockStrangerInvite()
	MISC:EnhanceDressup()
	MISC:ExtendInstance()
	MISC:FasterMovieSkip()
	MISC:FuckTrainSound()
	MISC:MawWidgetFrame()
	MISC:MoveDurabilityFrame()
	MISC:MoveMawBuffsFrame()
	MISC:MoveQuestTracker()
	MISC:MoveTicketStatusFrame()
	MISC:MoveUIWidgetFrame()
	MISC:MoveVehicleSeat()
	MISC:NakedIcon()
	MISC:OverrideAWQ()
	MISC:ToggleBossBanner()
	MISC:ToggleBossEmote()
	MISC:TradeTargetInfo()
	MISC:UpdateFasterLoot()
	MISC:UpdateScreenShot()
	MISC:WorldQuestTool()

	-- Unregister talent event
	if PlayerTalentFrame then
		PlayerTalentFrame:UnregisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	else
		hooksecurefunc("TalentFrame_LoadUI", function()
			PlayerTalentFrame:UnregisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
		end)
	end

	-- Auto chatBubbles
	if NDuiADB["AutoBubbles"] then
		local function updateBubble()
			C_Timer.After(.5, function()
				if IsInInstance() then
					SetCVar("chatBubbles", 1)
				else
					SetCVar("chatBubbles", 0)
				end
			end)
		end
		B:RegisterEvent("PLAYER_ENTERING_WORLD", updateBubble)
	end

	-- Readycheck sound on master channel
	B:RegisterEvent("READY_CHECK", function()
		PlaySound(SOUNDKIT.READY_CHECK, "master")
	end)

	-- Instant delete
	local deleteDialog = StaticPopupDialogs["DELETE_GOOD_ITEM"]
	if deleteDialog.OnShow then
		hooksecurefunc(deleteDialog, "OnShow", function(self)
			if C.db["Misc"]["InstantDelete"] then
				self.editBox:SetText(DELETE_ITEM_CONFIRM_STRING)
			end
		end)
	end

	-- Fix blizz bug in addon list
	local _AddonTooltip_Update = AddonTooltip_Update
	function AddonTooltip_Update(owner)
		if not owner then return end
		if owner:GetID() < 1 then return end
		_AddonTooltip_Update(owner)
	end
end

-- Hide boss banner
function MISC:ToggleBossBanner()
	if C.db["Misc"]["HideBossBanner"] then
		BossBanner:UnregisterAllEvents()
	else
		BossBanner:RegisterEvent("BOSS_KILL")
		BossBanner:RegisterEvent("ENCOUNTER_LOOT_RECEIVED")
	end
end

-- Hide boss emote
function MISC:ToggleBossEmote()
	if C.db["Misc"]["HideBossEmote"] then
		RaidBossEmoteFrame:UnregisterAllEvents()
	else
		RaidBossEmoteFrame:RegisterEvent("RAID_BOSS_EMOTE")
		RaidBossEmoteFrame:RegisterEvent("RAID_BOSS_WHISPER")
		RaidBossEmoteFrame:RegisterEvent("CLEAR_BOSS_EMOTES")
	end
end

-- Get Naked
function MISC:NakedIcon()
	local width = PaperDollSidebarTab1:GetWidth()
	local bu = CreateFrame("Button", nil, CharacterFrameInsetRight)
	bu:SetPoint("TOPLEFT", PaperDollSidebarTab1, "TOPLEFT", -(width+4), 0)
	bu:SetPoint("BOTTOMRIGHT", PaperDollSidebarTab1, "BOTTOMLEFT", -4, 0)
	B.PixelIcon(bu, "Interface\\ICONS\\SPELL_SHADOW_TWISTEDFAITH", true)
	B.AddTooltip(bu, "ANCHOR_RIGHT", L["Get Naked"])

	local function UnequipItemInSlot(i)
		local action = EquipmentManager_UnequipItemInSlot(i)
		EquipmentManager_RunAction(action)
	end

	bu:SetScript("OnDoubleClick", function()
		for i = 1, 17 do
			local texture = GetInventoryItemTexture("player", i)
			if texture then
				UnequipItemInSlot(i)
			end
		end
	end)
end

-- Extend Instance
function MISC:ExtendInstance()
	local bu = CreateFrame("Button", nil, RaidInfoFrame)
	bu:SetSize(25, 25)
	bu:SetPoint("TOPRIGHT", -35, -5)
	B.PixelIcon(bu, GetSpellTexture(80353), true)
	bu.title = L["Extend Instance"]
	local tipStr = format(L["Extend Instance Tip"], DB.LeftButton, DB.RightButton)
	B.AddTooltip(bu, "ANCHOR_RIGHT", tipStr, "system")

	bu:SetScript("OnMouseUp", function(_, btn)
		for i = 1, GetNumSavedInstances() do
			local _, _, _, _, _, extended, _, isRaid = GetSavedInstanceInfo(i)
			if isRaid then
				if btn == "LeftButton" then
					if not extended then
						SetSavedInstanceExtend(i, true)		-- extend
					end
				else
					if extended then
						SetSavedInstanceExtend(i, false)	-- cancel
					end
				end
			end
		end
		RequestRaidInfo()
		RaidInfoFrame_Update()
	end)
end

-- Reanchor Vehicle
function MISC:MoveVehicleSeat()
	local frame = CreateFrame("Frame", "NDuiVehicleSeatMover", UIParent)
	frame:SetSize(125, 125)
	B.Mover(frame, L["VehicleSeat"], "VehicleSeat", {"BOTTOMRIGHT", UIParent, -400, 80})

	hooksecurefunc(VehicleSeatIndicator, "SetPoint", function(self, _, parent)
		if parent == "MinimapCluster" or parent == MinimapCluster then
			B.UpdatePoint(self, "BOTTOM", frame, "BOTTOM", 0, 0)
		end
	end)
end

-- Reanchor UIWidgetBelowMinimapContainerFrame
function MISC:MoveUIWidgetFrame()
	local frame = CreateFrame("Frame", "NDuiUIWidgetMover", UIParent)
	frame:SetSize(200, 50)
	B.Mover(frame, L["UIWidgetFrame"], "UIWidgetFrame", {"TOPRIGHT", Minimap, "BOTTOMRIGHT", 0, -30})

	hooksecurefunc(UIWidgetBelowMinimapContainerFrame, "SetPoint", function(self, _, parent)
		if parent == "MinimapCluster" or parent == MinimapCluster then
			B.UpdatePoint(self, "TOPRIGHT", frame, "TOPRIGHT", 0, 0)
		end
	end)
end

-- Reanchor MawBuffsBelowMinimapFrame
function MISC:MoveMawBuffsFrame()
	local frame = CreateFrame("Frame", "NDuiMawBuffsMover", UIParent)
	frame:SetSize(200, 28)
	local mover = B.Mover(frame, MAW_POWER_DESCRIPTION, "MawBuffs", {"RIGHT", Minimap, "LEFT", -10, 0})
	frame:SetPoint("CENTER", mover)

	hooksecurefunc(MawBuffsBelowMinimapFrame, "SetPoint", function(self, _, parent)
		if parent == "MinimapCluster" or parent == MinimapCluster then
			B.UpdatePoint(self, "CENTER", frame, "CENTER")
		end
	end)
end

-- Reanchor DurabilityFrame
function MISC:MoveDurabilityFrame()
	hooksecurefunc(DurabilityFrame, "SetPoint", function(self, _, parent)
		if parent == "MinimapCluster" or parent == MinimapCluster then
			B.UpdatePoint(self, "TOPRIGHT", Minimap, "BOTTOMRIGHT", 0, -30)
		end
	end)
end

-- Reanchor TicketStatusFrame
function MISC:MoveTicketStatusFrame()
	hooksecurefunc(TicketStatusFrame, "SetPoint", function(self, relF)
		if relF == "TOPRIGHT" then
			B.UpdatePoint(self, "TOP", UIParent, "TOP", -400, -20)
		end
	end)
end

-- Reanchor ObjectiveTracker
function MISC:MoveQuestTracker()
	local frame = CreateFrame("Frame", "NDuiQuestMover", UIParent)
	frame:SetSize(240, 50)
	B.Mover(frame, L["QuestTracker"], "QuestTracker", {"TOPRIGHT", Minimap, "BOTTOM", 0, -30})

	local tracker = ObjectiveTrackerFrame
	B.UpdatePoint(tracker, "TOPRIGHT", frame, "TOPRIGHT")
	tracker:SetHeight(GetScreenHeight()*.65)
	tracker:SetClampedToScreen(false)
	tracker:SetMovable(true)
	if tracker:IsMovable() then tracker:SetUserPlaced(true) end
end

-- Achievement screenshot
function MISC:ScreenShotOnEvent()
	MISC.ScreenShotFrame.delay = 1
	MISC.ScreenShotFrame:Show()
end

function MISC:UpdateScreenShot()
	if not MISC.ScreenShotFrame then
		MISC.ScreenShotFrame = CreateFrame("Frame")
		MISC.ScreenShotFrame:Hide()
		MISC.ScreenShotFrame:SetScript("OnUpdate", function(self, elapsed)
			self.delay = self.delay - elapsed
			if self.delay < 0 then
				Screenshot()
				self:Hide()
			end
		end)
	end

	if C.db["Misc"]["Screenshot"] then
		B:RegisterEvent("ACHIEVEMENT_EARNED", MISC.ScreenShotOnEvent)
	else
		MISC.ScreenShotFrame:Hide()
		B:UnregisterEvent("ACHIEVEMENT_EARNED", MISC.ScreenShotOnEvent)
	end
end

-- Faster Looting
local lootDelay = 0
function MISC:DoFasterLoot()
	local thisTime = GetTime()
	if thisTime - lootDelay >= .3 then
		lootDelay = thisTime
		if GetCVarBool("autoLootDefault") ~= IsModifiedClick("AUTOLOOTTOGGLE") then
			for i = GetNumLootItems(), 1, -1 do
				LootSlot(i)
			end
			lootDelay = thisTime
		end
	end
end

function MISC:UpdateFasterLoot()
	if C.db["Misc"]["FasterLoot"] then
		B:RegisterEvent("LOOT_READY", MISC.DoFasterLoot)
	else
		B:UnregisterEvent("LOOT_READY", MISC.DoFasterLoot)
	end
end

-- TradeFrame hook
function MISC:TradeTargetInfo()
	local infoText = B.CreateFS(TradeFrame, 16)
	B.UpdatePoint(infoText, "TOP", TradeFrameRecipientNameText, "BOTTOM", 0, -5)

	local function updateColor()
		local r, g, b = B.GetUnitColor("NPC")
		B.ReskinText(TradeFrameRecipientNameText, r, g, b)

		local guid = UnitGUID("NPC")
		if not guid then return end
		local text = "|cffFF0000"..L["Stranger"]
		if C_BattleNet_GetGameAccountInfoByGUID(guid) or C_FriendList_IsFriend(guid) then
			text = "|cffFFFF00"..FRIEND
		elseif IsGuildMember(guid) then
			text = "|cff00FF00"..GUILD
		end
		infoText:SetText(text)
	end
	hooksecurefunc("TradeFrame_Update", updateColor)
end

-- Block invite from strangers
function MISC:BlockStrangerInvite()
	B:RegisterEvent("PARTY_INVITE_REQUEST", function(_, _, _, _, _, _, _, guid)
		if C.db["Misc"]["BlockInvite"] and not (C_BattleNet_GetGameAccountInfoByGUID(guid) or C_FriendList_IsFriend(guid) or IsGuildMember(guid)) then
			DeclineGroup()
			StaticPopup_Hide("PARTY_INVITE")
		end
	end)
end

-- Maw widget frame
local maxValue = 1000
local function GetMawBarValue()
	local widgetInfo = C_UIWidgetManager_GetDiscreteProgressStepsVisualizationInfo(2885)
	if widgetInfo and widgetInfo.shownState == 1 then
		local value = widgetInfo.progressVal
		return floor(value / maxValue), value % maxValue
	end
end

function MISC:UpdateMawBarLayout()
	local bar = MISC.mawbar
	local rank, value = GetMawBarValue()
	if rank then
		local r, g, b = B.SmoothColor(rank, 5, true)
		bar:SetStatusBarColor(r, g, b)
		if rank == 5 then
			bar.text:SetText("Lv"..rank)
			bar:SetValue(maxValue)
		else
			bar.text:SetText("Lv"..rank.." - "..value.." / "..maxValue)
			bar:SetValue(value)
		end
		bar:Show()
		UIWidgetTopCenterContainerFrame:Hide()
	else
		bar:Hide()
		UIWidgetTopCenterContainerFrame:Show()
	end
end

function MISC:MawWidgetFrame()
	if not C.db["Misc"]["MawThreatBar"] then return end
	if MISC.mawbar then return end

	local bar = B.CreateSB(UIParent)
	bar:SetPoint("TOP", 0, -50)
	bar:SetSize(200, 16)
	bar:SetMinMaxValues(0, maxValue)
	B.SmoothSB(bar)

	bar.text = B.CreateFS(bar, 14)

	MISC.mawbar = bar

	B.Mover(bar, L["MawThreatBar"], "MawThreatBar", {"TOP", UIParent, 0, -40})

	bar:SetScript("OnEnter", function(self)
		local rank = GetMawBarValue()
		local widgetInfo = rank and C_UIWidgetManager_GetTextureWithAnimationVisualizationInfo(2873 + rank)
		if widgetInfo and widgetInfo.shownState == 1 then
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOM", 0, -10)
			local header, nonHeader = SplitTextIntoHeaderAndNonHeader(widgetInfo.tooltip)
			if header then
				GameTooltip:AddLine(header, nil,nil,nil, 1)
			end
			if nonHeader then
				GameTooltip:AddLine(nonHeader, nil,nil,nil, 1)
			end
			GameTooltip:Show()
		end
	end)
	bar:SetScript("OnLeave", B.HideTooltip)

	MISC:UpdateMawBarLayout()
	B:RegisterEvent("PLAYER_ENTERING_WORLD", MISC.UpdateMawBarLayout)
	B:RegisterEvent("UPDATE_UI_WIDGET", MISC.UpdateMawBarLayout)
end

-- Override default settings for AngrierWorldQuests
function MISC:OverrideAWQ()
	if not IsAddOnLoaded("AngrierWorldQuests") then return end

	AngrierWorldQuests_Config = AngrierWorldQuests_Config or {}
	AngrierWorldQuests_CharacterConfig = AngrierWorldQuests_CharacterConfig or {}

	local settings = {
		hideFilteredPOI = true,
		showHoveredPOI = true,
		lootUpgradesLevel = 0,
		sortMethod = 4,
		timeFilterDuration = 1,
	}
	local function overrideOptions(_, key)
		local value = settings[key]
		if value then
			AngrierWorldQuests_Config[key] = value
			AngrierWorldQuests_CharacterConfig[key] = value
		end
	end
	hooksecurefunc(AngrierWorldQuests.Modules.Config, "Get", overrideOptions)
	hooksecurefunc(AngrierWorldQuests.Modules.Config, "Set", overrideOptions)
end

-- WorldQuestTool
function MISC:WorldQuestTool()
	if not C.db["ActionBar"]["Enable"] then return end
	--https://www.wowhead.com/quest=59585/well-make-an-aspirant-out-of-you
	--https://www.wowhead.com/quest=61540/just-winging-it

	local hasFound
	local function Reset_ActionButtons()
		if not hasFound then return end
		for i = 1, 3 do
			B.HideOverlayGlow(_G["ActionButton"..i])
		end

		hasFound = nil
	end

	local fixedStrings = {
		--["横扫"] = "低扫",
		["表扬"] = "夸奖",
	}

	local function Update_ActionButtons(_, msg)
		if not C_QuestLog_GetLogIndexForQuestID(59585) and not C_QuestLog_GetLogIndexForQuestID(61540) then
			Reset_ActionButtons()
			return
		end

		for i = 1, 3 do
			local button = _G["ActionButton"..i]
			local _, spellID = GetActionInfo(button.action)
			local name = spellID and GetSpellInfo(spellID)
			name = fixedStrings[name] or name

			if name and strfind(msg, name) then
				B.ShowOverlayGlow(button)
			else
				B.HideOverlayGlow(button)
			end
		end

		hasFound = true
	end

	B:RegisterEvent("CHAT_MSG_MONSTER_SAY", Update_ActionButtons)
	B:RegisterEvent("CHAT_MSG_RAID_BOSS_WHISPER", Update_ActionButtons)
	B:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN", Reset_ActionButtons)
end

function MISC:FasterMovieSkip()
	if not C.db["Misc"]["FasterSkip"] then return end

	-- Allow space bar, escape key and enter key to cancel cinematic without confirmation
	if CinematicFrame.closeDialog and not CinematicFrame.closeDialog.confirmButton then
		CinematicFrame.closeDialog.confirmButton = CinematicFrameCloseDialogConfirmButton
	end

	CinematicFrame:HookScript("OnKeyDown", function(self, key)
		if key == "ESCAPE" then
			if self:IsShown() and self.closeDialog and self.closeDialog.confirmButton then
				self.closeDialog:Hide()
			end
		end
	end)
	CinematicFrame:HookScript("OnKeyUp", function(self, key)
		if key == "SPACE" or key == "ESCAPE" or key == "ENTER" then
			if self:IsShown() and self.closeDialog and self.closeDialog.confirmButton then
				self.closeDialog.confirmButton:Click()
			end
		end
	end)
	MovieFrame:HookScript("OnKeyUp", function(self, key)
		if key == "SPACE" or key == "ESCAPE" or key == "ENTER" then
			if self:IsShown() and self.CloseDialog and self.CloseDialog.ConfirmButton then
				self.CloseDialog.ConfirmButton:Click()
			end
		end
	end)
end

function MISC:EnhanceDressup()
	if not C.db["Misc"]["EnhanceDressup"] then return end

	local parent = _G.DressUpFrameResetButton
	local button = MISC:MailBox_CreatButton(parent, 75, 22, L["Undress"], {"RIGHT", parent, "LEFT", -2, 0})
	button:RegisterForClicks("AnyUp")
	button:SetScript("OnClick", function(_, btn)
		local actor = DressUpFrame.ModelScene:GetPlayerActor()
		if not actor then return end

		if btn == "LeftButton" then
			actor:Undress()
		else
			actor:UndressSlot(19)
		end
	end)

	B.AddTooltip(button, "ANCHOR_TOP", format(L["UndressButtonTip"], DB.LeftButton, DB.RightButton))
end

function MISC:FuckTrainSound()
	local trainSounds = {
	--[[Blood Elf]]	"539219", "539203", "1313588", "1306531",
	--[[Draenei]]	"539516", "539730",
	--[[Dwarf]]		"539802", "539881",
	--[[Gnome]]		"540271", "540275",
	--[[Goblin]]	"541769", "542017",
	--[[Human]]		"540535", "540734",
	--[[Night Elf]]	"540870", "540947", "1316209", "1304872",
	--[[Orc]]		"541157", "541239",
	--[[Pandaren]]	"636621", "630296", "630298",
	--[[Tauren]]	"542818", "542896",
	--[[Troll]] 	"543085", "543093",
	--[[Undead]]	"542526", "542600",
	--[[Worgen]]	"542035", "542206", "541463", "541601",
	--[[Dark Iron]]	"1902030", "1902543",
	--[[Highmount]]	"1730534", "1730908",
	--[[Kul Tiran]]	"2531204", "2491898",
	--[[Lightforg]]	"1731282", "1731656",
	--[[MagharOrc]] "1951457", "1951458",
	--[[Mechagnom]] "3107651", "3107182",
	--[[Nightborn]]	"1732030", "1732405",
	--[[Void Elf]]	"1732785", "1733163",
	--[[Vulpera]] 	"3106252", "3106717",
	--[[Zandalari]]	"1903049", "1903522",
	}
	for _, soundID in pairs(trainSounds) do
		MuteSoundFile(soundID)
	end
end

-- Archaeology counts
do
	local function CalculateArches(self)
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
		GameTooltip:ClearLines()
		GameTooltip:AddLine("|cff00FF00"..L["Arch Count"])
		GameTooltip:AddLine(" ")
		local total = 0
		for i = 1, GetNumArchaeologyRaces() do
			local numArtifacts = GetNumArtifactsByRace(i)
			local count = 0
			for j = 1, numArtifacts do
				local completionCount = select(10, GetArtifactInfoByRace(i, j))
				count = count + completionCount
			end
			local name = GetArchaeologyRaceInfo(i)
			if numArtifacts > 1 then
				GameTooltip:AddDoubleLine(name.."：", DB.InfoColor..count)
				total = total + count
			end
		end
		GameTooltip:AddLine(" ")
		GameTooltip:AddDoubleLine("|cff00FF00"..FROM_TOTAL, "|cffFF0000"..total)
		GameTooltip:Show()
	end

	local function AddCalculateIcon()
		local bu = CreateFrame("Button", nil, ArchaeologyFrameCompletedPage)
		bu:SetPoint("TOPRIGHT", -47, -47)
		bu:SetSize(35, 35)
		B.PixelIcon(bu, "Interface\\ICONS\\Ability_Iyyokuk_Calculate", true)
		bu:SetScript("OnEnter", CalculateArches)
		bu:SetScript("OnLeave", B.HideTooltip)
	end

	local function updateArcBar()
		AddCalculateIcon()

		ArcheologyDigsiteProgressBar.ignoreFramePositionManager = true
		ArcheologyDigsiteProgressBar:SetAttribute("ignoreFramePositionManager", true)
		B.CreateMF(ArcheologyDigsiteProgressBar)
		B.UpdatePoint(ArcheologyDigsiteProgressBar, "BOTTOM", UIParent, "BOTTOM", 0, 175)
	end
	B.LoadWithAddOn("Blizzard_ArchaeologyUI", updateArcBar)

	local newTitleString = ARCHAEOLOGY_DIGSITE_PROGRESS_BAR_TITLE.."：%s / %s"
	local function updateArcTitle(_, ...)
		local numFindsCompleted, totalFinds = ...
		if ArcheologyDigsiteProgressBar then
			ArcheologyDigsiteProgressBar.BarTitle:SetFormattedText(newTitleString, numFindsCompleted, totalFinds)
		end
	end
	B:RegisterEvent("ARCHAEOLOGY_SURVEY_CAST", updateArcTitle)
	B:RegisterEvent("ARCHAEOLOGY_FIND_COMPLETE", updateArcTitle)
end

-- Drag AltPowerbar
do
	local mover = CreateFrame("Frame", "NDuiAltBarMover", PlayerPowerBarAlt)
	mover:SetPoint("CENTER", UIParent, "BOTTOM", -270, 170)
	mover:SetSize(20, 20)
	B.CreateMF(PlayerPowerBarAlt, mover)

	hooksecurefunc(PlayerPowerBarAlt, "SetPoint", function(_, _, parent)
		if parent ~= mover then
			B.UpdatePoint(PlayerPowerBarAlt, "CENTER", mover, "CENTER")
		end
	end)

	hooksecurefunc("UnitPowerBarAlt_SetUp", function(self)
		local statusFrame = self.statusFrame
		if statusFrame.enabled then
			statusFrame:Show()
			statusFrame.Hide = statusFrame.Show
		end
	end)

	local altPowerInfo = {
		text = L["Drag AltBar Tip"],
		buttonStyle = HelpTip.ButtonStyle.GotIt,
		targetPoint = HelpTip.Point.RightEdgeCenter,
		onAcknowledgeCallback = B.HelpInfoAcknowledge,
		callbackArg = "AltPower",
	}
	PlayerPowerBarAlt:HookScript("OnEnter", function(self)
		if not NDuiADB["Help"]["AltPower"] then
			HelpTip:Show(self, altPowerInfo)
		end
	end)
end

-- ALT+RightClick to buy a stack
do
	local cache = {}
	local itemLink, id

	StaticPopupDialogs["BUY_STACK"] = {
		text = L["Stack Buying Check"],
		button1 = YES,
		button2 = NO,
		OnAccept = function()
			if not itemLink then return end
			BuyMerchantItem(id, GetMerchantItemMaxStack(id))
			cache[itemLink] = true
			itemLink = nil
		end,
		hideOnEscape = 1,
		hasItemFrame = 1,
	}

	local _MerchantItemButton_OnModifiedClick = MerchantItemButton_OnModifiedClick
	function MerchantItemButton_OnModifiedClick(self, ...)
		if IsAltKeyDown() then
			id = self:GetID()
			itemLink = GetMerchantItemLink(id)
			if not itemLink then return end
			local name, _, quality, _, _, _, _, maxStack, _, texture = GetItemInfo(itemLink)
			if maxStack and maxStack > 1 then
				if not cache[itemLink] then
					local r, g, b = B.GetQualityColor(quality)
					StaticPopup_Show("BUY_STACK", " ", " ", {["texture"] = texture, ["name"] = name, ["color"] = {r, g, b, 1}, ["link"] = itemLink, ["index"] = id, ["count"] = maxStack})
				else
					BuyMerchantItem(id, GetMerchantItemMaxStack(id))
				end
			end
		end

		_MerchantItemButton_OnModifiedClick(self, ...)
	end
end

-- Fix Drag Collections taint
do
	local done
	local function setupMisc(event, addon)
		if event == "ADDON_LOADED" and addon == "Blizzard_Collections" then
			CollectionsJournal:HookScript("OnShow", function()
				if not done then
					if InCombatLockdown() then
						B:RegisterEvent("PLAYER_REGEN_ENABLED", setupMisc)
					else
						B.CreateMF(CollectionsJournal)
					end
					done = true
				end
			end)
			B:UnregisterEvent(event, setupMisc)
		elseif event == "PLAYER_REGEN_ENABLED" then
			B.CreateMF(CollectionsJournal)
			B:UnregisterEvent(event, setupMisc)
		end
	end

	B:RegisterEvent("ADDON_LOADED", setupMisc)
end

-- Select target when click on raid units
do
	local function fixRaidGroupButton()
		for i = 1, 40 do
			local bu = _G["RaidGroupButton"..i]
			if bu and bu.unit and not bu.clickFixed then
				bu:SetAttribute("type", "target")
				bu:SetAttribute("unit", bu.unit)

				bu.clickFixed = true
			end
		end
	end

	local function setupMisc(event, addon)
		if event == "ADDON_LOADED" and addon == "Blizzard_RaidUI" then
			if not InCombatLockdown() then
				fixRaidGroupButton()
			else
				B:RegisterEvent("PLAYER_REGEN_ENABLED", setupMisc)
			end
			B:UnregisterEvent(event, setupMisc)
		elseif event == "PLAYER_REGEN_ENABLED" then
			if RaidGroupButton1 and RaidGroupButton1:GetAttribute("type") ~= "target" then
				fixRaidGroupButton()
				B:UnregisterEvent(event, setupMisc)
			end
		end
	end

	B:RegisterEvent("ADDON_LOADED", setupMisc)
end

-- Fix blizz guild news hyperlink error
do
	local function fixGuildNews(event, addon)
		if addon ~= "Blizzard_GuildUI" then return end

		local _GuildNewsButton_OnEnter = GuildNewsButton_OnEnter
		function GuildNewsButton_OnEnter(self)
			if not (self.newsInfo and self.newsInfo.whatText) then return end
			_GuildNewsButton_OnEnter(self)
		end

		B:UnregisterEvent(event, fixGuildNews)
	end

	local function fixCommunitiesNews(event, addon)
		if addon ~= "Blizzard_Communities" then return end

		local _CommunitiesGuildNewsButton_OnEnter = CommunitiesGuildNewsButton_OnEnter
		function CommunitiesGuildNewsButton_OnEnter(self)
			if not (self.newsInfo and self.newsInfo.whatText) then return end
			_CommunitiesGuildNewsButton_OnEnter(self)
		end

		B:UnregisterEvent(event, fixCommunitiesNews)
	end

	B:RegisterEvent("ADDON_LOADED", fixGuildNews)
	B:RegisterEvent("ADDON_LOADED", fixCommunitiesNews)
end