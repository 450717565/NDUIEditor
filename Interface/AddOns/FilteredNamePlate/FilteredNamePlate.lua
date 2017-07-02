local _
local _G = _G
FilteredNamePlate = {}
local L = FNP_LOCALE_TEXT
local FilteredNamePlate = FilteredNamePlate

SLASH_FilteredNamePlate1 = "/fnp"
local GetNamePlateForUnit = C_NamePlate.GetNamePlateForUnit
local GetNamePlates = C_NamePlate.GetNamePlates
local UnitName, GetUnitName = UnitName, GetUnitName
local string_find = string.find
local FilterNp_EventList = FilterNp_EventList

local IS_REGISGER, IsCurOnlyShowStat, currentNpFlag, isScaleListInited, isUIErrorInOneLoad, isNullOnlyList, isNullFilterList

local CurrentScaleList, CurrentOrigScaleList

local spellcastScale = 0.5

local function getTableCount(atab)
	local count = 0
    for pos, name in ipairs(atab) do
        count = count + 1
    end
	return count
end

--Fnp_Mode  仅显模式 true 过滤模式 false 暂时去掉过滤模式，其实没什么用
--Fnp_OtherNPFlag 0是默认 1是TidyPlate模式 2是Kui 3是EUI 4是NDUI

local function initFnp_SavedScaleList_only(curFlag)
	if curFlag == 0 then
		Fnp_SavedScaleList.only = 1.4
	elseif curFlag == 1 then
		Fnp_SavedScaleList.only = 1.35
	elseif curFlag == 2 then
		Fnp_SavedScaleList.only = 1.5
	else
		Fnp_SavedScaleList.only = 1.45
	end
end

local function registerMyEvents(self, event, ...)
	if IS_REGISGER == true then return end
	if Fnp_Enable == nil then
		Fnp_Enable = true
	end

	if Fnp_OtherNPFlag == nil then
		Fnp_OtherNPFlag = 4
	end

	currentNpFlag = Fnp_OtherNPFlag

	if Fnp_ONameList == nil then
		Fnp_ONameList = {}
		table.insert(Fnp_ONameList, "邪能炸药")
	end

	if Fnp_FNameList == nil then
		Fnp_FNameList = {}
	end

	if IsCurOnlyShowStat == nil then
		IsCurOnlyShowStat = false
	end

	if Fnp_SavedScaleList == nil then
		Fnp_SavedScaleList = {
			normal = 1.00,
			small = 0.50,
			only = 1.50,
		}
		initFnp_SavedScaleList_only(currentNpFlag)
	else -- V4 update to V5
		if Fnp_SavedScaleList.only == nil then initFnp_SavedScaleList_only(currentNpFlag) end
	end

	isNullOnlyList = false
	isNullFilterList = false
	if getTableCount(Fnp_ONameList) == 0 then isNullOnlyList = true end
	if getTableCount(Fnp_FNameList) == 0 then isNullFilterList = true end

	isScaleListInited = false

	if Fnp_Enable == true then
		FilteredNamePlate.isSettingChanged = false
		for k, v in pairs(FilterNp_EventList) do
			if k ~= "PLAYER_ENTERING_WORLD" then
				self:RegisterEvent(k,v)
			end
        end
		IS_REGISGER = true
	end
end

local function unRegisterMyEvents(self)
	if IS_REGISGER == true then
		IS_REGISGER = false
		Fnp_Enable = false
		for k, v in pairs(FilterNp_EventList) do
			if k ~= "PLAYER_ENTERING_WORLD" then
				self:UnregisterEvent(k,v)
			end
        end
	end
end

local function isMatchedNameList(tabList, tName)
	if tName == nil then return false end

	local isMatch = false
	for key, var in ipairs(tabList) do
		local _, ret = string_find(tName, var)
		if ret ~= nil then
			isMatch = true
			break
		end
	end
	return isMatch
end

