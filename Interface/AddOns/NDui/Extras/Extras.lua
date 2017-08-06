local B, C, L, DB = unpack(select(2, ...))

--- 重定义部分函数
BAG_ITEM_QUALITY_COLORS[0] = { r = 0.4, g = 0.4, b = 0.4 }
BAG_ITEM_QUALITY_COLORS[1] = { r = 0.9, g = 0.9, b = 0.9 }
BAG_ITEM_QUALITY_COLORS[LE_ITEM_QUALITY_POOR] = { r = 0.4, g = 0.4, b = 0.4 }
BAG_ITEM_QUALITY_COLORS[LE_ITEM_QUALITY_COMMON] = { r = 0.9, g = 0.9, b = 0.9 }

GOLD_AMOUNT = "%d|c00ffd700金|r"
SILVER_AMOUNT = "%d|c00c7c7cf银|r"
COPPER_AMOUNT = "%d|c00eda55f铜|r"

--- 修复世界地图错位
local old_ResetZoom = _G.WorldMapScrollFrame_ResetZoom
_G.WorldMapScrollFrame_ResetZoom = function()
	if _G.InCombatLockdown() then
		_G.WorldMapFrame_Update()
		_G.WorldMapScrollFrame_ReanchorQuestPOIs()
		_G.WorldMapFrame_ResetPOIHitTranslations()
		_G.WorldMapBlobFrame_DelayedUpdateBlobs()
	else
		old_ResetZoom()
	end
end

--- 共享计量条材质
local media = LibStub("LibSharedMedia-3.0")
media:Register("statusbar", "Altz01", [[Interface\AddOns\NDui\Media\StatusBar\Altz01]])
media:Register("statusbar", "Altz02", [[Interface\AddOns\NDui\Media\StatusBar\Altz02]])
media:Register("statusbar", "Altz03", [[Interface\AddOns\NDui\Media\StatusBar\Altz03]])
media:Register("statusbar", "Altz04", [[Interface\AddOns\NDui\Media\StatusBar\Altz04]])
media:Register("statusbar", "MaoR", [[Interface\AddOns\NDui\Media\StatusBar\MaoR]])
media:Register("statusbar", "normTex", [[Interface\AddOns\NDui\Media\normTex]])
media:Register("statusbar", "Ray01", [[Interface\AddOns\NDui\Media\StatusBar\Ray01]])
media:Register("statusbar", "Ray02", [[Interface\AddOns\NDui\Media\StatusBar\Ray02]])
media:Register("statusbar", "Ray03", [[Interface\AddOns\NDui\Media\StatusBar\Ray03]])
media:Register("statusbar", "Ray04", [[Interface\AddOns\NDui\Media\StatusBar\Ray04]])
media:Register("statusbar", "Ya01", [[Interface\AddOns\NDui\Media\StatusBar\Ya01]])
media:Register("statusbar", "Ya02", [[Interface\AddOns\NDui\Media\StatusBar\Ya02]])
media:Register("statusbar", "Ya03", [[Interface\AddOns\NDui\Media\StatusBar\Ya03]])
media:Register("statusbar", "Ya04", [[Interface\AddOns\NDui\Media\StatusBar\Ya04]])
media:Register("statusbar", "Ya05", [[Interface\AddOns\NDui\Media\StatusBar\Ya05]])

--- 自动填写DELETE
hooksecurefunc(StaticPopupDialogs["DELETE_GOOD_ITEM"], "OnShow", function(self)
	self.editBox:SetText(DELETE_ITEM_CONFIRM_STRING)
end)

--- 进入/脱离战斗提示
local CombatAlert = NDui:EventFrame({"PLAYER_REGEN_ENABLED", "PLAYER_REGEN_DISABLED"})
CombatAlert:SetScript("OnEvent", function(self, event)
	if UnitIsDead("player") then return end
	if event == "PLAYER_REGEN_ENABLED" then
		B.AlertRun(LEAVING_COMBAT.."！", 0.1, 1, 0.1)
	elseif event == "PLAYER_REGEN_DISABLED" then
		B.AlertRun(ENTERING_COMBAT.."！", 1, 0.1, 0.1)
	end
end)

--- 进入PVP地区自动切换TAB功能
local PvPTab = NDui:EventFrame({"ZONE_CHANGED_NEW_AREA", "DUEL_REQUESTED", "DUEL_FINISHED"})
PvPTab:SetScript("OnEvent", function(self, event)
	local bindSet = GetCurrentBindingSet()
	local pvpType = GetZonePVPInfo()
	local _, zoneType = IsInInstance()

	if (zoneType == "arena") or (zoneType == "pvp") or (pvpType == "combat") or (event == "DUEL_REQUESTED") then
		SetBinding("TAB", "TARGETNEARESTENEMYPLAYER")
		SetBinding("SHIFT-TAB", "TARGETPREVIOUSENEMYPLAYER")
		--print("TAB目标选择增强功能 |cff00FF00已开启")
	else
		SetBinding("TAB", "TARGETNEARESTENEMY")
		SetBinding("SHIFT-TAB", "TARGETPREVIOUSENEMY")
		--print("TAB目标选择增强功能 |cffFF0000已关闭")
	end

	SaveBindings(bindSet)
end)

--- 优化巅峰声望显示
hooksecurefunc("ReputationFrame_Update",function()
	ReputationFrame.paragonFramesPool:ReleaseAll()
	local numFactions = GetNumFactions()
	local factionOffset = FauxScrollFrame_GetOffset(ReputationListScrollFrame)
	for i=1, NUM_FACTIONS_DISPLAYED, 1 do
		local factionIndex = factionOffset + i
		local factionRow = _G["ReputationBar"..i]
		local factionBar = _G["ReputationBar"..i.."ReputationBar"]
		local factionStanding = _G["ReputationBar"..i.."ReputationBarFactionStanding"]
		if ( factionIndex <= numFactions ) then
			local _, _, _, _, _, _, _, _, _, _, _, _, _, factionID = GetFactionInfo(factionIndex)
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

--- 神器能量提示当前专精和武器
GameTooltip:HookScript("OnTooltipSetItem", function(self)
	local _, link = self:GetItem()
	if type(link) == "string" then
		if IsArtifactPowerItem(link) then
			local artifactID, _, artifactName = C_ArtifactUI.GetEquippedArtifactInfo()
			if artifactName then
				local spec = GetSpecialization()
				local _, specName = GetSpecializationInfo(spec)
				if artifactName then
					self:AddLine(" ")
					self:AddDoubleLine(format(DB.MyColor.."<%s>", specName), format("|cffe6cc80[%s]", artifactName))
					self:Show()
				end
			end
		end
	end
end)

--- 特殊物品购买无需确认
--[[
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
]]