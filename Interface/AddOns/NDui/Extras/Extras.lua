local B, C, L, DB = unpack(select(2, ...))
local module = B:RegisterModule("Extras")

local strformat = string.format

function module:OnLogin()
	self:ChatAtFriends()
	self:ChatEmote()
end

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
	local GW_Message_Info = {
		L["GW Message 1"],
		L["GW Message 2"],
		L["GW Message 3"],
		L["GW Message 4"],
	}
	local function GuildWelcome(event, msg)
		if not NDuiDB["Extras"]["GuildWelcome"] then return end

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

	B:RegisterEvent("CHAT_MSG_SYSTEM", GuildWelcome)
end

--- BOSS战斗自动收起任务追踪
do
	local collapse = false
	local function autoCollapse(event)
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

	B:RegisterEvent("ENCOUNTER_START", autoCollapse)
	B:RegisterEvent("ENCOUNTER_END", autoCollapse)
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