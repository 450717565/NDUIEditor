local _, ns = ...
local B, C, L, DB = unpack(ns)
---------------------------
-- rButtonTemplate, zork
---------------------------
local Bar = B:GetModule("ActionBar")
local _G = getfenv(0)
local pairs, gsub = pairs, string.gsub

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
	for _, point in next, points do
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
	icon.icbg = icbg
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

function Bar:UpdateHotKey()
	local hotkey = _G[self:GetDebugName().."HotKey"]
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
		hotkey:SetText(text)
	end
end

function Bar:HookHotKey(button)
	Bar.UpdateHotKey(button)
	if button.UpdateHotkeys then
		hooksecurefunc(button, "UpdateHotkeys", Bar.UpdateHotKey)
	end
end

function Bar:StyleActionButton(button, cfg)
	if not button then return end
	if button.__styled then return end

	local buttonName = button:GetDebugName()
	local icon = _G[buttonName.."Icon"]
	local name = _G[buttonName.."Name"]
	local count = _G[buttonName.."Count"]
	local flash = _G[buttonName.."Flash"]
	local border = _G[buttonName.."Border"]
	local hotkey = _G[buttonName.."HotKey"]
	local cooldown = _G[buttonName.."Cooldown"]
	local autoCastable = _G[buttonName.."AutoCastable"]
	local flyoutBorder = _G[buttonName.."FlyoutBorder"]
	local flyoutBorderShadow = _G[buttonName.."FlyoutBorderShadow"]

	local normalTexture = button:GetNormalTexture()
	local pushedTexture = button:GetPushedTexture()
	local highlightTexture = button:GetHighlightTexture()

	--normal buttons do not have a checked texture, but checkbuttons do and normal actionbuttons are checkbuttons
	local checkedTexture = nil
	if button.GetCheckedTexture then checkedTexture = button:GetCheckedTexture() end

	--hide stuff
	local floatingBG = _G[buttonName.."FloatingBG"]
	if floatingBG then floatingBG:Hide() end

	local newActionTexture = button.NewActionTexture
	if newActionTexture then newActionTexture:SetTexture("") end

	--backdrop
	SetupBackdrop(icon)
	B.ReskinBorder(border, icon.icbg)

	--textures
	SetupTexture(icon, cfg.icon, "SetTexture", icon)
	SetupTexture(flash, cfg.flash, "SetTexture", flash)
	SetupTexture(flyoutBorder, cfg.flyoutBorder, "SetTexture", flyoutBorder)
	SetupTexture(flyoutBorderShadow, cfg.flyoutBorderShadow, "SetTexture", flyoutBorderShadow)
	--SetupTexture(border, cfg.border, "SetTexture", border)

	SetupTexture(normalTexture, cfg.normalTexture, "SetNormalTexture", button)
	SetupTexture(pushedTexture, cfg.pushedTexture, "SetPushedTexture", button)
	SetupTexture(checkedTexture, cfg.checkedTexture, "SetCheckedTexture", button)
	SetupTexture(highlightTexture, cfg.highlightTexture, "SetHighlightTexture", button)

	highlightTexture:SetColorTexture(1, 1, 1, .25)

	--cooldown
	SetupCooldown(cooldown, cfg.cooldown)

	--no clue why but blizzard created count and duration on background layer, need to fix that
	local overlay = CreateFrame("Frame", nil, button)
	overlay:SetAllPoints()
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
		Bar:HookHotKey(button)
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

	Bar:RegisterButtonRange(button)

	button.__styled = true
end

function Bar:StyleExtraActionButton(cfg)
	local button = ExtraActionButton1
	if button.__styled then return end

	local buttonName = button:GetDebugName()
	local buttonstyle = button.style --artwork around the button
	local icon = _G[buttonName.."Icon"]
	local count = _G[buttonName.."Count"]
	local hotkey = _G[buttonName.."HotKey"]
	local cooldown = _G[buttonName.."Cooldown"]
	--local flash = _G[buttonName.."Flash"] --wierd the template has two textures of the same name

	button:SetPushedTexture(DB.pushed) --force it to gain a texture
	local checkedTexture = button:GetCheckedTexture()
	local normalTexture = button:GetNormalTexture()
	local pushedTexture = button:GetPushedTexture()
	local highlightTexture = button:GetHighlightTexture()

	--backdrop
	SetupBackdrop(icon)

	--textures
	SetupTexture(icon, cfg.icon, "SetTexture", icon)
	SetupTexture(buttonstyle, cfg.buttonstyle, "SetTexture", buttonstyle)

	SetupTexture(normalTexture, cfg.normalTexture, "SetNormalTexture", button)
	SetupTexture(pushedTexture, cfg.pushedTexture, "SetPushedTexture", button)
	SetupTexture(checkedTexture, cfg.checkedTexture, "SetCheckedTexture", button)
	SetupTexture(highlightTexture, cfg.highlightTexture, "SetHighlightTexture", button)

	highlightTexture:SetColorTexture(1, 1, 1, .25)

	--cooldown
	SetupCooldown(cooldown, cfg.cooldown)

	--hotkey, count
	local overlay = CreateFrame("Frame", nil, button)
	overlay:SetAllPoints()

	hotkey:SetParent(overlay)
	Bar:HookHotKey(button)
	cfg.hotkey.font = {DB.Font[1], 13, DB.Font[3]}
	SetupFontString(hotkey, cfg.hotkey)

	if C.db["ActionBar"]["Count"] then
		count:SetParent(overlay)
		cfg.count.font = {DB.Font[1], 16, DB.Font[3]}
		SetupFontString(count, cfg.count)
	else
		count:Hide()
	end

	Bar:RegisterButtonRange(button)

	button.__styled = true
