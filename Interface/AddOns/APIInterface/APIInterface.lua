
local _addonName, _addon = ...;

local APII = LibStub("AceAddon-3.0"):NewAddon(_addonName);

local LISTITEM_HEIGHT = 34;
local LISTITEM_EXPAND_MARGIN = 43;
local ERROR_COMBAT = "Can't open %s during combat. The frame will open once you leave combat.";
local COLOR_FILTER1 = "|cff......";
local COLOR_FILTER2 = "|r";
----------
-- Code
----------

function APII_Resize_OnMouseUp(self, button)
	if (button == "LeftButton") then
		APII_Core:StopMovingOrSizing();
		HybridScrollFrame_CreateButtons(APIIListsSystemList, "APII_ListSystemTemplate", 1, 0);
		APIIListsSystemListScrollBar.doNotHide = true;
		APII:UpdateSystemList();
		APII:AdjustSelection();
	end
end

function APII_Resize_OnMouseDown(self, button)
	if (button == "RightButton") then
		APII:ResetFrame()
	elseif (button == "LeftButton") then
		APII_Core:StartSizing();
	end
end

function APII_List_OnClick(self, button)
	if (self.Type ~= "system" ) then
		if ( self.selected ) then
			self.selected = nil;
			APIIListsSystemList.Opened = "";
			self:SetHeight(LISTITEM_HEIGHT);
			HybridScrollFrame_CollapseButton(APIIListsSystemList);
			APII:UpdateSystemList();
		else
		APIIListsSystemList.Opened = self.Api:GetFullName();
		self.Details:SetText(table.concat(self.Api:GetDetailedOutputLines(), "\n", 2));
		self:SetHeight(LISTITEM_HEIGHT + LISTITEM_EXPAND_MARGIN + self.Details:GetHeight());
		HybridScrollFrame_ExpandButton(APIIListsSystemList, ((self.index - 1) * LISTITEM_HEIGHT), self:GetHeight());
		APII:UpdateSystemList();
		APII:AdjustSelection();
		end
	else
		APIIListsSystemList.InSystem = self.Api;
		APII_UpdateFilterBar()
		APIILists.searchBox:SetText("");
	end
	
	-- if (CopyToClipboard and button == "RightButton" and self.Api) then
		-- local clipboardString = self.Api:GetClipboardString();
		-- CopyToClipboard(clipboardString);
		-- print(("Copied to clipboard: %s"):format(clipboardString));
	-- end
end

function APII:UpdateSearchResults()
	for i=#APIIListsSystemList.SearchResults, 1, -1 do
		table.remove(APIIListsSystemList.SearchResults, i)
	end

	--if (APIIListsSystemList.SearchString == "") then return; end
	
	local results = APIIListsSystemList.SearchResults;
	local matches;
	if APIIListsSystemList.InSystem then
		if APIIListsSystemList.SearchString == "" then
			matches = APIIListsSystemList.InSystem:ListAllAPI();
		else
			matches = APIIListsSystemList.InSystem:FindAllAPIMatches(APIIListsSystemList.SearchString);
		end
	else
		if (APIIListsSystemList.SearchString == "") then return; end
		matches = APIDocumentation:FindAllAPIMatches(APIIListsSystemList.SearchString);
		if not matches then return; end
		
		for k, info in ipairs(matches.systems) do
			table.insert(results, info);
		end
	end
	
	if not matches then return; end
	
	for k, info in ipairs(matches.functions) do
		table.insert(results, info);
	end
	
	for k, info in ipairs(matches.tables) do
		table.insert(results, info);
	end

end

function APII_Search_OnTextChanged(self)
	local searchString = self:GetText();
	
	-- Make 'Search' text disapear when needed
	SearchBoxTemplate_OnTextChanged(self);
	-- protect against malformed pattern
	if not pcall(function() APIDocumentation:FindAllAPIMatches(searchString) end) then 
		self:SetTextColor(1, 0.25, 0.25, 1);
		return; 
	else
		self:SetTextColor(1, 1, 1, 1);
	end
	
	APIIListsSystemListScrollBar:SetValue(0);
	
	APIIListsSystemList.SearchString = searchString;
	APII:ResetListButtons();
	
	APII:UpdateSearchResults()
	APII:UpdateSystemList();
