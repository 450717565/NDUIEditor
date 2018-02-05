local B, C, L, DB = unpack(select(2, ...))

local buttons = {}
local currencies = {}
local errors = {}
local factions = {}
local knowns = {}
local merchantFrameButtons = {}
local searching = ""
local RECIPE = GetItemClassInfo(LE_ITEM_CLASS_RECIPE)
local tooltip = CreateFrame("GameTooltip", "xMerchantTooltip", UIParent, "GameTooltipTemplate")

local scroll_limit_enabled = false
local scroll_limit_amount = 5
local kItemButtonHeight = 29.4

local function GetError(link, isRecipe)
	if not link then
		return false
	end

	local id = link:match("item:(%d+)")
	if errors[id] then
		return errors[id]
	end

	tooltip:SetOwner(UIParent, "ANCHOR_NONE")
	tooltip:SetHyperlink(link)

	local errormsg = ""
	for i = 2, tooltip:NumLines() do
		local text = _G["xMerchantTooltipTextLeft"..i]
		local r, g, b = text:GetTextColor()
		local gettext = text:GetText()
		if gettext and r >= 0.9 and g <= 0.2 and b <= 0.2 and gettext ~= RETRIEVING_ITEM_INFO then
			if errormsg ~= "" then
				errormsg = errormsg..L[","]
			end

			local level = gettext:match(L["Requires Level (%d+)"])
			if level then
				errormsg = errormsg..L["Level %d"]:format(level)
			end

			local reputation = gettext:match(L["Requires .+ %- (.+)"])
			if reputation then
				errormsg = errormsg..reputation
				local factionName = gettext:match(L["Requires (.+) %- .+"])
				if factionName then
					local standingLabel = factions[factionName]
					if standingLabel then
						errormsg = errormsg.." ("..standingLabel..") - "..factionName
					else
						errormsg = errormsg.." ("..factionName..")"
					end
				end
			end

			local skill, slevel = gettext:match(L["Requires (.+) %((%d+)%)"])
			if skill and slevel then
				errormsg = errormsg..L["%1$s (%2$d)"]:format(skill, slevel)
			end

			local requires = gettext:match(L["Requires (.+)"])
			if not level and not reputation and not skill and requires then
				errormsg = errormsg..requires
			end

			if not level and not reputation and not skill and not requires then
				if errormsg ~= "" then
					errormsg = gettext..L[","]..errormsg
				else
					errormsg = errormsg..gettext
				end
			end
		end

		local text = _G["xMerchantTooltipTextRight"..i]
		local r, g, b = text:GetTextColor()
		local gettext = text:GetText()
		if gettext and r >= 0.9 and g <= 0.2 and b <= 0.2 then
			if errormsg ~= "" then
				errormsg = errormsg..L[","]
			end
			errormsg = errormsg..gettext
		end

		if isRecipe and i == 5 then
			break
		end
	end

	if errormsg == "" then
		return false
	end

	errors[id] = errormsg
	return errormsg
end

local function GetKnown(link)
	if not link then
		return false
	end

	local id = link:match("item:(%d+)")
	if knowns[id] then
		return true
	end

	tooltip:SetOwner(UIParent, "ANCHOR_NONE")
	tooltip:SetHyperlink(link)

	for i = 1, tooltip:NumLines() do
		if _G["xMerchantTooltipTextLeft"..i]:GetText() == ITEM_SPELL_KNOWN then
			knowns[id] = true
			return true
		end
	end

	return false
end


local function FactionsUpdate()
	wipe(factions)

	for factionIndex = 1, GetNumFactions() do
		local name, description, standingId, bottomValue, topValue, earnedValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild, factionID = GetFactionInfo(factionIndex)
		if name ~= nil and factionID ~= nil then
			local friendID, friendRep, friendMaxRep, friendName, friendText, friendTexture, friendTextLevel = GetFriendshipReputation(factionID)
			local standingLabel
			if isHeader == nil then
				if friendID ~= nil then
					standingLabel = friendTextLevel or "unkown"
				else
					standingLabel = _G["FACTION_STANDING_LABEL"..tostring(standingId)] or "unkown"
				end
				factions[name] = standingLabel
			end
		end
	end
end

