local _, ns = ...
local B, C, L, DB = unpack(ns)
---------------------------
-- rButtonTemplate, zork
---------------------------
local AB = B:GetModule("ActionBar")
local _G = getfenv(0)
local pairs, gsub, unpack = pairs, gsub, unpack
local IsEquippedAction = IsEquippedAction

local cr, cg, cb = DB.cr, DB.cg, DB.cb

local function CallButtonFunctionByName(button, func, ...)
	if button and func and button[func] then
		button[func](button, ...)
	end
end

local function ResetNormalTexture(self, file)
	if not self.__normalTextureFile then return end
	if file == self.__normalTextureFile then return end
	self:SetNormalTexture(self.__normalTextureFile)
end

local function ResetTexture(self, file)
	if not self.__textureFile then return end
	if file == self.__textureFile then return end
	self:SetTexture(self.__textureFile)
end

local function ResetVertexColor(self, r, g, b, a)
	if not self.__vertexColor then return end
	local r2, g2, b2, a2 = unpack(self.__vertexColor)
	if not a2 then a2 = 1 end
	if r ~= r2 or g ~= g2 or b ~= b2 or a ~= a2 then
		self:SetVertexColor(r2, g2, b2, a2)
	end
end

local function ApplyPoints(self, points)
	if not points then return end
	self:ClearAllPoints()
	for _, point in pairs(points) do
		self:SetPoint(unpack(point))
	end
end

local function ApplyTexCoord(texture, texCoord)
	if texture.__lockdown or not texCoord then return end
	texture:SetTexCoord(unpack(texCoord))
end

local function ApplyVertexColor(texture, color)
	if not color then return end
	texture.__vertexColor = color
	texture:SetVertexColor(unpack(color))
	hooksecurefunc(texture, "SetVertexColor", ResetVertexColor)
end

local function ApplyAlpha(region, alpha)
	if not alpha then return end
	region:SetAlpha(alpha)
end

local function ApplyFont(fontString, font)
	if not font then return end
	fontString:SetFont(unpack(font))
end

local function ApplyHorizontalAlign(fontString, align)
	if not align then return end
	fontString:SetJustifyH(align)
end

local function ApplyVerticalAlign(fontString, align)
	if not align then return end
	fontString:SetJustifyV(align)
end

local function ApplyTexture(texture, file)
	if not file then return end
	texture.__textureFile = file
	texture:SetTexture(file)
	hooksecurefunc(texture, "SetTexture", ResetTexture)
end

local function ApplyNormalTexture(button, file)
	if not file then return end
	button.__normalTextureFile = file
	button:SetNormalTexture(file)
	hooksecurefunc(button, "SetNormalTexture", ResetNormalTexture)
end

local function SetupTexture(texture, cfg, func, button)
	if not texture or not cfg then return end
	ApplyTexCoord(texture, cfg.texCoord)
	ApplyPoints(texture, cfg.points)
	ApplyVertexColor(texture, cfg.color)
	ApplyAlpha(texture, cfg.alpha)
	if func == "SetTexture" then
		ApplyTexture(texture, cfg.file)
	elseif func == "SetNormalTexture" then
		ApplyNormalTexture(button, cfg.file)
	elseif cfg.file then
		CallButtonFunctionByName(button, func, cfg.file)
	end
end

local function SetupFontString(fontString, cfg)
	if not fontString or not cfg then return end
	ApplyPoints(fontString, cfg.points)
	ApplyFont(fontString, cfg.font)
	ApplyAlpha(fontString, cfg.alpha)
	ApplyHorizontalAlign(fontString, cfg.halign)
	ApplyVerticalAlign(fontString, cfg.valign)
end

local function SetupCooldown(cooldown, cfg)
	if not cooldown or not cfg then return end
	ApplyPoints(cooldown, cfg.points)
end

local function SetupBackdrop(icon)
	local icbg = B.CreateBDFrame(icon, 0, -C.mult)
	B.CreateBT(icbg)

	icon:SetDrawLayer("ARTWORK")
	icon:GetParent().icbg = icbg
end

local keyButton = gsub(KEY_BUTTON4, "%d", "")
local keyNumpad = gsub(KEY_NUMPAD1, "%d", "")

