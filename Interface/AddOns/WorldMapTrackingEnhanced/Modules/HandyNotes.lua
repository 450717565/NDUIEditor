-- $Id: HandyNotes.lua 33 2017-06-04 06:10:01Z arith $
-----------------------------------------------------------------------
-- Upvalued Lua API.
-----------------------------------------------------------------------
-- Functions
local _G = getfenv(0)
-- Libraries
-- ----------------------------------------------------------------------------
-- AddOn namespace.
-- ----------------------------------------------------------------------------
local FOLDER_NAME, private = ...

local MODNAME = "HandyNotes"

local LibStub = _G.LibStub
local addon = LibStub("AceAddon-3.0"):GetAddon(private.addon_name)
local HandyNotes = addon:NewModule(MODNAME)

local HN
local iHandyNotes = select(4, GetAddOnInfo("HandyNotes"))
local enabled = GetAddOnEnableState(UnitName("player"), "HandyNotes")

function HandyNotes:OnEnable()
	if (enabled > 0 and iHandyNotes) then 
		HN = LibStub("AceAddon-3.0"):GetAddon("HandyNotes") 
	end
end
	
local function ToggleHandyNotes()
	HN.db.profile.enabled = not HN.db.profile.enabled
	if (HN.db.profile.enabled) then
		HN:Enable()
	else
		HN:Disable()
	end
end

local function CheckHandyNotesStatus()
	return HN.db.profile.enabled or nil
end

local function GetPlugins()
	return HN.plugins
end

local function CheckPluginStatus(pluginName)
	return HN.db.profile.enabledPlugins[pluginName] and true or false
end

local function TogglePlugin(pluginName)
	HN.db.profile.enabledPlugins[pluginName] = not HN.db.profile.enabledPlugins[pluginName]
	HN:UpdatePluginMap(nil, pluginName)
end

function HandyNotes:DropDownMenus()
	if (enabled > 0 and iHandyNotes) then
		local menu = {}
		local i = 1
		local LH = LibStub("AceLocale-3.0"):GetLocale("HandyNotes", false)
		local L = LibStub("AceLocale-3.0"):GetLocale(private.addon_name)
		-- Clear out the info from the separator wholesale.
		menu[i] = {}

		menu[i].isTitle = true
		menu[i].notCheckable = true
		menu[i].text = LH["HandyNotes"]
		menu[i].num = i
		i = i + 1

		menu[i] = {}
		menu[i].isNotRadio = true
		menu[i].keepShownOnClick = true
		if (addon.db.profile.handynotes_contextMenu) then
			menu[i].hasArrow = true
		else
			menu[i].hasArrow = nil
		end
		menu[i].value = "HandyNotes"
		menu[i].text = LH["HandyNotes"]..L[" (Core}"]
		menu[i].colorCode = "|cFFB5E61D"
		menu[i].tooltipTitle = LH["HandyNotes"]
		menu[i].tooltipText = LH["Enable or disable HandyNotes"]
		menu[i].tooltipOnButton = true
		menu[i].checked = CheckHandyNotesStatus
		menu[i].func = ToggleHandyNotes
		menu[i].num = i
		i = i + 1
		
		-- Now create HandyNotes' plugins dropdown
		-- better to find a way to refresh dropdown and then set the disabled status
		--if (addon.HandyNotes.CheckHandyNotesStatus()) then
		--	info.disabled = nil
		--else
		--	info.disabled = true
		--end
		local plugins = GetPlugins()
		for k, v in pairs(plugins) do
			menu[i] = {}
			menu[i].isNotRadio = true
			menu[i].keepShownOnClick = true
			menu[i].text = k
			if (not CheckHandyNotesStatus()) then
				menu[i].disabled = true
			else
				menu[i].disabled = nil
			end
			menu[i].checked = CheckPluginStatus(k)
			menu[i].func = (function(self)
				TogglePlugin(k)
			end)
			menu[i].num = i
			i = i + 1
		end

		menu[i] = {}
		menu[i].isNotRadio = true
		menu[i].notCheckable = true
		menu[i].text = L["HandyNotes Config"]
		menu[i].colorCode = "|cFFFFC90E"
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
