local _, ns = ...
local B, C, L, DB = unpack(ns)
local module = B:RegisterModule("Settings")
local cr, cg, cb = DB.CC.r, DB.CC.g, DB.CC.b

-- Addon Info
print("|cff0080ff< NDui >|cff70C0F5----------------")
print("|cff00ff00  "..DB.Support.."|c00ffff00 "..DB.Version.." |c0000ff00"..L["Version Info1"])
print("|c0000ff00  "..L["Version Info2"].."|c00ffff00 /ndui |c0000ff00"..L["Version Info3"])
print("|cff70C0F5------------------------")

-- Tuitorial
local function ForceDefaultSettings()
	SetActionBarToggles(1, 1, 1, 1)
	SetCVar("ActionButtonUseKeyDown", 1)
	SetCVar("alwaysCompareItems", 1)
	SetCVar("alwaysShowActionBars", 1)
	SetCVar("autoLootDefault", 1)
	SetCVar("autoQuestWatch", 1)
	SetCVar("autoSelfCast", 1)
	SetCVar("breakUpLargeNumbers", 1)
	SetCVar("doNotFlashLowHealthWarning", 1)
	SetCVar("enableFloatingCombatText", 1)
	SetCVar("ffxGlow", 0)
	SetCVar("floatingCombatTextCombatDamage", 1)
	SetCVar("floatingCombatTextCombatDamageDirectionalScale", 0)
	SetCVar("floatingCombatTextCombatHealing", 0)
	SetCVar("floatingCombatTextCombatState", 1)
	SetCVar("floatingCombatTextFloatMode", 2)
	SetCVar("floatingCombatTextLowManaHealth", 1)
	SetCVar("floatingCombatTextRepChanges", 1)
	SetCVar("lockActionBars", 1)
	SetCVar("lootUnderMouse", 1)
	SetCVar("missingTransmogSourceInItemTooltips", 1)
	SetCVar("nameplateMotion", 1)
	SetCVar("nameplateShowAll", 1)
	SetCVar("nameplateShowEnemies", 1)
	SetCVar("nameplateShowFriendlyNPCs", 0)
	SetCVar("nameplateShowSelf", 0)
	SetCVar("overrideArchive", 0)
	SetCVar("screenshotFormat", jpg)
	SetCVar("screenshotQuality", 10)
	SetCVar("ShowClassColorInFriendlyNameplate", 1)
	SetCVar("showTutorials", 0)
	SetCVar("useCompactPartyFrames", 1)
	SetCVar("WorldTextScale", 1.5)
end

local function ForceRaidFrame()
	if not CompactUnitFrameProfiles.selectedProfile then return end
	SetRaidProfileOption(CompactUnitFrameProfiles.selectedProfile, "useClassColors", true)
	SetRaidProfileOption(CompactUnitFrameProfiles.selectedProfile, "displayPowerBar", true)
	SetRaidProfileOption(CompactUnitFrameProfiles.selectedProfile, "displayBorder", false)
	CompactUnitFrameProfiles_ApplyCurrentSettings()
	CompactUnitFrameProfiles_UpdateCurrentPanel()
end

local function ForceUIScale()
	B.HideOption(Advanced_UseUIScale)
	B.HideOption(Advanced_UIScaleSlider)

	local scale = NDuiDB["Settings"]["UIScale"]
	if NDuiDB["Settings"]["LockUIScale"] then
		scale = 768/DB.ScreenHeight * .8
		local minScale = .64
		if DB.ScreenHeight > 1080 then minScale = .5 end
		if scale < minScale then scale = minScale end
		NDuiDB["Settings"]["UIScale"] = scale
	end

	SetCVar("useUiScale", 1)
	if scale < .64 then
		UIParent:SetScale(scale)
	else
		SetCVar("uiScale", scale)
	end

	-- Restore from Auto-scaling
	local function RestoreUIScale(scale)
		UIParent:SetScale(scale)
		if NDuiDB["Chat"]["Lock"] then
			ChatFrame1:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 0, 28)
		end
	end

	B:RegisterEvent("UI_SCALE_CHANGED", function()
		if scale < .64 then RestoreUIScale(scale) end

		C_Timer.After(1, function()
			if scale < .64 and UIParent:GetScale() ~= scale then
				RestoreUIScale(scale)
			end
		end)
	end)