local replaces = {
	{"("..keyButton..")", "M"},
	{"("..keyNumpad..")", "N"},
	{"(a%-)", "a"},
	{"(c%-)", "c"},
	{"(s%-)", "s"},
	{KEY_BUTTON3, "M3"},
	{KEY_MOUSEWHEELUP, "MU"},
	{KEY_MOUSEWHEELDOWN, "MD"},
	{KEY_SPACE, "Sp"},
	{CAPSLOCK_KEY_TEXT, "CL"},
	{"BUTTON", "M"},
	{"NUMPAD", "N"},
	{"(ALT%-)", "a"},
	{"(CTRL%-)", "c"},
	{"(SHIFT%-)", "s"},
	{"MOUSEWHEELUP", "MU"},
	{"MOUSEWHEELDOWN", "MD"},
	{"SPACE", "Sp"},
}

function AB:UpdateHotKey()
	local hotkey = B.GetObject(self, "HotKey")
	if hotkey and hotkey:IsShown() and not C.db["ActionBar"]["Hotkeys"] then
		hotkey:Hide()
		return
	end

	local text = hotkey:GetText()
	if not text then return end

	for _, value in pairs(replaces) do
		text = gsub(text, value[1], value[2])
	end

	if text == RANGE_INDICATOR then
		hotkey:SetText("")
	else
		hotkey:SetText(DB.MyColor..text.."|r")
	end
end

function AB:HookHotKey(button)
	AB.UpdateHotKey(button)
	if button.UpdateHotkeys then
		hooksecurefunc(button, "UpdateHotkeys", AB.UpdateHotKey)
	end
end

function AB:UpdateEquipItemColor()
	if not self.icbg then return end

	if IsEquippedAction(self.action) then
		self.icbg:SetBackdropBorderColor(0, .7, .1)
	else
		self.icbg:SetBackdropBorderColor(0, 0, 0)
	end
end

function AB:EquipItemColor(button)
	if not button.Update then return end
	hooksecurefunc(button, "Update", AB.UpdateEquipItemColor)
end

function AB:StyleActionButton(button, cfg)
	if not button then return end
	if button.__styled then return end

	local icon = B.GetObject(button, "Icon")
	local name = B.GetObject(button, "Name")
	local count = B.GetObject(button, "Count")
	local flash = B.GetObject(button, "Flash")
	local border = B.GetObject(button, "Border")
	local hotkey = B.GetObject(button, "HotKey")
	local cooldown = B.GetObject(button, "Cooldown")
	local autoCastable = B.GetObject(button, "AutoCastable")
	local flyoutBorder = B.GetObject(button, "FlyoutBorder")
	local flyoutBorderShadow = B.GetObject(button, "FlyoutBorderShadow")

	local normalTexture = button:GetNormalTexture()
	local pushedTexture = button:GetPushedTexture()
	local checkedTexture = button:GetCheckedTexture()
	local highlightTexture = button:GetHighlightTexture()

	--hide stuff
	local floatingBG = B.GetObject(button, "FloatingBG")
	if floatingBG then floatingBG:Hide() end

	local newActionTexture = B.GetObject(button, "NewActionTexture")
	if newActionTexture then newActionTexture:SetTexture("") end

	local keybindHighlight = B.GetObject(button, "QuickKeybindHighlightTexture")
	if keybindHighlight then keybindHighlight:SetOutside(nil, 4, 4) end

	--backdrop
	SetupBackdrop(icon)
	B.ReskinBorder(border, button.icbg)
	--AB:EquipItemColor(button)

	--textures
	SetupTexture(icon, cfg.icon, "SetTexture", icon)
	SetupTexture(flash, cfg.flash, "SetTexture", flash)
	SetupTexture(border, cfg.border, "SetTexture", border)
	SetupTexture(flyoutBorder, cfg.flyoutBorder, "SetTexture", flyoutBorder)
	SetupTexture(flyoutBorderShadow, cfg.flyoutBorderShadow, "SetTexture", flyoutBorderShadow)

	SetupTexture(normalTexture, cfg.normalTexture, "SetNormalTexture", button)
	SetupTexture(pushedTexture, cfg.pushedTexture, "SetPushedTexture", button)
	SetupTexture(checkedTexture, cfg.checkedTexture, "SetCheckedTexture", button)
	SetupTexture(highlightTexture, cfg.highlightTexture, "SetHighlightTexture", button)

	highlightTexture:SetVertexColor(1, 1, 1, .25)
	highlightTexture:SetDrawLayer("HIGHLIGHT")

	pushedTexture:SetVertexColor(0, 1, 1, 1)
	pushedTexture:SetDrawLayer("BACKGROUND")

	checkedTexture:SetVertexColor(1, 1, 1, 1)
	checkedTexture:SetDrawLayer("BACKGROUND")

	--cooldown
	SetupCooldown(cooldown, cfg.cooldown)

	--no clue why but blizzard created count and duration on background layer, need to fix that
	local overlay = B.CreateParentFrame(button)
	if count then
		if C.db["ActionBar"]["Count"] then
			count:SetParent(overlay)
			SetupFontString(count, cfg.count)
		else
			count:Hide()
		end
	end
	if hotkey then
		hotkey:SetParent(overlay)
		AB:HookHotKey(button)
		SetupFontString(hotkey, cfg.hotkey)
	end
	if name then
		if C.db["ActionBar"]["Macro"] then
			name:SetParent(overlay)
			SetupFontString(name, cfg.name)
		else
			name:Hide()
		end
	end

	if autoCastable then
		autoCastable:SetTexCoord(.217, .765, .217, .765)
		autoCastable:SetInside()
	end

	AB:RegisterButtonRange(button)

	button.__styled = true
