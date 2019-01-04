-- [[ Core ]]
local addonName, ns = ...

ns[1] = {} -- F, functions
ns[2] = {} -- C, constants/config
_G[addonName] = ns

AuroraConfig = {}

local F, C = unpack(ns)

-- [[ Constants and settings ]]

local mediaPath = "Interface\\AddOns\\AuroraClassic\\media\\"

C.media = {
	["arrowDown"] = mediaPath.."arrow-down-active",
	["arrowLeft"] = mediaPath.."arrow-left-active",
	["arrowRight"] = mediaPath.."arrow-right-active",
	["arrowUp"] = mediaPath.."arrow-up-active",
	["bdTex"] = "Interface\\ChatFrame\\ChatFrameBackground",
	["bgTex"] = mediaPath.."bgTex",
	["checked"] = mediaPath.."checked",
	["font"] = STANDARD_TEXT_FONT,
	["glowTex"] = mediaPath.."glowTex",
	["gradientTex"] = mediaPath.."gradientTex",
	["normTex"] = "Interface\\TARGETINGFRAME\\UI-TargetingFrame-BarFill",
	["pushed"] = mediaPath.."pushed",
	["roleIcons"] = mediaPath.."UI-LFG-ICON-ROLES",
}

C.defaults = {
	["alpha"] = 0.5,
	["bags"] = false,
	["bubbleColor"] = false,
	["buttonGradientColour"] = {.3, .3, .3, .3},
	["buttonSolidColour"] = {.2, .2, .2, .6},
	["chatBubbles"] = true,
	["customColour"] = {r = .5, g = .5, b = .5},
	["fontScale"] = 1,
	["loot"] = false,
	["objectiveTracker"] = true,
	["reskinFont"] = true,
	["shadow"] = true,
	["tooltips"] = false,
	["useButtonGradientColour"] = true,
	["useCustomColour"] = false,
}

C.frames = {}

-- [[ Functions ]]

local useButtonGradientColour
local _, class = UnitClass("player")
C.classcolours = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
local cr, cg, cb = C.classcolours[class].r, C.classcolours[class].g, C.classcolours[class].b

local function SetupPixelFix()
	local screenHeight = select(2, GetPhysicalScreenSize())
	local scale = UIParent:GetScale()
	scale = tonumber(floor(scale*100 + .5)/100)
	C.mult = 768/screenHeight/scale
	if screenHeight > 1080 then C.mult = C.mult*2 end
end

function F:dummy()
end

local function CreateTex(f)
	if f.Tex then return end

	f.Tex = f:CreateTexture(nil, "BACKGROUND", nil, 1)
	f.Tex:SetAllPoints()
	f.Tex:SetTexture(C.media.bgTex, true, true)
	f.Tex:SetHorizTile(true)
	f.Tex:SetVertTile(true)
	f.Tex:SetBlendMode("ADD")
end

function F:CreateSD()
	if not AuroraConfig.shadow then return end
	if self.Shadow then return end

	local Pmult, Smult = C.mult*1.5, C.mult*2

	local lvl = self:GetFrameLevel()
	self.Shadow = CreateFrame("Frame", nil, self)
	self.Shadow:SetPoint("TOPLEFT", -Pmult, Pmult)
	self.Shadow:SetPoint("BOTTOMRIGHT", Pmult, -Pmult)
	self.Shadow:SetBackdrop({edgeFile = C.media.glowTex, edgeSize = Smult})
	self.Shadow:SetBackdropBorderColor(0, 0, 0)
	self.Shadow:SetFrameLevel(lvl == 0 and 1 or lvl - 1)
	CreateTex(self)

	return self.Shadow
end

function F:CreateBD(a)
	self:SetBackdrop({bgFile = C.media.bdTex, edgeFile = C.media.bdTex, edgeSize = C.mult})
	self:SetBackdropColor(0, 0, 0, a or AuroraConfig.alpha)
	self:SetBackdropBorderColor(0, 0, 0)

	if not a then tinsert(C.frames, self) end
end