end

local function ForceChatSettings()
	FCF_SetLocked(ChatFrame1, nil)
	ChatFrame1:ClearAllPoints()
	ChatFrame1:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 0, 28)
	ChatFrame1:SetWidth(380)
	ChatFrame1:SetHeight(190)
	ChatFrame1:SetUserPlaced(true)
	for i = 1, NUM_CHAT_WINDOWS do
		local cf = _G["ChatFrame"..i]
		ChatFrame_RemoveMessageGroup(cf, "CHANNEL")
	end
	FCF_SavePositionAndDimensions(ChatFrame1)
	FCF_SetLocked(ChatFrame1, true)

	NDuiDB["Chat"]["Lock"] = true
end

StaticPopupDialogs["RELOAD_NDUI"] = {
	text = L["ReloadUI Required"],
	button1 = APPLY,
	button2 = CLASS_TRIAL_THANKS_DIALOG_CLOSE_BUTTON,
	OnAccept = function()
		ReloadUI()
	end,
}

-- DBM bars
local function ForceDBMOptions()
	if not IsAddOnLoaded("DBM-Core") then return end
	if DBT_AllPersistentOptions then table.wipe(DBT_AllPersistentOptions) end
	DBT_AllPersistentOptions = {
		["Default"] = {
			["DBM"] = {
				["BarXOffset"] = 0,
				["BarYOffset"] = 16,
				["EndColorB"] = 0,
				["EndColorG"] = 0,
				["EndColorR"] = 1,
				["ExpandUpwards"] = true,
				["ExpandUpwardsLarge"] = true,
				["FontSize"] = 10,
				["Heigh"] = 20,
				["HugeBarsEnabled"] = false,
				["HugeBarXOffset"] = 0,
				["HugeBarYOffset"] = 16,
				["HugeScale"] = 1,
				["HugeTimerPoint"] = "BOTTOM",
				["HugeTimerX"] = -50,
				["HugeTimerY"] = 120,
				["HugeWidth"] = 210,
				["Scale"] = 1,
				["StartColorB"] = 0,
				["StartColorG"] = 0.7,
				["StartColorR"] = 1,
				["Texture"] = DB.normTex,
				["TimerPoint"] = "CENTER",
				["TimerX"] = 310,
				["TimerY"] = -85,
				["Width"] = 175,
			},
		},
	}

	if not DBM_AllSavedOptions["Default"] then DBM_AllSavedOptions["Default"] = {} end
	DBM_AllSavedOptions = {
		["Default"] = {
			["EventSoundVictory"] = "None",
			["HideObjectivesFrame"] = false,
			["ShowMinimapButton"] = false,
			["SpecialWarningFontSize2"] = 24,
			["SpecialWarningFontStyle"] = "OUTLINE",
			["SpecialWarningPoint"] = "TOP",
			["SpecialWarningSound3"] = "Sound\\interface\\UI_RaidBossWhisperWarning.ogg",
			["SpecialWarningX"] = 0,
			["SpecialWarningY"] = -200,
			["UseSoundChannel"] = "Dialog",
			["WarningFontSize"] = 18,
			["WarningFontStyle"] = "OUTLINE",
			["WarningPoint"] = "TOP",
			["WarningX"] = 0,
			["WarningY"] = -180,
		},
	}
	NDuiDB["Settings"]["DBMRequest"] = false
end