end

function AB:StyleExtraActionButton(cfg)
	local button = ExtraActionButton1
	if button.__styled then return end

	local style = B.GetObject(button, "style")
	local icon = B.GetObject(button, "Icon")
	local count = B.GetObject(button, "Count")
	local hotkey = B.GetObject(button, "HotKey")
	local cooldown = B.GetObject(button, "Cooldown")
	--local flash = B.GetObject(button, "Flash") --wierd the template has two textures of the same name

	--force it to gain a texture
	button:SetNormalTexture(DB.blankTex)
	button:SetPushedTexture(DB.blankTex)
	button:SetCheckedTexture(DB.blankTex)
	button:SetHighlightTexture(DB.blankTex)

	local normalTexture = button:GetNormalTexture()
	local pushedTexture = button:GetPushedTexture()
	local checkedTexture = button:GetCheckedTexture()
	local highlightTexture = button:GetHighlightTexture()

	--backdrop
	SetupBackdrop(icon)

	--textures
	SetupTexture(icon, cfg.icon, "SetTexture", icon)
	SetupTexture(style, cfg.style, "SetTexture", style)

	SetupTexture(normalTexture, cfg.normalTexture, "SetNormalTexture", button)
	SetupTexture(pushedTexture, cfg.pushedTexture, "SetPushedTexture", button)
	SetupTexture(checkedTexture, cfg.checkedTexture, "SetCheckedTexture", button)
	SetupTexture(highlightTexture, cfg.highlightTexture, "SetHighlightTexture", button)

	highlightTexture:SetVertexColor(1, 1, 1, .25)
	highlightTexture:SetDrawLayer("HIGHLIGHT")

	pushedTexture:SetVertexColor(0, 1, 1, 1)
	pushedTexture:SetDrawLayer("BACKGROUND")

	checkedTexture:SetVertexColor(1, 1, 1, 1)
	checkedTexture:SetDrawLayer("BACKGROUND")

	--cooldown
	SetupCooldown(cooldown, cfg.cooldown)

	--hotkey, count
	local overlay = B.CreateParentFrame(button)
	hotkey:SetParent(overlay)
	AB:HookHotKey(button)
	cfg.hotkey.font = {DB.Font[1], 13, DB.Font[3]}
	SetupFontString(hotkey, cfg.hotkey)

	if C.db["ActionBar"]["Count"] then
		count:SetParent(overlay)
		cfg.count.font = {DB.Font[1], 16, DB.Font[3]}
		SetupFontString(count, cfg.count)
	else
		count:Hide()
	end

	AB:RegisterButtonRange(button)

	button.__styled = true
end

function AB:UpdateStanceHotKey()
	for i = 1, NUM_STANCE_SLOTS do
		_G["StanceButton"..i.."HotKey"]:SetText(GetBindingKey("SHAPESHIFTBUTTON"..i))
		AB:HookHotKey(_G["StanceButton"..i])
	end
