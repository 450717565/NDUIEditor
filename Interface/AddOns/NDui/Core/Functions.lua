local _, ns = ...
local B, C, L, DB, F = unpack(ns)
local cr, cg, cb = DB.r, DB.g, DB.b

local type, pairs, tonumber, wipe, next = type, pairs, tonumber, table.wipe, next
local strmatch, gmatch, strfind, format, gsub = string.match, string.gmatch, string.find, string.format, string.gsub
local min, max, abs, floor = math.min, math.max, math.abs, math.floor

-- Color Text
function B.ColorText(p, GtR, val)
	local v = p / 100
	local r, g, b
	local per = format("%.1f%%", p)

	if GtR then
		r, g, b = v, 1 - v, 0
	else
		r, g, b = 1 - v, v, 0
	end

	if val then
		return B.HexRGB(r, g, b, val)
	else
		return B.HexRGB(r, g, b, per)
	end
end

-- Item Slot Info
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

-- Item Gems Info
function B.GetItemGems(item)
	local itemGems

	local stats = GetItemStats(item)
	for index in pairs(stats) do
		if strfind(index, "EMPTY_SOCKET_") then
			itemGems = "-"..L["Socket"]
		end
	end

	return itemGems
end

-- Create BGFrame
function B:CreateBGFrame(type, alpha, offset)
	local bg = B.CreateBG(self, offset)

	if type == "tex" then
		B.SetBackground(bg, alpha)
	elseif type == "notex" then
		B.CreateBD(bg, alpha)
		B.CreateSD(bg)
	else
		B.CreateSD(bg)
	end
	self.Shadow = bg.Shadow

	return bg
end

-- Gradient Frame
function B:CreateGF(w, h, o, r, g, b, a1, a2)
	self:SetSize(w, h)
	self:SetFrameStrata("BACKGROUND")
	local gf = self:CreateTexture(nil, "BACKGROUND")
	gf:SetAllPoints()
	gf:SetTexture(DB.normTex)
	gf:SetGradientAlpha(o, r, g, b, a1, r, g, b, a2)
end

-- Create Backdrop
function B:CreateBD(a)
	self:SetBackdrop({bgFile = DB.bdTex, edgeFile = DB.bdTex, edgeSize = C.mult})
	self:SetBackdropColor(0, 0, 0, a or .5)
	self:SetBackdropBorderColor(0, 0, 0, 1)
end

-- Create Shadow
function B:CreateSD(m, s)
	if self.Shadow then return end

	local frame = self
	if self:GetObjectType() == "Texture" then frame = self:GetParent() end
	local lvl = frame:GetFrameLevel()
	if not m then m, s = C.mult*1.5, C.mult*2.5 end

	local Shadow = CreateFrame("Frame", nil, frame)
	Shadow:ClearAllPoints()
	Shadow:SetPoint("TOPLEFT", self, -m, m)
	Shadow:SetPoint("BOTTOMRIGHT", self, m, -m)
	Shadow:SetBackdrop({edgeFile = DB.glowTex, edgeSize = s})
	Shadow:SetBackdropBorderColor(0, 0, 0, 1)
	Shadow:SetFrameLevel(lvl == 0 and 1 or lvl - 1)
	self.Shadow = Shadow

	return Shadow
end

-- Create Background
function B:CreateBG(offset)
	local frame = self
	if self:GetObjectType() == "Texture" then frame = self:GetParent() end
	offset = offset or C.mult
	local lvl = frame:GetFrameLevel()

	local bg = CreateFrame("Frame", nil, frame)
	bg:ClearAllPoints()
	bg:SetPoint("TOPLEFT", self, -offset, offset)
	bg:SetPoint("BOTTOMRIGHT", self, offset, -offset)
	bg:SetFrameLevel(lvl == 0 and 1 or lvl - 1)

	return bg
end

