local _, ns = ...
local B, C, L, DB = unpack(ns)

local _G = _G
local type, pairs, tonumber, wipe, next, select, unpack = type, pairs, tonumber, table.wipe, next, select, unpack
local strmatch, gmatch, strfind, format, gsub = string.match, string.gmatch, string.find, string.format, string.gsub
local min, max, floor, rad = math.min, math.max, math.floor, math.rad

local cr, cg, cb = DB.cr, DB.cg, DB.cb
local tL, tR, tT, tB = unpack(DB.TexCoord)

-- Math Function
do
	-- Number
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

	function B.Scale(x)
		local mult = C.mult

		return mult * B.Round(x / mult)
	end

	-- Time
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

	-- Cooldown
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
			word = tonumber(word) or word -- use number if exists, needs review
			list[word] = true
		end
	end
end

-- Color Function
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

-- Itemlevel Function
do
	local iLvlDB = {}
	local itemLevelString = gsub(ITEM_LEVEL, "%%d", "")
	local enchantString = gsub(ENCHANTED_TOOLTIP_LINE, "%%s", "(.+)")
	local essenceTextureID = 2975691
	local essenceDescription = GetSpellDescription(277253)
	local ITEM_SPELL_TRIGGER_ONEQUIP = ITEM_SPELL_TRIGGER_ONEQUIP
	local RETRIEVING_ITEM_INFO = RETRIEVING_ITEM_INFO

	local tip = CreateFrame("GameTooltip", "NDui_ScanTooltip", nil, "GameTooltipTemplate")
	B.ScanTip = tip

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
			local tex = _G[tip:GetDebugName().."Texture"..i]
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
				local line = _G[tip:GetDebugName().."TextLeft"..index-i]
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
				local line = _G[tip:GetDebugName().."TextLeft"..i]
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

			local firstLine = _G.NDui_ScanTooltipTextLeft1:GetText()
			if firstLine == RETRIEVING_ITEM_INFO then
				return "tooSoon"
			end

			for i = 2, 5 do
				local line = _G[tip:GetDebugName().."TextLeft"..i]
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

-- ItemInfo Function
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
end

-- Kill Function
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
		self:EnableMouse(false)
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
		"GarrCorners",
		"Inset",
		"inset",
		"InsetFrame",
		"InsetLeft",
		"InsetRight",
		"LeftInset",
		"NineSlice",
		"Overlay",
		"Portrait",
		"portrait",
		"PortraitOverlay",
		"RightInset",
		"ScrollDownBorder",
		"ScrollFrameBorder",
		"ScrollUpBorder",
		"ShadowOverlay",
		"shadows",
	}

	function B:StripTextures(kill)
		local frameName = self:GetDebugName()
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
		"Center",
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

	function B:CleanTextures(isOverride)
		if self.SetBackdrop then self:SetBackdrop(nil) end
		if self.SetDisabledTexture then self:SetDisabledTexture("") end
		if self.SetHighlightTexture then self:SetHighlightTexture("") end
		if self.SetPushedTexture then self:SetPushedTexture("") end
		if self.SetNormalTexture and not isOverride then self:SetNormalTexture("") end

		local frameName = self:GetDebugName()
		for _, key in pairs(cleanTextures) do
			local cleanFrame = self[key] or (frameName and _G[frameName..key])
			if cleanFrame then
				cleanFrame:SetAlpha(0)
				cleanFrame:Hide()
			end
		end
	end
end