end

function AB:StyleAllActionButtons(cfg)
	for i = 1, NUM_ACTIONBAR_BUTTONS do
		AB:StyleActionButton(_G["ActionButton"..i], cfg)
		AB:StyleActionButton(_G["MultiBarBottomLeftButton"..i], cfg)
		AB:StyleActionButton(_G["MultiBarBottomRightButton"..i], cfg)
		AB:StyleActionButton(_G["MultiBarRightButton"..i], cfg)
		AB:StyleActionButton(_G["MultiBarLeftButton"..i], cfg)
		AB:StyleActionButton(_G["NDui_CustomBarButton"..i], cfg)
	end
	for i = 1, 6 do
		AB:StyleActionButton(_G["OverrideActionBarButton"..i], cfg)
	end
	--petbar buttons
	for i = 1, NUM_PET_ACTION_SLOTS do
		AB:StyleActionButton(_G["PetActionButton"..i], cfg)
	end
	--stancebar buttons
	for i = 1, NUM_STANCE_SLOTS do
		AB:StyleActionButton(_G["StanceButton"..i], cfg)
	end
	--possess buttons
	for i = 1, NUM_POSSESS_SLOTS do
		AB:StyleActionButton(_G["PossessButton"..i], cfg)
	end
	--leave vehicle
	AB:StyleActionButton(_G["NDui_LeaveVehicleButton"], cfg)
	--extra action button
	AB:StyleExtraActionButton(cfg)
	--spell flyout
	SpellFlyoutBackgroundEnd:SetTexture("")
	SpellFlyoutHorizontalBackground:SetTexture("")
	SpellFlyoutVerticalBackground:SetTexture("")
	local function checkForFlyoutButtons()
		local i = 1
		local button = _G["SpellFlyoutButton"..i]
		while button and button:IsShown() do
			AB:StyleActionButton(button, cfg)
			i = i + 1
			button = _G["SpellFlyoutButton"..i]
		end
	end
	SpellFlyout:HookScript("OnShow", checkForFlyoutButtons)
end

function AB:ReskinBars()
	local cfg = {
		flash = {file = ""},
		border = {file = ""},
		style = {file = ""},
		flyoutBorder = {file = ""},
		flyoutBorderShadow = {file = ""},
		icon = {
			texCoord = DB.TexCoord,
			points = {
				{"TOPLEFT", C.mult, -C.mult},
				{"BOTTOMRIGHT", -C.mult, C.mult},
			},
		},
		cooldown = {
			points = {
				{"TOPLEFT", C.mult, -C.mult},
				{"BOTTOMRIGHT", -C.mult, C.mult},
			},
		},
		highlightTexture = {
			file = DB.bgTex,
			points = {
				{"TOPLEFT", C.mult, -C.mult},
				{"BOTTOMRIGHT", -C.mult, C.mult},
			},
		},
		normalTexture = {
			file = DB.blankTex,
			points = {
				{"TOPLEFT", 0, 0},
				{"BOTTOMRIGHT", 0, 0},
			},
		},
		pushedTexture = {
			file = DB.bgTex,
			points = {
				{"TOPLEFT", 0, 0},
				{"BOTTOMRIGHT", 0, 0},
			},
		},
		checkedTexture = {
			file = DB.bgTex,
			points = {
				{"TOPLEFT", 0, 0},
				{"BOTTOMRIGHT", 0, 0},
			},
		},
		name = {
			font = DB.Font,
			points = {
				{"BOTTOMLEFT", 0, 0},
				{"BOTTOMRIGHT", 0, 0},
			},
		},
		hotkey = {
			font = DB.Font,
			points = {
				{"TOPRIGHT", 0, 0},
				{"TOPLEFT", 0, 0},
			},
		},
		count = {
			font = DB.Font,
			points = {
				{"BOTTOMRIGHT", 2, 0},
			},
		},
	}

	AB:StyleAllActionButtons(cfg)

	-- Update hotkeys
	hooksecurefunc("PetActionButton_SetHotkeys", AB.UpdateHotKey)
	AB:UpdateStanceHotKey()
	B:RegisterEvent("UPDATE_BINDINGS", AB.UpdateStanceHotKey)
end