-- Skada
local function ForceSkadaOptions()
	if not IsAddOnLoaded("Skada") then return end
	if SkadaDB then table.wipe(SkadaDB) end
	SkadaDB = {
		["hasUpgraded"] = true,
		["profiles"] = {
			["Default"] = {
				["icon"] = {
					["hide"] = true,
				},
				["modulesBlocked"] = {
					["Power"] = true,
					["Threat"] = true,
				},
				["reset"] = {
					["instance"] = 2,
					["join"] = 2,
				},
				["setstokeep"] = 30,
				["tooltippos"] = "topleft",
				["tooltiprows"] = 10,
				["windows"] = {
					{
						["background"] = {
							["bordercolor"] = {
								["a"] = 0,
							},
							["height"] = 160,
							["texture"] = "None",
						},
						["barbgcolor"] = {
							["a"] = 0,
							["b"] = 0,
							["g"] = 0,
							["r"] = 0,
						},
						["barfontflags"] = "OUTLINE",
						["barfontsize"] = 12,
						["barheight"] = 16,
						["barslocked"] = true,
						["bartexture"] = "Altz01",
						["barwidth"] = 350,
						["classicons"] = false,
						["point"] = "BOTTOMRIGHT",
						["smoothing"] = true,
						["spark"] = false,
						["title"] = {
							["borderthickness"] = 0,
							["color"] = {
								["a"] = 0.3,
								["b"] = 0,
								["g"] = 0,
								["r"] = 0,
							},
							["font"] = "",
							["fontflags"] = "OUTLINE",
							["fontsize"] = 14,
							["texture"] = "normTex",
						},
						["y"] = 30,
						["x"] = -4,
					},
				},
			},
		},
	}
	NDuiDB["Settings"]["SkadaRequest"] = false
end

-- BigWigs
local function ForceBigwigs()
	if not IsAddOnLoaded("BigWigs") then return end
	if BigWigs3DB then table.wipe(BigWigs3DB) end
	BigWigs3DB = {
		["namespaces"] = {
			["BigWigs_Plugins_Victory"] = {
				["profiles"] = {
					["Default"] = {
						["soundName"] = "None",
					},
				},
			},
			["BigWigs_Plugins_Alt Power"] = {
				["profiles"] = {
					["Default"] = {
						["font"] = "默认",
						["fontOutline"] = "OUTLINE",
						["fontSize"] = 14,
						["posx"] = 1000,
						["posy"] = 500,
					},
				},
			},
			["BigWigs_Plugins_Bars"] = {
				["profiles"] = {
					["Default"] = {
						["barStyle"] = "NDui",
						["BigWigsAnchor_width"] = 175,
						["BigWigsAnchor_x"] = 400,
						["BigWigsAnchor_y"] = 725,
						["BigWigsEmphasizeAnchor_width"] = 200,
						["BigWigsEmphasizeAnchor_x"] = 875,
						["BigWigsEmphasizeAnchor_y"] = 350,
						["emphasizeGrowup"] = true,
						["emphasizeScale"] = 1,
						["font"] = "默认",
						["fontSize"] = 12,
						["growup"] = false,
						["interceptMouse"] = false,
						["LeftButton"] = {
							["emphasize"] = false,
						},
						["onlyInterceptOnKeypress"] = true,
						["outline"] = "OUTLINE",
					},
				},
			},
			["BigWigs_Plugins_Super Emphasize"] = {
				["profiles"] = {
					["Default"] = {
						["font"] = "默认",
						["fontSize"] = 28,
					},
				},
			},
			["BigWigs_Plugins_Statistics"] = {
				["profiles"] = {
					["Default"] = {
						["showBar"] = true,
					},
				},
			},
			["BigWigs_Plugins_Proximity"] = {
				["profiles"] = {
					["Default"] = {
						["font"] = "默认",
						["fontSize"] = 18,
						["height"] = 120,
						["posx"] = 200,
						["posy"] = 400,
						["width"] = 140,
					},
				},
			},
			["BigWigs_Plugins_Messages"] = {
				["profiles"] = {
					["Default"] = {
						["BWEmphasizeCountdownMessageAnchor_x"] = 665,
						["BWEmphasizeCountdownMessageAnchor_y"] = 530,
						["BWEmphasizeMessageAnchor_x"] = 600,
						["BWEmphasizeMessageAnchor_y"] = 700,
						["BWMessageAnchor_x"] = 600,
						["BWMessageAnchor_y"] = 350,
						["font"] = "默认",
						["fontSize"] = 18,
						["growUpwards"] = true,
						["outline"] = "OUTLINE",
						["useicons"] = false,
					},
				},
			},
		},
		["discord"] = 1,
		["profiles"] = {
			["Default"] = {
				["fakeDBMVersion"] = true,
			},
		},
	}
	NDuiDB["Settings"]["BWRequest"] = false