-- Reskin Function
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

	-- Setup Function
	local function SetupDisTex(self)
		self:SetDisabledTexture(DB.bgTex)
		local dis = self:GetDisabledTexture()
		dis:SetVertexColor(0, 0, 0, .5)
		dis:SetDrawLayer("OVERLAY")
		dis:SetAllPoints()
	end

	function B:SetupHook(isOutside)
		B.Hook_OnEnter(self)
		B.Hook_OnLeave(self)
		B.Hook_OnMouseDown(self)
		B.Hook_OnMouseUp(self, isOutside)
	end

	function B:SetupArrow(direction)
		if self.arrowTex then return end

		local arrowTex = self:CreateTexture(nil, "ARTWORK")
		arrowTex:SetTexture(DB.arrowTex..direction)
		arrowTex:SetInside(nil, 2, 2)
		self.arrowTex = arrowTex
	end

	-- Hook Function
	function B:Tex_OnEnter()
		if self.Tex then
			self.Tex:SetVertexColor(cr, cg, cb, 1)
		elseif self.bgTex then
			self.bgTex:SetBackdropBorderColor(cr, cg, cb, 1)
		elseif self.SetBackdropBorderColor then
			self:SetBackdropBorderColor(cr, cg, cb, 1)
		end
	end

	function B:Tex_OnLeave()
		if self.Tex then
			self.Tex:SetVertexColor(1, 1, 1, 1)
		elseif self.bgTex then
			self.bgTex:SetBackdropBorderColor(0, 0, 0, 1)
		elseif self.SetBackdropBorderColor then
			self:SetBackdropBorderColor(0, 0, 0, 1)
		end
	end

	function B:Tex_OnMouseDown()
		if self.bgTex then
			self.bgTex:SetBackdropColor(cr, cg, cb, .5)
		elseif self.SetBackdropColor then
			self:SetBackdropColor(cr, cg, cb, .5)
		end
	end

	function B:Tex_OnMouseUp(isOutside)
		local BGColor = C.db["Skins"]["BGColor"]
		local BGAlpha = C.db["Skins"]["BGAlpha"]

		if self.bgTex then
			self.bgTex:SetBackdropColor(BGColor.r, BGColor.g, BGColor.b, isOutside and BGAlpha or 0)
		elseif self.SetBackdropColor then
			self:SetBackdropColor(BGColor.r, BGColor.g, BGColor.b, isOutside and BGAlpha or 0)
		end
	end

	function B:Hook_OnEnter()
		self:HookScript("OnEnter", B.Tex_OnEnter)
	end

	function B:Hook_OnLeave()
		self:HookScript("OnLeave", B.Tex_OnLeave)
	end

	function B:Hook_OnMouseDown()
		self:HookScript("OnMouseDown", B.Tex_OnMouseDown)
	end

	function B:Hook_OnMouseUp(isOutside)
		self:HookScript("OnMouseUp", function(self)
			B.Tex_OnMouseUp(self, isOutside)
		end)
	end

	-- Create Function
	C.frames = {}

	function B:CreateBT()
		if not C.db["Skins"]["SkinTexture"] then return end
		if self.bdTex then return end

		local frame = self
		if self:IsObjectType("Texture") then frame = self:GetParent() end

		local bdTex = frame:CreateTexture(nil, "BACKGROUND", nil, 1)
		bdTex:SetInside(self)
		bdTex:SetTexture(DB.bdTex, true, true)
		bdTex:SetHorizTile(true)
		bdTex:SetVertTile(true)
		bdTex:SetBlendMode("ADD")

		self.bdTex = bdTex
	end

	function B:CreateGT()
		if self.gdTex then return end

		local FSColor = C.db["Skins"]["FSColor"]
		local FSAlpha = C.db["Skins"]["FSAlpha"]

		local GSColor1 = C.db["Skins"]["GSColor1"]
		local GSColor2 = C.db["Skins"]["GSColor2"]
		local GSAlpha1 = C.db["Skins"]["GSAlpha1"]
		local GSAlpha2 = C.db["Skins"]["GSAlpha2"]
		local GSDirection = C.db["Skins"]["GSDirection"]

		local SkinStyle = C.db["Skins"]["SkinStyle"]

		local gdTex = self:CreateTexture(nil, "BORDER")
		gdTex:SetTexture(DB.bgTex)
		gdTex:SetInside()
		if SkinStyle == 1 then
			gdTex:SetVertexColor(FSColor.r, FSColor.g, FSColor.b, FSAlpha)
		else
			gdTex:SetGradientAlpha(GSDirection == 1 and "Vertical" or "Horizontal", GSColor1.r, GSColor1.g, GSColor1.b, GSAlpha1, GSColor2.r, GSColor2.g, GSColor2.b, GSAlpha2)
		end

		self.gdTex = gdTex
	end

	function B:CreateBD(alpha)
		local BGColor = C.db["Skins"]["BGColor"]
		local BGAlpha = C.db["Skins"]["BGAlpha"]

		if alpha == "none" then alpha = nil end

		self:SetBackdrop({bgFile = DB.bgTex, edgeFile = DB.bgTex, edgeSize = C.mult})
		self:SetBackdropColor(BGColor.r, BGColor.g, BGColor.b, alpha or BGAlpha)
		self:SetBackdropBorderColor(0, 0, 0, 1)

		if not alpha then tinsert(C.frames, self) end
	end

	function B:CreateSD(isOverride)
		if not isOverride and not C.db["Skins"]["SkinShadow"] then return end
		if self.sdTex then return end

		local frame = self
		if self:IsObjectType("Texture") then frame = self:GetParent() end

		local SDColor = C.db["Skins"]["SDColor"]
		local SDAlpha = C.db["Skins"]["SDAlpha"]

		local lvl = frame:GetFrameLevel()
		local sdTex = CreateFrame("Frame", nil, frame, "BackdropTemplate")
		sdTex:SetOutside(self, 4, 4)
		sdTex:SetBackdrop({edgeFile = DB.shadowTex, edgeSize = B.Scale(4)})
		sdTex:SetBackdropBorderColor(SDColor.r, SDColor.g, SDColor.b, SDAlpha)
		sdTex:SetFrameLevel(lvl)
		self.sdTex = sdTex

		return sdTex
	end

	function B:CreateBDFrame(alpha, offset, noGT)
		local frame = self
		if self:IsObjectType("Texture") then frame = self:GetParent() end

		local lvl = frame:GetFrameLevel()
		local bg = CreateFrame("Frame", nil, frame, "BackdropTemplate")
		bg:SetFrameLevel(lvl == 0 and 0 or lvl - 1)

		local value = offset and math.abs(offset) or 0
		if (offset and offset <= 0) or (not offset) then
			bg:SetOutside(self, value, value)
		elseif (offset and offset >= 0) or (not offset) then
			bg:SetInside(self, value, value)
		end

		B.CreateBD(bg, alpha or 0)
		B.CreateSD(bg)

		if not noGT then
			B.CreateGT(bg)
		end

		return bg
	end

	function B:CreateBGFrame(x, y, x2, y2, frame)
		local bg = B.CreateBDFrame(self)
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
		local bg = B.CreateBDFrame(self, "none", 0, true)

		if x and y and x2 and y2 then
			bg:ClearAllPoints()
			bg:Point("TOPLEFT", self, x, y)
			bg:Point("BOTTOMRIGHT", self, x2, y2)
		end

		B.CreateBT(bg)

		return bg
	end

	local orientationAbbr = {["V"] = "Vertical", ["H"] = "Horizontal"}
	function B:CreateGA(orientation, r, g, b, a1, a2, width, height)
		orientation = orientationAbbr[orientation]
		if not orientation then return end

		local tex = self:CreateTexture(nil, "BACKGROUND")
		tex:SetTexture(DB.bgTex)
		tex:SetGradientAlpha(orientation, r, g, b, a1, r, g, b, a2)

		if width then tex:SetWidth(width) end
		if height then tex:SetHeight(height) end

		return tex
	end

	-- Reskin Function
	-- Handle Affixes
	function B:ReskinAffixes()
		for _, frame in ipairs(self.Affixes) do
			frame.Border:SetTexture("")
			frame.Portrait:SetTexture("")
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

	-- Handle Arrow
	function B:ReskinArrow(direction, size)
		self:SetSize(size or 18, size or 18)

		B.StripTextures(self, 0)

		B.ReskinButton(self)
		B.SetupArrow(self, direction)

		SetupDisTex(self)
	end

	-- Handle Border
	local AtlasToQuality = {
		["auctionhouse-itemicon-border-gray"] = LE_ITEM_QUALITY_POOR,
		["auctionhouse-itemicon-border-white"] = LE_ITEM_QUALITY_COMMON,
		["auctionhouse-itemicon-border-green"] = LE_ITEM_QUALITY_UNCOMMON,
		["auctionhouse-itemicon-border-blue"] = LE_ITEM_QUALITY_RARE,
		["auctionhouse-itemicon-border-purple"] = LE_ITEM_QUALITY_EPIC,
		["auctionhouse-itemicon-border-orange"] = LE_ITEM_QUALITY_LEGENDARY,
		["auctionhouse-itemicon-border-artifact"] = LE_ITEM_QUALITY_ARTIFACT,
		["auctionhouse-itemicon-border-account"] = LE_ITEM_QUALITY_HEIRLOOM,
	}

	local function updateBorderAtlas(self, atlas)
		local quality = AtlasToQuality[atlas]
		local r, g, b = GetItemQualityColor(quality or 1)

		self.__owner.icbg:SetBackdropBorderColor(r, g, b)
		if self.__owner.bubg then
			self.__owner.bubg:SetBackdropBorderColor(r, g, b)
		end
	end

	local function updateBorderColor(self, r, g, b)
		if (not r) or (r == .65882) then r, g, b = 1, 1, 1 end

		self.__owner.icbg:SetBackdropBorderColor(r, g, b)
		if self.__owner.bubg then
			self.__owner.bubg:SetBackdropBorderColor(r, g, b)
		end
	end

	local function resetBorderColor(self)
		self.__owner.icbg:SetBackdropBorderColor(0, 0, 0)
		if self.__owner.bubg then
			self.__owner.bubg:SetBackdropBorderColor(0, 0, 0)
		end
	end

	function B:ReskinBorder(icbg, bubg, needInit)
		if not self then return end

		self:SetAlpha(0)

		local parent = self:GetParent()
		self.__owner = parent

		if not parent.icbg and icbg then parent.icbg = icbg end
		if not parent.bubg and bubg then parent.bubg = bubg end
		if not parent.icbg then return end

		if parent.useCircularIconBorder then
			hooksecurefunc(self, "SetAtlas", updateBorderAtlas)
		else
			hooksecurefunc(self, "SetVertexColor", updateBorderColor)
			if needInit then
				self:SetVertexColor(self:GetVertexColor()) -- for border with color before hook
			end
		end
		hooksecurefunc(self, "Hide", resetBorderColor)

		if parent.IconOverlay then parent.IconOverlay:SetInside(icbg) end
		if parent.IconOverlay2 then parent.IconOverlay2:SetInside(icbg) end
	end

	function B:ReskinSpecialBorder(relativeTo, classColor)
		if not self then return end

		self:SetTexture(DB.bgTex)
		self.SetTexture = B.Dummy
		self:SetDrawLayer("BACKGROUND")

		if classColor then
			self:SetColorTexture(cr, cg, cb)
		end

		self:SetAllPoints(relativeTo)
	end

	-- Handle Button
	function B:ReskinButton(isOutside, isOverride)
		B.CleanTextures(self, isOverride)

		local bgTex = isOutside and B.CreateBG(self) or B.CreateBDFrame(self)
		bgTex:SetFrameLevel(self:GetFrameLevel())
		self.bgTex = bgTex

		B.SetupHook(self, isOutside)
	end

	-- Handle Check and Radio
	function B:ReskinCheck(forceSaturation)
		B.CleanTextures(self)

		local check = self:GetCheckedTexture()
		check:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
		check:SetTexCoord(0, 1, 0, 1)
		check:SetDesaturated(true)
		check:SetVertexColor(cr, cg, cb)

		local bgTex = B.CreateBDFrame(self, 0, 4)
		bgTex:SetFrameLevel(self:GetFrameLevel())
		self.bgTex = bgTex

		B.SetupHook(self)
		self.forceSaturation = forceSaturation
	end

	function B:ReskinRadio()
		B.StripTextures(self, 0)
		B.CleanTextures(self)

		local bgTex = B.CreateBDFrame(self, 0, 2)
		bgTex:SetFrameLevel(self:GetFrameLevel())
		self.bgTex = bgTex

		self:SetCheckedTexture(DB.bgTex)
		local check = self:GetCheckedTexture()
		check:SetVertexColor(cr, cg, cb, .75)
		check:SetInside(bgTex)

		B.SetupHook(self)
	end

	-- Handle Checked and Pushed
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

		checked:SetInside(relativeTo)
	end

	function B:ReskinPushed(relativeTo, classColor)
		if not self then return end

		local pushed
		if self.SetPushedTexture then
			self:SetPushedTexture(DB.pushed)
			pushed = self:GetPushedTexture()
		elseif self.GetNormalTexture then
			pushed = self:GetNormalTexture()
			pushed:SetTexture(DB.pushed)
		elseif self.SetTexture then
			pushed = self
			pushed:SetTexture(DB.pushed)
		end

		if classColor then
			pushed:SetVertexColor(cr, cg, cb)
		end

		pushed:SetInside(relativeTo)
	end

	-- Handle Close and Decline
	function B:ReskinClose(parent, xOffset, yOffset)
		self:SetSize(18, 18)
		self:ClearAllPoints()
		self:Point("TOPRIGHT", parent or self:GetParent(), "TOPRIGHT", xOffset or -6, yOffset or -6)

		B.StripTextures(self, 0)

		B.ReskinButton(self)
		SetupDisTex(self)

		local tex = self:CreateTexture()
		tex:SetTexture(DB.closeTex)
		tex:SetInside(nil, 2, 2)
	end

	function B:ReskinDecline()
		B.StripTextures(self, 0)

		B.ReskinButton(self)

		local tex = self:CreateTexture()
		tex:SetTexture(DB.closeTex)
		tex:SetInside(nil, 2, 2)
	end

	-- Handle Collapse and MinMax
	local function updateCollapseTexture(texture, collapsed)
		local atlas = collapsed and "Soulbinds_Collection_CategoryHeader_Expand" or "Soulbinds_Collection_CategoryHeader_Collapse"
		texture:SetAtlas(atlas, true)
	end

	local function resetCollapseTexture(self, texture)
		if self.setTex then return end
		self.setTex = true
		self:SetNormalTexture("")

		if texture and texture ~= "" then
			if strfind(texture, "Plus") or strfind(texture, "Closed") or (type(texture) == "number" and texture == 130838) then
				self.expTex:DoCollapse(true)
			elseif strfind(texture, "Minus") or strfind(texture, "Open") or (type(texture) == "number" and texture == 130821) then
				self.expTex:DoCollapse(false)
			end
			self.bgTex:Show()
		else
			self.bgTex:Hide()
		end

		self.setTex = false
	end

	function B:ReskinCollapse(isAtlas)
		B.StripTextures(self, 0)
		B.CleanTextures(self)

		local bgTex = B.CreateBDFrame(self)
		bgTex:SetFrameLevel(self:GetFrameLevel())
		bgTex:SetSize(14, 14)
		bgTex:ClearAllPoints()
		bgTex:SetPoint("CENTER", self:GetNormalTexture())
		self.bgTex = bgTex

		local expTex = bgTex:CreateTexture(nil, "OVERLAY")
		expTex:SetOutside(nil, 4, 4)
		expTex.DoCollapse = updateCollapseTexture
		self.expTex = expTex

		B.SetupHook(self)

		if isAtlas then
			hooksecurefunc(self, "SetNormalAtlas", resetCollapseTexture)
		else
			hooksecurefunc(self, "SetNormalTexture", resetCollapseTexture)
		end
	end

	local buttonNames = {"MaximizeButton", "MinimizeButton"}
	function B:ReskinMinMax()
		for _, name in pairs(buttonNames) do
			local button = self[name]
			if button then
				button:ClearAllPoints()
				button:Point("CENTER", -3, 0)

				B.ReskinArrow(button, "max")

				if name == "MaximizeButton" then
					button.arrowTex:SetTexture(DB.arrowTex.."max")
				else
					button.arrowTex:SetTexture(DB.arrowTex.."min")
				end
			end
		end
	end

	-- Handle Color Swatch
	function B:ReskinColorSwatch()
		local icon

		if self.Color then
			icon = self.Color
			icon:SetTexture(DB.bgTex)
		else
			self:SetNormalTexture(DB.bgTex)
			icon = self:GetNormalTexture()
		end

		icon:SetInside(nil, 2, 2)

		local frameName = self:GetDebugName()
		local bg = self.SwatchBg or (frameName and _G[frameName.."SwatchBg"])
		bg:SetColorTexture(0, 0, 0, 1)
		bg:SetOutside(icon)
	end

	-- Handle DropDown
	function B:ReskinDropDown()
		B.StripTextures(self)
		B.CleanTextures(self)

		local frameName = self:GetDebugName()

		local button = self.Button or (frameName and (_G[frameName.."Button"] or _G[frameName.."_Button"]))
		button:ClearAllPoints()
		button:Point("RIGHT", -18, 2)
		B.ReskinArrow(button, "down", 20)

		local bg = B.CreateBDFrame(self)
		bg:SetFrameLevel(self:GetFrameLevel())
		bg:ClearAllPoints()
		bg:Point("LEFT", self, "LEFT", 16, 0)
		bg:Point("TOP", button, "TOP", 0, 0)
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

	-- Handle EditBox
	function B:ReskinInput(height, width)
		B.CleanTextures(self)
		self:DisableDrawLayer("BACKGROUND")

		if height then self:SetHeight(height) end
		if width then self:SetWidth(width) end

		local bg = B.CreateBGFrame(self, -3, 0, -3, 0)

		return bg
	end

	-- Handle Filter
	function B:ReskinFilter()
		B.StripTextures(self)

		B.ReskinButton(self)

		local height = B.Round(self:GetHeight()*.6)
		self.Icon:SetTexture(DB.arrowTex.."right")
		self.Icon:ClearAllPoints()
		self.Icon:Point("RIGHT", self, "RIGHT", -5, 0)
		self.Icon:SetSize(height, height)

		local frameName = self:GetDebugName()
		for _, key in pairs(textWords) do
			local text = self[key] or (frameName and _G[frameName..key])
			if text then
				text:SetJustifyH("CENTER")
				text:ClearAllPoints()
				text:SetPoint("CENTER")
			end
		end
	end

	-- Handle Frame
	function B:ReskinFrame(killType)
		if killType == "none" then
			B.StripTextures(self)
		else
			B.StripTextures(self, killType or 0)
		end
		B.CleanTextures(self)

		local bg = B.CreateBG(self)
		local frameName = self:GetDebugName()
		for _, key in pairs({"Header", "header"}) do
			local frameHeader = self[key] or (frameName and _G[frameName..key])
			if frameHeader then
				B.StripTextures(frameHeader, 0)

				frameHeader:ClearAllPoints()
				frameHeader:SetPoint("TOP", bg, "TOP", 0, 5)
			end
		end
		for _, key in pairs({"Portrait", "portrait"}) do
			local framePortrait = self[key] or (frameName and _G[frameName..key])
			if framePortrait then framePortrait:SetAlpha(0) end
		end

		local closeButton = self.CloseButton or (frameName and _G[frameName.."CloseButton"])
		if closeButton then B.ReskinClose(closeButton, bg) end

		return bg
	end

	-- Handle Highlight
	function B:ReskinHighlight(relativeTo, classColor, isVertex)
		if not self then return end

		local r, g, b = 1, 1, 1
		if classColor then r, g, b = cr, cg, cb end

		local tex
		if self.SetHighlightTexture then
			self:SetHighlightTexture(DB.bgTex)
			tex = self:GetHighlightTexture()
		elseif self.GetNormalTexture then
			tex = self:GetNormalTexture()
			tex:SetTexture(DB.bgTex)
		elseif self.SetTexture then
			tex = self
			tex:SetTexture(DB.bgTex)
		end

		if isVertex then
			tex:SetVertexColor(r, g, b, .25)
		else
			tex:SetColorTexture(r, g, b, .25)
		end

		if relativeTo then
			tex:SetInside(relativeTo)
		end
	end

	-- Handle Icon
	function B:ReskinIcon(alpha)
		self:SetTexCoord(tL, tR, tT, tB)
		local icbg = B.CreateBDFrame(self, alpha, -C.mult)

		return icbg
	end

	-- Handle NavBar
	function B:ReskinNavBar()
		if self.styled then return end

		B.StripTextures(self, 0)
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

	-- Handle Role Icon
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
		local frameName = self:GetDebugName()
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
			icbg:SetFrameLevel(icon:GetFrameLevel())
		end

		local icbg = B.CreateBDFrame(self, 0, -C.mult)
		self.icbg = icbg
	end

	function B:ReskinRoleIcon(alpha)
		self:SetTexture(DB.rolesTex)
		local icbg = B.CreateBDFrame(self, alpha, -C.mult)

		return icbg
	end

	-- Handle Scroll
	local function GetScrollThumb(self)
		local thumb
		local frameName = self:GetDebugName()
		if self.GetThumbTexture then
			thumb = self:GetThumbTexture()
		else
			for _, key in pairs({"ThumbTexture", "thumbTexture"}) do
				thumb = self[key] or (frameName and _G[frameName..key])
			end
		end

		return thumb
	end

	function B:ReskinScroll()
		B.StripTextures(self, 0)
		B.CleanTextures(self)

		local parent = self:GetParent()
		if parent then
			B.StripTextures(parent, 0)
			B.CleanTextures(parent)
		end

		local thumb = GetScrollThumb(self)
		if thumb then
			thumb:SetAlpha(0)
			thumb:SetWidth(18)

			local bgTex = B.CreateBGFrame(thumb, 0, -3, 0, 3)
			self.bgTex = bgTex

			B.SetupHook(self)
		end

		local up, down = self:GetChildren()
		B.ReskinArrow(up, "up")
		B.ReskinArrow(down, "down")
	end

	-- Handle Slider
	function B:ReskinSlider(verticle)
		self:SetBackdrop(nil)
		B.StripTextures(self)

		B.CreateBGFrame(self, 14, -2, -15, 3)

		local thumb = self:GetThumbTexture()
		thumb:SetTexture(DB.sparkTex)
		thumb:SetBlendMode("ADD")

		if verticle then thumb:SetRotation(math.rad(90)) end
	end

	-- Handle StatusBar
	function B:ReskinStatusBar(noClassColor)
		B.StripTextures(self)
		B.CleanTextures(self)

		B.CreateBDFrame(self, 0, -C.mult)

		self:SetStatusBarTexture(DB.normTex)
		if not noClassColor then
			self:SetStatusBarColor(cr, cg, cb, C.alpha)
		end

		local frameName = self:GetDebugName()
		for _, key in pairs(barWords) do
			local text = self[key] or (frameName and _G[frameName..key])
			if text then
				text:SetJustifyH("CENTER")
				text:ClearAllPoints()
				text:SetPoint("CENTER")
			end
		end
	end

	-- Handle Tab
	function B:ReskinTab()
		B.StripTextures(self)
		B.CleanTextures(self)

		local bg = B.CreateBG(self, 8, -3, -8, 2)
		B.ReskinHighlight(self, bg, true)
	end

	function B:ReskinFrameTab(index, tabName)
		local frameName = self:GetDebugName()
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
					tabs:Point("TOPLEFT", frameName, "BOTTOMLEFT", 15, (1+C.mult*2))
				else
					tabs:Point("LEFT", _G[tab..(i-1)], "RIGHT", -(15+C.mult), 0)
				end
			end
		end
	end
