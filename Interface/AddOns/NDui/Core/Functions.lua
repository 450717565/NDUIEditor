local _, ns = ...
local B, C, L, DB = unpack(ns)
local cr, cg, cb = DB.r, DB.g, DB.b

local type, pairs, tonumber, wipe, next, select, unpack = type, pairs, tonumber, table.wipe, next, select, unpack
local strmatch, gmatch, strfind, format, gsub = string.match, string.gmatch, string.find, string.format, string.gsub
local min, max, floor, rad = math.min, math.max, math.floor, math.rad

-- Math
do
	-- Numberize
	function B.FormatNumb(n)
		if NDuiADB["NumberFormat"] == 1 then
			if n >= 1e12 then
				return format("%.4ft", n / 1e12)
			elseif n >= 1e9 then
				return format("%.3fb", n / 1e9)
			elseif n >= 1e6 then
				return format("%.2fm", n / 1e6)
			elseif n >= 1e3 then
				return format("%.1fk", n / 1e3)
			else
				return format("%.0f", n)
			end
		elseif NDuiADB["NumberFormat"] == 2 then
			if n >= 1e12 then
				return format("%.3f"..L["NumberCap3"], n / 1e12)
			elseif n >= 1e8 then
				return format("%.2f"..L["NumberCap2"], n / 1e8)
			elseif n >= 1e4 then
				return format("%.1f"..L["NumberCap1"], n / 1e4)
			else
				return format("%.0f", n)
			end
		else
			return format("%.0f", n)
		end
	end

	function B.Round(number, idp)
		idp = idp or 0
		local mult = 10 ^ idp
		return floor(number * mult + .5) / mult
	end

	-- Cooldown calculation
	local day, hour, minute = 86400, 3600, 60
	function B.FormatTime(s, auraTime)
		if s >= day then
			return format("%.1f"..DB.MyColor..L["Days"], s/day), s%day
		elseif s >= 3*hour then
			return format("%d"..DB.MyColor..L["Hours"], s/hour), s%hour
		elseif s >= hour then
			return format("%.1f"..DB.MyColor..L["Hours"], s/hour), s%hour
		elseif s >= minute then
			if auraTime and s <= 3*minute then
				return format("%.1d:%.2d", s/minute, s%minute), s%minute
			else
				return format("%d"..DB.MyColor..L["Minutes"], s/minute), s%minute
			end
		elseif s > 3 then
			if auraTime then
				return format("|cffFFFF00%d|r"..DB.MyColor..L["Seconds"], s), s-floor(s)
			else
				return format("|cffFFFF00%d|r", s), s-floor(s)
			end
		else
			return format("|cffFF0000%.1f|r", s), s-format("%.1f", s)
		end
	end

	function B:CooldownOnUpdate(elapsed)
		self.elapsed = (self.elapsed or 0) + elapsed
		if self.elapsed >= .1 then
			local timeLeft = self.expiration - GetTime()
			if timeLeft > 0 then
				local text = B.FormatTime(timeLeft)
				self.timer:SetText(text)
			else
				self:SetScript("OnUpdate", nil)
				self.timer:SetText(nil)
			end
			self.elapsed = 0
		end
	end

	-- GUID to npcID
	function B.GetNPCID(guid)
		local id = tonumber(strmatch((guid or ""), "%-(%d-)%-%x-$"))
		return id
	end

	-- Table
	function B.CopyTable(source, target)
		for key, value in pairs(source) do
			if type(value) == "table" then
				if not target[key] then target[key] = {} end
				for k in pairs(value) do
					target[key][k] = value[k]
				end
			else
				target[key] = value
			end
		end
	end

	function B.SplitList(list, variable, cleanup)
		if cleanup then wipe(list) end
		for word in gmatch(variable, "%S+") do
			list[word] = true
		end
	end
end

-- Color
do
	function B.HexRGB(r, g, b, unit)
		if r then
			if type(r) == "table" then
				if r.r then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
			end
			if unit then
				return format("|cff%02x%02x%02x%s|r", r*255, g*255, b*255, unit)
			else
				return format("|cff%02x%02x%02x", r*255, g*255, b*255)
			end
		end
	end

	function B.ClassColor(class)
		local color = DB.ClassColors[class]
		if not color then return .5, .5, .5 end
		return color.r, color.g, color.b
	end

	function B.UnitColor(unit)
		local r, g, b = 1, 1, 1
		if UnitIsPlayer(unit) then
			local class = select(2, UnitClass(unit))
			if class then
				r, g, b = B.ClassColor(class)
			end
		elseif UnitIsTapDenied(unit) then
			r, g, b = .6, .6, .6
		else
			local reaction = UnitReaction(unit, "player")
			if reaction then
				local color = FACTION_BAR_COLORS[reaction]
				r, g, b = color.r, color.g, color.b
			end
		end
		return r, g, b
	end
end

-- Itemlevel
do
	local iLvlDB = {}
	local itemLevelString = gsub(ITEM_LEVEL, "%%d", "")
	local enchantString = gsub(ENCHANTED_TOOLTIP_LINE, "%%s", "(.+)")
	local essenceTextureID = 2975691
	local essenceDescription = GetSpellDescription(277253)
	local ITEM_SPELL_TRIGGER_ONEQUIP = ITEM_SPELL_TRIGGER_ONEQUIP
	local RETRIEVING_ITEM_INFO = RETRIEVING_ITEM_INFO
	local tip = CreateFrame("GameTooltip", "NDui_iLvlTooltip", nil, "GameTooltipTemplate")

	function B.InspectItemTextures()
		if not tip.gems then
			tip.gems = {}
		else
			wipe(tip.gems)
		end

		if not tip.essences then
			tip.essences = {}
		else
			for _, essences in pairs(tip.essences) do
				wipe(essences)
			end
		end

		local step = 1
		for i = 1, 10 do
			local tex = _G[tip:GetName().."Texture"..i]
			local texture = tex and tex:IsShown() and tex:GetTexture()
			if texture then
				if texture == essenceTextureID then
					local selected = (tip.gems[i-1] ~= essenceTextureID and tip.gems[i-1]) or nil
					if not tip.essences[step] then tip.essences[step] = {} end
					tip.essences[step][1] = selected		--essence texture if selected or nil
					tip.essences[step][2] = tex:GetAtlas()	--atlas place 'tooltip-heartofazerothessence-major' or 'tooltip-heartofazerothessence-minor'
					tip.essences[step][3] = texture			--border texture placed by the atlas

					step = step + 1
					if selected then tip.gems[i-1] = nil end
				else
					tip.gems[i] = texture
				end
			end
		end

		return tip.gems, tip.essences
	end

	function B.InspectItemInfo(text, slotInfo)
		local itemLevel = strfind(text, itemLevelString) and strmatch(text, "(%d+)%)?$")
		if itemLevel then
			slotInfo.iLvl = tonumber(itemLevel)
		end

		local enchant = strmatch(text, enchantString)
		if enchant then
			slotInfo.enchantText = enchant
		end
	end

	function B.CollectEssenceInfo(index, lineText, slotInfo)
		local step = 1
		local essence = slotInfo.essences[step]
		if essence and next(essence) and (strfind(lineText, ITEM_SPELL_TRIGGER_ONEQUIP, nil, true) and strfind(lineText, essenceDescription, nil, true)) then
			for i = 5, 2, -1 do
				local line = _G[tip:GetName().."TextLeft"..index-i]
				local text = line and line:GetText()

				if text and (not strmatch(text, "^[ +]")) and essence and next(essence) then
					local r, g, b = line:GetTextColor()
					essence[4] = r
					essence[5] = g
					essence[6] = b

					step = step + 1
					essence = slotInfo.essences[step]
				end
			end
		end
	end

	function B.GetItemLevel(link, arg1, arg2, fullScan)
		if fullScan then
			tip:SetOwner(UIParent, "ANCHOR_NONE")
			tip:SetInventoryItem(arg1, arg2)

			if not tip.slotInfo then tip.slotInfo = {} else wipe(tip.slotInfo) end

			local slotInfo = tip.slotInfo
			slotInfo.gems, slotInfo.essences = B.InspectItemTextures()

			for i = 1, tip:NumLines() do
				local line = _G[tip:GetName().."TextLeft"..i]
				if line then
					local text = line:GetText() or ""
					if i == 1 and text == RETRIEVING_ITEM_INFO then
						return "tooSoon"
					else
						B.InspectItemInfo(text, slotInfo)
						B.CollectEssenceInfo(i, text, slotInfo)
					end
				end
			end

			return slotInfo
		else
			if iLvlDB[link] then return iLvlDB[link] end

			tip:SetOwner(UIParent, "ANCHOR_NONE")
			if arg1 and type(arg1) == "string" then
				tip:SetInventoryItem(arg1, arg2)
			elseif arg1 and type(arg1) == "number" then
				tip:SetBagItem(arg1, arg2)
			else
				tip:SetHyperlink(link)
			end

			local firstLine = _G.NDui_iLvlTooltipTextLeft1:GetText()
			if firstLine == RETRIEVING_ITEM_INFO then
				return "tooSoon"
			end

			for i = 2, 5 do
				local line = _G[tip:GetName().."TextLeft"..i]
				if line then
					local text = line:GetText() or ""
					local found = strfind(text, itemLevelString)
					if found then
						local level = strmatch(text, "(%d+)%)?$")
						iLvlDB[link] = tonumber(level)
						break
					end
				end
			end

			return iLvlDB[link]
		end
	end