local function CurrencyUpdate()
	wipe(currencies)

	local limit = GetCurrencyListSize()
	for i = 1, limit do
		local name, isHeader, _, _, _, count, icon, maximum, hasWeeklyLimit, currentWeeklyAmount, _, itemID = GetCurrencyListInfo(i)
		if not isHeader and itemID then
			currencies[tonumber(itemID)] = count
			if not isHeader and itemID and tonumber(itemID) <= 9 then
				currencies[name] = count
			end
		elseif not isHeader and not itemID then
			currencies[name] = count
		end
	end

	for i = INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED, 1 do
		local itemID = GetInventoryItemID("player", i)
		if itemID then
			currencies[tonumber(itemID)] = 1
		end
	end

	for bagID = 0, NUM_BAG_SLOTS, 1 do
		local numSlots = GetContainerNumSlots(bagID)
		for slotID = 1, numSlots, 1 do
			local itemID = GetContainerItemID(bagID, slotID)
			if itemID then
				local count = select(2, GetContainerItemInfo(bagID, slotID))
				itemID = tonumber(itemID)
				local currency = currencies[itemID]
				if currency then
					currencies[itemID] = currency+count
				else
					currencies[itemID] = count
				end
			end
		end
	end
end

local function AltCurrencyFrame_Update(item, texture, cost, itemID, currencyName)
	item.count:SetText(cost)
	item.icon:SetTexture(texture)

	if itemID ~= 0 or currencyName then
		local currency = currencies[itemID] or currencies[currencyName]
		if currency and currency < cost or not currency then
			item.count:SetTextColor(1, 0, 0)
		else
			item.count:SetTextColor(1, 1, 1)
		end
	end

	if item.pointType == HONOR_POINTS then
		item.count:SetPoint("RIGHT", item.icon, "LEFT", 1, 0)
	else
		item.count:SetPoint("RIGHT", item.icon, "LEFT", -2, 0)
	end

	local iconWidth = 17
	item.icon:SetSize(iconWidth, iconWidth)
	item:SetWidth(item.count:GetWidth() + iconWidth + 4)
	item:SetHeight(item.count:GetHeight() + 4)
	-- Aurora Reskin
	if IsAddOnLoaded("Aurora") then
		if not item.styled then
			local F = unpack(Aurora)
			F.ReskinIcon(item.icon)
			item.styled = true
		end
	end
end

local function UpdateAltCurrency(button, index, i)
	local currency_frames = {}
	local lastFrame
	local honorPoints, arenaPoints, itemCount = GetMerchantItemCostInfo(index)

	if select(4, GetBuildInfo()) >= 40000 then
		itemCount, honorPoints, arenaPoints = honorPoints, 0, 0
	end

	if itemCount > 0 then
		for i = 1, MAX_ITEM_COST, 1 do
			local itemTexture, itemValue, itemLink, currencyName = GetMerchantItemCostItem(index, i)
			local item = button.item[i]
			item.index = index
			item.item = i
			if currencyName then
				item.pointType = "Beta"
				item.itemLink = currencyName
			else
				item.pointType = nil
				item.itemLink = itemLink
			end

			local itemID = tonumber((itemLink or "item:0"):match("item:(%d+)"))
			AltCurrencyFrame_Update(item, itemTexture, itemValue, itemID, currencyName)

			if not itemTexture then
				item:Hide()
			else
				lastFrame = item
				lastFrame._dbg_name = "item"..i
				table.insert(currency_frames, item)
				item:Show()
			end
		end
	else
		for i = 1, MAX_ITEM_COST, 1 do
			button.item[i]:Hide()
		end
	end

	local arena = button.arena
	if arenaPoints > 0 then
		arena.pointType = ARENA_POINTS
		AltCurrencyFrame_Update(arena, "Interface\\PVPFrame\\PVP-ArenaPoints-Icon", arenaPoints)

		if GetArenaCurrency() < arenaPoints then
			arena.count:SetTextColor(1, 0, 0)
		else
			arena.count:SetTextColor(1, 1, 1)
		end

		lastFrame = arena
		lastFrame._dbg_name = "arena"
		table.insert(currency_frames, arena)
		arena:Show()
	else
		arena:Hide()
	end

	local honor = button.honor
	if honorPoints > 0 then
		honor.pointType = HONOR_POINTS
		local factionGroup = UnitFactionGroup("player")
		local honorTexture = "Interface\\TargetingFrame\\UI-PVP-Horde"
		if factionGroup then
			honorTexture = "Interface\\TargetingFrame\\UI-PVP-"..factionGroup
		end

		AltCurrencyFrame_Update(honor, honorTexture, honorPoints)

		if GetHonorCurrency() < honorPoints then
			honor.count:SetTextColor(1, 0, 0)
		else
			honor.count:SetTextColor(1, 1, 1)
		end

		lastFrame = honor
		lastFrame._dbg_name = "honor"
		table.insert(currency_frames, arena)
		honor:Show()
	else
		honor:Hide()
	end

	button.money._dbg_name = "money"
	table.insert(currency_frames, button.money)

	lastFrame = nil
	for i, frame in ipairs(currency_frames) do
		if i == 1 then
			frame:SetPoint("RIGHT", -2, 0)
		else
			if lastFrame then
				frame:SetPoint("RIGHT", lastFrame, "LEFT", -2, 0)
			else
				frame:SetPoint("RIGHT", -2, 0)
			end
		end
		lastFrame = frame
	end
