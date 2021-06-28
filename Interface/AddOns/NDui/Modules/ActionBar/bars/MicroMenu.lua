local _, ns = ...
local B, C, L, DB = unpack(ns)
local Bar = B:GetModule("ActionBar")

-- Texture credit: 胡里胡涂
local _G = getfenv(0)
local tinsert, pairs, type = table.insert, pairs, type
local buttonList = {}
local cr, cg, cb, color

local function ResetButtonParent(button, parent)
	if parent ~= button.__owner then
		button:SetParent(button.__owner)
	end
end

local function ResetButtonAnchor(button)
	button:ClearAllPoints()
	button:SetAllPoints()
end

function Bar:MicroButton_SetupTexture(icon, texture)
	icon:SetOutside(nil, 3, 3)
	icon:SetTexture(DB.menuTex..texture)
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
		button.__owner = bu

		button:SetParent(bu)
		hooksecurefunc(button, "SetParent", ResetButtonParent)

		ResetButtonAnchor(button)
		hooksecurefunc(button, "SetPoint", ResetButtonAnchor)

		button:SetHitRectInsets(0, 0, 0, 0)
		button:UnregisterAllEvents()
		button:SetNormalTexture("")
		button:SetPushedTexture("")
		button:SetDisabledTexture("")
		if tooltip then B.AddTooltip(button, "ANCHOR_TOP", tooltip) end

		local hl = button:GetHighlightTexture()
		Bar:MicroButton_SetupTexture(hl, texture)

		local flash = button.Flash
		Bar:MicroButton_SetupTexture(flash, texture)
	else
		bu:SetScript("OnMouseUp", method)
		B.AddTooltip(bu, "ANCHOR_TOP", tooltip)

		local hl = bu:CreateTexture(nil, "HIGHLIGHT")
		hl:SetBlendMode("ADD")
		Bar:MicroButton_SetupTexture(hl, texture)
	end
end

function Bar:MicroMenu_Lines(parent)
	if not C.db["Skins"]["MenuLine"] then return end

	local width = B.Round(parent:GetWidth()*.6)
	local height = B.Round(parent:GetHeight()*.9)
	local anchors = {
		["LEFT"] = {C.alpha, 0},
		["RIGHT"] = {0, C.alpha}
	}
	for anchor, v in pairs(anchors) do
		local frame = CreateFrame("Frame", nil, parent)
		frame:SetPoint(anchor, parent, "CENTER", 0, 0)
		frame:SetSize(width, height)
		frame:SetFrameStrata("BACKGROUND")

		local bottomLine = B.CreateGA(frame, "H", cr, cg, cb, v[1], v[2], width, C.mult*2)
		bottomLine:SetPoint("TOP"..anchor, frame, "BOTTOM"..anchor, 0, 0)
		local topLine = B.CreateGA(frame, "H", cr, cg, cb, v[1], v[2], width, C.mult*2)
		topLine:SetPoint("BOTTOM"..anchor, frame, "TOP"..anchor, 0, 0)
	end
end

function Bar:MicroMenu()
	if not C.db["ActionBar"]["MicroMenu"] then return end

	cr, cg, cb = DB.cr, DB.cg, DB.cb
	color = C.db["Skins"]["LineColor"]
	if not C.db["Skins"]["ClassLine"] then cr, cg, cb = color.r, color.g, color.b end

	local menubar = CreateFrame("Frame", nil, UIParent)
	menubar:SetSize(323, 22)
	B.Mover(menubar, L["Menubar"], "Menubar", C.Skins.MicroMenuPos)
	Bar:MicroMenu_Lines(menubar)

	-- Generate Buttons
	local buttonInfo = {
		{"character", "CharacterMicroButton"},
		{"spellbook", "SpellbookMicroButton"},
		{"talent", "TalentMicroButton"},
		{"achievement", "AchievementMicroButton"},
		{"questlog", "QuestLogMicroButton"},
		{"guild", "GuildMicroButton"},
		{"lfd", "LFDMicroButton"},
		{"encounter", "EJMicroButton"},
		{"collections", "CollectionsMicroButton"},
		{"store", "StoreMicroButton"},
		{"mainmenu", "MainMenuMicroButton", MicroButtonTooltipText(MAINMENU_BUTTON, "TOGGLEGAMEMENU")},
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
end