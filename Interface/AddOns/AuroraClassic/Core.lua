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
}

C.defaults = {
	["alpha"] = 0.5,
	["bags"] = false,
	["bubbleColor"] = false,
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

local function texOnEnter(self)
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
F.texOnEnter = texOnEnter

local function texOnLeave(self)
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
F.texOnLeave = texOnLeave

local function texOnMouseDown(self)
	if self:IsEnabled() then
		if self.bdTex then
			self.bdTex:SetBackdropColor(cr, cg, cb, .25)
		else
			self:SetBackdropColor(cr, cg, cb, .25)
		end
	end
end
F.texOnMouseDown = texOnMouseDown

local function texOnMouseUp(self)
	if self:IsEnabled() then
		if self.bdTex then
			self.bdTex:SetBackdropColor(0, 0, 0, 0)
		else
			self:SetBackdropColor(0, 0, 0, 0)
		end
	end
end
F.texOnMouseUp = texOnMouseUp

local function SetupHook(frame)
	frame:HookScript("OnEnter", texOnEnter)
	frame:HookScript("OnLeave", texOnLeave)
	frame:HookScript("OnMouseDown", texOnMouseDown)
	frame:HookScript("OnMouseUp", texOnMouseUp)
end

-- [[ Reskin Functions ]]

function F:CreateBD(alpha)
	self:SetBackdrop({bgFile = C.media.bdTex, edgeFile = C.media.bdTex, edgeSize = C.mult})
	self:SetBackdropColor(0, 0, 0, alpha or AuroraConfig.alpha)
	self:SetBackdropBorderColor(0, 0, 0)

	if not alpha then tinsert(C.frames, self) end
end

function F:CreateBDFrame(alpha, noGradient)
	local frame = self
	if self:GetObjectType() == "Texture" then frame = self:GetParent() end

	local lvl = frame:GetFrameLevel()
	local bg = CreateFrame("Frame", nil, frame)
	bg:SetPoint("TOPLEFT", self, -C.mult, C.mult)
	bg:SetPoint("BOTTOMRIGHT", self, C.mult, -C.mult)
	bg:SetFrameLevel(lvl == 0 and 1 or lvl - 1)
	F.CreateBD(bg, alpha)
	F.CreateSD(bg)

	if not noGradient then
		F.CreateGradient(bg)
	end

	return bg
end

function F:CreateBG()
	local frame = self
	if self:GetObjectType() == "Texture" then frame = self:GetParent() end

	local bg = frame:CreateTexture(nil, "BACKGROUND")
	bg:SetPoint("TOPLEFT", self, -C.mult, C.mult)
	bg:SetPoint("BOTTOMRIGHT", self, C.mult, -C.mult)
	bg:SetTexture(C.media.bdTex)
	bg:SetVertexColor(0, 0, 0)

	return bg
end

function F:CreateGradient()
	if self.Gradient then return end

	local Gradient = self:CreateTexture(nil, "BORDER")
	Gradient:SetPoint("TOPLEFT", self, C.mult, -C.mult)
	Gradient:SetPoint("BOTTOMRIGHT", self, -C.mult, C.mult)
	Gradient:SetTexture(C.media.gradientTex)
	Gradient:SetVertexColor(.3, .3, .3, .3)
	self.Gradient = Gradient

	return Gradient
end

local function createTex(frame)
	if frame.Tex then return end

	local Tex = frame:CreateTexture(nil, "BACKGROUND", nil, 1)
	Tex:SetAllPoints()
	Tex:SetTexture(C.media.bgTex, true, true)
	Tex:SetHorizTile(true)
	Tex:SetVertTile(true)
	Tex:SetBlendMode("ADD")
	frame.Tex = Tex

	return Tex
end

function F:CreateSD()
	if not AuroraConfig.shadow then return end
	if self.Shadow then return end

	local Pmult, Smult = C.mult*1.5, C.mult*2

	local lvl = self:GetFrameLevel()
	local Shadow = CreateFrame("Frame", nil, self)
	Shadow:SetPoint("TOPLEFT", self, -Pmult, Pmult)
	Shadow:SetPoint("BOTTOMRIGHT", self, Pmult, -Pmult)
	Shadow:SetBackdrop({edgeFile = C.media.glowTex, edgeSize = Smult})
	Shadow:SetBackdropBorderColor(0, 0, 0)
	Shadow:SetFrameLevel(lvl == 0 and 1 or lvl - 1)
	self.Shadow = Shadow

	createTex(self)

	return Shadow
end

function F:SetBDFrame(x, y, x2, y2)
	local bg = F.CreateBDFrame(self, nil, true)

	if x and y and x2 and y2 then
		bg:SetPoint("TOPLEFT", x, y)
		bg:SetPoint("BOTTOMRIGHT", x2, y2)
	end
end

function F:ReskinAffixes()
	for _, frame in ipairs(self.Affixes) do
		frame.Border:SetTexture(nil)
		frame.Portrait:SetTexture(nil)
		if not frame.bg then
			frame.bg = F.ReskinIcon(frame.Portrait)
		end

		if frame.info then
			frame.Portrait:SetTexture(CHALLENGE_MODE_EXTRA_AFFIX_INFO[frame.info.key].texture)
		elseif frame.affixID then
			local _, _, filedataid = C_ChallengeMode.GetAffixInfo(frame.affixID)
			frame.Portrait:SetTexture(filedataid)
		end
	end
end

function F:ReskinArrow(direction)
	self:SetSize(18, 18)

	F.StripTextures(self)
	F.ReskinButton(self)

	self:SetDisabledTexture(C.media.bdTex)
	local dis = self:GetDisabledTexture()
	dis:SetVertexColor(0, 0, 0, .25)
	dis:SetDrawLayer("OVERLAY")

	local bgTex = self:CreateTexture(nil, "ARTWORK")
	bgTex:SetTexture(mediaPath.."arrow-"..direction.."-active")
	bgTex:SetSize(8, 8)
	bgTex:SetPoint("CENTER")
	self.bgTex = bgTex
end

function F:ReskinBorder(relativeTo, classColor)
	if not self then return end

	self:SetTexture(C.media.bdTex)
	self.SetTexture = F.Dummy
	self:SetDrawLayer("BACKGROUND")

	if classColor then
		self:SetColorTexture(cr, cg, cb)
	end

	self:SetPoint("TOPLEFT", relativeTo, -C.mult, C.mult)
	self:SetPoint("BOTTOMRIGHT", relativeTo, C.mult, -C.mult)
end

function F:ReskinButton(noHighlight)
	F.CleanTextures(self, true)

	F.CreateBD(self, 0)
	F.CreateSD(self)
	F.CreateGradient(self)

	if not noHighlight then
		SetupHook(self)
	end
end

function F:ReskinCheck()
	F.CleanTextures(self)

	local ch = self:GetCheckedTexture()
	ch:SetDesaturated(true)
	ch:SetVertexColor(cr, cg, cb)

	local bdTex = F.CreateBDFrame(self, 0)
	bdTex:SetPoint("TOPLEFT", 4, -4)
	bdTex:SetPoint("BOTTOMRIGHT", -4, 4)
	self.bdTex = bdTex

	SetupHook(self)
end

function F:ReskinClose(a1, p, a2, x, y)
	self:SetSize(17, 17)

	F.StripTextures(self)
	F.ReskinButton(self)

	if not a1 then
		self:SetPoint("TOPRIGHT", -6, -6)
	else
		self:ClearAllPoints()
		self:SetPoint(a1, p, a2, x, y)
	end

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
	F.StripTextures(self)
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
	F.CleanTextures(self)

	local frameName = self.GetName and self:GetName()
	local button = self.Button or (frameName and _G[frameName.."Button"])
	button:SetSize(20, 20)
	button:ClearAllPoints()
	button:SetPoint("RIGHT", -18, 2)
	F.ReskinButton(button)

	button:SetDisabledTexture(C.media.bdTex)
	local dis = button:GetDisabledTexture()
	dis:SetVertexColor(0, 0, 0, .5)
	dis:SetDrawLayer("OVERLAY")
	dis:SetAllPoints()

	local bgTex = button:CreateTexture(nil, "ARTWORK")
	bgTex:SetTexture(C.media.arrowDown)
	bgTex:SetSize(8, 8)
	bgTex:SetPoint("CENTER")
	bgTex:SetVertexColor(1, 1, 1)
	button.bgTex = bgTex

	local bg = F.CreateBDFrame(self, 0)
	bg:SetPoint("TOPLEFT", self, "TOPLEFT", 16, -4)
	bg:SetPoint("BOTTOMRIGHT", button, "BOTTOMLEFT", -1, 0)

	local text = self.Text or (frameName and _G[frameName.."Text"])
	if text then
		text:SetJustifyH("CENTER")
		text:ClearAllPoints()
		text:SetPoint("CENTER", bg, 1, 0)
	end
end

local function setupTex(self, texture)
	if self.setTex then return end
	self.setTex = true
	self:SetNormalTexture("")

	if texture and texture ~= "" then
		if texture:find("Plus") then
			self.expTex:SetTexCoord(0, 0.4375, 0, 0.4375)
		elseif texture:find("Minus") then
			self.expTex:SetTexCoord(0.5625, 1, 0, 0.4375)
		end
		self.bdTex:Show()
	else
		self.bdTex:Hide()
	end
	self.setTex = false
end

function F:ReskinExpandOrCollapse()
	F.StripTextures(self)
	F.CleanTextures(self)

	local bdTex = F.CreateBDFrame(self, 0)
	bdTex:ClearAllPoints()
	bdTex:SetSize(13, 13)
	bdTex:SetPoint("TOPLEFT", self:GetNormalTexture())
	self.bdTex = bdTex

	local expTex = bdTex:CreateTexture(nil, "OVERLAY")
	expTex:SetSize(7, 7)
	expTex:SetPoint("CENTER")
	expTex:SetTexture("Interface\\Buttons\\UI-PlusMinus-Buttons")
	self.expTex = expTex

	SetupHook(self)

	hooksecurefunc(self, "SetNormalTexture", setupTex)
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
	end

	F.CleanTextures(self)
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

	local squareBG = F.CreateBDFrame(self, 1)
	squareBG:SetPoint("TOPLEFT", 3, -3)
	squareBG:SetPoint("BOTTOMRIGHT", -3, 11)
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

function F:ReskinIcon(setBG, alpha)
	self:SetTexCoord(.08, .92, .08, .92)

	if setBG then
		return F.CreateBG(self)
	else
		return F.CreateBDFrame(self, alpha or 0)
	end
end

function F:ReskinInput(height, width)
	F.CleanTextures(self)

	local bg = F.CreateBDFrame(self, 0)
	bg:SetPoint("TOPLEFT", -2, 0)
	bg:SetPoint("BOTTOMRIGHT")

	if height then self:SetHeight(height) end
	if width then self:SetWidth(width) end
end

function F:ReskinMinMax()
	for _, name in next, {"MaximizeButton", "MinimizeButton"} do
		local button = self[name]
		if button then
			F.StripTextures(self)
			F.CleanTextures(self)
			F.ReskinButton(button)

			button:SetSize(17, 17)
			button:ClearAllPoints()
			button:SetPoint("CENTER", -3, 0)

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
		end
	end
end

function F:ReskinNavBar()
	if self.styled then return end

	F.StripTextures(self)
	F.CleanTextures(self)

	self:GetRegions():Hide()
	self:DisableDrawLayer("BORDER")
	self.overlay:Hide()

	local homeButton = self.homeButton
	homeButton:GetRegions():Hide()
	homeButton.text:ClearAllPoints()
	homeButton.text:SetPoint("CENTER")
	F.ReskinButton(homeButton)

	local overflowButton = self.overflowButton
	F.ReskinButton(overflowButton)

	local bgTex = overflowButton:CreateTexture(nil, "ARTWORK")
	bgTex:SetTexture(C.media.arrowLeft)
	bgTex:SetSize(8, 8)
	bgTex:SetPoint("CENTER")
	overflowButton.bgTex = bgTex

	self.styled = true
end

function F:ReskinRadio()
	F.StripTextures(self)
	F.CleanTextures(self)

	local bdTex = F.CreateBDFrame(self, 0)
	bdTex:SetPoint("TOPLEFT", 2, -2)
	bdTex:SetPoint("BOTTOMRIGHT", -2, 2)
	self.bdTex = bdTex

	self:SetCheckedTexture(C.media.bdTex)
	local ch = self:GetCheckedTexture()
	ch:SetPoint("TOPLEFT", bdTex, C.mult, -C.mult)
	ch:SetPoint("BOTTOMRIGHT", bdTex, -C.mult, C.mult)
	ch:SetVertexColor(cr, cg, cb, .75)

	SetupHook(self)
end

local function scrollThumb(self)
	local frameName = self.GetName and self:GetName()
	local bu = self.ThumbTexture or self.thumbTexture or (frameName and _G[frameName.."ThumbTexture"])

	return bu
end

local function scrollOnEnter(self)
	if self:IsEnabled() then
		local bu = scrollThumb(self)

		if not bu then return end
		bu.bg:SetBackdropBorderColor(cr, cg, cb, 1)
	end
end

local function scrollOnLeave(self)
	if self:IsEnabled() then
		local bu = scrollThumb(self)

		if not bu then return end
		bu.bg:SetBackdropBorderColor(0, 0, 0, 1)
	end
end

function F:ReskinScroll()
	F.StripTextures(self)
	F.CleanTextures(self)

	local bu = scrollThumb(self)
	bu:SetAlpha(0)
	bu:SetWidth(17)

	local bg = F.CreateBDFrame(self, 0)
	bg:SetPoint("TOPLEFT", bu, 0, -3)
	bg:SetPoint("BOTTOMRIGHT", bu, 0, 3)
	bu.bg = bg

	local up, down = self:GetChildren()
	up:SetWidth(17)
	down:SetWidth(17)

	F.ReskinButton(up)
	F.ReskinButton(down)

	up:SetDisabledTexture(C.media.bdTex)
	local updis = up:GetDisabledTexture()
	updis:SetVertexColor(0, 0, 0, .5)
	updis:SetDrawLayer("OVERLAY")

	down:SetDisabledTexture(C.media.bdTex)
	local downdis = down:GetDisabledTexture()
	downdis:SetVertexColor(0, 0, 0, .5)
	downdis:SetDrawLayer("OVERLAY")

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

	self:HookScript("OnEnter", scrollOnEnter)
	self:HookScript("OnLeave", scrollOnLeave)
end

function F:ReskinSearchBox()
	F.StripTextures(self)
	F.CleanTextures(self, true)

	local bg = F.CreateBDFrame(self, 0)
	bg:SetPoint("TOPLEFT", 0, 0)
	bg:SetPoint("BOTTOMRIGHT", 0, 1)
	F.ReskinTexture(self, bg, true)

	local icon = self.icon or self.Icon
	if icon then F.ReskinIcon(icon, true) end
end

function F:ReskinSearchResult()
	if not self then return end

	local results = self.searchResults
	results:ClearAllPoints()
	results:SetPoint("BOTTOMLEFT", self, "BOTTOMRIGHT", 20, 0)
	F.StripTextures(results)
	F.CleanTextures(results)

	local bg = F.CreateBDFrame(results, nil, true)
	bg:SetPoint("TOPLEFT", -10, 0)
	bg:SetPoint("BOTTOMRIGHT")

	local frameName = self.GetName and self:GetName()
	local closebu = results.closeButton or (frameName and _G[frameName.."SearchResultsCloseButton"])
	F.ReskinClose(closebu)

	local bar = results.scrollFrame.scrollBar
	if bar then F.ReskinScroll(bar) end

	for i = 1, 9 do
		local bu = results.scrollFrame.buttons[i]

		if bu and not bu.styled then
			F.StripTextures(bu)

			local icbg = F.ReskinIcon(bu.icon)
			bu.icon.SetTexCoord = F.Dummy

			local bubg = F.CreateBDFrame(bu, 0)
			bubg:SetPoint("TOPLEFT", icbg, "TOPRIGHT", 2, 2)
			bubg:SetPoint("BOTTOMRIGHT", -2, 3)
			F.ReskinTexture(bu, bubg, true)

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

function F:ReskinSlider(verticle)
	self:SetBackdrop(nil)
	self.SetBackdrop = F.Dummy

	local bg = F.CreateBDFrame(self, 0)
	bg:SetPoint("TOPLEFT", 14, -2)
	bg:SetPoint("BOTTOMRIGHT", -15, 3)
	bg:SetFrameStrata("BACKGROUND")

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

function F:ReskinStatusBar(noClassColor)
	F.StripTextures(self, true)
	F.CleanTextures(self)
	F.CreateBDFrame(self, 0)

	self:SetStatusBarTexture(C.media.normTex)
	if not noClassColor then
		self:SetStatusBarColor(cr, cg, cb, .8)
	end
end

function F:ReskinTab()
	F.StripTextures(self)
	F.CleanTextures(self)

	local bg = F.CreateBDFrame(self, nil, true)
	bg:SetPoint("TOPLEFT", 8, -3)
	bg:SetPoint("BOTTOMRIGHT", -8, 0)
	F.ReskinTexture(self, bg, true)
end

function F:ReskinTexture(relativeTo, classColor)
	if not self then return end

	local r, g, b = 1, 1, 1
	if classColor then r, g, b = cr, cg, cb end

	local tex
	if self.SetHighlightTexture then
		self:SetHighlightTexture(C.media.bdTex)
		tex = self:GetHighlightTexture()
	else
		tex = self
		tex:SetTexture(C.media.bdTex)
	end

	tex:SetColorTexture(r, g, b, .25)
	tex:SetPoint("TOPLEFT", relativeTo, C.mult, -C.mult)
	tex:SetPoint("BOTTOMRIGHT", relativeTo, -C.mult, C.mult)
end

local function getBackdrop(self) return self.bdTex:GetBackdrop() end
local function getBackdropColor() return 0, 0, 0, .5 end
local function getBackdropBorderColor() return 0, 0, 0 end

function F:ReskinTooltip()
	if not self.auroraTip then
		self:SetBackdrop(nil)
		self:DisableDrawLayer("BACKGROUND")
		local bdTex = F.CreateBDFrame(self, nil, true)
		self.bdTex = bdTex

		self.GetBackdrop = getBackdrop
		self.GetBackdropColor = getBackdropColor
		self.GetBackdropBorderColor = getBackdropBorderColor
		self.auroraTip = true
	end
end

-- [[ Strip Functions ]]

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

function F:Dummy()
end

local CleanTextures = {
	"BG",
	"Bg",
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
	"track",
	"trackBG",
}

function F:CleanTextures(noIcon)
	--if self.SetCheckedTexture then self:SetCheckedTexture("") end
	if self.SetDisabledTexture then self:SetDisabledTexture("") end
	if self.SetHighlightTexture then self:SetHighlightTexture("") end
	if self.SetNormalTexture then self:SetNormalTexture("") end
	if self.SetPushedTexture then self:SetPushedTexture("") end

	local frameName = self.GetName and self:GetName()
	for _, texture in pairs(CleanTextures) do
		local cleanFrame = self[texture] or (frameName and _G[frameName..texture])
		if cleanFrame then
			cleanFrame:SetAlpha(0)
			cleanFrame:Hide()
		end
	end

	if not noIcon then
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
					region:SetAlpha(0)
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