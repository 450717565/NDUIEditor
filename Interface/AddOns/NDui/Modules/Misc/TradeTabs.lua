local _, ns = ...
local B, C, L, DB = unpack(ns)
local MISC = B:GetModule("Misc")

local pairs, unpack, tinsert, select = pairs, unpack, tinsert, select
local GetSpellCooldown, GetSpellInfo, GetItemCooldown, GetItemCount, GetItemInfo = GetSpellCooldown, GetSpellInfo, GetItemCooldown, GetItemCount, GetItemInfo
local IsPassiveSpell, IsCurrentSpell, IsPlayerSpell, UseItemByName = IsPassiveSpell, IsCurrentSpell, IsPlayerSpell, UseItemByName
local GetProfessions, GetProfessionInfo, GetSpellBookItemInfo = GetProfessions, GetProfessionInfo, GetSpellBookItemInfo
local PlayerHasToy, C_ToyBox_IsToyUsable, C_ToyBox_GetToyInfo = PlayerHasToy, C_ToyBox.IsToyUsable, C_ToyBox.GetToyInfo
local C_TradeSkillUI_GetRecipeInfo, C_TradeSkillUI_GetTradeSkillLine = C_TradeSkillUI.GetRecipeInfo, C_TradeSkillUI.GetTradeSkillLine
local C_TradeSkillUI_GetOnlyShowSkillUpRecipes, C_TradeSkillUI_SetOnlyShowSkillUpRecipes = C_TradeSkillUI.GetOnlyShowSkillUpRecipes, C_TradeSkillUI.SetOnlyShowSkillUpRecipes
local C_TradeSkillUI_GetOnlyShowMakeableRecipes, C_TradeSkillUI_SetOnlyShowMakeableRecipes = C_TradeSkillUI.GetOnlyShowMakeableRecipes, C_TradeSkillUI.SetOnlyShowMakeableRecipes
local cr, cg, cb = DB.cr, DB.cg, DB.cb

local BOOKTYPE_PROFESSION = BOOKTYPE_PROFESSION
local RUNEFORGING_ID = 53428
local PICK_LOCK = 1804
local CHEF_HAT = 134020
local THERMAL_ANVIL = 87216
local ENCHANTING_VELLUM = 38682
local tabList = {}

local onlyPrimary = {
	[171] = true, -- Alchemy
	[202] = true, -- Engineering
	[182] = true, -- Herbalism
	[393] = true, -- Skinning
	[356] = true, -- Fishing
}

function MISC:UpdateProfessions()
	local prof1, prof2, _, fish, cook = GetProfessions()
	local profs = {prof1, prof2, fish, cook}

	if DB.MyClass == "DEATHKNIGHT" then
		MISC:TradeTabs_Create(RUNEFORGING_ID)
	elseif DB.MyClass == "ROGUE" and IsPlayerSpell(PICK_LOCK) then
		MISC:TradeTabs_Create(PICK_LOCK)
	end

	local isCook
	for _, prof in pairs(profs) do
		local _, _, _, _, numSpells, spelloffset, skillLine = GetProfessionInfo(prof)
		if skillLine == 185 then isCook = true end

		numSpells = onlyPrimary[skillLine] and 1 or numSpells
		if numSpells > 0 then
			for i = 1, numSpells do
				local slotID = i + spelloffset
				if not IsPassiveSpell(slotID, BOOKTYPE_PROFESSION) then
					local spellID = select(2, GetSpellBookItemInfo(slotID, BOOKTYPE_PROFESSION))
					if i == 1 then
						MISC:TradeTabs_Create(spellID)
					else
						MISC:TradeTabs_Create(spellID)
					end
				end
			end
		end
	end

	if isCook and PlayerHasToy(CHEF_HAT) and C_ToyBox_IsToyUsable(CHEF_HAT) then
		MISC:TradeTabs_Create(nil, CHEF_HAT)
	end
	if GetItemCount(THERMAL_ANVIL) > 0 then
		MISC:TradeTabs_Create(nil, nil, THERMAL_ANVIL)
	end
end

function MISC:TradeTabs_Update()
	for _, tab in pairs(tabList) do
		local spellID = tab.spellID
		local itemID = tab.itemID

		if IsCurrentSpell(spellID) then
			tab:SetChecked(true)
			tab.cover:Show()
		else
			tab:SetChecked(false)
			tab.cover:Hide()
		end

		local start, duration
		if itemID then
			start, duration = GetItemCooldown(itemID)
		else
			start, duration = GetSpellCooldown(spellID)
		end
		if start and duration and duration > 1.5 then
			tab.CD:SetCooldown(start, duration)
		end
	end
end

function MISC:TradeTabs_Reskin()
	if not C.db["Skins"]["BlizzardSkins"] then return end

	for _, tab in pairs(tabList) do
		if tab and not tab.styled then
			B.ReskinSideTab(tab)

			tab.styled = true
		end
	end
end

