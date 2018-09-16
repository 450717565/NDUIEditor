local B, C, L, DB = unpack(select(2, ...))

--- 共享计量条材质
do
	local media = LibStub("LibSharedMedia-3.0")
	media:Register("statusbar", "Altz01", [[Interface\AddOns\NDui\Media\StatusBar\Altz01]])
	media:Register("statusbar", "Altz02", [[Interface\AddOns\NDui\Media\StatusBar\Altz02]])
	media:Register("statusbar", "Altz03", [[Interface\AddOns\NDui\Media\StatusBar\Altz03]])
	media:Register("statusbar", "Altz04", [[Interface\AddOns\NDui\Media\StatusBar\Altz04]])
	media:Register("statusbar", "MaoR", [[Interface\AddOns\NDui\Media\StatusBar\MaoR]])
	media:Register("statusbar", "NDui", [[Interface\TargetingFrame\UI-TargetingFrame-BarFill]])
	media:Register("statusbar", "Ray01", [[Interface\AddOns\NDui\Media\StatusBar\Ray01]])
	media:Register("statusbar", "Ray02", [[Interface\AddOns\NDui\Media\StatusBar\Ray02]])
	media:Register("statusbar", "Ray03", [[Interface\AddOns\NDui\Media\StatusBar\Ray03]])
	media:Register("statusbar", "Ray04", [[Interface\AddOns\NDui\Media\StatusBar\Ray04]])
	media:Register("statusbar", "Ya01", [[Interface\AddOns\NDui\Media\StatusBar\Ya01]])
	media:Register("statusbar", "Ya02", [[Interface\AddOns\NDui\Media\StatusBar\Ya02]])
	media:Register("statusbar", "Ya03", [[Interface\AddOns\NDui\Media\StatusBar\Ya03]])
	media:Register("statusbar", "Ya04", [[Interface\AddOns\NDui\Media\StatusBar\Ya04]])
	media:Register("statusbar", "Ya05", [[Interface\AddOns\NDui\Media\StatusBar\Ya05]])
end

--- 新人加入公会自动欢迎
do
	local function GuildWelcome(event, msg)
		if not NDuiDB["Extras"]["GuildWelcome"] then return end

		local str = GUILDEVENT_TYPE_JOIN:gsub("%%s", "")
		if msg:find(str) then
			local name = msg:gsub(str, "")
			name = Ambiguate(name, "guild")
			if not UnitIsUnit(name, "player") then
				C_Timer.After(random(1000) / 1000, function()
					SendChatMessage(L["Guild Welcome Message"]:format(name), "GUILD")
				end)
			end
		end
	end
	B:RegisterEvent("CHAT_MSG_SYSTEM", GuildWelcome)
end

--- 优化巅峰声望显示
do
	hooksecurefunc("ReputationFrame_Update",function()
		ReputationFrame.paragonFramesPool:ReleaseAll()
		local numFactions = GetNumFactions()
		local factionOffset = FauxScrollFrame_GetOffset(ReputationListScrollFrame)
		for i=1, NUM_FACTIONS_DISPLAYED, 1 do
			local factionIndex = factionOffset + i
			local factionRow = _G["ReputationBar"..i]
			local factionBar = _G["ReputationBar"..i.."ReputationBar"]
			local factionStanding = _G["ReputationBar"..i.."ReputationBarFactionStanding"]
			if factionIndex <= numFactions then
				local factionID = select(14, GetFactionInfo(factionIndex))
				if factionID and C_Reputation.IsFactionParagon(factionID) then
					local currentValue, threshold, _, hasRewardPending = C_Reputation.GetFactionParagonInfo(factionID)
					local value = mod(currentValue, threshold)
					if hasRewardPending then
						local paragonFrame = ReputationFrame.paragonFramesPool:Acquire()
						paragonFrame.factionID = factionID
						paragonFrame:SetPoint("RIGHT", factionRow, 11, 0)
						paragonFrame.Glow:SetShown(true)
						paragonFrame.Check:SetShown(true)
						paragonFrame:Show()
						value = value + threshold
					end
					factionBar:SetMinMaxValues(0, threshold)
					factionBar:SetValue(value)
					factionBar:SetStatusBarColor(0, .5, .9)
					factionRow.rolloverText = HIGHLIGHT_FONT_COLOR_CODE..format(REPUTATION_PROGRESS_FORMAT, BreakUpLargeNumbers(value), BreakUpLargeNumbers(threshold))..FONT_COLOR_CODE_CLOSE
					factionStanding:SetText(L["Paragon"])
					factionRow.standingText = L["Paragon"]
				end
			else
				factionRow:Hide()
			end
		end
	end)