end

-- ItemInfo
do
	-- Item Slot
	function B.GetItemSlot(item)
		local _, _, _, _, _, _, itemSubType, _, itemEquipLoc, _, _, itemClassID, itemSubClassID, bindType = GetItemInfo(item)
		local itemSolt

		if itemEquipLoc and itemEquipLoc ~= "" then
			itemSolt = _G[itemEquipLoc]

			if itemEquipLoc == "INVTYPE_FEET" then
				itemSolt = L["Feet"]
			elseif itemEquipLoc == "INVTYPE_HAND" then
				itemSolt = L["Hands"]
			elseif itemEquipLoc == "INVTYPE_HOLDABLE" then
				itemSolt = SECONDARYHANDSLOT
			elseif itemEquipLoc == "INVTYPE_SHIELD" then
				itemSolt = SHIELDSLOT
			end
		end

		if itemSubType and itemSubType == EJ_LOOT_SLOT_FILTER_ARTIFACT_RELIC then
			itemSolt = RELICSLOT
		end

		if itemClassID and itemClassID == LE_ITEM_CLASS_MISCELLANEOUS then
			if itemSubClassID and itemSubClassID == LE_ITEM_MISCELLANEOUS_COMPANION_PET then
				itemSolt = PETS
			elseif itemSubClassID and itemSubClassID == LE_ITEM_MISCELLANEOUS_MOUNT then
				itemSolt = MOUNTS
			end
		end

		if bindType and itemEquipLoc ~= "INVTYPE_BAG" then
			if bindType == 2 then
				itemSolt = "BoE"
			elseif bindType == 3 then
				itemSolt = "BoU"
			end
		end

		return itemSolt
	end

	-- Item Gems
	function B.GetItemGems(item)
		local itemGems

		local stats = GetItemStats(item)
		if stats then
			for index in pairs(stats) do
				if strfind(index, "EMPTY_SOCKET_") then
					itemGems = "-"..L["Socket"]
				end
			end
		end

		return itemGems
	end

	-- Item Corruption
	function B.GetItemCorruption(item)
		local itemCorrupted

		local corrupted = IsCorruptedItem(item)
		if corrupted then
			itemCorrupted = "-"..ITEM_MOD_CORRUPTION
		end

		return itemCorrupted
	end
end

-- Kill regions
do
	function B:Dummy()
		return
	end

	B.HiddenFrame = CreateFrame("Frame")
	B.HiddenFrame:Hide()

	function B:HideObject()
		if self.UnregisterAllEvents then
			self:UnregisterAllEvents()
			self:SetParent(B.HiddenFrame)
		else
			self.Show = self.Hide
		end
		self:Hide()
	end

	function B:HideOption()
		self:SetAlpha(0)
		self:SetScale(.0001)
	end

	local blizzTextures = {
		"ArtOverlayFrame",
		"bgLeft",
		"bgRight",
		"border",
		"Border",
		"BorderBox",
		"BorderFrame",
		"bottomInset",
		"BottomInset",
		"Cover",
		"FilligreeOverlay",
		"Inset",
		"inset",
		"InsetFrame",
		"InsetLeft",
		"InsetRight",
		"LeftInset",
		"NineSlice",
		"Portrait",
		"portrait",
		"PortraitOverlay",
		"RightInset",
		"ScrollFrameBorder",
		"ShadowOverlay",
		"shadows",
	}
	function B:StripTextures(kill)
		local frameName = self.GetName and self:GetName()
		for _, texture in pairs(blizzTextures) do
			local blizzFrame = self[texture] or (frameName and _G[frameName..texture])
			if blizzFrame then
				B.StripTextures(blizzFrame, kill)
			end
		end

		if self.GetNumRegions then
			for i = 1, self:GetNumRegions() do
				local region = select(i, self:GetRegions())
				if region and region.IsObjectType and region:IsObjectType("Texture") then
					if kill and type(kill) == "boolean" then
						B.HideObject(region)
					elseif tonumber(kill) then
						if kill == 0 then
							region:SetAlpha(0)
							region:Hide()
						elseif i ~= kill then
							region:SetAlpha(0)
							region:Hide()
						end
					else
						region:SetTexture("")
					end
				end
			end
		end
	end

	local cleanTextures = {
		"_LeftSeparator",
		"_RightSeparator",
		"Background",
		"BG",
		"Bg",
		"BGBottom",
		"BGCenter",
		"BGLeft",
		"BGRight",
		"BGTop",
		"BorderBottom",
		"BorderBottomLeft",
		"BorderBottomRight",
		"BorderCenter",
		"BorderGlow",
		"BorderLeft",
		"BorderRight",
		"BorderTop",
		"BorderTopLeft",
		"BorderTopRight",
		"Bottom",
		"BottomLeft",
		"BottomLeftTex",
		"BottomMid",
		"BottomMiddle",
		"BottomRight",
		"BottomRightTex",
		"BottomTex",
		"Delimiter1",
		"Delimiter2",
		"Left",
		"LeftDisabled",
		"LeftSeparator",
		"LeftTex",
		"Mid",
		"Middle",
		"MiddleDisabled",
		"MiddleLeft",
		"MiddleMid",
		"MiddleMiddle",
		"MiddleRight",
		"MiddleTex",
		"Right",
		"RightDisabled",
		"RightSeparator",
		"RightTex",
		"ScrollBarBottom",
		"ScrollBarMiddle",
		"ScrollBarTop",
		"ScrollDownBorder",
		"ScrollUpBorder",
		"TabSpacer",
		"TabSpacer1",
		"TabSpacer2",
		"Top",
		"TopLeft",
		"TopLeftTex",
		"TopMid",
		"TopMiddle",
		"TopRight",
		"TopRightTex",
		"TopTex",
		"Track",
		"track",
		"trackBG",
	}

	function B:CleanTextures()
		if self.SetBackdrop then self:SetBackdrop(nil) end
		if self.SetDisabledTexture then self:SetDisabledTexture("") end
		if self.SetHighlightTexture then self:SetHighlightTexture("") end
		if self.SetNormalTexture then self:SetNormalTexture("") end
		if self.SetPushedTexture then self:SetPushedTexture("") end

		local frameName = self.GetName and self:GetName()
		for _, key in pairs(cleanTextures) do
			local cleanFrame = self[key] or (frameName and _G[frameName..key])
			if cleanFrame then
				cleanFrame:SetAlpha(0)
				cleanFrame:Hide()
			end
		end
	end
end