end

function APII_FilterClearButton_OnClick(self)
	APIIListsSystemListScrollBar:SetValue(0);	
	APIIListsSystemList.InSystem = nil;
	HybridScrollFrame_CollapseButton(APIIListsSystemList);
	APII_UpdateFilterBar();
end

function APII:ResetFrame()
	APII_Core:SetSize(550, 450);
	HybridScrollFrame_CreateButtons(APIIListsSystemList, "APII_ListSystemTemplate", 1, 0);
	APIIListsSystemListScrollBar.doNotHide = true;
	APII:UpdateSystemList();
	APII:AdjustSelection();
end

function APII:FindSelection()
	local _, maxVal = APIIListsSystemListScrollBar:GetMinMaxValues();
	local scrollHeight = APIIListsSystemList:GetHeight();
	local newHeight = 0;
	
	
	print("calling selection")
	APIIListsSystemListScrollBar:SetValue(0);	
	local i = 0;
	while (true) do
		for _, button in next, APIIListsSystemList.buttons do
			if ( button.selected ) then
				newHeight = APIIListsSystemListScrollBar:GetValue() + APIIListsSystemList:GetTop() - button:GetTop();
				newHeight = min(newHeight, maxVal);
				APIIListsSystemListScrollBar:SetValue(newHeight);					
				return;
			end
		end		
			newHeight = newHeight + scrollHeight;
			newHeight = min(newHeight, maxVal);
			APIIListsSystemListScrollBar:SetValue(newHeight);
		
		if ( APIIListsSystemListScrollBar:GetValue() == maxVal or APIIListsSystemListScrollBar:GetValue() == 0 ) then	
			-- If we don't actually find any selected button, reset scrollbar to the top
			APIIListsSystemListScrollBar:SetValue(0);	
			return;
		end
	end
end

function APII:AdjustSelection()
	if APIIListsSystemList.Adjusting then return; end
	local selectedButton;	
	APIIListsSystemList.Adjusting = true;
	-- check if selection is visible
	for _, button in next, APIIListsSystemList.buttons do
		if ( button.selected ) then
			selectedButton = button;
			break;
		end
	end	
	
	if ( not selectedButton ) then
		APII:FindSelection();
	else
		local newHeight;
		if ( selectedButton:GetTop() > APIIListsSystemList:GetTop() ) then
			newHeight = APIIListsSystemListScrollBar:GetValue() + APIIListsSystemList:GetTop() - selectedButton:GetTop();
		elseif ( selectedButton:GetBottom() < APIIListsSystemList:GetBottom() ) then
			if ( selectedButton:GetHeight() > APIIListsSystemList:GetHeight() ) then
				newHeight = APIIListsSystemListScrollBar:GetValue() + APIIListsSystemList:GetTop() - selectedButton:GetTop();
			else
				newHeight = APIIListsSystemListScrollBar:GetValue() + APIIListsSystemList:GetBottom() - selectedButton:GetBottom();
			end
		end
		if ( newHeight ) then
			local _, maxVal = APIIListsSystemListScrollBar:GetMinMaxValues();
			newHeight = min(newHeight, maxVal);
			APIIListsSystemListScrollBar:SetValue(newHeight);					
		end
	end
	APIIListsSystemList.Adjusting = false;
end

function APII:ResetListButtons()
	HybridScrollFrame_CollapseButton(APIIListsSystemList);
	APIIListsSystemList.Opened = nil;
	APIIListsSystemList.ExpandedHeight = nil;
end

function APII_UpdateFilterBar()
	APIILists.filterBar:SetHeight(APIIListsSystemList.InSystem and 20 or 0.1);
	APIILists.filterBar.text:SetText(APIIListsSystemList.InSystem and "In system: " .. APIIListsSystemList.InSystem.Name or "")
	APIILists.filterBar.clearButton:SetShown(APIIListsSystemList.InSystem)
	APII:UpdateSystemList()
end

