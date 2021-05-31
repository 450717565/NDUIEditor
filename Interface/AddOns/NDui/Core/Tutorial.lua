local _, ns = ...
local B, C, L, DB = unpack(ns)
local Settings = B:RegisterModule("Settings")

local pairs, wipe = pairs, table.wipe
local cr, cg, cb = DB.cr, DB.cg, DB.cb

-- Addon Info
print("|cff0080ff< NDui >|cff70C0F5——————————————")
print("|cff00ff00  "..DB.Support.."|c00ffff00 "..DB.Version.." |c0000ff00"..L["Version Info1"])
print("|c0000ff00  "..L["Version Info2"].."|c00ffff00 /ndui |c0000ff00"..L["Version Info3"])
print("|cff70C0F5——————————————————")

-- Tuitorial
local function ForceDefaultSettings()
	SetActionBarToggles(1, 1, 1, 1)
	SetCVar("ActionButtonUseKeyDown", 1)
	SetCVar("alwaysCompareItems", 1)
	SetCVar("autoDismountFlying", 1)
	SetCVar("autoLootDefault", 1)
	SetCVar("autoQuestWatch", 1)
	SetCVar("autoSelfCast", 1)
	SetCVar("breakUpLargeNumbers", 1)
	SetCVar("cameraDistanceMaxZoomFactor", 2.6)
	SetCVar("cameraSmoothStyle", 0)
	SetCVar("deselectOnClick", 1)
	SetCVar("doNotFlashLowHealthWarning", 1)
	SetCVar("enableFloatingCombatText", 1)
	SetCVar("ffxGlow", 0)
	SetCVar("findYourselfAnywhereOnlyInCombat", 1)
	SetCVar("findYourselfMode", 1)
	SetCVar("floatingCombatTextCombatDamage", 1)
	SetCVar("floatingCombatTextCombatDamageDirectionalOffset", 10)
	SetCVar("floatingCombatTextCombatDamageDirectionalScale", 1)
	SetCVar("floatingCombatTextCombatHealing", 0)
	SetCVar("floatingCombatTextCombatState", 1)
	SetCVar("floatingCombatTextFloatMode", 2)
	SetCVar("floatingCombatTextLowManaHealth", 1)
	SetCVar("floatingCombatTextRepChanges", 1)
	SetCVar("hideAdventureJournalAlerts", 1)
	SetCVar("interactOnLeftClick", 0)
	SetCVar("lockActionBars", 1)
	SetCVar("lootUnderMouse", 1)
	SetCVar("missingTransmogSourceInItemTooltips", 1)
	SetCVar("movieSubtitle", 1)
	SetCVar("Outline", 3)
	SetCVar("overrideArchive", 0)
	SetCVar("screenshotFormat", jpg)
	SetCVar("screenshotQuality", 10)
	SetCVar("scriptErrors", 0)
	SetCVar("ShowClassColorInFriendlyNameplate", 1)
	SetCVar("showTutorials", 0)

	if not InCombatLockdown() then
		SetCVar("alwaysShowActionBars", 1)
		SetCVar("nameplateMotion", 1)
		SetCVar("nameplateMotionSpeed", 0.1)
		SetCVar("nameplateShowAll", 1)
		SetCVar("nameplateShowEnemies", 1)
		SetCVar("nameplateShowEnemyMiniones", 1)
		SetCVar("nameplateOccludedAlphaMult", 0.5)
	end
end

local function ForceRaidFrame()
	if InCombatLockdown() then return end
	if not CompactUnitFrameProfiles then return end
	SetCVar("useCompactPartyFrames", 1)
	SetRaidProfileOption(CompactUnitFrameProfiles.selectedProfile, "useClassColors", true)
	SetRaidProfileOption(CompactUnitFrameProfiles.selectedProfile, "displayPowerBar", true)
	SetRaidProfileOption(CompactUnitFrameProfiles.selectedProfile, "displayBorder", false)
	CompactUnitFrameProfiles_ApplyCurrentSettings()
	CompactUnitFrameProfiles_UpdateCurrentPanel()
end

