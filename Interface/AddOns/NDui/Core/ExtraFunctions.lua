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
	for index in pairs(stats) do
		if strfind(index, "EMPTY_SOCKET_") then
			itemGems = "-"..L["Socket"]
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
	self:HookScript("OnEnter", B.Tex_OnEnter)
	self:HookScript("OnLeave", B.Tex_OnLeave)
	self:HookScript("OnMouseDown", B.Tex_OnMouseDown)
	self:HookScript("OnMouseUp", B.Tex_OnMouseUp)
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

		borders.TOPLEFT:Point("BOTTOMRIGHT", borders.CENTER, "TOPLEFT", 1, -1)
		borders.TOPRIGHT:Point("BOTTOMLEFT", borders.CENTER, "TOPRIGHT", -1, -1)
		borders.BOTTOMLEFT:Point("TOPRIGHT", borders.CENTER, "BOTTOMLEFT", 1, 1)
		borders.BOTTOMRIGHT:Point("TOPLEFT", borders.CENTER, "BOTTOMRIGHT", -1, 1)

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
	bgTex:SetPoint("CENTER")
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
				tabs:SetPoint("TOPLEFT", frameName, "BOTTOMLEFT", 15, 1)
			else
				tabs:SetPoint("LEFT", _G[tab..(i-1)], "RIGHT", -15, 0)
			end
		end
	end
end

function B:GetRoleTexCoord()
	if self == "TANK" then
		return 0.32/9.03, 2.04/9.03, 2.65/9.03, 4.30/9.03
	elseif self == "DPS" or self == "DAMAGER" then
		return 2.68/9.03, 4.40/9.03, 2.65/9.03, 4.34/9.03
	elseif self == "HEALER" then
		return 2.68/9.03, 4.40/9.03, 0.28/9.03, 1.98/9.03
	elseif self == "LEADER" then
		return 0.32/9.03, 2.04/9.03, 0.28/9.03, 1.98/9.03
	elseif self == "READY" then
		return 5.10/9.03, 6.76/9.03, 0.28/9.03, 1.98/9.03
	elseif self == "PENDING" then
		return 5.10/9.03, 6.76/9.03, 2.65/9.03, 4.34/9.03
	elseif self == "REFUSE" then
		return 2.68/9.03, 4.40/9.03, 5.02/9.03, 6.70/9.03
	end
end

function B:Tex_OnEnter()
	if self:IsEnabled() then
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
end

function B:Tex_OnLeave()
	if self:IsEnabled() then
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
end

function B:Tex_OnMouseDown()
	if self:IsEnabled() then
		if self.bdTex then
			self.bdTex:SetBackdropColor(cr, cg, cb, .25)
		else
			self:SetBackdropColor(cr, cg, cb, .25)
		end
	end
end

function B:Tex_OnMouseUp()
	if self:IsEnabled() then
		if self.bdTex then
			self.bdTex:SetBackdropColor(0, 0, 0, 0)
		else
			self:SetBackdropColor(0, 0, 0, 0)
		end
	end
end

function B:SetupTex()
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
	self:SetBackdrop(nil)

	B.SetupPixelBorders(self)
	B.SetBackdropColor(self, 0, 0, 0, alpha or NDuiDB["Skins"]["SkinAlpha"])
	B.SetBackdropBorderColor(self, 0, 0, 0, 1)
	B.SetupTex(self)

	if not alpha then tinsert(C.frames, self) end
end

function B:CreateBDFrame(alpha, offset, noGF)
	local frame = self
	if self:GetObjectType() == "Texture" then frame = self:GetParent() end

	local lvl = frame:GetFrameLevel()
	local bg = CreateFrame("Frame", nil, frame)
	bg:SetOutside(self, offset, offset)
	bg:SetFrameLevel(lvl == 0 and 1 or lvl - 1)

	B.CreateBD(bg, alpha)
	B.CreateSD(bg)

	if not noGF then
		B.CreateGF(bg)
	end

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

	local gTex = self:CreateTexture(nil, "BORDER")
	gTex:SetTexture(DB.bdTex)
	gTex:SetInside()
	if NDuiDB["Skins"]["FlatMode"] then
		gTex:SetVertexColor(.3, .3, .3, .3)
	else
		gTex:SetGradientAlpha("Vertical", 0, 0, 0, .6, .3, .3, .3, .3)
	end

	self.gTex = gTex
end

function B:CreateGlowFrame(size)
	local frame = CreateFrame("Frame", nil, self)
	frame:SetPoint("CENTER")
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

function B:CreateSD()
	if not NDuiDB["Skins"]["Shadow"] then return end
	if self.Shadow then return end

	local frame = self
	if self:GetObjectType() == "Texture" then frame = self:GetParent() end

	local lvl = frame:GetFrameLevel()
	local Shadow = CreateFrame("Frame", nil, frame)
	Shadow:SetOutside(self, 2, 2)
	Shadow:SetBackdrop({edgeFile = DB.glowTex, edgeSize = B.Scale(3)})
	Shadow:SetBackdropBorderColor(0, 0, 0, .5)
	Shadow:SetFrameLevel(lvl == 0 and 0 or lvl - 1)
	self.Shadow = Shadow