end

--- 鼠标闪光
do
	local cursor = CreateFrame("Frame", nil, UIParent)
	cursor:SetFrameStrata("TOOLTIP")

	local flash = cursor:CreateTexture(nil, "ARTWORK")
	flash:SetTexture(DB.newItemFlash)
	flash:SetBlendMode("ADD")
	flash:SetAlpha(.6)

	local x, y, speed = 0, 0, 0
	local function OnUpdate(_, elapsed)
		if not NDuiDB["Extras"]["StarCursor"] then return end

		local dX, dY = x, y
		x, y = GetCursorPosition()
		dX, dY = x - dX, y - dY

		local weight = 2048 ^ - elapsed
		speed = math.min(weight * speed + (1 - weight) * math.sqrt(dX * dX + dY * dY) / elapsed, 1024)

		local size = speed / 10 - 20
		if size > 0 then
			local scale = UIParent:GetEffectiveScale()
			flash:SetSize(size, size)
			flash:SetPoint("CENTER", UIParent, "BOTTOMLEFT", (x + 0.5 * dX) / scale, (y + 0.5 * dY) / scale)
			flash:Show()
		else
			flash:Hide()
		end
	end

	cursor:SetScript("OnUpdate", OnUpdate)
end

--- /in 命令
do
	local _, SlashIn = ...
	LibStub("AceTimer-3.0"):Embed(SlashIn)

	local MacroEditBox_OnEvent = MacroEditBox:GetScript("OnEvent")

	local function OnCallback(command)
		MacroEditBox_OnEvent(MacroEditBox, "EXECUTE_CHAT_LINE", command)
	end

	SLASH_SLASHIN_IN1 = "/in"
	SLASH_SLASHIN_IN2 = "/slashin"

	function SlashCmdList.SLASHIN_IN(msg)
		local secs, command = msg:match("^([^%s]+)%s+(.*)$")
		secs = tonumber(secs)
		if (not secs) or (#command == 0) then
			print("|cff33ff99SlashIn:|r")
			print("|cff33ff99Usage:|r /in <seconds> <command>")
			print("|cff33ff99Example:|r /in 1.5 /say hi")
		else
			SlashIn:ScheduleTimer(OnCallback, secs, command)
		end
	end
end

--- BOSS战斗自动收起任务追踪
do
	local collapse = false
	local function autoCollapse(event)
		B:UnregisterEvent("PLAYER_ENTERING_WORLD", autoCollapse)

		if event == "ENCOUNTER_START" then
			if not collapse then
				ObjectiveTracker_Collapse()
				collapse = true
			end
		elseif event == "ENCOUNTER_END" then
			if collapse then
				ObjectiveTracker_Expand()
				collapse = false
			end
		end
	end
	B:RegisterEvent("PLAYER_ENTERING_WORLD", autoCollapse)
	B:RegisterEvent("ENCOUNTER_START", autoCollapse)
	B:RegisterEvent("ENCOUNTER_END", autoCollapse)
end

--- 特殊物品购买无需确认
--[[
do
	MerchantItemButton_OnClick = function(self, button, ...)
		if MerchantFrame.selectedTab == 1 then
			MerchantFrame.extendedCost = nil
			MerchantFrame.highPrice = nil
			if button == "LeftButton" then
				if MerchantFrame.refundItem then
					if ContainerFrame_GetExtendedPriceString(MerchantFrame.refundItem, MerchantFrame.refundItemEquipped) then
						return
					end
				end
				PickupMerchantItem(self:GetID())
			else
				BuyMerchantItem(self:GetID())
			end
		end
	end
end
]]