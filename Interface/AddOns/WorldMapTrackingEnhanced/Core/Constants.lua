-- $Id: Constants.lua 24 2017-05-24 14:29:40Z arith $
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
private.addon_name = "WorldMapTrackingEnhanced"

local LibStub = _G.LibStub

local constants = {}
private.constants = constants

constants.defaults = {
	profile = {
		handynotes_contextMenu = true,
		enable_HandyNotes = true,
		enable_GatherMate2 = true,
		enable_PetTracker = true,
	},
}

constants.events = {
	"CLOSE_WORLD_MAP",
}
