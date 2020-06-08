local _, ns = ...
local B, C, L, DB = unpack(ns)
local Bar = B:GetModule("Actionbar")

-- Texture credit: 胡里胡涂
local _G = getfenv(0)
local tinsert, pairs, type = table.insert, pairs, type
local buttonList = {}
local cr, cg, cb, color

function Bar:MicroButton_SetupTexture(icon, texture)
	icon:SetOutside(nil, 3, 3)
	icon:SetTexture(DB.microTex..texture)
	icon:SetVertexColor(cr, cg, cb)
end

function Bar:MicroButton_Create(parent, data)
	local texture, method, tooltip = unpack(data)

	local bu = CreateFrame("Frame", nil, parent)
	tinsert(buttonList, bu)
	bu:SetSize(22, 22)

	local icon = bu:CreateTexture(nil, "ARTWORK")
	Bar:MicroButton_SetupTexture(icon, texture)

	if type(method) == "string" then
		local button = _G[method]
		button:SetHitRectInsets(0, 0, 0, 0)
		button:SetParent(bu)
		button:ClearAllPoints(bu)
		button:SetAllPoints(bu)
		button.SetPoint = B.Dummy
		button:UnregisterAllEvents()
		button:SetNormalTexture(nil)
		button:SetPushedTexture(nil)
		button:SetDisabledTexture(nil)
		if tooltip then B.AddTooltip(button, "ANCHOR_RIGHT", tooltip) end

		local hl = button:GetHighlightTexture()
		Bar:MicroButton_SetupTexture(hl, texture)

		local flash = button.Flash
		Bar:MicroButton_SetupTexture(flash, texture)
	else
		bu:SetScript("OnMouseUp", method)
		B.AddTooltip(bu, "ANCHOR_RIGHT", tooltip)

		local hl = bu:CreateTexture(nil, "HIGHLIGHT")
		hl:SetBlendMode("ADD")
		Bar:MicroButton_SetupTexture(hl, texture)
	end
end

function Bar:MicroMenu_Lines(parent)
	if not NDuiDB["Skins"]["MenuLine"] then return end

	local width, height = parent:GetWidth()*.6, C.mult*2

	local MenuL = CreateFrame("Frame", nil, parent)
	MenuL:SetPoint("TOPRIGHT", parent, "BOTTOM")
	B.CreateGA(MenuL, width, height, "Horizontal", cr, cg, cb, 0, DB.Alpha)
	local MenuR = CreateFrame("Frame", nil, parent)
	MenuR:SetPoint("TOPLEFT", parent, "BOTTOM")
	B.CreateGA(MenuR, width, height, "Horizontal", cr, cg, cb, DB.Alpha, 0)
end

function Bar:MicroMenu()
	if not NDuiDB["Actionbar"]["MicroMenu"] then return end

	cr, cg, cb = DB.r, DB.g, DB.b
	color = NDuiDB["Skins"]["LineColor"]
	if not NDuiDB["Skins"]["ClassLine"] then cr, cg, cb = color.r, color.g, color.b end

	local menubar = CreateFrame("Frame", nil, UIParent)
	menubar:SetSize(323, 22)
	B.Mover(menubar, L["Menubar"], "Menubar", C.Skins.MicroMenuPos)
	Bar:MicroMenu_Lines(menubar)

	-- Generate Buttons
	local buttonInfo = {
		{"player", "CharacterMicroButton"},
		{"spellbook", "SpellbookMicroButton"},
		{"talents", "TalentMicroButton"},
		{"achievements", "AchievementMicroButton"},
		{"quests", "QuestLogMicroButton"},
		{"guild", "GuildMicroButton"},
		{"lfd", "LFDMicroButton"},
		{"encounter", "EJMicroButton"},
		{"collections", "CollectionsMicroButton"},
		{"store", "StoreMicroButton"},
		{"settings", "MainMenuMicroButton", MicroButtonTooltipText(MAINMENU_BUTTON, "TOGGLEGAMEMENU")},
		{"bags", function() ToggleAllBags() end, MicroButtonTooltipText(BAGSLOT, "OPENALLBAGS")},
	}
	for _, info in pairs(buttonInfo) do
		Bar:MicroButton_Create(menubar, info)
	end

	-- Order Positions
	for i = 1, #buttonList do
		if i == 1 then
			buttonList[i]:SetPoint("LEFT")
		else
			buttonList[i]:SetPoint("LEFT", buttonList[i-1], "RIGHT", 5, 0)
		end
	end

	-- Default elements
	B.HideObject(MicroButtonPortrait)
	B.HideObject(GuildMicroButtonTabard)
	B.HideObject(MainMenuBarDownload)
	B.HideObject(HelpOpenWebTicketButton)
	B.HideObject(MainMenuBarPerformanceBar)
	MainMenuMicroButton:SetScript("OnUpdate", nil)

	CharacterMicroButtonAlert:EnableMouse(false)
	B.HideOption(CharacterMicroButtonAlert)
end