-- DBM bars
local function ForceDBMOptions()
	if not IsAddOnLoaded("DBM-Core") then return end

	if DBM_MinimapIcon then wipe(DBM_MinimapIcon) end
	DBM_MinimapIcon = {["hide"] = true}

	if DBT_AllPersistentOptions then wipe(DBT_AllPersistentOptions) end
	DBT_AllPersistentOptions = {
		["Default"] = {
			["DBM"] = {
				["Alpha"] = 0.8,
				["BarStyle"] = "DBM",
				["BarXOffset"] = 0,
				["BarYOffset"] = 5,
				["EndColorB"] = 0,
				["EndColorG"] = 0,
				["EndColorR"] = 1,
				["ExpandUpwards"] = true,
				["ExpandUpwardsLarge"] = true,
				["FontSize"] = 10,
				["Heigh"] = 20,
				["HugeBarsEnabled"] = false,
				["HugeBarXOffset"] = 0,
				["HugeBarYOffset"] = 5,
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
				["TimerY"] = -75,
				["Width"] = 175,
			},
		},
	}

	if DBM_AllSavedOptions then wipe(DBM_AllSavedOptions) end
	DBM_AllSavedOptions = {
		["Default"] = {
			["EventSoundVictory"] = "None",
			["EventSoundVictory2"] = "None",
			["HideObjectivesFrame"] = false,
			["SpecialWarningFontSize2"] = 24,
			["SpecialWarningFontStyle"] = DB.Font[3],
			["SpecialWarningPoint"] = "TOP",
			["SpecialWarningSound3"] = "Sound\\interface\\UI_RaidBossWhisperWarning.ogg",
			["SpecialWarningX"] = 0,
			["SpecialWarningY"] = -200,
			["UseSoundChannel"] = "Dialog",
			["WarningFontSize"] = 18,
			["WarningFontStyle"] = DB.Font[3],
			["WarningPoint"] = "TOP",
			["WarningX"] = 0,
			["WarningY"] = -180,
		},
	}

	if IsAddOnLoaded("DBM-VPVV") then
		DBM_AllSavedOptions["Default"]["ChosenVoicePack"] = "VV"
		DBM_AllSavedOptions["Default"]["CountdownVoice"] = "VP:VV"
		DBM_AllSavedOptions["Default"]["CountdownVoice2"] = "VP:VV"
		DBM_AllSavedOptions["Default"]["CountdownVoice3"] = "VP:VV"
		DBM_AllSavedOptions["Default"]["CountdownVoice3v2"] = "VP:VV"
	elseif IsAddOnLoaded("DBM-VPYike") then
		DBM_AllSavedOptions["Default"]["ChosenVoicePack"] = "Yike"
		DBM_AllSavedOptions["Default"]["CountdownVoice"] = "VP:Yike"
		DBM_AllSavedOptions["Default"]["CountdownVoice2"] = "VP:Yike"
		DBM_AllSavedOptions["Default"]["CountdownVoice3"] = "VP:Yike"
		DBM_AllSavedOptions["Default"]["CountdownVoice3v2"] = "VP:Yike"
	end

	NDuiADB["DBMRequest"] = false
end

-- Skada
local function ForceSkadaOptions()
	if not IsAddOnLoaded("Skada") then return end
	if SkadaDB then wipe(SkadaDB) end
	SkadaDB = {
		["hasUpgraded"] = true,
		["profiles"] = {
			["Default"] = {
				["windows"] = {
					{	["barheight"] = 18,
						["classicons"] = false,
						["barslocked"] = true,
						["y"] = 28,
						["x"] = -3,
						["title"] = {
							["color"] = {
								["a"] = 0.3,
								["b"] = 0,
								["g"] = 0,
								["r"] = 0,
							},
							["font"] = "",
							["borderthickness"] = 0,
							["fontflags"] = DB.Font[3],
							["fontsize"] = 14,
							["texture"] = "normTex",
						},
						["barfontflags"] = DB.Font[3],
						["point"] = "BOTTOMRIGHT",
						["mode"] = "",
						["barwidth"] = 300,
						["barbgcolor"] = {
							["a"] = 0,
							["b"] = 0,
							["g"] = 0,
							["r"] = 0,
						},
						["barfontsize"] = 14,
						["background"] = {
							["height"] = 180,
							["texture"] = "None",
							["bordercolor"] = {
								["a"] = 0,
							},
						},
						["bartexture"] = "normTex",
					}, -- [1]
				},
				["tooltiprows"] = 10,
				["setstokeep"] = 30,
				["tooltippos"] = "topleft",
				["reset"] = {
					["instance"] = 3,
					["join"] = 1,
				},
			},
		},
	}
	NDuiADB["SkadaRequest"] = false
end

