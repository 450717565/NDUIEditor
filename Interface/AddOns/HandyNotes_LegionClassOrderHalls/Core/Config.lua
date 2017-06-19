-- $Id: Config.lua 46 2017-05-25 06:01:07Z arith $
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

local config = {}
private.config = config

config.options = {
	type = "group",
	name = addon.pluginName,
	desc = addon.description,
	get = function(info) return private.db[info[#info]] end,
	set = function(info, v)
		private.db[info[#info]] = v
		addon:SendMessage("HandyNotes_NotifyUpdate", addon.pluginName)
	end,
	args = {
		icon = {
			type = "group",
			name = L["Icon settings"],
			inline = true,
			order = 10,
			args = {
				desc = {
					name = L["These settings control the look and feel of the icon."],
					type = "description",
					order = 0,
				},
				icon_scale = {
					type = "range",
					name = L["Icon Scale"],
					desc = L["The scale of the icons"],
					min = 0.25, max = 2, step = 0.01,
					order = 20,
				},
				icon_alpha = {
					type = "range",
					name = L["Icon Alpha"],
					desc = L["The alpha transparency of the icons"],
					min = 0, max = 1, step = 0.01,
					order = 30,
				},
			},
		},
		display = {
			type = "group",
			name = L["What to display"],
			inline = true,
			order = 20,
			args = {
				desc = {
					name = L["These settings control what type of icons to be displayed."],
					type = "description",
					order = 0,
				},
				show_mission = {
					type = "toggle",
					name = ORDER_HALL_MISSIONS,
					desc = L["Show the node where you can manage your class hall missions."],
					order = 20,
				},
				show_recruiter = {
					type = "toggle",
					name = CAPACITANCE_START_RECRUITMENT,
					desc = L["Show the recruiter's locations."],
					order = 21,
				},
				show_research = {
					type = "toggle",
					name = L["Artifact Research"],
					desc = L["Show the class hall researcher's location."],
					order = 22,
				},
				show_armaments = {
					type = "toggle",
					name = L["Champion Armaments"],
					desc = L["Show the Champion Armaments NPC's location."],
					order = 23,
				},
				show_quartermaster = {
					type = "toggle",
					name = L["Class Hall Quartermaster"],
					desc = L["Show the class hall quartermaster's location."],
					order = 24,
				},
				show_classUpgrade = {
					type = "toggle",
					name = ORDER_HALL_TALENT_TITLE,
					desc = L["Show the location of the NPC where you can learn for your class hall upgrade."],
					order = 26,
				},
				show_artifact = {
					type = "toggle",
					name = ARTIFACT_POWER,
					desc = L["Show the location of your class hall forge where you can manage your artifact power."],
					order = 26,
				},
				show_portal = {
					type = "toggle",
					name = L["Portal"],
					desc = L["Show portal's locations."],
					order = 27,
				},
				show_flight = {
					type = "toggle",
					name = MINIMAP_TRACKING_FLIGHTMASTER,
					desc = L["Show flight master's location."],
					order = 28,
				},
				show_lightsHeart = {
					type = "toggle",
					name = L["Light's Heart"],
					desc = L["Show the location of Light's Heart."],
					order = 29,
				},
				show_sealOrder = {
					type = "toggle",
					name = L["Seal of Broken Fate"],
					desc = L["Show the location of Seal of Broken Fate vendor."],
					order = 30,
				},
				show_others = {
					type = "toggle",
					name = L["Others"],
					desc = L["Show all the other POIs."],
					order = 40,
				},
			},
		},
		plugin_config = {
			type = "group",
			name = L["AddOn Settings"],
			inline = true,
			order = 30,
			args = {
				query_server = {
					type = "toggle",
					name = L["Query from server"],
					desc = L["Send query request to server to lookup localized name. May be a little bit slower for the first time lookup but would be very fast once the name is found and cached."],
					order = 10,
				},
				show_note = {
					type = "toggle",
					name = L["Show note"],
					desc = L["Show the node's additional notes when it's available."],
					order = 40,
				},
				unhide = {
					type = "execute",
					name = L["Reset hidden nodes"],
					desc = L["Show all nodes that you manually hid by right-clicking on them and choosing \"hide\"."],
					func = function()
						for map,coords in pairs(private.hidden) do
							wipe(coords)
						end
						addon:Refresh()
					end,
					order = 50,
				},
			},
		},
	},
}

