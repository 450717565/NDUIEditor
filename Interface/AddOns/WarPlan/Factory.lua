local Factory, _, T = {}, ...
local Nine = T.Nine or _G
local EV, W, L, C = T.Evie, T.WrappedAPI, T.L, Nine.C_Garrison

local function CreateObject(otype, ...)
	return Factory[otype](...)
end
T.CreateObject = CreateObject

local CreateEdge do
	local edgeSlices = {
		{"TOPLEFT", 0, -1, "BOTTOMRIGHT", "BOTTOMLEFT", 1, 1}, -- L
		{"TOPRIGHT", 0, -1, "BOTTOMLEFT", "BOTTOMRIGHT", -1, 1}, -- R
		{"TOPLEFT", 1, 0, "BOTTOMRIGHT", "TOPRIGHT", -1, -1, ccw=true}, -- T
		{"BOTTOMLEFT", 1, 0, "TOPRIGHT", "BOTTOMRIGHT", -1, 1, ccw=true}, -- B
		{"TOPLEFT", 0, 0, "BOTTOMRIGHT", "TOPLEFT", 1, -1},
		{"TOPRIGHT", 0, 0, "BOTTOMLEFT", "TOPRIGHT", -1, -1},
		{"BOTTOMLEFT", 0, 0, "TOPRIGHT", "BOTTOMLEFT", 1, 1},
		{"BOTTOMRIGHT", 0, 0, "TOPLEFT", "BOTTOMRIGHT", -1, 1}
	}
	function CreateEdge(f, info, bgColor, edgeColor)
		local insets = info.insets
		local es = info.edgeFile and (info.edgeSize or 39) or 0
		if info.bgFile then
			local bg = f:CreateTexture(nil, "BACKGROUND", nil, -7)
			local tileBackground = not not info.tile
			bg:SetTexture(info.bgFile, tileBackground, tileBackground)
			bg:SetPoint("TOPLEFT", (insets and insets.left or 0), -(insets and insets.top or 0))
			bg:SetPoint("BOTTOMRIGHT", -(insets and insets.right or 0), (insets and insets.bottom or 0))
			local n = bgColor or 0xffffff
			bg:SetVertexColor((n - n % 2^16) / 2^16 % 256 / 255, (n - n % 2^8) / 2^8 % 256 / 255, n % 256 / 255, n >= 2^24 and (n - n % 2^24) / 2^24 % 256 / 255 or 1)
		end
		if info.edgeFile then
			local n = edgeColor or 0xffffff
			local r,g,b,a = (n - n % 2^16) / 2^16 % 256 / 255, (n - n % 2^8) / 2^8 % 256 / 255, n % 256 / 255, n >= 2^24 and (n - n % 2^24) / 2^24 % 256 / 255 or 1
			for i=1,#edgeSlices do
				local t, s = f:CreateTexture(nil, "BORDER", nil, -7), edgeSlices[i]
				t:SetTexture(info.edgeFile)
				t:SetPoint(s[1], s[2]*es, s[3]*es)
				t:SetPoint(s[4], f, s[5], s[6]*es, s[7]*es)
				local x1, x2, y1, y2 = 1/128+(i-1)/8, i/8-1/128, 0.0625, 1-0.0625
				if s.ccw then
					t:SetTexCoord(x1,y2, x2,y2, x1,y1, x2,y1)
				else
					t:SetTexCoord(x1, x2, y1, y2)
				end
				t:SetVertexColor(r,g,b,a)
			end
		end
	end
end

local CONFIRM_ON_USE_BUTTON
local PROGRESS_MIN_STEP = 0.2
local currencyMeterFrame
local function HideOwnGameTooltip(self)
	if GameTooltip:IsOwned(self) then
		GameTooltip:Hide()
	end
end
local function CommonTooltip_OnEnter(self)
	local showCurrencyBar = false
	GameTooltip:SetOwner(self, self.tooltipAnchor or "ANCHOR_TOP")
	if type(self.mechanicInfo) == "table" then
		local ic, m = self.Icon and self.Icon:GetTexture(), self.mechanicInfo
		ic = ic or m.icon
		GameTooltip:SetText((ic and "|T" .. ic .. ":0:0:0:0:64:64:4:60:4:60|t " or "") .. m.name)
		if (m.enemy or "") ~= "" then
			GameTooltip:AddLine("|cff49C8F2" .. m.enemy)
		elseif (m.description or "") ~= "" then
			GameTooltip:AddLine(m.description, 1,1,1,1)
		end
		if type(m.ability) == "table" then
			local a = m.ability
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine((a.icon and "|T" .. a.icon .. ":0|t " or "") .. a.name)
			if (a.description or "") ~= "" then
				GameTooltip:AddLine(a.description, 1,1,1,1)
			end
		end
	elseif self.itemID then
		GameTooltip:SetItemByID(self.itemID)
	elseif self.tooltipHeader and self.tooltipText then
		GameTooltip:AddLine(self.tooltipHeader)
		GameTooltip:AddLine(self.tooltipText, 1,1,1, 1)
		showCurrencyBar = not not (self.currencyID)
	elseif self.currencyID then
		GameTooltip:SetCurrencyByID(self.currencyID)
	elseif self.achievementID then
		local self, achievementID, highlightAsset = GameTooltip, self.achievementID, self.assetID
		local _, n, _points, c, _, _, _, description, _, _icon, _, _, wasEarnedByMe, _earnedBy =
			GetAchievementInfo(achievementID)
		self:SetText(n)
		if not c or not wasEarnedByMe then
			self:AddLine(ACHIEVEMENT_TOOLTIP_IN_PROGRESS:format(UnitName("player")), 0.1, 0.9, 0.1)
			self:AddLine(" ")
		end
		self:AddLine(description, 1,1,1,1)
		local nc = GetAchievementNumCriteria(achievementID)
		for i=1,nc,2 do
			local n1, _, c1, _, _, _, _, asid = GetAchievementCriteriaInfo(achievementID, i)
			n1 = (asid == highlightAsset and "|cffffea00" or c1 and "|cff20c020" or "|cffa8a8a8") .. n1
			if i == nc then
				self:AddLine(n1)
			else
				local n2, _, c2, _, _, _, _, asid = GetAchievementCriteriaInfo(achievementID, i+1)
				n2 = (asid == highlightAsset and "|cffffea00" or c2 and "|cff20c020" or "|cffa8a8a8") .. n2
				self:AddDoubleLine(n1, n2)
			end
		end
	else
		GameTooltip:Hide()
		return
	end
	if self.tooltipExtra then
		GameTooltip:AddLine(self.tooltipExtra, 1,1,1)
	end
	GameTooltip:Show()
	if showCurrencyBar then
		currencyMeterFrame = currencyMeterFrame or CreateObject("CurrencyMeter")
		currencyMeterFrame:Activate(GameTooltip, self.currencyID, self.currencyQ)
	end
end
local function CommonLinkable_OnClick(self)
	if not IsModifiedClick("CHATLINK") then
	elseif self.achievementID then
		ChatEdit_InsertLink(GetAchievementLink(self.achievementID))
	elseif self.itemID then
		local _, link = GetItemInfo(self.itemID)
		if link then
			ChatEdit_InsertLink(link)
		end
	elseif self.currencyID and self.currencyID ~= 0 then
		ChatEdit_InsertLink(Nine.GetCurrencyLink(self.currencyID, self.currencyAmount or 0))
	end
end
local function Button_ClickWithSpace(self, button)
	self:SetPropagateKeyboardInput(button ~= "SPACE")
	if button == "SPACE" then
		self:Click()
	end
end
local function Ability_OnEnter(self)
	if self.abilityID and self.abilityID > 0 then
		GarrisonFollowerAbilityTooltip:ClearAllPoints()
		GarrisonFollowerAbilityTooltip:SetPoint("TOPLEFT", self.Icon, "BOTTOMRIGHT")
		GarrisonFollowerAbilityTooltip_Show(GarrisonFollowerAbilityTooltip, self.abilityID, 22)
		GarrisonFollowerAbilityTooltip.CounterIcon:SetMask(nil)
		GarrisonFollowerAbilityTooltip.CounterIcon:SetTexCoord(4/64, 60/64, 4/64, 60/64)
	end
end
local function Ability_OnLeave(self)
	if GameTooltip:IsOwned(self) then
		GameTooltip:Hide()
	else
		GarrisonFollowerAbilityTooltip:Hide()
	end
end
local function ChampionList_UpdateEquipmentGlow(self)
	local isVisible = self:IsVisible()
	self[isVisible and "RegisterEvent" or "UnregisterEvent"](self, "CURSOR_UPDATE")
	self[isVisible and "RegisterEvent" or "UnregisterEvent"](self, "CURRENT_SPELL_CAST_CHANGED")
	local Champions = self:GetParent().Champions
	for i=1,isVisible and #Champions or 0 do
		local c = Champions[i]
		local fid, abilities = c.followerID, c.Abilities
		for i=1, #abilities do
			local a = abilities[i]
			local maid = a.mutableAbilityID
			local canTarget = fid and maid and (
				ItemCanTargetGarrisonFollowerAbility(fid, maid) or
				SpellCanTargetGarrisonFollowerAbility(fid, maid)
			) or false
			a.EquipmentGlow:SetShown(canTarget)
			local canUse = fid and C.GetFollowerStatus(fid) ~= GARRISON_FOLLOWER_ON_MISSION
			a.EquipmentGlow:SetAtlas(canUse and "GarrMission-AbilityHighlight" or "GarrMission-AbilityHighlight-Error")
		end
	end
end
local function Equipment_PostClick(self)
	self:SetScript("PostClick", nil)
	self:SetAttribute("type", nil)
	self:SetAttribute("macrotext", nil)
	local maid = self.mutableAbilityID
	local fid = maid and self:GetParent():GetParent().followerID
	if maid and fid and SpellCanTargetGarrisonFollowerAbility(fid, maid) then
		EV("I_ARM_FOLLOWER_UPDATE", fid)
		C.CastSpellOnFollowerAbility(fid, maid)
	end
