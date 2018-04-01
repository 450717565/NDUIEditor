-- $Id: Config.lua 64 2018-03-28 04:33:06Z arith $
-----------------------------------------------------------------------
-- Upvalued Lua API.
-----------------------------------------------------------------------
-- Functions
local _G = getfenv(0)
local pairs = _G.pairs
-- Libraries
-- ----------------------------------------------------------------------------
-- AddOn namespace.
-- ----------------------------------------------------------------------------
local FOLDER_NAME, private = ...
local LibStub = _G.LibStub;
local addon = LibStub("AceAddon-3.0"):GetAddon(private.addon_name)
local L = LibStub("AceLocale-3.0"):GetLocale(private.addon_name);

local AceConfigReg = LibStub("AceConfigRegistry-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceDBOptions = LibStub("AceDBOptions-3.0")

local optGetter, optSetter
do
	function optGetter(info)
		local key = info[#info]
		return addon.db.profile[key]
	end

	function optSetter(info, value)
		local key = info[#info]
		addon.db.profile[key] = value
		addon:Refresh()
	end
end

local options, moduleOptions = nil, {}

local function getOptions()
	if not options then
		options = {
			type = "group",
			name = addon.LocName,
			args = {
				general = {
					order = 1,
					type = "group",
					name = L["Options"],
					get = optGetter,
					set = optSetter,
					args = {
						version = {
							order = 1,
							type = "description",
							name = addon.Notes,
						},
						header1 = {
							order = 10,
							type = "header",
							name = L["Support"],
						},
						desc1 = {
							order = 10.1,
							type = "description",
							name = L["Toggle which map enhancement addon to be included in the enhanced tracking option menu."],
						},
						enable_HandyNotes = {
							order = 11,
							type = "toggle",
							name = select(2, GetAddOnInfo("HandyNotes")) or L["HandyNotes"],
							desc = select(3, GetAddOnInfo("HandyNotes")) or nil,
							disabled = function() 
								local iHandyNotes = select(4, GetAddOnInfo("HandyNotes"))
								return not iHandyNotes
							end,
						},
						enable_GatherMate2 = {
							order = 12,
							type = "toggle",
							name = select(2, GetAddOnInfo("GatherMate2")) or L["GatherMate2"],
							desc = select(3, GetAddOnInfo("GatherMate2")) or nil,
							disabled = function() 
								local iGatherMate2 = select(4, GetAddOnInfo("GatherMate2"))
								return not iGatherMate2
							end,
						},
						enable_PetTracker = {
							order = 13,
							type = "toggle",
							name = select(2, GetAddOnInfo("PetTracker")) or L["PetTracker"],
							desc = select(3, GetAddOnInfo("PetTracker")) or nil,
							disabled = function() 
								local iPetTracker = select(4, GetAddOnInfo("PetTracker"))
								return not iPetTracker
							end,
						},
						enable_WorldQuestTracker = {
							order = 14,
							type = "toggle",
							name = select(2, GetAddOnInfo("WorldQuestTracker")) or L["WorldQuestTracker"],
							desc = select(3, GetAddOnInfo("WorldQuestTracker")) or nil,
							disabled = function() 
								local iWorldQuestTracker = select(4, GetAddOnInfo("WorldQuestTracker"))
								return not iWorldQuestTracker
							end,
						},
						header2 = {
							order = 20,
							type = "header",
							name = L["Second Level Menu"],
						},
						handynotes_contextMenu = {
							order = 21,
							type = "toggle",
							name = select(2, GetAddOnInfo("HandyNotes")) or L["HandyNotes"],
							desc = L["Show HandyNotes plugins in second level menu."],
							width = "full",
							disabled = function() 
								local iHandyNotes = select(4, GetAddOnInfo("HandyNotes"))
								return not iHandyNotes or not addon.db.profile.enable_HandyNotes
							end,
						},
						worldQuestTracker_contextMenu = {
							order = 22,
							type = "toggle",
							name = select(2, GetAddOnInfo("WorldQuestTracker")) or L["WorldQuestTracker"],
							desc = L["Show WorldQuestTracker's filter selections in second level menu."],
							width = "full",
							disabled = function() 
								local iWorldQuestTracker = select(4, GetAddOnInfo("WorldQuestTracker"))
								return not iWorldQuestTracker or not addon.db.profile.enable_WorldQuestTracker
							end,
						},
					},
				},
			},
		}
		for k,v in pairs(moduleOptions) do
			options.args[k] = (type(v) == "function") and v() or v
		end
	end
	
	return options
end

local function openOptions()
	-- open the profiles tab before, so the menu expands
	InterfaceOptionsFrame_OpenToCategory(addon.optionsFrames.Profiles)
	InterfaceOptionsFrame_OpenToCategory(addon.optionsFrames.Profiles) -- yes, run twice to force the tre get expanded
	InterfaceOptionsFrame_OpenToCategory(addon.optionsFrames.General)
	InterfaceOptionsFrame:Raise()
end

function addon:OpenOptions() 
	openOptions()
end

local function giveProfiles()
	return AceDBOptions:GetOptionsTable(addon.db)
end

function addon:SetupOptions()
	self.optionsFrames = {}

	-- setup options table
	AceConfigReg:RegisterOptionsTable(addon.LocName, getOptions)
	self.optionsFrames.General = AceConfigDialog:AddToBlizOptions(addon.LocName, nil, nil, "general")

	self:RegisterModuleOptions("Profiles", giveProfiles, L["Profile Options"])
end

-- Description: Function which extends our options table in a modular way
-- Expected result: add a new modular options table to the modularOptions upvalue as well as the Blizzard config
-- Input:
--		name			: index of the options table in our main options table
--		optionsTable	: the sub-table to insert
--		displayName	: the name to display in the config interface for this set of options
-- Output: None.
function addon:RegisterModuleOptions(name, optionTbl, displayName)
	moduleOptions[name] = optionTbl
	self.optionsFrames[name] = AceConfigDialog:AddToBlizOptions(addon.LocName, displayName, addon.LocName, name)
end