end

function B:SetBDFrame(x, y, x2, y2)
	if x and y and x2 and y2 then
		local bg = B.CreateBDFrame(self, nil, 0, true)
		bg:ClearAllPoints()
		bg:SetPoint("TOPLEFT", self, x, y)
		bg:SetPoint("BOTTOMRIGHT", self, x2, y2)

		return bg
	else
		B.CreateBD(self)
		B.CreateSD(self)
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

function B:ReskinButton(noHL)
	B.CleanTextures(self)

	B.CreateBD(self, 0)
	B.CreateSD(self)
	B.CreateGF(self)

	if not noHL then
		SetupHook(self)
	end
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

function B:ReskinClose(a1, p, a2, x, y)
	self:SetSize(18, 18)

	self:ClearAllPoints()
	if not a1 then
		self:SetPoint("TOPRIGHT", -6, -6)
	else
		self:SetPoint(a1, p, a2, x, y)
	end

	B.StripTextures(self)

	B.ReskinButton(self)
	SetupDisTex(self)

	self.pixels = {}
	for i = 1, 2 do
		local tex = self:CreateTexture()
		tex:SetColorTexture(1, 1, 1)
		tex:SetSize(11, 2)
		tex:ClearAllPoints()
		tex:SetPoint("CENTER")
		tex:SetRotation(math.rad((i-1/2)*90))
		tinsert(self.pixels, tex)
	end
end

function B:ReskinColorSwatch()
	self:SetNormalTexture(DB.bdTex)
	local nt = self:GetNormalTexture()
	nt:ClearAllPoints()
	nt:SetPoint("TOPLEFT", 2, -2)
	nt:SetPoint("BOTTOMRIGHT", -2, 2)

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
		tex:SetSize(w*.75, 2)
		tex:ClearAllPoints()
		tex:SetPoint("CENTER")
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
	button:SetPoint("RIGHT", -18, 2)

	B.ReskinArrow(button, "down")
	button:SetSize(20, 20)

	local bg = B.CreateBDFrame(self, 0)
	bg:ClearAllPoints()
	bg:SetPoint("TOPLEFT", self, "TOPLEFT", 16, -4)
	bg:SetPoint("BOTTOMRIGHT", button, "BOTTOMLEFT", -1, 0)

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
		if texture:find("Plus") then
			self.expTex:SetTexCoord(0, .4375, 0, .4375)
		elseif texture:find("Minus") then
			self.expTex:SetTexCoord(.5625, 1, 0, .4375)
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
	bdTex:SetSize(13, 13)
	bdTex:ClearAllPoints()
	bdTex:SetPoint("TOPLEFT", self:GetNormalTexture())
	self.bdTex = bdTex

	local expTex = bdTex:CreateTexture(nil, "OVERLAY")
	expTex:SetSize(7, 7)
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
	self.Icon:SetPoint("RIGHT", self, "RIGHT", -5, 0)
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

	local frameName = self.GetName and self:GetName()
	for _, key in pairs({"Header", "header"}) do
		local frameHeader = self[key] or (frameName and _G[frameName..key])
		if frameHeader then
			B.StripTextures(frameHeader)

			frameHeader:ClearAllPoints()
			frameHeader:SetPoint("TOP", 0, 5)
		end
	end
	for _, key in pairs({"Portrait", "portrait"}) do
		local framePortrait = self[key] or (frameName and _G[frameName..key])
		if framePortrait then framePortrait:SetAlpha(0) end
	end

	local closeButton = self.CloseButton or (frameName and _G[frameName.."CloseButton"])
	if closeButton then B.ReskinClose(closeButton) end

	local bg = B.CreateBDFrame(self, nil, 0, true)

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
	bg:SetPoint("TOPLEFT", -2, 0)
	bg:SetPoint("BOTTOMRIGHT")

	if height then self:SetHeight(height) end
	if width then self:SetWidth(width) end
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
			button:SetPoint("CENTER", -3, 0)

			button.pixels = {}

			local tex = button:CreateTexture()
			tex:SetColorTexture(1, 1, 1)
			tex:SetSize(11, 2)
			tex:ClearAllPoints()
			tex:SetPoint("CENTER")
			tex:SetRotation(math.rad(45))
			tinsert(button.pixels, tex)

			local hline = button:CreateTexture()
			hline:SetColorTexture(1, 1, 1)
			hline:SetSize(7, 2)
			hline:ClearAllPoints()
			tinsert(button.pixels, hline)

			local vline = button:CreateTexture()
			vline:SetColorTexture(1, 1, 1)
			vline:SetSize(2, 7)
			vline:ClearAllPoints()
			tinsert(button.pixels, vline)

			if name == "MaximizeButton" then
				hline:SetPoint("TOPRIGHT", -4, -4)
				vline:SetPoint("TOPRIGHT", -4, -4)
			else
				hline:SetPoint("BOTTOMLEFT", 4, 4)
				vline:SetPoint("BOTTOMLEFT", 4, 4)
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
		texture:SetTexture(DB.rolesTex)
		texture:SetTexCoord(B.GetRoleTexCoord(role))
	end

	local checkButton = self.checkButton or self.CheckButton or self.CheckBox
	if checkButton then
		checkButton:SetFrameLevel(self:GetFrameLevel() + 2)
		checkButton:ClearAllPoints()
		checkButton:SetPoint("BOTTOMLEFT", -2, -2)
		B.ReskinCheck(checkButton)
	end

	local shortageBorder = self.shortageBorder
	if shortageBorder then
		shortageBorder:SetTexture("")

		local icon = self.incentiveIcon
		icon.border:SetTexture("")
		icon.texture:ClearAllPoints()
		icon.texture:SetPoint("BOTTOMRIGHT", self, -3, 3)
		icon.texture:SetSize(14, 14)
		B.ReskinIcon(icon.texture)
	end

	self.bg = B.CreateBDFrame(self, 0)
