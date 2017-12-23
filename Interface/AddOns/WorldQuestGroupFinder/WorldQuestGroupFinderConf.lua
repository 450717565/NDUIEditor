WorldQuestGroupFinderConf = {}

local L = LibStub ("AceLocale-3.0"):GetLocale ("WorldQuestGroupFinder", true)

local DefaultConfig = {}
WorldQuestGroupFinderConfig = {}
WorldQuestGroupFinderCharacterConfig = {}

function WorldQuestGroupFinderConf.CreateConfigMenu()
	local configPanel = CreateFrame("Frame", "WorldQuestGroupFinderConfigFrame", UIParent)
	configPanel.name = "WorldQuestGroupFinder"
	configPanel.okay = function (self) return end
	configPanel.cancel = function (self) return end

	local addonName, addonTitle, addonNotes = GetAddOnInfo('WorldQuestGroupFinder')
	local configPanelText = configPanel:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
	configPanelText:SetPoint('TOPLEFT', 16, -16)
	configPanelText:SetText(addonTitle .. " "..GetAddOnMetadata("WorldQuestGroupFinder", "Version").." (" .. L["WQGF_CONFIG_PAGE_CREDITS"] ..")")

	local configPanelDesc = configPanel:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightSmall')

	configPanelDesc:SetPoint('TOPLEFT', configPanelText, 'BOTTOMLEFT', 0, -6)
	configPanelDesc:SetPoint('RIGHT', configPanel, -32, 0)
	configPanelDesc:SetNonSpaceWrap(true)
	configPanelDesc:SetJustifyH('LEFT')
	configPanelDesc:SetJustifyV('TOP')
	configPanelDesc:SetText(L["WQGF_ADDON_DESCRIPTION"])
	
	local regularQuestsDesc = configPanel:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
	regularQuestsDesc:SetPoint('TOPLEFT', configPanelDesc, 'BOTTOMLEFT', -2, -8)
	regularQuestsDesc:SetText(L["WQGF_CONFIG_QUEST_SUPPORT_TITLE"])

	local regularQuests = WorldQuestGroupFinderConf.CreateCheckButton(L["WQGF_CONFIG_QUEST_SUPPORT_ENABLE"], configPanel, L["WQGF_CONFIG_QUEST_SUPPORT_HOVER"], "regularQuests", 'InterfaceOptionsCheckButtonTemplate')
	regularQuests:SetPoint('TOPLEFT', regularQuestsDesc, 'BOTTOMLEFT', 0, -2)
	
	local askToLeaveDesc = configPanel:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
	askToLeaveDesc:SetPoint('TOPLEFT', regularQuests, 'BOTTOMLEFT', 0, -6)
	askToLeaveDesc:SetText(L["WQGF_CONFIG_WQ_END_DIALOG_TITLE"])

	local askToLeave = WorldQuestGroupFinderConf.CreateCheckButton(L["WQGF_CONFIG_WQ_END_DIALOG_ENABLE"], configPanel, L["WQGF_CONFIG_WQ_END_DIALOG_HOVER"], "askToLeave", 'InterfaceOptionsCheckButtonTemplate')
	askToLeave:SetPoint('TOPLEFT', askToLeaveDesc, 'BOTTOMLEFT', 0, -2)
	
	local autoLeaveGroup = WorldQuestGroupFinderConf.CreateCheckButton(L["WQGF_CONFIG_WQ_END_DIALOG_AUTO_LEAVE_ENABLE"], configPanel, L["WQGF_CONFIG_WQ_END_DIALOG_AUTO_LEAVE_HOVER"], "autoLeaveGroup", 'InterfaceOptionsCheckButtonTemplate')
	autoLeaveGroup:SetPoint('TOPLEFT', askToLeave, 'BOTTOMLEFT', 10, 2)
	WorldQuestGroupFinderConf.AddDependentCheckbox(askToLeave, autoLeaveGroup, false)

	local notifyPartyDesc = configPanel:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
	notifyPartyDesc:SetPoint('TOPLEFT', autoLeaveGroup, 'BOTTOMLEFT', -10, -6)
	notifyPartyDesc:SetText(L["WQGF_CONFIG_PARTY_NOTIFICATION_TITLE"])

	local notifyParty = WorldQuestGroupFinderConf.CreateCheckButton(L["WQGF_CONFIG_PARTY_NOTIFICATION_ENABLE"], configPanel, L["WQGF_CONFIG_PARTY_NOTIFICATION_HOVER"], "notifyParty", 'InterfaceOptionsCheckButtonTemplate')
	notifyParty:SetPoint('TOPLEFT', notifyPartyDesc, 'BOTTOMLEFT', 0, -2)

	local askZoningDesc = configPanel:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
	askZoningDesc:SetPoint('TOPLEFT', notifyParty, 'BOTTOMLEFT', 0, -6)
	askZoningDesc:SetText(L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_TITLE"])

	local askZoning = WorldQuestGroupFinderConf.CreateCheckButton(L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_ENABLE"], configPanel, L["WQGF_CONFIG_NEW_WQ_AREA_DETECTION_HOVER"], "askZoning", 'InterfaceOptionsCheckButtonTemplate')
	askZoning:SetPoint('TOPLEFT', askZoningDesc, 'BOTTOMLEFT', 0, -2)

	local allLanguagesDesc = configPanel:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
	allLanguagesDesc:SetPoint('TOPLEFT', askZoning, 'BOTTOMLEFT', 0, -6)
	allLanguagesDesc:SetText(L["WQGF_CONFIG_LANGUAGE_FILTER_TITLE"])

	local allLanguagesOpt = WorldQuestGroupFinderConf.CreateCheckButton(L["WQGF_CONFIG_LANGUAGE_FILTER_ENABLE"], configPanel, L["WQGF_CONFIG_LANGUAGE_FILTER_HOVER"], "allLanguages", 'InterfaceOptionsCheckButtonTemplate')
	allLanguagesOpt:SetPoint('TOPLEFT', allLanguagesDesc, 'BOTTOMLEFT', 0, -2)

	local avoidPVPDesc = configPanel:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
	avoidPVPDesc:SetPoint('TOPLEFT', allLanguagesOpt, 'BOTTOMLEFT', 0, -6)
	avoidPVPDesc:SetText(L["WQGF_CONFIG_PVP_REALMS_TITLE"])

	local avoidPVPOpt = WorldQuestGroupFinderConf.CreateCheckButton(L["WQGF_CONFIG_PVP_REALMS_ENABLE"], configPanel, L["WQGF_CONFIG_PVP_REALMS_HOVER"], "avoidPVP", 'InterfaceOptionsCheckButtonTemplate')
	avoidPVPOpt:SetPoint('TOPLEFT', avoidPVPDesc, 'BOTTOMLEFT', 0, -2)

	local silentModeDesc = configPanel:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
	silentModeDesc:SetPoint('TOPLEFT', avoidPVPOpt, 'BOTTOMLEFT', 0, -6)
	silentModeDesc:SetText(L["WQGF_CONFIG_SILENT_MODE_TITLE"])

	local silentModeOpt = WorldQuestGroupFinderConf.CreateCheckButton(L["WQGF_CONFIG_SILENT_MODE_ENABLE"], configPanel, L["WQGF_CONFIG_SILENT_MODE_HOVER"], "silent", 'InterfaceOptionsCheckButtonTemplate')
	silentModeOpt:SetPoint('TOPLEFT', silentModeDesc, 'BOTTOMLEFT', 0, -2)

	local bindingAdvice = configPanel:CreateFontString(nil, 'ARTWORK', 'GameFontNormalSmall')
	bindingAdvice:SetPoint('TOPLEFT', silentModeOpt, 'BOTTOMLEFT', 0, -10)
	bindingAdvice:SetText(L["WQGF_CONFIG_BINDING_ADVICE"])
	
	if (GetLocale() ~= "enUS" and GetLocale() ~= "enGB") then
		local translationInfo = configPanel:CreateFontString(nil, 'ARTWORK', 'GameFontNormalSmall')
		translationInfo:SetPoint('TOPLEFT', bindingAdvice, 'BOTTOMLEFT', 0, -10)
		translationInfo:SetText(L["WQGF_TRANSLATION_INFO"])
	end
	
	InterfaceOptions_AddCategory(configPanel)
end


function WorldQuestGroupFinderConf.AddDependentCheckbox(dependency, checkbox, reversed)
	if ( not dependency ) then
		return
	end
	local reversed = reversed or false
	assert(checkbox)
	checkbox.Disable = function (self) getmetatable(self).__index.Disable(self) _G[self:GetName().."Text"]:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b) end
	checkbox.Enable = function (self) getmetatable(self).__index.Enable(self) _G[self:GetName().."Text"]:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b) end
	if (reversed) then
		dependency.reverseDependentCheckbox = dependency.reverseDependentCheckbox or {}
		tinsert(dependency.reverseDependentCheckbox, control)
		if dependency:GetChecked() then
			checkbox:Disable()
		else
			checkbox:Enable()
		end
	else
		dependency.dependentCheckbox = dependency.dependentCheckbox or {}
		tinsert(dependency.dependentCheckbox, checkbox)
		if dependency:GetChecked() then
			checkbox:Enable()
		else
			checkbox:Disable()
		end
	end
