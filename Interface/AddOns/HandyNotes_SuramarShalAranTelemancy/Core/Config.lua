-- $Id: Config.lua 23 2017-05-02 07:16:40Z arith $
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
				show_shalaran = {
					type = "toggle",
					name = L["Shal'Aran Portals"],
					desc = L["Show portals inside Shal'Aran"],
					order = 12,
				},
				show_telemetryLab = {
					type = "toggle",
					name = L["Telemetry Lab"],
					desc = L["Show Telemetry Lab related telemancies, mainly quest related from Oculeth's quest: \"The Delicate Art of Telemancy\"."],
					order = 13,
				},
				show_leyline = {
					type = "toggle",
					name = L["Leyline Entrances"],
					desc = L["Show entrances which lead to the leyline."],
					order = 14,
				},
				show_specifiedEntrance = {
					type = "toggle",
					name = L["Specified Entrances"],
					desc = L["Show the entrances which lead to known caves or space."],
					order = 15,
				},
				show_unspecifiedEntrances = {
					type = "toggle",
					name = L["Unspecified Entrances"],
					desc = L["Show the entrances which are not specified more precisely."],
					order = 16,
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
					desc = L["Send query request to server to lookup NPC's localized name. May be a little bit slower for the first time lookup but would be very fast once the name is found and cached."],
					order = 10,
				},
				show_note = {
					type = "toggle",
					name = L["Show note"],
					desc = L["Show the node's additional notes when it's available."],
					order = 11,
				},
				ignore_InOutDoor = {
					type = "toggle",
					name = L["Ignore in-/out-door"],
					desc = L["Ignore whether it is currently indoor or outdoor, show all nodes."],
					order = 12,
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

