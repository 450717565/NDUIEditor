-- $Id: Handler.lua 28 2017-05-24 15:30:01Z arith $
-----------------------------------------------------------------------
-- Upvalued Lua API.
-----------------------------------------------------------------------
-- Functions
local _G = getfenv(0)
-- Libraries
local string = _G.string;
local format = string.format
local gsub = string.gsub
local next = next
local wipe = wipe
local GameTooltip = GameTooltip
local WorldMapTooltip = WorldMapTooltip
-- ----------------------------------------------------------------------------
-- AddOn namespace.
-- ----------------------------------------------------------------------------
local FOLDER_NAME, private = ...

local LibStub = _G.LibStub
local L = LibStub("AceLocale-3.0"):GetLocale(private.addon_name)
local LH = LibStub("AceLocale-3.0"):GetLocale("HandyNotes", false)
local AceDB = LibStub("AceDB-3.0")

local HandyNotes = LibStub("AceAddon-3.0"):GetAddon("HandyNotes")
local addon = LibStub("AceAddon-3.0"):NewAddon(private.addon_name, "AceEvent-3.0")
addon.constants = private.constants
addon.constants.addon_name = private.addon_name

addon.descName 		= private.descName
addon.description 	= private.description
addon.pluginName 	= private.pluginName

addon.Name = FOLDER_NAME;
_G.HandyNotes_LegionInstanceWorldQuests = addon;

-- //////////////////////////////////////////////////////////////////////////
local cache_tooltip = CreateFrame("GameTooltip", private.addon_name.."_cacheToolTip", UIParent, "GameTooltipTemplate")
local questTitle_cache
local questComplete_cache

function cache_tooltip:GetQuestTitle()
	local questTitle = _G[private.addon_name.."_cacheToolTipTextLeft1"]:GetText()
	--DEFAULT_CHAT_FRAME:AddMessage(self["message"]:format(questTitle))
	self:SetScript("OnTooltipSetQuest", nil)
	if (questTitle) then 
		questTitle_cache = questTitle
	end
end

-- activation code
local function getQuestTitlebyID(id)
	if IsQuestFlaggedCompleted(id) then
		questComplete_cache = true
	else
		questComplete_cache = nil
	end
	cache_tooltip:SetOwner(UIParent, "ANCHOR_NONE")
	cache_tooltip:SetScript("OnTooltipSetQuest", cache_tooltip.GetQuestTitle)
	cache_tooltip:SetHyperlink("quest:" .. id)
end
-- //////////////////////////////////////////////////////////////////////////
-- get creature's name from server
local mcache_tooltip = CreateFrame("GameTooltip", private.addon_name.."_mcacheToolTip", UIParent, "GameTooltipTemplate")
local creature_cache

-- activation code
local function getCreatureNamebyID(id)
	mcache_tooltip:SetOwner(UIParent, "ANCHOR_NONE")
	mcache_tooltip:SetHyperlink(("unit:Creature-0-0-0-0-%d"):format(id))
	creature_cache = _G[private.addon_name.."_mcacheToolTipTextLeft1"]:GetText()
end
-- //////////////////////////////////////////////////////////////////////////
local function work_out_texture(point)
	if (point.type) then
		return private.constants.icon_texture[point.type]
	-- use the icon specified in point data
	elseif (point.icon) then
		return point.icon
	else
		return private.constants.defaultIcon
	end
end

local get_point_info = function(point)
	if point then
		local label = point.label or UNKNOWN
		local icon = work_out_texture(point)

		return label, icon, point.scale, point.alpha, point.dungeonLevel
	end
end

local get_point_info_by_coord = function(mapFile, coord)
	mapFile = string.gsub(mapFile, "_terrain%d+$", "")
	return get_point_info(private.DB.points[mapFile] and private.DB.points[mapFile][coord])
end

local function handle_tooltip(tooltip, point)
	if point then
		if (point.quest) then
			if (private.db.query_server) then
				getQuestTitlebyID(point.quest)
				if (questTitle_cache) then