end

local function ForceAddonSkins()
	if NDuiDB["Settings"]["DBMRequest"] then ForceDBMOptions() end
	if NDuiDB["Settings"]["SkadaRequest"] then ForceSkadaOptions() end
	if NDuiDB["Settings"]["BWRequest"] then ForceBigwigs() end
end

-- Tutorial
local tutor
local function YesTutor()
	if tutor then tutor:Show() return end
	tutor = CreateFrame("Frame", nil, UIParent)
	tutor:SetPoint("CENTER")
	tutor:SetSize(400, 250)
	tutor:SetFrameStrata("HIGH")
	tutor:SetScale(1.2)
	B.CreateMF(tutor)
	B.CreateBD(tutor)
	B.CreateTex(tutor)
	B.CreateFS(tutor, 30, "NDui", true, "TOPLEFT", 10, 25)
	local ll = CreateFrame("Frame", nil, tutor)
	ll:SetPoint("TOP", -40, -32)
	B.CreateGF(ll, 80, 3, "Horizontal", cr, cg, cb, 0, .7)
	ll:SetFrameStrata("HIGH")
	local lr = CreateFrame("Frame", nil, tutor)
	lr:SetPoint("TOP", 40, -32)
	B.CreateGF(lr, 80, 3, "Horizontal", cr, cg, cb, .7, 0)
	lr:SetFrameStrata("HIGH")

	local title = B.CreateFS(tutor, 12, "", true, "TOP", 0, -10)
	local body = B.CreateFS(tutor, 12, "", false, "TOPLEFT", 20, -50)
	body:SetPoint("BOTTOMRIGHT", -20, 50)
	body:SetJustifyV("TOP")
	body:SetJustifyH("LEFT")
	body:SetWordWrap(true)
	local foot = B.CreateFS(tutor, 12, "", false, "BOTTOM", 0, 10)

	local pass = B.CreateButton(tutor, 50, 20, L["Skip"])
	pass:SetPoint("BOTTOMLEFT", 10, 10)
	local apply = B.CreateButton(tutor, 50, 20, APPLY)
	apply:SetPoint("BOTTOMRIGHT", -10, 10)

	local titles = {L["Default Settings"], UI_SCALE, L["ChatFrame"], L["Skins"], L["Tips"]}
	local function RefreshText(page)
		title:SetText(titles[page])
		body:SetText(L["Tutorial Page"..page])
		foot:SetText(page.."/5")
	end
	RefreshText(1)

	local currentPage = 1
	pass:SetScript("OnClick", function()
		if currentPage > 3 then pass:Hide() end
		currentPage = currentPage + 1
		RefreshText(currentPage)
		PlaySound(SOUNDKIT.IG_QUEST_LOG_OPEN)
	end)
	apply:SetScript("OnClick", function()
		pass:Show()
		if currentPage == 1 then
			ForceDefaultSettings()
			ForceRaidFrame()
			UIErrorsFrame:AddMessage(DB.InfoColor..L["Default Settings Check"])
		elseif currentPage == 2 then
			NDuiDB["Settings"]["LockUIScale"] = true
			ForceUIScale()
			NDuiDB["Settings"]["LockUIScale"] = false
			UIErrorsFrame:AddMessage(DB.InfoColor..L["UIScale Check"])
		elseif currentPage == 3 then
			ForceChatSettings()
			UIErrorsFrame:AddMessage(DB.InfoColor..L["Chat Settings Check"])
		elseif currentPage == 4 then
			NDuiDB["Settings"]["DBMRequest"] = true
			NDuiDB["Settings"]["SkadaRequest"] = true
			NDuiDB["Settings"]["BWRequest"] = true
			ForceAddonSkins()
			UIErrorsFrame:AddMessage(DB.InfoColor..L["Tutorial Complete"])
			pass:Hide()
		elseif currentPage == 5 then
			tutor:Hide()
			StaticPopup_Show("RELOAD_NDUI")
			currentPage = 0
		end

		currentPage = currentPage + 1
		RefreshText(currentPage)
		PlaySound(SOUNDKIT.IG_QUEST_LOG_OPEN)
	end)
