﻿local _, ns = ...
local B, C, L, DB = unpack(ns)
if not C.Infobar.Spec then return end

local Infobar = B:GetModule("Infobar")
local info = Infobar:RegisterInfobar("Spec", C.Infobar.SpecPos)

local format, wipe, select, next = string.format, table.wipe, select, next
local SPECIALIZATION, TALENTS_BUTTON, MAX_TALENT_TIERS = SPECIALIZATION, TALENTS_BUTTON, MAX_TALENT_TIERS
local PVP_TALENTS, LOOT_SPECIALIZATION_DEFAULT = PVP_TALENTS, LOOT_SPECIALIZATION_DEFAULT
local GetSpecialization, GetSpecializationInfo, GetLootSpecialization, GetSpecializationInfoByID = GetSpecialization, GetSpecializationInfo, GetLootSpecialization, GetSpecializationInfoByID
local GetTalentInfo, GetPvpTalentInfoByID, SetLootSpecialization, SetSpecialization = GetTalentInfo, GetPvpTalentInfoByID, SetLootSpecialization, SetSpecialization
local C_SpecializationInfo_GetAllSelectedPvpTalentIDs = C_SpecializationInfo.GetAllSelectedPvpTalentIDs
local C_SpecializationInfo_CanPlayerUsePVPTalentUI = C_SpecializationInfo.CanPlayerUsePVPTalentUI

local function addIcon(texture, isMain)
	local h, y = 13, 0
	if isMain then h, y = 15, -1 end

	texture = texture and format("|T%s:%s:15:0:%s:50:50:4:46:4:46|t", texture, h, y) or ""
	return texture
end

local menuList = {
	{text = CHOOSE_SPECIALIZATION, isTitle = true, notCheckable = true},
	{text = SPECIALIZATION, hasArrow = true, notCheckable = true},
	{text = SELECT_LOOT_SPECIALIZATION, hasArrow = true, notCheckable = true},
}

info.eventList = {
	"PLAYER_ENTERING_WORLD",
	"ACTIVE_TALENT_GROUP_CHANGED",
	"PLAYER_LOOT_SPEC_UPDATED",
}

info.onEvent = function(self)
	local specIndex = GetSpecialization()
	if specIndex then
		local _, name, _, icon = GetSpecializationInfo(specIndex)
		if not name then return end
		local specID = GetLootSpecialization()
		if specID == 0 then
			icon = addIcon(icon, true)
		else
			icon = addIcon(select(4, GetSpecializationInfoByID(specID)), true)
		end
		self.text:SetFormattedText("%s%s", DB.MyColor..name.."|r", icon)
	else
		self.text:SetFormattedText("%s%s", DB.MyColor..NONE.."|r", SPECIALIZATION)
	end
end

local pvpTalents
local pvpIconTexture = C_CurrencyInfo.GetCurrencyInfo(104).iconFileID

info.onEnter = function(self)
	local specIndex = GetSpecialization()
	if not specIndex or specIndex == 5 then return end

	GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 15)
	GameTooltip:ClearLines()
	GameTooltip:AddLine(TALENTS_BUTTON, 0,.6,1)
	GameTooltip:AddLine(" ")

	local _, specName, _, specIcon = GetSpecializationInfo(specIndex)
	GameTooltip:AddDoubleLine(addIcon(specIcon).." "..specName, " ", .6,.8,1, 1,1,1)

	for t = 1, MAX_TALENT_TIERS do
		for c = 1, 3 do
			local _, name, icon, selected = GetTalentInfo(t, c, 1)
			if selected then
				GameTooltip:AddDoubleLine(" ", name.." "..addIcon(icon), 1,1,1, 1,1,1)
			end
		end
	end

	if C_SpecializationInfo_CanPlayerUsePVPTalentUI() then
		pvpTalents = C_SpecializationInfo_GetAllSelectedPvpTalentIDs()

		if #pvpTalents > 0 then
			GameTooltip:AddLine(" ")
			GameTooltip:AddDoubleLine(addIcon(pvpIconTexture).." "..PVP_TALENTS, " ", .6,.8,1, 1,1,1)
			for _, talentID in next, pvpTalents do
				local _, name, icon, _, _, _, unlocked = GetPvpTalentInfoByID(talentID)
				if name and unlocked then
					GameTooltip:AddDoubleLine(" ", name.." "..addIcon(icon), 1,1,1, 1,1,1)
				end
			end
		end

		wipe(pvpTalents)
	end

	GameTooltip:AddDoubleLine(" ", DB.LineString)
	GameTooltip:AddDoubleLine(" ", DB.LeftButton..L["SpecPanel"].." ", 1,1,1, .6,.8,1)
	GameTooltip:AddDoubleLine(" ", DB.RightButton..L["Change Spec"].." ", 1,1,1, .6,.8,1)
	GameTooltip:Show()
end

info.onLeave = B.HideTooltip

local function clickFunc(i, isLoot)
	if not i then return end
	if isLoot then
		SetLootSpecialization(i)
	else
		SetSpecialization(i)
	end
	DropDownList1:Hide()
end

info.onMouseUp = function(self, btn)
	local specIndex = GetSpecialization()
	if not specIndex or specIndex == 5 then return end

	if btn == "LeftButton" then
		if InCombatLockdown() then UIErrorsFrame:AddMessage(DB.InfoColor..ERR_NOT_IN_COMBAT) return end
		ToggleTalentFrame(2)
	else
		menuList[2].menuList = {{}, {}, {}, {}}
		menuList[3].menuList = {{}, {}, {}, {}, {}}
		local specList, lootList = menuList[2].menuList, menuList[3].menuList
		local spec, specName = GetSpecializationInfo(specIndex)
		local lootSpec = GetLootSpecialization()
		lootList[1] = {text = format(LOOT_SPECIALIZATION_DEFAULT, specName), func = function() clickFunc(0, true) end, checked = lootSpec == 0 and true or false}

		for i = 1, 4 do
			local id, name = GetSpecializationInfo(i)
			if id then
				specList[i].text = name
				if id == spec then
					specList[i].func = function() clickFunc() end
					specList[i].checked = true
				else
					specList[i].func = function() clickFunc(i) end
					specList[i].checked = false
				end
				lootList[i+1] = {text = name, func = function() clickFunc(id, true) end, checked = id == lootSpec and true or false}
			else
				specList[i] = nil
				lootList[i+1] = nil
			end
		end

		EasyMenu(menuList, B.EasyMenu, self, -80, 100, "MENU", 1)
		GameTooltip:Hide()
	end
end