local B, C, L, DB = unpack(select(2, ...))
local Extras = B:RegisterModule("Extras")

-- 频道选择
local function msgChannel()
	if IsInGroup() then
		if IsInRaid() then
			return "RAID"
		else
			return "PARTY"
		end
	end
end

function Extras:OnLogin()
	self:AutoCollapse()
	self:FriendlyNameAutoSet()
	self:GuildWelcome()
	self:InstanceAutoMarke()
	self:InstanceDifficulty()
	self:InstanceReset()

	self:ChatEmote()
	self:DressUp()
	self:IllusionsCheck()
	self:KeystoneHelper()
	self:MountSource()
end

-- 新人加入公会自动欢迎
local GW_Message_Info = {
	L["GW Message 1"],
	L["GW Message 2"],
	L["GW Message 3"],
	L["GW Message 4"],
}

function Extras.UpdateGuildWelcome(_, msg)
	local text = gsub(GUILDEVENT_TYPE_JOIN, "%%s", "")
	if msg:find(text) then
		local name = gsub(msg, text, "")
		name = Ambiguate(name, "guild")
		if not UnitIsUnit(name, "player") then
			C_Timer.After(random(1000) / 1000, function()
				SendChatMessage(string.format(GW_Message_Info[random(4)], name), "GUILD")
			end)
		end
	end
end

function Extras:GuildWelcome()
	if C.db["Extras"]["GuildWelcome"] then
		B:RegisterEvent("CHAT_MSG_SYSTEM", self.UpdateGuildWelcome)
	else
		B:UnregisterEvent("CHAT_MSG_SYSTEM", self.UpdateGuildWelcome)
	end
end

-- BOSS战斗自动收起任务追踪
function Extras.UpdateAutoCollapse(event)
	if event == "ENCOUNTER_START" then
		ObjectiveTracker_Collapse()
	elseif event == "ENCOUNTER_END" then
		ObjectiveTracker_Expand()
	end
end

function Extras:AutoCollapse()
	if C.db["Extras"]["AutoCollapse"] then
		B:RegisterEvent("ENCOUNTER_START", self.UpdateAutoCollapse)
		B:RegisterEvent("ENCOUNTER_END", self.UpdateAutoCollapse)
	else
		B:UnregisterEvent("ENCOUNTER_START", self.UpdateAutoCollapse)
		B:UnregisterEvent("ENCOUNTER_END", self.UpdateAutoCollapse)
	end
end

-- 副本重置自动喊话
function Extras.UpdateInstanceReset(_, msg)
	if strfind(msg, "重置") then
		if not IsInGroup() then
			UIErrorsFrame:AddMessage(DB.InfoColor..msg)
		else
			SendChatMessage(msg, msgChannel())
		end
	end
end

function Extras:InstanceReset()
	B:RegisterEvent("CHAT_MSG_SYSTEM", self.UpdateInstanceReset)
end

-- 副本难度自动喊话
function Extras.UpdateInstanceDifficulty()
	if IsInInstance() and (IsInGroup() and not IsInRaid()) then
		C_Timer.After(.5, function()
			local _, _, difficultyID, difficultyName = GetInstanceInfo()
			if difficultyID ~= 0 and difficultyID ~= 8 and difficultyID ~= 23 then
				if not IsInGroup() then
					UIErrorsFrame:AddMessage(format(DB.InfoColor..L["Instance Difficulty"], difficultyName))
				else
					SendChatMessage(format(L["Instance Difficulty"], difficultyName), msgChannel())
				end
			end
		end)
	end
end

function Extras:InstanceDifficulty()
	B:RegisterEvent("PLAYER_ENTERING_WORLD", self.UpdateInstanceDifficulty)
end

-- 进本自动标记坦克和治疗
function Extras.UpdateInstanceAutoMarke()
	if IsInInstance() and (IsInGroup() and not IsInRaid()) then
		for i = 1, 5 do
			local unit = i == 5 and "player" or ("party"..i)
			local role = UnitGroupRolesAssigned(unit)
			if role == "TANK" then
				SetRaidTarget(unit, 6)
			elseif role == "HEALER" then
				SetRaidTarget(unit, 5)
			end
		end
	end