end

local function MerchantUpdate()
	local self = xMerchantFrame
	local numMerchantItems = GetMerchantNumItems()

	FauxScrollFrame_Update(self.scrollframe, numMerchantItems, 10, kItemButtonHeight, nil, nil, nil, nil, nil, nil, 1)
	for i = 1, 10, 1 do
		local offset = i+FauxScrollFrame_GetOffset(self.scrollframe)
		local button = buttons[i]
		button.hover = false

		if offset <= numMerchantItems then
			local name, texture, price, quantity, numAvailable, isUsable, extendedCost = GetMerchantItemInfo(offset)
			local link = GetMerchantItemLink(offset)
			local name_text = name
			local iteminfo_text = ""
			local r, g, b = 0.5, 0.5, 0.5
			local _, itemRarity, itemType, itemSubType
			local iLevel, iLevelText

			if link then
				_, _, itemRarity, iLevel, _, itemType, itemSubType, _, itemEquipLoc = GetItemInfo(link)
				if itemRarity then
					r, g, b = GetItemQualityColor(itemRarity)
					button.itemname:SetTextColor(r, g, b)
				end

				if itemSubType or itemEquipLoc then
					iteminfo_text = itemSubType:gsub("%(OBSOLETE%)", "")
					if iLevel and iLevel > 1 then
						iLevelText = tostring(iLevel)
						iteminfo_text = iteminfo_text.." - "..iLevelText
					end
					if itemEquipLoc and string.find(itemEquipLoc, "INVTYPE_") then
						iteminfo_text = iteminfo_text.." - ".._G[itemEquipLoc]
					end
				else
					iteminfo_text = ""
				end

				local alpha = 0.3
				if searching == "" or searching == SEARCH:lower() or name:lower():match(searching) or (itemRarity and tostring(itemRarity):lower():match(searching) or _G["ITEM_QUALITY"..tostring(itemRarity).."_DESC"]:lower():match(searching)) or (itemType and itemType:lower():match(searching)) or (itemSubType and itemSubType:lower():match(searching)) then
					alpha = 1
				elseif self.tooltipsearching then
					tooltip:SetOwner(UIParent, "ANCHOR_NONE")
					tooltip:SetHyperlink(link)
					for i = 1, tooltip:NumLines() do
						if _G["xMerchantTooltipTextLeft"..i]:GetText():lower():match(searching) then
							alpha = 1
							break
						end
					end
				end
				button:SetAlpha(alpha)
			end

			local prename_text = (numAvailable >= 0 and "|cffffffff["..numAvailable.."]|r " or "")..(quantity > 1 and "|cffffffff"..quantity.."x|r " or "")
			name_text = prename_text..(name or "|cffff0000"..RETRIEVING_ITEM_INFO)
			button.itemname:SetText(name_text)
			button.icon:SetTexture(texture)

			UpdateAltCurrency(button, offset, i)
			if extendedCost then
				button.extendedCost = true
				if price <= 0 then
					button.price = nil
					button.money:SetText("")
				else
					button.price = price
					button.money:SetText(GetCoinTextureString(price))
				end
			else
				button.extendedCost = false
				if price <= 0 then
					button.price = nil
					button.money:SetText("")
				else
					button.price = price
					button.money:SetText(GetCoinTextureString(price))
				end
			end

			if GetMoney() < price then
				button.money:SetTextColor(1, 0, 0)
			else
				button.money:SetTextColor(1, 1, 1)
			end

			if numAvailable == 0 then
				button.highlight:SetVertexColor(0.5, 0.5, 0.5, 0.5)
				button.highlight:Show()
				button.isShown = true
			elseif not isUsable then
				button.highlight:SetVertexColor(1, 0.2, 0.2, 0.5)
				button.highlight:Show()
				button.isShown = true

				local errors = GetError(link, itemType and itemType == RECIPE)
				if errors then
					iteminfo_text = "|cffd00000"..iteminfo_text.." - "..errors.."|r"
				end
			elseif itemType and itemType == RECIPE and not GetKnown(link) then
				button.highlight:SetVertexColor(0.2, 1, 0.2, 0.5)
				button.highlight:Show()
				button.isShown = true
			else
				button.highlight:SetVertexColor(r, g, b, 0.5)
				button.highlight:Hide()
				button.isShown = false

				local errors = GetError(link, itemType and itemType == RECIPE)
				if errors then
					iteminfo_text = "|cffd00000"..iteminfo_text.." - "..errors.."|r"
				end
			end

			if button.itemname:GetNumLines() <= 1 then
				button.iteminfo:SetText(iteminfo_text)
			else
				button.iteminfo:SetText(iteminfo_text)
			end

			button.r = r
			button.g = g
			button.b = b
			button.link = GetMerchantItemLink(offset)
			button.hasItem = true
			button.texture = texture
			button:SetID(offset)
			button:Show()
		else
			button.price = nil
			button.hasItem = false
			button:Hide()
		end

		if button.hasStackSplit == 1 then
			StackSplitFrame:Hide()
		end
	end
