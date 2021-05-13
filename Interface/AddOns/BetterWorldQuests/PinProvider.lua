local parentMaps = {
	-- list of all continents and their sub-zones that have world quests
	[1550] = { -- Shadowlands
		[1525] = true, -- Revendreth
		[1533] = true, -- Bastion
		[1536] = true, -- Maldraxxus
		[1565] = true, -- Ardenwald
	},
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
	[1579] = true,
	[1592] = true,
	[1593] = true,
	[1594] = true,
	[1595] = true,
	[1596] = true,
	[1597] = true,
	[1598] = true,
	[1599] = true,
	[1600] = true,
	[1738] = true,
	[1739] = true,
	[1740] = true,
	[1742] = true,

	[1804] = true, -- 晋升者
	[1805] = true, -- 不朽军团
	[1806] = true, -- 荒猎团
	[1807] = true, -- 收割者之庭
}

local ANIMA_SPELLID = {[347555] = 3, [345706] = 5, [336327] = 35, [336456] = 250}
local function GetAnimaMultiplier(itemID)
	local _, spellID = GetItemSpell(itemID)
	return ANIMA_SPELLID[spellID]
end

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
	if(self.focusedQuestID or self:IsQuestSuppressed(questID)) then
		return false
	else
		-- returns true if the given quest is a world quest on one of the maps in our list
		local mapID = AdjustedMapID(self:GetMap():GetMapID())
		local questMapID = questInfo.mapID
		if(mapID == questMapID or (parentMaps[mapID] and parentMaps[mapID][questMapID])) then
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
	if(quests) then
		for _, questInfo in next, quests do
			if(self:ShouldShowQuest(questInfo) and self:DoesWorldQuestInfoPassFilters(questInfo)) then
				local questID = questInfo.questId
				pinsToRemove[questID] = nil -- unmark the pin for removal

				local Pin = self.activePins[questID]
				if(Pin) then
					-- update existing pin
					Pin:RefreshVisuals()
					Pin:SetPosition(questInfo.x, questInfo.y)

					if(self.pingPin and self.pingPin:IsAttachedToQuest(questID)) then
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
		if(self.pingPin and self.pingPin:IsAttachedToQuest(questID)) then
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
	self.TimeLowFrame:ClearAllPoints()
	self.TimeLowFrame:SetPoint("CENTER", self, "TOPRIGHT")
end

local function IsParentMap(mapID)
	return not not parentMaps[AdjustedMapID(mapID)]
end

function BetterWorldQuestPinMixin:RefreshVisuals()
	WorldMap_WorldQuestPinMixin.RefreshVisuals(self)

	-- update scale
	if(IsParentMap(self:GetMap():GetMapID())) then
		self:SetScalingLimits(1, 0.3, 0.5)
	else
		self:SetScalingLimits(1, 0.425, 0.425)
	end

	-- hide frames we don't want to use
	self.BountyRing:Hide()

	-- set texture to the item/currency/value it rewards
	local r, g, b = 1, 1, 1
	local warMode = C_PvP.IsWarModeDesired()
	local warModeBonus = format("%.1f", 1 + (C_PvP.GetWarModeRewardBonus() / 100))

	local questID = self.questID
	local numMoney = GetQuestLogRewardMoney(questID)
	local numRewards = GetNumQuestLogRewards(questID)
	local numCurrencies = GetNumQuestLogRewardCurrencies(questID)
	if numRewards > 0 then
		local itemName, itemTexture, numItems, quality, isUsable, itemID, itemLevel
		for index = 1, numRewards do
			itemName, itemTexture, numItems, quality, isUsable, itemID, itemLevel = GetQuestLogRewardInfo(index, questID)
		end

		if C_Item.IsAnimaItemByID(itemID) then
			itemTexture = 3528288
			itemLevel = numItems * GetAnimaMultiplier(itemID)
		elseif numItems and numItems > 1 then
			itemLevel = numItems
		elseif itemLevel and itemLevel <= 1 then
			itemLevel = ""
		end

		SetPortraitToTexture(self.Texture, itemTexture)
		self.Texture:SetSize(self:GetSize())

		r, g, b = GetItemQualityColor(quality or 1)
		self.Text:SetText(itemLevel)
		self.Text:SetTextColor(r, g, b)
	elseif numCurrencies > 0 then
		local name, texture, numItems, currencyId, quality
		for index = 1, numCurrencies do
			name, texture, numItems, currencyId, quality = GetQuestLogRewardCurrencyInfo(index, questID)
		end

		SetPortraitToTexture(self.Texture, texture)
		self.Texture:SetSize(self:GetSize())

		r, g, b = GetItemQualityColor(quality or 1)
		if warMode and not factionList[currencyId] then
			numItems = numItems * warModeBonus
			r, g, b = 0, 1, 0
		end

		self.Text:SetFormattedText("%d", numItems)
		self.Text:SetTextColor(r, g, b)
	elseif numMoney > 0 then
		SetPortraitToTexture(self.Texture, "Interface\\Icons\\inv_misc_coin_01")
		self.Texture:SetSize(self:GetSize())

		local copper = GetQuestLogRewardMoney(questID)
		if warMode then
			copper = copper * warModeBonus
			r, g, b = 0, 1, 0
		end

		self.Text:SetFormattedText("%d", copper / 1e4)
		self.Text:SetTextColor(r, g, b)
	end

	-- update our own widgets
	local bountyQuestID = self.dataProvider:GetBountyQuestID()
	self.Bounty:SetShown(bountyQuestID and C_QuestLog.IsQuestCriteriaForBounty(questID, bountyQuestID))

	local Indicator = self.Indicator
	local questInfo = C_QuestLog.GetQuestTagInfo(questID)
	-- local _, _, worldQuestType, _, _, professionID = C_QuestLog.GetQuestTagInfo(questID)
	if(questInfo.worldQuestType == Enum.QuestTagType.PvP) then
		self.Indicator:SetAtlas('Warfronts-BaseMapIcons-Empty-Barracks-Minimap')
		self.Indicator:SetSize(58, 58)
		self.Indicator:Show()
	else
		self.Indicator:SetSize(44, 44)
		if(questInfo.worldQuestType == Enum.QuestTagType.PetBattle) then
			self.Indicator:SetAtlas('WildBattlePetCapturable')
			self.Indicator:Show()
		elseif(questInfo.worldQuestType == Enum.QuestTagType.Profession) then
			self.Indicator:SetAtlas(WORLD_QUEST_ICONS_BY_PROFESSION[questInfo.tradeskillLineID])
			self.Indicator:Show()
		elseif(questInfo.worldQuestType == Enum.QuestTagType.Dungeon) then
			self.Indicator:SetAtlas('Dungeon')
			self.Indicator:Show()
		elseif(questInfo.worldQuestType == Enum.QuestTagType.Raid) then
			self.Indicator:SetAtlas('Raid')
			self.Indicator:Show()
		elseif(questInfo.worldQuestType == Enum.QuestTagType.Invasion) then
			self.Indicator:SetAtlas('worldquest-icon-burninglegion')
			self.Indicator:Show()
		elseif(questInfo.worldQuestType == Enum.QuestTagType.FactionAssault) then
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
	if(provider.GetPinTemplate and provider.GetPinTemplate() == 'WorldMap_WorldQuestPinTemplate') then
		WorldMapFrame:RemoveDataProvider(provider)
	end