-- Create Skin
function B:CreateTex()
	if self.Tex then return end

	local frame = self
	if self:GetObjectType() == "Texture" then frame = self:GetParent() end

	local Tex = frame:CreateTexture(nil, "BACKGROUND", nil, 1)
	Tex:SetTexture(DB.bgTex, true, true)
	Tex:SetAllPoints(self)
	Tex:SetBlendMode("ADD")
	Tex:SetHorizTile(true)
	Tex:SetVertTile(true)
	self.Tex = Tex

	return Tex
end

function B:SetBackground(a)
	if F then
		F.CreateBD(self, a)
		F.CreateSD(self)
	else
		B.CreateBD(self, a)
		B.CreateSD(self)
		B.CreateTex(self)
	end
end

-- Frame Text
function B:CreateFS(size, text, classcolor, anchor, x, y)
	local fs = self:CreateFontString(nil, "OVERLAY")
	fs:SetFont(DB.Font[1], size, DB.Font[3])
	fs:SetText(text)
	fs:SetWordWrap(false)
	fs:ClearAllPoints()
	if classcolor and type(classcolor) == "boolean" then
		fs:SetTextColor(cr, cg, cb)
	elseif classcolor == "system" then
		fs:SetTextColor(1, .8, 0)
	end
	if anchor and x and y then
		fs:SetPoint(anchor, x, y)
	else
		fs:SetPoint("CENTER", 1, 0)
	end

	return fs
end

-- GameTooltip
function B:HideTooltip()
	if self.isButton then
		self:SetBackdropBorderColor(0, 0, 0, 1)
	end
	GameTooltip:Hide()
end

local function tooltipOnEnter(self)
	if self.isButton then
		self:SetBackdropBorderColor(cr, cg, cb, 1)
	end
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
	GameTooltip:Show()
end

function B:AddTooltip(anchor, tooltip, color, isButton)
	self.anchor = anchor
	self.tooltip = tooltip
	self.color = color
	self.isButton = isButton
	self:SetScript("OnEnter", tooltipOnEnter)
	self:SetScript("OnLeave", B.HideTooltip)
end

-- Button Color
function B:CreateBC(a)
	self:SetNormalTexture("")
	self:SetHighlightTexture("")
	self:SetPushedTexture("")
	self:SetDisabledTexture("")

	if self.Left then self.Left:SetAlpha(0) end
	if self.Middle then self.Middle:SetAlpha(0) end
	if self.Right then self.Right:SetAlpha(0) end
	if self.LeftSeparator then self.LeftSeparator:Hide() end
	if self.RightSeparator then self.RightSeparator:Hide() end

	B.CreateBD(self, a)
	B.CreateSD(self)

	self:SetScript("OnEnter", function()
		self:SetBackdropBorderColor(cr, cg, cb, 1)
	end)
	self:SetScript("OnLeave", function()
		self:SetBackdropBorderColor(0, 0, 0, 1)
	end)
	self:SetScript("OnMouseDown", function()
		self:SetBackdropColor(cr, cg, cb, a or .5)
	end)
	self:SetScript("OnMouseUp", function()
		self:SetBackdropColor(0, 0, 0, a or .5)
	end)
end

-- Checkbox
function B:CreateCB()
	self:SetNormalTexture("")
	self:SetPushedTexture("")

	local bd = B.CreateBGFrame(self, "notex", .25, -4)

	local ch = self:GetCheckedTexture()
	ch:SetDesaturated(true)
	ch:SetVertexColor(cr, cg, cb)

	self:SetHighlightTexture(DB.bdTex)
	local hl = self:GetHighlightTexture()
	hl:ClearAllPoints()
	hl:SetPoint("TOPLEFT", bd, C.mult, -C.mult)
	hl:SetPoint("BOTTOMRIGHT", bd, -C.mult, C.mult)
	hl:SetVertexColor(cr, cg, cb, .25)
end