-- UI widgets
do
	-- Fontstring
	function B:CreateFS(size, text, color, anchor, x, y)
		local fs = self:CreateFontString(nil, "OVERLAY")
		fs:SetFont(DB.Font[1], size, DB.Font[3])
		fs:SetText(text)
		fs:SetWordWrap(false)
		fs:ClearAllPoints()
		if color and type(color) == "boolean" then
			fs:SetTextColor(cr, cg, cb)
		elseif color == "system" then
			fs:SetTextColor(1, .8, 0)
		end
		if anchor and x and y then
			fs:SetPoint(anchor, x, y)
		else
			fs:SetPoint("CENTER", 1, 0)
		end

		return fs
	end

	-- Gametooltip
	function B:HideTooltip()
		GameTooltip:Hide()
	end

	local function Tooltip_OnEnter(self)
		GameTooltip:SetOwner(self, self.anchor)
		GameTooltip:ClearLines()
		if self.title then
			GameTooltip:AddLine(self.title)
		end
		if self.tooltip and strfind(self.tooltip, "|H.+|h") then
			GameTooltip:SetHyperlink(self.tooltip)
		elseif tonumber(self.tooltip) then
			GameTooltip:SetSpellByID(self.tooltip)
		elseif self.tooltip then
			local r, g, b = 1, 1, 1
			if self.color == "class" then
				r, g, b = cr, cg, cb
			elseif self.color == "system" then
				r, g, b = 1, .8, 0
			elseif self.color == "info" then
				r, g, b = .6, .8, 1
			end
			GameTooltip:AddLine(self.tooltip, r, g, b, 1)
		end
		GameTooltip:Show()
	end

	function B:AddTooltip(anchor, tooltip, color)
		self.anchor = anchor
		self.tooltip = tooltip
		self.color = color
		self:SetScript("OnEnter", Tooltip_OnEnter)
		self:SetScript("OnLeave", B.HideTooltip)
	end

	-- Frame
	function B.Scale(x)
		local mult = C.mult
		return mult * B.Round(x / mult)
	end

	-- Glow parent
	function B:CreateGlowFrame(size)
		local frame = CreateFrame("Frame", nil, self)
		frame:Point("CENTER")
		frame:SetSize(size+8, size+8)

		return frame
	end

	-- Gradient Frame
	function B:CreateGA(w, h, d, r, g, b, a1, a2)
		self:SetSize(w, h)
		self:SetFrameStrata("BACKGROUND")

		local ga = self:CreateTexture(nil, "BACKGROUND")
		ga:SetAllPoints()
		ga:SetTexture(DB.normTex)
		ga:SetGradientAlpha(d, r, g, b, a1, r, g, b, a2)
	end

	-- Background texture
	function B:SetupTex()
		if not NDuiDB["Skins"]["SkinTexture"] then return end
		if self.Tex then return end

		local frame = self
		if self:GetObjectType() == "Texture" then frame = self:GetParent() end

		local Tex = frame:CreateTexture(nil, "BACKGROUND", nil, 1)
		Tex:SetAllPoints(self)
		Tex:SetTexture(DB.bgTex, true, true)
		Tex:SetHorizTile(true)
		Tex:SetVertTile(true)
		Tex:SetBlendMode("ADD")
		self.Tex = Tex
	end

	-- Backdrop shadow
	function B:CreateSD(override)
		if not override and not NDuiDB["Skins"]["SkinShadow"] then return end
		if self.Shadow then return end

		local frame = self
		if self:GetObjectType() == "Texture" then frame = self:GetParent() end

		local lvl = frame:GetFrameLevel()
		local Shadow = CreateFrame("Frame", nil, frame)
		Shadow:SetOutside(self, 2, 2)
		Shadow:SetBackdrop({edgeFile = DB.glowTex, edgeSize = B.Scale(3)})
		Shadow:SetBackdropBorderColor(0, 0, 0, .5)
		Shadow:SetFrameLevel(lvl)
		self.Shadow = Shadow

		return Shadow
	end
end