--					tooltip:AddLine(QUESTS_COLON..questTitle_cache, 1, 1, 1)
					tooltip:SetHyperlink(("quest:%d[%%s]"):format(point.quest))
					questTitle_cache = nil
				end
			end
			tooltip:AddDoubleLine(L["QuestID"], point.quest or UNKNOWN, 0.5, 0.5, 1, 0.5, 0.5, 1)
			if (IsQuestFlaggedCompleted(point.quest)) then
				tooltip:AddLine(ERR_QUEST_ALREADY_DONE, 0, 1, 0)
			end
		end
		if (point.label and not point.item) then -- skip when item ID is available, this is because we can get item's localized name so we don't need to use the lable
			if (point.npc and private.db.query_server) then
				getCreatureNamebyID(point.npc)
				tooltip:AddLine(creature_cache or point.label)
				creature_cache = nil
			else
				tooltip:AddLine(point.label)
			end
		end
		if (point.item) then
			local itemName = GetItemInfo(point.item)
			if (itemName) then
				if (point.quest) then
					tooltip:AddDoubleLine(ITEM_BIND_QUEST, itemName, 1, 1, 1, 1, 1, 1)
				else
					tooltip:AddDoubleLine(ENCOUNTER_JOURNAL_ITEM, itemName, 1, 1, 1, 1, 1, 1)
				end
			end
		end
		if (point.spell) then
			local spellName = GetSpellInfo(point.spell)
			if (spellName) then
				tooltip:AddLine(spellName, 1, 1, 1, true)
			end
		end
		if (point.achievement) then
			local _, name, _, completed, month, day, year, description, _, _, _, _, _, earnedBy = GetAchievementInfo(point.achievement);
			tooltip:AddLine(BATTLE_PET_SOURCE_6..HEADER_COLON..name, 1, 1, 1)
			if (point.criteria) then
				local tooltiptext = description
				local numCriteria = GetAchievementNumCriteria(point.achievement)
				if (numCriteria and numCriteria > 0) then
					for i = 1, numCriteria do
						-- criteriaString, criteriaType, completed, quantity, reqQuantity, charName, flags, assetID, quantityString, criteriaID, eligible =  GetAchievementCriteriaInfo(achievementID, criteriaIndex)
						local criteriaString, criteriaType, criteriaCompleted, quantity, reqQuantity, _, flags, assetID, quantityString = GetAchievementCriteriaInfo(point.achievement, i);
						if (criteriaType == CRITERIA_TYPE_ACHIEVEMENT and assetID) then
							local _, aname, _, acompleted = GetAchievementInfo(assetID);
							if (acompleted) then
								tooltiptext = tooltiptext.."\n|CFFFFFFFF - "..aname;
							else
								tooltiptext = tooltiptext.."\n|CFF808080 - "..aname;
							end
						--elseif (criteriaString == "" or reqQuantity > 1) then
						elseif (bit.band(flags, EVALUATION_TREE_FLAG_PROGRESS_BAR) == EVALUATION_TREE_FLAG_PROGRESS_BAR) then
							if (quantity >= reqQuantity) then
								tooltiptext = tooltiptext.."\n|CFFFFFFFF - "..quantityString;
							else
								tooltiptext = tooltiptext.."\n|CFF808080 - "..quantityString;
							end
						else
							if (criteriaCompleted) then
								tooltiptext = tooltiptext.."\n|CFFFFFFFF - "..criteriaString;
							else
								tooltiptext = tooltiptext.."\n|CFF808080 - "..criteriaString;
							end
						end
					end
				end
				tooltip:AddLine(tooltiptext)
			end
			if (completed) then
				tooltip:AddLine(format(ACHIEVEMENT_TOOLTIP_COMPLETE, earnedBy, month, day, year), 0, 1, 0)
			end
		end
		if (point.note and private.db.show_note) then
			tooltip:AddLine(point.note, 1, 1, 1, true)
		end
	else
		tooltip:SetText(UNKNOWN)
	end
	tooltip:Show()
end

local handle_tooltip_by_coord = function(tooltip, mapFile, coord)
	mapFile = string.gsub(mapFile, "_terrain%d+$", "")
	return handle_tooltip(tooltip, private.DB.points[mapFile] and private.DB.points[mapFile][coord])
end

-- //////////////////////////////////////////////////////////////////////////
local PluginHandler = {}
local info = {}

function PluginHandler:OnEnter(mapFile, coord)
	local tooltip = self:GetParent() == WorldMapButton and WorldMapTooltip or GameTooltip
	if ( self:GetCenter() > UIParent:GetCenter() ) then -- compare X coordinate
		tooltip:SetOwner(self, "ANCHOR_LEFT")
	else
		tooltip:SetOwner(self, "ANCHOR_RIGHT")
	end
	handle_tooltip_by_coord(tooltip, mapFile, coord)
end

function PluginHandler:OnLeave(mapFile, coord)
	if self:GetParent() == WorldMapButton then
		WorldMapTooltip:Hide()
	else
		GameTooltip:Hide()
	end
end

local function hideNode(button, mapFile, coord)
	private.hidden[mapFile][coord] = true
	addon:Refresh()
end

