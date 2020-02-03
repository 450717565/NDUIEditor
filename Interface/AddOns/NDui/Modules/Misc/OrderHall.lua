local _, ns = ...
local B, C, L, DB = unpack(ns)
local ipairs = ipairs

local cr, cg, cb = DB.r, DB.g, DB.b

--[[
	职业大厅图标，取代自带的信息条
]]
local eventList = {
	"ADDON_LOADED",
	"CURRENCY_DISPLAY_UPDATE",
	"DISPLAY_SIZE_CHANGED",
	"GARRISON_FOLLOWER_ADDED",
	"GARRISON_FOLLOWER_CATEGORIES_UPDATED",
	"GARRISON_FOLLOWER_LIST_UPDATE",
	"GARRISON_FOLLOWER_REMOVED",
	"GARRISON_TALENT_COMPLETE",
	"GARRISON_TALENT_UPDATE",
	"PLAYER_ENTERING_WORLD",
	"UI_SCALE_CHANGED",
}

local OrderHall_Frame = CreateFrame("Frame")
OrderHall_Frame:RegisterEvent("ADDON_LOADED")
OrderHall_Frame:SetScript("OnEvent", function(self, event, arg1)
	if event == "ADDON_LOADED" and arg1 == "Blizzard_OrderHallUI" then
		for _, event in pairs(eventList) do
			OrderHall_Frame:RegisterEvent(event)
		end

		OrderHallCommandBar:HookScript("OnShow", function()
			OrderHallCommandBar:EnableMouse(false)
			OrderHallCommandBar.Background:SetAtlas(nil)
			OrderHallCommandBar.WorldMapButton:Hide()

			local ClassIcon = OrderHallCommandBar.ClassIcon
			ClassIcon:ClearAllPoints()
			ClassIcon:SetPoint("TOPLEFT", 10, -35)
			ClassIcon:SetSize(40, 20)
			ClassIcon:SetAlpha(1)
			if not ClassIcon.styled then
				B.CreateBDFrame(ClassIcon, 1)

				ClassIcon.styled = true
			end

			local AreaName = OrderHallCommandBar.AreaName
			AreaName:ClearAllPoints()
			AreaName:SetPoint("LEFT", ClassIcon, "RIGHT", 5, 0)
			AreaName:SetFont(unpack(DB.Font))
			AreaName:SetTextColor(cr, cg, cb)

			local CurrencyIcon = OrderHallCommandBar.CurrencyIcon
			CurrencyIcon:ClearAllPoints()
			CurrencyIcon:SetPoint("LEFT", AreaName, "RIGHT", 5, 0)

			local amount = select(2, GetCurrencyInfo(OrderHallCommandBar.currency))
			local Currency = OrderHallCommandBar.Currency
			Currency:ClearAllPoints()
			Currency:SetPoint("LEFT", CurrencyIcon, "RIGHT", 0, 0)
			Currency:SetFont(unpack(DB.Font))
			Currency:SetTextColor(cr, cg, cb)
			Currency:SetText(B.Numb(amount))
		end)
	elseif event ~= "ADDON_LOADED" then
		local index = 1
		C_Timer.After(0.1, function()
			for _, child in ipairs({OrderHallCommandBar:GetChildren()}) do
				if child.Icon and child.Count and child.TroopPortraitCover then
					child:SetPoint("TOPLEFT", OrderHallCommandBar.ClassIcon, "BOTTOMLEFT", -5, -index*25+15)
					child.TroopPortraitCover:Hide()

					child.Icon:SetSize(40, 20)
					if not child.styled then
						B.CreateBDFrame(child.Icon, 1)

						child.styled = true
					end

					child.Count:ClearAllPoints()
					child.Count:SetPoint("LEFT", child.Icon, "RIGHT", 5, 0)
					child.Count:SetFont(unpack(DB.Font))
					child.Count:SetTextColor(cr, cg, cb)

					index = index + 1
				end
			end
		end)
	end
end)