-- UI skins
do
	-- Database
	local barWords = {
		"Label",
		"label",
		"Rank",
		"RankText",
		"rankText",
		"Text",
		"text",
	}

	local textWords = {
		"Text",
		"text",
	}

	local function SetupDisTex(self)
		self:SetDisabledTexture(DB.bdTex)
		local dis = self:GetDisabledTexture()
		dis:SetVertexColor(0, 0, 0, .5)
		dis:SetDrawLayer("OVERLAY")
		dis:SetAllPoints()
	end

	local function SetupHook(self)
		B.Hook_OnEnter(self)
		B.Hook_OnLeave(self)
		B.Hook_OnMouseDown(self)
		B.Hook_OnMouseUp(self)
	end

	local direcIndex = {
		["up"] = DB.arrowUp,
		["down"] = DB.arrowDown,
		["left"] = DB.arrowLeft,
		["right"] = DB.arrowRight,
		["top"] = DB.arrowTop,
		["bottom"] = DB.arrowBottom,
	}

	-- Setup Function
	function B:Tex_OnEnter()
		if self.pixels then
			for _, pixel in pairs(self.pixels) do
				pixel:SetVertexColor(cr, cg, cb, 1)
			end
		elseif self.bgTex then
			self.bgTex:SetVertexColor(cr, cg, cb, 1)
		elseif self.bdTex then
			self.bdTex:SetBackdropBorderColor(cr, cg, cb, 1)
		else
			self:SetBackdropBorderColor(cr, cg, cb, 1)
		end
	end

	function B:Tex_OnLeave()
		if self.pixels then
			for _, pixel in pairs(self.pixels) do
				pixel:SetVertexColor(1, 1, 1, 1)
			end
		elseif self.bgTex then
			self.bgTex:SetVertexColor(1, 1, 1, 1)
		elseif self.bdTex then
			self.bdTex:SetBackdropBorderColor(0, 0, 0, 1)
		else
			self:SetBackdropBorderColor(0, 0, 0, 1)
		end
	end

	function B:Tex_OnMouseDown()
		if self.bdTex then
			self.bdTex:SetBackdropColor(cr, cg, cb, .25)
		else
			self:SetBackdropColor(cr, cg, cb, .25)
		end
	end

	function B:Tex_OnMouseUp()
		if self.bdTex then
			self.bdTex:SetBackdropColor(0, 0, 0, 0)
		else
			self:SetBackdropColor(0, 0, 0, 0)
		end
	end

	function B:Hook_OnEnter(isSpecial)
		self:HookScript("OnEnter", isSpecial and B.Tex_OnMouseDown or B.Tex_OnEnter)
	end

	function B:Hook_OnLeave(isSpecial)
		self:HookScript("OnLeave", isSpecial and B.Tex_OnMouseUp or B.Tex_OnLeave)
	end

	function B:Hook_OnMouseDown()
		self:HookScript("OnMouseDown", B.Tex_OnMouseDown)
	end

	function B:Hook_OnMouseUp()
		self:HookScript("OnMouseUp", B.Tex_OnMouseUp)
	end

	-- Pixel Borders
	local PIXEL_BORDERS = {"TOPLEFT", "TOPRIGHT", "BOTTOMLEFT", "BOTTOMRIGHT", "TOP", "BOTTOM", "LEFT", "RIGHT"}

	function B:SetBackdropColor(r, g, b, a)
		if self.pixelBorders then
			self.pixelBorders.CENTER:SetVertexColor(r, g, b, a)
		end
	end

	function B:SetBackdropBorderColor(r, g, b, a)
		if self.pixelBorders then
			for _, key in pairs(PIXEL_BORDERS) do
				self.pixelBorders[key]:SetVertexColor(r, g, b, a)
			end
		end
	end

	function B:SetupPixelBorders()
		if self and not self.pixelBorders then
			local borders = {}
			for _, key in pairs(PIXEL_BORDERS) do
				borders[key] = self:CreateTexture(nil, "BORDER", nil, 1)
				borders[key]:SetTexture(DB.bdTex)
			end

			borders.CENTER = self:CreateTexture(nil, "BACKGROUND", nil, -1)
			borders.CENTER:SetTexture(DB.bdTex)
			borders.CENTER:SetAllPoints()

			borders.TOPLEFT:SetSize(C.mult, C.mult)
			borders.TOPRIGHT:SetSize(C.mult, C.mult)
			borders.BOTTOMLEFT:SetSize(C.mult, C.mult)
			borders.BOTTOMRIGHT:SetSize(C.mult, C.mult)

			borders.TOPLEFT:Point("BOTTOMRIGHT", borders.CENTER, "TOPLEFT", C.mult, -C.mult)
			borders.TOPRIGHT:Point("BOTTOMLEFT", borders.CENTER, "TOPRIGHT", -C.mult, -C.mult)
			borders.BOTTOMLEFT:Point("TOPRIGHT", borders.CENTER, "BOTTOMLEFT", C.mult, C.mult)
			borders.BOTTOMRIGHT:Point("TOPLEFT", borders.CENTER, "BOTTOMRIGHT", -C.mult, C.mult)

			borders.TOP:Point("TOPLEFT", borders.TOPLEFT, "TOPRIGHT", 0, 0)
			borders.TOP:Point("BOTTOMRIGHT", borders.TOPRIGHT, "BOTTOMLEFT", 0, 0)

			borders.BOTTOM:Point("TOPLEFT", borders.BOTTOMLEFT, "TOPRIGHT", 0, 0)
			borders.BOTTOM:Point("BOTTOMRIGHT", borders.BOTTOMRIGHT, "BOTTOMLEFT", 0, 0)

			borders.LEFT:Point("TOPLEFT", borders.TOPLEFT, "BOTTOMLEFT", 0, 0)
			borders.LEFT:Point("BOTTOMRIGHT", borders.BOTTOMLEFT, "TOPRIGHT", 0, 0)

			borders.RIGHT:Point("TOPLEFT", borders.TOPRIGHT, "BOTTOMLEFT", 0, 0)
			borders.RIGHT:Point("BOTTOMRIGHT", borders.BOTTOMRIGHT, "TOPRIGHT", 0, 0)

			hooksecurefunc(self, "SetBackdropColor", B.SetBackdropColor)
			hooksecurefunc(self, "SetBackdropBorderColor", B.SetBackdropBorderColor)

			self.pixelBorders = borders
		end
	end

	-- Setup backdrop
	C.frames = {}
	function B:CreateBD(alpha)
		local BGColor = NDuiDB["Skins"]["BGColor"]
		local BGAlpha = NDuiDB["Skins"]["BGAlpha"]

		self:SetBackdrop(nil)

		B.SetupPixelBorders(self)
		B.SetBackdropColor(self, BGColor.r, BGColor.g, BGColor.b, alpha or BGAlpha)
		B.SetBackdropBorderColor(self, 0, 0, 0, 1)
		B.SetupTex(self)

		if not alpha then tinsert(C.frames, self) end
	end

	function B:CreateGF()
		if self.gTex then return end

		local FSColor = NDuiDB["Skins"]["FSColor"]
		local GSColor1 = NDuiDB["Skins"]["GSColor1"]
		local GSColor2 = NDuiDB["Skins"]["GSColor2"]
		local SkinStyle = NDuiDB["Skins"]["SkinStyle"]

		local r, g, b = cr, cg, cb
		if SkinStyle == 2 then r, g, b = FSColor.r, FSColor.g, FSColor.b end

		local gTex = self:CreateTexture(nil, "BORDER")
		gTex:SetTexture(DB.bdTex)
		gTex:SetInside()
		if SkinStyle < 3 then
			gTex:SetVertexColor(r, g, b, .3)
		else
			gTex:SetGradientAlpha("Vertical", GSColor1.r, GSColor1.g, GSColor1.b, .6, GSColor2.r, GSColor2.g, GSColor2.b, .3)
		end

		self.gTex = gTex
	end

	-- Handle frame
	function B:CreateBDFrame(alpha, offset, noGF)
		local frame = self
		if self:GetObjectType() == "Texture" then frame = self:GetParent() end

		local lvl = frame:GetFrameLevel()
		local bg = CreateFrame("Frame", nil, frame)
		bg:SetOutside(self, offset, offset)
		bg:SetFrameLevel(lvl == 0 and 0 or lvl - 1)

		B.CreateBD(bg, alpha)
		B.CreateSD(bg)

		if not noGF then
			B.CreateGF(bg)
		end

		return bg
	end

	function B:CreateBGFrame(x, y, x2, y2, frame)
		local bg = B.CreateBDFrame(self, 0)
		bg:ClearAllPoints()
		if frame then
			bg:Point("TOPLEFT", frame, "TOPRIGHT", x, y)
			bg:Point("BOTTOM", frame, "BOTTOM", 0, y2)
			bg:Point("RIGHT", self, "RIGHT", x2, 0)
		else
			bg:Point("TOPLEFT", self, x, y)
			bg:Point("BOTTOMRIGHT", self, x2, y2)
		end

		return bg
	end

	function B:CreateBG(x, y, x2, y2)
		if x or y or x2 or y2 then
			local bg = B.CreateBDFrame(self, nil, 0, true)
			bg:ClearAllPoints()
			bg:Point("TOPLEFT", self, x, y)
			bg:Point("BOTTOMRIGHT", self, x2, y2)

			return bg
		else
			B.CreateBD(self)
			B.CreateSD(self)
		end
	end

	-- Handle icons
	function B:ReskinIcon(alpha)
		self:SetTexCoord(unpack(DB.TexCoord))
		local bg = B.CreateBDFrame(self, alpha or 0)

		return bg
	end

	function B:PixelIcon(texture, highlight)
		B.CreateBG(self)
		B.CreateGF(self)

		self.Icon = self:CreateTexture(nil, "ARTWORK")
		self.Icon:SetTexCoord(unpack(DB.TexCoord))
		self.Icon:SetInside()
		if texture then
			local atlas = strmatch(texture, "Atlas:(.+)$")
			if atlas then
				self.Icon:SetAtlas(atlas)
			else
				self.Icon:SetTexture(texture)
			end
		end
		if highlight and type(highlight) == "boolean" then
			self:EnableMouse(true)
			self.HL = self:CreateTexture(nil, "HIGHLIGHT")
			self.HL:SetColorTexture(1, 1, 1, .25)
			self.HL:SetInside()
		end
	end

	function B:AuraIcon()
		self.CD = CreateFrame("Cooldown", nil, self, "CooldownFrameTemplate")
		self.CD:SetAllPoints()
		self.CD:SetReverse(true)
		B.PixelIcon(self, nil, true)
	end

	function B:CreateGear(name)
		local bu = CreateFrame("Button", name, self)
		bu:SetSize(24, 24)
		bu.Icon = bu:CreateTexture(nil, "ARTWORK")
		bu.Icon:SetAllPoints()
		bu.Icon:SetTexture(DB.gearTex)
		bu.Icon:SetTexCoord(0, .5, 0, .5)
		bu:SetHighlightTexture(DB.gearTex)
		bu:GetHighlightTexture():SetTexCoord(0, .5, 0, .5)

		return bu
	end

	-- Handle statusbar
	function B:CreateSB(spark, r, g, b)
		self:SetStatusBarTexture(DB.normTex)
		if r and g and b then
			self:SetStatusBarColor(r, g, b)
		else
			self:SetStatusBarColor(cr, cg, cb)
		end

		local bd = B.CreateBDFrame(self, 0, nil, true)
		self.bd = bd

		local bg = self:CreateTexture(nil, "BACKGROUND")
		bg:SetInside(bd)
		bg:SetTexture(DB.normTex)
		bg:SetVertexColor(0, 0, 0, .25)
		self.bg = bg

		if spark then
			self.Spark = self:CreateTexture(nil, "OVERLAY")
			self.Spark:SetTexture(DB.sparkTex)
			self.Spark:SetBlendMode("ADD")
			self.Spark:SetAlpha(DB.Alpha)
			self.Spark:ClearAllPoints()
			self.Spark:SetPoint("TOPLEFT", self:GetStatusBarTexture(), "TOPRIGHT", -10, 10)
			self.Spark:SetPoint("BOTTOMRIGHT", self:GetStatusBarTexture(), "BOTTOMRIGHT", 10, -10)
		end
	end

	function B:ReskinStatusBar(noClassColor)
		B.StripTextures(self)
		B.CleanTextures(self)

		B.CreateBDFrame(self, 0)

		self:SetStatusBarTexture(DB.normTex)
		if not noClassColor then
			self:SetStatusBarColor(cr, cg, cb, DB.Alpha)
		end

		local frameName = self.GetName and self:GetName()
		for _, key in pairs(barWords) do
			local text = self[key] or (frameName and _G[frameName..key])
			if text then
				text:SetJustifyH("CENTER")
				text:ClearAllPoints()
				text:SetPoint("CENTER")
			end
		end
	end

	-- Handle button
	function B:ReskinButton()
		B.CleanTextures(self)

		B.CreateBD(self, 0)
		B.CreateSD(self)
		B.CreateGF(self)

		SetupHook(self)
	end

	-- Handle tabs
	function B:ReskinTab()
		B.StripTextures(self)
		B.CleanTextures(self)

		local bg = B.CreateBG(self, 8, -3, -8, 2)
		B.ReskinHighlight(self, bg, true)
	end

	function B:SetupTabStyle(index, tabName)
		local frameName = self.GetName and self:GetName()
		local tab = frameName and frameName.."Tab"

		if tabName then tab = frameName and frameName..tabName end
		if not tab then return end

		for i = 1, index do
			local tabs = _G[tab..i]
			if tabs then
				if not tabs.styled then
					B.ReskinTab(tabs)

					tabs.styled = true
				end

				tabs:ClearAllPoints()
				if i == 1 then
					tabs:Point("TOPLEFT", frameName, "BOTTOMLEFT", 15, 2)
				else
					tabs:Point("LEFT", _G[tab..(i-1)], "RIGHT", -B.Scale(16), 0)
				end
			end
		end
	end

	-- Handle scrollframe
	function B:ReskinScroll()
		B.StripTextures(self)
		B.CleanTextures(self)

		local parent = self:GetParent()
		if parent then
			B.StripTextures(parent, 0)
			B.CleanTextures(parent)
		end

		local frameName = self.GetName and self:GetName()
		local thumb
		if self.GetThumbTexture then
			thumb = self:GetThumbTexture()
		else
			for _, key in pairs({"ThumbTexture", "thumbTexture"}) do
				thumb = self[key] or (frameName and _G[frameName..key])
			end
		end
		if thumb then
			thumb:SetAlpha(0)
			thumb:SetWidth(18)

			local bdTex = B.CreateBGFrame(thumb, 0, -3, 0, 3)
			self.bdTex = bdTex
		end

		local up, down = self:GetChildren()
		B.ReskinArrow(up, "up")
		B.ReskinArrow(down, "down")

		up:SetHeight(16)
		down:SetHeight(16)

		SetupHook(self)
	end

	-- Handle dropdown
	function B:ReskinDropDown()
		B.StripTextures(self)
		B.CleanTextures(self)

		local frameName = self.GetName and self:GetName()

		local button = self.Button or (frameName and _G[frameName.."Button"])
		button:ClearAllPoints()
		button:Point("RIGHT", -18, 2)

		B.ReskinArrow(button, "down")
		button:SetSize(20, 20)

		local bg = B.CreateBDFrame(self, 0)
		bg:ClearAllPoints()
		bg:Point("TOPLEFT", self, "TOPLEFT", 16, -4)
		bg:Point("BOTTOMRIGHT", button, "BOTTOMLEFT", -2, 0)

		for _, key in pairs(textWords) do
			local text = self[key] or (frameName and _G[frameName..key])
			if text then
				text:SetJustifyH("CENTER")
				text:ClearAllPoints()
				text:SetPoint("CENTER", bg, 1, 0)
			end
		end
	end

	-- Handle close button
	function B:ReskinClose(a1, p, a2, x, y)
		self:SetSize(18, 18)

		self:ClearAllPoints()
		if not a1 then
			self:Point("TOPRIGHT", -6, -6)
		else
			self:Point(a1, p, a2, x, y)
		end

		B.StripTextures(self)

		B.ReskinButton(self)
		SetupDisTex(self)

		self.pixels = {}
		for i = 1, 2 do
			local tex = self:CreateTexture()
			tex:SetColorTexture(1, 1, 1)
			tex:SetSize(12, 2)
			tex:ClearAllPoints()
			tex:Point("CENTER")
			tex:SetRotation(math.rad((i-1/2)*90))
			tinsert(self.pixels, tex)
		end
	end

	function B:ReskinDecline()
		B.StripTextures(self)

		B.ReskinButton(self)

		local w = self:GetWidth()
		self.pixels = {}
		for i = 1, 2 do
			local tex = self:CreateTexture()
			tex:SetColorTexture(1, 1, 1)
			tex:SetSize(w*.8, 2)
			tex:ClearAllPoints()
			tex:Point("CENTER")
			tex:SetRotation(math.rad((i-1/2)*90))
			tinsert(self.pixels, tex)
		end
	end

	-- Handle editbox
	function B:ReskinInput(height, width)
		B.CleanTextures(self)
		self:DisableDrawLayer("BACKGROUND")

		if height then self:SetHeight(height) end
		if width then self:SetWidth(width) end

		local bg = B.CreateBGFrame(self, -3, 0, -3, 0)

		return bg
	end

	-- Handle arrows
	function B:SetupArrowTex(direction)
		if self.bgTex then return end

		local bgTex = self:CreateTexture(nil, "ARTWORK")
		bgTex:SetTexture(direcIndex[direction])
		bgTex:SetSize(8, 8)
		bgTex:ClearAllPoints()
		bgTex:Point("CENTER")
		bgTex:SetVertexColor(1, 1, 1)
		self.bgTex = bgTex
	end

	function B:ReskinArrow(direction)
		self:SetSize(18, 18)

		B.StripTextures(self)

		B.ReskinButton(self)
		B.SetupArrowTex(self, direction)
		SetupDisTex(self)
	end

	-- Handle filter
	function B:ReskinFilter()
		B.StripTextures(self)

		B.ReskinButton(self)

		self.Icon:SetTexture(DB.arrowRight)
		self.Icon:ClearAllPoints()
		self.Icon:Point("RIGHT", self, "RIGHT", -5, 0)
		self.Icon:SetSize(8, 8)

		local frameName = self.GetName and self:GetName()
		for _, key in pairs(textWords) do
			local text = self[key] or (frameName and _G[frameName..key])
			if text then
				text:SetJustifyH("CENTER")
				text:ClearAllPoints()
				text:SetPoint("CENTER")
			end
		end
	end

	-- Handle navbar
	function B:ReskinNavBar()
		if self.styled then return end

		B.StripTextures(self)
		B.CleanTextures(self)
		self.overlay:Hide()

		local homeButton = self.homeButton
		homeButton.text:ClearAllPoints()
		homeButton.text:SetPoint("CENTER")
		B.ReskinButton(homeButton)

		local overflowButton = self.overflowButton
		B.ReskinArrow(overflowButton, "left")

		self.styled = true
	end

	-- Handle checkbox and radio
	function B:ReskinCheck(forceSaturation)
		B.CleanTextures(self)

		local ch = self:GetCheckedTexture()
		ch:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
		ch:SetTexCoord(0, 1, 0, 1)
		ch:SetDesaturated(true)
		ch:SetVertexColor(cr, cg, cb)

		local bdTex = B.CreateBDFrame(self, 0, -4)
		self.bdTex = bdTex

		SetupHook(self)
		self.forceSaturation = forceSaturation
	end

	hooksecurefunc("TriStateCheckbox_SetState", function(_, checkButton)
		if checkButton.forceSaturation then
			local tex = checkButton:GetCheckedTexture()
			if checkButton.state == 2 then
				tex:SetDesaturated(true)
				tex:SetVertexColor(cr, cg, cb)
			elseif checkButton.state == 1 then
				tex:SetVertexColor(1, .8, 0)
			end
		end
	end)

	function B:ReskinRadio()
		B.StripTextures(self)
		B.CleanTextures(self)

		local bdTex = B.CreateBDFrame(self, 0, -2)
		self.bdTex = bdTex

		self:SetCheckedTexture(DB.bdTex)
		local ch = self:GetCheckedTexture()
		ch:SetVertexColor(cr, cg, cb, .75)
		ch:SetInside(bdTex)

		SetupHook(self)
	end

	-- Color swatch
	function B:ReskinColorSwatch()
		self:SetNormalTexture(DB.bdTex)
		local nt = self:GetNormalTexture()
		nt:ClearAllPoints()
		nt:Point("TOPLEFT", 2, -2)
		nt:Point("BOTTOMRIGHT", -2, 2)

		local frameName = self.GetName and self:GetName()
		local bg = self.SwatchBg or (frameName and _G[frameName.."SwatchBg"])
		bg:SetColorTexture(0, 0, 0)
		bg:SetOutside(nt)
	end

	-- Handle slider
	function B:ReskinSlider(verticle)
		self:SetBackdrop(nil)
		B.StripTextures(self)

		B.CreateBGFrame(self, 14, -2, -15, 3)

		local thumb = self:GetThumbTexture()
		thumb:SetTexture(DB.sparkTex)
		thumb:SetBlendMode("ADD")

		if verticle then thumb:SetRotation(math.rad(90)) end
	end

	-- Handle collapse
	local function UpdateExpandOrCollapse(self, texture)
		if self.setTex then return end
		self.setTex = true
		self:SetNormalTexture("")

		if texture and texture ~= "" then
			if type(texture) == "number" then
				if texture == 130838 then
					self.expTex:SetTexCoord(0, .4375, 0, .4375)
				elseif texture == 130821 then
					self.expTex:SetTexCoord(.5625, 1, 0, .4375)
				end
			else
				if texture:find("Plus") then
					self.expTex:SetTexCoord(0, .4375, 0, .4375)
				elseif texture:find("Minus") then
					self.expTex:SetTexCoord(.5625, 1, 0, .4375)
				end
			end
			self.bdTex:Show()
		else
			self.bdTex:Hide()
		end

		self.setTex = false
	end

	function B:ReskinExpandOrCollapse()
		B.StripTextures(self)
		B.CleanTextures(self)

		local bdTex = B.CreateBDFrame(self, 0)
		bdTex:SetSize(14, 14)
		bdTex:ClearAllPoints()
		bdTex:SetPoint("TOPLEFT", self:GetNormalTexture())
		self.bdTex = bdTex

		local expTex = bdTex:CreateTexture(nil, "OVERLAY")
		expTex:SetSize(8, 8)
		expTex:ClearAllPoints()
		expTex:SetPoint("CENTER")
		expTex:SetTexture("Interface\\Buttons\\UI-PlusMinus-Buttons")
		self.expTex = expTex

		SetupHook(self)

		hooksecurefunc(self, "SetNormalTexture", UpdateExpandOrCollapse)
	end

	function B:ReskinMinMax()
		for _, name in pairs({"MaximizeButton", "MinimizeButton"}) do
			local button = self[name]
			if button then
				B.StripTextures(self)
				B.CleanTextures(self)

				B.ReskinButton(button)

				button:SetSize(18, 18)
				button:ClearAllPoints()
				button:Point("CENTER", -3, 0)

				button.pixels = {}

				local tex = button:CreateTexture()
				tex:SetColorTexture(1, 1, 1)
				tex:SetSize(12, 2)
				tex:ClearAllPoints()
				tex:Point("CENTER")
				tex:SetRotation(math.rad(45))
				tinsert(button.pixels, tex)

				local hline = button:CreateTexture()
				hline:SetColorTexture(1, 1, 1)
				hline:SetSize(8, 2)
				hline:ClearAllPoints()
				tinsert(button.pixels, hline)

				local vline = button:CreateTexture()
				vline:SetColorTexture(1, 1, 1)
				vline:SetSize(2, 8)
				vline:ClearAllPoints()
				tinsert(button.pixels, vline)

				if name == "MaximizeButton" then
					hline:Point("TOPRIGHT", -4, -4)
					vline:Point("TOPRIGHT", -4, -4)
				else
					hline:Point("BOTTOMLEFT", 4, 4)
					vline:Point("BOTTOMLEFT", 4, 4)
				end
			end
		end
	end

	-- Handle others
	function B:CreateLine(isHorizontal)
		if self.Line then return end

		local w, h = self:GetSize()
		local Line = self:CreateTexture(nil, "ARTWORK")
		Line:SetColorTexture(1, 1, 1, .25)
		Line:ClearAllPoints()

		if isHorizontal then
			Line:SetSize(w*.9, C.mult)
		else
			Line:SetSize(C.mult, h*.9)
		end

		self.Line = Line

		return Line
	end

	function B:ReskinBorder(relativeTo, classColor)
		if not self then return end

		self:SetTexture(DB.bdTex)
		self.SetTexture = B.Dummy
		self:SetDrawLayer("BACKGROUND")

		if classColor then
			self:SetColorTexture(cr, cg, cb)
		end

		self:SetAllPoints(relativeTo)
	end

	function B:ReskinChecked(relativeTo, classColor)
		if not self then return end

		local checked
		if self.SetCheckedTexture then
			self:SetCheckedTexture(DB.checked)
			checked = self:GetCheckedTexture()
		elseif self.GetNormalTexture then
			checked = self:GetNormalTexture()
			checked:SetTexture(DB.checked)
		elseif self.SetTexture then
			checked = self
			checked:SetTexture(DB.checked)
		end

		if classColor then
			checked:SetVertexColor(cr, cg, cb)
		end

		checked:SetAllPoints(relativeTo)
	end

	function B:ReskinHighlight(relativeTo, classColor, isVertex)
		if not self then return end

		local r, g, b = 1, 1, 1
		if classColor then r, g, b = cr, cg, cb end

		local tex
		if self.SetHighlightTexture then
			self:SetHighlightTexture(DB.bdTex)
			tex = self:GetHighlightTexture()
		elseif self.GetNormalTexture then
			tex = self:GetNormalTexture()
			tex:SetTexture(DB.bdTex)
		elseif self.SetTexture then
			tex = self
			tex:SetTexture(DB.bdTex)
		end

		if isVertex then
			tex:SetVertexColor(r, g, b, .25)
		else
			tex:SetColorTexture(r, g, b, .25)
		end

		if not relativeTo then return end
		tex:SetInside(relativeTo)
	end

	-- UI templates
	function B:ReskinGarrisonPortrait()
		self.Portrait:ClearAllPoints()
		self.Portrait:SetPoint("TOPLEFT", 4, -4)
		self.Portrait:SetMask(DB.bdTex)
		self.PortraitRing:Hide()
		self.PortraitRingQuality:SetTexture("")
		if self.Highlight then self.Highlight:Hide() end

		self.LevelBorder:SetScale(.0001)
		self.Level:ClearAllPoints()
		self.Level:SetPoint("BOTTOM", self, 0, 12)

		local squareBG = B.CreateBDFrame(self.Portrait, 1)
		self.squareBG = squareBG

		if self.PortraitRingCover then
			self.PortraitRingCover:SetColorTexture(0, 0, 0)
			self.PortraitRingCover:SetAllPoints(self.squareBG)
		end

		if self.Empty then
			self.Empty:SetColorTexture(0, 0, 0)
			self.Empty:SetAllPoints(self.Portrait)
		end
	end

	function B:ReskinAffixes()
		for _, frame in ipairs(self.Affixes) do
			frame.Border:SetTexture(nil)
			frame.Portrait:SetTexture(nil)
			if not frame.styled then
				B.ReskinIcon(frame.Portrait, 1)

				frame.styled = true
			end

			if frame.info then
				frame.Portrait:SetTexture(CHALLENGE_MODE_EXTRA_AFFIX_INFO[frame.info.key].texture)
			elseif frame.affixID then
				local _, _, filedataid = C_ChallengeMode.GetAffixInfo(frame.affixID)
				frame.Portrait:SetTexture(filedataid)
			end
		end
	end

	function B:ReskinFrame(killType)
		if killType == "noKill" then
			B.StripTextures(self)
		else
			B.StripTextures(self, killType or 0)
		end
		B.CleanTextures(self)

		local bg = B.CreateBDFrame(self, nil, 0, true)
		local frameName = self.GetName and self:GetName()
		for _, key in pairs({"Header", "header"}) do
			local frameHeader = self[key] or (frameName and _G[frameName..key])
			if frameHeader then
				B.StripTextures(frameHeader)

				frameHeader:ClearAllPoints()
				frameHeader:SetPoint("TOP", bg, "TOP", 0, 5)
			end
		end
		for _, key in pairs({"Portrait", "portrait"}) do
			local framePortrait = self[key] or (frameName and _G[frameName..key])
			if framePortrait then framePortrait:SetAlpha(0) end
		end

		local closeButton = self.CloseButton or (frameName and _G[frameName.."CloseButton"])
		if closeButton then B.ReskinClose(closeButton, "TOPRIGHT", bg, "TOPRIGHT", -6, -6) end

		return bg
	end

	function B.UpdateMerchantInfo()
		for i = 1, MERCHANT_ITEMS_PER_PAGE do
			local money = _G["MerchantItem"..i.."MoneyFrame"]
			local currency = _G["MerchantItem"..i.."AltCurrencyFrame"]

			currency:ClearAllPoints()
			if money:IsShown() then
				currency:Point("LEFT", money, "RIGHT", -10, 2)
			else
				currency:Point("LEFT", money, "LEFT", 0, 2)
			end
		end
	end

	function B.ReskinMerchantItem(index)
		local frame = "MerchantItem"..index

		local item = _G[frame]
		B.StripTextures(item)

		local button = _G[frame.."ItemButton"]
		B.StripTextures(button)

		local icbg = B.ReskinIcon(button.icon)
		B.ReskinHighlight(button, icbg)
		B.ReskinBorder(button.IconBorder, icbg)

		local count = _G[frame.."ItemButtonCount"]
		count:SetJustifyH("RIGHT")
		count:ClearAllPoints()
		count:SetPoint("BOTTOMRIGHT", icbg, "BOTTOMRIGHT", -1, 1)

		local stock = _G[frame.."ItemButtonStock"]
		stock:SetJustifyH("RIGHT")
		stock:ClearAllPoints()
		stock:SetPoint("TOPRIGHT", icbg, "TOPRIGHT", -1, -1)

		local name = _G[frame.."Name"]
		name:SetWordWrap(false)
		name:SetJustifyH("LEFT")
		name:ClearAllPoints()
		name:SetPoint("TOPLEFT", icbg, "TOPRIGHT", 4, 2)

		local money = _G[frame.."MoneyFrame"]
		money:ClearAllPoints()
		money:SetPoint("BOTTOMLEFT", icbg, "BOTTOMRIGHT", 4, 2)

		for i = 1, 3 do
			B.ReskinIcon(_G[frame.."AltCurrencyFrameItem"..i.."Texture"])
		end
	end

	function B:ReskinPartyPoseUI()
		B.ReskinFrame(self)
		B.ReskinButton(self.LeaveButton)
		B.StripTextures(self.ModelScene)
		B.CreateBDFrame(self.ModelScene, 0)

		self.OverlayElements.Topper:Hide()

		local RewardFrame = self.RewardAnimations.RewardFrame
		RewardFrame.NameFrame:SetAlpha(0)
		RewardFrame.IconBorder:SetAlpha(0)

		local icbg = B.ReskinIcon(RewardFrame.Icon)
		local Label = RewardFrame.Label
		Label:ClearAllPoints()
		Label:SetPoint("LEFT", icbg, "RIGHT", 6, 10)

		local Name = RewardFrame.Name
		Name:ClearAllPoints()
		Name:SetPoint("LEFT", icbg, "RIGHT", 6, -10)
	end

	function B:ReskinReforgeUI(index)
		B.StripTextures(self, index)
		B.ReskinClose(self.CloseButton)
		B.CreateBG(self)

		local Background = self.Background
		B.CreateBDFrame(Background, 0, nil, true)

		local ItemSlot = self.ItemSlot
		B.ReskinIcon(ItemSlot.Icon)

		local ButtonFrame = self.ButtonFrame
		ButtonFrame.MoneyFrameEdge:SetAlpha(0)
		B.StripTextures(ButtonFrame)

		local bubg = B.CreateBDFrame(ButtonFrame, 0)
		bubg:Point("TOPLEFT", ButtonFrame.MoneyFrameEdge, 2, 0)
		bubg:Point("BOTTOMRIGHT", ButtonFrame.MoneyFrameEdge, 0, 2)

		if ButtonFrame.AzeriteRespecButton then B.ReskinButton(ButtonFrame.AzeriteRespecButton) end
		if ButtonFrame.ActionButton then B.ReskinButton(ButtonFrame.ActionButton) end
		if ButtonFrame.Currency then B.ReskinIcon(ButtonFrame.Currency.icon) end
	end

	function B:ReskinSearchBox()
		B.StripTextures(self)
		B.CleanTextures(self)

		local bg = B.CreateBDFrame(self, 0, -C.mult)
		B.ReskinHighlight(self, bg, true)

		local icon = self.icon or self.Icon
		if icon then B.ReskinIcon(icon) end
	end

	function B:ReskinSearchResult()
		if not self then return end

		local results = self.searchResults
		results:ClearAllPoints()
		results:Point("BOTTOMLEFT", self, "BOTTOMRIGHT", 50, 0)
		B.StripTextures(results)
		B.CleanTextures(results)
		B.CreateBG(results, -10, 0, 0, 0)

		local frameName = self.GetName and self:GetName()
		local closebu = results.closeButton or (frameName and _G[frameName.."SearchResultsCloseButton"])
		B.ReskinClose(closebu)

		local bar = results.scrollFrame.scrollBar
		if bar then B.ReskinScroll(bar) end

		for i = 1, 9 do
			local bu = results.scrollFrame.buttons[i]

			if bu and not bu.styled then
				B.StripTextures(bu)

				local icbg = B.ReskinIcon(bu.icon)
				bu.icon.SetTexCoord = B.Dummy

				local bubg = B.CreateBGFrame(bu, 2, 2, -2, -2, icbg)
				B.ReskinHighlight(bu, bubg, true)

				local name = bu.name
				name:ClearAllPoints()
				name:SetPoint("TOPLEFT", bubg, 4, -6)

				local path = bu.path
				path:ClearAllPoints()
				path:SetPoint("BOTTOMLEFT", bubg, 4, 4)

				local type = bu.resultType
				type:ClearAllPoints()
				type:SetPoint("RIGHT", bubg, -2, 0)

				bu.styled = true
			end
		end
	end

	function B:ReskinSort()
		B.ReskinButton(self)
		B.ReskinHighlight(self, self)

		self:SetSize(26, 26)
		self:SetNormalTexture("Interface\\Icons\\INV_Pet_Broom")
		self:SetPushedTexture("Interface\\Icons\\INV_Pet_Broom")
	end

	-- Role Icons
	function B:GetRoleTexCoord()
		if self == "TANK" then
			return 0.33/9.03, 2.84/9.03, 3.16/9.03, 5.67/9.03
		elseif self == "DPS" or self == "DAMAGER" then
			return 3.26/9.03, 5.76/9.03, 3.16/9.03, 5.67/9.03
		elseif self == "HEALER" then
			return 3.26/9.03, 5.76/9.03, 0.29/9.03, 2.77/9.03
		elseif self == "LEADER" then
			return 0.33/9.03, 2.84/9.03, 0.29/9.03, 2.77/9.03
		elseif self == "READY" then
			return 6.18/9.03, 8.73/9.03, 0.29/9.03, 2.77/9.03
		elseif self == "PENDING" then
			return 6.18/9.03, 8.73/9.03, 3.16/9.03, 5.67/9.03
		elseif self == "REFUSE" then
			return 3.26/9.03, 5.76/9.03, 6.04/9.03, 8.60/9.03
		end
	end

	function B:ReskinRole(role)
		local frameName = self.GetName and self:GetName()
		for _, key in pairs({"background", "Cover", "cover"}) do
			local tex = self[key] or (frameName and _G[frameName..key])
			if tex then tex:SetTexture("") end
		end

		local texture = self.Icon or self.icon or self.Texture or self.texture or (self.SetTexture and self) or (self.GetNormalTexture and self:GetNormalTexture())
		if texture then
			texture:SetTexture(DB.rolesTex)
			texture:SetTexCoord(B.GetRoleTexCoord(role))
		end

		local checkButton = self.checkButton or self.CheckButton or self.CheckBox
		if checkButton then
			checkButton:SetFrameLevel(self:GetFrameLevel() + 2)
			checkButton:ClearAllPoints()
			checkButton:Point("BOTTOMLEFT", -2, -2)
			B.ReskinCheck(checkButton)
		end

		local shortageBorder = self.shortageBorder
		if shortageBorder then
			shortageBorder:SetTexture("")

			local icon = self.incentiveIcon
			icon.border:Hide()
			icon.texture:ClearAllPoints()
			icon.texture:Point("BOTTOMRIGHT", self, -3, 3)
			icon.texture:SetSize(14, 14)

			local icbg = B.ReskinIcon(icon.texture)
			icbg:SetFrameLevel(self:GetFrameLevel() + 1)
		end

		self.bg = B.CreateBDFrame(self, 0)
	end

	function B:ReskinRoleIcon()
		self:SetTexture(DB.rolesTex)
		local bg = B.CreateBDFrame(self)

		return bg
	end
