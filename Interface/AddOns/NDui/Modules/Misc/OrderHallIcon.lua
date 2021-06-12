local _, ns = ...
local B, C, L, DB = unpack(ns)
local Misc = B:GetModule("Misc")

-- 职业大厅图标，取代自带的信息条

local pairs, format = pairs, format
local IsShiftKeyDown = IsShiftKeyDown
local C_CurrencyInfo_GetCurrencyInfo = C_CurrencyInfo.GetCurrencyInfo
local C_Garrison_GetCurrencyTypes = C_Garrison.GetCurrencyTypes
local C_Garrison_GetClassSpecCategoryInfo = C_Garrison.GetClassSpecCategoryInfo
local C_Garrison_RequestClassSpecCategoryInfo = C_Garrison.RequestClassSpecCategoryInfo
local LE_GARRISON_TYPE_7_0 = Enum.GarrisonType.Type_7_0
local LE_FOLLOWER_TYPE_GARRISON_7_0 = Enum.GarrisonFollowerType.FollowerType_7_0
local cr, cg, cb = DB.cr, DB.cg, DB.cb

function Misc:OrderHall_CreateIcon()
	local hall = CreateFrame("Frame", "NDuiOrderHallIcon", UIParent)
	hall:SetSize(50, 50)
	hall:SetPoint("TOP", 0, -40)
	hall:SetFrameStrata("HIGH")
	hall:Hide()

	B.CreateBDFrame(hall)
	B.CreateMF(hall, nil, true)
	B.RestoreMF(hall)

	hall.Category = {}
	Misc.OrderHallIcon = hall

	local Icon = hall:CreateTexture(nil, "ARTWORK")
	Icon:SetInside()
	Icon:SetTexture(DB.classTex)
	Icon:SetTexCoord(B.GetClassTexCoord(DB.MyClass))
	hall.Icon = Icon

	hall:SetScript("OnEnter", Misc.OrderHall_OnEnter)
	hall:SetScript("OnLeave", Misc.OrderHall_OnLeave)
	hooksecurefunc(OrderHallCommandBar, "SetShown", function(_, state)
		hall:SetShown(state)
	end)

	-- Default objects
	B.HideOption(OrderHallCommandBar)
	B.HideObject(OrderHallCommandBar.CurrencyHitTest)
end

function Misc:OrderHall_Refresh()
	C_Garrison_RequestClassSpecCategoryInfo(LE_FOLLOWER_TYPE_GARRISON_7_0)

	local currency = C_Garrison_GetCurrencyTypes(LE_GARRISON_TYPE_7_0)
	local info = C_CurrencyInfo_GetCurrencyInfo(currency)
	self.name = info.name
	self.amount = info.quantity
	self.texture = info.iconFileID

	local categoryInfo = C_Garrison_GetClassSpecCategoryInfo(LE_FOLLOWER_TYPE_GARRISON_7_0)
	for index, info in pairs(categoryInfo) do
		local category = self.Category
		if not category[index] then category[index] = {} end
		category[index].name = info.name
		category[index].count = info.count
		category[index].limit = info.limit
		category[index].description = info.description
		category[index].icon = info.icon
	end

	self.numCategory = #categoryInfo
end

function Misc:OrderHall_OnShiftDown(btn)
	if btn == "LSHIFT" then
		Misc.OrderHall_OnEnter(Misc.OrderHallIcon)
	end
end

local function getIconString(texture)
	return format("|T%s:12:12:0:0::50:50:4:46:4:46|t ", texture)
end

function Misc:OrderHall_OnEnter()
	Misc.OrderHall_Refresh(self)

	GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT", 5, -5)
	GameTooltip:ClearLines()
	GameTooltip:AddLine(_G["ORDER_HALL_"..DB.MyClass], cr,cg,cb)
	GameTooltip:AddLine(" ")
	GameTooltip:AddDoubleLine(getIconString(self.texture)..self.name, B.FormatNumb(self.amount), 1,1,1, 1,1,1)

	local blank
	for i = 1, self.numCategory do
		if not blank then
			GameTooltip:AddLine(" ")
			blank = true
		end
		local category = self.Category[i]
		if category then
			GameTooltip:AddDoubleLine(getIconString(category.icon)..category.name, category.count.." / "..category.limit, cr,cg,cb, 1,1,1)
			if IsShiftKeyDown() then
				GameTooltip:AddLine(category.description, .6,.8,1, 1)
			end
		end
	end

	GameTooltip:AddDoubleLine(" ", DB.LineString)
	GameTooltip:AddDoubleLine(" ", L["Details by Shift"], 1,1,1, .6,.8,1)
	GameTooltip:Show()

	B:RegisterEvent("MODIFIER_STATE_CHANGED", Misc.OrderHall_OnShiftDown)
end

function Misc:OrderHall_OnLeave()
	GameTooltip:Hide()
	B:UnregisterEvent("MODIFIER_STATE_CHANGED", Misc.OrderHall_OnShiftDown)
end

function Misc:OrderHall_OnLoad(addon)
	if addon == "Blizzard_OrderHallUI" then
		Misc:OrderHall_CreateIcon()
		B:UnregisterEvent(self, Misc.OrderHall_OnLoad)
	end
end

function Misc:OrderHall_OnInit()
	if IsAddOnLoaded("Blizzard_OrderHallUI") then
		Misc:OrderHall_CreateIcon()
	else
		B:RegisterEvent("ADDON_LOADED", Misc.OrderHall_OnLoad)
	end
end
Misc:RegisterMisc("OrderHallIcon", Misc.OrderHall_OnInit)