function F:CreateBG()
	local f = self
	if self:GetObjectType() == "Texture" then f = self:GetParent() end

	local bg = f:CreateTexture(nil, "BACKGROUND")
	bg:SetPoint("TOPLEFT", self, -C.mult, C.mult)
	bg:SetPoint("BOTTOMRIGHT", self, C.mult, -C.mult)
	bg:SetTexture(C.media.bdTex)
	bg:SetVertexColor(0, 0, 0)

	return bg
end

-- we assign these after loading variables for caching
-- otherwise we call an extra unpack() every time
local buttonR, buttonG, buttonB, buttonA

function F:CreateGradient()
	local tex = self:CreateTexture(nil, "BORDER")
	tex:SetPoint("TOPLEFT", C.mult, -C.mult)
	tex:SetPoint("BOTTOMRIGHT", -C.mult, C.mult)
	tex:SetTexture(useButtonGradientColour and C.media.gradientTex or C.media.bdTex)
	tex:SetVertexColor(buttonR, buttonG, buttonB, buttonA)

	return tex
end

local function colourButton(self)
	if not self:IsEnabled() then return end

	if useButtonGradientColour then
		self:SetBackdropColor(cr, cg, cb, .25)
	else
		self.bgTex:SetVertexColor(r / 4, g / 4, b / 4)
	end

	self:SetBackdropBorderColor(cr, cg, cb)
end

local function clearButton(self)
	if useButtonGradientColour then
		self:SetBackdropColor(0, 0, 0, 0)
	else
		self.bgTex:SetVertexColor(buttonR, buttonG, buttonB, buttonA)
	end

	self:SetBackdropBorderColor(0, 0, 0)
end

function F:Reskin(noHighlight)
	F.CleanTextures(self)

	F.CreateBD(self, 0)
	F.CreateSD(self)

	self.bgTex = F.CreateGradient(self)

	if not noHighlight then
		self:HookScript("OnEnter", colourButton)
		self:HookScript("OnLeave", clearButton)
	end
end

function F:ReskinTab()
	self:DisableDrawLayer("BACKGROUND")

	local lvl = self:GetFrameLevel()
	local bg = F.CreateBDFrame(self)
	bg:SetPoint("TOPLEFT", 8, -3)
	bg:SetPoint("BOTTOMRIGHT", -8, 0)
	bg:SetFrameLevel(lvl == 0 and 1 or lvl - 1)

	F.ReskinTexture(self, true, bg)
end

local function textureOnEnter(self)
	if self:IsEnabled() then
		if self.pixels then
			for _, pixel in pairs(self.pixels) do
				pixel:SetVertexColor(cr, cg, cb)
			end
		else
			self.bgTex:SetVertexColor(cr, cg, cb)
		end
	end
end
F.colourArrow = textureOnEnter

local function textureOnLeave(self)
	if self.pixels then
		for _, pixel in pairs(self.pixels) do
			pixel:SetVertexColor(1, 1, 1)
		end
	else
		self.bgTex:SetVertexColor(1, 1, 1)
	end
end
F.clearArrow = textureOnLeave

local function scrollOnEnter(self)
	local name = self:GetName()
	local bu = (self.ThumbTexture or self.thumbTexture) or _G[name.."ThumbTexture"]
	if not bu then return end
	bu.bg:SetBackdropColor(cr, cg, cb, .25)
	bu.bg:SetBackdropBorderColor(cr, cg, cb)
end

local function scrollOnLeave(self)
	local name = self:GetName()
	local bu = (self.ThumbTexture or self.thumbTexture) or _G[name.."ThumbTexture"]
	if not bu then return end
	bu.bg:SetBackdropColor(0, 0, 0, 0)
	bu.bg:SetBackdropBorderColor(0, 0, 0)
end

