local B, C, L, DB = unpack(select(2, ...))
local module = NDui:GetModule("Skins")

local buttonList = {}
local cr, cg, cb = 0, 0, 0

local function CreateMicroButton(parent, data)
	if NDuiDB["Skins"]["ClassLine"] then cr, cg, cb = DB.ClassColor.r, DB.ClassColor.g, DB.ClassColor.b end

	local texture, onside, tip, func = unpack(data)
	local width, offset = 24, 0
	if onside then width, offset = 35, 6 end

	local bu = CreateFrame("Button", nil, parent)
	tinsert(buttonList, bu)
	bu:SetSize(width, 20)
	bu:SetFrameStrata("BACKGROUND")
	B.CreateGT(bu, "ANCHOR_TOP", tip)

	local icon = bu:CreateTexture(nil, "ARTWORK")
	icon:SetPoint("CENTER", offset, 0)
	icon:SetSize(50, 50)
	icon:SetTexture(DB.MicroTex..texture)
	icon:SetVertexColor(cr, cg, cb)

	local bg = B.CreateBG(bu, 0)
	bg:SetPoint("TOPLEFT", 1, 0)
	bg:SetPoint("BOTTOMRIGHT", -1, 0)
	B.CreateBD(bg)
	bg:Hide()
	bg:SetBackdropColor(cr, cg, cb, .5)
	bg:SetBackdropBorderColor(cr, cg, cb)
	bu:HookScript("OnEnter", function() bg:Show() end)
	bu:HookScript("OnLeave", function() bg:Hide() end)
	bu:SetScript("OnClick", func)
end

function module:MicroMenu()
	-- Taint Fix
	ToggleAllBags()
	ToggleAllBags()
	ToggleFrame(SpellBookFrame)
	ToggleFrame(SpellBookFrame)

	if not NDuiDB["Skins"]["MicroMenu"] then return end

	local faction = UnitFactionGroup("player")
	local menubar = CreateFrame("Frame", nil, UIParent)
	menubar:SetSize(384, 20)
	B.Mover(menubar, L["Menubar"], "Menubar", C.Skins.MicroMenuPos)

	-- Generate Buttons
	local buttonInfo = {
		{"player", true, MicroButtonTooltipText(CHARACTER_BUTTON, "TOGGLECHARACTER0"), function() ToggleFrame(CharacterFrame) end},
		{"spellbook", false, MicroButtonTooltipText(SPELLBOOK_ABILITIES_BUTTON, "TOGGLESPELLBOOK"), function() ToggleFrame(SpellBookFrame) end},
		{"talents", false, MicroButtonTooltipText(TALENTS_BUTTON, "TOGGLETALENTS"), function()
			if not PlayerTalentFrame then LoadAddOn("Blizzard_TalentUI") end
			if UnitLevel("player") < SHOW_SPEC_LEVEL then
				UIErrorsFrame:AddMessage(DB.InfoColor..format(FEATURE_BECOMES_AVAILABLE_AT_LEVEL, SHOW_SPEC_LEVEL))
			else
				ToggleFrame(PlayerTalentFrame)
			end
		end},
		{"achievements", false, MicroButtonTooltipText(ACHIEVEMENT_BUTTON, "TOGGLEACHIEVEMENT"), function() ToggleAchievementFrame() end},
		{"quests", false, MicroButtonTooltipText(QUESTLOG_BUTTON, "TOGGLEQUESTLOG"), function() ToggleFrame(WorldMapFrame) end},
		{"guild", false, IsInGuild() and MicroButtonTooltipText(GUILD, "TOGGLEGUILDTAB") or MicroButtonTooltipText(LOOKINGFORGUILD, "TOGGLEGUILDTAB"), function()
			if IsTrialAccount() then
				UIErrorsFrame:AddMessage(DB.InfoColor..ERR_GUILD_TRIAL_ACCOUNT_TRIAL)
			elseif faction == "Neutral" then
				UIErrorsFrame:AddMessage(DB.InfoColor..FEATURE_NOT_AVAILBLE_PANDAREN)
			elseif IsInGuild() then
				if not GuildFrame then LoadAddOn("Blizzard_GuildUI") end
				ToggleFrame(GuildFrame)
			else
				ToggleGuildFinder()
			end
		end},
		{"pvp", false, MicroButtonTooltipText(PLAYER_V_PLAYER, "TOGGLECHARACTER4"), function()
			if faction == "Neutral" then
				UIErrorsFrame:AddMessage(DB.InfoColor..FEATURE_NOT_AVAILBLE_PANDAREN)
			elseif UnitLevel("player") < LFDMicroButton.minLevel then
				UIErrorsFrame:AddMessage(DB.InfoColor..format(FEATURE_BECOMES_AVAILABLE_AT_LEVEL, LFDMicroButton.minLevel))
			else
				TogglePVPUI()
			end
		end},
		{"LFD", false, MicroButtonTooltipText(DUNGEONS_BUTTON, "TOGGLEGROUPFINDER"), function()
			if faction == "Neutral" then
				UIErrorsFrame:AddMessage(DB.InfoColor..FEATURE_NOT_AVAILBLE_PANDAREN)
			elseif UnitLevel("player") < LFDMicroButton.minLevel then
				UIErrorsFrame:AddMessage(DB.InfoColor..format(FEATURE_BECOMES_AVAILABLE_AT_LEVEL, LFDMicroButton.minLevel))
			else
				PVEFrame_ToggleFrame()
			end
		end},
		{"encounter", false, MicroButtonTooltipText(ADVENTURE_JOURNAL, "TOGGLEENCOUNTERJOURNAL"), function() ToggleEncounterJournal() end},
		{"pets", false, MicroButtonTooltipText(COLLECTIONS, "TOGGLECOLLECTIONS"), function()
			if InCombatLockdown() and not IsAddOnLoaded("Blizzard_Collections") then
				UIErrorsFrame:AddMessage(DB.InfoColor..ERR_POTION_COOLDOWN)
			else
				ToggleCollectionsJournal()
			end
		end},
		{"store", false, BLIZZARD_STORE, function()
			if IsTrialAccount() then
				UIErrorsFrame:AddMessage(DB.InfoColor..ERR_GUILD_TRIAL_ACCOUNT)
			elseif C_StorePublic.IsDisabledByParentalControls() then
				UIErrorsFrame:AddMessage(DB.InfoColor..BLIZZARD_STORE_ERROR_PARENTAL_CONTROLS)
			else
				ToggleStoreUI()
			end
		end},
		{"gm", false, HELP_BUTTON, function() ToggleFrame(HelpFrame) end},
		{"settings", false, MicroButtonTooltipText(MAINMENU_BUTTON, "TOGGLEGAMEMENU"), function() ToggleFrame(GameMenuFrame) PlaySound(SOUNDKIT.IG_MINIMAP_OPEN) end},
		{"bags", true, MicroButtonTooltipText(BAGSLOT, "OPENALLBAGS"), function() ToggleAllBags() end},
	}
	for _, info in pairs(buttonInfo) do CreateMicroButton(menubar, info) end

	-- Order Positions
	for i = 1, #buttonList do
		if i == 1 then
			buttonList[i]:SetPoint("LEFT")
		else
			buttonList[i]:SetPoint("LEFT", buttonList[i-1], "RIGHT", 2, 0)
		end
	end
end