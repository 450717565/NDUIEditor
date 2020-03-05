local _, ns = ...
local B, C, L, DB = unpack(ns)
local cr, cg, cb = DB.r, DB.g, DB.b

local type, pairs, tonumber, wipe, next = type, pairs, tonumber, table.wipe, next
local strmatch, gmatch, strfind, format, gsub = string.match, string.gmatch, string.find, string.format, string.gsub
local min, max, floor = math.min, math.max, math.floor

function B.Scale(x)
	local mult = C.mult
	return mult * floor(x / mult + .5)
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
	GameTooltip:Hide()
end

local function tooltipOnEnter(self)
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

function B:AddTooltip(anchor, tooltip, color)
	self.anchor = anchor
	self.tooltip = tooltip
	self.color = color
	self:SetScript("OnEnter", tooltipOnEnter)
	self:SetScript("OnLeave", B.HideTooltip)
end

-- Icon Style
function B:PixelIcon(texture, highlight)
	B.SetBDFrame(self)
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

	local bd = B.CreateBDFrame(self, 0, nil, true)
	self.bd = bd

	local bg = self:CreateTexture(nil, "BACKGROUND")
	bg:SetAllPoints()
	bg:SetTexture(DB.normTex)
	bg:SetVertexColor(0, 0, 0, .25)
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
end

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

local blizzTextures = {
	"ArtOverlayFrame",
	"BG",
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
						region:SetTexture("")
					end
				else
					region:SetTexture("")
				end
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

-- Timer Format
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
			return format("|cffffff00%d|r"..DB.MyColor..L["Seconds"], s), s - floor(s)
		else
			return format("|cffffff00%d|r", s), s - floor(s)
		end
	else
		return format("|cffff0000%.1f|r", s), s - format("%.1f", s)
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
				B.InspectItemInfo(text, slotInfo)
				B.CollectEssenceInfo(i, text, slotInfo)
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

-- Add APIs
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

-- GUI APIs
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
			opt[i].bg:SetBackdropColor(1, .8, 0, .5)
			opt[i].selected = true
		else
			opt[i].bg:SetBackdropColor(0, 0, 0, 0)
			opt[i].selected = false
		end
	end
	self.__owner.Text:SetText(self.text)
	self:GetParent():Hide()
end

local function optOnEnter(self)
	if self.selected then return end
	self.bg:SetBackdropColor(1, 1, 1, .5)
end

local function optOnLeave(self)
	if self.selected then return end
	self.bg:SetBackdropColor(0, 0, 0, 0)
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
	local bg = B.CreateBDFrame(dd, 0)
	bg:SetBackdropBorderColor(1, 1, 1)
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
		opt[i].bg = B.CreateBDFrame(opt[i], 0)
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