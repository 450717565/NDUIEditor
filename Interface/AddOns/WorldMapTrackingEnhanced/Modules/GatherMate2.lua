-- $Id: GatherMate2.lua 33 2017-06-04 06:10:01Z arith $
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

local MODNAME = "GatherMate2"

local LibStub = _G.LibStub
local addon = LibStub("AceAddon-3.0"):GetAddon(private.addon_name)
local GatherMate2 = addon:NewModule(MODNAME)

local GM
local iGatherMate2 = select(4, GetAddOnInfo("GatherMate2"))
local enabled = GetAddOnEnableState(UnitName("player"), "GatherMate2")

function GatherMate2:OnEnable()
	if (enabled > 0 and iGatherMate2) then 
		GM = LibStub("AceAddon-3.0"):GetAddon("GatherMate2") 
	end
end
	
local function ToggleGatherMate2()
	GM.db.profile.showWorldMap = not GM.db.profile.showWorldMap
	GM:OnProfileChanged()
end

local function CheckWorldMapStatus()
	return GM.db.profile.showWorldMap or nil
end

function GatherMate2:DropDownMenus()
	if (enabled > 0 and iGatherMate2) then
		local info = {}
		local LGM = LibStub("AceLocale-3.0"):GetLocale("GatherMate2", false)
		info.isNotRadio = true
		info.keepShownOnClick = true
		info.text = select(2, GetAddOnInfo("GatherMate2"))
		info.tooltipTitle = LGM["Show World Map Icons"]
		info.tooltipText = LGM["Toggle showing World Map icons."]
		info.tooltipOnButton = true
		info.func = ToggleGatherMate2
		info.checked = CheckWorldMapStatus
		
		return info
	else
		return nil
	end
end
