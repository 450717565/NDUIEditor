local _, ns = ...
local B, C, L, DB = unpack(ns)

local BUTTON = "ActionButton%d"
local MESSAGE = "狂按 <空格> 完成!"

local Handler = CreateFrame("Frame")
function Handler:Message()
	for i = 1, 2 do
		RaidNotice_AddMessage(RaidWarningFrame, MESSAGE, ChatTypeInfo.RAID_WARNING)
	end
end

-- 世界任务：候选者训练
do
	local actionMessages = {}
	local actionResetSpells = {}
	local spells = {
		[321842] = {
			[321843] = 1, -- Strike
			[321844] = 2, -- Sweep
			[321847] = 3, -- Parry
		},
		[341925] = {
			[341931] = 1, -- Slash
			[341928] = 2, -- Bash
			[341929] = 3, -- Block
		},
		[341985] = {
			[342000] = 1, -- Jab
			[342001] = 2, -- Kick
			[342002] = 3, -- Dodge
		},
	}

	local trainerName = "训练师伊卡洛斯"

	local function auraFilter(a, _, _, _, _, _, _, _, _, _, _, _, b)
		return a == b
	end

	Handler:RegisterEvent("QUEST_LOG_UPDATE")
	Handler:RegisterEvent("QUEST_ACCEPTED")
	Handler:SetScript("OnEvent", function(self, event, ...)
		if event == "QUEST_LOG_UPDATE" then
			if C_QuestLog.IsOnQuest(59585) then
				self:Watch()
			else
				self:Unwatch()
			end
		elseif event == "QUEST_ACCEPTED" then
			local questID = ...
			if questID == 59585 then
				self:Watch()
			end
		elseif event == "QUEST_REMOVED" then
			local questID = ...
			if questID == 59585 then
				self:Unwatch()
			end
		elseif event == "UNIT_AURA" then
			for buff, spellSet in next, spells do
				if AuraUtil.FindAura(auraFilter, "player", "HELPFUL", buff) then
					self:Control(spellSet)
					return
				else
					self:Uncontrol()
				end
			end
		elseif event == "CHAT_MSG_MONSTER_SAY" then
			local msg, sender = ...
			if sender == trainerName then -- Trainer Ikaros
				for spell, actionID in pairs (actionMessages) do
					if strmatch(msg, spell) then
						C_Timer.After(0.1, function()
							-- wait a split second to get "Perfect"
							ClearOverrideBindings(self)
							SetOverrideBinding(self, true, "SPACE", BUTTON:format(actionID))
						end)
						break
					end
				end
			end
		elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
			local _, _, spellID = ...
			if actionResetSpells[spellID] then
				ClearOverrideBindings(self)

				-- bind to something useless to avoid spamming jump
				SetOverrideBinding(self, true, "SPACE", BUTTON:format(12))
			end
		elseif event == "PLAYER_REGEN_ENABLED" then
			ClearOverrideBindings(self)
			self:UnregisterEvent(event)
		end
	end)

	function Handler:Watch()
		self:RegisterUnitEvent("UNIT_AURA", "player")
		self:RegisterEvent("QUEST_REMOVED")
	end

	function Handler:Unwatch()
		self:UnregisterEvent("UNIT_AURA")
		self:UnregisterEvent("QUEST_REMOVED")
		self:Uncontrol()
	end

	function Handler:Control(spellSet)
		table.wipe(actionMessages)
		table.wipe(actionResetSpells)
		for spellID, actionIndex in next, spellSet do
			actionMessages[(GetSpellInfo(spellID))] = actionIndex
			actionResetSpells[spellID] = true

			if spellID == 321844 then
				actionMessages["低扫"] = actionIndex -- zhCN fix
			end
		end

		-- bind to something useless to avoid spamming jump
		SetOverrideBinding(self, true, "SPACE", BUTTON:format(12))

		self:Message()

		self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")
		self:RegisterEvent("CHAT_MSG_MONSTER_SAY")
	end

	function Handler:Uncontrol()
		self:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
		self:UnregisterEvent("CHAT_MSG_MONSTER_SAY")

		if InCombatLockdown() then
			self:RegisterEvent("PLAYER_REGEN_ENABLED")
		else
			ClearOverrideBindings(self)
		end
	end
end

-- 世界任务：万能执事者
do
	local HBD = LibStub("HereBeDragons-2.0")

	local BASTION = 1533
	local coordinateToHelper = {
		[169022] = {{0.5291, 0.4579}},
		[169023] = {{0.5306, 0.4750}},
		[169024] = {{0.5263, 0.4617}, {0.5258, 0.4660}},
		[169025] = {{0.5199, 0.4846}, {0.5265, 0.4744}},
		[169026] = {{0.5251, 0.4877}, {0.5182, 0.4540}},
		[169027] = {{0.5333, 0.4701}},
	}

	local function getClosestQuestNPC()
		local closestNPC
		local closestDistance = math.huge

		local pos = C_Map.GetPlayerMapPosition(BASTION, "player")
		if not pos then
			return
		end

		local playerX, playerY = pos:GetXY()
		for npcID, data in next, coordinateToHelper do
			for _, coords in next, data do
				local distance = HBD:GetZoneDistance(BASTION, playerX, playerY, BASTION, coords[1], coords[2])
				if distance < closestDistance then
					closestNPC = npcID
					closestDistance = distance
				end
			end
		end

		return closestNPC
	end

	Handler:RegisterEvent("QUEST_LOG_UPDATE")
	Handler:RegisterEvent("QUEST_ACCEPTED")
	Handler:SetScript("OnEvent", function(self, event, ...)
		if event == "QUEST_LOG_UPDATE" then
			if C_QuestLog.IsOnQuest(60565) then
				self:Watch()
			end
		elseif event == "QUEST_ACCEPTED" then
			local questID = ...
			if questID == 60565 then
				self:Watch()
			end
		elseif event == "QUEST_REMOVED" then
			local questID = ...
			if questID == 60565 then
				self:Unwatch()
			end
		elseif event == "UPDATE_MOUSEOVER_UNIT" then
			local unitGUID = UnitGUID("mouseover")
			if unitGUID then
				local closestQuestNPC = getClosestQuestNPC()
				if closestQuestNPC then
					if GetNPCID(unitGUID) == closestQuestNPC and GetRaidTargetIndex("mouseover") ~= 4 then
						SetRaidTarget("mouseover", 4)
					end
				end
			end
		end
	end)

	function Handler:Watch()
		self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
		self:RegisterEvent("QUEST_REMOVED")
	end

	function Handler:Unwatch()
		self:UnregisterEvent("UPDATE_MOUSEOVER_UNIT")
		self:UnregisterEvent("QUEST_REMOVED")
	end