function F:ReskinScroll()
	F.StripTextures(self, true)
	F.CleanTextures(self, true)

	local name = self:GetName()
	local bu = (self.ThumbTexture or self.thumbTexture) or _G[name.."ThumbTexture"]
	bu:SetAlpha(0)
	bu:SetWidth(17)

	bu.bg = F.CreateBDFrame(self, 0)
	bu.bg:SetPoint("TOPLEFT", bu, 0, -3)
	bu.bg:SetPoint("BOTTOMRIGHT", bu, 0, 3)
	F.CreateGradient(bu.bg)

	local up, down = self:GetChildren()
	up:SetWidth(17)
	down:SetWidth(17)

	F.Reskin(up, true)
	F.Reskin(down, true)

	up:SetDisabledTexture(C.media.bdTex)
	local dis1 = up:GetDisabledTexture()
	dis1:SetVertexColor(0, 0, 0, .5)
	dis1:SetDrawLayer("OVERLAY")

	down:SetDisabledTexture(C.media.bdTex)
	local dis2 = down:GetDisabledTexture()
	dis2:SetVertexColor(0, 0, 0, .5)
	dis2:SetDrawLayer("OVERLAY")

	local uptex = up:CreateTexture(nil, "ARTWORK")
	uptex:SetTexture(C.media.arrowUp)
	uptex:SetSize(8, 8)
	uptex:SetPoint("CENTER")
	uptex:SetVertexColor(1, 1, 1)
	up.bgTex = uptex

	local downtex = down:CreateTexture(nil, "ARTWORK")
	downtex:SetTexture(C.media.arrowDown)
	downtex:SetSize(8, 8)
	downtex:SetPoint("CENTER")
	downtex:SetVertexColor(1, 1, 1)
	down.bgTex = downtex

	up:HookScript("OnEnter", textureOnEnter)
	up:HookScript("OnLeave", textureOnLeave)
	down:HookScript("OnEnter", textureOnEnter)
	down:HookScript("OnLeave", textureOnLeave)
	self:HookScript("OnEnter", scrollOnEnter)
	self:HookScript("OnLeave", scrollOnLeave)
end

function F:ReskinDropDown()
	F.StripTextures(self)
	F.CleanTextures(self, true)

	local name = self:GetName()
	local down = self.Button or _G[name.."Button"]

	down:SetSize(20, 20)
	down:ClearAllPoints()
	down:SetPoint("RIGHT", -18, 2)

	F.Reskin(down, true)

	down:SetDisabledTexture(C.media.bdTex)
	local dis = down:GetDisabledTexture()
	dis:SetVertexColor(0, 0, 0, .5)
	dis:SetDrawLayer("OVERLAY")
	dis:SetAllPoints()

	local tex = down:CreateTexture(nil, "ARTWORK")
	tex:SetTexture(C.media.arrowDown)
	tex:SetSize(8, 8)
	tex:SetPoint("CENTER")
	tex:SetVertexColor(1, 1, 1)
	down.bgTex = tex

	down:HookScript("OnEnter", textureOnEnter)
	down:HookScript("OnLeave", textureOnLeave)

	local lvl = self:GetFrameLevel()
	local bg = F.CreateBDFrame(self, 0)
	bg:SetPoint("TOPLEFT", 16, -4)
	bg:SetPoint("BOTTOMRIGHT", -18, 8)
	bg:SetFrameLevel(lvl == 0 and 1 or lvl - 1)
	F.CreateGradient(bg)
end

function F:ReskinClose(a1, p, a2, x, y)
	self:SetSize(17, 17)

	F.StripTextures(self, true)
	F.CleanTextures(self, true)

	if not a1 then
		self:SetPoint("TOPRIGHT", -6, -6)
	else
		self:ClearAllPoints()
		self:SetPoint(a1, p, a2, x, y)
	end

	F.CreateBD(self, 0)
	F.CreateSD(self)
	F.CreateGradient(self)

	self:SetDisabledTexture(C.media.bdTex)
	local dis = self:GetDisabledTexture()
	dis:SetVertexColor(0, 0, 0, .5)
	dis:SetDrawLayer("OVERLAY")
	dis:SetAllPoints()

	self.pixels = {}
	for i = 1, 2 do
		local tex = self:CreateTexture()
		tex:SetColorTexture(1, 1, 1)
		tex:SetSize(11, 2)
		tex:SetPoint("CENTER")
		tex:SetRotation(math.rad((i-1/2)*90))
		tinsert(self.pixels, tex)
	end

	self:HookScript("OnEnter", textureOnEnter)
	self:HookScript("OnLeave", textureOnLeave)
