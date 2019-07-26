local B, C, L, DB = unpack(select(2, ...))
local Extras = B:RegisterModule("Extras")

local strformat = string.format

function Extras:OnLogin()
	self:ChatAtFriends()
	self:ChatEmote()
	self:DressUp()
	self:KeystoneHelper()
	self:MountSource()
	self:Reskins()
	self:GuildWelcome()
	self:AutoCollapse()
end

--- 新人加入公会自动欢迎
local GW_Message_Info = {
	L["GW Message 1"],
	L["GW Message 2"],
	L["GW Message 3"],
	L["GW Message 4"],
}

function Extras:UpdateGuildWelcome(event, msg)
	local str = GUILDEVENT_TYPE_JOIN:gsub("%%s", "")
	if msg:find(str) then
		local name = msg:gsub(str, "")
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
		B:RegisterEvent("CHAT_MSG_SYSTEM", Extras.UpdateGuildWelcome)
	else
		B:UnregisterEvent("CHAT_MSG_SYSTEM", Extras.UpdateGuildWelcome)
	end
end

--- BOSS战斗自动收起任务追踪
local collapse = false
function Extras:UpdateAutoCollapse(event)
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
	if NDuiDB["Extras"]["GuildWelcome"] then
		B:RegisterEvent("ENCOUNTER_START", Extras.UpdateAutoCollapse)
		B:RegisterEvent("ENCOUNTER_END", Extras.UpdateAutoCollapse)
	else
		collapse = false
		B:UnregisterEvent("ENCOUNTER_START", Extras.UpdateAutoCollapse)
		B:UnregisterEvent("ENCOUNTER_END", Extras.UpdateAutoCollapse)
	end
end

--- 自动选择节日BOSS
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

--- 修复预创建队伍人数显示问题
do
	-- [[ Player Count ]]
	hooksecurefunc("LFGListGroupDataDisplayPlayerCount_Update", function(self)
		if not self.revised then
			self.Count:SetWidth(20)

			self.revised = true
		end
	end)

	-- [[ Role Count ]]
	hooksecurefunc("LFGListGroupDataDisplayRoleCount_Update", function(self)
		if not self.revised then
			self.TankCount:SetWidth(20)
			self.HealerCount:SetWidth(20)
			self.DamagerCount:SetWidth(20)

			self.revised = true
		end
	end)
end

-- 格式化货币数值
do
	hooksecurefunc("AltCurrencyFrame_Update", function(frameName, texture, cost, canAfford)
		local button = _G[frameName]
		button:SetText(B.Numb(cost))
	end)

	hooksecurefunc("MerchantFrame_UpdateCurrencies", function()
		local currencies = {GetMerchantCurrencies()}

		if #currencies ~= 0 then
			local numCurrencies = #currencies
			for index = 1, numCurrencies do
				local tokenButton = _G["MerchantToken"..index]
				if tokenButton and currencies[index] then
					local count = select(2, GetCurrencyInfo(currencies[index]))
					tokenButton.count:SetText(B.Numb(count))
				end
			end
		end
	end)

	hooksecurefunc("MerchantFrame_UpdateCurrencyAmounts", function()
		for i = 1, MAX_MERCHANT_CURRENCIES do
			local tokenButton = _G["MerchantToken"..i]
			if tokenButton and tokenButton.currencyID then
				local count = select(2, GetCurrencyInfo(tokenButton.currencyID))
				tokenButton.count:SetText(B.Numb(count))
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
			if not bu.isHeader then
				bu.count:SetText(B.Numb(count))
			end
		end
	end

	hooksecurefunc("TokenFrame_Update", formatCurrency)
	hooksecurefunc(TokenFrameContainer, "update", formatCurrency)
end