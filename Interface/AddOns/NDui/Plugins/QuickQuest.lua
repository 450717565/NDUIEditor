--------------------------
-- QuickQuest, by p3lim
-- NDui MOD
--------------------------
local _, ns = ...
local B, C, L, DB = unpack(ns)

local next, pairs, select = next, pairs, select
local UnitGUID, IsShiftKeyDown, GetItemInfoFromHyperlink = UnitGUID, IsShiftKeyDown, GetItemInfoFromHyperlink
local GetNumTrackingTypes, GetTrackingInfo, GetInstanceInfo, GetQuestID = GetNumTrackingTypes, GetTrackingInfo, GetInstanceInfo, GetQuestID
local GetNumActiveQuests, GetActiveTitle, GetActiveQuestID, SelectActiveQuest = GetNumActiveQuests, GetActiveTitle, GetActiveQuestID, SelectActiveQuest
local IsQuestCompletable, GetNumQuestItems, GetQuestItemLink, QuestIsFromAreaTrigger = IsQuestCompletable, GetNumQuestItems, GetQuestItemLink, QuestIsFromAreaTrigger
local QuestGetAutoAccept, AcceptQuest, CloseQuest, CompleteQuest, AcknowledgeAutoAcceptQuest = QuestGetAutoAccept, AcceptQuest, CloseQuest, CompleteQuest, AcknowledgeAutoAcceptQuest
local GetNumQuestChoices, GetQuestReward, GetItemInfo, GetQuestItemInfo = GetNumQuestChoices, GetQuestReward, GetItemInfo, GetQuestItemInfo
local GetNumAvailableQuests, GetAvailableQuestInfo, SelectAvailableQuest = GetNumAvailableQuests, GetAvailableQuestInfo, SelectAvailableQuest
local GetNumAutoQuestPopUps, GetAutoQuestPopUp, ShowQuestOffer, ShowQuestComplete = GetNumAutoQuestPopUps, GetAutoQuestPopUp, ShowQuestOffer, ShowQuestComplete
local C_QuestLog_IsWorldQuest = C_QuestLog.IsWorldQuest
local C_QuestLog_IsQuestTrivial = C_QuestLog.IsQuestTrivial
local C_QuestLog_GetQuestTagInfo = C_QuestLog.GetQuestTagInfo
local C_GossipInfo_GetOptions = C_GossipInfo.GetOptions
local C_GossipInfo_SelectOption = C_GossipInfo.SelectOption
local C_GossipInfo_GetNumOptions = C_GossipInfo.GetNumOptions
local C_GossipInfo_GetActiveQuests = C_GossipInfo.GetActiveQuests
local C_GossipInfo_SelectActiveQuest = C_GossipInfo.SelectActiveQuest
local C_GossipInfo_GetAvailableQuests = C_GossipInfo.GetAvailableQuests
local C_GossipInfo_GetNumActiveQuests = C_GossipInfo.GetNumActiveQuests
local C_GossipInfo_SelectAvailableQuest = C_GossipInfo.SelectAvailableQuest
local C_GossipInfo_GetNumAvailableQuests = C_GossipInfo.GetNumAvailableQuests
local MINIMAP_TRACKING_TRIVIAL_QUESTS = MINIMAP_TRACKING_TRIVIAL_QUESTS

local choiceQueue

-- Minimap checkbox
local created
local function setupCheckButton()
	if created then return end
	local mono = CreateFrame("CheckButton", nil, WorldMapFrame.BorderFrame, "OptionsCheckButtonTemplate")
	mono:SetHitRectInsets(-5, -5, -5, -5)
	mono:SetPoint("TOPRIGHT", -140, 0)
	mono:SetSize(26, 26)
	B.ReskinCheck(mono)

	mono.text = B.CreateFS(mono, 14, L["AutoQuest"], false, "LEFT", 25, 0)
	mono:SetChecked(C.db["Misc"]["AutoQuest"])
	mono:SetScript("OnClick", function(self)
		C.db["Misc"]["AutoQuest"] = self:GetChecked()
	end)
	mono.title = L["Tips"]
	B.AddTooltip(mono, "ANCHOR_BOTTOMLEFT", L["AutoQuestTip"], "info")

	created = true