end

function F:ReskinInput(height, width)
	F.StripTextures(self, true)
	F.CleanTextures(self, true)

	local lvl = self:GetFrameLevel()
	local bg = F.CreateBDFrame(self, 0)
	bg:SetPoint("TOPLEFT", -2, 0)
	bg:SetPoint("BOTTOMRIGHT")
	bg:SetFrameLevel(lvl == 0 and 1 or lvl - 1)
	F.CreateGradient(bg)

	if height then self:SetHeight(height) end
	if width then self:SetWidth(width) end
end

function F:ReskinArrow(direction)
	self:SetSize(18, 18)

	F.StripTextures(self, true)
	F.Reskin(self, true)

	self:SetDisabledTexture(C.media.bdTex)
	local dis = self:GetDisabledTexture()
	dis:SetVertexColor(0, 0, 0, .25)
	dis:SetDrawLayer("OVERLAY")

	local tex = self:CreateTexture(nil, "ARTWORK")
	tex:SetTexture(mediaPath.."arrow-"..direction.."-active")
	tex:SetSize(8, 8)
	tex:SetPoint("CENTER")
	self.bgTex = tex

	self:HookScript("OnEnter", textureOnEnter)
	self:HookScript("OnLeave", textureOnLeave)
end

function F:ReskinCheck()
	F.CleanTextures(self, true)

	local ch = self:GetCheckedTexture()
	ch:SetDesaturated(true)
	ch:SetVertexColor(cr, cg, cb)

	local lvl = self:GetFrameLevel()
	local bg = F.CreateBDFrame(self, 0)
	bg:SetPoint("TOPLEFT", 4, -4)
	bg:SetPoint("BOTTOMRIGHT", -4, 4)
	bg:SetFrameLevel(lvl == 0 and 1 or lvl - 1)
	F.CreateGradient(bg)

	F.ReskinTexture(self, true, bg)
end

local function colourRadio(self)
	self.bg:SetBackdropBorderColor(cr, cg, cb)
end

local function clearRadio(self)
	self.bg:SetBackdropBorderColor(0, 0, 0)
end

function F:ReskinRadio()
	F.StripTextures(self, true)
	F.CleanTextures(self, true)

	self:SetCheckedTexture(C.media.bdTex)
	local ch = self:GetCheckedTexture()
	ch:SetPoint("TOPLEFT", 4, -4)
	ch:SetPoint("BOTTOMRIGHT", -4, 4)
	ch:SetVertexColor(cr, cg, cb, .75)

	local lvl = self:GetFrameLevel()
	local bg = F.CreateBDFrame(self, 0)
	bg:SetPoint("TOPLEFT", 3, -3)
	bg:SetPoint("BOTTOMRIGHT", -3, 3)
	bg:SetFrameLevel(lvl == 0 and 1 or lvl - 1)
	F.CreateGradient(bg)
	self.bg = bg

	self:HookScript("OnEnter", colourRadio)
	self:HookScript("OnLeave", clearRadio)
end

function F:ReskinSlider(verticle)
	self:SetBackdrop(nil)
	self.SetBackdrop = F.dummy

	local lvl = self:GetFrameLevel()
	local bg = F.CreateBDFrame(self, 0)
	bg:SetPoint("TOPLEFT", 14, -2)
	bg:SetPoint("BOTTOMRIGHT", -15, 3)
	bg:SetFrameStrata("BACKGROUND")
	bg:SetFrameLevel(lvl == 0 and 1 or lvl - 1)
	F.CreateGradient(bg)

	for i = 1, self:GetNumRegions() do
		local region = select(i, self:GetRegions())
		if region:GetObjectType() == "Texture" then
			region:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
			region:SetBlendMode("ADD")
			if verticle then region:SetRotation(math.rad(90)) end
			return
		end
	end
end

local function expandOnEnter(self)
	if self:IsEnabled() then
		self.bg:SetBackdropColor(cr, cg, cb, .25)
	end