---------kkkkk---kkkkk---kkkkk-------------
local function reinitScaleValues()
	CurrentScaleList.normal = CurrentScaleList.SYSTEM * Fnp_SavedScaleList.normal
	CurrentScaleList.small = CurrentScaleList.normal * Fnp_SavedScaleList.small
	CurrentScaleList.middle = CurrentScaleList.normal * spellcastScale
	CurrentScaleList.only = CurrentScaleList.SYSTEM * Fnp_SavedScaleList.only

	CurrentOrigScaleList.name.normal = CurrentOrigScaleList.name.SYSTEM
	CurrentOrigScaleList.name.small = CurrentOrigScaleList.name.normal * Fnp_SavedScaleList.small
	CurrentOrigScaleList.name.middle = CurrentOrigScaleList.name.small
	if CurrentOrigScaleList.name.small < 30 then
		CurrentOrigScaleList.name.small = 30
		CurrentOrigScaleList.name.middle = 30
	end
	CurrentOrigScaleList.bars.heal_onlyHeight = CurrentOrigScaleList.bars.HEAL_SYS_HEIGHT * Fnp_SavedScaleList.only;
	CurrentOrigScaleList.bars.cast_midHeight = CurrentOrigScaleList.bars.CAST_SYS_HEIGHT * 0.5;
end


local function initScaleValues()
	local indx = currentNpFlag

	if isScaleListInited == true then
		reinitScaleValues()
		return
	end

	for _, frame in pairs(GetNamePlates()) do
		local foundUnit = frame.namePlateUnitToken or (frame.UnitFrame and frame.UnitFrame.unit)
		if foundUnit then
			CurrentScaleList = { -- 一种原始保存,三种不同状态下的scale value
			SYSTEM = 0.78,
			normal = 1.0,
			small = 0.20,
			middle = spellcastScale,
			only = 1.45,
			};
			CurrentOrigScaleList = {
				name = {
					SYSTEM = 130,
					normal = 130,
					small = 40,
					middle = 40,
				},
				bars = {
					HEAL_SYS_HEIGHT = 10.8,
					heal_onlyHeight = 15.0,
					CAST_SYS_HEIGHT = 10.8,
					cast_midHeight = 5.4
				}
			}
			local sys = 0
			if indx == 4 then
				if frame.unitFrame then
					sys = frame.unitFrame:GetEffectiveScale()
				end
			elseif indx == 3 then --EUI
				if frame.UnitFrame then
					sys = frame.UnitFrame:GetEffectiveScale()
				end
			elseif indx == 1 then --Tidy
				if frame.carrier then
					sys = frame.carrier:GetEffectiveScale()
				end
			elseif indx == 2 then -- Kui
				if frame.kui then
					sys = frame.kui:GetEffectiveScale()
				end
			elseif indx == 0 then --Orig
				if frame.UnitFrame then
					sys = 1
					CurrentOrigScaleList.name.SYSTEM = frame.UnitFrame:GetWidth()
					CurrentOrigScaleList.bars.HEAL_SYS_HEIGHT = frame.UnitFrame.healthBar:GetHeight()
					CurrentOrigScaleList.bars.CAST_SYS_HEIGHT = frame.UnitFrame.castBar:GetHeight()
				end
			end
			if sys > 0.01 then -- it's a real info
				CurrentScaleList.SYSTEM = sys
				reinitScaleValues()
				isScaleListInited = true
				break
			end
		end
	end
end

local hideSwitchSingleUnit = {
	[0] = function(frame)
		if frame == nil then return end
		if frame.UnitFrame then
			frame.UnitFrame.name:SetWidth(CurrentOrigScaleList.name.small)
			frame.UnitFrame.healthBar:Hide()
			frame.UnitFrame.castBar:SetHeight(CurrentOrigScaleList.bars.cast_midHeight)
		end
	end,
	[1] = function(frame)
		if frame == nil then return end
		if frame.carrier then
			frame.carrier:SetScale(CurrentScaleList.small)
		end
	end,
	[2] = function(frame)
		if frame == nil then return end
		if frame.kui then
			frame.kui:SetScale(CurrentScaleList.small)
		end
	end,
	[3] = function(frame)
		if frame == nil then return end
		if frame.UnitFrame then
			frame.UnitFrame:SetScale(CurrentScaleList.small)
		end
	end,
	[4] = function(frame)
		if frame == nil then return end
		if frame.unitFrame then
			frame.unitFrame:SetScale(CurrentScaleList.small)
		end
	end
}

