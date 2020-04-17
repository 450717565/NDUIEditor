local _, ns = ...
local B, C, L, DB = unpack(ns)
local cr, cg, cb = DB.r, DB.g, DB.b

--[[Other Functions]]

-- Color Text
function B.ColorText(p, fullRed, val)
	local v = p / 100
	local r, g, b
	local per = format("%.1f%%", p)

	if fullRed then
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
	if stats then
		for index in pairs(stats) do
			if strfind(index, "EMPTY_SOCKET_") then
				itemGems = "-"..L["Socket"]
			end
		end
	end

	return itemGems
end

-- Item Gems Corruption
function B.GetItemCorruption(item)
	local itemCorrupted

	local corrupted = IsCorruptedItem(item)
	if corrupted then
		itemCorrupted = "-"..ITEM_MOD_CORRUPTION
	end

	return itemCorrupted
end

--[[Reskin Functions]]

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

local direcIndex = {
	["up"] = DB.arrowUp,
	["down"] = DB.arrowDown,
	["left"] = DB.arrowLeft,
	["right"] = DB.arrowRight,
	["top"] = DB.arrowTop,
	["bottom"] = DB.arrowBottom,
}

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
				tabs:Point("LEFT", _G[tab..(i-1)], "RIGHT", -16, 0)
			end
		end
	end
end

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

function B:SetBDFrame(x, y, x2, y2)
	if x and y and x2 and y2 then
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

function B:CreateBG(frame, x, y, x2, y2)
	local bg = B.CreateBDFrame(self, 0)
	bg:ClearAllPoints()
	bg:Point("TOPLEFT", frame, "TOPRIGHT", x or 0, y or 0)
	bg:Point("BOTTOM", frame, "BOTTOM", 0, y2 or 0)
	bg:Point("RIGHT", self, "RIGHT", x2 or 0, 0)

	return bg
end

function B:CreateGA(w, h, d, r, g, b, a1, a2)
	self:SetSize(w, h)
	self:SetFrameStrata("BACKGROUND")

	local ga = self:CreateTexture(nil, "BACKGROUND")
	ga:SetAllPoints()
	ga:SetTexture(DB.normTex)
	ga:SetGradientAlpha(d, r, g, b, a1, r, g, b, a2)
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

function B:CreateGlowFrame(size)
	local frame = CreateFrame("Frame", nil, self)
	frame:Point("CENTER")
	frame:SetSize(size+8, size+8)

	return frame
end

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

function B:ReskinArrow(direction)
	self:SetSize(18, 18)

	B.StripTextures(self)

	B.ReskinButton(self)
	B.SetupArrowTex(self, direction)
	SetupDisTex(self)
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

function B:ReskinButton()
	B.CleanTextures(self)

	B.CreateBD(self, 0)
	B.CreateSD(self)
	B.CreateGF(self)

	SetupHook(self)
end

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

local function setupTex(self, texture)
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

	hooksecurefunc(self, "SetNormalTexture", setupTex)
end

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

function B:ReskinIcon(alpha)
	self:SetTexCoord(unpack(DB.TexCoord))
	local bg = B.CreateBDFrame(self, alpha or 0)

	return bg
end

function B:ReskinInput(height, width)
	B.CleanTextures(self)
	self:DisableDrawLayer("BACKGROUND")

	local bg = B.CreateBDFrame(self, 0)
	bg:ClearAllPoints()
	bg:Point("TOPLEFT", -3, 0)
	bg:Point("BOTTOMRIGHT", -3, 0)

	if height then self:SetHeight(height) end
	if width then self:SetWidth(width) end

	return bg
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

function B:ReskinRole(role)
	local frameName = self.GetName and self:GetName()
	for _, key in pairs({"background", "Cover", "cover"}) do
		local tex = self[key] or (frameName and _G[frameName..key])
		if tex then tex:SetTexture("") end
	end

	local texture = self.Icon or self.icon or self.Texture or self.texture or (self.SetTexture and self) or (self.GetNormalTexture and self:GetNormalTexture())
	if texture then
		texture:SetTexture(DB.roleTex)
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
	self:SetTexture(DB.roleTex)
	local bg = B.CreateBDFrame(self)

	return bg
end

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

		local bdTex = B.CreateBDFrame(thumb, 0)
		bdTex:ClearAllPoints()
		bdTex:Point("TOPLEFT", thumb, 0, -3)
		bdTex:Point("BOTTOMRIGHT", thumb, 0, 3)

		self.bdTex = bdTex
	end

	local up, down = self:GetChildren()
	B.ReskinArrow(up, "up")
	B.ReskinArrow(down, "down")

	up:SetHeight(16)
	down:SetHeight(16)

	SetupHook(self)
end

function B:ReskinSearchBox()
	B.StripTextures(self)
	B.CleanTextures(self)

	local bg = B.CreateBDFrame(self, 0, -C.mult)
	B.ReskinHighlight(self, bg, true)

	local icon = self.icon or self.Icon
	if icon then B.ReskinIcon(icon) end
end

function B:ReskinSlider(verticle)
	self:SetBackdrop(nil)
	B.StripTextures(self)

	local bg = B.CreateBDFrame(self, 0)
	bg:ClearAllPoints()
	bg:Point("TOPLEFT", 14, -2)
	bg:Point("BOTTOMRIGHT", -15, 3)

	local thumb = self:GetThumbTexture()
	thumb:SetTexture(DB.sparkTex)
	thumb:SetBlendMode("ADD")

	if verticle then thumb:SetRotation(math.rad(90)) end
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

function B:ReskinTab()
	B.StripTextures(self)
	B.CleanTextures(self)

	local bg = B.SetBDFrame(self, 8, -3, -8, 0)
	B.ReskinHighlight(self, bg, true)
end

-- [[ UI Reskin Functions ]]

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
	count:ClearAllPoints()
	count:SetPoint("BOTTOMRIGHT", icbg, "BOTTOMRIGHT", 0, 1)

	local stock = _G[frame.."ItemButtonStock"]
	stock:ClearAllPoints()
	stock:SetPoint("TOPRIGHT", icbg, "TOPRIGHT", 0, -1)

	local name = _G[frame.."Name"]
	name:SetWordWrap(false)
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
	B.SetBDFrame(self)

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

function B:ReskinSearchResult()
	if not self then return end

	local results = self.searchResults
	results:ClearAllPoints()
	results:Point("BOTTOMLEFT", self, "BOTTOMRIGHT", 20, 0)
	B.StripTextures(results)
	B.CleanTextures(results)
	B.SetBDFrame(results, -10, 0, 0, 0)

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

			local bubg = B.CreateBG(bu, icbg, 2, 2, -2, -2)
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
	local bg = B.CreateBDFrame(self, 0)

	local normal = self:GetNormalTexture()
	normal:SetTexCoord(.17, .83, .17, .83)

	local pushed = self:GetPushedTexture()
	pushed:SetTexCoord(.17, .83, .17, .83)

	local highlight = self:GetHighlightTexture()
	highlight:SetColorTexture(1, 1, 1, .25)
	highlight:SetInside(bg)
end