end
WorldMapFrame:HookScript("OnShow", setupCheckButton)

-- Main
local QuickQuest = CreateFrame("Frame")
QuickQuest:SetScript("OnEvent", function(self, event, ...)
	self[event](...)
end)

function QuickQuest:Register(event, func)
	self:RegisterEvent(event)
	self[event] = function(...)
		if C.db["Misc"]["AutoQuest"] then
			if not IsShiftKeyDown() then
				func(...)
			end
		else
			if IsShiftKeyDown() then
				func(...)
			end
		end
	end
end

local function GetNPCID()
	return B.GetNPCID(UnitGUID("npc"))
end

local function IsTrackingHidden()
	for index = 1, GetNumTrackingTypes() do
		local name, _, active = GetTrackingInfo(index)
		if name == MINIMAP_TRACKING_TRIVIAL_QUESTS then
			return active
		end
	end
end

local ignoreQuestNPC = {
	-- 考古学训练师
	[ 44238] = true, -- 哈里森·琼斯
	[ 47571] = true, -- 贝洛克·辉刃
	[ 93538] = true, -- 博学者达瑞妮斯

	-- 传送门训练师
	[ 29156] = true, -- 大法师塞琳德拉
	[131443] = true, -- 首席传送师欧库勒斯
	[143172] = true, -- 伊薇拉·晨翼 <阿拉希高地>
	[143380] = true, -- 伊薇拉·晨翼
	[143381] = true, -- 德鲁扎·虚空之牙 <阿拉希高地>
	[143388] = true, -- 德鲁扎·虚空之牙

	-- 命运大师
	[ 87391] = true, -- 命运扭曲者赛瑞斯
	[ 88570] = true, -- 命运扭曲者提拉尔
	[111243] = true, -- 大法师兰达洛克
	[141584] = true, -- 祖尔温
	[142063] = true, -- 特兹兰

	-- 荣耀印记军需官
	[143555] = true, -- 山德·希尔伯曼 <部落>
	[143560] = true, -- 加布里埃尔元帅 <联盟>

	-- 麦卡贡订单日常
	[149813] = true, -- 吉拉·交线 <联盟>
	[150563] = true, -- 斯卡基特 <部落>

	-- 布林顿
	[ 43929] = true, -- 4000
	[ 77789] = true, -- 5000
	[101527] = true, -- 6000
	[153897] = true, -- 7000

	-- 其他
	[ 14847] = true, -- 萨杜斯·帕雷教授 <暗月卡片商人>
	[101462] = true, -- 里弗斯
	[101880] = true, -- 泰克泰克
	[103792] = true, -- 格里伏塔 <绝世宝物商人>
	[108868] = true, -- 塔鲁瓦 <雄鹰管理员>
	[114719] = true, -- 商人塞林
	[119388] = true, -- 酋长哈顿
	[121263] = true, -- 大技师罗姆尔
	[124312] = true, -- 大主教图拉扬
	[126954] = true, -- 大主教图拉扬
	[127037] = true, -- 纳毕鲁
	[135690] = true, -- 亡灵舰长塔特赛尔
	[150987] = true, -- 肖恩·维克斯，斯坦索姆
	[154534] = true, -- 阿畅 <电涌保护者>
	[160248] = true, -- 档案员费安，罪魂碎片
	[168430] = true, -- 戴克泰丽丝 <晋升之路工匠>
	[326027] = true, -- 回收生成器DX-82
}

QuickQuest:Register("QUEST_GREETING", function()
	local npcID = GetNPCID()
	if ignoreQuestNPC[npcID] then return end

	local active = GetNumActiveQuests()
	if active > 0 then
		for index = 1, active do
			local _, isComplete = GetActiveTitle(index)
			local questID = GetActiveQuestID(index)
			if isComplete and not C_QuestLog_IsWorldQuest(questID) then
				SelectActiveQuest(index)
			end
		end
	end

	local available = GetNumAvailableQuests()
	if available > 0 then
		for index = 1, available do
			local isTrivial = GetAvailableQuestInfo(index)
			if not isTrivial or IsTrackingHidden() then
				SelectAvailableQuest(index)
			end
		end
	end
end)