end

-- 世界任务：乌合之众
do
	Handler:RegisterEvent("QUEST_LOG_UPDATE")
	Handler:RegisterEvent("QUEST_ACCEPTED")
	Handler:SetScript("OnEvent", function(self, event, ...)
		if event == "QUEST_LOG_UPDATE" then
			if C_QuestLog.IsOnQuest(60739) then
				self:Watch()
			end
		elseif event == "QUEST_ACCEPTED" then
			local questID = ...
			if questID == 60739 then
				self:Watch()
			end
		elseif event == "QUEST_REMOVED" then
			local questID = ...
			if questID == 60739 then
				self:Unwatch()
			end
		elseif event == "UPDATE_MOUSEOVER_UNIT" then
			local unitGUID = UnitGUID("mouseover")
			if unitGUID then
				if B.GetNPCID(unitGUID) == 170080 and GetRaidTargetIndex("mouseover") ~= 8 then
					SetRaidTarget("mouseover", 8)
				end
			end
		end
	end)

	function Handler:Watch()
		self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
		self:RegisterEvent("QUEST_REMOVED")
	end

	function Handler:Unwatch()
		self:UnregisterEvent("UPDATE_MOUSEOVER_UNIT")
		self:UnregisterEvent("QUEST_REMOVED")
	end
end

-- 日常：踏向未知
do
	local gormJuiceStage
	local correctFairies = {
		[174770] = true,
		[174498] = true,
		[174771] = true,
		[174499] = true,
	}

	-- handles talking for the daily quest "Into the Unknown"
	Handler:RegisterEvent("GOSSIP_SHOW")
	Handler:SetScript("OnEvent", function(self)
		if IsShiftKeyDown() then
			return
		end

		local npcID = GetNPCID(UnitGUID("npc"))
		if npcID == 174365 then
			-- Guess the correct word in sentence, we always pick option 2 because it"s easy, she
			-- will just keep asking for the correct one if you make a mistake
			if C_GossipInfo.GetNumOptions() == 1 then
				C_GossipInfo.SelectOption(1)
			else
				C_GossipInfo.SelectOption(2)
			end
		elseif npcID == 174371 then
			-- Mixy Mak, you ask her if the _can_ create something, then ask her to create it
			if not gormJuiceStage then
				C_GossipInfo.SelectOption(2)
			elseif gormJuiceStage == 1 then
				C_GossipInfo.SelectOption(C_GossipInfo.GetNumOptions())
			end

			gormJuiceStage = (gormJuiceStage or 0) + 1
		elseif correctFairies[npcID] then
			-- Guess the correct drunk faerie, they"re all correct
			C_GossipInfo.SelectOption(3)
		end
	end)
end

-- 稀有精英：逃跑的荒蚺
do
	local RARE = "逃跑的荒蚺"

	Handler:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	Handler:RegisterEvent("PLAYER_ENTERING_WORLD")
	Handler:SetScript("OnEvent", function(self, event, ...)
		if event == "ZONE_CHANGED_NEW_AREA" or event == "PLAYER_ENTERING_WORLD" then
			local mapID = C_Map.GetBestMapForUnit("player")
			if mapID and mapID == 1961 then
				self:Watch()
			else
				self:Unwatch()
			end
		elseif event == "UNIT_ENTERED_VEHICLE" then
			if GetPlayerAuraBySpellID(356137) then
				self:Control()
			else
				self:Uncontrol()
			end
		elseif event == "UNIT_EXITED_VEHICLE" then
			self:Uncontrol()
		elseif event == "CHAT_MSG_RAID_BOSS_EMOTE" then
			local msg = ...
			if strfind(msg, RARE) then
				ClearOverrideBindings(self)
				SetOverrideBinding(self, true, "SPACE", BUTTON:format(1))
			end
		elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
			local _, _, spellID = ...
			if spellID == 356151 then
				ClearOverrideBindings(self)
				SetOverrideBinding(self, true, "SPACE", BUTTON:format(12))
			end
		end
	end)

	function Handler:Watch()
		self:RegisterEvent("UNIT_ENTERED_VEHICLE")
	end

	function Handler:Unwatch()
		self:UnregisterEvent("UNIT_ENTERED_VEHICLE")
	end

	function Handler:Control()
		self:Message()

		self:RegisterEvent("UNIT_EXITED_VEHICLE")
		self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
		self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")
	end

	function Handler:Uncontrol()
		self:UnregisterEvent("UNIT_EXITED_VEHICLE")
		self:UnregisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
		self:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")

		ClearOverrideBindings(self)
	end
end