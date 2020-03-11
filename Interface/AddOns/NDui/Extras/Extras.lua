local B, C, L, DB = unpack(select(2, ...))
local Extras = B:RegisterModule("Extras")

local strformat = string.format

-- 钥石数据
Extras.MythicLoot =  {0, 435, 435, 440, 445, 445, 450, 455, 455, 455, 460, 460, 460, 465, 465}
Extras.WeeklyLoot =  {0, 440, 445, 450, 450, 455, 460, 460, 460, 465, 465, 470, 470, 470, 475}

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
	self:ChatEmote()
	self:DressUp()
	self:KeystoneHelper()
	self:MountSource()
	self:GuildWelcome()
	self:AutoCollapse()
	self:InstanceReset()
end

-- 新人加入公会自动欢迎
local GW_Message_Info = {
	L["GW Message 1"],
	L["GW Message 2"],
	L["GW Message 3"],
	L["GW Message 4"],
}

function Extras.UpdateGuildWelcome(_, msg)
	local str = gsub(GUILDEVENT_TYPE_JOIN, "%%s", "")
	if msg:find(str) then
		local name = gsub(msg, str, "")
		name = Ambiguate(name, "guild")
		if not UnitIsUnit(name, "player") then
			C_Timer.After(random(1000) / 1000, function()
				SendChatMessage(strformat(GW_Message_Info[random(4)], name), "GUILD")
			end)
		end
	end
end

function Extras:GuildWelcome()
	if NDuiDB["Extras"]["GuildWelcome"] then
		B:RegisterEvent("CHAT_MSG_SYSTEM", self.UpdateGuildWelcome)
	else
		B:UnregisterEvent("CHAT_MSG_SYSTEM", self.UpdateGuildWelcome)
	end
end

-- BOSS战斗自动收起任务追踪
local collapse = false
function Extras.UpdateAutoCollapse(event)
	if event == "ENCOUNTER_START" then
		if not collapse then
			ObjectiveTracker_Collapse()

			collapse = true
		end
	else
		if collapse then
			ObjectiveTracker_Expand()

			collapse = false
		end
	end
end

function Extras:AutoCollapse()
	if NDuiDB["Extras"]["AutoCollapse"] then
		B:RegisterEvent("ENCOUNTER_START", self.UpdateAutoCollapse)
		B:RegisterEvent("ENCOUNTER_END", self.UpdateAutoCollapse)
	else
		collapse = false
		B:UnregisterEvent("ENCOUNTER_START", self.UpdateAutoCollapse)
		B:UnregisterEvent("ENCOUNTER_END", self.UpdateAutoCollapse)
	end
end

-- 重置副本自动喊话
local resetList = {"无法重置", "已被重置"}
function Extras.UpdateInstanceReset(_, msg)
	for _, word in ipairs(resetList) do
		if strfind(msg, word) then
			if not IsInGroup() then
				UIErrorsFrame:AddMessage(DB.InfoColor..msg)
			else
				SendChatMessage(msg, msgChannel())
			end
		end
	end
end

function Extras:InstanceReset()
	B:RegisterEvent("CHAT_MSG_SYSTEM", self.UpdateInstanceReset)
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
					local count = select(2, GetCurrencyInfo(currencies[index]))
					tokenButton.count:SetText(B.FormatNumb(count))
				end
			end
		end
	end)

	hooksecurefunc("MerchantFrame_UpdateCurrencyAmounts", function()
		for i = 1, MAX_MERCHANT_CURRENCIES do
			local tokenButton = _G["MerchantToken"..i]
			if tokenButton and tokenButton.currencyID then
				local count = select(2, GetCurrencyInfo(tokenButton.currencyID))
				tokenButton.count:SetText(B.FormatNumb(count))
			end
		end
	end)

	local function formatCurrency()
		local buttons = TokenFrameContainer.buttons
		if not buttons then return end

		local offset = HybridScrollFrame_GetOffset(TokenFrameContainer)
		local index, count
		for i = 1, #buttons do
			index = offset + i
			count = select(6, GetCurrencyListInfo(index))

			local bu = buttons[i]
			if not bu.isHeader and count then
				bu.count:SetText(B.FormatNumb(count))
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