end

local welcome
local function HelloWorld()
	if welcome then welcome:Show() return end
	welcome = CreateFrame("Frame", "HelloWorld", UIParent)
	welcome:SetPoint("CENTER")
	welcome:SetSize(350, 400)
	welcome:SetScale(1.2)
	welcome:SetFrameStrata("HIGH")
	B.CreateMF(welcome)
	B.CreateBD(welcome)
	B.CreateTex(welcome)
	B.CreateFS(welcome, 30, "NDui", true, "TOPLEFT", 10, 25)
	B.CreateFS(welcome, 14, DB.Version, true, "TOPLEFT", 90, 12)
	B.CreateFS(welcome, 16, L["Help Title"], true, "TOP", 0, -10)
	local ll = CreateFrame("Frame", nil, welcome)
	ll:SetPoint("TOP", -50, -35)
	B.CreateGF(ll, 100, 3, "Horizontal", cr, cg, cb, 0, .7)
	ll:SetFrameStrata("HIGH")
	local lr = CreateFrame("Frame", nil, welcome)
	lr:SetPoint("TOP", 50, -35)
	B.CreateGF(lr, 100, 3, "Horizontal", cr, cg, cb, .7, 0)
	lr:SetFrameStrata("HIGH")
	B.CreateFS(welcome, 12, L["Help Info1"], false, "TOPLEFT", 20, -50)
	B.CreateFS(welcome, 12, L["Help Info2"], false, "TOPLEFT", 20, -70)

	local c1, c2 = "|c00FFFF00", "|c0000FF00"
	local lines = {
		c1.." /ww "..c2..L["Help Info12"],
		c1.." /hb "..c2..L["Help Info5"],
		c1.." /mm "..c2..L["Help Info6"],
		c1.." /rl "..c2..L["Help Info7"],
		c1.." /kro "..c2..L["Help Info13"],
		c1.." /ncl "..c2..L["Help Info9"],
	}
	for index, line in pairs(lines) do
		B.CreateFS(welcome, 12, line, false, "TOPLEFT", 20, -100-index*20)
	end

	B.CreateFS(welcome, 12, L["Help Info10"], false, "TOPLEFT", 20, -310)
	B.CreateFS(welcome, 12, L["Help Info11"], false, "TOPLEFT", 20, -330)

	local close = B.CreateButton(welcome, 20, 20, "X")
	close:SetPoint("TOPRIGHT", -10, -10)
	close:SetScript("OnClick", function() welcome:Hide() end)

	local goTutor = B.CreateButton(welcome, 100, 20, L["Tutorial"])
	goTutor:SetPoint("BOTTOM", 0, 10)
	goTutor:SetScript("OnClick", function() welcome:Hide() YesTutor() end)
end
SlashCmdList["NDUI"] = function() HelloWorld() end
SLASH_NDUI1 = "/ndui"

function module:OnLogin()
	if not NDuiDB["Tutorial"]["Complete"] then
		HelloWorld()
		NDuiDB["Tutorial"]["Complete"] = true
	end

	ForceUIScale()
	ForceAddonSkins()
	if NDuiDB["Chat"]["Lock"] then ForceChatSettings() end

	if tonumber(GetCVar("cameraDistanceMaxZoomFactor")) ~= 2.6 then
		SetCVar("cameraDistanceMaxZoomFactor", 2.6)
	end
end