end

function WorldQuestGroupFinderConf.CreateCheckButton(name, parent, tooltipText, configKey, template)
	local button = CreateFrame('CheckButton', parent:GetName() .. name, parent, template)
	_G[button:GetName() .. 'Text']:SetText(name)
	button:SetChecked(WorldQuestGroupFinderConf.GetConfigValue(configKey))
	button:SetScript('OnClick', function(self)
		if self:GetChecked() then
			WorldQuestGroupFinderConf.SetConfigValue(configKey, true)
		else 
			WorldQuestGroupFinderConf.SetConfigValue(configKey, false)
		end
		if ( self.dependentCheckbox ) then
			if ( self:GetChecked() ) then
				for _, control in pairs(self.dependentCheckbox) do
					control:Enable()
				end
			else
				for _, control in pairs(self.dependentCheckbox) do
					control:Disable()
				end
			end
		end
		if ( self.reverseDependentCheckbox ) then
			if ( self:GetChecked() ) then
				for _, control in pairs(self.reverseDependentCheckbox) do
					control:Disable()
				end
			else
				for _, control in pairs(self.reverseDependentCheckbox) do
					control:Enable()
				end
			end
		end
	end)
	button:SetScript('OnEnter', function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(tooltipText, nil, nil, nil, 1, 1)
		GameTooltip:Show() end)
	button:SetScript('OnLeave', function(self) GameTooltip:Hide() end)

	return button
end

function WorldQuestGroupFinderConf.GetConfigValue(key, cType)
	local cType = cType or "GLOBAL"
	if (cType == "GLOBAL") then
		return WorldQuestGroupFinderConfig[key]
	elseif (cType == "CHAR") then
		return WorldQuestGroupFinderCharacterConfig[key]
	end
end

function WorldQuestGroupFinderConf.SetConfigValue(key, value, cType)
	local cType = cType or "GLOBAL"
	if (cType == "GLOBAL") then
		WorldQuestGroupFinderConfig[key] = value
	elseif (cType == "CHAR") then
		WorldQuestGroupFinderCharacterConfig[key] = value
	end
	WorldQuestGroupFinder.dprint(string.format("Changed parameter value. Parameter: %s, Value: %s, Type: %s", key, tostring(value), cType))
end

WorldQuestGroupFinderConf.DefaultConfig = {
	autoinvite = true,
	autoinviteUsers = true,
	askToLeave = true,
	notifyParty = false,
	askZoning = false,
	hideLoginMessage = false,
	autoAcceptInvites = false,
	printDebug = false,
	allLanguages = true,
	avoidPVP = false,
	autoLeaveGroup = true,
	regularQuests = false,
	frameUnlocked = true,
	silent = true
}