end

local function expandOnLeave(self)
	self.bg:SetBackdropColor(0, 0, 0, .25)
end

local function SetupTexture(self, texture)
	if self.settingTexture then return end
	self.settingTexture = true
	self:SetNormalTexture("")

	if texture and texture ~= "" then
		if texture:find("Plus") then
			self.expTex:SetTexCoord(0, 0.4375, 0, 0.4375)
		elseif texture:find("Minus") then
			self.expTex:SetTexCoord(0.5625, 1, 0, 0.4375)
		end
		self.bg:Show()
	else
		self.bg:Hide()
	end
	self.settingTexture = nil
end

function F:ReskinExpandOrCollapse()
	F.StripTextures(self)
	F.CleanTextures(self, true)

	local bg = F.CreateBDFrame(self, .25)
	bg:ClearAllPoints()
	bg:SetSize(13, 13)
	bg:SetPoint("TOPLEFT", self:GetNormalTexture())
	F.CreateGradient(bg)
	self.bg = bg

	self.expTex = bg:CreateTexture(nil, "OVERLAY")
	self.expTex:SetSize(7, 7)
	self.expTex:SetPoint("CENTER")
	self.expTex:SetTexture("Interface\\Buttons\\UI-PlusMinus-Buttons")

	self:HookScript("OnEnter", expandOnEnter)
	self:HookScript("OnLeave", expandOnLeave)
	hooksecurefunc(self, "SetNormalTexture", SetupTexture)
end

function F:SetBD(x, y, x2, y2)
	local lvl = self:GetFrameLevel()
	local bg = F.CreateBDFrame(self)

	if x and y and x2 and y2 then
		bg:SetPoint("TOPLEFT", x, y)
		bg:SetPoint("BOTTOMRIGHT", x2, y2)
	end

	bg:SetFrameLevel(lvl == 0 and 1 or lvl - 1)
end

-- Disable function
F.HiddenFrame = CreateFrame("Frame")
F.HiddenFrame:Hide()

function F:HideObject()
	if self.UnregisterAllEvents then
		self:UnregisterAllEvents()
		self:SetParent(F.HiddenFrame)
	else
		self.Show = self.Hide
	end
	self:Hide()
end

function F:StripTextures(kill)
	for i = 1, self:GetNumRegions() do
		local region = select(i, self:GetRegions())
		if region and region:GetObjectType() == "Texture" then
			if kill and type(kill) == "boolean" then
				F.HideObject(region)
			elseif region:GetDrawLayer() == kill then
				region:SetTexture(nil)
			elseif kill and type(kill) == "string" and region:GetTexture() ~= kill then
				region:SetTexture("")
			else
				region:SetTexture("")
			end
		end
	end

	F.CleanInset(self)
end

function F:RemoveSlice()
	if self.NineSlice then
		for _, tex in next, self.NineSlice do
			if type(tex) == "table" then
				tex:SetTexture(nil)
				tex:Hide()
			end
		end
		self.NineSlice:Hide()
	end
end

function F:CleanInset()
	if self.Bg then self.Bg:Hide() end
	F.RemoveSlice(self)
end

function F:ReskinPortraitFrame(setBS)
	F.StripTextures(self, true)
	F.CleanTextures(self, true)

	local insetFrame = self.inset or self.Inset
	if insetFrame then F.StripTextures(insetFrame, true) end
	if self.portrait then self.portrait:SetAlpha(0) end

	if setBS then
		F.CreateBD(self)
		F.CreateSD(self)
	end

	local name = self:GetName()
	local closeButton = self.CloseButton or (name and _G[name.."CloseButton"])

	if closeButton then
		F.ReskinClose(closeButton)
	end
end

function F:CreateBDFrame(a)
	local frame = self
	if self:GetObjectType() == "Texture" then frame = self:GetParent() end
	local lvl = frame:GetFrameLevel()

	local bg = CreateFrame("Frame", nil, frame)
	bg:SetPoint("TOPLEFT", self, -C.mult, C.mult)
	bg:SetPoint("BOTTOMRIGHT", self, C.mult, -C.mult)
	bg:SetFrameLevel(lvl == 0 and 1 or lvl - 1)
	F.CreateBD(bg, a)
	F.CreateSD(bg)

	return bg