local function showCustomSingleUnit(customFrame,isOnlyShowSpellCast,restore, isOnlyUnit)
	if customFrame then
		if restore == true then
			customFrame:SetScale(CurrentScaleList.SYSTEM)
		elseif isOnlyShowSpellCast == false then
			if isOnlyUnit == true then
				customFrame:SetScale(CurrentScaleList.only)
			else
				customFrame:SetScale(CurrentScaleList.normal)
			end
		else
			customFrame:SetScale(CurrentScaleList.middle)
		end
	end
end

--isOnlyShowSpellCast 的情况下，就代表是仅显模式。并且该怪是非仅显目标而且施法了！
local showSwitchSingleUnit = {
	[0] = function(frame, isOnlyShowSpellCast, restore, isOnlyUnit)
		if frame.UnitFrame then
			if restore == true then
				frame.UnitFrame.name:SetWidth(CurrentOrigScaleList.name.SYSTEM)
				frame.UnitFrame.healthBar:Show()
				frame.UnitFrame.healthBar:SetHeight(CurrentOrigScaleList.bars.HEAL_SYS_HEIGH)
				frame.UnitFrame.castBar:SetHeight(CurrentOrigScaleList.bars.CAST_SYS_HEIGHT)
			elseif isOnlyShowSpellCast == false then
				frame.UnitFrame.name:SetWidth(CurrentOrigScaleList.name.normal)
				frame.UnitFrame.healthBar:Show()
				frame.UnitFrame.castBar:SetHeight(CurrentOrigScaleList.bars.CAST_SYS_HEIGHT)
				if isOnlyUnit then
					frame.UnitFrame.healthBar:SetHeight(CurrentOrigScaleList.bars.heal_onlyHeight)
				else
					frame.UnitFrame.healthBar:SetHeight(CurrentOrigScaleList.bars.HEAL_SYS_HEIGHT)
				end
			else
				frame.UnitFrame.name:SetWidth(CurrentOrigScaleList.name.middle)
				frame.UnitFrame.castBar:SetHeight(CurrentOrigScaleList.bars.cast_midHeight)
				--frame.UnitFrame.healthBar:Show()
			end
		end
	end,
	[1] = function(frame, isOnlyShowSpellCast, restore, isOnlyUnit)
		showCustomSingleUnit(frame.carrier,isOnlyShowSpellCast,restore, isOnlyUnit)
	end,
	[2] = function(frame, isOnlyShowSpellCast, restore, isOnlyUnit)
		showCustomSingleUnit(frame.kui,isOnlyShowSpellCast,restore, isOnlyUnit)
	end,
	[3] = function(frame, isOnlyShowSpellCast, restore, isOnlyUnit)
		showCustomSingleUnit(frame.UnitFrame,isOnlyShowSpellCast,restore, isOnlyUnit)
	end,
	[4] = function(frame, isOnlyShowSpellCast, restore, isOnlyUnit)
		showCustomSingleUnit(frame.unitFrame,isOnlyShowSpellCast,restore, isOnlyUnit)
	end,
}