end

local function xScrollFrame_OnVerticalScroll(self, offset)
	local current_offset_n = FauxScrollFrame_GetOffset(self)
	local offset_n = (offset >= 0 and 1 or -1) * math.floor(math.abs(offset) / kItemButtonHeight + 0.1)
	local changed_n = offset_n - current_offset_n

	if scroll_limit_enabled then
		if changed_n > scroll_limit_amount or changed_n < -scroll_limit_amount then
			changed_n = math.min(changed_n, scroll_limit_amount)
			changed_n = math.max(changed_n, -scroll_limit_amount)
			offset_n = (current_offset_n + changed_n)
			offset = (offset_n > 0.1 and (offset_n - 0.1) or 0) * kItemButtonHeight
		end
	end
	FauxScrollFrame_OnVerticalScroll(self, offset, kItemButtonHeight, MerchantUpdate)
end

local function OnClick(self, button)
	if IsModifiedClick() then
		MerchantItemButton_OnModifiedClick(self, button)
	else
		MerchantItemButton_OnClick(self, button)
	end
end

local function OnEnter(self)
	if self.isShown and not self.hover then
		self.oldr, self.oldg, self.oldb, self.olda = self.highlight:GetVertexColor()
		self.highlight:SetVertexColor(self.r, self.g, self.b, self.olda)
		self.hover = true
	else
		self.highlight:Show()
	end
	MerchantItemButton_OnEnter(self)
end

local function OnLeave(self)
	if self.isShown then
		self.highlight:SetVertexColor(self.oldr, self.oldg, self.oldb, self.olda)
		self.hover = false
	else
		self.highlight:Hide()
	end
	GameTooltip:Hide()
	ResetCursor()
	MerchantFrame.itemHover = false
end

local function SplitStack(button, split)
	if button.extendedCost then
		MerchantFrame_ConfirmExtendedItemCost(button, split)
	elseif split > 0 then
		BuyMerchantItem(button:GetID(), split)
	end
end

local function Item_OnClick(self)
	HandleModifiedItemClick(self.itemLink)
end