end

-- GUI elements
do
	function B:CreateButton(width, height, text, fontSize)
		local bu = CreateFrame("Button", nil, self)
		bu:SetSize(width, height)
		if type(text) == "boolean" then
			B.PixelIcon(bu, fontSize, true)
		else
			B.ReskinButton(bu)
			bu.text = B.CreateFS(bu, fontSize or 14, text, true)
		end

		return bu
	end

	function B:CreateCheckBox()
		local cb = CreateFrame("CheckButton", nil, self, "InterfaceOptionsCheckButtonTemplate")
		B.ReskinCheck(cb)

		cb.Type = "CheckBox"
		return cb
	end

	local function editBoxClearFocus(self)
		self:ClearFocus()
	end

	function B:CreateEditBox(width, height)
		local eb = CreateFrame("EditBox", nil, self)
		eb:SetSize(width, height)
		eb:SetAutoFocus(false)
		eb:SetTextInsets(5, 5, 0, 0)
		eb:SetFont(DB.Font[1], DB.Font[2]+2, DB.Font[3])
		B.CreateBDFrame(eb, 0)
		eb:SetScript("OnEscapePressed", editBoxClearFocus)
		eb:SetScript("OnEnterPressed", editBoxClearFocus)

		eb.Type = "EditBox"
		return eb
	end

	local function optOnClick(self)
		PlaySound(SOUNDKIT.GS_TITLE_OPTION_OK)
		local opt = self.__owner.options
		for i = 1, #opt do
			if self == opt[i] then
				opt[i]:SetBackdropColor(1, .8, 0, .25)
				opt[i].selected = true
			else
				opt[i]:SetBackdropColor(0, 0, 0, 0)
				opt[i].selected = false
			end
		end
		self.__owner.Text:SetText(self.text)
		self:GetParent():Hide()
	end

	local function optOnEnter(self)
		if self.selected then return end
		self:SetBackdropColor(1, 1, 1, .25)
	end

	local function optOnLeave(self)
		if self.selected then return end
		self:SetBackdropColor(0, 0, 0, 0)
	end

	local function buttonOnShow(self)
		self.__list:Hide()
	end

	local function buttonOnClick(self)
		PlaySound(SOUNDKIT.GS_TITLE_OPTION_OK)
		B.TogglePanel(self.__list)
	end

	function B:CreateDropDown(width, height, data)
		local dd = CreateFrame("Frame", nil, self)
		dd:SetSize(width, height)
		B.CreateBD(dd, 0)
		B.CreateSD(dd)
		B.CreateGF(dd)
		dd:SetBackdropBorderColor(1, 1, 1)
		dd.Text = B.CreateFS(dd, 14, "", false, "LEFT", 5, 0)
		dd.Text:SetPoint("RIGHT", -5, 0)
		dd.options = {}

		local bu = B.CreateGear(dd)
		bu:ClearAllPoints()
		bu:SetPoint("LEFT", dd, "RIGHT", 0, 0)
		local list = CreateFrame("Frame", nil, dd)
		list:ClearAllPoints()
		list:SetPoint("TOP", dd, "BOTTOM", 0, -2)
		B.CreateBD(list, 1)
		B.CreateSD(list)
		list:SetBackdropBorderColor(1, 1, 1)
		list:Hide()
		bu.__list = list
		bu:SetScript("OnShow", buttonOnShow)
		bu:SetScript("OnClick", buttonOnClick)
		dd.button = bu

		local opt, index = {}, 0
		for i, j in pairs(data) do
			opt[i] = CreateFrame("Button", nil, list)
			opt[i]:ClearAllPoints()
			opt[i]:SetPoint("TOPLEFT", 4, -4 - (i-1)*(height+2))
			opt[i]:SetSize(width - 8, height)
			B.CreateBD(opt[i], 0)
			B.CreateSD(opt[i])
			B.CreateGF(opt[i])
			local text = B.CreateFS(opt[i], 14, j, false, "LEFT", 5, 0)
			text:SetPoint("RIGHT", -5, 0)
			opt[i].text = j
			opt[i].__owner = dd
			opt[i]:SetScript("OnClick", optOnClick)
			opt[i]:SetScript("OnEnter", optOnEnter)
			opt[i]:SetScript("OnLeave", optOnLeave)

			dd.options[i] = opt[i]
			index = index + 1
		end
		list:SetSize(width, index*(height+2) + 6)

		dd.Type = "DropDown"
		return dd
	end

	local function updatePicker()
		local swatch = ColorPickerFrame.__swatch
		local r, g, b = ColorPickerFrame:GetColorRGB()
		swatch.tex:SetVertexColor(r, g, b)
		swatch.color.r, swatch.color.g, swatch.color.b = r, g, b
	end

	local function cancelPicker()
		local swatch = ColorPickerFrame.__swatch
		local r, g, b = ColorPicker_GetPreviousValues()
		swatch.tex:SetVertexColor(r, g, b)
		swatch.color.r, swatch.color.g, swatch.color.b = r, g, b
	end

	local function openColorPicker(self)
		local r, g, b = self.color.r, self.color.g, self.color.b
		ColorPickerFrame.__swatch = self
		ColorPickerFrame.func = updatePicker
		ColorPickerFrame.previousValues = {r = r, g = g, b = b}
		ColorPickerFrame.cancelFunc = cancelPicker
		ColorPickerFrame:SetColorRGB(r, g, b)
		ColorPickerFrame:Show()
	end

	function B:CreateColorSwatch(name, color)
		color = color or {r=1, g=1, b=1}

		local swatch = CreateFrame("Button", nil, self)
		swatch:SetSize(18, 18)
		swatch.text = B.CreateFS(swatch, 14, name, false, "LEFT", 26, 0)

		local bg = B.CreateBDFrame(swatch, 0)
		local tex = swatch:CreateTexture()
		tex:SetInside(bg)
		tex:SetTexture(DB.bdTex)
		tex:SetVertexColor(color.r, color.g, color.b)

		swatch.tex = tex
		swatch.color = color
		swatch:SetScript("OnClick", openColorPicker)

		return swatch
	end

	local function updateSliderEditBox(self)
		local slider = self.__owner
		local minValue, maxValue = slider:GetMinMaxValues()
		local text = tonumber(self:GetText())
		if not text then return end
		text = min(maxValue, text)
		text = max(minValue, text)
		slider:SetValue(text)
		self:SetText(text)
		self:ClearFocus()
	end

	function B:CreateSlider(name, minValue, maxValue, x, y, width)
		local slider = CreateFrame("Slider", nil, self, "OptionsSliderTemplate")
		slider:ClearAllPoints()
		slider:SetPoint("TOPLEFT", x, y)
		slider:SetWidth(width or 200)
		slider:SetMinMaxValues(minValue, maxValue)
		slider:SetHitRectInsets(0, 0, 0, 0)
		B.ReskinSlider(slider)

		slider.Low:SetText(minValue)
		slider.Low:ClearAllPoints()
		slider.Low:SetPoint("TOPLEFT", slider, "BOTTOMLEFT", 10, -2)
		slider.High:SetText(maxValue)
		slider.High:ClearAllPoints()
		slider.High:SetPoint("TOPRIGHT", slider, "BOTTOMRIGHT", -10, -2)
		slider.Text:ClearAllPoints()
		slider.Text:SetPoint("CENTER", 0, 25)
		slider.Text:SetText(name)
		slider.Text:SetTextColor(1, .8, 0)
		slider.value = B.CreateEditBox(slider, 50, 20)
		slider.value:ClearAllPoints()
		slider.value:SetPoint("TOP", slider, "BOTTOM")
		slider.value:SetJustifyH("CENTER")
		slider.value.__owner = slider
		slider.value:SetScript("OnEnterPressed", updateSliderEditBox)

		return slider
	end

	function B:TogglePanel()
		if self:IsShown() then
			self:Hide()
		else
			self:Show()
		end
	end
