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
	["chatBubbles"] = true,
	["customColour"] = {r = 1, g = 1, b = 1},
	["fontScale"] = 1,
	["loot"] = false,
	["objectiveTracker"] = true,
	["reskinFont"] = true,
	["shadow"] = true,
	["tooltips"] = false,
	["useCustomColour"] = false,
}

C.frames = {}
C.isNewPatch = GetBuildInfo() == "8.1.5"

-- [[ Database ]]

C.ClassColors = {}
local class = select(2, UnitClass("player"))
local colors = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
for class in pairs(colors) do
	C.ClassColors[class] = {}
	C.ClassColors[class].r = colors[class].r
	C.ClassColors[class].g = colors[class].g
	C.ClassColors[class].b = colors[class].b
	C.ClassColors[class].colorStr = colors[class].colorStr
end
local cr, cg, cb = C.ClassColors[class].r, C.ClassColors[class].g, C.ClassColors[class].b

local function SetupPixelFix()
	local screenHeight = select(2, GetPhysicalScreenSize())
	local scale = UIParent:GetScale()
	scale = tonumber(floor(scale*100 + .5)/100)
	C.mult = 768/screenHeight/scale
	if screenHeight > 1080 then C.mult = C.mult*2 end
end

function F:dummy()
end

-- [[ Functions ]]

function F:CreateBD(a)
	self:SetBackdrop({bgFile = C.media.bdTex, edgeFile = C.media.bdTex, edgeSize = C.mult})
	self:SetBackdropColor(0, 0, 0, a or AuroraConfig.alpha)
	self:SetBackdropBorderColor(0, 0, 0)

	if not a then tinsert(C.frames, self) end
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

local buttonR, buttonG, buttonB, buttonA
function F:CreateGradient()
	local tex = self:CreateTexture(nil, "BORDER")
	tex:SetPoint("TOPLEFT", self, C.mult, -C.mult)
	tex:SetPoint("BOTTOMRIGHT", self, -C.mult, C.mult)
	tex:SetTexture(C.media.gradientTex)
	tex:SetVertexColor(buttonR, buttonG, buttonB, buttonA)

	return tex
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
	self.Shadow:SetPoint("TOPLEFT", self, -Pmult, Pmult)
	self.Shadow:SetPoint("BOTTOMRIGHT", self, Pmult, -Pmult)
	self.Shadow:SetBackdrop({edgeFile = C.media.glowTex, edgeSize = Smult})
	self.Shadow:SetBackdropBorderColor(0, 0, 0)
	self.Shadow:SetFrameLevel(lvl == 0 and 1 or lvl - 1)
	CreateTex(self)

	return self.Shadow
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

function F:ReskinAffixes()
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
	if self:IsEnabled() then
		if self.pixels then
			for _, pixel in pairs(self.pixels) do
				pixel:SetVertexColor(1, 1, 1)
			end
		else
			self.bgTex:SetVertexColor(1, 1, 1)
		end
	end
end
F.clearArrow = textureOnLeave

function F:ReskinArrow(direction)
	self:SetSize(18, 18)

	F.StripTextures(self, true)
	F.ReskinButton(self, true)

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

local function buttonOnEnter(self)
	if self:IsEnabled() then
		self:SetBackdropBorderColor(cr, cg, cb, 1)
	end
end

local function buttonOnLeave(self)
	if self:IsEnabled() then
		self:SetBackdropBorderColor(0, 0, 0, 1)
	end
end

local function buttonOnMouseDown(self)
	if self:IsEnabled() then
		self:SetBackdropColor(cr, cg, cb, .25)
	end
end

local function buttonOnMouseUp(self)
	if self:IsEnabled() then
		self:SetBackdropColor(0, 0, 0, 0)
	end
end

function F:ReskinButton(noHighlight)
	F.CleanTextures(self)

	F.CreateBD(self, 0)
	F.CreateSD(self)
	F.CreateGradient(self)

	if not noHighlight then
		self:HookScript("OnEnter", buttonOnEnter)
		self:HookScript("OnLeave", buttonOnLeave)
		self:HookScript("OnMouseDown", buttonOnMouseDown)
		self:HookScript("OnMouseUp", buttonOnMouseUp)
	end
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

	F.ReskinTexture(self, bg, true)
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

function F:ReskinColourSwatch()
	self:SetNormalTexture(C.media.bdTex)
	local nt = self:GetNormalTexture()
	nt:SetPoint("TOPLEFT", 2, -2)
	nt:SetPoint("BOTTOMRIGHT", -2, 2)

	local frameName = self.GetName and self:GetName()
	local bg = frameName and _G[frameName.."SwatchBg"]
	bg:SetColorTexture(0, 0, 0)
	bg:SetPoint("TOPLEFT", nt, -C.mult, C.mult)
	bg:SetPoint("BOTTOMRIGHT", nt, C.mult, -C.mult)
end

function F:ReskinDecline()
	F.StripTextures(self, true)
	F.ReskinButton(self)

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