function FilteredNamePlate.actionUnitStateAfterChanged()
    --FilteredNamePlate.printSavedScaleList(Fnp_SavedScaleList)
	initScaleValues()
	local matched = false
	local matched2 = false
	if Fnp_Enable == true then
		IsCurOnlyShowStat = false
		--仅显
		isNullOnlyList = false
		if getTableCount(Fnp_ONameList) == 0 then isNullOnlyList = true end
		--过滤
		isNullFilterList = false
		if getTableCount(Fnp_FNameList) == 0 then isNullFilterList = true end
		local isHide = false
		for _, frame in pairs(GetNamePlates()) do
			if isNullOnlyList == true then
				matched2 = false
				if isNullFilterList == false then
					local foundUnit = frame.namePlateUnitToken or (frame.UnitFrame and frame.UnitFrame.unit)
					matched2 = isMatchedNameList(Fnp_FNameList, GetUnitName(foundUnit))
				end
				if matched2 == true then
					hideSwitchSingleUnit[currentNpFlag](frame)
				else
					showSwitchSingleUnit[currentNpFlag](frame, false, false, false) -- 全是普通情况
				end
			else
				local foundUnit = frame.namePlateUnitToken or (frame.UnitFrame and frame.UnitFrame.unit)
				matched = isMatchedNameList(Fnp_ONameList, GetUnitName(foundUnit))
				if matched == true then
					isHide = true
					break
				end
			end
		end
		if isHide == true then
			for _, frame in pairs(GetNamePlates()) do
				local foundUnit = frame.namePlateUnitToken or (frame.UnitFrame and frame.UnitFrame.unit)
				matched = isMatchedNameList(Fnp_ONameList, GetUnitName(foundUnit))
				if matched == true then
					-- 仅显模式仅显的怪
					showSwitchSingleUnit[currentNpFlag](frame, false, false, true)
				else
					hideSwitchSingleUnit[currentNpFlag](frame)
				end
			end
			IsCurOnlyShowStat = true
		else
			for _, frame in pairs(GetNamePlates()) do
				-- 普通模式
				showSwitchSingleUnit[currentNpFlag](frame, false, false, false)
			end	
		end
		-- registerMyEvents(FilteredNamePlate_Frame, "", "")
	else -- 已经关闭功能就全部显示
		for _, frame in pairs(GetNamePlates()) do
			local foundUnit = frame.namePlateUnitToken or (frame.UnitFrame and frame.UnitFrame.unit)
			if foundUnit then
				-- disable 还原了！
				showSwitchSingleUnit[currentNpFlag](frame, false, true, false)
			end
		end
		IsCurOnlyShowStat = false
		-- unRegisterMyEvents(FilteredNamePlate_Frame)
	end
end

local function getNamePlateFromPlatesById(unitid)
	for _, frame in pairs(GetNamePlates()) do
		local foundUnit = frame.namePlateUnitToken or (frame.UnitFrame and frame.UnitFrame.unit)
		if foundUnit and (foundUnit == unitid) then
			return frame
		end
	end
	return nil
end

local function actionUnitAddedForce(unitid)
	local addedname = UnitName(unitid)
	-- 0. 当前Add的单位名,是否match filter
	local curFilterMatch = false
	if isNullFilterList == false then curFilterMatch = isMatchedNameList(Fnp_FNameList, addedname) end
	if curFilterMatch == true then
		local frame = GetNamePlateForUnit(unitid)
		hideSwitchSingleUnit[currentNpFlag](frame)
		return
	end
	-- 1. 当前add的单位名,是否match
	local curOnlyMatch = isMatchedNameList(Fnp_ONameList, addedname)
	if curOnlyMatch == false and IsCurOnlyShowStat == true then
		--新增单位不需要仅显,但是目前处于仅显情况下, 那么,就将当前这个Hide TODO 这里改成直接用自己,而不是用GetNamePlates
		-- local frame = getNamePlateFromPlatesById(unitid)
		local frame = GetNamePlateForUnit(unitid)
		hideSwitchSingleUnit[currentNpFlag](frame)
	elseif curOnlyMatch == false and IsCurOnlyShowStat == false then
		-- 新增单位不需要仅显, 此时也没有仅显, 就不管了.现在我们将当前的效果展示出来
		showSwitchSingleUnit[currentNpFlag](GetNamePlateForUnit(unitid), false, false, false)
	elseif curOnlyMatch == true and IsCurOnlyShowStat == true then
		-- 新增单位是需要仅显的,而此时已经有仅显的了,于是我们什么也不用干 -- 更新，怀疑在异步调用的时候莫名奇妙被hide了这里开出来确保
		showSwitchSingleUnit[currentNpFlag](GetNamePlateForUnit(unitid), false, false, true)
	elseif curOnlyMatch == true and IsCurOnlyShowStat == false then
		--新增单位是需要仅显的,而此时不是仅显, 于是我们就将之前的都Hide,当前这个不用处理
		for _, frame in pairs(GetNamePlates()) do
			local foundUnit = frame.namePlateUnitToken or (frame.UnitFrame and frame.UnitFrame.unit)
			if foundUnit then
				-- TODO 判断是否是正在读条
				if (unitid == foundUnit) then
					-- 刚刚进入仅显模式！这个是仅显单位，那么将他变大一些
					showSwitchSingleUnit[currentNpFlag](frame, false, false, true)
				else
					hideSwitchSingleUnit[currentNpFlag](frame)
				end
			end
		end
		IsCurOnlyShowStat = true
	end
end