end

-- Add API
do
	local function WatchPixelSnap(frame, snap)
		if (frame and not frame:IsForbidden()) and frame.PixelSnapDisabled and snap then
			frame.PixelSnapDisabled = nil
		end
	end

	local function DisablePixelSnap(frame)
		if (frame and not frame:IsForbidden()) and not frame.PixelSnapDisabled then
			if frame.SetSnapToPixelGrid then
				frame:SetSnapToPixelGrid(false)
				frame:SetTexelSnappingBias(0)
			elseif frame.GetStatusBarTexture then
				local texture = frame:GetStatusBarTexture()
				if texture and texture.SetSnapToPixelGrid then
					texture:SetSnapToPixelGrid(false)
					texture:SetTexelSnappingBias(0)
				end
			end

			frame.PixelSnapDisabled = true
		end
	end

	local function Point(frame, arg1, arg2, arg3, arg4, arg5, ...)
		if arg2 == nil then arg2 = frame:GetParent() end

		if type(arg2) == "number" then arg2 = B.Scale(arg2) end
		if type(arg3) == "number" then arg3 = B.Scale(arg3) end
		if type(arg4) == "number" then arg4 = B.Scale(arg4) end
		if type(arg5) == "number" then arg5 = B.Scale(arg5) end

		frame:SetPoint(arg1, arg2, arg3, arg4, arg5, ...)
	end

	local function SetInside(frame, anchor, xOffset, yOffset, anchor2)
		xOffset = xOffset or C.mult
		yOffset = yOffset or C.mult
		anchor = anchor or frame:GetParent()

		DisablePixelSnap(frame)
		frame:ClearAllPoints()
		frame:Point("TOPLEFT", anchor, "TOPLEFT", xOffset, -yOffset)
		frame:Point("BOTTOMRIGHT", anchor2 or anchor, "BOTTOMRIGHT", -xOffset, yOffset)
	end

	local function SetOutside(frame, anchor, xOffset, yOffset, anchor2)
		xOffset = xOffset or C.mult
		yOffset = yOffset or C.mult
		anchor = anchor or frame:GetParent()

		DisablePixelSnap(frame)
		frame:ClearAllPoints()
		frame:Point("TOPLEFT", anchor, "TOPLEFT", -xOffset, yOffset)
		frame:Point("BOTTOMRIGHT", anchor2 or anchor, "BOTTOMRIGHT", xOffset, -yOffset)
	end

	local function addapi(object)
		local mt = getmetatable(object).__index
		if not object.Point then mt.Point = Point end
		if not object.SetInside then mt.SetInside = SetInside end
		if not object.SetOutside then mt.SetOutside = SetOutside end
		if not object.DisabledPixelSnap then
			if mt.SetTexture then hooksecurefunc(mt, "SetTexture", DisablePixelSnap) end
			if mt.SetTexCoord then hooksecurefunc(mt, "SetTexCoord", DisablePixelSnap) end
			if mt.CreateTexture then hooksecurefunc(mt, "CreateTexture", DisablePixelSnap) end
			if mt.SetVertexColor then hooksecurefunc(mt, "SetVertexColor", DisablePixelSnap) end
			if mt.SetColorTexture then hooksecurefunc(mt, "SetColorTexture", DisablePixelSnap) end
			if mt.SetSnapToPixelGrid then hooksecurefunc(mt, "SetSnapToPixelGrid", WatchPixelSnap) end
			if mt.SetStatusBarTexture then hooksecurefunc(mt, "SetStatusBarTexture", DisablePixelSnap) end
			mt.DisabledPixelSnap = true
		end
	end

	local handled = {["Frame"] = true}
	local object = CreateFrame("Frame")
	addapi(object)
	addapi(object:CreateTexture())
	addapi(object:CreateMaskTexture())

	object = EnumerateFrames()
	while object do
		if not object:IsForbidden() and not handled[object:GetObjectType()] then
			addapi(object)
			handled[object:GetObjectType()] = true
		end

		object = EnumerateFrames(object)
	end
end