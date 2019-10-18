-- [[ Core ]]
local addonName, ns = ...

ns[1] = {} -- F, functions
ns[2] = {} -- C, constants/config
_G[addonName] = ns

AuroraConfig = {}

local F, C = unpack(ns)

-- [[ Constants and settings ]]

local mediaPath = "Interface\\AddOns\\AuroraClassic\\Media\\"

C.media = {
	["arrowBottom"] = mediaPath.."arrow-bottom",
	["arrowDown"] = mediaPath.."arrow-down",
	["arrowLeft"] = mediaPath.."arrow-left",
	["arrowRight"] = mediaPath.."arrow-right",
	["arrowTop"] = mediaPath.."arrow-top",
	["arrowUp"] = mediaPath.."arrow-up",
	["bdTex"] = "Interface\\ChatFrame\\ChatFrameBackground",
	["bgTex"] = mediaPath.."bgTex",
	["checked"] = mediaPath.."checked",
	["font"] = STANDARD_TEXT_FONT,
	["glowTex"] = mediaPath.."glowTex",
	["gradTex"] = mediaPath.."gradTex",
	["normTex"] = "Interface\\TargetingFrame\\UI-TargetingFrame-BarFill",
	["pushed"] = mediaPath.."pushed",
	["roleTex"] = mediaPath.."roleTex",
}

C.defaults = {
	["alpha"] = .5,
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
	["uiScale"] = 0,
	["useCustomColour"] = false,
}

C.frames = {}

-- [[ Database ]]

C.ClassColors = {}
local class = select(2, UnitClass("player"))
local colors = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
for class, value in pairs(colors) do
	C.ClassColors[class] = {}
	C.ClassColors[class].r = value.r
	C.ClassColors[class].g = value.g
	C.ClassColors[class].b = value.b
	C.ClassColors[class].colorStr = value.colorStr
end

local cr, cg, cb = C.ClassColors[class].r, C.ClassColors[class].g, C.ClassColors[class].b

local function SetupPixelFix()
	local screenHeight = select(2, GetPhysicalScreenSize())
	local bestScale = max(.4, min(1.15, 768 / screenHeight))
	local pixelScale = 768 / screenHeight
	local scale = UIParent:GetScale()
	local uiScale = AuroraConfig.uiScale
	if uiScale and uiScale > 0 then scale = uiScale end
	C.mult = (bestScale / scale) - ((bestScale - pixelScale) / scale)

	if screenHeight > 1080 then C.mult = C.mult*2 end
end

local function SetupDisTex(self)
	self:SetDisabledTexture(C.media.bdTex)
	local dis = self:GetDisabledTexture()
	dis:SetVertexColor(0, 0, 0, .5)
	dis:SetDrawLayer("OVERLAY")
	dis:SetAllPoints()
end

local function SetupHook(self)
	self:HookScript("OnEnter", F.TexOnEnter)
	self:HookScript("OnLeave", F.TexOnLeave)
	self:HookScript("OnMouseDown", F.TexOnMouseDown)
	self:HookScript("OnMouseUp", F.TexOnMouseUp)
end

function F:SetupArrowTex(direction)
	if self.bgTex then return end

	local bgTex = self:CreateTexture(nil, "ARTWORK")
	bgTex:SetTexture(mediaPath.."arrow-"..direction)
	bgTex:SetSize(8, 8)
	bgTex:ClearAllPoints()
	bgTex:SetPoint("CENTER")
	bgTex:SetVertexColor(1, 1, 1)
	self.bgTex = bgTex

	return bgTex
end

function F:SetupTabStyle(index, tabName)
	local frameName = self.GetName and self:GetName()
	local tab = frameName and frameName.."Tab"

	if tabName then tab = frameName and frameName..tabName end
	if not tab then return end

	for i = 1, index do
		local tabs = _G[tab..i]
		if tabs then
			if not tabs.styled then
				F.ReskinTab(tabs)

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

function F:GetRoleTexCoord()
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

function F:TexOnEnter()
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

function F:TexOnLeave()
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

function F:TexOnMouseDown()
	if self:IsEnabled() then
		if self.bdTex then
			self.bdTex:SetBackdropColor(cr, cg, cb, .25)
		else
			self:SetBackdropColor(cr, cg, cb, .25)
		end
	end
end