local function actionUnitRemovedForce(unitid)
	-- 1. 当前移除的单位名,是否match
	local curOnlyMatch = isMatchedNameList(Fnp_ONameList, UnitName(unitid))
	if curOnlyMatch == true then
		-- 移除单位是需要仅显的,而此时肯定已经仅显,
		--于是我们判断剩余的是否还含有,如果还有就什么也不动.如果没有了,就恢复显示
		local matched = false
		local name = ""
		for _, frame in pairs(GetNamePlates()) do
			local foundUnit = frame.namePlateUnitToken or (frame.UnitFrame and frame.UnitFrame.unit)
			if foundUnit then
				matched = isMatchedNameList(Fnp_ONameList, GetUnitName(foundUnit))
				if matched == true then
					return --have & return
				end
			end
		end
		--没有找到,说明我们该退出了就显示
		for _, frame in pairs(GetNamePlates()) do
			local foundUnit = frame.namePlateUnitToken or (frame.UnitFrame and frame.UnitFrame.unit)
			if foundUnit then
				matched = isMatchedNameList(Fnp_ONameList, GetUnitName(foundUnit))
				if matched == false then
					-- 退出仅显模式， 说明这些都是普通
					showSwitchSingleUnit[currentNpFlag](frame, false, false, false)
				end
			end
		end
		IsCurOnlyShowStat = false
	end
end
---------k k k---k k k---k k k-------------

local function actionUnitAdded(self, event, ...)
	if isScaleListInited == false then
		initScaleValues()
	end
	
	if isScaleListInited == false then
		if isUIErrorInOneLoad == false then
			isUIErrorInOneLoad = true
			print(L.FNP_PRINT_ERROR_UITYPE)
			print(L.FNP_PRINT_ERROR_UITYPE)
			print(L.FNP_PRINT_ERROR_UITYPE)
		end
		return
	end
	if isNullOnlyList == true and isNullFilterList == true then
		return
	end

	local unitid = ...
	if UnitIsPlayer(unitid) then
		return
	end
	if Fnp_Enable == false then return end
	actionUnitAddedForce(unitid)
end

local function actionUnitRemoved(self, event, ...)
	--这里不需要判断是否为空
	-- if isNullOnlyList == true and isNullFilterList == true then
	--	return
	-- end
	if IsCurOnlyShowStat == false then
		-- 当前处于没有仅显模式,表明所有血条都开着的
		return
	end
	local unitid = ...
	if UnitIsPlayer(unitid) then
		return
	end
	actionUnitRemovedForce(unitid)
end
--[[
local function actionTargetChanged(self, event, ...)
end
--]]

local function actionUnitSpellCastStartOnlyShowMode(...)
	if IsCurOnlyShowStat == false then
		-- 当前处于没有仅显模式,表明所有血条都开着的
		return
	end
	local unitid = ...
	if UnitIsPlayer(unitid) then
		return
	end
	local curName = UnitName(unitid)
	if curName == nil then return end
	local curMatch = isMatchedNameList(Fnp_ONameList, curName)
	-- true的话，表明是我们要的，那么肯定是在显示了。就不管了
	if curMatch == false then 
		local frame = GetNamePlateForUnit(unitid)
		--仅显模式，非仅显怪施法啦！我们放到到miiddle大小
		showSwitchSingleUnit[currentNpFlag](frame, true, false, false)
	end
end

local function actionUnitSpellCastStopOnlyShowMode(...)
	if IsCurOnlyShowStat == false then
		-- 当前处于没有仅显模式,表明所有血条都开着的
		return
	end
	local unitid = ...
	if UnitIsPlayer(unitid) then
		return
	end
	local curName = UnitName(unitid)
	if curName == nil then return end
	local curMatch = isMatchedNameList(Fnp_ONameList, curName)
	-- true的话，表明是我们要的，那么肯定是在显示了。
	if curMatch == false then --false，而且是处于isCurrentOnlyShow
		local frame = GetNamePlateForUnit(unitid)
		-- hideSingleUnit(frame)
		hideSwitchSingleUnit[currentNpFlag](frame)
	end
end

local function actionUnitSpellCastStart(self, event, ...)
	actionUnitSpellCastStartOnlyShowMode(...)
end