end

function F:ReskinColourSwatch()
	self:SetNormalTexture(C.media.bdTex)
	local nt = self:GetNormalTexture()
	nt:SetPoint("TOPLEFT", 3, -3)
	nt:SetPoint("BOTTOMRIGHT", -3, 3)

	local name = self:GetName()
	local bg = _G[name.."SwatchBg"]
	bg:SetColorTexture(0, 0, 0)
	bg:SetPoint("TOPLEFT", 2, -2)
	bg:SetPoint("BOTTOMRIGHT", -2, 2)
end

function F:ReskinFilterButton()
	F.StripTextures(self)
	F.Reskin(self)

	self.Text:SetPoint("CENTER")
	self.Icon:SetTexture(C.media.arrowRight)
	self.Icon:SetPoint("RIGHT", self, "RIGHT", -5, 0)
	self.Icon:SetSize(8, 8)
end

function F:ReskinNavBar()
	if self.navBarStyled then return end

	F.StripTextures(self, true)
	F.CleanTextures(self, true)

	local homeButton = self.homeButton
	local overflowButton = self.overflowButton

	self:GetRegions():Hide()
	self:DisableDrawLayer("BORDER")
	self.overlay:Hide()
	homeButton:GetRegions():Hide()
	homeButton.text:ClearAllPoints()
	homeButton.text:SetPoint("CENTER")
	F.Reskin(homeButton)
	F.Reskin(overflowButton, true)

	local tex = overflowButton:CreateTexture(nil, "ARTWORK")
	tex:SetTexture(C.media.arrowLeft)
	tex:SetSize(8, 8)
	tex:SetPoint("CENTER")
	overflowButton.bgTex = tex

	overflowButton:HookScript("OnEnter", textureOnEnter)
	overflowButton:HookScript("OnLeave", textureOnLeave)

	self.navBarStyled = true
end

function F:ReskinGarrisonPortrait()
	self.Portrait:ClearAllPoints()
	self.Portrait:SetPoint("TOPLEFT", 4, -4)
	self.PortraitRing:Hide()
	self.PortraitRingQuality:SetTexture("")
	if self.Highlight then self.Highlight:Hide() end

	self.LevelBorder:SetScale(.0001)
	self.Level:ClearAllPoints()
	self.Level:SetPoint("BOTTOM", self, 0, 12)

	local lvl = self:GetFrameLevel()
	self.squareBG = F.CreateBDFrame(self, 1)
	self.squareBG:SetFrameLevel(lvl == 0 and 1 or lvl - 1)
	self.squareBG:SetPoint("TOPLEFT", 3, -3)
	self.squareBG:SetPoint("BOTTOMRIGHT", -3, 11)

	if self.PortraitRingCover then
		self.PortraitRingCover:SetColorTexture(0, 0, 0)
		self.PortraitRingCover:SetAllPoints(self.squareBG)
	end

	if self.Empty then
		self.Empty:SetColorTexture(0, 0, 0)
		self.Empty:SetAllPoints(self.Portrait)
	end
end

function F:ReskinIcon(setBS)
	self:SetTexCoord(.08, .92, .08, .92)

	if setBS then
		return F.CreateBDFrame(self, .25)
	else
		return F.CreateBG(self)
	end
end