local ignoreGossipNPC = {
	-- 保镖
	[86682] = true, -- 高里亚退役百夫长
	[86927] = true, -- 暴风之盾死亡骑士
	[86933] = true, -- 战争之矛魔导师
	[86934] = true, -- 沙塔尔防御者
	[86945] = true, -- 誓日术士
	[86946] = true, -- 流亡者鸦爪祭司
	[86964] = true, -- 血鬃缚地者

	-- 邪能小鬼
	[95139] = true,
	[95141] = true,
	[95142] = true,
	[95143] = true,
	[95144] = true,
	[95145] = true,
	[95146] = true,
	[95200] = true,
	[95201] = true,

	-- 任务专员
	[79740] = true, -- 战争大师佐格
	[79953] = true, -- 索恩中尉
	[84268] = true, -- 索恩中尉
	[90250] = true, -- 格雷森·沙东布瑞克公爵
	[93568] = true, -- 女妖希奥克丝
	[98002] = true, -- 啸天者欧穆隆

	-- 向导招募员
	[172558] = true, -- 艾拉·引路者
	[172572] = true, -- 瑟蕾丝特·贝利文科

	-- 其他
	[117871] = true, -- 军事顾问维多利亚
	[150122] = true, -- 荣耀堡法师
	[150131] = true, -- 萨尔玛法师
	[155101] = true, -- 元素精华融合器
	[155261] = true, -- 肖恩·维克斯，斯坦索姆
	[171589] = true, -- 德莱文将军
	[171787] = true, -- 文官阿得赖斯提斯
	[171795] = true, -- 月莓女勋爵
	[171821] = true, -- 德拉卡女男爵
	[173021] = true, -- 刻符牛头人
	[175513] = true, -- 纳斯利亚审判官，傲慢
}

local rogueClassHallInsignia = {
	[93188] = true, -- 墨戈 <采矿商人>
	[96782] = true, -- 鲁希安·提亚斯 <面包与奶酪商人>
	[97004] = true, -- “红发”杰克·芬德 <材料供应商>
}

local followerAssignees = {
	[135614] = true, -- 马迪亚斯·肖尔大师
	[138708] = true, -- 半兽人迦罗娜
}

local autoGossipTypes = {
	["taxi"] = true,
	["gossip"] = true,
	["banker"] = true,
	["vendor"] = true,
	["trainer"] = true,
}

QuickQuest:Register("GOSSIP_SHOW", function()
	local npcID = GetNPCID()
	if ignoreQuestNPC[npcID] then return end

	local active = C_GossipInfo_GetNumActiveQuests()
	if active > 0 then
		for index, questInfo in pairs(C_GossipInfo_GetActiveQuests()) do
			local questID = questInfo.questID
			local isWorldQuest = questID and C_QuestLog_IsWorldQuest(questID)
			if questInfo.isComplete and (not questID or not isWorldQuest) then
				C_GossipInfo_SelectActiveQuest(index)
			end
		end
	end

	local available = C_GossipInfo_GetNumAvailableQuests()
	if available > 0 then
		for index, questInfo in pairs(C_GossipInfo_GetAvailableQuests()) do
			local trivial = questInfo.isTrivial
			if not trivial or IsTrackingHidden() or (trivial and npcID == 64337) then
				C_GossipInfo_SelectAvailableQuest(index)
			end
		end
	end

	if rogueClassHallInsignia[npcID] then
		return C_GossipInfo_SelectOption(1)
	end

	if available == 0 and active == 0 then
		local numOptions = C_GossipInfo_GetNumOptions()
		if numOptions == 1 then
			if npcID == 57850 then
				return C_GossipInfo_SelectOption(1)
			end

			local _, instance, _, _, _, _, _, mapID = GetInstanceInfo()
			if instance ~= "raid" and not ignoreGossipNPC[npcID] and not (instance == "scenario" and mapID == 1626) then
				local gossipInfoTable = C_GossipInfo_GetOptions()
				local gType = gossipInfoTable[1] and gossipInfoTable[1].type
				if gType and autoGossipTypes[gType] then
					C_GossipInfo_SelectOption(1)
					return
				end
			end
		elseif followerAssignees[npcID] and numOptions > 1 then
			return C_GossipInfo_SelectOption(1)
		end
	end
end)