local function actionUnitSpellCastStop(self, event, ...)
	actionUnitSpellCastStopOnlyShowMode(...)
end

local function actionAreaChanged(self, event)
	-- print("areaChanged> "..event)
end

FilterNp_EventList = {
	["NAME_PLATE_UNIT_ADDED"]         = actionUnitAdded,
	["NAME_PLATE_UNIT_REMOVED"]       = actionUnitRemoved,

	["UNIT_SPELLCAST_START"]          = actionUnitSpellCastStart,
	["UNIT_SPELLCAST_CHANNEL_START"]  = actionUnitSpellCastStart,
	["UNIT_SPELLCAST_STOP"]           = actionUnitSpellCastStop,
	["UNIT_SPELLCAST_CHANNEL_STOP"]   = actionUnitSpellCastStop,

	["PLAYER_ENTERING_WORLD"]         = registerMyEvents,
	-- ["PLAYER_TARGET_CHANGED"]		  = actionTargetChanged,
	-- ["ZONE_CHANGED_NEW_AREA"]         = actionAreaChanged,
};

function FilteredNamePlate_OnEvent(self, event, ...)
	local handler = FilterNp_EventList[event]
	if handler then
	    handler(self, event, ...)
	end
end

function FilteredNamePlate_OnLoad(self)
	IS_REGISGER = false
	isUIErrorInOneLoad = false
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

function FilteredNamePlate.FNP_UITypeChanged(checkbtn, checked, flag)
	if checked then
		if Fnp_OtherNPFlag == flag then
			return
		end
		Fnp_OtherNPFlag = flag
		initFnp_SavedScaleList_only(flag)
		FilteredNamePlate_Frame_OnlyShowScale:SetValue(Fnp_SavedScaleList.only * 100)
		FilteredNamePlate_Frame_tidyCheckBtn:SetChecked(false)
		FilteredNamePlate_Frame_KuiCheckBtn:SetChecked(false)
		FilteredNamePlate_Frame_OrgCheckBtn:SetChecked(false)
		FilteredNamePlate_Frame_EUIRayBtn:SetChecked(false)
		FilteredNamePlate_Frame_NDUIBtn:SetChecked(false)
		if flag == 0 then
			FilteredNamePlate_Frame_OrgCheckBtn:SetChecked(true)
		elseif flag == 1 then
			FilteredNamePlate_Frame_tidyCheckBtn:SetChecked(true)
		elseif flag == 2 then
			FilteredNamePlate_Frame_KuiCheckBtn:SetChecked(true)
		elseif flag == 3 then
			FilteredNamePlate_Frame_EUIRayBtn:SetChecked(true)
		elseif flag == 4 then
			FilteredNamePlate_Frame_NDUIBtn:SetChecked(true)
		end
	else
		checkbtn:SetChecked(true)
		if Fnp_OtherNPFlag == flag then
			return
		end
	end
	print(L.FNP_PRINT_UITYPE_CHANGED)
end

function FilteredNamePlate.FNP_EnableButtonChecked(self, checked)
	if (checked) then
		Fnp_Enable = true;
	else
		Fnp_Enable = false;
	end
	FilteredNamePlate.actionUnitStateAfterChanged()
end

function FilteredNamePlate.FNP_ModeEditBoxWritenEsc()
	local names = ""
	local first = true
	for key, var in ipairs(Fnp_ONameList) do
		if first then 
			names = var
			first = false
		else
			names = names..";"..var
		end
	end
	FilteredNamePlate_Frame_OnlyShowModeEditBox:SetText(names);

	names = ""
	first = true
	for key, var in ipairs(Fnp_FNameList) do
		if first then 
			names = var
			first = false
		else
			names = names..";"..var
		end
	end
	FilteredNamePlate_Frame_FilteredModeEditBox:SetText(names);
end

function FilteredNamePlate.FNP_ModeEditBoxWriten(mode, inputStr)
	if mode == "o" then
		Fnp_ONameList = {}  
		string.gsub(inputStr, '[^;]+', function(w) table.insert(Fnp_ONameList, w) end )
	else
		Fnp_FNameList = {}  
		string.gsub(inputStr, '[^;]+', function(w) table.insert(Fnp_FNameList, w) end )
	end
end