function F:TexOnMouseUp()
	if self:IsEnabled() then
		if self.bdTex then
			self.bdTex:SetBackdropColor(0, 0, 0, 0)
		else
			self:SetBackdropColor(0, 0, 0, 0)
		end
	end
end

-- [[ Reskin Functions ]]

local function CreateTex(self)
	if self.Tex then return end

	local Tex = self:CreateTexture(nil, "BACKGROUND", nil, 1)
	Tex:SetTexture(C.media.bgTex, true, true)
	Tex:SetAllPoints(self)
	Tex:SetBlendMode("ADD")
	Tex:SetHorizTile(true)
	Tex:SetVertTile(true)
	self.Tex = Tex

	return Tex
end

function F:CreateBD(alpha)
	self:SetBackdrop({bgFile = C.media.bdTex, edgeFile = C.media.bdTex, edgeSize = C.mult})
	self:SetBackdropColor(0, 0, 0, alpha or AuroraConfig.alpha)
	self:SetBackdropBorderColor(0, 0, 0)

	CreateTex(self)

	if not alpha then tinsert(C.frames, self) end
end

function F:CreateBDFrame(alpha, offset, noGradient)
	local frame = self
	if self:GetObjectType() == "Texture" then frame = self:GetParent() end

	offset = offset or C.mult

	local lvl = frame:GetFrameLevel()
	local bg = CreateFrame("Frame", nil, frame)
	bg:ClearAllPoints()
	bg:SetPoint("TOPLEFT", self, -offset, offset)
	bg:SetPoint("BOTTOMRIGHT", self, offset, -offset)
	bg:SetFrameLevel(lvl == 0 and 1 or lvl - 1)
	F.CreateBD(bg, alpha)
	F.CreateSD(bg)

	if not noGradient then
		F.CreateGF(bg)
	end

	return bg
end

function F:CreateBG()
	local frame = self
	if self:GetObjectType() == "Texture" then frame = self:GetParent() end

	local bg = frame:CreateTexture(nil, "BORDER")
	bg:ClearAllPoints()
	bg:SetPoint("TOPLEFT", self, -C.mult, C.mult)
	bg:SetPoint("BOTTOMRIGHT", self, C.mult, -C.mult)
	bg:SetTexture(C.media.bdTex)
	bg:SetVertexColor(0, 0, 0)

	return bg
end

function F:CreateGA(width, height, direction, r, g, b, a1, a2)
	self:SetSize(width, height)
	self:SetFrameStrata("BACKGROUND")

	local ga = self:CreateTexture(nil, "BACKGROUND")
	ga:SetAllPoints()
	ga:SetTexture(C.media.normTex)
	ga:SetGradientAlpha(direction, r, g, b, a1, r, g, b, a2)
end

function F:CreateGF()
	if self.Gradient then return end

	local Gradient = self:CreateTexture(nil, "BORDER")
	Gradient:ClearAllPoints()
	Gradient:SetPoint("TOPLEFT", self, C.mult, -C.mult)
	Gradient:SetPoint("BOTTOMRIGHT", self, -C.mult, C.mult)
	Gradient:SetTexture(C.media.gradTex)
	Gradient:SetVertexColor(.3, .3, .3, .3)
	self.Gradient = Gradient

	return Gradient
end

function F:CreateLine(isHorizontal)
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

function F:CreateSD()
	if not AuroraConfig.shadow then return end
	if self.Shadow then return end

	local Pmult, Smult = C.mult*1.5, C.mult*2.5
	local lvl = self:GetFrameLevel()
	local Shadow = CreateFrame("Frame", nil, self)
	Shadow:ClearAllPoints()
	Shadow:SetPoint("TOPLEFT", self, -Pmult, Pmult)
	Shadow:SetPoint("BOTTOMRIGHT", self, Pmult, -Pmult)
	Shadow:SetBackdrop({edgeFile = C.media.glowTex, edgeSize = Smult})
	Shadow:SetBackdropBorderColor(0, 0, 0)
	Shadow:SetFrameLevel(lvl == 0 and 1 or lvl - 1)
	self.Shadow = Shadow

	return Shadow
end

function F:SetBDFrame(x, y, x2, y2)
	local bg = F.CreateBDFrame(self, nil, nil, true)

	if x and y and x2 and y2 then
		bg:ClearAllPoints()
		bg:SetPoint("TOPLEFT", x, y)
		bg:SetPoint("BOTTOMRIGHT", x2, y2)
	end

	return bg
