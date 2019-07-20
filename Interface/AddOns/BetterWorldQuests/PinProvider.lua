local parentMaps = {
	-- list of all continents and their sub-zones that have world quests
	[619] = { -- Broken Isles
		[630] = true, -- Azsuna
		[641] = true, -- Val'sharah
		[650] = true, -- Highmountain
		[634] = true, -- Stormheim
		[680] = true, -- Suramar
		[627] = true, -- Dalaran
		[790] = true, -- Eye of Azshara (world version)
		[646] = true, -- Broken Shore
	},
	[994] = { -- Argus (our modified one, the original ID is 905)
		[830] = true, -- Krokuun
		[885] = true, -- Antoran Wastes
		[882] = true, -- Mac'Aree
	},
	[875] = { -- Zandalar
		[862] = true, -- Zuldazar
		[864] = true, -- Vol'Dun
		[863] = true, -- Nazmir
	},
	[876] = { -- Kul Tiras
		[895] = true, -- Tiragarde Sound
		[896] = true, -- Drustvar
		[942] = true, -- Stormsong Valley
	},
	[13] = { -- Eastern Kingdoms
		[14] = true, -- Arathi Highlands (Warfronts)
	},
	[12] = { -- Kalimdor
		[62] = true, -- Darkshore (Warfronts)
	},
}

local factionList = {
	[1579] = 2164,
	[1592] = 2161,
	[1593] = 2160,
	[1594] = 2162,
	[1595] = 2156,
	[1596] = 2158,
	[1597] = 2103,
	[1598] = 2163,
	[1599] = 2159,
	[1600] = 2157,
	[1738] = 2373,
	[1739] = 2400,
	[1740] = 2391,
	[1742] = 2391,
}

local color, warMode, warModeBonus

local factionAssaultAtlasName = UnitFactionGroup('player') == 'Horde' and 'worldquest-icon-horde' or 'worldquest-icon-alliance'

local function AdjustedMapID(mapID)
	-- this will replace the Argus map ID with the one used by the taxi UI, since one of the
	-- features of this addon is replacing the Argus map art with the taxi UI one
	return mapID == 905 and 994 or mapID
end

-- create a new data provider that will display the world quests on zones from the list above,
-- based on WorldQuestDataProviderMixin
local DataProvider = CreateFromMixins(WorldQuestDataProviderMixin)
DataProvider:SetMatchWorldMapFilters(true)
DataProvider:SetUsesSpellEffect(true)
DataProvider:SetCheckBounties(true)
DataProvider:SetMarkActiveQuests(true)

function DataProvider:GetPinTemplate()
	-- we use our own copy of the WorldMap_WorldQuestPinTemplate template to avoid interference
	return 'BetterWorldQuestPinTemplate'
end

function DataProvider:ShouldShowQuest(questInfo)
	local questID = questInfo.questId
	if (self.focusedQuestID or self:IsQuestSuppressed(questID)) then
		return false
	else
		-- returns true if the given quest is a world quest on one of the maps in our list
		local mapID = AdjustedMapID(self:GetMap():GetMapID())
		local questMapID = questInfo.mapID
		if (mapID == questMapID or (parentMaps[mapID] and parentMaps[mapID][questMapID])) then
			return HaveQuestData(questID) and QuestUtils_IsQuestWorldQuest(questID)
		end
	end
end

function DataProvider:RefreshAllData()
	-- map is updated, draw world quest pins
	local pinsToRemove = {}
	for questID in next, self.activePins do
		-- mark all pins for removal
		pinsToRemove[questID] = true
	end

	local Map = self:GetMap()
	local mapID = AdjustedMapID(Map:GetMapID())

	local quests = mapID and C_TaskQuest.GetQuestsForPlayerByMapID(mapID)
	if (quests) then
		for _, questInfo in next, quests do
			if (self:ShouldShowQuest(questInfo) and self:DoesWorldQuestInfoPassFilters(questInfo)) then
				local questID = questInfo.questId
				pinsToRemove[questID] = nil -- unmark the pin for removal

				local Pin = self.activePins[questID]
				if (Pin) then
					-- update existing pin
					Pin:RefreshVisuals()
					Pin:SetPosition(questInfo.x, questInfo.y)

					if (self.pingPin and self.pingPin:IsAttachedToQuest(questID)) then
						self.pingPin:SetScalingLimits(1, 1, 1)
						self.pingPin:SetPosition(questInfo.x, questInfo.y)
					end
				else
					-- create a new pin
					self.activePins[questID] = self:AddWorldQuest(questInfo)
				end
			end
		end
	end

	for questID in next, pinsToRemove do
		-- iterate and remove all pins marked for removal
		if (self.pingPin and self.pingPin:IsAttachedToQuest(questID)) then
			self.pingPin:Stop()
		end

		Map:RemovePin(self.activePins[questID])
		self.activePins[questID] = nil
	end

	-- trigger callbacks like WorldQuestDataProviderMixin.RefreshAllData does
	Map:TriggerEvent('WorldQuestUpdate', Map:GetNumActivePinsByTemplate(self:GetPinTemplate()))