function F:ReskinMinMax()
	for _, name in next, {"MaximizeButton", "MinimizeButton"} do
		local button = self[name]
		if button then
			F.StripTextures(self, true)

			button:SetSize(17, 17)
			button:ClearAllPoints()
			button:SetPoint("CENTER", -3, 0)
			F.Reskin(button)

			button.pixels = {}

			local tex = button:CreateTexture()
			tex:SetColorTexture(1, 1, 1)
			tex:SetSize(11, 2)
			tex:SetPoint("CENTER")
			tex:SetRotation(math.rad(45))
			tinsert(button.pixels, tex)

			local hline = button:CreateTexture()
			hline:SetColorTexture(1, 1, 1)
			hline:SetSize(7, 2)
			tinsert(button.pixels, hline)
			local vline = button:CreateTexture()
			vline:SetColorTexture(1, 1, 1)
			vline:SetSize(2, 7)
			tinsert(button.pixels, vline)

			if name == "MaximizeButton" then
				hline:SetPoint("TOPRIGHT", -4, -4)
				vline:SetPoint("TOPRIGHT", -4, -4)
			else
				hline:SetPoint("BOTTOMLEFT", 4, 4)
				vline:SetPoint("BOTTOMLEFT", 4, 4)
			end

			button:SetScript("OnEnter", textureOnEnter)
			button:SetScript("OnLeave", textureOnLeave)
		end
	end
end

function F:AffixesSetup()
	for _, frame in ipairs(self.Affixes) do
		frame.Border:SetTexture(nil)
		frame.Portrait:SetTexture(nil)
		if not frame.bg then
			frame.bg = F.ReskinIcon(frame.Portrait, true)
		end

		if frame.info then
			frame.Portrait:SetTexture(CHALLENGE_MODE_EXTRA_AFFIX_INFO[frame.info.key].texture)
		elseif frame.affixID then
			local _, _, filedataid = C_ChallengeMode.GetAffixInfo(frame.affixID)
			frame.Portrait:SetTexture(filedataid)
		end
	end
end

function F:CleanTextures(noIcon)
	--if self.SetCheckedTexture then self:SetCheckedTexture("") end
	if self.SetDisabledTexture then self:SetDisabledTexture("") end
	if self.SetHighlightTexture then self:SetHighlightTexture("") end
	if self.SetNormalTexture then self:SetNormalTexture("") end
	if self.SetPushedTexture then self:SetPushedTexture("") end

	local name = self:GetName()

	local Left = self.Left or (name and _G[name.."Left"])
	if Left then Left:Hide() end
	local Right = self.Right or (name and _G[name.."Right"])
	if Right then Right:Hide() end
	local Top = self.Top or (name and _G[name.."Top"])
	if Top then Top:Hide() end
	local Bottom = self.Bottom or (name and _G[name.."Bottom"])
	if Bottom then Bottom:Hide() end
	local Middle = self.Middle or (name and (_G[name.."Middle"] or _G[name.."Mid"]))
	if Middle then Middle:Hide() end
	local TopLeft = self.TopLeft or (name and _G[name.."TopLeft"])
	if TopLeft then TopLeft:Hide() end
	local TopMiddle = self.TopMiddle or (name and (_G[name.."TopMiddle"] or _G[name.."TopMid"]))
	if TopMiddle then TopMiddle:Hide() end
	local TopRight = self.TopRight or (name and _G[name.."TopRight"])
	if TopRight then TopRight:Hide() end
	local MiddleLeft = self.MiddleLeft or (name and _G[name.."MiddleLeft"])
	if MiddleLeft then MiddleLeft:Hide() end
	local MiddleMiddle = self.MiddleMiddle or (name and (_G[name.."MiddleMiddle"] or _G[name.."MiddleMid"]))
	if MiddleMiddle then MiddleMiddle:Hide() end
	local MiddleRight = self.MiddleRight or (name and _G[name.."MiddleRight"])
	if MiddleRight then MiddleRight:Hide() end
	local BottomLeft = self.BottomLeft or (name and _G[name.."BottomLeft"])
	if BottomLeft then BottomLeft:Hide() end
	local BottomMiddle = self.BottomMiddle or (name and (_G[name.."BottomMiddle"] or _G[name.."BottomMid"]))
	if BottomMiddle then BottomMiddle:Hide() end
	local BottomRight = self.BottomRight or (name and _G[name.."BottomRight"])
	if BottomRight then BottomRight:Hide() end

	local track = self.Track or self.trackBG or self.Background or (name and (_G[name.."Track"] or _G[name.."BG"]))
	if track then track:Hide() end
	local top = self.ScrollBarTop or self.ScrollUpBorder
	if top then top:Hide() end
	local middle = self.ScrollBarMiddle or self.Border
	if middle then middle:Hide() end
	local bottom = self.ScrollBarBottom or self.ScrollDownBorder
	if bottom then bottom:Hide() end

	local bd = self.Border or self.border
	if bd then bd:Hide() end

	if noIcon then
		local ic = self.icon or self.Icon
		if ic then ic:Hide() end
	end