end

-- Other Function
do
	B.EasyMenu = CreateFrame("Frame", "NDui_EasyMenu", UIParent, "UIDropDownMenuTemplate")

	function B:CreateLine(isHorizontal)
		if self.Line then return end

		local w, h = self:GetSize()
		local Line = self:CreateTexture(nil, "ARTWORK")
		Line:SetColorTexture(1, 1, 1, .5)
		Line:ClearAllPoints()

		if isHorizontal then
			Line:SetSize(w*.9, C.mult)
		else
			Line:SetSize(C.mult, h*.9)
		end

		self.Line = Line

		return Line
	end

	function B:CreateGlowFrame(size)
		local frame = CreateFrame("Frame", nil, self)
		frame:Point("CENTER")
		frame:SetSize(size + 8, size + 8)

		return frame
	end

	function B:TogglePanel()
		if self:IsShown() then
			self:Hide()
		else
			self:Show()
		end
	end
end

-- GUI Function
do
	-- GameTooltip
	function B:HideTooltip()
		if self and self.bgTex then
			B.Tex_OnLeave(self)
		end

		GameTooltip:Hide()
	end

	local function Tooltip_OnEnter(self)
		GameTooltip:SetOwner(self, self.anchor)
		GameTooltip:ClearLines()
		if self.title then
			GameTooltip:AddLine(self.title)
		end
		if tonumber(self.tooltip) then
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

		if self and self.bgTex then
			B.Tex_OnEnter(self)
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

	-- PixelIcon
	function B:PixelIcon(texture, highlight)
		local icbg = B.CreateBDFrame(self)

		local Icon = self:CreateTexture(nil, "ARTWORK")
		Icon:SetTexCoord(tL, tR, tT, tB)
		Icon:SetInside(icbg)
		if texture then
			local atlas = strmatch(texture, "Atlas:(.+)$")
			if atlas then
				Icon:SetAtlas(atlas)
			else
				Icon:SetTexture(texture)
			end
		end
		if highlight and type(highlight) == "boolean" then
			self:EnableMouse(true)

			local HL = self:CreateTexture(nil, "HIGHLIGHT")
			HL:SetColorTexture(1, 1, 1, .25)
			HL:SetInside(icbg)

			self.HL = HL
		end

		self.icbg = icbg
		self.Icon = Icon
	end

	-- AuraIcon
	function B:AuraIcon()
		local CD = CreateFrame("Cooldown", nil, self, "CooldownFrameTemplate")
		CD:SetInside()
		CD:SetReverse(true)
		self.CD = CD

		B.PixelIcon(self, nil, true)
	end

	-- FontString
	function B:ReskinText(r, g, b, a)
		self:SetTextColor(r, g, b, a or 1)

		if self.SetShadowColor then
			self:SetShadowColor(0, 0, 0, 0)
		end
	end

	function B:ReskinFont(size)
		local oldSize = select(2, self:GetFont())
		size = size or oldSize

		local fontSize = size*C.db["Skins"]["FontScale"]
		self:SetFont(DB.Font[1], fontSize, DB.Font[3])
		self:SetShadowColor(0, 0, 0, 0)
	end

	function B:CreateFS(size, text, color, anchor, x, y)
		local fs = self:CreateFontString(nil, "OVERLAY")
		fs:SetFont(DB.Font[1], size, DB.Font[3])
		fs:SetText(text)
		fs:SetWordWrap(false)
		fs:SetShadowColor(0, 0, 0, 0)
		if color and type(color) == "boolean" then
			fs:SetTextColor(cr, cg, cb)
		elseif color == "system" then
			fs:SetTextColor(1, .8, 0)
		end
		if anchor and x and y then
			fs:SetPoint(anchor, x, y)
		else
			fs:SetPoint("CENTER", 1, -.5)
		end

		return fs
	end

	-- StatusBar
	function B:CreateSB(spark, r, g, b)
		self:SetStatusBarTexture(DB.normTex)
		if r and g and b then
			self:SetStatusBarColor(r, g, b)
		else
			self:SetStatusBarColor(cr, cg, cb)
		end

		local bd = B.CreateBG(self, -C.mult, C.mult, C.mult, -C.mult)
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
			self.Spark:SetAlpha(C.alpha)
			self.Spark:ClearAllPoints()
			self.Spark:SetPoint("TOPLEFT", self:GetStatusBarTexture(), "TOPRIGHT", -10, 10)
			self.Spark:SetPoint("BOTTOMRIGHT", self:GetStatusBarTexture(), "BOTTOMRIGHT", 10, -10)
		end
	end

	-- Gear
	function B:CreateGear(name)
		local gear = CreateFrame("Button", name, self)
		gear:SetSize(24, 24)
		gear.Icon = gear:CreateTexture(nil, "ARTWORK")
		gear.Icon:SetAllPoints()
		gear.Icon:SetTexture(DB.gearTex)
		gear.Icon:SetTexCoord(0, .5, 0, .5)
		gear:SetHighlightTexture(DB.gearTex)
		gear:GetHighlightTexture():SetTexCoord(0, .5, 0, .5)

		return gear
	end

	-- HelpInfo
	function B:CreateHelpInfo(tooltip)
		local help = CreateFrame("Button", nil, self)
		help:SetSize(40, 40)
		help.Icon = help:CreateTexture(nil, "ARTWORK")
		help.Icon:SetAllPoints()
		help.Icon:SetTexture(616343)
		help:SetHighlightTexture(616343)
		if tooltip then
			help.title = L["Tips"]
			B.AddTooltip(help, "ANCHOR_BOTTOMLEFT", tooltip, "info")
		end

		return help
	end

	-- HelpTip
	function B.HelpInfoAcknowledge(callbackArg)
		NDuiADB["Help"][callbackArg] = true
	end

	-- WaterMark
	function B:CreateWaterMark()
		local logo = self:CreateTexture(nil, "BACKGROUND")
		logo:SetPoint("BOTTOMRIGHT", 10, 0)
		logo:SetTexture(DB.logoTex)
		logo:SetTexCoord(0, 1, 0, .75)
		logo:SetSize(200, 75)
		logo:SetAlpha(.25)
	end

	-- Button
	function B:CreateButton(width, height, text, fontSize)
		local bu = CreateFrame("Button", nil, self, "BackdropTemplate")
		bu:SetSize(width, height)
		if type(text) == "boolean" then
			B.PixelIcon(bu, fontSize, true)
		else
			B.ReskinButton(bu)
			bu.text = B.CreateFS(bu, fontSize or 14, text, true)
		end

		return bu
	end

	-- CheckBox
	function B:CreateCheckBox()
		local cb = CreateFrame("CheckButton", nil, self, "InterfaceOptionsCheckButtonTemplate")
		cb:SetScript("OnClick", nil)
		B.ReskinCheck(cb)

		cb.Type = "CheckBox"
		return cb
	end

	-- EditBox
	local function editBoxClearFocus(self)
		self:ClearFocus()
	end

	function B:CreateEditBox(width, height)
		local eb = CreateFrame("EditBox", nil, self)
		eb:SetSize(width, height)
		eb:SetAutoFocus(false)
		eb:SetTextInsets(5, 5, 0, 0)
		eb:SetFont(DB.Font[1], DB.Font[2]+2, DB.Font[3])
		eb:SetShadowColor(0, 0, 0, 0)
		eb:SetScript("OnEscapePressed", editBoxClearFocus)
		eb:SetScript("OnEnterPressed", editBoxClearFocus)

		B.CreateBDFrame(eb)

		eb.Type = "EditBox"
		return eb
	end

	-- DropDown
	local function optOnClick(self)
		PlaySound(SOUNDKIT.GS_TITLE_OPTION_OK)
		local opt = self.__owner.options
		for i = 1, #opt do
			if self == opt[i] then
				opt[i]:SetBackdropColor(cr, cg, cb, .5)
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
		self:SetBackdropColor(1, 1, 1, .5)
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
		local dd = CreateFrame("Frame", nil, self, "BackdropTemplate")
		dd:SetSize(width, height)
		dd.bg = B.CreateBDFrame(dd)
		dd.bg:SetBackdropBorderColor(1, 1, 1)
		dd.Text = B.CreateFS(dd, 14, "", false, "LEFT", 5, 0)
		dd.Text:SetPoint("RIGHT", -5, 0)
		dd.options = {}

		local bu = CreateFrame("Button", nil, dd)
		bu:SetPoint("RIGHT", -5, 0)
		B.ReskinArrow(bu, "down")

		local list = CreateFrame("Frame", nil, dd, "BackdropTemplate")
		B.CreateBD(list, 1)
		B.CreateSD(list)
		list:ClearAllPoints()
		list:SetPoint("TOP", dd, "BOTTOM", 0, -2)
		list:SetBackdropBorderColor(1, 1, 1)
		list:Hide()

		bu.__list = list
		bu:SetScript("OnShow", buttonOnShow)
		bu:SetScript("OnClick", buttonOnClick)
		dd.button = bu

		local opt, index = {}, 0
		for i, j in pairs(data) do
			opt[i] = CreateFrame("Button", nil, list, "BackdropTemplate")
			opt[i]:ClearAllPoints()
			opt[i]:SetPoint("TOPLEFT", 4, -4 - (i-1)*(height+2))
			opt[i]:SetSize(width - 8, height)
			B.CreateBD(opt[i], 0)
			B.CreateSD(opt[i])
			B.CreateGT(opt[i])

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

	-- ColorSwatch
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

	local function resetColorPicker(swatch)
		local defaultColor = swatch.__default
		if defaultColor then
			ColorPickerFrame:SetColorRGB(defaultColor.r, defaultColor.g, defaultColor.b)
		end
	end

	local function GetSwatchTexColor(tex)
		local r, g, b = tex:GetVertexColor()
		r = B:Round(r, 2)
		g = B:Round(g, 2)
		b = B:Round(b, 2)

		return r, g, b
	end

	function B:CreateColorSwatch(name, color)
		color = color or {r=1, g=1, b=1}

		local swatch = CreateFrame("Button", nil, self)
		swatch:SetSize(18, 18)
		swatch.text = B.CreateFS(swatch, 14, name, false, "LEFT", 26, 0)

		local bg = B.CreateBDFrame(swatch)
		local tex = swatch:CreateTexture()
		tex:SetInside(bg)
		tex:SetTexture(DB.bgTex)
		tex:SetVertexColor(color.r, color.g, color.b, color.a)
		tex.GetColor = GetSwatchTexColor

		swatch.tex = tex
		swatch.color = color
		swatch:SetScript("OnClick", openColorPicker)
		swatch:SetScript("OnDoubleClick", resetColorPicker)

		return swatch
	end

	-- Slider
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

	local function resetSliderValue(self)
		local slider = self.__owner
		if slider.__default then
			slider:SetValue(slider.__default)
		end
	end

	function B:CreateSlider(name, minValue, maxValue, step, x, y, width)
		local slider = CreateFrame("Slider", nil, self, "OptionsSliderTemplate")
		slider:ClearAllPoints()
		slider:SetPoint("TOPLEFT", x, y)
		slider:SetWidth(width or 200)
		slider:SetMinMaxValues(minValue, maxValue)
		slider:SetValueStep(step)
		slider:SetObeyStepOnDrag(true)
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
		slider.Text:SetShadowColor(0, 0, 0, 0)

		slider.value = B.CreateEditBox(slider, 50, 20)
		slider.value:ClearAllPoints()
		slider.value:SetPoint("TOP", slider, "BOTTOM")
		slider.value:SetJustifyH("CENTER")
		slider.value.__owner = slider
		slider.value:SetScript("OnEnterPressed", updateSliderEditBox)

		slider.clicker = CreateFrame("Button", nil, slider)
		slider.clicker:SetAllPoints(slider.Text)
		slider.clicker.__owner = slider
		slider.clicker:SetScript("OnDoubleClick", resetSliderValue)

		return slider
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