end

function F:ReskinAffixes()
	for _, frame in ipairs(self.Affixes) do
		frame.Border:SetTexture(nil)
		frame.Portrait:SetTexture(nil)
		if not frame.styled then
			F.ReskinIcon(frame.Portrait, false, 1)

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

function F:ReskinArrow(direction)
	self:SetSize(18, 18)

	F.StripTextures(self)

	F.ReskinButton(self)
	F.SetupArrowTex(self, direction)
	SetupDisTex(self)
end

function F:ReskinBorder(relativeTo, classColor)
	if not self then return end

	self:SetTexture(C.media.bdTex)
	self.SetTexture = F.Dummy
	self:SetDrawLayer("BACKGROUND")

	if classColor then
		self:SetColorTexture(cr, cg, cb)
	end

	self:ClearAllPoints()
	self:SetPoint("TOPLEFT", relativeTo, -C.mult, C.mult)
	self:SetPoint("BOTTOMRIGHT", relativeTo, C.mult, -C.mult)
end

function F:ReskinButton(noHighlight)
	F.CleanTextures(self)

	F.CreateBD(self, 0)
	F.CreateSD(self)
	F.CreateGF(self)

	if not noHighlight then
		SetupHook(self)
	end
end

function F:ReskinCheck()
	F.CleanTextures(self)

	local ch = self:GetCheckedTexture()
	ch:SetDesaturated(true)
	ch:SetVertexColor(cr, cg, cb)

	local bdTex = F.CreateBDFrame(self, 0, -4)
	self.bdTex = bdTex

	SetupHook(self)
end

function F:ReskinClose(a1, p, a2, x, y)
	self:SetSize(18, 18)

	self:ClearAllPoints()
	if not a1 then
		self:SetPoint("TOPRIGHT", -6, -6)
	else
		self:SetPoint(a1, p, a2, x, y)
	end

	F.StripTextures(self)

	F.ReskinButton(self)
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

function F:ReskinColourSwatch()
	self:SetNormalTexture(C.media.bdTex)
	local nt = self:GetNormalTexture()
	nt:ClearAllPoints()
	nt:SetPoint("TOPLEFT", 2, -2)
	nt:SetPoint("BOTTOMRIGHT", -2, 2)

	local frameName = self.GetName and self:GetName()
	local bg = frameName and _G[frameName.."SwatchBg"]
	bg:SetColorTexture(0, 0, 0)
	bg:ClearAllPoints()
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
		tex:SetColorTexture(1, 1, 1)
		tex:SetSize(w*.75, 2)
		tex:ClearAllPoints()
		tex:SetPoint("CENTER")
		tex:SetRotation(math.rad((i-1/2)*90))
		tinsert(self.pixels, tex)
	end
end

function F:ReskinDropDown()
	F.StripTextures(self)
	F.CleanTextures(self)

	local frameName = self.GetName and self:GetName()
	local button = (frameName and _G[frameName.."Button"]) or self.Button
	button:SetSize(20, 20)
	button:ClearAllPoints()
	button:SetPoint("RIGHT", -18, 2)

	F.ReskinButton(button)
	F.SetupArrowTex(button, "down")
	SetupDisTex(button)

	local bg = F.CreateBDFrame(self, 0)
	bg:ClearAllPoints()
	bg:SetPoint("TOPLEFT", self, "TOPLEFT", 16, -4)
	bg:SetPoint("BOTTOMRIGHT", button, "BOTTOMLEFT", -1, 0)

	for _, word in pairs({"Text", "text"}) do
		local text = (frameName and _G[frameName..word]) or self[word]
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

function F:ReskinExpandOrCollapse()
	F.StripTextures(self)
	F.CleanTextures(self)

	local bdTex = F.CreateBDFrame(self, 0)
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

function F:ReskinFilter()
	F.StripTextures(self)

	F.ReskinButton(self)

	self.Icon:SetTexture(C.media.arrowRight)
	self.Icon:ClearAllPoints()
	self.Icon:SetPoint("RIGHT", self, "RIGHT", -5, 0)
	self.Icon:SetSize(8, 8)

	if self.Text then
		self.Text:ClearAllPoints()
		self.Text:SetPoint("CENTER")
	end
end