function F:ReskinDropDown()
	F.StripTextures(self)
	F.CleanTextures(self, true)

	local frameName = self.GetName and self:GetName()
	local down = self.Button or (frameName and _G[frameName.."Button"])

	down:SetSize(20, 20)
	down:ClearAllPoints()
	down:SetPoint("RIGHT", -18, 2)

	F.ReskinButton(down, true)

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

local function expandOnEnter(self)
	if self:IsEnabled() then
		self.bg:SetBackdropColor(cr, cg, cb, .25)
	end
end

local function expandOnLeave(self)
	if self:IsEnabled() then
		self.bg:SetBackdropColor(0, 0, 0, .25)
	end
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

function F:ReskinFilter()
	F.StripTextures(self)
	F.ReskinButton(self)

	self.Text:SetPoint("CENTER")
	self.Icon:SetTexture(C.media.arrowRight)
	self.Icon:SetPoint("RIGHT", self, "RIGHT", -5, 0)
	self.Icon:SetSize(8, 8)
end

function F:ReskinFrame(noKill)
	if not noKill then
		F.StripTextures(self, true)
		F.CleanTextures(self, true)
	end

	F.CreateBD(self)
	F.CreateSD(self)

	local frameName = self.GetName and self:GetName()

	local framePortrait = self.portrait or (frameName and _G[frameName.."Portrait"])
	if framePortrait then framePortrait:SetAlpha(0) end

	local closeButton = self.CloseButton or (frameName and _G[frameName.."CloseButton"])
	if closeButton then F.ReskinClose(closeButton) end
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

function F:ReskinMinMax()
	for _, name in next, {"MaximizeButton", "MinimizeButton"} do
		local button = self[name]
		if button then
			F.StripTextures(self, true)

			button:SetSize(17, 17)
			button:ClearAllPoints()
			button:SetPoint("CENTER", -3, 0)
			F.ReskinButton(button)

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
	F.ReskinButton(homeButton)
	F.ReskinButton(overflowButton, true)

	local tex = overflowButton:CreateTexture(nil, "ARTWORK")
	tex:SetTexture(C.media.arrowLeft)
	tex:SetSize(8, 8)
	tex:SetPoint("CENTER")
	overflowButton.bgTex = tex

	overflowButton:HookScript("OnEnter", textureOnEnter)
	overflowButton:HookScript("OnLeave", textureOnLeave)

	self.navBarStyled = true
end

local function radioOnEnter(self)
	if self:IsEnabled() then
		self.bg:SetBackdropBorderColor(cr, cg, cb)
	end
end

local function radioOnLeave(self)
	if self:IsEnabled() then
		self.bg:SetBackdropBorderColor(0, 0, 0)
	end
end

function F:ReskinRadio()
	F.StripTextures(self, true)
	F.CleanTextures(self, true)

	local lvl = self:GetFrameLevel()
	local bg = F.CreateBDFrame(self, 0)
	bg:SetPoint("TOPLEFT", 2, -2)
	bg:SetPoint("BOTTOMRIGHT", -2, 2)
	bg:SetFrameLevel(lvl == 0 and 1 or lvl - 1)
	F.CreateGradient(bg)

	self:SetCheckedTexture(C.media.bdTex)
	local ch = self:GetCheckedTexture()
	ch:SetPoint("TOPLEFT", bg, C.mult, -C.mult)
	ch:SetPoint("BOTTOMRIGHT", bg, -C.mult, C.mult)
	ch:SetVertexColor(cr, cg, cb, .75)

	self.bg = bg

	self:HookScript("OnEnter", radioOnEnter)
	self:HookScript("OnLeave", radioOnLeave)
end

local function scrollOnEnter(self)
	if self:IsEnabled() then
		local frameName = self.GetName and self:GetName()
		local bu = self.ThumbTexture or self.thumbTexture or (frameName and _G[frameName.."ThumbTexture"])
		if not bu then return end
		bu.bg:SetBackdropBorderColor(cr, cg, cb, 1)
	end
end

local function scrollOnLeave(self)
	if self:IsEnabled() then
		local frameName = self.GetName and self:GetName()
		local bu = self.ThumbTexture or self.thumbTexture or (frameName and _G[frameName.."ThumbTexture"])
		if not bu then return end
		bu.bg:SetBackdropBorderColor(0, 0, 0, 1)
	end
end

function F:ReskinScroll()
	F.StripTextures(self, true)
	F.CleanTextures(self, true)

	local frameName = self.GetName and self:GetName()
	local bu = self.ThumbTexture or self.thumbTexture or (frameName and _G[frameName.."ThumbTexture"])
	bu:SetAlpha(0)
	bu:SetWidth(17)

	bu.bg = F.CreateBDFrame(self, 0)
	bu.bg:SetPoint("TOPLEFT", bu, 0, -3)
	bu.bg:SetPoint("BOTTOMRIGHT", bu, 0, 3)
	F.CreateGradient(bu.bg)

	local up, down = self:GetChildren()
	up:SetWidth(17)
	down:SetWidth(17)

	F.ReskinButton(up, true)
	F.ReskinButton(down, true)

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