local function Item_OnEnter(self)
	local parent = self:GetParent()
	if parent.isShown and not parent.hover then
		parent.oldr, parent.oldg, parent.oldb, parent.olda = parent.highlight:GetVertexColor()
		parent.highlight:SetVertexColor(parent.r, parent.g, parent.b, parent.olda)
		parent.hover = true
	else
		parent.highlight:Show()
	end

	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")

	local r, g, b = HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b
	if self.pointType == ARENA_POINTS then
		GameTooltip:SetText(ARENA_POINTS, r, g, b)
		GameTooltip:AddLine(TOOLTIP_ARENA_POINTS, nil, nil, nil, 1)
		GameTooltip:Show()
	elseif self.pointType == HONOR_POINTS then
		GameTooltip:SetText(HONOR_POINTS, r, g, b)
		GameTooltip:AddLine(TOOLTIP_HONOR_POINTS, nil, nil, nil, 1)
		GameTooltip:Show()
	elseif self.pointType == "Beta" then
		GameTooltip:SetText(self.itemLink, r, g, b)
		GameTooltip:Show()
	else
		GameTooltip:SetHyperlink(self.itemLink)
	end

	if IsModifiedClick("DRESSUP") then
		ShowInspectCursor()
	else
		ResetCursor()
	end
end

local function Item_OnLeave(self)
	local parent = self:GetParent()
	if parent.isShown then
		parent.highlight:SetVertexColor(parent.oldr, parent.oldg, parent.oldb, parent.olda)
		parent.hover = false
	else
		parent.highlight:Hide()
	end

	GameTooltip:Hide()
	ResetCursor()
end

local function OnEvent(self, event, ...)
	if addonName == select(1, ...) then
		self:UnregisterEvent("ADDON_LOADED")

		local x = 0
		if IsAddOnLoaded("SellOMatic") then
			x = 20
		elseif IsAddOnLoaded("DropTheCheapestThing") then
			x = 14
		end

		if x ~= 0 then
			self.search:SetWidth(92-x)
			self.search:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 50-x, 9)
		end
	end
end

local frame = CreateFrame("Frame", "xMerchantFrame", MerchantFrame)
local function xMerchant_InitFrame(frame)
	frame:RegisterEvent("ADDON_LOADED")
	frame:SetScript("OnEvent", OnEvent)
	frame:SetSize(295, 294)
	frame:SetPoint("TOPLEFT", 10, -65)

	merchantFrame = frame
end
xMerchant_InitFrame(frame)

local function OnTextChanged(self)
	searching = self:GetText():trim():lower()
	MerchantUpdate()
end

local function OnShow(self)
	self:SetText(SEARCH)
	searching = ""
end

local function OnEnterPressed(self)
	self:ClearFocus()
end

local function OnEscapePressed(self)
	self:ClearFocus()
	self:SetText(SEARCH)
	searching = ""
end

local function OnEditFocusLost(self)
	self:HighlightText(0, 0)
	if strtrim(self:GetText()) == "" then
		self:SetText(SEARCH)
		searching = ""
	end
end

local function OnEditFocusGained(self)
	self:HighlightText()
	if self:GetText():trim():lower() == SEARCH:lower() then
		self:SetText("")
	end
end

local search = CreateFrame("EditBox", "$parentSearch", frame, "InputBoxTemplate")
frame.search = search
search:SetSize(92, 26)
search:SetAutoFocus(false)
search:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 50, 10)
search:SetScript("OnShow", OnShow)
search:SetScript("OnTextChanged", OnTextChanged)
search:SetScript("OnEditFocusGained", OnEditFocusGained)
search:SetScript("OnEditFocusLost", OnEditFocusLost)
search:SetScript("OnEnterPressed", OnEnterPressed)
search:SetScript("OnEscapePressed", OnEscapePressed)

local function Search_OnClick(self)
	if self:GetChecked() then
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
		frame.tooltipsearching = 1
	else
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
		frame.tooltipsearching = nil
	end

	if searching ~= "" and searching ~= SEARCH:lower() then
		MerchantUpdate()
	end
end