function APII:UpdateSystemList()
	local scrollFrame = APIIListsSystemList;
	local offset = HybridScrollFrame_GetOffset(scrollFrame);
	local buttons = scrollFrame.buttons;
	if buttons == nil then return; end
	
	APII:UpdateSearchResults();
	local list = (APIIListsSystemList.SearchString == "" and  #APIIListsSystemList.SearchResults == 0) and APIDocumentation.systems or APIIListsSystemList.SearchResults;

	for i=1, #buttons do
		local button = buttons[i];
		local displayIndex = i + offset;
		
		button:SetHeight(LISTITEM_HEIGHT);
		button.ClipboardString:Hide();
		button.ClipboardInfo:Hide();
		button.Details:Hide();
		button.Api = nil;
		button.Type = "";
		button.Name:SetText("");
		button.Key = 0;
		button.ClipboardString:SetTextColor(0.7, 0.7, 0.7, 1);
		button.selected = false;
		button.highlight:Hide();
		
		if ( displayIndex <= #list) then
			button:Show();
			local info = list[displayIndex];
			--button.Name:SetText(info:GetSingleOutputLine():gsub(COLOR_FILTER1, ""):gsub(COLOR_FILTER2, ""));
			button.Name:SetText(info:GetSingleOutputLine())
			button.Api = info;
			button.Key = displayIndex;
			button.Type = info:GetType();
			button.index = displayIndex;
			if scrollFrame.Opened == info:GetFullName()  then
				button.selected = true;
				
				button.ClipboardString:Show();
				button.ClipboardString:SetText(info:GetClipboardString());
				button.ClipboardInfo:Show();
				button.Details:Show();
				button.highlight:Show();
				button.Details:SetText(table.concat(info:GetDetailedOutputLines(), "\n", 2));
				button:SetHeight(LISTITEM_HEIGHT + LISTITEM_EXPAND_MARGIN + button.Details:GetHeight());
			end
		else
			button:Hide();
		end
	end
	
	local extra = APIIListsSystemList.largeButtonHeight or LISTITEM_HEIGHT 
	local totalHeight = #list * LISTITEM_HEIGHT
	totalHeight = totalHeight + (extra - LISTITEM_HEIGHT)
	HybridScrollFrame_Update(scrollFrame, totalHeight, scrollFrame:GetHeight());
end

function APII:OnInitialize()
	APII_Core:SetScript("OnDragStart", function(self)
					self:StartMoving();
				end
			);
	APII_Core:SetScript("OnDragStop", function(self)
					self:StopMovingOrSizing();
				end
			);
end

function APII:OnEnable()
	if not APIDocumentation then
		LoadAddOn("Blizzard_APIDocumentation");
	end
	
	HybridScrollFrame_CreateButtons(APIIListsSystemList, "APII_ListSystemTemplate", 1, 0);
	HybridScrollFrame_Update(APIIListsSystemList, #APIDocumentation.systems * LISTITEM_HEIGHT, APIIListsSystemList:GetHeight());
	APIIListsSystemListScrollBar.doNotHide = true;
	APIIListsSystemListScrollBar:Show();
	
	APIIListsSystemList.update = function() APII:UpdateSystemList() end;
	APIIListsSystemList.SearchString = "";
	APIIListsSystemList.SearchResults = {};
	APIIListsSystemList.Opened = {};
	APII:UpdateSystemList();
end

----------
-- Events
----------

APII.events = CreateFrame("FRAME", "APII_EventFrame"); 
APII.events:RegisterEvent("PLAYER_REGEN_DISABLED");
APII.events:RegisterEvent("PLAYER_REGEN_ENABLED");
APII.events:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)


function APII.events:PLAYER_REGEN_DISABLED(loaded_addon)
	HideUIPanel(APII_Core);
end

function APII.events:PLAYER_REGEN_ENABLED(loaded_addon)
	if APII.openDuringCombat then
		ShowUIPanel(APII_Core);
		APII.openDuringCombat = false;
	end
end
----------
-- Slash
----------

SLASH_APIISLASH1 = '/apii';
SLASH_APIISLASH2 = '/apiinterface';
local function slashcmd(msg, editbox)
	if (msg == "reset") then
		APII:ResetFrame();
	else
		if (not InCombatLockdown()) then
			ShowUIPanel(APII_Core);
		else
			print(ERROR_COMBAT:format(_addonName));
			APII.openDuringCombat = true;
		end
	end
end
SlashCmdList["APIISLASH"] = slashcmd
