-- SETTINGS MODULE --

-- options frame
ServerHop.optionsFrame = CreateFrame("Frame","hopOptions",ServerHop)
ServerHop.optionsFrame:SetFrameLevel(10)
ServerHop.optionsFrame:SetSize(400,360)
ServerHop.optionsFrame:SetPoint("CENTER",UIParent,"CENTER",0,0)
ServerHop.optionsFrame:SetBackdrop({bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", 
					edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", 
					tile = true, tileSize = 32, edgeSize = 32, 
					insets = { left = 11, right = 11, top = 12, bottom = 10 }});
ServerHop.optionsFrame:Hide()

ServerHop.optionsFrame.header = ServerHop.optionsFrame:CreateTexture(nil,"ARTWORK")
ServerHop.optionsFrame.header:SetSize(300,68)
ServerHop.optionsFrame.header:SetPoint("TOP",0,12)
ServerHop.optionsFrame.header:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Header")

ServerHop.optionsFrame.headerString = ServerHop.optionsFrame:CreateFontString("headerString", "OVERLAY", "GameFontNormal")
ServerHop.optionsFrame.headerString:SetPoint("TOP",0,-4)
ServerHop.optionsFrame.headerString:SetText("Server Hop v"..SERVERHOP_VERSION)

ServerHop.optionsFrame.closeButton = CreateFrame("Button", "optionsInFrameCloseBut", ServerHop.optionsFrame,"BrowserButtonTemplate")
ServerHop.optionsFrame.closeButton:SetSize(25,25)
ServerHop.optionsFrame.closeButton:SetPoint("TOPRIGHT",-6,-6)
ServerHop.optionsFrame.closeButton.Icon = ServerHop.optionsFrame.closeButton:CreateTexture("optionsClosetex","OVERLAY")
ServerHop.optionsFrame.closeButton.Icon:SetSize(14,14)
ServerHop.optionsFrame.closeButton.Icon:SetPoint("CENTER",0,0)
ServerHop.optionsFrame.closeButton.Icon:SetTexture("Interface\\Buttons\\UI-StopButton")
ServerHop.optionsFrame.closeButton:SetScript("OnClick", function(btn)
	ServerHop.optionsFrame:Hide()
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
end)

ServerHop.optionsFrame:SetMovable(true)
ServerHop.optionsFrame:EnableMouse(true)
ServerHop.optionsFrame:RegisterForDrag("LeftButton")
ServerHop.optionsFrame:SetScript("OnDragStart", ServerHop.optionsFrame.StartMoving)
ServerHop.optionsFrame:SetScript("OnDragStop", ServerHop.optionsFrame.StopMovingOrSizing)


-- Author Notes Frame
ServerHop.optionsFrame.optionsAuthor = CreateFrame("Frame",nil,ServerHop.optionsFrame)
local authorFrame = ServerHop.optionsFrame.optionsAuthor
authorFrame:SetBackdrop({ 
					edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", 
					tile = true, tileSize = 16, edgeSize = 16, 
					insets = { left = 5, right = 5, top = 5, bottom = 5 }});
authorFrame:SetSize(360,75)
authorFrame:SetPoint("BOTTOM",0,20)
authorFrame:SetBackdropBorderColor(0.6,0.6,0.6,1)
authorFrame:Show()

authorFrame.updateString = authorFrame:CreateFontString("updateString", "OVERLAY", "GameFontNormal")
authorFrame.updateString:SetWidth(330)
authorFrame.updateString:SetJustifyH("LEFT")
authorFrame.updateString:SetPoint("TOPLEFT",15,-15)
authorFrame.updateString:SetText(SERVERHOP_UPDATESTRING)

authorFrame.linkBox = CreateFrame("EditBox", nil, authorFrame, "LFGListEditBoxTemplate")
authorFrame.linkBox:SetPoint("BOTTOM",0,10)
authorFrame.linkBox:SetSize(320,20)
authorFrame.linkBox:SetText("http://www.curse.com/addons/wow/server-hop")
authorFrame.linkBox:SetScript("OnTextChanged", function(self,userInput)
	authorFrame.linkBox:SetText("http://www.curse.com/addons/wow/server-hop")
end)

-- TAB LIST --
ServerHop.optionsFrame.tabList = CreateFrame("Frame",nil,ServerHop.optionsFrame)
local optionTabs = ServerHop.optionsFrame.tabList
optionTabs:SetBackdrop({ 
					edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", 
					tile = true, tileSize = 16, edgeSize = 16, 
					insets = { left = 5, right = 5, top = 5, bottom = 5 }});

optionTabs:SetSize(110,85)
optionTabs:SetPoint("TOPLEFT",20,-30)
optionTabs:Show()