local function Search_OnEnter(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetText(L["To browse item tooltips"])
end

local tooltipsearching = CreateFrame("CheckButton", "$parentTooltipSearching", frame, "InterfaceOptionsSmallCheckButtonTemplate")
search.tooltipsearching = tooltipsearching
tooltipsearching:SetSize(24, 24)
tooltipsearching:SetChecked(false)
tooltipsearching:SetHitRectInsets(0, 0, 0, 0)
tooltipsearching:SetPoint("LEFT", search, "RIGHT", -3, -2)
tooltipsearching:SetScript("OnClick", Search_OnClick)
tooltipsearching:SetScript("OnEnter", Search_OnEnter)
tooltipsearching:SetScript("OnLeave", GameTooltip_Hide)

local scrollframe = CreateFrame("ScrollFrame", "xMerchantScrollFrame", frame, "FauxScrollFrameTemplate")
frame.scrollframe = scrollframe
scrollframe:SetSize(284, 298)
scrollframe:SetPoint("TOPLEFT", MerchantFrame, 22, -65)
scrollframe:SetScript("OnVerticalScroll", xScrollFrame_OnVerticalScroll)

local top = frame:CreateTexture("$parentTop", "ARTWORK")
frame.top = top
top:SetSize(31, 182)
top:SetPoint("TOPRIGHT", 30, 6)
top:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-ScrollBar")
top:SetTexCoord(0, 0.484375, 0, 1)

local bottom = frame:CreateTexture("$parentBottom", "ARTWORK")
frame.bottom = bottom
bottom:SetSize(31, 182)
bottom:SetPoint("BOTTOMRIGHT", 30, -6)
bottom:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-ScrollBar")
bottom:SetTexCoord(0.515625, 1, 0, 0.421875)

local function xMerchant_InitItemsButtons()
	for i = 1, 10, 1 do
		local button = CreateFrame("Button", "xMerchantFrame"..i, frame)
		button:SetWidth(frame:GetWidth())
		button:SetHeight(kItemButtonHeight)
		button:RegisterForClicks("LeftButtonUp","RightButtonUp")
		button:RegisterForDrag("LeftButton")
		button:SetScript("OnClick", OnClick)
		button:SetScript("OnDragStart", MerchantItemButton_OnClick)
		button:SetScript("OnEnter", OnEnter)
		button:SetScript("OnHide", OnHide)
		button:SetScript("OnLeave", OnLeave)
		button.SplitStack = SplitStack
		button.UpdateTooltip = OnEnter

		if i == 1 then
			button:SetPoint("TOPLEFT", 0, -1)
		else
			button:SetPoint("TOP", buttons[i-1], "BOTTOM")
		end

		local highlight = button:CreateTexture(nil, "BACKGROUND")
		button.highlight = highlight
		highlight:SetAllPoints()
		highlight:SetBlendMode("ADD")
		highlight:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
		highlight:Hide()

		local itemname = B.CreateFS(button, 12, "", false, "TOPLEFT", 30.4, -2)
		button.itemname = itemname
		itemname:SetJustifyH("LEFT")
		itemname:SetJustifyV("TOP")
		itemname:SetWordWrap(false)

		local iteminfo = B.CreateFS(button, 12, "", false, "BOTTOMLEFT", 30.4, 2)
		button.iteminfo = iteminfo
		iteminfo:SetJustifyH("LEFT")
		iteminfo:SetJustifyV("BOTTOM")
		iteminfo:SetWordWrap(false)
		iteminfo:SetTextColor(0.5, 0.5, 0.5)

		local icon = button:CreateTexture(nil, "ARTWORK")
		button.icon = icon
		icon:SetSize(25.4, 25.4)
		icon:SetPoint("LEFT", 2, 0)
		icon:SetTexture("Interface\\Icons\\temp")

		local money = B.CreateFS(button, 15, "", false, "RIGHT", -2, 0)
		button.money = money
		money:SetJustifyH("RIGHT")
		money:SetJustifyV("MIDDLE")

		itemname:SetPoint("RIGHT", money, "LEFT", -2, 0)
		iteminfo:SetPoint("RIGHT", money, "LEFT", -2, 0)

		button.item = {}
		for j = 1, MAX_ITEM_COST, 1 do
			local item = CreateFrame("Button", "$parentItem"..j, button)
			button.item[j] = item
			item:SetSize(17, 17)
			item:RegisterForClicks("LeftButtonUp","RightButtonUp")
			item:SetScript("OnClick", Item_OnClick)
			item:SetScript("OnEnter", Item_OnEnter)
			item:SetScript("OnLeave", Item_OnLeave)
			item.hasItem = true
			item.UpdateTooltip = Item_OnEnter

			if j == 1 then
				item:SetPoint("RIGHT", -2, 0)
			else
				item:SetPoint("RIGHT", button.item[j-1], "LEFT", -2, 0)
			end

			local icon = item:CreateTexture(nil, "ARTWORK")
			item.icon = icon
			icon:SetSize(17, 17)
			icon:SetPoint("RIGHT")

			local count = B.CreateFS(item, 15, "")
			item.count = count
			count:SetPoint("RIGHT", icon, "LEFT", -2, 0)
		end

		local honor = CreateFrame("Button", "$parentHonor", button)
		button.honor = honor
		honor.itemLink = select(2, GetItemInfo(43308)) or "|cffffffff|Hitem:43308:0:0:0:0:0:0:0:0|h[Ehrenpunkte]|h|r"
		honor:SetSize(17, 17)
		honor:SetPoint("RIGHT", -2, 0)
		honor:RegisterForClicks("LeftButtonUp","RightButtonUp")
		honor:SetScript("OnClick", Item_OnClick)
		honor:SetScript("OnEnter", Item_OnEnter)
		honor:SetScript("OnLeave", Item_OnLeave)
		honor.hasItem = true
		honor.UpdateTooltip = Item_OnEnter

		local icon = honor:CreateTexture(nil, "ARTWORK")
		honor.icon = icon
		icon:SetSize(17, 17)
		icon:SetPoint("RIGHT")

		local count = B.CreateFS(honor, 15, "")
		honor.count = count
		count:SetPoint("RIGHT", icon, "LEFT", -2, 0)

		local arena = CreateFrame("Button", "$parentArena", button)
		button.arena = arena
		arena.itemLink = select(2, GetItemInfo(43307)) or "|cffffffff|Hitem:43307:0:0:0:0:0:0:0:0|h[Arenapunkte]|h|r"
		arena:SetSize(17, 17)
		arena:SetPoint("RIGHT", -2, 0)
		arena:RegisterForClicks("LeftButtonUp","RightButtonUp")
		arena:SetScript("OnClick", Item_OnClick)
		arena:SetScript("OnEnter", Item_OnEnter)
		arena:SetScript("OnLeave", Item_OnLeave)
		arena.hasItem = true
		arena.UpdateTooltip = Item_OnEnter

		local icon = arena:CreateTexture(nil, "ARTWORK")
		arena.icon = icon
		icon:SetSize(17, 17)
		icon:SetPoint("RIGHT")

		local count = B.CreateFS(arena, 15, "")
		arena.count = count
		count:SetPoint("RIGHT", icon, "LEFT", -2, 0)

		merchantFrameButtons[i] = button
		buttons[i] = button
	end
end
xMerchant_InitItemsButtons()

local function Update()
	if MerchantFrame.selectedTab == 1 then
		for i = 1, 12, 1 do
			_G["MerchantItem"..i]:Hide()
		end
		frame:Show()
		CurrencyUpdate()

		FactionsUpdate()
		MerchantUpdate()
	else
		frame:Hide()
		for i = 1, 12, 1 do
			_G["MerchantItem"..i]:Show()
		end
		if StackSplitFrame:IsShown() then
			StackSplitFrame:Hide()
		end
	end
end
hooksecurefunc("MerchantFrame_Update", Update)

local function OnHide()
	wipe(errors)
	wipe(currencies)
end
hooksecurefunc("MerchantFrame_OnHide", OnHide)

MerchantBuyBackItem:ClearAllPoints()
MerchantBuyBackItem:SetPoint("BOTTOMLEFT", 175, 32)

for _, frame in next, { MerchantNextPageButton, MerchantPrevPageButton, MerchantPageText } do
	frame:Hide()
	frame.Show = function() end
end

-- Aurora Reskin
if IsAddOnLoaded("Aurora") then
	local F, C= unpack(Aurora)
	search:SetSize(122, 20)
	search:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 10, 13)
	tooltipsearching:SetSize(28, 28)
	tooltipsearching:SetPoint("LEFT", search, "RIGHT", 0, 0)
	MerchantBuyBackItem:SetPoint("BOTTOMLEFT", 169, 28)
	F.ReskinInput(search)
	F.ReskinCheck(tooltipsearching)
	F.ReskinScroll(xMerchantScrollFrameScrollBar)
	xMerchantFrameTop:Hide()
	xMerchantFrameBottom:Hide()

	for i = 1, 10, 1 do
		local bu = _G["xMerchantFrame"..i]
		local ic = bu.icon
		F.ReskinIcon(ic)
	end
end