end

function Extras:InstanceAutoMarke()
	B:RegisterEvent("UPDATE_INSTANCE_INFO", self.UpdateInstanceAutoMarke)
end

-- 自动切换显示友方名字，防止卡屏
function Extras.UpdateFriendlyNameAutoSet()
	if IsInInstance() then
		SetCVar("UnitNameFriendlyPlayerName", 1)
		SetCVar("UnitNameFriendlyMinionName", 1)
	else
		SetCVar("UnitNameFriendlyPlayerName", 0)
		SetCVar("UnitNameFriendlyMinionName", 0)
	end
end

function Extras:FriendlyNameAutoSet()
	B:RegisterEvent("PLAYER_ENTERING_WORLD", self.UpdateFriendlyNameAutoSet)
	B:RegisterEvent("PLAYER_ENTERING_BATTLEGROUND", self.UpdateFriendlyNameAutoSet)
end

-- 自动选择节日BOSS
do
	local function autoSelect()
		for i = 1, GetNumRandomDungeons() do
			local id, name = GetLFGRandomDungeonInfo(i)
			local isHoliday = select(15, GetLFGDungeonInfo(id))
			if isHoliday and not GetLFGDungeonRewards(id) then
				LFDQueueFrame_SetType(id)
			end
		end
	end

	LFDParentFrame:HookScript("OnShow", autoSelect)
end

-- 修复金币文本显示问题
do
	local function resizeMoneyText(frameName, money, forceShow)
		local frame
		if type(frameName) == "table" then
			frame = frameName
			frameName = frame:GetDebugName()
		else
			frame = _G[frameName]
		end
		if not frame.info then return end

		local iconWidth = MONEY_ICON_WIDTH
		if frame.small then
			iconWidth = MONEY_ICON_WIDTH_SMALL
		end

		if ENABLE_COLORBLIND_MODE ~= "1" then
			if (not frame.colorblind) or (not frame.vadjust) or (frame.vadjust ~= MONEY_TEXT_VADJUST) then
				_G[frameName.."GoldButtonText"]:SetPoint("RIGHT", -iconWidth, 0)
				_G[frameName.."SilverButtonText"]:SetPoint("RIGHT", -iconWidth, 0)
				_G[frameName.."CopperButtonText"]:SetPoint("RIGHT", -iconWidth, 0)
			end
		end
	end

	hooksecurefunc("MoneyFrame_Update", resizeMoneyText)
end

-- 修复预创建队伍人数和时间显示问题
do
	local function resizeTextWidth(self)
		if not self.modified then
			if self.Count then self.Count:SetWidth(25) end
			if self.DamagerCount then self.DamagerCount:SetWidth(25) end
			if self.ExpirationTime then self.ExpirationTime:SetWidth(40) end

			self.modified = true
		end
	end

	-- [[ Player Count ]]
	hooksecurefunc("LFGListGroupDataDisplayPlayerCount_Update", resizeTextWidth)

	-- [[ Role Count ]]
	hooksecurefunc("LFGListGroupDataDisplayRoleCount_Update", resizeTextWidth)

	-- [[ Expiration Time ]]
	hooksecurefunc("LFGListSearchEntry_Update", resizeTextWidth)
end

