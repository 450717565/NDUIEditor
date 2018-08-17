local B, C, L, DB = unpack(select(2, ...))

local function GetSavedInstances()
	local db = {
		["dungeons"] = {},
		["raids"] = {},
	}

	for i = 1, GetNumSavedInstances() do
		local name, id, _, difficulty, locked, extended, _, isRaid, maxPlayers, difficultyName, numEncounters, encounterProgress = GetSavedInstanceInfo(i)
		local instances = isRaid and db.raids or db.dungeons

		if instances[name] == nil then
			instances[name] = {}
		end

		if locked or extended then
			table.insert(instances[name], {
				["index"] = i,
				["name"] = name,
				["difficulty"] = difficulty,
				["locked"] = locked,
				["extended"] = extended,
				["isRaid"] = isRaid,
				["maxPlayers"] = maxPlayers,
				["difficultyName"] = difficultyName,
				["numEncounters"] = numEncounters,
				["encounterProgress"] = encounterProgress,
			})

			table.sort(instances[name], function(a, b)
				return a.difficulty < b.difficulty
			end)
		end
	end

	return db
end

local function GetSavedInstancesByDifficulty()
	local db = {}

	for i = 1, GetNumSavedInstances() do
		local name, id, _, difficulty, locked, extended = GetSavedInstanceInfo(i)

		if locked or extended then
			if db[name] == nil then
				db[name] = {}
			end

			db[name][difficulty] = {
				["index"] = i,
				["locked"] = locked,
				["extended"] = extended,
			}
		end
	end

	return db
end

local function GetNumSavedDBInstances(db, type)
	local size = 0

	for instanceName, instances in pairs(db[type]) do
		for difficulty, instance in pairs(instances) do
			if instance.locked or instance.extended then
				size = size + 1
			end
		end
	end

	return size
end

local function GetEncounterJournalInstanceTabs()
	if EncounterJournal ~= nil then
		return EncounterJournal.instanceSelect.dungeonsTab, EncounterJournal.instanceSelect.raidsTab
	end

	return nil, nil
end

local function GetEncounterJournalEncounterBossButtonKilledTexture(button)
	if button.killedTexture == nil then
		button.killedTexture = button:CreateTexture(nil, "OVERLAY")
		button.killedTexture:SetTexture("Interface\\EncounterJournal\\UI-EJ-HeroicTextIcon")
		button.killedTexture:SetPoint("RIGHT", -14, 0)
		button.killedTexture:SetAlpha(.75)
	end

	button.killedTexture:Hide()

	return button.killedTexture
end

local function GetSavedInstanceBossEncounterInfo(instanceIndex)
	local info = {}

	for i = 1, 32 do
		local bossName, _, isKilled, _ = GetSavedInstanceEncounterInfo(instanceIndex, i)

		if bossName ~= nil then
			info[string.gsub(bossName, "[·‧]", "")] = isKilled
		else
			break
		end
	end

	return info
end

local function HandleEncounterJournalScrollInstances(func)
	if EncounterJournal then
		table.foreach(EncounterJournal.instanceSelect.scroll.child, function(instanceButtonKey, instanceButton)
			if string.match(instanceButtonKey, "instance%d+") and type(instanceButton) == "table" then
				func(instanceButton)
			end
		end)
	end
end

local function ResetEncounterJournalScrollInstancesInfo()
	HandleEncounterJournalScrollInstances(function(instanceButton)
		if instanceButton.instanceInfoDifficulty == nil then
			instanceButton.instanceInfoDifficulty = B.CreateFS(instanceButton, 16, "", true, "BOTTOMLEFT", 9, 7)
			instanceButton.instanceInfoDifficulty:SetJustifyH("LEFT")
			instanceButton.instanceInfoDifficulty:SetWordWrap(true)
		end

		if instanceButton.instanceInfoEncounterProgress == nil then
			instanceButton.instanceInfoEncounterProgress = B.CreateFS(instanceButton, 16, "", true, "BOTTOMRIGHT", -9, 7)
			instanceButton.instanceInfoEncounterProgress:SetJustifyH("RIGHT")
			instanceButton.instanceInfoEncounterProgress:SetWordWrap(true)
		end

		instanceButton.instanceInfoDifficulty:Hide()
		instanceButton.instanceInfoEncounterProgress:Hide()
	end)
end

local function ResetEncounterJournalBossButtonKilledTexture()
	for i = 1, 32 do
		local button = _G["EncounterJournalBossButton" .. i]

		if button == nil then
			break
		end

		if button.killedTexture ~= nil then
			button.killedTexture:Hide()
		end
	end
end