end

function F:ReskinTexture(classColor, relativeTo, isBorder)
	if not self then return end

	local r, g, b = 1, 1, 1
	if classColor then r, g, b = cr, cg, cb end

	local mult = C.mult
	if isBorder then mult = -C.mult end

	local tex
	if self.SetHighlightTexture then
		self:SetHighlightTexture(C.media.bdTex)
		tex = self:GetHighlightTexture()
	else
		tex = self
		tex:SetTexture(C.media.bdTex)
		if isBorder then
			tex.SetTexture = F.dummy
			tex:SetDrawLayer("BACKGROUND")
		end
	end

	if not isBorder then
		tex:SetColorTexture(r, g, b, .25)
	end

	tex:SetPoint("TOPLEFT", relativeTo, mult, -mult)
	tex:SetPoint("BOTTOMRIGHT", relativeTo, -mult, mult)
end

function F:ReskinStatusBar(classColor, stripTex)
	F.StripTextures(self, stripTex)
	F.CleanTextures(self, true)

	self:SetStatusBarTexture(C.media.normTex)
	if classColor then self:SetStatusBarColor(cr*.8, cg*.8, cb*.8) end

	local lvl = self:GetFrameLevel()
	local bg = F.CreateBDFrame(self, .25)
	bg:SetFrameLevel(lvl == 0 and 1 or lvl - 1)
end

function F:ReskinDecline()
	F.StripTextures(self, true)
	F.Reskin(self)

	local w = self:GetWidth()
	self.pixels = {}
	for i = 1, 2 do
		local tex = self:CreateTexture()
		tex:SetColorTexture(1, 0, 0)
		tex:SetSize(w*.75, 2)
		tex:SetPoint("CENTER")
		tex:SetRotation(math.rad((i-1/2)*90))
		tinsert(self.pixels, tex)
	end
end

-- [[ Variable and module handling ]]

C.themes = {}
C.themes["AuroraClassic"] = {}

-- [[ Initialize addon ]]

local Skin = CreateFrame("Frame")
Skin:RegisterEvent("ADDON_LOADED")
Skin:SetScript("OnEvent", function(_, _, addon)
	if addon == "AuroraClassic" then
		SetupPixelFix()

		-- [[ Load Variables ]]

		-- remove deprecated or corrupt variables
		for key in pairs(AuroraConfig) do
			if C.defaults[key] == nil then
				AuroraConfig[key] = nil
			end
		end

		-- load or init variables
		for key, value in pairs(C.defaults) do
			if AuroraConfig[key] == nil then
				if type(value) == "table" then
					AuroraConfig[key] = {}
					for k in pairs(value) do
						AuroraConfig[key][k] = value[k]
					end
				else
					AuroraConfig[key] = value
				end
			end
		end

		useButtonGradientColour = AuroraConfig.useButtonGradientColour

		if useButtonGradientColour then
			buttonR, buttonG, buttonB, buttonA = unpack(C.defaults.buttonGradientColour)
		else
			buttonR, buttonG, buttonB, buttonA = unpack(C.defaults.buttonSolidColour)
		end

		if AuroraConfig.useCustomColour then
			cr, cg, cb = AuroraConfig.customColour.r, AuroraConfig.customColour.g, AuroraConfig.customColour.b
		end

		-- for modules
		C.r, C.g, C.b = cr, cg, cb
	end

	-- [[ Load modules ]]

	-- check if the addon loaded is supported by Aurora, and if it is, execute its module
	local addonModule = C.themes[addon]
	if addonModule then
		if type(addonModule) == "function" then
			addonModule()
		else
			for _, moduleFunc in pairs(addonModule) do
				moduleFunc()
			end
		end
	end
end)