function F:ReskinFrame(killType)
	if type(killType) == "number" then
		F.StripTextures(self, killType)
	else
		F.StripTextures(self, not killType)
	end
	F.CleanTextures(self)

	local bg = F.CreateBDFrame(self, nil, nil, true)

	local frameName = self.GetName and self:GetName()
	local framePortrait = (frameName and _G[frameName.."Portrait"]) or self.portrait
	if framePortrait then framePortrait:SetAlpha(0) end

	local closeButton = (frameName and _G[frameName.."CloseButton"]) or self.CloseButton
	if closeButton then F.ReskinClose(closeButton) end

	return bg
end

function F:ReskinGarrisonPortrait()
	self.Portrait:ClearAllPoints()
	self.Portrait:SetPoint("TOPLEFT", 4, -4)
	self.Portrait:SetMask(C.media.bdTex)
	self.PortraitRing:Hide()
	self.PortraitRingQuality:SetTexture("")
	if self.Highlight then self.Highlight:Hide() end

	self.LevelBorder:SetScale(.0001)
	self.Level:ClearAllPoints()
	self.Level:SetPoint("BOTTOM", self, 0, 12)

	local squareBG = F.CreateBDFrame(self.Portrait, 1)
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
	self:DisableDrawLayer("BACKGROUND")

	local bg = F.CreateBDFrame(self, 0)
	bg:ClearAllPoints()
	bg:SetPoint("TOPLEFT", -2, 0)
	bg:SetPoint("BOTTOMRIGHT")

	if height then self:SetHeight(height) end
	if width then self:SetWidth(width) end
end

function F:ReskinMinMax()
	for _, name in pairs({"MaximizeButton", "MinimizeButton"}) do
		local button = self[name]
		if button then
			F.StripTextures(self)
			F.CleanTextures(self)

			F.ReskinButton(button)

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

function F:ReskinNavBar()
	if self.styled then return end

	F.StripTextures(self)
	F.CleanTextures(self)
	self.overlay:Hide()

	local homeButton = self.homeButton
	homeButton.text:ClearAllPoints()
	homeButton.text:SetPoint("CENTER")
	F.ReskinButton(homeButton)

	local overflowButton = self.overflowButton
	F.ReskinButton(overflowButton)
	F.SetupArrowTex(overflowButton, "left")

	self.styled = true
end

function F:ReskinPartyPoseUI()
	F.ReskinFrame(self)
	F.ReskinButton(self.LeaveButton)
	F.StripTextures(self.ModelScene)
	F.CreateBDFrame(self.ModelScene, 0)

	self.OverlayElements.Topper:Hide()

	local RewardFrame = self.RewardAnimations.RewardFrame
	RewardFrame.NameFrame:SetAlpha(0)
	RewardFrame.IconBorder:SetAlpha(0)

	local icbg = F.ReskinIcon(RewardFrame.Icon)
	local Label = RewardFrame.Label
	Label:ClearAllPoints()
	Label:SetPoint("LEFT", icbg, "RIGHT", 6, 10)

	local Name = RewardFrame.Name
	Name:ClearAllPoints()
	Name:SetPoint("LEFT", icbg, "RIGHT", 6, -10)
end

function F:ReskinRadio()
	F.StripTextures(self)
	F.CleanTextures(self)

	local bdTex = F.CreateBDFrame(self, 0, -2)
	self.bdTex = bdTex

	self:SetCheckedTexture(C.media.bdTex)
	local ch = self:GetCheckedTexture()
	ch:ClearAllPoints()
	ch:SetPoint("TOPLEFT", bdTex, C.mult, -C.mult)
	ch:SetPoint("BOTTOMRIGHT", bdTex, -C.mult, C.mult)
	ch:SetVertexColor(cr, cg, cb, .75)

	SetupHook(self)
end

function F:ReskinRole(role)
	if self.background then self.background:SetTexture("") end

	local cover = self.cover or self.Cover
	if cover then cover:SetTexture("") end

	local texture = self.Icon or self.icon or self.Texture or self.texture or (self.SetTexture and self) or (self.GetNormalTexture and self:GetNormalTexture())
	if texture then
		texture:SetTexture(C.media.roleTex)
		texture:SetTexCoord(F.GetRoleTexCoord(role))
	end
	self.bg = F.CreateBDFrame(self, 0, nil, true)

	local checkButton = self.checkButton or self.CheckButton or self.CheckBox
	if checkButton then
		checkButton:SetFrameLevel(self:GetFrameLevel() + 2)
		checkButton:ClearAllPoints()
		checkButton:SetPoint("BOTTOMLEFT", -2, -2)
		F.ReskinCheck(checkButton)
	end

	local shortageBorder = self.shortageBorder
	if shortageBorder then
		shortageBorder:SetTexture("")

		local icon = self.incentiveIcon
		icon.border:SetTexture("")
		icon.texture:ClearAllPoints()
		icon.texture:SetPoint("BOTTOMRIGHT", self, -3, 3)
		icon.texture:SetSize(14, 14)
		F.ReskinIcon(icon.texture, true)
	end