end

function Bar:UpdateStanceHotKey()
	for i = 1, NUM_STANCE_SLOTS do
		_G["StanceButton"..i.."HotKey"]:SetText(GetBindingKey("SHAPESHIFTBUTTON"..i))
		Bar:HookHotKey(_G["StanceButton"..i])
	end
end

function Bar:StyleAllActionButtons(cfg)
	for i = 1, NUM_ACTIONBAR_BUTTONS do
		Bar:StyleActionButton(_G["ActionButton"..i], cfg)
		Bar:StyleActionButton(_G["MultiBarBottomLeftButton"..i], cfg)
		Bar:StyleActionButton(_G["MultiBarBottomRightButton"..i], cfg)
		Bar:StyleActionButton(_G["MultiBarRightButton"..i], cfg)
		Bar:StyleActionButton(_G["MultiBarLeftButton"..i], cfg)
		Bar:StyleActionButton(_G["NDui_CustomBarButton"..i], cfg)
	end
	for i = 1, 6 do
		Bar:StyleActionButton(_G["OverrideActionBarButton"..i], cfg)
	end
	--petbar buttons
	for i = 1, NUM_PET_ACTION_SLOTS do
		Bar:StyleActionButton(_G["PetActionButton"..i], cfg)
	end
	--stancebar buttons
	for i = 1, NUM_STANCE_SLOTS do
		Bar:StyleActionButton(_G["StanceButton"..i], cfg)
	end
	--possess buttons
	for i = 1, NUM_POSSESS_SLOTS do
		Bar:StyleActionButton(_G["PossessButton"..i], cfg)
	end
	--leave vehicle
	Bar:StyleActionButton(_G["NDui_LeaveVehicleButton"], cfg)
	--extra action button
	Bar:StyleExtraActionButton(cfg)
	--spell flyout
	SpellFlyoutBackgroundEnd:SetTexture("")
	SpellFlyoutHorizontalBackground:SetTexture("")
	SpellFlyoutVerticalBackground:SetTexture("")
	local function checkForFlyoutButtons()
		local i = 1
		local button = _G["SpellFlyoutButton"..i]
		while button and button:IsShown() do
			Bar:StyleActionButton(button, cfg)
			i = i + 1
			button = _G["SpellFlyoutButton"..i]
		end
	end
	SpellFlyout:HookScript("OnShow", checkForFlyoutButtons)
end

function Bar:ReskinBars()
	local cfg = {
		border = {file = ""},
		buttonstyle = {file = ""},
		flash = {file = DB.flash},
		flyoutBorder = {file = ""},
		flyoutBorderShadow = {file = ""},
		icon = {
			texCoord = DB.TexCoord,
			points = {
				{"TOPLEFT", C.mult, -C.mult},
				{"BOTTOMRIGHT", -C.mult, C.mult},
			},
		},
		normalTexture = {
			file = DB.normal,
			texCoord = DB.TexCoord,
			points = {
				{"TOPLEFT", C.mult, -C.mult},
				{"BOTTOMRIGHT", -C.mult, C.mult},
			},
		},
		pushedTexture = {
			file = DB.pushed,
			points = {
				{"TOPLEFT", C.mult, -C.mult},
				{"BOTTOMRIGHT", -C.mult, C.mult},
			},
		},
		checkedTexture = {
			file = DB.checked,
			points = {
				{"TOPLEFT", C.mult, -C.mult},
				{"BOTTOMRIGHT", -C.mult, C.mult},
			},
		},
		highlightTexture = {
			file = DB.backgroundTex,
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

	Bar:StyleAllActionButtons(cfg)

	-- Update hotkeys
	hooksecurefunc("PetActionButton_SetHotkeys", Bar.UpdateHotKey)
	Bar:UpdateStanceHotKey()
	B:RegisterEvent("UPDATE_BINDINGS", Bar.UpdateStanceHotKey)
end