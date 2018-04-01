-- $Id: HandyNotes.lua 70 2018-03-29 07:50:58Z arith $
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

local MODNAME = "HandyNotes"

local LibStub = _G.LibStub
local addon = LibStub("AceAddon-3.0"):GetAddon(private.addon_name)
local L = LibStub("AceLocale-3.0"):GetLocale(private.addon_name)
local HandyNotes = addon:NewModule(MODNAME)

local HN, profile, LH
local iHandyNotes = select(4, GetAddOnInfo(MODNAME))
local enabled = GetAddOnEnableState(UnitName("player"), MODNAME)

function HandyNotes:OnEnable()
	if (enabled > 0 and iHandyNotes) then 
		HN = LibStub("AceAddon-3.0"):GetAddon(MODNAME) 
		profile = HN.db.profile
		LH = LibStub("AceLocale-3.0"):GetLocale(MODNAME, false)
	end
end
	
local function toggleHandyNotes()
	profile.enabled = not profile.enabled
	if (profile.enabled) then
		HN:Enable()
	else
		HN:Disable()
	end
end

local function checkHandyNotesStatus()
	return profile.enabled or nil
end

local function getPlugins()
	return HN.plugins
end

local function checkPluginStatus(pluginName)
	return profile.enabledPlugins[pluginName] and true or false
end

local function togglePlugin(pluginName)
	profile.enabledPlugins[pluginName] = not profile.enabledPlugins[pluginName]
	HN:UpdatePluginMap(nil, pluginName)
end

function HandyNotes:DropDownMenus()
	if (enabled > 0 and iHandyNotes) then
		local menu = {}
		local i = 1

		-- Clear out the info from the separator wholesale.
		menu[i] = {}
		menu[i].text = LH["HandyNotes"]
		menu[i].isNotRadio = true
		--menu[i].keepShownOnClick = true
		if (addon.db.profile.handynotes_contextMenu) then
			menu[i].hasArrow = true
		else
			menu[i].hasArrow = nil
		end
		menu[i].value = "HandyNotes"
		menu[i].colorCode = "|cFFFFC90E"
		menu[i].tooltipTitle = LH["HandyNotes"]
		menu[i].tooltipText = LH["Enable or disable HandyNotes"]
		menu[i].tooltipOnButton = true
		menu[i].checked = checkHandyNotesStatus
		menu[i].func = toggleHandyNotes
		menu[i].num = i
		i = i + 1
		
		-- Now create HandyNotes' plugins dropdown
		-- better to find a way to refresh dropdown and then set the disabled status
		--if (addon.HandyNotes.checkHandyNotesStatus()) then
		--	info.disabled = nil
		--else
		--	info.disabled = true
		--end
		local plugins = getPlugins()
		for k, v in pairs(plugins) do
			menu[i] = {}
			menu[i].isNotRadio = true
			menu[i].keepShownOnClick = true
			menu[i].text = k
			if (not checkHandyNotesStatus()) then
				menu[i].disabled = true
			else
				menu[i].disabled = nil
			end
			menu[i].checked = checkPluginStatus(k)
			menu[i].func = (function(self)
				togglePlugin(k)
			end)
			menu[i].num = i
			i = i + 1
		end

		menu[i] = {}
		menu[i].isNotRadio = true
		menu[i].notCheckable = true
		menu[i].text = L["HandyNotes Config"]
		menu[i].colorCode = "|cFFB5E61D"
		menu[i].tooltipTitle = LH["HandyNotes"]
		menu[i].tooltipText = L["Click to open HandyNotes' config panel"]
		menu[i].tooltipOnButton = true
		menu[i].func = (function(self)
			ToggleFrame(WorldMapFrame)
			InterfaceOptionsFrame_OpenToCategory("HandyNotes")
			InterfaceOptionsFrame_OpenToCategory("HandyNotes")
		end)
		
		return menu
	else
		return nil
	end
end