function F:ReskinSearchBox()
	F.StripTextures(self)

	local bg = F.CreateBDFrame(self, .25)
	bg:SetPoint("TOPLEFT", 0, 0)
	bg:SetPoint("BOTTOMRIGHT", 0, 1)
	F.ReskinTexture(self, bg, true)

	local icon = self.icon or self.Icon
	if icon then F.ReskinIcon(icon) end
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

function F:ReskinStatusBar(classColor, stripTex)
	F.StripTextures(self, stripTex)
	F.CleanTextures(self, true)

	self:SetStatusBarTexture(C.media.normTex)
	if classColor then
		self:SetStatusBarColor(cr*.8, cg*.8, cb*.8)
	end

	local lvl = self:GetFrameLevel()
	local bg = F.CreateBDFrame(self, .25)
	bg:SetFrameLevel(lvl == 0 and 1 or lvl - 1)
end

function F:ReskinTab()
	self:DisableDrawLayer("BACKGROUND")

	local lvl = self:GetFrameLevel()
	local bg = F.CreateBDFrame(self)
	bg:SetPoint("TOPLEFT", 8, -3)
	bg:SetPoint("BOTTOMRIGHT", -8, 0)
	bg:SetFrameLevel(lvl == 0 and 1 or lvl - 1)

	F.ReskinTexture(self, bg, true)
end

function F:ReskinTexture(relativeTo, classColor, isBorder)
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

	if self ~= relativeTo then
		tex:SetPoint("TOPLEFT", relativeTo, mult, -mult)
		tex:SetPoint("BOTTOMRIGHT", relativeTo, -mult, mult)
	end
end

local function getBackdrop(self) return self.bg:GetBackdrop() end
local function getBackdropColor() return 0, 0, 0, .5 end
local function getBackdropBorderColor() return 0, 0, 0 end

function F:ReskinTooltip()
	if not self.auroraTip then
		self:SetBackdrop(nil)
		self:DisableDrawLayer("BACKGROUND")
		local bg = F.CreateBDFrame(self)
		self.bg = bg

		self.GetBackdrop = getBackdrop
		self.GetBackdropColor = getBackdropColor
		self.GetBackdropBorderColor = getBackdropBorderColor
		self.auroraTip = true
	end
end

local hiddenFrame = CreateFrame("Frame")
hiddenFrame:Hide()

function F:HideObject()
	if self.UnregisterAllEvents then
		self:UnregisterAllEvents()
		self:SetParent(hiddenFrame)
	else
		self.Show = self.Hide
	end
	self:Hide()
end

local CleanList = {
	"Background",
	"BG",
	"Border",
	"border",
	"Bottom",
	"BottomLeft",
	"BottomMid",
	"BottomMiddle",
	"BottomRight",
	"Left",
	"Mid",
	"Middle",
	"MiddleLeft",
	"MiddleMid",
	"MiddleMiddle",
	"MiddleRight",
	"Right",
	"ScrollBarBottom",
	"ScrollBarMiddle",
	"ScrollBarTop",
	"ScrollDownBorder",
	"ScrollUpBorder",
	"Top",
	"TopLeft",
	"TopMid",
	"TopMiddle",
	"TopRight",
	"Track",
	"trackBG",
}

function F:CleanTextures(noIcon)
	--if self.SetCheckedTexture then self:SetCheckedTexture("") end
	if self.SetDisabledTexture then self:SetDisabledTexture("") end
	if self.SetHighlightTexture then self:SetHighlightTexture("") end
	if self.SetNormalTexture then self:SetNormalTexture("") end
	if self.SetPushedTexture then self:SetPushedTexture("") end

	local frameName = self.GetName and self:GetName()
	for _, texture in pairs(CleanList) do
		local cleanFrame = self[texture] or (frameName and _G[frameName..texture])
		if cleanFrame then cleanFrame:Hide() end
	end

	if noIcon then
		local ic = self.icon or self.Icon
		if ic then ic:Hide() end
	end
end

local BlizzTextures = {
	"Inset",
	"inset",
	"InsetFrame",
	"LeftInset",
	"RightInset",
	"NineSlice",
	"BorderFrame",
	"bottomInset",
	"BottomInset",
	"bgLeft",
	"bgRight",
	"FilligreeOverlay",
	"ShadowOverlay",
}

function F:StripTextures(kill)
	local frameName = self.GetName and self:GetName()
	for _, texture in pairs(BlizzTextures) do
		local blizzFrame = self[texture] or (frameName and _G[frameName..texture])
		if blizzFrame then F.StripTextures(blizzFrame, kill) end
	end

	if self.GetNumRegions then
		for i = 1, self:GetNumRegions() do
			local region = select(i, self:GetRegions())
			if region and region.IsObjectType and region:IsObjectType("Texture") then
				if kill and type(kill) == "boolean" then
					F.HideObject(region)
				elseif kill == 0 then
					region:Hide()
				else
					region:SetTexture("")
				end
			end
		end
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

		buttonR, buttonG, buttonB, buttonA = unpack(C.defaults.buttonGradientColour)

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