end

function F:ReskinRoleIcon(setBG)
	self:SetTexture(C.media.roleTex)

	if setBG then
		return F.CreateBG(self)
	else
		return F.CreateBDFrame(self, 0)
	end
end

local function scrollThumb(self)
	local frameName = self.GetName and self:GetName()
	local bu = (frameName and _G[frameName.."ThumbTexture"]) or self.ThumbTexture or self.thumbTexture

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

	local parent = self:GetParent()
	if parent then
		F.StripTextures(parent, true)
		F.CleanTextures(parent)
	end

	local bu = scrollThumb(self)
	bu:SetAlpha(0)
	bu:SetWidth(18)

	local bg = F.CreateBDFrame(self, 0)
	bg:ClearAllPoints()
	bg:SetPoint("TOPLEFT", bu, 0, -3)
	bg:SetPoint("BOTTOMRIGHT", bu, 0, 3)
	bu.bg = bg

	local up, down = self:GetChildren()
	up:SetWidth(18)
	down:SetWidth(18)

	F.ReskinButton(up)
	F.ReskinButton(down)

	F.SetupArrowTex(up, "up")
	F.SetupArrowTex(down, "down")

	SetupDisTex(up)
	SetupDisTex(down)

	self:HookScript("OnEnter", scrollOnEnter)
	self:HookScript("OnLeave", scrollOnLeave)
end

function F:ReskinSearchBox()
	F.StripTextures(self)
	F.CleanTextures(self)

	local bg = F.CreateBDFrame(self, 0, -.5)
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

	local bg = F.CreateBDFrame(results, nil, nil, true)
	bg:ClearAllPoints()
	bg:SetPoint("TOPLEFT", -10, 0)
	bg:SetPoint("BOTTOMRIGHT")

	local frameName = self.GetName and self:GetName()
	local closebu = (frameName and _G[frameName.."SearchResultsCloseButton"]) or results.closeButton
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
			bubg:ClearAllPoints()
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
	bg:ClearAllPoints()
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

function F:ReskinSort()
	local normal = self:GetNormalTexture()
	normal:SetTexCoord(.17, .83, .17, .83)

	local pushed = self:GetPushedTexture()
	pushed:SetTexCoord(.17, .83, .17, .83)

	local highlight = self:GetHighlightTexture()
	highlight:SetColorTexture(1, 1, 1, .25)
	highlight:SetAllPoints()

	F.CreateBDFrame(self, 0)
end

local BarWords = {
	"Label",
	"label",
	"Rank",
	"RankText",
	"rankText",
	"Text",
	"text",
}

function F:ReskinStatusBar(noClassColor)
	F.StripTextures(self)
	F.CleanTextures(self)

	F.CreateBDFrame(self, 0)

	self:SetStatusBarTexture(C.media.normTex)
	if not noClassColor then
		self:SetStatusBarColor(cr, cg, cb, .8)
	end

	local frameName = self.GetName and self:GetName()
	for _, word in pairs(BarWords) do
		local text = (frameName and _G[frameName..word]) or self[word]
		if text then
			text:SetJustifyH("CENTER")
			text:ClearAllPoints()
			text:SetPoint("CENTER")
		end
	end
end

function F:ReskinTab()
	F.StripTextures(self)
	F.CleanTextures(self)

	local bg = F.CreateBDFrame(self, nil, nil, true)
	bg:ClearAllPoints()
	bg:SetPoint("TOPLEFT", 8, -3)
	bg:SetPoint("BOTTOMRIGHT", -8, 0)
	F.ReskinTexture(self, bg, true)
end