function FilteredNamePlate.FNP_ChangeFrameVisibility(...)
	if FilteredNamePlate_Frame:IsVisible() then
		FilteredNamePlate_Frame:Hide()
		FilteredNamePlate_Frame:Hide()
	else
		local oldChange = FilteredNamePlate.isSettingChanged
		FilteredNamePlate_Frame:Show()
		FilteredNamePlate_Frame:Show()

		if Fnp_Enable == true then
			FilteredNamePlate_Frame_EnableCheckButton:SetChecked(true);
		else
			FilteredNamePlate_Frame_EnableCheckButton:SetChecked(false);
		end

		if Fnp_OtherNPFlag == 0 then
			FilteredNamePlate_Frame_OrgCheckBtn:SetChecked(true);
		else
			FilteredNamePlate_Frame_OrgCheckBtn:SetChecked(false);
		end
		if Fnp_OtherNPFlag == 1 then
			FilteredNamePlate_Frame_tidyCheckBtn:SetChecked(true);
		else
			FilteredNamePlate_Frame_tidyCheckBtn:SetChecked(false);
		end

		if Fnp_OtherNPFlag == 2 then
			FilteredNamePlate_Frame_KuiCheckBtn:SetChecked(true);
		else
			FilteredNamePlate_Frame_KuiCheckBtn:SetChecked(false);
		end

		if Fnp_OtherNPFlag == 3 then
			FilteredNamePlate_Frame_EUIRayBtn:SetChecked(true);
		else
			FilteredNamePlate_Frame_EUIRayBtn:SetChecked(false);
		end
		if Fnp_OtherNPFlag == 4 then
			FilteredNamePlate_Frame_NDUIBtn:SetChecked(true);
		else
			FilteredNamePlate_Frame_NDUIBtn:SetChecked(false);
		end
		--[[
		if Fnp_Mode ~= nil and Fnp_Mode == true then
			FilteredNamePlate_Frame_FilteredModeCheckBtn:SetChecked(false);
			FilteredNamePlate_Frame_OnlyShowModeCheckBtn:SetChecked(true);
		else
			FilteredNamePlate_Frame_FilteredModeCheckBtn:SetChecked(true);
			FilteredNamePlate_Frame_OnlyShowModeCheckBtn:SetChecked(false);
		end --]]

		FilteredNamePlate_Frame_OnlyShowScale:SetValue(Fnp_SavedScaleList.only * 100)
		FilteredNamePlate_Frame_OnlyOtherShowScale:SetValue(Fnp_SavedScaleList.small * 100)
		FilteredNamePlate_Frame_SystemScale:SetValue(Fnp_SavedScaleList.normal * 100)

		FilteredNamePlate_Frame_OnlyShowModeEditBox:SetText(table.concat(Fnp_ONameList, ";"));
		FilteredNamePlate_Frame_FilteredModeEditBox:SetText(table.concat(Fnp_FNameList, ";"));

		if oldChange == false then
			FilteredNamePlate_Frame_takeEffectBtn:Hide()
		end
	end
end

function SlashCmdList.FilteredNamePlate(msg)
	if msg == "" then
		print(L.FNP_PRINT_HELP0)
		print(L.FNP_PRINT_HELP1)
		print(L.FNP_PRINT_HELP2)
		print(L.FNP_PRINT_HELP3)
	elseif msg == "options" or msg == "opt" then
		FilteredNamePlate.FNP_ChangeFrameVisibility()
	elseif msg == "change" or msg == "ch" then
		if Fnp_Enable == true then
			FilteredNamePlate_Frame_EnableCheckButton:SetChecked(false)
			FilteredNamePlate.FNP_EnableButtonChecked(FilteredNamePlate_Frame, false)
		else
			FilteredNamePlate_Frame_EnableCheckButton:SetChecked(true)
			FilteredNamePlate.FNP_EnableButtonChecked(FilteredNamePlate_Frame, true)
		end
	elseif msg == "refresh" then
		FilteredNamePlate.actionUnitStateAfterChanged()
	elseif msg == "spellcast_small" then
		spellcastScale = 0.35
		FilteredNamePlate.actionUnitStateAfterChanged()
	elseif msg == "spellcast_big" then
		spellcastScale = 0.7
		FilteredNamePlate.actionUnitStateAfterChanged()
	end
end