end

-- 大使任务计数
local WorldQuestBountyCount = CreateFrame("Frame")

function WorldQuestBountyCount:OnLoad()
	self.bountyCounterPool = CreateFramePool("FRAME", self, "BountyCounterTemplate")

	-- Auto emisarry when clicking on one of the buttons
	local bountyBoard = WorldMapFrame.overlayFrames[4]
	self.bountyBoard = bountyBoard

	hooksecurefunc(bountyBoard, "RefreshSelectedBounty", function()
		self:UpdateBountyCounters()
	end)

	-- Slight offset the tabs to make room for the counters
	hooksecurefunc(bountyBoard, "AnchorBountyTab", function(self, tab)
		local point, relativeTo, relativePoint, x, y = tab:GetPoint(1);
		tab:SetPoint(point, relativeTo, relativePoint, x, y + 2);
	end)
end

function WorldQuestBountyCount:UpdateBountyCounters()
	self.bountyCounterPool:ReleaseAll()

	if (not self.bountyInfo) then
		self.bountyInfo = {}
	end

	for tab, v in pairs(self.bountyBoard.bountyTabPool.activeObjects) do
		self:AddBountyCountersToTab(tab)
	end
end

function WorldQuestBountyCount:AddBountyCountersToTab(tab)
	local bountyData = self.bountyBoard.bounties[tab.bountyIndex]

	if (bountyData) then
		local progress, goal = self.bountyBoard:CalculateBountySubObjectives(bountyData)

		if (progress == goal) then return end

		-- Counters
		local offsetAngle = 32
		local startAngle = 270

		-- position of first counter
		startAngle = startAngle - offsetAngle * (goal -1) /2

		for i=1, goal do
			local counter = self.bountyCounterPool:Acquire()

			local x = cos(startAngle) * 16
			local y = sin(startAngle) * 16
			counter:SetPoint("CENTER", tab.Icon, "CENTER", x, y)
			counter:SetParent(tab)
			counter:Show()

			-- Light nr of completed
			if i <= progress then
				counter.icon:SetTexCoord(0, 0.5, 0, 0.5)
				counter.icon:SetVertexColor(1, 1, 1, 1)
				counter.icon:SetDesaturated(false)
			else
				counter.icon:SetTexCoord(0, 0.5, 0, 0.5)
				counter.icon:SetVertexColor(0.75, 0.75, 0.75, 1)
				counter.icon:SetDesaturated(true)
			end

			-- Offset next counter
			startAngle = startAngle + offsetAngle
		end
	end
end

WorldQuestBountyCount:OnLoad()