local index = 1
function MISC:TradeTabs_Create(spellID, toyID, itemID)
	local name, _, texture
	if toyID then
		_, name, texture = C_ToyBox_GetToyInfo(toyID)
	elseif itemID then
		name, _, _, _, _, _, _, _, _, texture = GetItemInfo(itemID)
	else
		name, _, texture = GetSpellInfo(spellID)
	end

	local tab = CreateFrame("CheckButton", nil, TradeSkillFrame, "SpellBookSkillLineTabTemplate, SecureActionButtonTemplate")
	tab.tooltip = name
	tab.spellID = spellID
	tab.itemID = toyID or itemID
	tab.type = (toyID and "toy") or (itemID and "item") or "spell"
	if spellID == 818 then -- cooking fire
		tab:SetAttribute("type", "macro")
		tab:SetAttribute("macrotext", "/cast [@player]"..name)
	else
		tab:SetAttribute("type", tab.type)
		tab:SetAttribute(tab.type, spellID or name)
	end
	tab:SetNormalTexture(texture)
	tab:Show()

	tab.CD = CreateFrame("Cooldown", nil, tab, "CooldownFrameTemplate")
	tab.CD:SetAllPoints()

	tab.cover = B.CreateParentFrame(tab)
	tab.cover:EnableMouse(true)

	tab:SetPoint("TOPLEFT", TradeSkillFrame, "TOPRIGHT", 2, -index*40)
	tinsert(tabList, tab)
	index = index + 1
end

function MISC:TradeTabs_FilterIcons()
	local buttonList = {
		[1] = {"Atlas:bags-greenarrow", TRADESKILL_FILTER_HAS_SKILL_UP, C_TradeSkillUI_GetOnlyShowSkillUpRecipes, C_TradeSkillUI_SetOnlyShowSkillUpRecipes},
		[2] = {"Interface\\RAIDFRAME\\ReadyCheck-Ready", CRAFT_IS_MAKEABLE, C_TradeSkillUI_GetOnlyShowMakeableRecipes, C_TradeSkillUI_SetOnlyShowMakeableRecipes},
	}

	local function filterClick(self)
		local value = self.__value
		if value[3]() then
			value[4](false)
			self.icbg:SetBackdropBorderColor(0, 0, 0)
		else
			value[4](true)
			self.icbg:SetBackdropBorderColor(cr, cg, cb)
		end
	end

	local buttons = {}
	for index, value in pairs(buttonList) do
		local bu = CreateFrame("Button", nil, TradeSkillFrame)
		bu:SetSize(22, 22)
		bu:SetPoint("RIGHT", TradeSkillFrame.FilterButton, "LEFT", -5 - (index-1)*27, 0)
		B.PixelIcon(bu, value[1], true)
		B.AddTooltip(bu, "ANCHOR_TOP", value[2])
		bu.__value = value
		bu:SetScript("OnClick", filterClick)

		buttons[index] = bu
	end

	local function updateFilterStatus()
		for index, value in pairs(buttonList) do
			if value[3]() then
				buttons[index].icbg:SetBackdropBorderColor(cr, cg, cb)
			else
				buttons[index].icbg:SetBackdropBorderColor(0, 0, 0)
			end
		end
	end
	B:RegisterEvent("TRADE_SKILL_LIST_UPDATE", updateFilterStatus)
end

function MISC:TradeTabs_OnLoad()
	MISC:UpdateProfessions()

	MISC:TradeTabs_Update()
	B:RegisterEvent("TRADE_SKILL_SHOW", MISC.TradeTabs_Update)
	B:RegisterEvent("TRADE_SKILL_CLOSE", MISC.TradeTabs_Update)
	B:RegisterEvent("CURRENT_SPELL_CAST_CHANGED", MISC.TradeTabs_Update)

	MISC:TradeTabs_FilterIcons()
	MISC:TradeTabs_QuickEnchanting()

	MISC:TradeTabs_Reskin()
end

function MISC.TradeTabs_OnEvent(event, addon)
	if event == "ADDON_LOADED" and addon == "Blizzard_TradeSkillUI" then
		B:UnregisterEvent(event, MISC.TradeTabs_OnEvent)

		if InCombatLockdown() then
			B:RegisterEvent("PLAYER_REGEN_ENABLED", MISC.TradeTabs_OnEvent)
		else
			MISC:TradeTabs_OnLoad()
		end
	elseif event == "PLAYER_REGEN_ENABLED" then
		B:UnregisterEvent(event, MISC.TradeTabs_OnEvent)
		MISC:TradeTabs_OnLoad()
	end
end

local isEnchanting
local tooltipString = "|cffffffff%s(%d)"
local function IsRecipeEnchanting(self)
	isEnchanting = nil

	local recipeID = self.selectedRecipeID
	local recipeInfo = recipeID and C_TradeSkillUI_GetRecipeInfo(recipeID)
	if recipeInfo and recipeInfo.alternateVerb then
		local parentSkillLineID = select(6, C_TradeSkillUI_GetTradeSkillLine())
		if parentSkillLineID == 333 then
			isEnchanting = true
			self.CreateButton.tooltip = format(tooltipString, L["UseVellum"], GetItemCount(ENCHANTING_VELLUM))
		end
	end
end

function MISC:TradeTabs_QuickEnchanting()
	if not TradeSkillFrame then return end

	local detailsFrame = TradeSkillFrame.DetailsFrame
	hooksecurefunc(detailsFrame, "RefreshDisplay", IsRecipeEnchanting)

	local createButton = detailsFrame.CreateButton
	createButton:RegisterForClicks("AnyUp")
	createButton:HookScript("OnClick", function(_, btn)
		if btn == "RightButton" and isEnchanting then
			UseItemByName(ENCHANTING_VELLUM)
		end
	end)
end

function MISC:TradeTabs()
	if not C.db["Misc"]["TradeTabs"] then return end

	B:RegisterEvent("ADDON_LOADED", MISC.TradeTabs_OnEvent)
end
MISC:RegisterMisc("TradeTabs", MISC.TradeTabs)