function F:ReskinTexed(relativeTo)
	if not self then return end

	local tex
	if self.SetCheckedTexture then
		self:SetCheckedTexture(C.media.checked)
		tex = self:GetCheckedTexture()
	elseif self.GetNormalTexture then
		tex = self:GetNormalTexture()
		tex:SetTexture(C.media.checked)
	elseif self.SetTexture then
		tex = self
		tex:SetTexture(C.media.checked)
	end

	tex:ClearAllPoints()
	tex:SetPoint("TOPLEFT", relativeTo, C.mult, -C.mult)
	tex:SetPoint("BOTTOMRIGHT", relativeTo, -C.mult, C.mult)
end

function F:ReskinTexture(relativeTo, classColor, alpha, offset)
	if not self then return end

	local r, g, b = 1, 1, 1
	if classColor then r, g, b = cr, cg, cb end

	local tex
	if self.SetHighlightTexture then
		self:SetHighlightTexture(C.media.bdTex)
		tex = self:GetHighlightTexture()
	elseif self.GetNormalTexture then
		tex = self:GetNormalTexture()
		tex:SetTexture(C.media.bdTex)
	elseif self.SetTexture then
		tex = self
		tex:SetTexture(C.media.bdTex)
	end

	offset = offset or C.mult

	tex:SetColorTexture(r, g, b, alpha or .25)
	tex:ClearAllPoints()
	tex:SetPoint("TOPLEFT", relativeTo, offset, -offset)
	tex:SetPoint("BOTTOMRIGHT", relativeTo, -offset, offset)
end

local function getBackdrop(self) return self.bdTex:GetBackdrop() end
local function getBackdropColor() return 0, 0, 0, .5 end
local function getBackdropBorderColor() return 0, 0, 0 end

function F:ReskinTooltip()
	if not self.auroraTip then
		self:SetBackdrop(nil)
		self:DisableDrawLayer("BACKGROUND")
		local bdTex = F.CreateBDFrame(self, nil, nil, true)
		self.bdTex = bdTex

		self.GetBackdrop = getBackdrop
		self.GetBackdropColor = getBackdropColor
		self.GetBackdropBorderColor = getBackdropBorderColor

		local icon = self.Icon or self.icon
		if icon then F.ReskinIcon(icon, true) end

		local border = self.Border or self.IconBorder
		if border then border:SetAlpha(0) end

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

function F:CleanTextures()
	if self.SetBackdrop then self:SetBackdrop(nil) end
	if self.SetDisabledTexture then self:SetDisabledTexture("") end
	if self.SetHighlightTexture then self:SetHighlightTexture("") end
	if self.SetNormalTexture then self:SetNormalTexture("") end
	if self.SetPushedTexture then self:SetPushedTexture("") end

	local frameName = self.GetName and self:GetName()
	for _, texture in pairs(CleanTextures) do
		local cleanFrame = (frameName and _G[frameName..texture]) or self[texture]
		if cleanFrame then
			cleanFrame:SetAlpha(0)
			cleanFrame:Hide()
		end
	end
end

local BlizzTextures = {
	"bgLeft",
	"bgRight",
	"Border",
	"border",
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
	"RightInset",
	"shadows",
	"ShadowOverlay",
}

function F:StripTextures(kill)
	local frameName = self.GetName and self:GetName()
	for _, texture in pairs(BlizzTextures) do
		local blizzFrame = (frameName and _G[frameName..texture]) or self[texture]
		if blizzFrame then F.StripTextures(blizzFrame, kill) end
	end

	if self.GetNumRegions then
		for i = 1, self:GetNumRegions() do
			local region = select(i, self:GetRegions())
			if region and region.IsObjectType and region:IsObjectType("Texture") then
				if kill and type(kill) == "boolean" then
					F.HideObject(region)
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

-- [[ Variable and module handling ]]

C.themes = {}
C.themes["AuroraClassic"] = {}
C.login = {}

-- [[ Initialize addon ]]

local Skin = CreateFrame("Frame")
Skin:RegisterEvent("ADDON_LOADED")
Skin:RegisterEvent("PLAYER_LOGIN")
Skin:RegisterEvent("PLAYER_LOGOUT")
Skin:SetScript("OnEvent", function(_, event, addon)
	if event == "ADDON_LOADED" then
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

		-- check if the addon loaded is supported by AuroraClassic, and if it is, execute its module
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
	elseif event == "PLAYER_LOGIN" then
		for index, func in pairs(C.login) do
			if IsAddOnLoaded(index) then
				func()
			end
		end
	else
		AuroraConfig.uiScale = UIParent:GetScale()
	end
end)