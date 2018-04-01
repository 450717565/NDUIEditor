-- $Id: GatherMate2.lua 70 2018-03-29 07:50:58Z arith $
-----------------------------------------------------------------------
-- Upvalued Lua API.
-----------------------------------------------------------------------
-- Functions
local _G = getfenv(0)
local select = _G.select
-- Libraries
local GetAddOnInfo, GetAddOnEnableState, UnitName, ToggleFrame, InterfaceOptionsFrame_OpenToCategory = _G.GetAddOnInfo, _G.GetAddOnEnableState, _G.UnitName, _G.ToggleFrame, _G.InterfaceOptionsFrame_OpenToCategory
-- ----------------------------------------------------------------------------
-- AddOn namespace.
-- ----------------------------------------------------------------------------
local FOLDER_NAME, private = ...

local MODNAME = "GatherMate2"

local LibStub = _G.LibStub
local addon = LibStub("AceAddon-3.0"):GetAddon(private.addon_name)
local L = LibStub("AceLocale-3.0"):GetLocale(private.addon_name)
local GatherMate2 = addon:NewModule(MODNAME)

local GM, profile, LGM
local prof_options = {}
local prof_options2 = {}
local prof_options3 = {}
local prof_options4 = {}
local filters = {}
local Config

local iGatherMate2 = select(4, GetAddOnInfo(MODNAME))
local enabled = GetAddOnEnableState(UnitName("player"), MODNAME)

function GatherMate2:OnEnable()
	if (enabled > 0 and iGatherMate2) then 
		GM = LibStub("AceAddon-3.0"):GetAddon(MODNAME) 
		profile = GM.db.profile
		LGM = LibStub("AceLocale-3.0"):GetLocale("GatherMate2", false)
		Config = GM:GetModule("Config")

		prof_options = {
			always          = LGM["Always show"],
			with_profession = LGM["Only with profession"],
			active          = LGM["Only while tracking"],
			never           = LGM["Never show"],
		}
		prof_options2 = { -- For Gas, which doesn't have tracking as a skill
			always           = LGM["Always show"],
			with_profession  = LGM["Only with profession"],
			never            = LGM["Never show"],
		}
		prof_options3 = {
			always          = LGM["Always show"],
			active          = LGM["Only while tracking"],
			never           = LGM["Never show"],
		}
		prof_options4 = { -- For Archaeology, which doesn't have tracking as a skill
			always           = LGM["Always show"],
			active		 = LGM["Only with digsite"],
			with_profession  = LGM["Only with profession"],
			never            = LGM["Never show"],
		}
		filters = {
			showMinerals = {
				name = LGM["Show Mining Nodes"], 
				desc = LGM["Toggle showing mining nodes."], 
				opts = prof_options, 
				arg = "Mining"
			},
			showHerbs = {
				name = LGM["Show Herbalism Nodes"], 
				desc = LGM["Toggle showing herbalism nodes."], 
				opts = prof_options, 
				arg = "Herb Gathering"
			},
			showFishes = {
				name = LGM["Show Fishing Nodes"], 
				desc = LGM["Toggle showing fishing nodes."], 
				opts = prof_options, 
				arg = "Fishing"
			},
			showGases = {
				name = LGM["Show Gas Clouds"], 
				desc = LGM["Toggle showing gas clouds."], 
				opts = prof_options2, 
				arg = "Extract Gas"
			},
			showTreasure = {
				name = LGM["Show Treasure Nodes"], 
				desc = LGM["Toggle showing treasure nodes."], 
				opts = prof_options3, 
				arg = "Treasure"
			},
			showArchaeology = {
				name = LGM["Show Archaeology Nodes"], 
				desc = LGM["Toggle showing archaeology nodes."], 
				opts = prof_options4, 
				arg = "Archaeology"
			},
			showTimber = {
				name = LGM["Show Timber Nodes"], 
				desc = LGM["Toggle showing timber nodes."], 
				opts = prof_options3, 
				arg = "Logging"
			},
		}

	end
end
	
local function toggleGatherMate2()
	profile.showWorldMap = not profile.showWorldMap
	GM:OnProfileChanged()
end

local function checkWorldMapStatus()
	return profile.showWorldMap or nil
end

function GatherMate2:DropDownMenus()
	if (enabled > 0 and iGatherMate2) then
		local menu = {}
		local menu2 = {}
		local i = 1
		local mode_name = select(2, GetAddOnInfo("GatherMate2")) or MODNAME
		
		menu[i] = {}
		menu[i].isNotRadio = true
		--menu[i].keepShownOnClick = true
		menu[i].hasArrow = true
		menu[i].value = MODNAME
		menu[i].colorCode = "|cFFFFC90E"
		menu[i].text = mode_name
		menu[i].tooltipTitle = LGM["Show World Map Icons"]
		menu[i].tooltipText = LGM["Toggle showing World Map icons."]
		menu[i].tooltipOnButton = true
		menu[i].func = toggleGatherMate2
		menu[i].checked = checkWorldMapStatus
		i = i + 1

		for k, v in pairs(filters) do
			menu[i] = {}
			menu[i].isNotRadio = true
			menu[i].notCheckable = true
			menu[i].hasArrow = true
			menu[i].keepShownOnClick = true
			menu[i].colorCode = "|cFFFFC90E"
			menu[i].value = MODNAME.."."..k
			menu[i].text = v.name
			menu[i].tooltipTitle = v.name
			menu[i].tooltipText = v.desc
			menu[i].tooltipOnButton = true
			if (not checkWorldMapStatus()) then
				menu[i].disabled = true
			else
				menu[i].disabled = nil
			end
			i = i + 1

			menu2[k] = {}
			for ka, va in pairs(v.opts) do
				menu2[k][ka] = {}
				menu2[k][ka].isNotRadio = true
				--menu2[k][ka].keepShownOnClick = true
				menu2[k][ka].text = va
				menu2[k][ka].disabled = (not checkWorldMapStatus()) and true or nil
				menu2[k][ka].checked = (function(self)
					return profile.show[v.arg] == ka and true or false
				end)
				menu2[k][ka].func = (function(self)
					profile.show[v.arg] = ka
					Config:UpdateConfig()
				end)
			end
		end

		menu[i] = {}
		menu[i].isNotRadio = true
		menu[i].notCheckable = true
		menu[i].text = L["GatherMate2 Config"]
		menu[i].colorCode = "|cFFB5E61D"
		menu[i].tooltipTitle = mode_name
		menu[i].tooltipText = L["Click to open GatherMate2's config panel"]
		menu[i].tooltipOnButton = true
		menu[i].func = (function(self)
			ToggleFrame(WorldMapFrame)
			InterfaceOptionsFrame_OpenToCategory("GatherMate 2")
			InterfaceOptionsFrame_OpenToCategory("GatherMate 2")
		end)
		
		return menu, menu2
	else
		return nil
	end
end