end
local function Equipment_PreClick(self)
	if IsModifiedClick("CHATLINK") and self.abilityID then
		ChatEdit_InsertLink(C.GetFollowerAbilityLink(self.abilityID))
		return
	end
	local maid = self.mutableAbilityID
	local fid = maid and self:GetParent():GetParent().followerID
	local canUse = fid and C.GetFollowerStatus(fid) ~= GARRISON_FOLLOWER_ON_MISSION
	if InCombatLockdown() or not (maid and fid and canUse) then
		return
	end
	if ItemCanTargetGarrisonFollowerAbility(fid, maid) then
		-- C.CastItemSpellOnFollowerAbility is protected, so we need to do a little dance:
		local _, itemID = GetCursorInfo()
		-- Champion equipment is flagged as bind-on-use, so /use item:id will fire USE_BIND_CONFIRM
		-- rather than doing anything actually useful. USE_BIND_CONFIRM won't fire if there's still an item
		-- on the cursor, so clear the cursor (this should be protected, but isn't). Then, clear the current
		-- spell cast to make sure we don't disenchant/scrap/whatever the item in the eventual UseItemByName
		-- call. CONFIRM_ON_USE_BUTTON will find and dismiss the confirmation popup if USE_BIND_CONFIRM fires
		-- between it being armed and clicked.
		ClearCursor()
		CONFIRM_ON_USE_BUTTON = CONFIRM_ON_USE_BUTTON or CreateObject("ConfirmOnUseButton")
		self:SetAttribute("type", "macro")
		self:SetAttribute("macrotext", SLASH_STOPSPELLTARGET1 .. "\n" .. SLASH_USE1 .. " item:" .. itemID .. "\n" .. SLASH_CLICK1 .. " " .. CONFIRM_ON_USE_BUTTON:GetName())
		self:SetScript("PostClick", Equipment_PostClick)
		CONFIRM_ON_USE_BUTTON:Arm()
		-- The item can then be equipped by calling C.CastSpellOnFollowerAbility insecurely.
	elseif SpellCanTargetGarrisonFollowerAbility(fid, maid) then
		self:SetScript("PostClick", Equipment_PostClick)
	end
end
local function Equipment_SetEquipment(self, isEquipment, isLocked, abilityID)
	self.mutableAbilityID = isEquipment and not isLocked and abilityID
	self.EquipmentBorder:SetShown(isEquipment)
	if self:IsMouseOver() then
		Ability_OnEnter(self)
	end
end
local function Progress_UpdateTimer(self)
	local now, endTime = GetTime(), self.endTime
	if endTime <= now then
		self.Fill:SetWidth(self:GetWidth())
		self:SetScript("OnUpdate", nil)
		if self.endText then
			self.Text:SetText(self.endText)
		end
		if self.endMotion then
			self:SetMouseMotionEnabled(true)
		end
		self.endTime, self.duration, self.endText, self.nextUp = nil
	elseif (self.nextUp or 0) < now then
		local w, d = self:GetWidth(), self.duration
		self.Fill:SetWidth(math.max(0.01, w*(1-(endTime-now)/d)))
		self.nextUp = now + (PROGRESS_MIN_STEP/w * d)
	end
end
local function Progress_SetProgress(self, progress)
	self.Fill:SetWidth(math.max(0.01,self:GetWidth()*progress))
	self.endTime, self.duration, self.endText, self.endMotion, self.nextUp = nil
	self:SetScript("OnUpdate", nil)
end
local function Progress_SetTimer(self, endTime, duration, endText, endMotion)
	self.endTime, self.duration, self.endText, self.endMotion, self.nextUp = endTime, duration, endText, endMotion == true or nil, nil
	self:SetScript("OnUpdate", Progress_UpdateTimer)
	Progress_UpdateTimer(self)
end
local function Champion_OnUpdate(self)
	if not self:IsMouseOver() then
		self.Highlight:Hide()
		self:SetScript("OnUpdate", nil)
	end
end
local function Champion_OnEnter(self)
	if not self.selectDisabled then
		self.Highlight:Show()
		self:SetScript("OnUpdate", Champion_OnUpdate)
	end
end
local function ToggleChampionOnClick(self, button)
	if IsModifiedClick("CHATLINK") and button == "LeftButton" then
		ChatEdit_InsertLink(C.GetFollowerLink(self.followerID))
	elseif button == "LeftButton" then
		EV("I_TOGGLE_FOLLOWER_FOCUS", self.followerID, self.selectDisabled)
	elseif button == "RightButton" then
		local tmid = W.GetFollowerTentativeGroup(self.followerID)
		if tmid then
			W.SetTentativeGroup(tmid, nil)
			local oe = self:GetScript("OnEnter")
			if oe and self:IsMouseOver() then
				oe(self)
			end
		end
	end
end
local function TroopButton_OnEnter(self)
	if not self.selectDisabled then
		self.Highlight1:Show()
	end
	if self.followerID then
		local fid, gfid, NC = self.followerID, self.gfollowerID, NORMAL_FONT_COLOR
		GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
		local rc = fid and ITEM_QUALITY_COLORS[C.GetFollowerQuality(fid)] or nil
		GameTooltip:SetText(C.GetFollowerName(fid), rc and rc.r, rc and rc.g, rc and rc.b)
		GameTooltipTextRight1:SetText("|T" .. C.GetFollowerPortraitIconID(fid) .. ":42:42:4:-22:1:1:1:0:0:1|t")
		GameTooltipTextRight1:Show()
		if gfid then
			GameTooltip:AddLine("|cff49C8F2" .. (C.GetFollowerClassSpecName(self.gfollowerID) or "?"))
		end
		for i=1,3 do
			local eid = C.GetFollowerAbilityAtIndex(fid, i)
			local lid = eid == 0 and gfid and C.GetFollowerAbilityAtIndexByID(gfid, i)
			local aid = eid ~= 0 and eid or lid
			if aid and aid > 0 then
				local an, ic, ad = C.GetFollowerAbilityName(aid), C.GetFollowerAbilityIcon(aid), C.GetFollowerAbilityDescription(aid)
				ic = aid == eid and "|T" .. ic .. ":0:0:0:0:64:64:4:60:4:60|t " or [[|TInterface\PetBattles\PetBattle-LockIcon:14:12:0:1:32:32:4:28:2:30:255:155:100|t |cff909090]]
				GameTooltip:AddLine(" ")
				GameTooltip:AddLine(ic .. an, 1,1,1,1)
				GameTooltip:AddLine(ad, NC.r, NC.g, NC.b, 1)
			end
		end
		local tmid = W.GetFollowerTentativeGroup(self.followerID)
		if self.missionID then
			local prefix = self.isEffectivelyDead and "|TInterface\\EncounterJournal\\UI-EJ-Icons:18:18:-2:2:256:64:134:154:4:24|t" or ""
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine(prefix .. GARRISON_FOLLOWER_ON_MISSION .. " - " .. (C.GetMissionName(self.missionID) or self.missionID), 1, 0.40, 0.10)
		elseif tmid then
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine("|cff66D9FF" .. L"In Tentative Group:" .. " " .. (C.GetMissionName(tmid) or tmid), 1, 0.40, 0.10)
		end
		GameTooltip:Show()
	end
end
local function TroopButton_OnLeave(self)
	self.Highlight1:Hide()
	return HideOwnGameTooltip(self)
end
local function TroopButton_SetDurability(self, maxDurability, returnDurability)
	self.Hearts[1]:SetDesaturated(returnDurability < 1)
	self.Hearts[2]:SetDesaturated(returnDurability < 2)
	self.Hearts[3]:SetDesaturated(returnDurability ~= 3)
	self.Hearts[3]:SetShown(maxDurability == 3)
	self:SetWidth(maxDurability == 3 and 55 or 38)
end
local function ResourceButton_Update(self, _event, currencyID, quant)
	if currencyID == self.currencyID then
		quant = quant or select(2, Nine.GetCurrencyInfo(currencyID))
		if quant then
			self.Text:SetText(BreakUpLargeNumbers(quant))
			self:SetWidth(self.Text:GetStringWidth()+26)
		end
	end
end
local function ResourceButton_OnClick(self)
	if IsModifiedClick("CHATLINK") then
		ChatEdit_InsertLink(Nine.GetCurrencyLink(self.currencyID, 24))
	end
end
local function GroupButton_OnEnter(self)
	EV("I_HIGHLIGHT_GROUP", self.group)
end
local function GroupButton_OnLeave()
	EV("I_HIGHLIGHT_GROUP", nil)
end
local function GroupButton_OnClick(self, button)
	local g, mid = self.group, self:GetParent().missionID
	if button == "LeftButton" then
		W.EnqueueMissionStart(mid, g)
		PlaySound(44323)
	else
		W.SetTentativeGroup(mid, g)
		PlaySound(44315)
	end
end
local function Mission_OnClick(self)
	if IsModifiedClick("CHATLINK") and self.missionID then
		ChatEdit_InsertLink(C.GetMissionLink(self.missionID))
	else
		if self.missionID and self.ProgressBar:IsShown() and self.completableAfter and self.completableAfter <= GetTime()
		   and (self.ProgressBar:IsMouseOver(6, -6, -6, 6) or self.RewardChest:IsMouseOver()) then
			self:GetParent():GetParent():GetParent():CompleteMission(self.missionID)
		else
			self:GetParent():GetParent():ScrollToward(self)
		end
	end
end
local function CountdownText_OnUpdate(self)
	local now = GetTime()
	if now >= self.cdtTick then
		local cdTo = self.cdtTo
		local secsLeft = cdTo-now
		if secsLeft <= 0 then
			self.CDTDisplay:SetText(self.cdtRest)
			self:SetScript("OnUpdate", nil)
			self.cdtTick, self.cdtTo = nil
		else
			self.cdtTick = secsLeft < 120 and (now + secsLeft % 0.5 + 0.01) or (now + secsLeft % 60 + 0.01)
			self.CDTDisplay:SetText(self.cdtPrefix .. W.GetTimeStringFromSeconds(secsLeft, self.cdtShort, self.cdtRoundedUp) .. self.cdtSuffix .. self.cdtRest)
		end
	end
end
local function CountdownText_SetCountdown(self, prefix, expireAt, suffix, rest, isShort, isRoundUp)
	prefix, suffix, rest = prefix or "", suffix or "", rest or ""
	local now = GetTime()
	if not (expireAt and expireAt > now) then
		self.CDTDisplay:SetText(rest or "")
		self:SetScript("OnUpdate", nil)
	else
		self.cdtTick, self.cdtPrefix, self.cdtTo, self.cdtSuffix, self.cdtRest, self.cdtShort, self.cdtRoundedUp = now, prefix, expireAt, suffix, rest, isShort == true, isRoundUp == true
		self:SetScript("OnUpdate", CountdownText_OnUpdate)
		CountdownText_OnUpdate(self)
	end
end
local function MissionList_ScrollToward(self, obj)
	if obj:GetBottom() < self:GetBottom() then
		self:GetScript("OnMouseWheel")(self, -1)
	elseif obj:GetTop() > self:GetTop() then
		self:GetScript("OnMouseWheel")(self, 1)
	end
end
local function MissionList_AcquireToast(self)
	local toasts, toast = self.Toasts
	for i=1,#toasts do
		toast = toasts[i]
		if not toast:IsShown() then
			break
		end
		toast = nil
	end
	if not toast then
		toast = CreateObject("MissionToast", toasts[1]:GetParent())
		toast:SetPoint("TOP", toasts[#toasts], "BOTTOM", 0, -5)
		toasts[#toasts+1] = toast
	end
	toast.Icon:SetTexCoord(4/64, 60/64, 4/64, 60/64)
	toast.animStart, toast.animPhase = nil
	toast:Show()
	return toast
end
local function HistoryFrame_CheckMouse(self)
	if self:IsMouseOver(32, -10, -8, 4) then
		self.leaveGrace = nil
	elseif self.leaveGrace == nil then
		self.leaveGrace = GetTime()+0.1
	elseif self.leaveGrace < GetTime() then
		self:Hide()
	end
end
local function HistoryFrame_UpdateDisplay(self)
	local lastEntry = W.GetNumCompletionHistoryEntries()
	local ofs = self.offset or 0
	for i=1,#self.Entries do
		local e, comAt, mid, chance, baseOK, bonusOK, baseInfo, bonusInfo, ex1, ex2, ex3 = self.Entries[i], W.GetCompletionHistoryEntry(i+ofs)
		if mid then
			e:SetID(i+ofs)
			e.Name:SetText(C.GetMissionName(mid))
			local color = baseOK and (bonusOK and "|cff00aaff" or "|cff00e000") or "|cffff0000"
			local ago = W.GetLazyTimeStringFromSeconds(GetServerTime() - comAt)
			local extra, excount = "", (ex1 and 1 or 0) + (ex2 and 1 or 0) + (ex3 and 1 or 0)
			if excount > 0 then
				extra = "|cffffa020" .. ("+"):rep(excount) .. "|r"
			end
			e.Detail:SetFormattedText("%s%d%%|r%s - %s", color, chance, extra, (L"Completed %s ago"):format("|cfff0f0f0" .. ago .. "|r"))
			local k1, i1, q1, icon = W.UnpackHistoryReward(baseInfo or bonusInfo)
			local k2, i2, q2 = W.UnpackHistoryReward(baseInfo and bonusInfo)
			e.Icon:SetTexture(icon or "Interface/Icons/Temp")
			local q = q1 + (baseOK and bonusOK and k2 == k1 and i1 == i2 and q2 or 0)
			if k1 == "gold" then
				q = math.floor(q/1e4)
			elseif k1 == "currency" then
				local ci = C_CurrencyInfo.GetCurrencyContainerInfo(i1, q)
				if ci and ci.icon then
					e.Icon:SetTexture(ci.icon)
				end
			end
			e.Quantity:SetText(q and q > 1 and q or "")
		end
		e:SetShown(not not mid)
	end
	self.ScrollUpButton:SetEnabled(ofs > 0)
	self.ScrollDownButton:SetEnabled((ofs+#self.Entries) < lastEntry)
	self.NoHistory:SetShown(lastEntry == 0)
end
local function HistoryFrame_OnShow(self)
	self.leaveGrace = nil
	return HistoryFrame_UpdateDisplay(self)
end
local function HistoryFrame_Scroll(self, d)
	local lastEntry = W.GetNumCompletionHistoryEntries()
	local oldOffset = self.offset or 0
	local newOffset = math.max(0, math.min(lastEntry-#self.Entries, oldOffset - d*(#self.Entries/2)))
	self.offset = newOffset
	if newOffset ~= oldOffset then
		HistoryFrame_UpdateDisplay(self)
	end
end
local function HistoryFrame_ScrollClick(self)
	PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON)
	return HistoryFrame_Scroll(self:GetParent(), (self:GetID()-2))
end
local function MissionTable_SpawnMissionButton(arr, i)
	local prev = type(i) == "number" and rawget(arr, i-1)
	if type(prev) == "table" then
		local cf = CreateObject("MissionButton", prev:GetParent())
		arr[i] = cf
		cf:SetPoint("TOPLEFT", 222*(((i-1)%4)+1)-220, math.floor((i-1)/4) *- 282)
		return cf
	end
end
local function Toast_SetMissionHistory(self, historyIndex)
	local _comAt, mid, chance, baseOK, bonusOK, baseInfo, _bonusInfo = W.GetCompletionHistoryEntry(historyIndex)
	local _, _, _, icon = W.UnpackHistoryReward(baseInfo)
	local resText
	if not baseOK then
		resText = "|cffff0000" .. L"Mission Failure"
		self.Sheen:SetVertexColor(0, 1, 0)
		self.PreGlow:SetVertexColor(1, 0.90, 0.90)
	elseif not bonusOK then
		resText = "|cff00e000" .. L"Mission Success"
		self.Sheen:SetVertexColor(0, 0.85, 0)
		self.PreGlow:SetVertexColor(0.9, 1, 0.9)
	else
		resText = "|cff00aaff" .. L"Grand Success"
		self.Sheen:SetVertexColor(0, 0.66, 1)
		self.PreGlow:SetVertexColor(0.80, 0.90, 1)
	end
	self.Outcome:SetText(resText)
	self.Detail:SetFormattedText("%s |cffa0a0a0(%d%%)", C.GetMissionName(mid) or "It's a Mystery to Everyone", chance)
	self.Icon:SetTexture(icon or "Interface/Icons/Temp")
	return baseOK, bonusOK
end
local function Toast_Animate(self, elapsed)
	local now, as, ap, d = GetTime(), self.animStart, self.animPhase
	if as and elapsed > 0.04 then
		as = as + elapsed - 0.04
		self.animStart = as
	end
	if ap == nil then
		self.animPhase, self.animStart = 1, nil
		self:SetAlpha(0)
		return
	elseif as == nil then
		self.animStart, as = now, now
		self:SetAlpha(1)
	end
	d = now-as
	if d < 0.5 then
		self.PreGlow:SetAlpha(d < 0.25 and (d < 0.125 and d*8 or 2-d*8)*0.75 or 0)
		self.Background:SetAlpha(d < 0.15 and sin(20+70*d/0.15) or 1)
		self.Sheen:SetAlpha(sin(360*d))
		self.Sheen:SetPoint("LEFT", 480*d, -1)
	elseif d >= 4 then
		self:Hide()
	elseif self:IsMouseOver() then
		self.animStart = now-2
		if ap ~= 2 then
			self.animPhase = 2
			self.PreGlow:SetAlpha(0)
			self.Background:SetAlpha(1)
			self.Sheen:SetAlpha(0)
			self:SetAlpha(1)
		end
	elseif d >= 3 then
		self:SetAlpha(cos(90*(d-3)))
		self.animPhase = 3
	elseif ap ~= 2 then
		self.animPhase = 2
		self.PreGlow:SetAlpha(0)
		self.Background:SetAlpha(1)
		self.Sheen:SetAlpha(0)
	end
end
local function Toast_OnClick(self, button)
	if button == "RightButton" then
		self.animPhase, self.animStart = nil
		self:Hide()
	end
end
local function CurrencyMeter_Update(self)
	local p = self:GetParent()
	local pt, sb, pw = p:GetTop(), self:GetBottom(), p:GetWidth()
	if pt and sb then
		p:SetHeight(pt-sb+8)
	end
	if pw then
		self:SetWidth(pw - 20)
	end
	self.Bar:SetProgress(self.pv)
	self.Fill2:SetWidth(self.Bar:GetWidth()*self.v2)
end
local function CurrencyMeter_Activate(self, tip, currencyID, q1)
	local factionID, cur, max, label = W.CURRENCY_FACTION_ID[currencyID]
	if factionID then
		if C_Reputation.IsFactionParagon(factionID) then
			label, cur, max = _G["FACTION_STANDING_LABEL8" .. (UnitSex("player") ~= 2 and "_FEMALE" or "")], C_Reputation.GetFactionParagonInfo(factionID)
			cur = cur % max
		else
			local _, _, stID, bMin, bMax, bVal  = GetFactionInfoByID(factionID)
			if stID and bMin then
				cur, max, label = bVal - bMin, bMax-bMin, _G["FACTION_STANDING_LABEL" .. stID .. (UnitSex("player") ~= 2 and "_FEMALE" or "")]
			end
		end
	elseif currencyID == 1553 and not C_AzeriteItem.IsAzeriteItemAtMaxLevel() then
		local aloc = C_AzeriteItem.FindActiveAzeriteItem()
		local ok, level = pcall(C_AzeriteItem.GetPowerLevel, aloc)
		if ok and level then
			label, cur, max = HEART_OF_AZEROTH_LEVEL:format(level), C_AzeriteItem.GetAzeriteItemXPInfo(aloc)
		end
	end
	if not (cur and max) then
		return
	end
	label = label .. " - " .. BreakUpLargeNumbers(cur) .. " / " .. BreakUpLargeNumbers(max)
	self.pv = cur/max
	self.v2 = math.max(0.00001, math.min(1-self.pv, (q1 or 0)/max))
	self.Bar.Text:SetText(label)
	self.Fill2:SetAtlas((cur+ (q1 or 0)) > max and "UI-Frame-Bar-Fill-Green" or "UI-Frame-Bar-Fill-Yellow")
	self:SetParent(tip)
	local lastLine = _G[tip:GetName() .. "TextLeft" .. tip:NumLines()]
	self:SetPoint("TOPLEFT", lastLine, "BOTTOMLEFT", 0, -2)
	self:Show()
	tip:Show()
	CurrencyMeter_Update(self)
end
local function CurrencyMeter_OnHide(self)
	self:Hide()
	self:SetParent(nil)
	self:ClearAllPoints()
end
local function Mirror(tex, swapH, swapV)
	local ulX, ulY, llX, llY, urX, urY, lrX, lrY = tex:GetTexCoord()
	if swapH then
		ulX, ulY, llX, llY, urX, urY, lrX, lrY = urX, urY, lrX, lrY, ulX, ulY, llX, llY
	end
	if swapV then
		ulX, ulY, llX, llY, urX, urY, lrX, lrY = llX, llY, ulX, ulY, lrX, lrY, urX, urY
	end
	tex:SetTexCoord(ulX, ulY, llX, llY, urX, urY, lrX, lrY)
	return tex
end
local function HideGrandparent(self)
	self:GetParent():GetParent():Hide()
end

local function ChampionList_EnableStaticAnchors(self)
	local listContainer = self:GetParent()
	local cl = listContainer:GetParent().Champions
	for i=1,#cl do
		cl[i]:SetPoint("LEFT", 182*i-182, 0)
	end
	listContainer:SetScript("OnUpdate", nil)
end
local function ChampionList_AnimateDynamicAnchors(listContainer, elapsed)
	local aLeft = listContainer.animLeft
	if not elapsed then
		listContainer.goalView, aLeft, listContainer.animLeft = true, nil
	elseif aLeft then
		aLeft = elapsed and aLeft > elapsed and aLeft - elapsed or nil
		listContainer.animLeft = aLeft
	end
	if listContainer:IsMouseOver() then
		local x, s, l, _b, w = GetCursorPosition(), listContainer:GetEffectiveScale(), listContainer:GetRect()
		x = (x/s-l)/w
		if (x < 0.188 or x > 0.62) and (listContainer.goalView ~= (x > 0.62)) then
			listContainer.goalView, aLeft = x > 0.62, elapsed and 0.2 or nil
			listContainer.animLeft = aLeft
		end
	end
	local cl, view = listContainer:GetParent().Champions, listContainer.goalView
	local left1, left2 = 0, 0
	local p = aLeft and (1-aLeft/0.2) or 1
	p = p*p*(3-2*p)
	if not view then p = 1-p end
	local q = 1-p
	for i=1,#cl do
		local cf = cl[i]
		cf:SetPoint("LEFT", left1*p+left2*q, 0)
		left1 = left1 + (i < 3 and 88 or 183)
		left2 = left2 + (i > 3 and 88 or 183)
	end
end
local function ChampionList_EnableDynamicAnchors(self)
	local listContainer = self:GetParent()
	listContainer:SetScript("OnUpdate", ChampionList_AnimateDynamicAnchors)
	ChampionList_AnimateDynamicAnchors(listContainer, nil)
end

do -- Factory.ObjectGroup
	local NamedMethodCallCache = setmetatable({}, {__index=function(t,k)
		t[k] = function(self, ...)
			for i=1,#self do
				local o = self[i]
				securecall(o[k], o, ...)
			end
		end
		return t[k]
	end})
	local ObjectGroup_Meta = {__index=function(t,k)
		if type(k) == "string" and type(t[1]) == "table" and type(t[1][k]) == "function" then
			t[k] = NamedMethodCallCache[k]
			return t[k]
		end
	end}
	function Factory.ObjectGroup(...)
		return setmetatable({...}, ObjectGroup_Meta)
	end
end
function Factory.TexSlice(parent, layer,subLevel, tex,tW,tH, x0,x1,x2,x3, y0,y1,y2,y3, xS,yS, oT,oR,oB,oL)
	local r, ni, t = CreateObject("ObjectGroup"), 1
	for i=1,yS == 0 and 3 or 9 do
		r[i] = parent:CreateTexture(nil, layer, nil, subLevel)
	end
	r:SetTexture(tex)
	
	x0,x1,x2,x3=x0/tW,x1/tW,x2/tW,x3/tW
	y0,y1,y2,y3=y0/tH,y1/tH,y2/tH,y3/tH
	
	if yS > 0 then
		t, ni = r[ni], ni + 1
		t:SetTexCoord(x0, x1, y0, y1)
		t:SetPoint("TOPLEFT", -oL, oT)
		t:SetSize(xS, yS)
		t, ni = r[ni], ni + 1
		t:SetTexCoord(x1, x2, y0, y1)
		t:SetPoint("TOPLEFT", xS-oL, oT)
		t:SetPoint("BOTTOMRIGHT", parent, "TOPRIGHT", oR-xS, oT-yS)
		t, ni = r[ni], ni + 1
		t:SetTexCoord(x2, x3, y0, y1)
		t:SetPoint("TOPRIGHT", oR, oT)
		t:SetSize(xS, yS)
	end
	t, ni = r[ni], ni + 1
	t:SetTexCoord(x0, x1, y1, y2)
	t:SetPoint("TOPLEFT", -oL, oT-yS)
	t:SetPoint("BOTTOMRIGHT", parent, "BOTTOMLEFT", xS-oL, yS-oB)
	t, ni = r[ni], ni + 1
	t:SetTexCoord(x1, x2, y1, y2)
	t:SetPoint("TOPLEFT", xS-oL, oT-yS)
	t:SetPoint("BOTTOMRIGHT", -xS+oR, yS-oB)
	t, ni = r[ni], ni + 1
	t:SetTexCoord(x2, x3, y1, y2)
	t:SetPoint("TOPLEFT", parent, "TOPRIGHT", oR-xS, oT-yS)
	t:SetPoint("BOTTOMRIGHT", oR, yS-oB)
	if yS > 0 then
		t, ni = r[ni], ni + 1
		t:SetTexCoord(x0, x1, y2, y3)
		t:SetPoint("BOTTOMLEFT", -oL, -oB)
		t:SetSize(xS, yS)
		t, ni = r[ni], ni + 1
		t:SetTexCoord(x1, x2, y2, y3)
		t:SetPoint("BOTTOMLEFT", -oL+xS, -oB)
		t:SetPoint("TOPRIGHT", parent, "BOTTOMRIGHT", oR-xS, yS-oB)
		t, ni = r[ni], ni + 1
		t:SetTexCoord(x2, x3, y2, y3)
		t:SetPoint("BOTTOMRIGHT", oR, -oB)
		t:SetSize(xS, yS)
	end
	
	return r
end
function Factory.RewardFrame(parent)
	local f, t = CreateObject("CommonHoverTooltip", CreateFrame("Button", nil, parent))
	f:SetSize(48, 48)
	t = f:CreateTexture(nil, "ARTWORK")
	t:SetAllPoints()
	t:SetTexture("Interface/Icons/Temp")
	t, f.Icon = f:CreateTexture(nil, "ARTWORK", nil, 2), t
	t:SetAllPoints()
	t:SetAtlas("loottoast-itemborder-orange")
	t, f.RarityBorder = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightOutline"), t
	t:SetPoint("BOTTOMRIGHT", -4, 5)
	t, f.Quantity = f:CreateTexture(nil, "ARTWORK", nil, 3), t
	t:SetPoint("TOP", 0, 7)
	t:SetSize(20, 20)
	t:SetAtlas("VignetteLoot")
	f.OvermaxRewardIcon = t
	f:SetScript("OnClick", CommonLinkable_OnClick)
	return f
end
function Factory.MissionThreat(parent)
	local f, t = CreateObject("CommonHoverTooltip", CreateFrame("Frame", nil, parent))
	f:SetSize(28, 28)
	t = f:CreateTexture(nil, "ARTWORK")
	t:SetAllPoints()
	t:SetTexture("Interface/Icons/Temp")
	t, f.Icon = f:CreateTexture(nil, "ARTWORK", nil, 2), t
	t:SetPoint("BOTTOMRIGHT", 4, -4)
	t:SetSize(16,16)
	t:SetTexture(1383681)
	t, f.PenaltyIcon = f:CreateTexture(nil, "ARTWORK", nil, 1), t
	t:SetAtlas("GarrMission_EncounterAbilityBorder-Lg")
	t:SetSize(48,48)
	t:SetPoint("CENTER")
	t, f.SpecBorder = f:CreateTexture(nil, "ARTWORK", nil, 1), t
	t:SetAtlas("GarrMission_WeakEncounterAbilityBorder-Lg")
	t:SetSize(48,48)
	t:SetPoint("CENTER")
	f.ThreatBorder = t
	return f
end
function Factory.FollowerAbilityOrEquipment(parent)
	local f,t = CreateFrame("Button", nil, parent, "InsecureActionButtonTemplate")
	f:SetSize(32, 32)
	f:SetScript("OnEnter", Ability_OnEnter)
	f:SetScript("OnLeave", Ability_OnLeave)
	f:SetScript("PreClick", Equipment_PreClick)
	f.SetEquipment = Equipment_SetEquipment
	f:SetMouseMotionEnabled(true)
	t = f:CreateTexture(nil, "ARTWORK", nil, 0)
	t:SetAllPoints()
	t:SetTexture("Interface/Icons/Temp")
	t, f.Icon = f:CreateTexture(nil, "ARTWORK", nil, 1), t
	t:SetAtlas("GarrMission_EncounterAbilityBorder-Lg")
	t:SetSize(52,52)
	t:SetPoint("CENTER")
	t, f.SpecBorder = f:CreateTexture(nil, "ARTWORK", nil, 1), t
	t:SetAtlas("GarrMission_WeakEncounterAbilityBorder-Lg")
	t:SetSize(52,52)
	t:SetPoint("CENTER")
	t, f.ThreatBorder = f:CreateTexture(nil, "ARTWORK", nil, 2), t
	t:SetAtlas("ClassHall_Follower-EquipmentFrame")
	t:SetSize(36,36)
	t:SetPoint("CENTER")
	t, f.EquipmentBorder = f:CreateTexture(nil, "ARTWORK", nil, 2), t
	t:SetPoint("CENTER", 0, 1)
	t:SetAtlas("AdventureMapIcon-Lock", true)
	t:SetSize(21, 28)
	t, f.LockIcon = f:CreateTexture(nil, "ARTWORK", nil, 3), t
	t:SetAtlas("GarrMission-AbilityHighlight")
	t:SetSize(52,52)
	t:SetPoint("CENTER")
	t:SetBlendMode("ADD")
	t:Hide()
	t, f.EquipmentGlow = f:CreateTexture(nil, "BACKGROUND"), t
	t:SetColorTexture(0,0,0, 0.85)
	t:SetPoint("BOTTOMLEFT", 2, 2)
	t:SetPoint("TOPRIGHT", -2, -2)

	return f
end
function Factory.ProgressBar(parent)
	local f, t, r = CreateFrame("Frame", nil, parent)
	f:SetHeight(16)
	f:SetHitRectInsets(-3, -3, -6, -4)
	t = f:CreateTexture(nil, "BACKGROUND")
	t:SetAtlas("UI-Frame-Bar-BGLeft", true)
	t:SetPoint("LEFT", -2,0)
	t = f:CreateTexture(nil, "BACKGROUND")
	t:SetAtlas("UI-Frame-Bar-BGRight", true)
	t:SetPoint("RIGHT", 2,0)
	t = f:CreateTexture(nil, "BACKGROUND")
	t:SetAtlas("UI-Frame-Bar-BGCenter")
	t:SetPoint("LEFT", 27,0)
	t:SetPoint("RIGHT", -27,0)
	t:SetHeight(18)
	t = f:CreateTexture(nil, "BORDER")
	t:SetAtlas("UI-Frame-Bar-BorderLeft", true)
	t:SetPoint("LEFT", -8,0)
	t = f:CreateTexture(nil, "BORDER")
	t:SetAtlas("UI-Frame-Bar-BorderRight", true)
	t:SetPoint("RIGHT", 8,0)
	t = f:CreateTexture(nil, "BORDER")
	t:SetAtlas("UI-Frame-Bar-BorderCenter")
	t:SetPoint("LEFT", 27,0)
	t:SetPoint("RIGHT", -27,0)
	t:SetHeight(31)
	t, r = f:CreateTexture(nil, "HIGHLIGHT"), CreateObject("ObjectGroup")
	t:SetAtlas("UI-Frame-Bar-BorderLeft", true)
	t:SetPoint("LEFT", -8,0)
	t, r[#r+1] = f:CreateTexture(nil, "HIGHLIGHT"), t
	t:SetAtlas("UI-Frame-Bar-BorderRight", true)
	t:SetPoint("RIGHT", 8,0)
	t, r[#r+1] = f:CreateTexture(nil, "HIGHLIGHT", nil, 2), t
	t:SetAtlas("UI-Frame-Bar-BorderCenter")
	t:SetPoint("LEFT", 27,0)
	t:SetPoint("RIGHT", -27,0)
	t:SetHeight(31)
	r[#r+1], f.Highlight = t, r
	r:SetBlendMode("ADD")
	t = f:CreateTexture(nil, "BACKGROUND", nil, 2)
	t:SetAtlas("UI-Frame-Bar-Fill-Red")
	t:SetPoint("TOPLEFT")
	t:SetPoint("BOTTOMLEFT")
	t:SetWidth(50)
	t, f.Fill = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight"), t
	t:SetPoint("TOPLEFT", 4, 0)
	t:SetPoint("BOTTOMRIGHT", -4, 1)
	t:SetJustifyV("MIDDLE")
	f.Text = t
	f.SetProgress = Progress_SetProgress
	f.SetProgressCountdown = Progress_SetTimer
	return f
end
function Factory.ChampionButton(parent)
	local cf, t = CreateFrame("Button", nil, parent)
	cf:SetSize(180, 140)
	cf:SetScript("OnEnter", Champion_OnEnter)
	cf:SetScript("OnClick", ToggleChampionOnClick)
	cf:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	cf:SetFlattensRenderLayers(true)
	CreateObject("TexSlice", cf, "BACKGROUND",2, "Interface/Store/Store-Splash",1024,1024, 1,31,257,287, 793,813,919,939, 18,13, 0,0,0,0)
	t = CreateObject("TexSlice", cf, "BACKGROUND",3, "Interface/Store/Store-Splash",1024,1024, 1,31,257,287, 793,813,919,939, 18,13, 0,0,0,0)
	t:SetVertexColor(0.25, 0.25, 0.45, 0.8)
	t:Hide()
	t, cf.Veil = CreateObject("TexSlice", cf, "BORDER",2, "Interface/Store/Store-Splash",1024,1024, 289,319,539,569, 793,813,919,933, 18,13, -2,-2,-2,-2), t
	t:SetBlendMode("ADD")
	t:Hide()
	t, cf.Highlight = CreateObject("TexSlice", cf, "BORDER",2, "Interface/Store/Store-Splash",1024,1024, 289,319,539,569, 793,813,919,933, 18,13, -2,-2,-2,-2), t
	t:SetBlendMode("ADD")
	t:SetAlpha(0.50)
	t:Hide()
	t, cf.Highlight2 = CreateObject("TexSlice", cf, "BORDER",1, "Interface/Store/Store-Splash",1024,1024, 573,603,823,853, 777,797,897,917, 18,13, -3,-3,-3,-3), t
	t:SetBlendMode("ADD")
	t:Hide()
	t, cf.Highlight3 = CreateObject("ProgressBar", cf), t
	t:SetWidth(152)
	t:SetPoint("BOTTOM", 0, 14)
	t:SetProgress(0.50 - math.random()/2 + math.random()/2)
	t.Text:SetText("Chasing Goats: 6 hours")
	t, cf.StatusBar = cf:CreateFontString(nil, "OVERLAY", "GameFontNormalMed2"), t
	t:SetText("Twenty-Fifth Bam")
	t:SetPoint("TOP", 0, -6)
	t:SetSize(165, 18)
	t:SetJustifyV("MIDDLE")
	t, cf.Name = cf:CreateTexture(nil, "ARTWORK"), t
	t:SetSize(64, 64)
	t:SetPoint("TOP", cf, "TOPLEFT", 44, -34)
	t:SetTexture(1605024)
	t, cf.Portrait = cf:CreateTexture(nil, "ARTWORK", nil, 2), t
	t:SetAtlas("hud-PlayerFrame-portraitring-large")
	t:SetPoint("TOPRIGHT", cf.Portrait, "TOPRIGHT", 4, 4)
	t:SetPoint("BOTTOMLEFT", cf.Portrait, "BOTTOMLEFT", -4, -4)
	local abCluster = CreateFrame("Frame", nil, cf)
	abCluster:SetSize(76, 76)
	abCluster:SetPoint("TOPRIGHT", -14, -28)
	cf.Abilities = {}
	for j=1,5 do
		local a = CreateObject("FollowerAbilityOrEquipment", abCluster)
		if j > 1 then
			local j = j-1
			a:SetPoint("TOPLEFT", j % 2 == 1 and 1 or 42, j > 2 and -42 or -1)
		else
			a:SetPoint("CENTER", cf.Portrait, "TOPRIGHT", -6, -10)
			a:SetScale(0.65)
		end
		cf.Abilities[j] = a
	end
	return cf
end
function Factory.TroopButton(parent)
	local f, t = CreateFrame("Button", nil, parent)
	f:SetSize(38, 18)
	f:SetScript("OnClick", ToggleChampionOnClick)
	f:SetScript("OnEnter", TroopButton_OnEnter)
	f:SetScript("OnLeave", TroopButton_OnLeave)
	f:SetScript("OnHide", TroopButton_OnLeave)
	f.SetDurability = TroopButton_SetDurability
	f:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	f.Hearts = {}
	for i=1,3 do
		t = f:CreateTexture(nil, "ARTWORK")
		t:SetAtlas("GarrisonTroops-Health", true)
		t:SetPoint("LEFT", 17*i-14, 0)
		f.Hearts[i] = t
	end
	f.Highlight1 = CreateObject("TexSlice", f, "BACKGROUND",0, "Interface/Calendar/Highlights",256,128, 0,8,76,84, 89,94,104,109, 5,3, 1,0,1,0)
	f.Highlight2 = CreateObject("TexSlice", f, "BACKGROUND",0, "Interface/Calendar/Highlights",256,128, 0,8,76,84, 89,94,104,109, 5,3, 1,0,0,0)
	f.Highlight3 = CreateObject("TexSlice", f, "BACKGROUND",1, "Interface/Calendar/Highlights",256,128, 90,98,166,174, 89,94,104,109, 5,3, 1,0,0,0)
	f.Highlight1:SetAlpha(0.85)
	f.Highlight1:SetBlendMode("ADD")
	f.Highlight2:SetBlendMode("ADD")
	f.Highlight3:SetBlendMode("ADD")
	f.Highlight1:Hide()
	f.Highlight2:SetShown(false)
	f.Highlight3:SetShown(false)
	return f
end
function Factory.ResourceButton(parent, currencyID)
	local f,t = CreateObject("CommonHoverTooltip", CreateFrame("Button", nil, parent))
	f.tooltipAnchor, f.currencyID = "ANCHOR_BOTTOM", currencyID
	f:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
	f:SetScript("OnEvent", ResourceButton_Update)
	f:SetScript("OnClick", ResourceButton_OnClick)
	f:SetSize(60, 23)
	t = f:CreateTexture()
	t:SetSize(18, 18)
	t:SetTexture((select(3, Nine.GetCurrencyInfo(f.currencyID))))
	t:SetTexCoord(4/64,60/64, 4/64,60/64)
	t:SetPoint("LEFT", 1, 0)
	t, f.Icon = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightMed2")
	t:SetPoint("LEFT", 25, 0)
	t:SetText("Lots")
	f.Text = t
	ResourceButton_Update(f, nil, currencyID)
	return f
end
function Factory.GroupButton(parent)
	local gr = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
	local t = gr:CreateFontString(nil, "OVERLAY", "GameFontBlack")
	t:SetWidth(52)
	t:SetPoint("BOTTOM", gr, "TOP", 0, 1)
	gr.Features = t
	gr:SetText("^")
	gr:SetSize(45, 22)
	gr:SetScript("OnEnter", GroupButton_OnEnter)
	gr:SetScript("OnLeave", GroupButton_OnLeave)
	gr:SetScript("OnClick", GroupButton_OnClick)
	gr:SetMotionScriptsWhileDisabled(true)
	gr:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	CreateObject("CountdownText", gr, gr.Features)
	return gr
end
function Factory.AchievementRewardIcon(parent)
	local f, t = CreateObject("CommonHoverTooltip", CreateFrame("Button", nil, parent))
	f:SetSize(30,30)
	f:SetScript("OnHide", HideOwnGameTooltip)
	f:SetScript("OnClick", CommonLinkable_OnClick)
	t = f:CreateTexture(nil, "ARTWORK")
	t:SetTexture("Interface/AchievementFrame/UI-Achievement-Progressive-Shield")
	t:SetTexCoord(0, 0.75, 0, 0.75)
	t:SetAllPoints()
	return f
end
function Factory.MissionBaseBackground(parent, expandW, expandH)
	local eX, eY, t = expandW or 10, expandH or expandW or 10
	t = parent:CreateTexture(nil, "BORDER")
	t:SetAtlas("Garr_InfoBoxMission-BackgroundTile")
	t:SetPoint("TOPLEFT", -eX, eY)
	t:SetPoint("BOTTOMRIGHT", eX, -eY)
	t = parent:CreateTexture(nil, "BORDER", nil, 1)
	parent["BaseFrameTop"] = t
	t:SetAtlas("_Garr_InfoBoxMission-Top", true)
	t:SetHorizTile(true)
	t:SetPoint("TOPLEFT", 1-eX, 7+eY)
	t:SetPoint("TOPRIGHT", -1+eX, 7+eY)
	t = parent:CreateTexture(nil, "BORDER", nil, 1)
	parent["BaseFrameBottom"] = t
	t:SetAtlas("_Garr_InfoBoxMission-Top", true)
	t:SetHorizTile(true)
	t:SetPoint("BOTTOMLEFT", -eX, -7-eY)
	t:SetPoint("BOTTOMRIGHT", eX, -7-eY)
	t:SetTexCoord(0.0, 1.0, 1.0, 0.0)
	t = parent:CreateTexture(nil, "BORDER", nil, 1)
	parent["BaseFrameLeft"] = t
	t:SetAtlas("!Garr_InfoBoxMission-Left", true)
	t:SetVertTile(true)
	t:SetPoint("TOPLEFT", -7-eX, eY)
	t:SetPoint("BOTTOMLEFT", -7-eX, -eY)
	t = parent:CreateTexture(nil, "BORDER", nil, 1)
	parent["BaseFrameRight"] = t
	t:SetAtlas("!Garr_InfoBoxMission-Left", true)
	t:SetVertTile(true)
	t:SetPoint("TOPRIGHT", 7+eX, eY)
	t:SetPoint("BOTTOMRIGHT", 7+eX, -eY)
	t:SetTexCoord(1.0, 0.0, 0.0, 1.0)

	t = parent:CreateTexture(nil, "BORDER", nil, 2)
	parent["BaseFrameTopLeft"] = t
	t:SetAtlas("Garr_InfoBoxMission-Corner", true)
	t:SetPoint("TOPLEFT", -6-eX, 7+eY)
	t = parent:CreateTexture(nil, "BORDER", nil, 2)
	parent["BaseFrameTopRight"] = t
	t:SetAtlas("Garr_InfoBoxMission-Corner", true)
	t:SetPoint("TOPRIGHT", 6+eX, 7+eY)
	t:SetTexCoord(1.0, 0.0, 0.0, 1.0)
	t = parent:CreateTexture(nil, "BORDER", nil, 2)
	parent["BaseFrameBottomLeft"] = t
	t:SetAtlas("Garr_InfoBoxMission-Corner", true)
	t:SetPoint("BOTTOMLEFT", -7-eX, -7-eY)
	t:SetTexCoord(0.0, 1.0, 1.0, 0.0)
	t = parent:CreateTexture(nil, "BORDER", nil, 2)
	parent["BaseFrameBottomRight"] = t
	t:SetAtlas("Garr_InfoBoxMission-Corner", true)
	t:SetPoint("BOTTOMRIGHT", 7+eX, -7-eY)
	t:SetTexCoord(1.0, 0.0, 1.0, 0.0)

	t = parent:CreateTexture(nil, "BORDER", nil, 4)
	t:SetAtlas("_Garr_InfoBoxBorderMission-Top", true)
	t:SetHorizTile(true)
	t:SetPoint("TOPLEFT", -eX,eY)
	t:SetPoint("TOPRIGHT", eX,eY)
	t = parent:CreateTexture(nil, "BORDER", nil, 4)
	t:SetAtlas("_Garr_InfoBoxBorderMission-Top", true)
	t:SetHorizTile(true)
	t:SetPoint("BOTTOMLEFT", -eX,-eY)
	t:SetPoint("BOTTOMRIGHT", eX,-eY)
	t:SetTexCoord(0.0, 1.0, 1.0, 0.0)
	t = parent:CreateTexture(nil, "BORDER", nil, 4)
	t:SetAtlas("!Garr_InfoBoxBorderMission-Left", true)
	t:SetVertTile(true)
	t:SetPoint("TOPLEFT", -eX,eY)
	t:SetPoint("BOTTOMLEFT", -eX,-eY)
	t = parent:CreateTexture(nil, "BORDER", nil, 4)
	t:SetAtlas("!Garr_InfoBoxBorderMission-Left", true)
	t:SetVertTile(true)
	t:SetPoint("TOPRIGHT", eX,eY)
	t:SetPoint("BOTTOMRIGHT", eX,-eY)
	t:SetTexCoord(1.0, 0.0, 0.0, 1.0)

	t = parent:CreateTexture(nil, "BORDER", nil, 5)
	t:SetAtlas("Garr_InfoBoxBorderMission-Corner", true)
	t:SetPoint("TOPLEFT", -eX, eY)
	t = parent:CreateTexture(nil, "BORDER", nil, 5)
	t:SetAtlas("Garr_InfoBoxBorderMission-Corner", true)
	t:SetPoint("TOPRIGHT", eX, eY)
	t:SetTexCoord(1.0, 0.0, 0.0, 1.0)
	t = parent:CreateTexture(nil, "BORDER", nil, 5)
	t:SetAtlas("Garr_InfoBoxBorderMission-Corner", true)
	t:SetPoint("BOTTOMLEFT", -eX, -eY)
	t:SetTexCoord(0.0, 1.0, 1.0, 0.0)
	t = parent:CreateTexture(nil, "BORDER", nil, 5)
	t:SetAtlas("Garr_InfoBoxBorderMission-Corner", true)
	t:SetPoint("BOTTOMRIGHT", eX, -eY)
	t:SetTexCoord(1.0, 0.0, 1.0, 0.0)
end
function Factory.CountdownText(widget, textWidget)
	widget.SetCountdown = CountdownText_SetCountdown
	widget.CDTDisplay = textWidget or widget
end
function Factory.MissionButton(parent)
	local cf, t = CreateFrame("Button", nil, parent)
	cf:SetSize(220, 280)
	cf:SetScript("OnClick", Mission_OnClick)
	t = cf:CreateTexture(nil, "BACKGROUND", nil, -2)
	t:SetAtlas("warboard-parchment")
	t:SetPoint("TOPLEFT", -5, -15)
	t:SetPoint("BOTTOMRIGHT", 5, 0)
	Mirror(t, true)
	t = cf:CreateTexture(nil, "ARTWORK", nil, -6)
	t:SetAtlas("warboard-parchment")
	t:SetPoint("TOPLEFT", -5, -15)
	t:SetPoint("BOTTOMRIGHT", 5, 0)
	t:SetVertexColor(0.30, 0.30, 0.40, 0.60)
	Mirror(t, true)
	t, cf.Veil = cf:CreateFontString(nil, "BACKGROUND", "GameFontHighlightLarge"), t
	t:SetText("Goats' Goat Goat")
	t:SetPoint("TOP", 0, -54)
	t:SetWidth(210)
	t, cf.Name = cf:CreateTexture(nil, "BACKGROUND", nil, 2), t
	t:SetTexture("Interface/EncounterJournal/UI-EncounterJournalTextures")
	t:SetTexCoord(0.359375, 0.99609375, 0.8525390625,0.880859375)
	t:SetWidth(220)
	t:SetPoint("TOP", cf.Name, 0, 8)
	t:SetPoint("BOTTOM", cf.Name, "BOTTOM", 0, -3)
	t = cf:CreateFontString(nil, "OVERLAY", "GameFontBlack")
	t:SetWidth(204)
	t:SetPoint("TOP", cf.Name, "BOTTOM", 0, -6)
	t:SetText("There is no cow level. Our forces, however, have discovered a goat level. Perhaps there's even epic goat loot? You should go rescue the goats. Who knows what would happen if the Horde got there first.")
	t, cf.Description = cf:CreateFontString(nil, "BACKGROUND", "GameFontNormal"), t
	t:SetPoint("LEFT", cf, "TOPLEFT", 10, -34)
	t:SetText(-math.random(1,45)*100 .. " XP")
	t, cf.XPReward = cf:CreateFontString(nil, "OVERLAY", "GameFontBlack"), t
	t:SetPoint("BOTTOM", cf, 0, 9)
	t:SetText("Expires in: two weeks ago")
	cf.ExpireTime = t
	CreateObject("CountdownText", cf, t)

	t = CreateFrame("Frame", nil, cf)
	t:SetPoint("TOP", 0, -4)
	t:SetSize(104, 48)
	cf.Rewards = {Container=t}
	for j=1,2 do
		local rew = CreateObject("RewardFrame", t)
		rew:SetPoint(j == 1 and "LEFT" or "RIGHT")
		cf.Rewards[j] = rew
	end
	t = CreateObject("AchievementRewardIcon", cf)
		t:SetPoint("LEFT", cf, "TOP", 64, -24)
		cf.AchievementReward = t
	
	t = CreateFrame("Frame", nil, cf)
	t:SetPoint("TOP", 0, -150)
	t:SetSize(140, 32)
	cf.Mechanics, cf.MechanicsContainer = {}, t
	for j=1,4 do
		local mech = CreateObject("MissionThreat", t)
		mech:SetPoint("LEFT", 38*j-38, 0)
		mech.SpecBorder:SetShown(j == 1)
		cf.Mechanics[j] = mech
	end
	cf.Groups = {}
	for j=1,4 do
		local g = CreateObject("GroupButton", cf)
		g:SetPoint("TOPLEFT", j*50-40, -234)
		cf.Groups[j] = g
	end
	t = cf:CreateFontString(nil, "OVERLAY", "QuestFont")
	t:SetWidth(180)
	t:SetPoint("CENTER", cf, "TOP", 0, -225)
	t:SetText("")
	t, cf.NoGroupLabel = CreateObject("ProgressBar", cf), t
	t:SetWidth(cf:GetWidth()-30)
	t:SetPoint("BOTTOM", 0, 32)
	t.Fill:SetAtlas("UI-Frame-Bar-Fill-Blue")
	t, cf.ProgressBar = t:CreateTexture(nil, "ARTWORK"), t
	t:SetPoint("BOTTOM", cf.ProgressBar, "TOP", 65, 3)
	t:SetAtlas(UnitFactionGroup("player") == "Horde" and "GarrMission-HordeChest" or "GarrMission-AllianceChest")
	t:SetVertexColor(0.6,0.6,0.6)
	t:SetSize(63, 47)
	t, cf.RewardChest = cf.ProgressBar:CreateFontString(nil, "OVERLAY", "GameFontNormalLargeOutline"), t
	t:SetPoint("BOTTOM", cf.ProgressBar, "TOP", 65, 15)
	t:SetText("5%")
	t:SetTextColor(0.2,0.85,0.1)
	cf.ProgressBar.ChanceText = t
	return cf
end
function Factory.MenuButton(parent)
	local b, t = CreateFrame("Button", nil, parent, "UIMenuButtonStretchTemplate")
	b:SetSize(30, 30)
	b:SetHighlightTexture([[Interface\Buttons\UI-Common-MouseHilight]], "ADD")
	t = b:CreateTexture(nil, "ARTWORK")
	t:SetPoint("CENTER")
	t, b.Icon = b:GetHighlightTexture(), t
	t:SetAlpha(0.75)
	t:SetTexCoord(0, 1, 0, 1)
	return b
end
function Factory.CommonHoverTooltip(frame)
	frame:SetScript("OnEnter", CommonTooltip_OnEnter)
	frame:SetScript("OnLeave", HideOwnGameTooltip)
	return frame
end
function Factory.FlyoutScrollButton(parent, downArrow, hitRectX)
	local f, t = CreateFrame("Button", nil, parent, nil, downArrow and 1 or 3)
	f:SetSize(32, 16)
	f:SetHitRectInsets(-(hitRectX or 0), -(hitRectX or 0), 0, 0)
	f:SetNormalTexture("Interface/PaperDollInfoFrame/UI-GearManager-FlyoutButton")
	f:SetHighlightTexture("Interface/PaperDollInfoFrame/UI-GearManager-FlyoutButton")
	f:SetDisabledTexture("Interface/PaperDollInfoFrame/UI-GearManager-FlyoutButton")
	t = f:GetDisabledTexture()
	if downArrow then
		f:GetNormalTexture():SetTexCoord(0.15625, 0.84375, 0.5, 0)
		f:GetHighlightTexture():SetTexCoord(0.15625, 0.84375, 1, 0.5)
		t:SetTexCoord(0.15625, 0.84375, 0.5, 0)
	else
		f:GetNormalTexture():SetTexCoord(0.15625, 0.84375, 0, 0.5)
		f:GetHighlightTexture():SetTexCoord(0.15625, 0.84375, 0.5, 1)
		t:SetTexCoord(0.15625, 0.84375, 0, 0.5)
	end
	t:SetDesaturated(true)
	t:SetVertexColor(0.8, 0.8, 0.8)
	return f
end
function Factory.HistoryFrame(parent)
	local f, t = CreateFrame("Frame", nil, parent)
	f:SetSize(250, 298)
	f:Hide()
	f:EnableMouse(true)
	f:EnableMouseWheel(true)
	f:SetFrameStrata("DIALOG")
	f.Scroll, f.UpdateDisplay = HistoryFrame_Scroll, HistoryFrame_UpdateDisplay
	f:SetHitRectInsets(-4, -4, 0, -4)
	CreateEdge(f, {edgeFile="Interface/Tooltips/UI-Tooltip-Border", bgFile="Interface/BUTTONS/White8x8", tile=true, edgeSize=16, tileSize=16, insets={left=4,right=4,bottom=4,top=4}}, 0xF3000000, 0xC0C0C0)
	f:SetScript("OnUpdate", HistoryFrame_CheckMouse)
	f:SetScript("OnShow", HistoryFrame_OnShow)
	f:SetScript("OnMouseWheel", HistoryFrame_Scroll)
	f:SetScript("OnHide", f.Hide)
	t = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	t:SetPoint("CENTER")
	t:SetWidth(150)
	t:SetText(L"Results of completed missions will be recorded and displayed here.")
	t, f.NoHistory = CreateObject("FlyoutScrollButton", f, false, 100), t
	t:SetPoint("TOP")
	t:SetScript("OnClick", HistoryFrame_ScrollClick)
	t, f.ScrollUpButton = CreateObject("FlyoutScrollButton", f, true, 100), t
	t:SetPoint("BOTTOM")
	t:SetScript("OnClick", HistoryFrame_ScrollClick)
	f.ScrollDownButton = t
	local lf = CreateFrame("Frame", nil, f)
	lf:SetPoint("TOPLEFT", 4, -14)
	lf:SetPoint("BOTTOMRIGHT", -4, 14)
	f.Entries = {}
	for i=1,8 do
		local e = CreateFrame("Button", nil, lf)
		e:SetSize(242, 34)
		e:SetPoint("TOP", 0, 34-i*34)
		t = e:CreateTexture(nil, "BACKGROUND")
		t:SetTexture("Interface/EncounterJournal/UI-EncounterJournalTextures_Tile")
		t:SetAllPoints()
		t:SetHorizTile(true)
		t:SetTexCoord(0, 1, 0.16601563, 0.21875000)
		t = e:CreateTexture(nil, "HIGHLIGHT")
		t:SetTexture("Interface/EncounterJournal/UI-EncounterJournalTextures")
		t:SetPoint("TOPLEFT")
		t:SetPoint("BOTTOMRIGHT",0,-2)
		t:SetHorizTile(true)
		t:SetTexCoord(0.63085938, 0.88085938, 0.58886719, 625/1024)
		t:SetAlpha(0.20)
		t:SetBlendMode("ADD")
		t = e:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		t:SetText("Retrieve the Epic Space Goat")
		t:SetPoint("TOPLEFT", 5, -4)
		t, e.Name = e:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall"), t
		t:SetFormattedText("|cff20ff20%d%%|r - Completed %d days ago", math.random(50,200), 41+i)
		t:SetPoint("BOTTOMLEFT", 5, 6)
		t, e.Detail = e:CreateTexture(nil, "OVERLAY"), t
		t:SetSize(30,30)
		t:SetPoint("RIGHT", -2, 0)
		t:SetTexture(877477)
		t, e.Icon = e:CreateFontString(nil, "OVERLAY", "GameFontHighlightOutline"), t
		t:SetPoint("BOTTOMRIGHT", -4, 4)
		t:SetText("M")
		e.Quantity = t
		f.Entries[i] = e
	end
	return f
end
function Factory.ControlContainerBorder(parent, expandX, expandY)
	expandX, expandY = expandX or 0, expandY or 0
	local t, is, ts = parent:CreateTexture(nil, "BACKGROUND"), 18, 1/16
	t:SetAtlas("Garr_Mission_MaterialFrame")
	t:SetTexCoord(0, ts, 0, 1)
	t:SetPoint("TOPLEFT", -expandX, expandY)
	t:SetPoint("BOTTOMRIGHT", parent, "BOTTOMLEFT", is-expandX, -expandY)
	t = parent:CreateTexture(nil, "BACKGROUND")
	t:SetTexCoord(ts, 1-ts, 0, 1)
	t:SetAtlas("Garr_Mission_MaterialFrame")
	t:SetPoint("TOPLEFT", is-expandX, expandY)
	t:SetPoint("BOTTOMRIGHT", -is+expandX, -expandY)
	t = parent:CreateTexture(nil, "BACKGROUND")
	t:SetTexCoord(1-ts, 1, 0, 1)
	t:SetAtlas("Garr_Mission_MaterialFrame")
	t:SetPoint("TOPRIGHT", expandX, expandY)
	t:SetPoint("BOTTOMLEFT", parent, "BOTTOMRIGHT", -is+expandX, -expandY)
end
function Factory.MissionTable(name)
	local frame, t = CreateFrame("Frame", name, UIParent)
	frame:Hide()
	frame:SetSize(962, 662)
	frame:SetPoint("CENTER", 0, -20)
	frame:SetFrameStrata("MEDIUM")
	frame:SetToplevel(true)
	frame:EnableMouseWheel(true)
	frame:EnableMouse(true)
	frame:SetScript("OnMouseWheel", function() end)
	
	CreateObject("TableArtwork", frame)
	frame.TitleText:SetText(GARRISON_MISSIONS)
	frame:SetMovable(true)
	frame:SetClampedToScreen(true)
	frame:SetClampRectInsets(0, 0, 4, -2)
	local mover = CreateFrame("Button", nil, frame)
	mover:SetPoint("TOPLEFT", frame.TitleText, "TOPLEFT", -48, -20)
	mover:SetPoint("BOTTOMRIGHT", frame.TitleText, "BOTTOMRIGHT", 48, 20)
	mover:SetScript("OnMouseDown", function()
		frame:StartMoving()
	end)
	mover:SetScript("OnMouseUp", function()
		frame:StopMovingOrSizing()
	end)
	mover:SetScript("OnShow", function()
		frame:ClearAllPoints()
		frame:SetPoint("CENTER", 0, -20)
	end)
	mover:SetScript("OnEnter", function()
		SetCursor("Interface/CURSOR/UI-Cursor-Move.crosshair")
	end)
	mover:SetScript("OnLeave", function()
		SetCursor(nil)
	end)
	mover:SetScript("OnHide", mover:GetScript("OnMouseUp"))
	UISpecialFrames[#UISpecialFrames+1] = name
	
	frame.TaskBoard = CreateFrame("Frame", nil, frame) do
		local mf, t = frame.TaskBoard
		mf:SetAllPoints()
		local resButton = CreateObject("ResourceButton", mf, 1560) do
			frame.ResourceCounter = resButton
			resButton:SetPoint("TOPRIGHT", -25-20, -33)
			CreateObject("ControlContainerBorder", resButton, 14, 10)
		end
		local troopContainer = CreateFrame("Frame", nil, mf) do
			mf.Troops, t = troopContainer, troopContainer
			t:SetSize(338, 21)
			t:SetPoint("RIGHT", resButton, "LEFT", -30, 0)
			CreateObject("ControlContainerBorder", troopContainer, 14, 11)
			t.Units, t.Headers = {}, {}
			for i=1,6 do
				local x = CreateObject("TroopButton", t)
				x:SetPoint("LEFT", 24+i*38-38 + (i >= 3 and 24 or 0) + (i >= 7 and 24 or 0), 0)
				t.Units[i] = x
			end
			for i=1,3 do
				local x = t:CreateTexture(nil, "ARTWORK")
				x:SetSize(18, 18)
				x:SetTexCoord(4/64, 60/64, 4/64, 60/64)
				t.Headers[i] = x
			end
			t.Headers[1]:SetTexture(236201)
			t.Headers[1]:SetPoint("LEFT", 2, 0)
			t.Headers[2]:SetTexture(132226)
			t.Headers[2]:SetPoint("LEFT", 2+24+76, 0)
			t.Headers[3]:SetTexture(132269)
			t.Headers[3]:SetPoint("LEFT", 2+48+228, 0)
		end
		t = CreateFrame("Button", nil, mf, "UIPanelButtonTemplate")
		t:SetSize(200, 26)
		t:SetPoint("RIGHT", troopContainer, "LEFT", -130, 0)
		t:SetText("Click Me")
		t:EnableKeyboard(true)
		t:SetScript("OnKeyDown", Button_ClickWithSpace)
		t:SetScript("OnLeave", HideOwnGameTooltip)
		t, mf.AllPurposeButton = CreateObject("CommonHoverTooltip", CreateObject("MenuButton", mf)), t
		t:SetSize(34, 30)
		t:SetPoint("TOPLEFT", 62, -30)
		t.Icon:SetTexture("Interface/EncounterJournal/UI-EncounterJournalTextures")
		t.Icon:SetSize(24,24)
		t.Icon:SetTexCoord(0.63281250, 0.72656250, 0.61816406, 0.66015625)
		mf.HistoryButton = t
		
		local missionList = CreateFrame("ScrollFrame", nil, mf)
		missionList:SetSize(892, 405)
		missionList:SetPoint("BOTTOM", 0, 180)
		missionList:EnableMouseWheel(true)
		missionList.ScrollToward = MissionList_ScrollToward
		CreateObject("MissionBaseBackground", missionList, 6, 10)
		mf.List = missionList
		do -- missionList:OnMouseWheel
			local v = CreateFrame("Frame", nil, mf)
			v:SetAllPoints(missionList)
			v:EnableMouse(true)
			v:SetFrameLevel(mf:GetFrameLevel()+20)
			v:Hide()
			missionList.ScrollVeil = v
			local function scrollFinish(self)
				self:GetScrollChild():SetPoint("TOPLEFT", 0, self.scrollEnd)
				self.scrollStart, self.scrollEnd, self.scrollTimeStart, self.scrollTimeEnd, self.scrollSpeed, self.scrollLast = nil
				self:SetScript("OnUpdate", nil)
				self:SetScript("OnHide", nil)
				self.ScrollVeil:Hide()
			end
			local function scrollOnUpdate(self)
				local a, b, s, t = self.scrollStart, self.scrollEnd, self.scrollTimeStart, self.scrollTimeEnd
				local sc, c = self:GetScrollChild(), GetTime()
				if c >= t then
					scrollFinish(self)
				else
					local p = a + (b-a)*(c-s)/(t-s)
					sc:SetPoint("TOPLEFT", 0, p)
					self.scrollLastTime, self.scrollLastOffset = c, s
				end
			end
			missionList:SetScript("OnMouseWheel", function(self, d)
				local scrollChild = self:GetScrollChild()
				local _, _, _, _, y = scrollChild:GetPoint()
				local snap = math.min(math.max(0, (self.scrollSnap or 0) - d), math.floor(((self.numMissions or 0)-1)/4))
				local dy = snap == 0 and 0 or (282*snap-30)
				if self.scrollEnd ~= dy then
					local ct = GetTime()
					self.scrollSnap, self.scrollStart, self.scrollEnd, self.scrollTimeStart, self.scrollTimeEnd = snap, y, dy, ct, ct + 0.20
					self:SetScript("OnUpdate", scrollOnUpdate)
					self:SetScript("OnHide", scrollFinish)
					self.ScrollVeil:Show()
				end
			end)
			function missionList:ReturnToTop()
				self.scrollSnap, self.scrollEnd = 0, 0
				scrollFinish(self)
			end
		end
		local b = missionList:CreateTexture(nil, "BACKGROUND")
		b:SetColorTexture(1,1,1, 0.15)
		b:SetPoint("TOPLEFT", -5, 5)
		b:SetPoint("BOTTOMRIGHT", 5, -5)
		local scrollChild = CreateFrame("Frame", nil, missionList)
		scrollChild:SetPoint("TOPLEFT")
		scrollChild:SetSize(902,missionList:GetHeight())
		missionList:SetScrollChild(scrollChild)
		mf.Missions = setmetatable({}, {__index=MissionTable_SpawnMissionButton})
		for i=1,6 do
			local cf = CreateObject("MissionButton", scrollChild)
			mf.Missions[i] = cf
			cf:SetPoint("TOPLEFT", 222*(((i-1)%4)+1)-220, math.floor(i/5) *- 282)
		end
		
		local championList = CreateFrame("Frame", nil, mf)
		championList:SetSize(908, 135)
		championList:SetPoint("BOTTOM", 0, 30)
		championList:SetScript("OnShow", ChampionList_UpdateEquipmentGlow)
		championList:SetScript("OnEvent", ChampionList_UpdateEquipmentGlow)
		championList:SetScript("OnHide", ChampionList_UpdateEquipmentGlow)
		championList.Update = ChampionList_UpdateEquipmentGlow
		mf.Champions, mf.ChampionContainer = {}, championList
		local baseFrameLevel = championList:GetFrameLevel()
		for i=1,6 do
			local cf = CreateObject("ChampionButton", championList)
			cf:SetFrameLevel(baseFrameLevel+i)
			mf.Champions[i] = cf
		end
		local exChampion = mf.Champions[6]
		exChampion:SetScript("OnShow", ChampionList_EnableDynamicAnchors)
		exChampion:SetScript("OnHide", ChampionList_EnableStaticAnchors)
		ChampionList_EnableStaticAnchors(exChampion)
		
		mf.Toasts = {CreateObject("MissionToast", mf)}
		mf.Toasts[1]:SetPoint("TOPLEFT", 20, -65)
		mf.AcquireToast = MissionList_AcquireToast
	end
	frame.ResetButton = CreateObject("CommonHoverTooltip", CreateObject("MenuButton", frame.TaskBoard)) do
		t = frame.ResetButton
		t.Icon:SetAtlas("transmog-icon-revert-small", true)
		t:SetPoint("TOPLEFT", 28, -30)
	end
	frame.HistoryFrame = CreateObject("HistoryFrame", frame) do
		local f, hb = frame.HistoryFrame, frame.TaskBoard.HistoryButton
		f:SetPoint("TOPLEFT", hb, "BOTTOMLEFT", -38, 0)
		function EV:I_MISSION_LOG_UPDATED()
			if f:IsShown() then
				f:UpdateDisplay()
			end
		end
		
		hb:SetScript("OnClick", function(self)
			if GameTooltip:IsOwned(self) then
				GameTooltip:Hide()
			end
			f:SetShown(not f:IsShown())
		end)
	end
	
	return frame
end
function Factory.MissionToast(parent)
	local f, t = CreateFrame("Button", nil, parent)
	f:SetSize(295, 40)
	f:SetFrameStrata("FULLSCREEN")
	f:SetHitRectInsets(-6, -6, -6, -6)
	f:RegisterForClicks("RightButtonUp")
	f:SetScript("OnUpdate", Toast_Animate)
	f:SetScript("OnClick", Toast_OnClick)
	f.SetMissionHistory = Toast_SetMissionHistory
	f.Background = CreateObject("TexSlice", f, "BACKGROUND", 0, "Interface/LootFrame/LootToast",1024,256, 578,638,763,823, 0,3,69,0, 45,0, 5,0,5,0)
	t = f:CreateTexture(nil, "ARTWORK")
	t:SetAtlas("loottoast-sheen")
	t:SetBlendMode("ADD")
	t:SetSize(90, 38) -- 171,75
	t:SetPoint("LEFT", 20, -1)
	t, f.Sheen = f:CreateTexture(nil, "OVERLAY", nil, -2), t
	t:SetTexture("Interface/AchievementFrame/UI-Achievement-Alert-Glow")
	t:SetTexCoord(5/512, 395/512, 5/256, 167/256)
	t:SetPoint("BOTTOMLEFT", -35, -30)
	t:SetPoint("TOPRIGHT", 35, 30)
	t:SetBlendMode("ADD")
	f.PreGlow = t
	t = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	t:SetPoint("TOPLEFT", 44, -7)
	t:SetSize(240, 12)
	t:SetText("|cffff8000Legendary Mission")
	t, f.Outcome = f:CreateFontString(nil, "ARTWORK", "GameFontHighlight"), t
	t:SetPoint("BOTTOMLEFT", 44, 7)
	t:SetSize(240, 12)
	t:SetText("Legendary Goat Rescue")
	t, f.Detail = f:CreateTexture(nil, "ARTWORK"), t
	t:SetSize(28, 28)
	t:SetPoint("LEFT", 11, -1)
	t:SetTexture(877477)
	t:SetTexCoord(4/64, 60/64, 4/64,60/64)
	f.Background[#f.Background+1], f.Icon = t, t
	f:Hide()
	return f
end
function Factory.TableArtworkHorde(frame)
	frame.TitleText:SetTextColor(0.192, 0.051, 0.008, 1)
	frame.TitleText:SetShadowOffset(0, 0)
	frame.Topper:SetAtlas("HordeFrame-Header", true)
	frame.Topper:SetPoint("BOTTOM", frame.Top, "TOP", 0, -34)
	frame.ScrollLeft:SetAtlas("HordeFrame_Title-End-2")
	frame.ScrollRight:SetAtlas("HordeFrame_Title-End")
	frame.ScrollMiddle:SetAtlas("_HordeFrame_Title-Tile")
	frame.CloseButtonBorder:SetAtlas("HordeFrame_ExitBorder", true)
	frame.CloseButtonBorder:SetPoint("CENTER", -1, 0)
	frame.CloseButton:SetPoint("TOPRIGHT", 4, 4)
	frame.BackgroundTile:SetAtlas("ClassHall_InfoBoxMission-BackgroundTile")
	frame.Top:SetAtlas("_HordeFrameTile-Top", true)
	frame.Bottom:SetAtlas("_HordeFrameTile-Top", true)
	frame.Left:SetAtlas("!HordeFrameTile-Left", true)
	frame.Right:SetAtlas("!HordeFrameTile-Left", true)
	frame.TopLeft:SetAtlas("HordeFrame-Corner-TopLeft", true)
	frame.TopRight:SetAtlas("HordeFrame-Corner-TopLeft", true)
	frame.BottomLeft:SetAtlas("HordeFrame-Corner-TopLeft", true)
	frame.BottomRight:SetAtlas("HordeFrame-Corner-TopLeft", true)
end
function Factory.TableArtworkAlliance(frame)
	frame.TitleText:SetTextColor(0.008, 0.051, 0.192, 1)
	frame.TitleText:SetShadowOffset(0, 0)
	frame.Topper:SetAtlas("AllianceFrame-Header", true)
	frame.Topper:SetPoint("BOTTOM", frame.Top, "TOP", 0, -29)
	frame.ScrollLeft:SetAtlas("AllianceFrame_Title-End-2")
	frame.ScrollRight:SetAtlas("AllianceFrame_Title-End")
	frame.ScrollMiddle:SetAtlas("_AllianceFrame_Title-Tile")
	frame.CloseButtonBorder:SetAtlas("AllianceFrame_ExitBorder", true)
	frame.CloseButtonBorder:SetPoint("CENTER", 0, -1)
	frame.CloseButton:SetPoint("TOPRIGHT", 4, 4)
	frame.BackgroundTile:SetAtlas("ClassHall_InfoBoxMission-BackgroundTile")
	frame.Top:SetAtlas("_AllianceFrameTile-Top", true)
	frame.Bottom:SetAtlas("_AllianceFrameTile-Top", true)
	frame.Left:SetAtlas("!AllianceFrameTile-Left", true)
	frame.Right:SetAtlas("!AllianceFrameTile-Left", true)
	frame.TopLeft:SetAtlas("AllianceFrameCorner-TopLeft", true)
	frame.TopRight:SetAtlas("AllianceFrameCorner-TopLeft", true)
	frame.BottomLeft:SetAtlas("AllianceFrameCorner-TopLeft", true)
	frame.BottomRight:SetAtlas("AllianceFrameCorner-TopLeft", true)
end
function Factory.TableArtwork(frame)
	local baseFrame, frame, t = frame, CreateFrame("Frame", nil, frame)
	frame:SetAllPoints()
	frame:SetScript("OnShow", function(self)
		self:SetFrameLevel(self:GetParent():GetFrameLevel()+10)
	end)
	t = frame:CreateTexture(nil, "ARTWORK", nil, 2)
	t:SetPoint("BOTTOM", frame, "TOP", 0, 0)
	t, frame.Topper = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal"), t
	t:SetPoint("TOP", 0, -3)
	t:SetText(GARRISON_MISSIONS)
	t, frame.TitleText = CreateFrame("Button", nil, frame, "UIPanelCloseButton"), t
	t:SetPoint("TOPRIGHT", 4, 5)
	t:SetScript("OnClick", HideGrandparent)
	t, frame.CloseButton = t:CreateTexture(nil, "BORDER"), t
	t:SetPoint("CENTER")
	frame.CloseButtonBorder = t

	t = frame:CreateTexture(nil, "ARTWORK", nil, 3)
	t:SetHeight(28.5)
	t:SetPoint("LEFT", frame.TitleText, "LEFT", -20, 0)
	t:SetPoint("RIGHT", frame.TitleText, "RIGHT", 20, 0)
	t, frame.ScrollMiddle = frame:CreateTexture(nil, "ARTWORK", nil, 3), t
	t:SetSize(39, 30.5)
	t:SetPoint("TOPRIGHT", frame.ScrollMiddle, "TOPLEFT", 0, 0)
	t, frame.ScrollLeft = frame:CreateTexture(nil, "ARTWORK", nil, 3), t
	t:SetSize(39, 30.5)
	t:SetPoint("TOPLEFT", frame.ScrollMiddle, "TOPRIGHT", 0, 0)
	t, frame.ScrollRight = baseFrame:CreateTexture(nil, "BACKGROUND", nil, 0), t
	t:SetAllPoints()
	t:SetHorizTile(true)
	t:SetVertTile(true)
	t, frame.BackgroundTile = frame:CreateTexture(nil, "BACKGROUND", nil, 1), t
	t:SetHorizTile(true)
	t, frame.Top = frame:CreateTexture(nil, "BACKGROUND", nil, 1), t
	t:SetTexCoord(1,0,0,1)
	t:SetVertTile(true)
	t, frame.Right = frame:CreateTexture(nil, "BACKGROUND", nil, 1), t
	t:SetTexCoord(0,1,1,0)
	t:SetHorizTile(true)
	t, frame.Bottom = frame:CreateTexture(nil, "BACKGROUND", nil, 1), t
	t:SetVertTile(true)
	t, frame.Left = frame:CreateTexture(nil, "BACKGROUND", nil, 2), t
	t:SetPoint("TOPLEFT", -6, 6)
	t, frame.TopLeft = frame:CreateTexture(nil, "BACKGROUND", nil, 2), t
	t:SetPoint("TOPRIGHT", 6, 6)
	t:SetTexCoord(1,0,0,1)
	t, frame.TopRight = frame:CreateTexture(nil, "BACKGROUND", nil, 2), t
	t:SetPoint("BOTTOMRIGHT", 6, -6)
	t:SetTexCoord(1,0,1,0)
	t, frame.BottomRight = frame:CreateTexture(nil, "BACKGROUND", nil, 2), t
	t:SetPoint("BOTTOMLEFT", -6, -6)
	t:SetTexCoord(0,1,1,0)
	t, frame.BottomLeft = frame:CreateTexture(nil, "BACKGROUND", nil, 2), t
	frame.Top:SetPoint("TOPLEFT", frame.TopLeft, "TOPRIGHT", 0, 0)
	frame.Top:SetPoint("TOPRIGHT", frame.TopRight, "TOPLEFT", 0, 0)
	frame.Right:SetPoint("TOPRIGHT", frame.TopRight, "BOTTOMRIGHT", 0, 0)
	frame.Right:SetPoint("BOTTOMRIGHT", frame.BottomRight, "TOPRIGHT", 0, 0)
	frame.Bottom:SetPoint("BOTTOMRIGHT", frame.BottomRight, "BOTTOMLEFT", 0,0)
	frame.Bottom:SetPoint("BOTTOMLEFT", frame.BottomLeft, "BOTTOMRIGHT", 0,0)
	frame.Left:SetPoint("BOTTOMLEFT", frame.BottomLeft, "TOPLEFT", 0,0)
	frame.Left:SetPoint("TOPLEFT", frame.TopLeft, "BOTTOMLEFT", 0,0)

	CreateObject(UnitFactionGroup("player") ~= "Horde" and "TableArtworkAlliance" or "TableArtworkHorde", frame)
	baseFrame.ArtFrame, baseFrame.TitleText = frame, frame.TitleText
end
function Factory.ConfirmOnUseButton()
	local n, j = "WPConfirmOnUse!", math.random(10000, 99999)
	while _G[n .. j] do
		j = j + 1
	end
	local b = CreateFrame("Button", n, nil, "InsecureActionButtonTemplate")
	b:RegisterEvent("USE_BIND_CONFIRM")
	b:SetScript("OnEvent", function(self)
		self.armState = self.armState == 1 and 2 or nil
	end)
	b:SetScript("PreClick", function(self)
		if self.armState == 2 then
			local _, f = StaticPopup_Visible("USE_BIND")
			self:SetAttribute("type", f and "macro" or nil)
			self:SetAttribute("macrotext", f and SLASH_CLICK1 .. " " .. f.button1:GetName() or nil)
			_, self.soundID2 = PlaySound(SOUNDKIT.IG_MAINMENU_CLOSE)
		end
		self.armState = nil
	end)
	b:SetScript("PostClick", function(self)
		self:SetAttribute("type", nil)
		self:SetAttribute("macrotext", nil)
		local s1, s2 = self.soundID, self.soundID2
		self.soundID, self.soundID2 = nil
		if s1 then
			StopSound(s1)
		end
		if s2 then
			StopSound(s2)
		end
	end)
	function b:Arm()
		local _
		self.armState = 1
		_, self.soundID = PlaySound(SOUNDKIT.IG_MAINMENU_OPEN)
	end
	return b
end
function Factory.CurrencyMeter()
	local f, t = CreateFrame("Frame")
	f:SetSize(180, 30)
	f:Hide()
	t = CreateObject("ProgressBar", f)
	t:SetPoint("LEFT", 8, 0)
	t:SetPoint("RIGHT", -8, 0)
	t:SetClipsChildren(true)
	t.Fill:SetAtlas("UI-Frame-Bar-Fill-Blue")
	t, f.Bar = t:CreateTexture(nil, "BACKGROUND", nil, 2), t
	t:SetAtlas("UI-Frame-Bar-Fill-Yellow")
	t:SetPoint("TOPLEFT", f.Bar.Fill, "TOPRIGHT")
	t:SetPoint("BOTTOMLEFT", f.Bar.Fill, "BOTTOMRIGHT")
	t:SetWidth(50)
	f.Activate, f.Fill2 = CurrencyMeter_Activate, t
	f:SetScript("OnHide", CurrencyMeter_OnHide)
	f:SetScript("OnUpdate", CurrencyMeter_Update)
	return f
end