local function RenderSavedInstancesInfo(savedDB)
	if EncounterJournal ~= nil then
		local scroll = EncounterJournal.instanceSelect.scroll

		if scroll.savedInstancesInfo == nil then
			scroll.savedInstancesInfo = B.CreateFS(scroll, 16, "", true, "BOTTOMRIGHT", -35, 7)
			scroll.savedInstancesInfo:SetJustifyH("RIGHT")
			scroll.savedInstancesInfo:SetWordWrap(true)
		end

		local dungeonsTab, raidsTab = GetEncounterJournalInstanceTabs()
		local currentInstanceType = (raidsTab ~= nil and not raidsTab:IsEnabled()) and "raids" or "dungeons"

		scroll.savedInstancesInfo:SetFormattedText(L["Sacve Instances Info"], _G[string.upper(currentInstanceType)], GetNumSavedDBInstances(savedDB, currentInstanceType))
	end
end

local function RenderInstanceInfo(instanceButton, savedInstance)
	local difficultyButton = instanceButton.instanceInfoDifficulty
	local encounterProgressButton = instanceButton.instanceInfoEncounterProgress
	local difficulty = ""
	local encounterProgress = ""

	table.foreach(savedInstance, function(index, instance)
		difficulty = difficulty .. "\n" .. instance.difficultyName
		encounterProgress = encounterProgress .. "\n" .. string.format("%s / %s", instance.encounterProgress, instance.numEncounters)
	end)

	if difficultyButton then
		difficultyButton:SetText(difficulty)
		difficultyButton:SetWidth(difficultyButton:GetStringWidth() * 1.25)
		difficultyButton:Show()
	end
	if encounterProgressButton then
		encounterProgressButton:SetText(encounterProgress)
		encounterProgressButton:SetWidth(encounterProgressButton:GetStringWidth() * 1.25)
		encounterProgressButton:Show()
	end
end

local function RenderEncounterJournalEncounterBossInfo(index)
	local info = GetSavedInstanceBossEncounterInfo(index)

	local n1

	table.foreach(info, function(name)
		if string.find(name, "怒風") then
			n1 = name
		end
	end)

	for i = 1, 32 do
		local button = _G["EncounterJournalBossButton" .. i]

		if button == nil then
			break
		end

		local texture = GetEncounterJournalEncounterBossButtonKilledTexture(button)

		if info[string.gsub(button:GetText(), "[·‧]", "")] then
			texture:Show()
		end
	end
end

local function RenderEncounterJournalEncounter(difficulty, name)
	local db = GetSavedInstancesByDifficulty()

	if db[name] ~= nil and db[name][difficulty] ~= nil then
		local info = db[name][difficulty]

		if info.locked or info.extended then
			RenderEncounterJournalEncounterBossInfo(info.index)
		end
	end
end

local function RenderEncounterJournalInstances()
	local savedDB = GetSavedInstances()
	local dungeonsTab, raidsTab = GetEncounterJournalInstanceTabs()
	local savedInstances = savedDB[(raidsTab ~= nil and not raidsTab:IsEnabled()) and "raids" or "dungeons"]

	RenderSavedInstancesInfo(savedDB)

	HandleEncounterJournalScrollInstances(function(instanceButton)
		local instanceName = EJ_GetInstanceInfo(instanceButton.instanceID)
		local savedInstance = savedInstances[instanceName]

		if savedInstance ~= nil then
			RenderInstanceInfo(instanceButton, savedInstance)
		end
	end)
end

local function EncounterJournalInstanceTab_OnClick()
	for _, tab in ipairs({ "dungeonsTab", "raidsTab" }) do
		EncounterJournal.instanceSelect[tab]:HookScript("OnClick", function(self, button, down)
			ResetEncounterJournalScrollInstancesInfo()
			RequestRaidInfo()
		end)
	end
end

local function EncounterJournalTierDropdown_OnSelect()
	hooksecurefunc("EJ_SelectTier", function()
		ResetEncounterJournalScrollInstancesInfo()
		RequestRaidInfo()
	end)
end

local function EncounterJournalEncounter_OnHook()
	hooksecurefunc("EncounterJournal_DisplayInstance", function()
		local difficulty = EJ_GetDifficulty()
		local name = EJ_GetInstanceInfo(EncounterJournal.instanceID)

		ResetEncounterJournalBossButtonKilledTexture()
		RenderEncounterJournalEncounter(difficulty, name)
	end)
end

function InstanceInfo_OnEvent(event, arg1)
	if event == "ADDON_LOADED" and arg1 == "Blizzard_EncounterJournal" then
		hooksecurefunc(EncounterJournal, "Show", function()
			local dungeonsTab, raidsTab = GetEncounterJournalInstanceTabs()
			local encounter = EncounterJournal.encounter

			if not dungeonsTab:IsEnabled() or not raidsTab:IsEnabled() or encounter:IsShown() then
				ResetEncounterJournalScrollInstancesInfo()
				RequestRaidInfo()
			end
		end)

		EncounterJournalEncounter_OnHook()
		EncounterJournalTierDropdown_OnSelect()
		EncounterJournalInstanceTab_OnClick()
	elseif event == "UPDATE_INSTANCE_INFO" then
		RenderEncounterJournalInstances()
	end
end

B:RegisterEvent("ADDON_LOADED", InstanceInfo_OnEvent)
B:RegisterEvent("UPDATE_INSTANCE_INFO", InstanceInfo_OnEvent)