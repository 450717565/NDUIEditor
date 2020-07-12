local B, C, L, DB = unpack(select(2, ...))
local S = B:GetModule("Skins")

function S:CompactVendor()
	if not IsAddOnLoaded("CompactVendor") then return end

	local frame = VladsVendorFrame
	frame:ClearAllPoints()
	frame:SetPoint("TOPLEFT", MerchantFrameInset, "TOPLEFT", 3, -3)
	frame:SetPoint("BOTTOMRIGHT", MerchantFrameInset, "BOTTOMRIGHT", -20, 55)

	local Search = frame.Search
	B.ReskinInput(Search, 20)
	Search:ClearAllPoints()
	Search:SetPoint("RIGHT", MerchantFrameLootFilter, "LEFT", 10, 2)

	local List = frame.List
	B.StripTextures(List)
	B.ReskinScroll(List.ListScrollFrame.ScrollBar)

	local splitFrame = VladsVendorListItemQuantityStackSplitFrame
	B.ReskinFrame(splitFrame)
	B.ReskinButton(splitFrame.OkayButton)
	B.ReskinButton(splitFrame.CancelButton)
	B.ReskinArrow(splitFrame.LeftButton, "left")
	B.ReskinArrow(splitFrame.RightButton, "right")

	hooksecurefunc(splitFrame, "Show", function(self)
		self:ClearAllPoints()
		self:SetPoint("TOPLEFT", MerchantFrame, "TOPRIGHT", 3, -25)
	end)

	-- 腐蚀缩写、腐蚀等级、装备等级
	-- by 雨夜独行客

	local function formatNumb(self, text)
		if self.setting or not text then return end
		self.setting = true
		self:SetText(B.FormatNumb(text))

		self.setting = false
	end

	local itemString
	local function updateItemString()
		local itemName = GetItemInfo(177981)
		if itemName then
			return strmatch(itemName, "(.+"..HEADER_COLON..")").."(.+)"
		end
	end

	local contaminantsLevel = DB.ContaminantsLevel
	local function updateItemName(self)
		if not itemString then
			itemString = updateItemString()
		end
		if not itemString then return end

		local item, name = self.item, self.Name
		local text = name and name:GetText()
		local nameString
		if text and item.link and item.id then
			local itemLevel = B.GetItemLevel(item.link)
			local itemSolt = B.GetItemSlot(item.link)
			if itemLevel and itemSolt then
				nameString = tostring(itemLevel).." | "..itemSolt
			elseif itemLevel then
				nameString = tostring(itemLevel)
			elseif itemSolt then
				nameString = itemSolt
			end

			local conLevel = contaminantsLevel[item.id]
			if conLevel then
				nameString = conLevel
				text = strmatch(text, itemString)
			end

			if nameString then
				name:SetText(text.." "..nameString)
			end
		end
	end

	hooksecurefunc(VladsVendorFrame.List, "RefreshLayout", function(self)
		local buttons = self.ListScrollFrame.buttons
		if buttons and not self.ListScrollFrame.styled then
			for i = 1, #buttons do
				local button = buttons[i]
				button.CircleMask:Hide()
				button.Icon:SetScale(.8)
				local icbg1 = B.ReskinIcon(button.Icon)
				hooksecurefunc(button, "Update", updateItemName)

				local Costs = button.Cost.Costs
				for j = 1, #Costs do
					local Icon = Costs[j].Icon
					Icon.CircleMask:Hide()
					Icon.Texture:SetMask("")
					Icon.Texture:SetScale(.8)

					local p1, p2, p3, x = Icon:GetPoint()
					Icon:ClearAllPoints()
					Icon:SetPoint(p1, p2, p3, x, 2)

					local icbg2 = B.ReskinIcon(Icon.Texture)
					hooksecurefunc(Icon.Count, "SetText", formatNumb)
				end

				if icbg1 then icbg1:SetFrameLevel(button:GetFrameLevel()+1) end
				if icbg2 then icbg2:SetFrameLevel(button:GetFrameLevel()+1) end
			end

			self.ListScrollFrame.styled = true
		end
	end)
end