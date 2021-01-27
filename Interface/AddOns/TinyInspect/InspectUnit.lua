
-------------------------------------
-- 查看装备等级 Author: M
-------------------------------------
local B, C, L, DB = unpack(NDui)

local LibEvent = LibStub:GetLibrary("LibEvent.7000")
local LibItemInfo = LibStub:GetLibrary("LibItemInfo.7000")

local ShowInspectColoredLabel = true
local ShowCharacterItemSheet = NDuiDB["Extras"]["ShowCharacterItemSheet"]
local ShowOwnFrameWhenInspecting = NDuiDB["Extras"]["ShowOwnFrameWhenInspecting"]

--裝備清單
local slots = {
	{ index = 1, name = HEADSLOT, },
	{ index = 2, name = NECKSLOT, },
	{ index = 3, name = SHOULDERSLOT, },
	{ index = 5, name = CHESTSLOT, },
	{ index = 6, name = WAISTSLOT, },
	{ index = 7, name = LEGSSLOT, },
	{ index = 8, name = L["Feet"], },
	{ index = 9, name = WRISTSLOT, },
	{ index = 10, name = L["Hands"], },
	{ index = 11, name = FINGER0SLOT, },
	{ index = 12, name = FINGER1SLOT, },
	{ index = 13, name = TRINKET0SLOT, },
	{ index = 14, name = TRINKET1SLOT, },
	{ index = 15, name = BACKSLOT, },
	{ index = 16, name = MAINHANDSLOT, },
	{ index = 17, name = SECONDARYHANDSLOT, },
}