end

WorldMapFrame:AddDataProvider(DataProvider)

BetterWorldQuestPinMixin = CreateFromMixins(WorldMap_WorldQuestPinMixin)
function BetterWorldQuestPinMixin:OnLoad()
	WorldQuestPinMixin.OnLoad(self)

	-- create any extra widgets we need if they don't already exist
	local Border = self:CreateTexture(nil, 'OVERLAY', nil, 1)
	Border:SetPoint('CENTER', 0, -3)
	Border:SetAtlas('worldquest-emissary-ring')
	Border:SetSize(72, 72)
	self.Border = Border

	-- create the indicator on a subframe so highlights don't overlap
	local Indicator = CreateFrame('Frame', nil, self):CreateTexture(nil, 'OVERLAY', nil, 2)
	Indicator:SetPoint("CENTER", self, "TOPLEFT")
	Indicator:SetSize(44, 44)
	self.Indicator = Indicator

	local Bounty = self:CreateTexture(nil, 'OVERLAY', nil, 2)
	Bounty:SetSize(44, 44)
	Bounty:SetAtlas('QuestNormal')
	Bounty:SetPoint("CENTER", self, "RIGHT")
	Bounty:SetVertexColor(0, 1, 0)
	self.Bounty = Bounty

	local Text = self:CreateFontString(nil, "OVERLAY")
	Text:SetFont(STANDARD_TEXT_FONT, 30, "OUTLINE")
	Text:SetPoint("CENTER", self, "BOTTOM")
	self.Text = Text

	-- make sure the tracked check mark doesn't appear underneath any of our widgets
	self.TrackedCheck:SetDrawLayer('OVERLAY', 3)

	-- 修改剩余时间提示
	self.TimeLowFrame:ClearAllPoints()
	self.TimeLowFrame:SetPoint("CENTER", self, "TOPRIGHT")

	-- 初始化
	color = {}
	warMode = C_PvP.IsWarModeDesired()
	warModeBonus = format("%.1f", 1 + (C_PvP.GetWarModeRewardBonus() / 100))
end

local function IsParentMap(mapID)
	return not not parentMaps[AdjustedMapID(mapID)]
end

function BetterWorldQuestPinMixin:RefreshVisuals()
	WorldMap_WorldQuestPinMixin.RefreshVisuals(self)

	-- update scale
	if (IsParentMap(self:GetMap():GetMapID())) then
		self:SetScalingLimits(1, 0.3, 0.5)
	else
		self:SetScalingLimits(1, 0.425, 0.425)
	end

	-- hide frames we don't want to use
	self.BountyRing:Hide()

	-- set texture to the item/currency/value it rewards
	local questID = self.questID
	if (GetNumQuestLogRewards(questID) > 0) then
		local _, texture, _, quality, _, _, itemLevel = GetQuestLogRewardInfo(1, questID)
		SetPortraitToTexture(self.Texture, texture)
		self.Texture:SetSize(self:GetSize())

		color = BAG_ITEM_QUALITY_COLORS[quality or 1]
		self.Text:SetText(itemLevel)
		self.Text:SetTextColor(color.r, color.g, color.b)
	elseif (GetNumQuestLogRewardCurrencies(questID) > 0) then
		local _, texture, numItems, currencyId, quality = GetQuestLogRewardCurrencyInfo(1, questID)
		SetPortraitToTexture(self.Texture, texture)
		self.Texture:SetSize(self:GetSize())

		color = BAG_ITEM_QUALITY_COLORS[quality or 1]
		if warMode and not factionList[currencyId] then
			numItems = numItems * warModeBonus
			color = {r=0, g=1, b=0}
		end
		self.Text:SetFormattedText("%d", numItems)
		self.Text:SetTextColor(color.r, color.g, color.b)
	elseif (GetQuestLogRewardMoney(questID) > 0) then
		SetPortraitToTexture(self.Texture, [[Interface\Icons\inv_misc_coin_01]])
		self.Texture:SetSize(self:GetSize())

		local copper = GetQuestLogRewardMoney(questID)
		if warMode then
			copper = copper * warModeBonus
			color = {r=0, g=1, b=0}
		else
			color = {r=1, g=1, b=1}
		end
		self.Text:SetFormattedText("%d", copper / 1e4)
		self.Text:SetTextColor(color.r, color.g, color.b)
	end

	-- update our own widgets
	local bountyQuestID = self.dataProvider:GetBountyQuestID()
	self.Bounty:SetShown(bountyQuestID and IsQuestCriteriaForBounty(questID, bountyQuestID))

	local Indicator = self.Indicator
	local _, _, worldQuestType, _, _, professionID = GetQuestTagInfo(questID)
	if (worldQuestType == LE_QUEST_TAG_TYPE_PVP) then
		self.Indicator:SetAtlas('Warfronts-BaseMapIcons-Empty-Barracks-Minimap')
		self.Indicator:SetSize(58, 58)
		self.Indicator:Show()
	else
		self.Indicator:SetSize(44, 44)
		if (worldQuestType == LE_QUEST_TAG_TYPE_PET_BATTLE) then
			self.Indicator:SetAtlas('WildBattlePetCapturable')
			self.Indicator:Show()
		elseif (worldQuestType == LE_QUEST_TAG_TYPE_PROFESSION) then
			self.Indicator:SetAtlas(WORLD_QUEST_ICONS_BY_PROFESSION[professionID])
			self.Indicator:Show()
		elseif (worldQuestType == LE_QUEST_TAG_TYPE_DUNGEON) then
			self.Indicator:SetAtlas('Dungeon')
			self.Indicator:Show()
		elseif (worldQuestType == LE_QUEST_TAG_TYPE_RAID) then
			self.Indicator:SetAtlas('Raid')
			self.Indicator:Show()
		elseif (worldQuestType == LE_QUEST_TAG_TYPE_INVASION) then
			self.Indicator:SetAtlas('worldquest-icon-burninglegion')
			self.Indicator:Show()
		elseif (worldQuestType == LE_QUEST_TAG_TYPE_FACTION_ASSAULT) then
			self.Indicator:SetAtlas(factionAssaultAtlasName)
			self.Indicator:SetSize(38, 38)
			self.Indicator:Show()
		else
			self.Indicator:Hide()
		end
	end