local tabList = {}

local function CreateOptionsTab(index,text)
	-- creating tab
	local frame = CreateFrame("Frame",nil,ServerHop.optionsFrame)
	frame:SetBackdrop({ 
						edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", 
						tile = true, tileSize = 16, edgeSize = 16, 
						insets = { left = 5, right = 5, top = 5, bottom = 5 }});

	frame:SetSize(240,230)
	frame:SetPoint("TOPRIGHT",-20,-30)
	frame:SetBackdropBorderColor(0.6,0.6,0.6,1)
	frame:Hide()
	
	-- creating button
	local button = CreateFrame("Button", nil, optionTabs)
	button:SetSize(110,25)
	button:SetPoint("TOPLEFT",0,-5-index*25)

	local highlightTexture = button:CreateTexture()
	highlightTexture:SetPoint("TOPLEFT",2,0)
	highlightTexture:SetPoint("BOTTOMRIGHT",-2,1)
	highlightTexture:SetTexture("Interface\\QuestFrame\\UI-QuestLogTitleHighlight")
	button:SetHighlightTexture(highlightTexture,"ADD")

	button.textName = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	button.textName:SetSize(156,36)
	button.textName:SetPoint("LEFT",button,"LEFT",8,0)
	button.textName:SetJustifyH("LEFT")
	button.textName:SetText(text)
	
	button.textName:SetTextColor(1,0.82,0,1)

	button:SetScript("OnClick",function(btn)
		-- Hiding all
		for i=1,#tabList do
			tabList[i].frame:Hide()
			tabList[i].button.textName:SetTextColor(1,0.82,0,1)
		end
		
		-- Showing selected
		frame:Show()
		button.textName:SetTextColor(1,1,1,1)
	end)
	
	t = {}
	t.frame = frame
	t.button = button
	
	table.insert(tabList,t)
	
	return frame,button
end

-- Hop Search options
ServerHop.optionsFrame.hopSearchOptionsFrame,optionTabs.hopButton = CreateOptionsTab(0,GRAPHICS_LABEL)
local hopOptions = ServerHop.optionsFrame.hopSearchOptionsFrame
optionTabs.hopButton.textName:SetTextColor(1,1,1,1)
hopOptions:Show()

hopOptions.string = hopOptions:CreateFontString("rolestring", "OVERLAY", "GameFontNormal")
hopOptions.string:SetPoint("TOPLEFT",15,-15)
hopOptions.string:SetText(ADVANCED_OPTIONS..":")

hopOptions.autoInviteCheck = CreateFrame("CheckButton","CheckAutoinv",hopOptions,"ChatConfigCheckButtonTemplate")
hopOptions.autoInviteCheck:SetPoint("TOPLEFT",15,-35)
getglobal(hopOptions.autoInviteCheck:GetName() .. 'Text'):SetText(SERVERHOP_AUTOINVITE_OPTIONS)
hopOptions.autoInviteCheck.tooltip = SERVERHOP_AUTOINVITE_TOOLTIP
hopOptions.autoInviteCheck:SetChecked(false)

hopOptions.sliderQueueWait = CreateFrame("Slider","ServerHop_sliderQueueWait",hopOptions,"OptionsSliderTemplate")
local slider = hopOptions.sliderQueueWait
slider:SetSize(140,17)
slider:SetPoint("TOPLEFT",38,-70)

local name = slider:GetName()
_G[name.."Low"]:SetText("1 "..SECONDS);
_G[name.."High"]:SetText("15 "..SECONDS);
slider.type = CONTROLTYPE_SLIDER;
_G[name.."Text"]:SetFontObject("GameFontNormal");
_G[name.."Text"]:SetJustifyH("LEFT")
_G[name.."Text"]:SetPoint("BOTTOMLEFT", slider, "TOPLEFT", 0, 4);
slider:SetMinMaxValues(1,15)
slider:SetValueStep(1)
slider:SetScript("OnValueChanged", function(self,value)
	self.value = value;
	_G[name.."Text"]:SetText(SERVERHOP_QUEUEWAITTIME.." ("..ceil(value).." "..SECONDS..")")
	if (self:IsVisible()) then
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
	end

end)

slider:SetValue(10)

Slider_Disable(slider)

hopOptions.autoInviteCheck:SetScript("OnClick", function(self)
	if self:GetChecked() then
		Slider_Enable(slider)
	else
		Slider_Disable(slider)
	end

	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
end)