end

function B:ReskinRoleIcon()
	self:SetTexture(DB.rolesTex)
	local bg = B.CreateBDFrame(self)

	return bg
end

function B:ReskinScroll()
	B.StripTextures(self)
	B.CleanTextures(self)

	local parent = self:GetParent()
	if parent then
		B.StripTextures(parent, true)
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
		bdTex:SetPoint("TOPLEFT", thumb, 0, -3)
		bdTex:SetPoint("BOTTOMRIGHT", thumb, 0, 3)

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
	B.ReskinTexture(self, bg, true)

	local icon = self.icon or self.Icon
	if icon then B.ReskinIcon(icon) end
end

function B:ReskinSlider(verticle)
	self:SetBackdrop(nil)
	B.StripTextures(self)

	local bg = B.CreateBDFrame(self, 0)
	bg:ClearAllPoints()
	bg:SetPoint("TOPLEFT", 14, -2)
	bg:SetPoint("BOTTOMRIGHT", -15, 3)
	bg:SetFrameStrata("BACKGROUND")

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
		self:SetStatusBarColor(cr, cg, cb, .8)
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
	B.ReskinTexture(self, bg, true)
end

function B:ReskinTexed(relativeTo)
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

	checked:SetAllPoints(relativeTo)
end

function B:ReskinTexture(relativeTo, classColor, isOutside)
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

	tex:SetColorTexture(r, g, b, .25)
	if isOutside then
		tex:SetOutside(relativeTo)
	else
		tex:SetInside(relativeTo)
	end
end

-- [[ Strip Functions ]]

local CleanTextures = {
	"_LeftSeparator",
	"_RightSeparator",
	"Background",
	"BG",
	"Bg",
	"BorderBottom",
	"BorderBottomLeft",
	"BorderBottomRight",
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
	for _, key in pairs(CleanTextures) do
		local cleanFrame = self[key] or (frameName and _G[frameName..key])
		if cleanFrame then
			cleanFrame:SetAlpha(0)
			cleanFrame:Hide()
		end
	end
end

-- [[ UI Reskin Functions ]]

function B.ReskinMerchantItem(index)
	local frame = "MerchantItem"..index

	local item = _G[frame]
	B.StripTextures(item)

	local button = _G[frame.."ItemButton"]
	B.StripTextures(button)

	local icbg = B.ReskinIcon(button.icon)
	B.ReskinTexture(button, icbg)
	B.ReskinBorder(button.IconBorder, icbg)

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
	bubg:SetPoint("TOPLEFT", ButtonFrame.MoneyFrameEdge, 2, 0)
	bubg:SetPoint("BOTTOMRIGHT", ButtonFrame.MoneyFrameEdge, 0, 2)

	if ButtonFrame.AzeriteRespecButton then B.ReskinButton(ButtonFrame.AzeriteRespecButton) end
	if ButtonFrame.ActionButton then B.ReskinButton(ButtonFrame.ActionButton) end
	if ButtonFrame.Currency then B.ReskinIcon(ButtonFrame.Currency.icon) end
end

function B:ReskinSearchResult()
	if not self then return end

	local results = self.searchResults
	results:ClearAllPoints()
	results:SetPoint("BOTTOMLEFT", self, "BOTTOMRIGHT", 20, 0)
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

			local bubg = B.CreateBDFrame(bu, 0)
			bubg:ClearAllPoints()
			bubg:SetPoint("TOPLEFT", icbg, "TOPRIGHT", 2, 2)
			bubg:SetPoint("BOTTOMRIGHT", -2, 3)
			B.ReskinTexture(bu, bubg, true)

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
	local normal = self:GetNormalTexture()
	normal:SetTexCoord(.17, .83, .17, .83)

	local pushed = self:GetPushedTexture()
	pushed:SetTexCoord(.17, .83, .17, .83)

	local highlight = self:GetHighlightTexture()
	highlight:SetColorTexture(1, 1, 1, .25)
	highlight:SetAllPoints()

	B.CreateBDFrame(self, 0)
end