-- BigWigs
local function ForceBWOptions()
	if not IsAddOnLoaded("BigWigs") then return end
	if BigWigs3DB then wipe(BigWigs3DB) end
	BigWigs3DB = {
		["namespaces"] = {
			["BigWigs_Plugins_AltPower"] = {
				["profiles"] = {
					["Default"] = {
						["fontSize"] = 14,
						["font"] = DB.Font[1],
						["fontOutline"] = DB.Font[3],
						["position"] = {
							"LEFT", -- [1]
							"LEFT", -- [2]
							50, -- [3]
							-180, -- [4]
						},
					},
				},
			},
			["BigWigs_Plugins_AutoReply"] = {
				["profiles"] = {
					["Default"] = {
						["exitCombatOther"] = 4,
						["disabled"] = false,
						["exitCombat"] = 4,
						["mode"] = 4,
						["modeOther"] = 4,
					},
				},
			},
			["BigWigs_Plugins_Bars"] = {
				["profiles"] = {
					["Default"] = {
						["outline"] = DB.Font[3],
						["fontSize"] = 12,
						["BigWigsAnchor_y"] = 760,
						["BigWigsAnchor_x"] = 450,
						["BigWigsAnchor_width"] = 180,
						["interceptMouse"] = false,
						["barStyle"] = "NDui",
						["LeftButton"] = {
							["emphasize"] = false,
						},
						["font"] = DB.Font[1],
						["onlyInterceptOnKeypress"] = true,
						["emphasizeMultiplier"] = 1,
						["BigWigsEmphasizeAnchor_x"] = 860,
						["BigWigsEmphasizeAnchor_y"] = 340,
						["BigWigsEmphasizeAnchor_width"] = 220,
						["emphasizeGrowup"] = true,
					},
				},
			},
			["BigWigs_Plugins_Countdown"] = {
				["profiles"] = {
					["Default"] = {
						["textEnabled"] = false,
					},
				},
			},
			["BigWigs_Plugins_InfoBox"] = {
				["profiles"] = {
					["Default"] = {
						["posx"] = 75,
						["posy"] = 390,
					},
				},
			},
			["BigWigs_Plugins_Messages"] = {
				["profiles"] = {
					["Default"] = {
						["fontSize"] = 18,
						["font"] = DB.Font[1],
						["normalPosition"] = {
							nil, -- [1]
							nil, -- [2]
							nil, -- [3]
							-180, -- [4]
						},
						["emphPosition"] = {
							"TOP", -- [1]
							"TOP", -- [2]
							nil, -- [3]
							-200, -- [4]
						},
					},
				},
			},
			["BigWigs_Plugins_Proximity"] = {
				["profiles"] = {
					["Default"] = {
						["fontSize"] = 18,
						["font"] = DB.Font[1],
						["posx"] = 200,
						["posy"] = 300,
						["width"] = 140,
						["height"] = 120,
					},
				},
			},
			["BigWigs_Plugins_Super Emphasize"] = {
				["profiles"] = {
					["Default"] = {
						["fontSize"] = 28,
						["font"] = DB.Font[1],
					},
				},
			},
			["BigWigs_Plugins_Victory"] = {
				["profiles"] = {
					["Default"] = {
						["soundName"] = "None",
					},
				},
			},
		},
		["profiles"] = {
			["Default"] = {
				["fakeDBMVersion"] = true,
			},
		},
	}
	NDuiADB["BWRequest"] = false
end

local function ForceAddonSkins()
	if NDuiADB["DBMRequest"] then ForceDBMOptions() end
	if NDuiADB["SkadaRequest"] then ForceSkadaOptions() end
	if NDuiADB["BWRequest"] then ForceBWOptions() end
end