-- 格式化死亡摘要
do
	local function formatDeathRecap(_, addon)
		if addon == "Blizzard_DeathRecap" then
			hooksecurefunc("DeathRecapFrame_OpenRecap", function(recapID)
				local self = DeathRecapFrame
				local events = DeathRecap_GetEvents(recapID)
				local maxHp = UnitHealthMax("player")

				for i = 1, #events do
					local entry = self.DeathRecapEntry[i]
					local dmgInfo = entry.DamageInfo
					local evtData = events[i]

					if evtData.amount then
						local amountStr = "-"..B.FormatNumb(evtData.amount)
						dmgInfo.Amount:SetText(amountStr)
						dmgInfo.AmountLarge:SetText(amountStr)
						dmgInfo.amount = B.FormatNumb(evtData.amount)

						dmgInfo.dmgExtraStr = ""
						if evtData.overkill and evtData.overkill > 0 then
							dmgInfo.dmgExtraStr = format(TEXT_MODE_A_STRING_RESULT_OVERKILLING, B.FormatNumb(evtData.overkill))
							dmgInfo.amount = B.FormatNumb(evtData.amount - evtData.overkill)
						end
						if evtData.absorbed and evtData.absorbed > 0 then
							dmgInfo.dmgExtraStr = dmgInfo.dmgExtraStr..format(TEXT_MODE_A_STRING_RESULT_ABSORB, B.FormatNumb(evtData.absorbed))
							dmgInfo.amount = B.FormatNumb(evtData.amount - evtData.absorbed)
						end
						if evtData.resisted and evtData.resisted > 0 then
							dmgInfo.dmgExtraStr = dmgInfo.dmgExtraStr..format(TEXT_MODE_A_STRING_RESULT_RESIST, B.FormatNumb(evtData.resisted))
							dmgInfo.amount = B.FormatNumb(evtData.amount - evtData.resisted)
						end
						if evtData.blocked and evtData.blocked > 0 then
							dmgInfo.dmgExtraStr = dmgInfo.dmgExtraStr..format(TEXT_MODE_A_STRING_RESULT_BLOCK, B.FormatNumb(evtData.blocked))
							dmgInfo.amount = B.FormatNumb(evtData.amount - evtData.blocked)
						end
					end

					dmgInfo.hpPercent = format("%.1f", evtData.currentHP / maxHp * 100)
				end
			end)
		end
	end

	B:RegisterEvent("ADDON_LOADED", formatDeathRecap)
end

-- 格式化货币数值
do

	hooksecurefunc("AltCurrencyFrame_Update", function(frameName, texture, cost)
		local button = _G[frameName]
		button:SetText(B.FormatNumb(cost))
	end)

	hooksecurefunc("MerchantFrame_UpdateCurrencies", function()
		local currencies = {GetMerchantCurrencies()}

		if #currencies ~= 0 then
			local numCurrencies = #currencies
			for index = 1, numCurrencies do
				local tokenButton = _G["MerchantToken"..index]
				if tokenButton and currencies[index] then
					local count = C_CurrencyInfo.GetCurrencyInfo(currencies[index]).quantity
					tokenButton.count:SetText(B.FormatNumb(count))
				end
			end
		end
	end)

	hooksecurefunc("MerchantFrame_UpdateCurrencyAmounts", function()
		for i = 1, MAX_MERCHANT_CURRENCIES do
			local tokenButton = _G["MerchantToken"..i]
			if tokenButton and tokenButton.currencyID then
				local count = C_CurrencyInfo.GetCurrencyInfo(tokenButton.currencyID).quantity
				tokenButton.count:SetText(B.FormatNumb(count))
			end
		end
	end)

	local function formatCurrency()
		local buttons = TokenFrameContainer.buttons
		if not buttons then return end

		local offset = HybridScrollFrame_GetOffset(TokenFrameContainer)
		local index
		for i = 1, #buttons do
			index = offset + i

			local currencyInfo = C_CurrencyInfo.GetCurrencyListInfo(index)
			if not currencyInfo then return end

			local count = currencyInfo.quantity
			local button = buttons[i]
			if not button.isHeader and count then
				button.count:SetText(B.FormatNumb(count))
			end
		end
	end

	hooksecurefunc("TokenFrame_Update", formatCurrency)
	hooksecurefunc(TokenFrameContainer, "update", formatCurrency)
end

-- 格式化经验值
do
	hooksecurefunc("LFGRewardsFrame_UpdateFrame", function(parentFrame, dungeonID)
		if not dungeonID then return end

		local experienceGained = select(4, GetLFGDungeonRewards(dungeonID))
		if experienceGained > 0 then
			parentFrame.xpAmount:SetText(B.FormatNumb(experienceGained))
		end
	end)
end