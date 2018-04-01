-- $Id: PetTracker.lua 67 2018-03-28 14:13:46Z arith $
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

local MODNAME = "PetTracker"

local LibStub = _G.LibStub
local addon = LibStub("AceAddon-3.0"):GetAddon(private.addon_name)
local L = LibStub("AceLocale-3.0"):GetLocale(private.addon_name)
local PT = addon:NewModule(MODNAME)

local iPetTracker = select(4, GetAddOnInfo(MODNAME))
local enabled = GetAddOnEnableState(UnitName("player"), MODNAME)

function PT:OnEnable()
	if (enabled > 0 and iPetTracker) then 
	else
		return false
	end
end

local function checkActiveSpecies()
	return not PetTracker.Sets["HideSpecies"]
end
	
local function toggleSpecies()
	PetTracker.Sets["HideSpecies"] = not PetTracker.Sets["HideSpecies"]
	PetTracker.WorldMap:UpdateBlips()
end

local function checkActiveStables()
	return not PetTracker.Sets["HideStables"]
end
	
local function toggleStables()
	PetTracker.Sets["HideStables"] = not PetTracker.Sets["HideStables"]
	PetTracker.WorldMap:UpdateBlips()
end

function PT:DropDownMenus()
	if (enabled > 0 and iPetTracker) then
		local menu = {}
		local i = 1
		local mode_name = select(2, GetAddOnInfo("PetTracker")) or MODNAME
		
		menu[i] = {}
		menu[i].notCheckable = true
		menu[i].isNotRadio = true
		menu[i].keepShownOnClick = true
		menu[i].hasArrow = true
		menu[i].value = MODNAME
		menu[i].colorCode = "|cFFFFC90E"
		menu[i].text = mode_name or MODNAME or PETS
		i = i + 1

		menu[i] = {}
		menu[i].isNotRadio = true
		menu[i].keepShownOnClick = true
		menu[i].text = PetTracker.Locals.Species or L["Species"]
		menu[i].func = toggleSpecies
		menu[i].checked = checkActiveSpecies
		i = i + 1

		menu[i] = {}
		menu[i].isNotRadio = true
		menu[i].keepShownOnClick = true
		menu[i].text = MINIMAP_TRACKING_STABLEMASTER
		menu[i].func = toggleStables
		menu[i].checked = checkActiveStables
		i = i + 1

		menu[i] = {}
		menu[i].isNotRadio = true
		menu[i].notCheckable = true
		menu[i].text = L["PetTracker Config"]
		menu[i].colorCode = "|cFFB5E61D"
		menu[i].tooltipTitle = mode_name
		menu[i].tooltipText = L["Click to open PetTracker's config panel"]
		menu[i].tooltipOnButton = true
		menu[i].func = (function(self)
			ToggleFrame(WorldMapFrame)
			InterfaceOptionsFrame_OpenToCategory("PetTracker")
			InterfaceOptionsFrame_OpenToCategory("PetTracker")
		end)
		
		return menu
	else
		return nil
	end
end