-- Movable Frame
function B:CreateMF(parent, saved)
	local frame = parent or self
	frame:SetMovable(true)
	frame:SetUserPlaced(true)
	frame:SetClampedToScreen(true)

	self:EnableMouse(true)
	self:RegisterForDrag("LeftButton")
	self:SetScript("OnDragStart", function() frame:StartMoving() end)
	self:SetScript("OnDragStop", function()
		frame:StopMovingOrSizing()
		if not saved then return end
		local orig, _, tar, x, y = frame:GetPoint()
		NDuiDB["TempAnchor"][frame:GetName()] = {orig, "UIParent", tar, x, y}
	end)
end

function B:RestoreMF()
	local name = self:GetName()
	if name and NDuiDB["TempAnchor"][name] then
		self:ClearAllPoints()
		self:SetPoint(unpack(NDuiDB["TempAnchor"][name]))
	end
end

-- Icon Style
function B:PixelIcon(texture, highlight)
	B.CreateBD(self)
	B.CreateSD(self)
	self.Icon = self:CreateTexture(nil, "ARTWORK")
	self.Icon:ClearAllPoints()
	self.Icon:SetPoint("TOPLEFT", C.mult, -C.mult)
	self.Icon:SetPoint("BOTTOMRIGHT", -C.mult, C.mult)
	self.Icon:SetTexCoord(unpack(DB.TexCoord))
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
		self.HL:ClearAllPoints()
		self.HL:SetPoint("TOPLEFT", C.mult, -C.mult)
		self.HL:SetPoint("BOTTOMRIGHT", -C.mult, C.mult)
	end
end

function B:AuraIcon(highlight)
	self.CD = CreateFrame("Cooldown", nil, self, "CooldownFrameTemplate")
	self.CD:SetAllPoints()
	self.CD:SetReverse(true)
	B.PixelIcon(self, nil, highlight)
end

function B:CreateGear(name)
	local bu = CreateFrame("Button", name, self)
	bu:SetSize(22, 22)
	bu.Icon = bu:CreateTexture(nil, "ARTWORK")
	bu.Icon:SetAllPoints()
	bu.Icon:SetTexture(DB.gearTex)
	bu.Icon:SetTexCoord(0, .5, 0, .5)
	bu:SetHighlightTexture(DB.gearTex)
	bu:GetHighlightTexture():SetTexCoord(0, .5, 0, .5)

	return bu
end

-- Statusbar
function B:CreateSB(spark, r, g, b)
	self:SetStatusBarTexture(DB.normTex)
	if r and g and b then
		self:SetStatusBarColor(r, g, b)
	else
		self:SetStatusBarColor(cr, cg, cb)
	end

	B.CreateBGFrame(self)

	local bg = self:CreateTexture(nil, "BACKGROUND")
	bg:SetAllPoints()
	bg:SetTexture(DB.normTex)
	bg:SetVertexColor(0, 0, 0, .5)
	self.bg = bg

	if spark then
		self.Spark = self:CreateTexture(nil, "OVERLAY")
		self.Spark:SetTexture(DB.sparkTex)
		self.Spark:SetBlendMode("ADD")
		self.Spark:SetAlpha(.8)
		self.Spark:ClearAllPoints()
		self.Spark:SetPoint("TOPLEFT", self:GetStatusBarTexture(), "TOPRIGHT", -10, 10)
		self.Spark:SetPoint("BOTTOMRIGHT", self:GetStatusBarTexture(), "BOTTOMRIGHT", 10, -10)
	end

	return bg
end

-- Numberize
function B.Numb(n)
	if type(n) == "number" then
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
	else
		return n
	end
end

function B:Round(number)
	return floor(number + .5)
end

-- Color code
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

-- Disable function
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

function B:StripTextures(kill)
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
					region:SetTexture("")
				end
			else
				region:SetTexture("")
			end
		end
	end
end

function B:Dummy()
	return
end

function B:HideOption()
	self:SetAlpha(0)
	self:SetScale(.0001)
end