--創建面板
local function GetInspectItemListFrame(parent)
	if (not parent.inspectFrame) then
		local frame = CreateFrame("Frame", nil, parent)
		local height = parent:GetHeight()
		frame:SetSize(160, height)
		frame:SetToplevel(true)
		frame.portrait = CreateFrame("Frame", nil, frame, "GarrisonFollowerPortraitTemplate")
		frame.portrait:SetPoint("TOPLEFT", frame, "TOPLEFT", 18, -16)
		frame.portrait:SetScale(0.8)
		frame.title = B.CreateFS(frame, 17, "", false, "TOPLEFT", 66, -18)
		frame.level = B.CreateFS(frame, 14, "", false, "TOPLEFT", 66, -42)

		local itemframe
		local fontsize = GetLocale():sub(1,2) == "zh" and 12 or 9
		for i, v in ipairs(slots) do
			itemframe = CreateFrame("Button", nil, frame)
			itemframe:SetSize(120, (height-82)/#slots)
			itemframe.index = v.index
			if (i == 1) then
				itemframe:SetPoint("TOPLEFT", frame, "TOPLEFT", 15, -70)
			else
				itemframe:SetPoint("TOPLEFT", frame["item"..(i-1)], "BOTTOMLEFT")
			end
			itemframe.label = CreateFrame("Frame", nil, itemframe, "BackdropTemplate")
			itemframe.label:SetSize(38, 16)
			itemframe.label:SetPoint("LEFT")
			itemframe.label:SetBackdropBorderColor(0, 0.9, 0.9, 0.2)
			itemframe.label:SetBackdropColor(0, 0.9, 0.9, 0.2)

			itemframe.label.text = B.CreateFS(itemframe.label, fontsize, v.name)
			itemframe.label.text:SetSize(34, 14)
			itemframe.label.text:SetTextColor(0, 0.9, 0.9)

			itemframe.levelString = B.CreateFS(itemframe, 16, "")
			itemframe.levelString:SetJustifyH("LEFT")
			itemframe.levelString:SetPoint("LEFT", itemframe.label, "RIGHT", 4, 0)

			itemframe.itemString = B.CreateFS(itemframe, 16, "")
			itemframe.itemString:SetJustifyH("LEFT")
			itemframe.itemString:SetPoint("LEFT", itemframe.levelString, "RIGHT", 0, 0)

			itemframe:SetScript("OnEnter", function(self)
				local r, g, b, a = self.label:GetBackdropColor()
				if (a) then self.label:SetBackdropColor(r, g, b, a+0.5) end
				if (self.link or (self.level and self.level > 0)) then
					GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
					GameTooltip:SetInventoryItem(self:GetParent().unit, self.index)
					GameTooltip:Show()
				end
			end)
			itemframe:SetScript("OnLeave", function(self)
				local r, g, b, a = self.label:GetBackdropColor()
				if (a) then self.label:SetBackdropColor(r, g, b, abs(a-0.5)) end
				GameTooltip:Hide()
			end)
			itemframe:SetScript("OnDoubleClick", function(self)
				if (self.link) then
					ChatEdit_ActivateChat(ChatEdit_ChooseBoxForSend())
					ChatEdit_InsertLink(self.link)
				end
			end)
			frame["item"..i] = itemframe
			LibEvent:trigger("INSPECT_ITEMFRAME_CREATED", itemframe)
		end

		frame.closeButton = CreateFrame("Button", nil, frame)
		frame.closeButton:SetSize(12, 12)
		frame.closeButton:SetScale(0.85)
		frame.closeButton:SetPoint("BOTTOMLEFT", 5, 5)
		frame.closeButton:SetNormalTexture("Interface\\Cursor\\Item")
		frame.closeButton:GetNormalTexture():SetTexCoord(0, 12/32, 12/32, 0)
		frame.closeButton:SetScript("OnClick", function(self)
			self:GetParent():Hide()
		end)

		parent:HookScript("OnHide", function(self) frame:Hide() end)
		parent.inspectFrame = frame
		LibEvent:trigger("INSPECT_FRAME_CREATED", frame, parent)

		frame.bg = B.CreateBG(frame)
	end

	return parent.inspectFrame
end

--等級字符
local ItemLevelPattern = gsub(ITEM_LEVEL, "%%d", "%%.1f")

--顯示面板
function ShowInspectItemListFrame(unit, parent, ilevel, maxLevel)
	if (not parent:IsShown()) then return end
	local frame = GetInspectItemListFrame(parent)
	local class = select(2, UnitClass(unit))
	local color = RAID_CLASS_COLORS[class] or NORMAL_FONT_COLOR
	frame.unit = unit
	frame.portrait:SetLevel(UnitLevel(unit))
	frame.portrait.PortraitRingQuality:SetVertexColor(color.r, color.g, color.b)
	frame.portrait.LevelBorder:SetVertexColor(color.r, color.g, color.b)
	SetPortraitTexture(frame.portrait.Portrait, unit)
	frame.title:SetText(UnitName(unit))
	frame.title:SetTextColor(color.r, color.g, color.b)
	frame.level:SetText(format(ItemLevelPattern, ilevel))
	frame.level:SetTextColor(1, 0.82, 0)
	local _, name, level, link, quality
	local itemframe, mframe, oframe, itemwidth
	local width = 160
	local formats = "%3s"
	if (maxLevel) then
		formats = "%" .. string.len(floor(maxLevel)) .. "s"
	end
	for i, v in ipairs(slots) do
		_, level, name, link, quality = LibItemInfo:GetUnitItemInfo(unit, v.index)
		itemframe = frame["item"..i]
		itemframe.name = name
		itemframe.link = link
		itemframe.level = level
		itemframe.quality = quality
		itemframe.itemString:SetWidth(0)

		if (level > 0) then
			itemframe.levelString:SetText(format(formats, level))
			itemframe.itemString:SetText(link or name)
		else
			itemframe.levelString:SetText("")
			itemframe.itemString:SetText("")
		end

		itemwidth = itemframe.itemString:GetWidth()
		itemframe.itemString:SetWidth(itemwidth)
		itemframe.width = itemwidth + max(64, floor(itemframe.label:GetWidth() + itemframe.levelString:GetWidth()) + 4)
		itemframe:SetWidth(itemframe.width)
		if (width < itemframe.width) then
			width = itemframe.width
		end
		if (v.index == 16) then
			mframe = itemframe
			mframe:SetAlpha(1)
		elseif (v.index == 17) then
			oframe = itemframe
			oframe:SetAlpha(1)
		end
		LibEvent:trigger("INSPECT_ITEMFRAME_UPDATED", itemframe)
	end
	if (mframe and oframe and (mframe.quality == 6 or oframe.quality == 6)) then
		level = max(mframe.level, oframe.level)
		if mframe.link then
			mframe.levelString:SetText(format(formats,level))
		end
		if oframe.link then
			oframe.levelString:SetText(format(formats,level))
		end
	end
	if (mframe and mframe.level <= 0) then
		mframe:SetAlpha(0.4)
	end
	if (oframe and oframe.level <= 0) then
		oframe:SetAlpha(0.4)
	end
	frame:SetWidth(width + 34)
	frame:Show()

	LibEvent:trigger("INSPECT_FRAME_SHOWN", frame, parent, ilevel)
	frame.bg:SetBackdropBorderColor(color.r, color.g, color.b)

	return frame
end


--裝備變更時
LibEvent:attachEvent("UNIT_INVENTORY_CHANGED", function(self, unit)
	if (InspectFrame and InspectFrame.unit and InspectFrame.unit == unit) then
		ReInspect(unit)
	end
end)

--@see InspectCore.lua
LibEvent:attachTrigger("UNIT_INSPECT_READY, UNIT_REINSPECT_READY", function(self, data)
	if (InspectFrame and InspectFrame.unit and UnitGUID(InspectFrame.unit) == data.guid) then
		local frame = ShowInspectItemListFrame(InspectFrame.unit, InspectFrame, data.ilevel, data.maxLevel)
		LibEvent:trigger("INSPECT_FRAME_COMPARE", frame)
	end
end)

--設置邊框
LibEvent:attachTrigger("INSPECT_FRAME_SHOWN", function(self, frame, parent, ilevel)
	frame:SetPoint("TOPLEFT", parent, "TOPRIGHT", 3, 0)
	frame:SetPoint("BOTTOMLEFT", parent, "BOTTOMRIGHT", 3, 0)
end)

--高亮橙裝和武器
LibEvent:attachTrigger("INSPECT_ITEMFRAME_UPDATED", function(self, itemframe)
	local r, g, b = 0, 0.9, 0.9
	if (ShowInspectColoredLabel) then
		if (itemframe.quality and itemframe.quality > 4) then
			r, g, b = GetItemQualityColor(itemframe.quality)
		elseif (itemframe.name and not itemframe.link) then
			r, g, b = 0.9, 0.8, 0.4
		elseif (not itemframe.link) then
			r, g, b = 0.5, 0.5, 0.5
		end
	end
	itemframe.label:SetBackdropBorderColor(r, g, b, 0.2)
	itemframe.label:SetBackdropColor(r, g, b, 0.2)
	itemframe.label.text:SetTextColor(r, g, b)
end)

--自己裝備列表
LibEvent:attachTrigger("INSPECT_FRAME_COMPARE", function(self, frame)
	if (not frame) then return end
	if (ShowOwnFrameWhenInspecting) then
		local _, ilevel, _, _, _, maxLevel = LibItemInfo:GetUnitItemLevel("player")
		local playerFrame = ShowInspectItemListFrame("player", frame, ilevel, maxLevel)
		if (frame.statsFrame) then
			frame.statsFrame:SetParent(playerFrame)
		end
	elseif (frame.statsFrame) then
		frame.statsFrame:SetParent(frame)
	end
	if (frame.statsFrame) then
		frame.statsFrame:SetPoint("TOPLEFT", frame.statsFrame:GetParent(), "TOPRIGHT", 1, -1)
	end
end)


----------------
--   Player   --
----------------

PaperDollFrame:HookScript("OnShow", function(self)
	if (not ShowCharacterItemSheet) then return end
	local _, ilevel, _, _, _, maxLevel = LibItemInfo:GetUnitItemLevel("player")
	ShowInspectItemListFrame("player", self, ilevel, maxLevel)
end)

LibEvent:attachEvent("PLAYER_EQUIPMENT_CHANGED", function(self)
	if (CharacterFrame:IsShown() and ShowCharacterItemSheet) then
		local _, ilevel, _, _, _, maxLevel = LibItemInfo:GetUnitItemLevel("player")
		ShowInspectItemListFrame("player", PaperDollFrame, ilevel, maxLevel)
	end
end)