-- Tutorial
local tutor
local function YesTutor()
	if tutor then tutor:Show() return end
	tutor = CreateFrame("Frame", nil, UIParent)
	tutor:SetPoint("CENTER")
	tutor:SetSize(480, 300)
	tutor:SetFrameStrata("HIGH")
	B.CreateBG(tutor)
	B.CreateMF(tutor)
	B.CreateWaterMark(tutor)

	local ll = B.CreateGA(tutor, "H", cr, cg, cb, 0, C.alpha, 80, C.mult*2)
	ll:SetPoint("TOPRIGHT", tutor, "TOP", 0, -35)
	local lr = B.CreateGA(tutor, "H", cr, cg, cb, C.alpha, 0, 80, C.mult*2)
	lr:SetPoint("TOPLEFT", tutor, "TOP", 0, -35)

	local title = B.CreateFS(tutor, 16, "", true, "TOP", 0, -10)
	local body = B.CreateFS(tutor, 14, "", false, "TOPLEFT", 20, -50)
	body:SetPoint("BOTTOMRIGHT", -20, 50)
	body:SetJustifyV("TOP")
	body:SetJustifyH("LEFT")
	body:SetWordWrap(true)
	local foot = B.CreateFS(tutor, 14, "", false, "BOTTOM", 0, 10)

	local pass = B.CreateButton(tutor, 50, 20, L["Skip"])
	pass:SetPoint("BOTTOMLEFT", 10, 10)
	pass:Hide()
	local apply = B.CreateButton(tutor, 50, 20, APPLY)
	apply:SetPoint("BOTTOMRIGHT", -10, 10)

	local titles = {L["Default Settings"], L["Skins"], L["Tips"]}
	local function RefreshText(page)
		title:SetText(titles[page])
		body:SetText(L["Tutorial Page"..page])
		foot:SetText(page.."/3")
	end
	RefreshText(1)

	local currentPage = 1
	local function TurnNextPage()
		currentPage = currentPage + 1
		RefreshText(currentPage)
		PlaySound(SOUNDKIT.IG_QUEST_LOG_OPEN)
	end

	pass:SetScript("OnClick", function()
		pass:Hide()
		TurnNextPage()
	end)
	apply:SetScript("OnClick", function()
		if currentPage == 1 then
			ForceDefaultSettings()
			ForceRaidFrame()
			UIErrorsFrame:AddMessage(DB.InfoColor..L["Default Settings Check"])
			pass:Show()
		elseif currentPage == 2 then
			NDuiADB["DBMRequest"] = true
			NDuiADB["SkadaRequest"] = true
			NDuiADB["BWRequest"] = true
			ForceAddonSkins()
			NDuiADB["ResetDetails"] = true
			UIErrorsFrame:AddMessage(DB.InfoColor..L["Tutorial Complete"])
			pass:Hide()
		elseif currentPage == 3 then
			C.db["Tutorial"]["Complete"] = true
			tutor:Hide()
			StaticPopup_Show("RELOAD_NDUI")
		end
		TurnNextPage()
	end)
end

local welcome
local function HelloWorld()
	if welcome then welcome:Show() return end

	welcome = CreateFrame("Frame", "NDui_Tutorial", UIParent)
	welcome:SetPoint("CENTER")
	welcome:SetSize(420, 480)
	welcome:SetFrameStrata("HIGH")
	B.CreateBG(welcome)
	B.CreateMF(welcome)
	B.CreateWaterMark(welcome)
	B.CreateFS(welcome, 18, L["Help Title"], true, "TOP", 0, -10)

	local ll = B.CreateGA(welcome, "H", cr, cg, cb, 0, C.alpha, 100, C.mult*2)
	ll:SetPoint("TOPRIGHT", welcome, "TOP", 0, -35)
	local lr = B.CreateGA(welcome, "H", cr, cg, cb, C.alpha, 0, 100, C.mult*2)
	lr:SetPoint("TOPLEFT", welcome, "TOP", 0, -35)

	local intro = B.CreateFS(welcome, 14, "", false, "TOPLEFT", 20, -70)
	intro:SetPoint("BOTTOMRIGHT", -20, 50)
	intro:SetWordWrap(true)
	intro:SetJustifyV("TOP")
	intro:SetJustifyH("LEFT")

	local c1, c2 = "|cffFFFF00", "|cff00FF00"
	local lines = {
		c1.." /ww "..c2..L["Cmd ww intro"].."|r",
		" /bb "..c2..L["Cmd bb intro"].."|r",
		" /mm /mmm "..c2..L["Cmd mm intro"].."|r",
		" /rl "..c2..L["Cmd rl intro"].."|r",
		" /ncl "..c2..L["Cmd ncl intro"].."|r",
	}
	local text = L["Help Intro"].."|n|n"
	for _, line in pairs(lines) do
		text = text.."|n|n"..line
	end
	intro:SetText(text)

	if C.db["Tutorial"]["Complete"] then
		local close = B.CreateButton(welcome, 16, 16, true, DB.closeTex)
		close:SetPoint("TOPRIGHT", -10, -10)
		close:SetScript("OnClick", function()
			welcome:Hide()
		end)
	end

	local goTutor = B.CreateButton(welcome, 100, 20, L["Tutorial"])
	goTutor:SetPoint("BOTTOM", 0, 10)
	goTutor:SetScript("OnClick", function()
		welcome:Hide()
		YesTutor()
	end)
end
SlashCmdList["NDUI"] = HelloWorld
SLASH_NDUI1 = "/ndui"

function Settings:OnLogin()
	-- Hide options
	B.HideOption(Display_UseUIScale)
	B.HideOption(Display_UIScaleSlider)

	-- Tutorial and settings
	ForceAddonSkins()
	if not C.db["Tutorial"]["Complete"] then HelloWorld() end
end