-- Smoothy
local smoothing = {}
local f = CreateFrame("Frame")
f:SetScript("OnUpdate", function()
	local limit = 30/GetFramerate()
	for bar, value in pairs(smoothing) do
		local cur = bar:GetValue()
		local new = cur + min((value-cur)/8, max(value-cur, limit))
		if new ~= new then
			new = value
		end
		bar:SetValue_(new)
		if cur == value or abs(new - value) < 1 then
			smoothing[bar] = nil
			bar:SetValue_(value)
		end
	end
end)

local function SetSmoothValue(self, value)
	if value ~= self:GetValue() or value == 0 then
		smoothing[self] = value
	else
		smoothing[self] = nil
	end
end

function B:SmoothBar()
	if not self.SetValue_ then
		self.SetValue_ = self.SetValue
		self.SetValue = SetSmoothValue
	end
end

-- Timer Format
local day, hour, minute = 86400, 3600, 60
function B.FormatTime(seconds)
	if seconds >= day then
		return format("%d"..DB.MyColor..L["Days"], seconds/day), seconds%day
	elseif seconds >= hour then
		return format("%d"..DB.MyColor..L["Hours"], seconds/hour), seconds%hour
	elseif seconds >= minute then
		return format("%d"..DB.MyColor..L["Minutes"], seconds/minute), seconds%minute
	elseif seconds > 10 then
		return format("|cffcccc33%d|r", seconds), seconds - floor(seconds)
	elseif seconds > 3 then
		return format("|cffffff00%d|r", seconds), seconds - floor(seconds)
	else
		if NDuiDB["Actionbar"]["DecimalCD"] then
			return format("|cffff0000%.1f|r", seconds), seconds - format("%.1f", seconds)
		else
			return format("|cffff0000%d|r", seconds + .5), seconds - floor(seconds)
		end
	end
end

function B.FormatTimeRaw(seconds)
	if seconds >= day then
		return format("%d"..DB.MyColor..L["Days"], seconds/day)
	elseif seconds >= hour then
		return format("%d"..DB.MyColor..L["Hours"], seconds/hour)
	elseif seconds >= minute then
		return format("%d"..DB.MyColor..L["Minutes"], seconds/minute)
	elseif seconds >= 3 then
		return floor(seconds)
	else
		return format("%.1f", seconds)
	end
end

function B:CooldownOnUpdate(elapsed, raw)
	local formatTime = raw and B.FormatTimeRaw or B.FormatTime
	self.elapsed = (self.elapsed or 0) + elapsed
	if self.elapsed >= .1 then
		local timeLeft = self.expiration - GetTime()
		if timeLeft > 0 then
			local text = formatTime(timeLeft)
			self.timer:SetText(text)
		else
			self:SetScript("OnUpdate", nil)
			self.timer:SetText(nil)
		end
		self.elapsed = 0
	end
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

-- Itemlevel
local iLvlDB = {}
local itemLevelString = gsub(ITEM_LEVEL, "%%d", "")
local enchantString = gsub(ENCHANTED_TOOLTIP_LINE, "%%s", "(.+)")
local essenceTextureID = 2975691
local essenceDescription = GetSpellDescription(277253)
local ITEM_SPELL_TRIGGER_ONEQUIP = ITEM_SPELL_TRIGGER_ONEQUIP
local tip = CreateFrame("GameTooltip", "NDui_iLvlTooltip", nil, "GameTooltipTemplate")

function B:InspectItemTextures()
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

function B:InspectItemInfo(text, slotInfo)
	local itemLevel = strfind(text, itemLevelString) and strmatch(text, "(%d+)%)?$")
	if itemLevel then
		slotInfo.iLvl = tonumber(itemLevel)
	end

	local enchant = strmatch(text, enchantString)
	if enchant then
		slotInfo.enchantText = enchant
	end
end