--[[
hopOptions.leaderHopButton = CreateFrame("CheckButton","SHGroupHoppingButton",hopOptions,"ChatConfigCheckButtonTemplate")
hopOptions.leaderHopButton:SetPoint("TOPLEFT",15,-100)
getglobal(hopOptions.leaderHopButton:GetName() .. 'Text'):SetText(HOPADDON_HOPWITHFRIEND)
hopOptions.leaderHopButton.tooltip = HOPADDON_HOPWITHFRIEND_TOOLTIP
hopOptions.leaderHopButton:SetChecked(false)
hopOptions.leaderHopButton:SetScript("OnEnter",function(self)
	GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT",0,5);
	GameTooltip:SetText(self.tooltip,nil,nil,nil,nil,1);
	GameTooltip:AddLine(HOPADDON_NONSAVESETTING,1,0,0)
	GameTooltip:Show()
end)
]]

hopOptions.chatNotifButton = CreateFrame("CheckButton","SHChatNotifCheckBtn",hopOptions,"ChatConfigCheckButtonTemplate")
hopOptions.chatNotifButton:SetPoint("TOPLEFT",15,-105)
getglobal(hopOptions.chatNotifButton:GetName() .. 'Text'):SetText(SERVERHOP_NOTIFCHECK)
hopOptions.chatNotifButton.tooltip = SERVERHOP_NOTIFTOOLTIP
hopOptions.chatNotifButton:SetChecked(true)


hopOptions.sliderBLTime = CreateFrame("Slider","ServerHop_sliderBL",hopOptions,"OptionsSliderTemplate")
local slider = hopOptions.sliderBLTime
slider:SetSize(160,17)
slider:SetPoint("TOPLEFT",15,-150)

slider.label = hopOptions.sliderBLTime:CreateFontString("bltimestring", "ARTWORK", "GameFontNormal")
local s = slider.label
s:SetTextColor(1,1,1)
s:SetPoint("LEFT",hopOptions.sliderBLTime,"RIGHT",2,1)
local name = slider:GetName()
_G[name.."Low"]:Hide();
_G[name.."High"]:Hide();
slider.type = CONTROLTYPE_SLIDER;
_G[name.."Text"]:SetFontObject("GameFontNormal");
_G[name.."Text"]:SetJustifyH("LEFT")
_G[name.."Text"]:SetPoint("BOTTOMLEFT", slider, "TOPLEFT", 0, 4);
_G[name.."Text"]:SetText(SERVERHOP_BLDURATION)
slider:SetMinMaxValues(30,3600)
slider:SetValueStep(30)
slider:SetScript("OnValueChanged", function(self,value)
	self.value = value;
	local minutes = math.floor(value/60)
	if minutes > 0 then
		self.label:SetText(minutes.." "..MINS_ABBR)
	else
		self.label:SetText(ceil(value).." "..SECONDS);	
	end
		
	if (self:IsVisible()) then
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
	end

end)

slider:SetValue(900)

slider:SetScript("OnEnter",function(self)
	GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT",0,5);
	GameTooltip:SetText(SERVERHOP_HOPHELP,nil,nil,nil,nil,1);
	GameTooltip:Show()
end)
slider:SetScript("OnLeave",function(self)
	GameTooltip:Hide()
end)


-- horizontal line
local highlightTexture = hopOptions:CreateTexture()
highlightTexture:SetPoint("BOTTOM",0,55)
highlightTexture:SetColorTexture(1,1,1,0.2)
highlightTexture:SetSize(210,1)


hopOptions.updateString = hopOptions:CreateFontString("updateString", "OVERLAY", "GameFontNormal")
hopOptions.updateString:SetWidth(220)
hopOptions.updateString:SetJustifyH("LEFT")
hopOptions.updateString:SetPoint("BOTTOMLEFT",15,35)
hopOptions.updateString:SetText(SERVERHOP_NEXTMACRO)

hopOptions.linkBox = CreateFrame("EditBox", nil, hopOptions, "LFGListEditBoxTemplate")
hopOptions.linkBox:SetPoint("BOTTOMLEFT",20,10)
hopOptions.linkBox:SetSize(180,20)
hopOptions.linkBox:SetText("/run ServerHop_HopForward()")
hopOptions.linkBox:SetScript("OnTextChanged", function(self,userInput)
	self:SetText("/run ServerHop_HopForward()")
end)

