local _, ns = ...
local B, C, L, DB = unpack(ns)

--[[
	职业大厅图标，取代自带的信息条
]]

if IsAddOnLoaded("AuroraClassic") then
	local F = unpack(AuroraClassic)
	local cr, cg, cb = DB.CC.r, DB.CC.g, DB.CC.b

	local OrderHall_Frame = CreateFrame("Frame")
	OrderHall_Frame:RegisterEvent("ADDON_LOADED")

	OrderHall_Frame:SetScript("OnEvent", function(self, event, arg1)
		if event == "ADDON_LOADED" and arg1 == "Blizzard_OrderHallUI" then
			OrderHall_Frame:RegisterEvent("DISPLAY_SIZE_CHANGED")
			OrderHall_Frame:RegisterEvent("UI_SCALE_CHANGED")
			OrderHall_Frame:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
			OrderHall_Frame:RegisterEvent("GARRISON_FOLLOWER_CATEGORIES_UPDATED")
			OrderHall_Frame:RegisterEvent("GARRISON_FOLLOWER_ADDED")
			OrderHall_Frame:RegisterEvent("GARRISON_FOLLOWER_REMOVED")
			OrderHall_Frame:RegisterEvent("GARRISON_TALENT_UPDATE")
			OrderHall_Frame:RegisterEvent("GARRISON_TALENT_COMPLETE")

			OrderHallCommandBar:HookScript("OnShow", function()
				OrderHallCommandBar:EnableMouse(false)
				OrderHallCommandBar.Background:SetAtlas(nil)

				OrderHallCommandBar.ClassIcon:ClearAllPoints()
				OrderHallCommandBar.ClassIcon:SetPoint("TOPLEFT", 10, -35)
				OrderHallCommandBar.ClassIcon:SetSize(40, 20)
				OrderHallCommandBar.ClassIcon:SetAlpha(1)
				if not OrderHallCommandBar.ClassIcon.styled then
					F.CreateBDFrame(OrderHallCommandBar.ClassIcon, 1)
					OrderHallCommandBar.ClassIcon.styled = true
				end

				OrderHallCommandBar.AreaName:ClearAllPoints()
				OrderHallCommandBar.AreaName:SetPoint("LEFT", OrderHallCommandBar.ClassIcon, "RIGHT", 5, 0)
				OrderHallCommandBar.AreaName:SetFont(unpack(DB.Font))
				OrderHallCommandBar.AreaName:SetTextColor(cr, cg, cb)

				OrderHallCommandBar.CurrencyIcon:ClearAllPoints()
				OrderHallCommandBar.CurrencyIcon:SetPoint("LEFT", OrderHallCommandBar.AreaName, "RIGHT", 5, 0)
				OrderHallCommandBar.Currency:ClearAllPoints()
				OrderHallCommandBar.Currency:SetPoint("LEFT", OrderHallCommandBar.CurrencyIcon, "RIGHT", 0, 0)
				OrderHallCommandBar.Currency:SetFont(unpack(DB.Font))
				OrderHallCommandBar.Currency:SetTextColor(cr, cg, cb)

				OrderHallCommandBar.WorldMapButton:Hide()
			end)
		elseif event ~= "ADDON_LOADED" then
			local index = 1
			C_Timer.After(0.1, function()
				for i, child in ipairs({OrderHallCommandBar:GetChildren()}) do
					if child.Icon and child.Count and child.TroopPortraitCover then
						child:SetPoint("TOPLEFT", OrderHallCommandBar.ClassIcon, "BOTTOMLEFT", -5, -index*25+15)
						child.TroopPortraitCover:Hide()

						child.Icon:SetSize(40, 20)
						if not child.styled then
							F.CreateBDFrame(child.Icon, 1)
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
else
	local hall = CreateFrame("Frame", "NDuiOrderHallIcon", UIParent)
	hall:SetSize(50, 50)
	hall:SetPoint("TOPLEFT", 10, -35)
	hall:SetFrameStrata("HIGH")
	hall:Hide()
	hall.Icon = hall:CreateTexture(nil, "ARTWORK")
	hall.Icon:SetAllPoints()
	hall.Icon:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles")
	hall.Icon:SetTexCoord(unpack(CLASS_ICON_TCOORDS[DB.MyClass]))
	hall.Category = {}

	local function RetrieveData(self)
		local currency = C_Garrison.GetCurrencyTypes(LE_GARRISON_TYPE_7_0)
		self.name, self.amount, self.texture = GetCurrencyInfo(currency)

		local categoryInfo = C_Garrison.GetClassSpecCategoryInfo(LE_FOLLOWER_TYPE_GARRISON_7_0)
		self.numCategory = #categoryInfo
		for i, category in ipairs(categoryInfo) do
			self.Category[i] = {category.name, category.count, category.limit, category.description, category.icon}
		end
	end

	hall:RegisterUnitEvent("UNIT_AURA", "player")
	hall:RegisterEvent("PLAYER_ENTERING_WORLD")
	hall:RegisterEvent("ADDON_LOADED")
	hall:SetScript("OnEvent", function(self, event, arg1)
		if event == "ADDON_LOADED" and arg1 == "Blizzard_OrderHallUI" then
			B.HideObject(OrderHallCommandBar)
			GarrisonLandingPageTutorialBox:SetClampedToScreen(true)
			self:UnregisterEvent("ADDON_LOADED")
		elseif event == "UNIT_AURA" or event == "PLAYER_ENTERING_WORLD" then
			local inOrderHall = C_Garrison.IsPlayerInGarrison(LE_GARRISON_TYPE_7_0)
			self:SetShown(inOrderHall)
		elseif event == "MODIFIER_STATE_CHANGED" and arg1 == "LSHIFT" then
			self:GetScript("OnEnter")(self)
		end
	end)

	hall:SetScript("OnEnter", function(self)
		C_Garrison.RequestClassSpecCategoryInfo(LE_FOLLOWER_TYPE_GARRISON_7_0)
		RetrieveData(self)

		GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT", 5, -5)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(DB.MyColor.._G["ORDER_HALL_"..DB.MyClass])
		GameTooltip:AddLine(" ")
		local icon = " |T"..self.texture..":12:12:0:0:50:50:4:46:4:46|t "
		GameTooltip:AddDoubleLine(self.name, self.amount..icon, 1,1,1, 1,1,1)
		local blank
		for i = 1, self.numCategory do
			if not blank then
				GameTooltip:AddLine(" ")
				blank = true
			end
			local name, count, limit, description = unpack(self.Category[i])
			GameTooltip:AddDoubleLine(name, count.." / "..limit, 1,1,1, 1,1,1)
			if IsShiftKeyDown() then
				GameTooltip:AddLine(description, .6,.8,1,true)
			end
		end
		GameTooltip:AddDoubleLine(" ", DB.LineString)
		GameTooltip:AddDoubleLine(" ", L["Details by Shift"], 1,1,1, .6,.8,1)
		GameTooltip:Show()

		self:RegisterEvent("MODIFIER_STATE_CHANGED")
	end)

	hall:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
		self:UnregisterEvent("MODIFIER_STATE_CHANGED")
	end)
end