local darkmoonNPC = {
	[57850] = true, -- 传送技师弗兹尔巴布
	[55382] = true, -- 暗月马戏团秘法师 <部落>
	[54334] = true, -- 暗月马戏团秘法师 <联盟>
}

QuickQuest:Register("GOSSIP_CONFIRM", function(index)
	local npcID = GetNPCID()
	if npcID and darkmoonNPC[npcID] then
		C_GossipInfo_SelectOption(index, "", true)
		StaticPopup_Hide("GOSSIP_CONFIRM")
	end
end)

QuickQuest:Register("QUEST_DETAIL", function()
	if QuestIsFromAreaTrigger() then
		AcceptQuest()
	elseif QuestGetAutoAccept() then
		AcknowledgeAutoAcceptQuest()
	elseif not C_QuestLog_IsQuestTrivial(GetQuestID()) or IsTrackingHidden() then
		AcceptQuest()
	end
end)

QuickQuest:Register("QUEST_ACCEPT_CONFIRM", AcceptQuest)

QuickQuest:Register("QUEST_ACCEPTED", function()
	if QuestFrame:IsShown() and QuestGetAutoAccept() then
		CloseQuest()
	end
end)

QuickQuest:Register("QUEST_ITEM_UPDATE", function()
	if choiceQueue and QuickQuest[choiceQueue] then
		QuickQuest[choiceQueue]()
	end
end)

local itemBlacklist = {
	-- Inscription weapons
	[31690] = 79343, -- Inscribed Tiger Staff
	[31691] = 79340, -- Inscribed Crane Staff
	[31692] = 79341, -- Inscribed Serpent Staff

	-- Darkmoon Faire artifacts
	[29443] = 71635, -- Imbued Crystal
	[29444] = 71636, -- Monstrous Egg
	[29445] = 71637, -- Mysterious Grimoire
	[29446] = 71638, -- Ornate Weapon
	[29451] = 71715, -- A Treatise on Strategy
	[29456] = 71951, -- Banner of the Fallen
	[29457] = 71952, -- Captured Insignia
	[29458] = 71953, -- Fallen Adventurer's Journal
	[29464] = 71716, -- Soothsayer's Runes

	-- Tiller Gifts
	["progress_79264"] = 79264, -- Ruby Shard
	["progress_79265"] = 79265, -- Blue Feather
	["progress_79266"] = 79266, -- Jade Cat
	["progress_79267"] = 79267, -- Lovely Apple
	["progress_79268"] = 79268, -- Marsh Lily

	-- Garrison scouting missives
	["38180"] = 122424, -- Scouting Missive: Broken Precipice
	["38193"] = 122423, -- Scouting Missive: Broken Precipice
	["38182"] = 122418, -- Scouting Missive: Darktide Roost
	["38196"] = 122417, -- Scouting Missive: Darktide Roost
	["38179"] = 122400, -- Scouting Missive: Everbloom Wilds
	["38192"] = 122404, -- Scouting Missive: Everbloom Wilds
	["38194"] = 122420, -- Scouting Missive: Gorian Proving Grounds
	["38202"] = 122419, -- Scouting Missive: Gorian Proving Grounds
	["38178"] = 122402, -- Scouting Missive: Iron Siegeworks
	["38191"] = 122406, -- Scouting Missive: Iron Siegeworks
	["38184"] = 122413, -- Scouting Missive: Lost Veil Anzu
	["38198"] = 122414, -- Scouting Missive: Lost Veil Anzu
	["38177"] = 122403, -- Scouting Missive: Magnarok
	["38190"] = 122399, -- Scouting Missive: Magnarok
	["38181"] = 122421, -- Scouting Missive: Mok'gol Watchpost
	["38195"] = 122422, -- Scouting Missive: Mok'gol Watchpost
	["38185"] = 122411, -- Scouting Missive: Pillars of Fate
	["38199"] = 122409, -- Scouting Missive: Pillars of Fate
	["38187"] = 122412, -- Scouting Missive: Shattrath Harbor
	["38201"] = 122410, -- Scouting Missive: Shattrath Harbor
	["38186"] = 122408, -- Scouting Missive: Skettis
	["38200"] = 122407, -- Scouting Missive: Skettis
	["38183"] = 122416, -- Scouting Missive: Socrethar's Rise
	["38197"] = 122415, -- Scouting Missive: Socrethar's Rise
	["38176"] = 122405, -- Scouting Missive: Stonefury Cliffs
	["38189"] = 122401, -- Scouting Missive: Stonefury Cliffs

	-- Misc
	[31664] = 88604, -- Nat's Fishing Journal
}