--[[
hopOptions.updateString = hopOptions:CreateFontString("updateString", "OVERLAY", "GameFontNormal")
hopOptions.updateString:SetWidth(220)
hopOptions.updateString:SetJustifyH("LEFT")
hopOptions.updateString:SetPoint("BOTTOMLEFT",15,40)
hopOptions.updateString:SetText(HOPADDON_LASTMACRO)

hopOptions.linkBox = CreateFrame("EditBox", nil, hopOptions, "LFGListEditBoxTemplate")
hopOptions.linkBox:SetPoint("BOTTOMLEFT",20,15)
hopOptions.linkBox:SetSize(180,20)
hopOptions.linkBox:SetText("/run ServerHop_HopBack()")
hopOptions.linkBox:SetScript("OnTextChanged", function(self,userInput)
	self:SetText("/run ServerHop_HopBack()")
end)
]]
--=============--
-- CREDITS TAB --
--=============--
ServerHop.optionsFrame.aboutTab,optionTabs.aboutTabSelector = CreateOptionsTab(2,HOPADDON_CREDITS)
local aboutTab = ServerHop.optionsFrame.aboutTab

aboutTab.headerCont = aboutTab:CreateFontString("rolestring", "OVERLAY", "GameFontNormal")
aboutTab.headerCont:SetPoint("TOPLEFT",15,-15)
aboutTab.headerCont:SetJustifyH("LEFT")
aboutTab.headerCont:SetText(HOPADDON_AUTHORCONT)

aboutTab.stringCont = aboutTab:CreateFontString("rolestring", "OVERLAY", "GameFontNormal")
aboutTab.stringCont:SetPoint("TOPLEFT",15,-35)
aboutTab.stringCont:SetJustifyH("LEFT")
aboutTab.stringCont:SetTextColor(1,1,1,1)
aboutTab.stringCont:SetText(BNet_GetClientEmbeddedTexture("Battlenet", 14).."Chronoexplosion")

aboutTab.string = aboutTab:CreateFontString("rolestring", "OVERLAY", "GameFontNormal")
aboutTab.string:SetPoint("TOPLEFT",15,-55)
aboutTab.string:SetText(HOPADDON_TESTERS)

aboutTab.helpedStringList = aboutTab:CreateFontString("rolestring", "OVERLAY", "GameFontNormal")
aboutTab.helpedStringList:SetPoint("TOPLEFT",30,-75)
aboutTab.helpedStringList:SetText("Тарики - Fordragon EU\nСтурворм - Fordragon EU\n\nТревиз - Borean Tundra EU\nKugelwerfer - Blackmoore EU\nChokobo - Aggramar US")
aboutTab.helpedStringList:SetJustifyH("LEFT")
aboutTab.helpedStringList:SetTextColor(1,1,1,1)

aboutTab.helpedTex1 = aboutTab:CreateTexture("horde","OVERLAY")
aboutTab.helpedTex1:SetPoint("TOPLEFT",5,-71)
aboutTab.helpedTex1:SetTexture("Interface\\BattlefieldFrame\\Battleground-Horde.png")
aboutTab.helpedTex2 = aboutTab:CreateTexture("alliance","OVERLAY")
aboutTab.helpedTex2:SetPoint("TOPLEFT",5,-107)
aboutTab.helpedTex2:SetTexture("Interface\\BattlefieldFrame\\Battleground-Alliance.png")

aboutTab.stringThanks = aboutTab:CreateFontString("rolestring", "OVERLAY", "GameFontNormal")
aboutTab.stringThanks:SetPoint("BOTTOMLEFT",10,10)
aboutTab.stringThanks:SetJustifyH("CENTER")
aboutTab.stringThanks:SetWidth(220)
aboutTab.stringThanks:SetText(HOPADDON_COMMUNITYTHANKS)

-- ATTACHING TO THE MAIN MODULE --

-- button on main frame
ServerHop.buttonOptions = CreateFrame("Button","optionsOnMain",ServerHop,"BrowserButtonTemplate")
ServerHop.buttonOptions:SetSize(25,25)
ServerHop.buttonOptions:SetPoint("TOPLEFT",6,4)
ServerHop.buttonOptions.Icon = ServerHop.buttonOptions:CreateTexture("butOptionsTex","OVERLAY")
ServerHop.buttonOptions.Icon:SetSize(14,14)
ServerHop.buttonOptions.Icon:SetPoint("CENTER",0,0)
ServerHop.buttonOptions.Icon:SetTexture("Interface\\Buttons\\UI-OptionsButton")
ServerHop.buttonOptions.tooltip = OPTIONS
-- override on enter, onhide event is inside template
ServerHop.buttonOptions:SetScript("OnEnter", function(button)
	GameTooltip:SetOwner(button, "ANCHOR_LEFT", 0, -25)
	GameTooltip:SetText(OPTIONS, 1, 1, 1, true)
	GameTooltip:Show()
end)
-- toggle options frame on click
ServerHop.buttonOptions:SetScript("OnClick", function(button)
	if not ServerHop.optionsFrame:IsShown() then
		ServerHop.optionsFrame:Show()
	else
		ServerHop.optionsFrame:Hide()	
	end
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
end)