end

-- we need to remove the default data provider mixin
for provider in next, WorldMapFrame.dataProviders do
	if (provider.GetPinTemplate and provider.GetPinTemplate() == 'WorldMap_WorldQuestPinTemplate') then
		WorldMapFrame:RemoveDataProvider(provider)
	end
end

-- 大使任务计数
-- 出自：WorldQuestTab
WorldQuestBountyCount = {}
function WorldQuestBountyCount:OnLoad()
	self.bountyCounterPool = CreateFramePool("FRAME", self, "BountyCounterTemplate")

	-- Auto emisarry when clicking on one of the buttons
	local bountyBoard = WorldMapFrame.overlayFrames[3]
	self.bountyBoard = bountyBoard

	hooksecurefunc(bountyBoard, "OnTabClick", function(self, tab)
		if tab.isEmpty then return end
		WRWorldQuestFrame.autoEmisarryId = bountyBoard.bounties[tab.bountyIndex]
	end)

	hooksecurefunc(bountyBoard, "RefreshSelectedBounty", function(s, tab)
			self:UpdateBountyCounters()
	end)

	-- Slight offset the tabs to make room for the counters
	hooksecurefunc(bountyBoard, "AnchorBountyTab", function(self, tab)
		local point, relativeTo, relativePoint, x, y = tab:GetPoint(1)
		tab:SetPoint(point, relativeTo, relativePoint, x, y + 2)
	end)
end

function WorldQuestBountyCount:UpdateBountyCounters()
	self.bountyCounterPool:ReleaseAll()
	for tab, v in pairs(self.bountyBoard.bountyTabPool.activeObjects) do
		self:AddBountyCountersToTab(tab)
	end
end

function WorldQuestBountyCount:RepositionBountyTabs()
	for tab, v in pairs(self.bountyBoard.bountyTabPool.activeObjects) do
		self.bountyBoard:AnchorBountyTab(tab)
	end
end

function WorldQuestBountyCount:AddBountyCountersToTab(tab)
	local bountyData = self.bountyBoard.bounties[tab.bountyIndex]
	if bountyData then
		local questIndex = GetQuestLogIndexByID(bountyData.questID)
		if questIndex > 0 then
			local desc = GetQuestLogLeaderBoard(1, questIndex)
			local progress, goal = desc:match("([%d]+)%s*/%s*([%d]+)")
			progress = tonumber(progress)
			goal = tonumber(goal)
			if progress == goal then return end
			local offsetAngle, startAngle = 32, 270
			-- position of first counter
			startAngle = startAngle - offsetAngle * (goal -1) /2
			for i=1, goal do
				local counter = self.bountyCounterPool:Acquire()
				local x = cos(startAngle) * 16
				local y = sin(startAngle) * 16
				counter:SetPoint("CENTER", tab.Icon, "CENTER", x, y)
				counter:SetParent(tab)
				counter:Show()
				counter.icon:SetTexCoord(0, 0.5, 0, 0.5)
				-- Light nr of completed
				if i <= progress then
					counter.icon:SetVertexColor(0, 1, 0, 1)
					counter.icon:SetDesaturated(false)
				else
					counter.icon:SetVertexColor(1, 1, 1, 1)
					counter.icon:SetDesaturated(true)
				end
				-- Offset next counter
				startAngle = startAngle + offsetAngle
			end
		end
	end
end