function B:CollectEssenceInfo(index, lineText, slotInfo)
	local step = 1
	local essence = slotInfo.essences[step]
	if essence and next(essence) and (strfind(lineText, ITEM_SPELL_TRIGGER_ONEQUIP, nil, true) and strfind(lineText, essenceDescription, nil, true)) then
		for i = 4, 2, -1 do
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
		slotInfo.gems, slotInfo.essences = B:InspectItemTextures()

		for i = 1, tip:NumLines() do
			local line = _G[tip:GetName().."TextLeft"..i]
			if line then
				local text = line:GetText() or ""
				B:InspectItemInfo(text, slotInfo)
				B:CollectEssenceInfo(i, text, slotInfo)
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

-- GUID to npcID
function B.GetNPCID(guid)
	local id = tonumber(strmatch((guid or ""), "%-(%d-)%-%x-$"))
	return id
end

-- GUI APIs
function B:CreateButton(width, height, text, fontSize)
	local bu = CreateFrame("Button", nil, self)
	bu:SetSize(width, height)
	if type(text) == "boolean" then
		B.PixelIcon(bu, fontSize, true)
	else
		B.CreateBC(bu, .25)
		bu.text = B.CreateFS(bu, fontSize or 14, text, true)
	end

	return bu
end

function B:CreateCheckBox()
	local cb = CreateFrame("CheckButton", nil, self, "InterfaceOptionsCheckButtonTemplate")
	B.CreateCB(cb)

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
	B.CreateBD(eb, .25)
	B.CreateSD(eb)
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
			opt[i]:SetBackdropColor(0, 0, 0, .25)
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
	self:SetBackdropColor(0, 0, 0)
end

local function buttonOnShow(self)
	self.__list:Hide()
end

local function buttonOnClick(self)
	PlaySound(SOUNDKIT.GS_TITLE_OPTION_OK)
	ToggleFrame(self.__list)
end

function B:CreateDropDown(width, height, data)
	local dd = CreateFrame("Frame", nil, self)
	dd:SetSize(width, height)
	B.CreateBD(dd)
	B.CreateSD(dd)
	dd:SetBackdropBorderColor(1, 1, 1, .5)
	dd.Text = B.CreateFS(dd, 14, "", false, "LEFT", 5, 0)
	dd.Text:SetPoint("RIGHT", -5, 0)
	dd.options = {}

	local bu = B.CreateGear(dd)
	bu:ClearAllPoints()
	bu:SetPoint("LEFT", dd, "RIGHT", -2, 0)
	local list = CreateFrame("Frame", nil, dd)
	list:ClearAllPoints()
	list:SetPoint("TOP", dd, "BOTTOM", 0, -2)
	B.CreateBD(list, 1)
	B.CreateSD(list)
	list:SetBackdropBorderColor(1, 1, 1, .5)
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
		B.CreateBD(opt[i], .25)
		B.CreateSD(opt[i])
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
	local swatch = CreateFrame("Button", nil, self)
	swatch:SetSize(18, 18)
	B.CreateBD(swatch, .25)
	B.CreateSD(swatch)
	swatch.text = B.CreateFS(swatch, 14, name, false, "LEFT", 26, 0)
	local tex = swatch:CreateTexture()
	tex:ClearAllPoints()
	tex:SetPoint("TOPLEFT", C.mult, -C.mult)
	tex:SetPoint("BOTTOMRIGHT", -C.mult, C.mult)
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
	slider:SetBackdrop(nil)
	slider.Thumb:SetTexture(DB.sparkTex)
	slider.Thumb:SetBlendMode("ADD")
	local bg = B.CreateBG(slider)
	bg:ClearAllPoints()
	bg:SetPoint("TOPLEFT", 14, -2)
	bg:SetPoint("BOTTOMRIGHT", -15, 3)
	B.CreateBD(bg, .25)
	B.CreateSD(bg)
	slider.value = B.CreateEditBox(slider, 50, 20)
	slider.value:ClearAllPoints()
	slider.value:SetPoint("TOP", slider, "BOTTOM")
	slider.value:SetJustifyH("CENTER")
	slider.value.__owner = slider
	slider.value:SetScript("OnEnterPressed", updateSliderEditBox)

	return slider
end