QuickQuest:Register("QUEST_PROGRESS", function()
	if IsQuestCompletable() then
		local info = C_QuestLog_GetQuestTagInfo(GetQuestID())
		if info and (info.tagID == 153 or info.worldQuestType) then return end

		local npcID = GetNPCID()
		if ignoreQuestNPC[npcID] then return end

		local requiredItems = GetNumQuestItems()
		if requiredItems > 0 then
			for index = 1, requiredItems do
				local link = GetQuestItemLink("required", index)
				if link then
					local id = GetItemInfoFromHyperlink(link)
					for _, itemID in pairs(itemBlacklist) do
						if itemID == id then
							CloseQuest()
							return
						end
					end
				else
					choiceQueue = "QUEST_PROGRESS"
					GetQuestItemInfo("required", index)
					return
				end
			end
		end

		CompleteQuest()
	end
end)

local cashRewards = {
	[45724] = 1e5, -- Champion's Purse
	[64491] = 2e6, -- Royal Reward

	-- Items from the Sixtrigger brothers quest chain in Stormheim
	[138127] = 15, -- Mysterious Coin, 15 copper
	[138129] = 11, -- Swatch of Priceless Silk, 11 copper
	[138131] = 24, -- Magical Sprouting Beans, 24 copper
	[138123] = 15, -- Shiny Gold Nugget, 15 copper
	[138125] = 16, -- Crystal Clear Gemstone, 16 copper
	[138133] = 27, -- Elixir of Endless Wonder, 27 copper
}

QuickQuest:Register("QUEST_COMPLETE", function()
	-- Blingtron 6000 only!
	local npcID = GetNPCID()
	if npcID == 43929 or npcID == 77789 then return end

	local choices = GetNumQuestChoices()
	if choices <= 1 then
		GetQuestReward(1)
	elseif choices > 1 then
		local bestValue, bestIndex = 0

		for index = 1, choices do
			local link = GetQuestItemLink("choice", index)
			if link then
				local value = select(11, GetItemInfo(link))
				local itemID = GetItemInfoFromHyperlink(link)
				value = cashRewards[itemID] or value

				if value > bestValue then
					bestValue, bestIndex = value, index
				end
			else
				choiceQueue = "QUEST_COMPLETE"
				return GetQuestItemInfo("choice", index)
			end
		end

		local button = bestIndex and QuestInfoRewardsFrame.RewardButtons[bestIndex]
		if button then
			QuestInfoItem_OnClick(button)
		end
	end
end)

local function AttemptAutoComplete(event)
	if GetNumAutoQuestPopUps() > 0 then
		if UnitIsDeadOrGhost("player") then
			QuickQuest:Register("PLAYER_REGEN_ENABLED", AttemptAutoComplete)
			return
		end

		local questID, popUpType = GetAutoQuestPopUp(1)
		if not C_QuestLog_IsWorldQuest(questID) then
			if popUpType == "OFFER" then
				ShowQuestOffer(questID)
			elseif popUpType == "COMPLETE" then
				ShowQuestComplete(questID)
			end
		end
	end

	if event == "PLAYER_REGEN_ENABLED" then
		QuickQuest:UnregisterEvent(event)
	end
end
QuickQuest:Register("QUEST_LOG_UPDATE", AttemptAutoComplete)