local function closeAllDropdowns()
	L_CloseDropDownMenus(1)
end

local function addTomTomWaypoint(button, mapFile, coord)
	if TomTom then
		local mapId = HandyNotes:GetMapFiletoMapID(mapFile)
		local x, y = HandyNotes:getXY(coord)
		TomTom:AddMFWaypoint(mapId, nil, x, y, {
			title = get_point_info_by_coord(mapFile, coord),
			persistent = nil,
			minimap = true,
			world = true
		})
	end
end

do
	local currentZone, currentCoord
	local function generateMenu(button, level)
		if (not level) then return end
		if (level == 1) then
			-- Create the title of the menu
			info = L_UIDropDownMenu_CreateInfo()
			info.isTitle 		= 1
			info.text 		= "HandyNotes - " ..addon.pluginName
			info.notCheckable 	= 1
			L_UIDropDownMenu_AddButton(info, level)

			if TomTom then
				-- Waypoint menu item
				info = L_UIDropDownMenu_CreateInfo()
				info.text = LH["Add this location to TomTom waypoints"]
				info.notCheckable = 1
				info.func = addTomTomWaypoint
				info.arg1 = currentZone
				info.arg2 = currentCoord
				L_UIDropDownMenu_AddButton(info, level)
			end

			 -- Hide menu item
			info = L_UIDropDownMenu_CreateInfo()
			info.text		 = HIDE 
			info.notCheckable = 1
			info.func		 = hideNode
			info.arg1		 = currentZone
			info.arg2		 = currentCoord
			L_UIDropDownMenu_AddButton(info, level)

			-- Close menu item
			info = L_UIDropDownMenu_CreateInfo()
			info.text		 = CLOSE
			info.func		 = closeAllDropdowns
			info.notCheckable = 1
			L_UIDropDownMenu_AddButton(info, level)
		end
	end
	local HL_Dropdown = CreateFrame("Frame", private.addon_name.."DropdownMenu")
	HL_Dropdown.displayMode = "MENU"
	HL_Dropdown.initialize = generateMenu

	function PluginHandler:OnClick(button, down, mapFile, coord)
		if button == "RightButton" and not down then
			currentZone = string.gsub(mapFile, "_terrain%d+$", "")
			currentCoord = coord
			L_ToggleDropDownMenu(1, nil, HL_Dropdown, self, 0, 0)
		end
	end
end

do
	-- This is a custom iterator we use to iterate over every node in a given zone
	local currentLevel, currentZone
	local function iter(t, prestate)
		if not t then return nil end
		local state, value = next(t, prestate)
		while state do -- Have we reached the end of this zone?
			if value and private:ShouldShow(state, value, currentZone, currentLevel) then
				local label, icon, scale, alpha, dungeonLevel = get_point_info(value)
				scale = (scale or 1) * (icon and icon.scale or 1) * private.db.icon_scale
				alpha = (alpha or 1) * (icon and icon.alpha or 1) * private.db.icon_alpha
				return state, nil, icon, scale, alpha, dungeonLevel or 0
			end
			state, value = next(t, state) -- Get next data
		end
		return nil, nil, nil, nil, nil, nil
	end
	function PluginHandler:GetNodes(mapFile, minimap, level)
		currentLevel = level
		mapFile = string.gsub(mapFile, "_terrain%d+$", "")
		currentZone = mapFile
		return iter, private.DB.points[mapFile], nil
	end
	function private:ShouldShow(coord, point, currentZone, currentLevel)
		if (private.hidden[currentZone] and private.hidden[currentZone][coord]) then
			return false
		end
		if (point.dungeonLevel and point.dungeonLevel ~= currentLevel) then
			return false
		end
		-- this will check if any node is for specific class
		if (point.class and point.class ~= select(2, UnitClass("player"))) then
			return false
		end
		return true
	end
end

-- //////////////////////////////////////////////////////////////////////////
function addon:OnInitialize()
	self.db = AceDB:New(private.addon_name.."DB", private.constants.defaults)
	
	private.db = self.db.profile
	private.hidden = self.db.char.hidden

	-- Initialize database with HandyNotes
	HandyNotes:RegisterPluginDB(addon.pluginName, PluginHandler, private.config.options)
end

function addon:OnEnable()
	for key, value in pairs( addon.constants.events ) do
		self:RegisterEvent( value );
	end
end

function addon:Refresh()
	self:SendMessage("HandyNotes_NotifyUpdate", addon.pluginName)
end

function addon:CLOSE_WORLD_MAP()
	closeAllDropdowns()
end

-- //////////////////////////////////////////////////////////////////////////
