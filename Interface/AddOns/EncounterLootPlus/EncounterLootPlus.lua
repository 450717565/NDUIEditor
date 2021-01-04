local addonName, ELP = ...

ELP.CURRENT_TIER = 9 --GetServerExpansionLevel() + 1 + 1 --8.0时接口返回7, 前夕再加1 --abyuiPW
ELP.RING_SLOT = Enum.ItemSlotFilterType.Finger
ELP.ALL_SLOT = Enum.ItemSlotFilterType.NoFilter

if not ELP.LAST_RAID_IDX then
	EJ_SelectTier(ELP.CURRENT_TIER)
	for i=1,20 do
		local _, name = EJ_GetInstanceByIndex(i, true)
		if not name then break end
		ELP.LAST_RAID_IDX, ELP.LAST_RAID_NAME = i, name
	end
end

local db = {
	range = 0,
	attr1 = 0,
	attr2 = 0,
	ITEMS = {},
}

ELP.db = db

ELP.frame = CreateFrame("Frame")
ELP.frame:RegisterEvent("ADDON_LOADED")
ELP.frame:SetScript("OnEvent", function(self, _, addon)
	if addon == addonName then
		if ELPDATA then
			local newVersion = GetAddOnMetadata("163UI_EncounterLootPlus", "X-DataVersion")
			local oldVersion = ELPDATA.dataVersion
			if oldVersion == newVersion then
				-- 使用之前保存的ITEM信息
				wipe(db)
				ELP.copy(ELPDATA, db)
			else
				-- 使用默认的空数据
				db.dataVersion = newVersion
			end
		end
		ELPDATA = db

		db.ITEMS = db.ITEMS or {}
		db.range = 0
	end

	if addon == "Blizzard_EncounterJournal" then
		hooksecurefunc("EJTierDropDown_Initialize", function(_, level)
			if not level then return end
			local listFrame = _G["DropDownList"..level];
			local expId = ELP.CURRENT_TIER
			if listFrame.numButtons >= expId then return end
			local info = UIDropDownMenu_CreateInfo();
			info.text = EJ_GetTierInfo(expId);
			info.func = EncounterJournal_TierDropDown_Select
			info.checked = expId == EJ_GetCurrentTier;
			info.arg1 = expId;
			UIDropDownMenu_AddButton(info, 1)
		end)

		local btn = CreateFrame("Button", "ELPShortcut", EncounterJournalInstanceSelect, "UIMenuButtonStretchTemplate")
		btn:SetSize(120, 32)
		btn:SetPoint("BOTTOMLEFT", EncounterJournalInstanceSelectLootJournalTab, "BOTTOMRIGHT", 24, 0)
		btn.Text:SetText("爱不易装备搜索")
		btn:SetScript("OnClick", function()
			if db.range == 0 then db.range = 5 end
			EncounterJournal_DisplayInstance(1187)
			EncounterJournalEncounterFrameInfoLootTab:Click()
			EncounterJournalEncounterFrameInfoLootScrollFrameFilterToggle:Click()
		end)

		ELP.initMenus()
		ELP.initScroll()

		if IsAddOnLoaded("NDui") then
			local B, C, L, DB = unpack(_G.NDui)
			B.ReskinButton(btn)
			btn.Text:SetFont(DB.Font[1], 14, DB.Font[3])
			btn.Text:SetPoint("CENTER", 1, 0)
			btn.Text:SetTextColor(DB.r, DB.g, DB.b)

			hooksecurefunc("EncounterJournal_SetLootButton", function(item)
				if item.instance then
					item.instance:SetTextColor(1, 1, 1)
					item.instance:ClearAllPoints()
					item.instance:SetPoint("TOPRIGHT", item.armorType, "BOTTOMRIGHT", 0, -6)
				end
			end)
		elseif IsAddOnLoaded("ElvUI") then
			local E, L, V, P, G = unpack(_G.ElvUI)
			local S = E:GetModule('Skins')
			local InstanceSelect = EncounterJournal.instanceSelect

			E:Delay(.5, function()
				for _, tabName in pairs({"suggestTab", "dungeonsTab", "raidsTab", "LootJournalTab"}) do
					local tab = InstanceSelect[tabName]
					tab:SetWidth(110)
				end
			end)

			S:HandleBlizzardRegions(btn)
			S:HandleTab(btn)
			btn:SetHitRectInsets(0, 0, 0, 0)
			btn:SetHeight(32)
			btn:ClearAllPoints()
			btn:Point('BOTTOMLEFT', InstanceSelect.LootJournalTab, 'BOTTOMRIGHT', 2, 0)
			btn.Text:FontTemplate()
			btn.Text:Point('CENTER')

			hooksecurefunc("EncounterJournal_SetLootButton", function(item)
				if item.instance then
					item.instance:SetTextColor(1, 1, 1)
				end
			end)
		end

		self:SetScript("OnUpdate", ELP.RetrieveNext)
	end
end)

local hooks = {}
function ELP.Hook(name, func)
	hooks[name] = _G[name]
	_G[name] = func
end

function ELP.RunHooked(name, ...)
	return hooks[name](...)
end

_G.ELP = ELP