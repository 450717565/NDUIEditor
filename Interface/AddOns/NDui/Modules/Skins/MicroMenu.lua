local _, ns = ...
local B, C, L, DB = unpack(ns)
local S = B:GetModule("Skins")

local _G = getfenv(0)
local tinsert, pairs, type = table.insert, pairs, type
local buttonList = {}
local cr, cg, cb, alpha, color

function S:MicroButton_SetupTexture(icon, texcoord, texture)
	if texture == "encounter" then
		icon:SetPoint("TOPLEFT", 2, -2)
		icon:SetPoint("BOTTOMRIGHT", -2, 3)
	else
		icon:SetAllPoints()
	end
	icon:SetTexture(DB.microTex..texture)
	icon:SetTexCoord(unpack(texcoord))
	icon:SetVertexColor(cr, cg, cb)
end

function S:MicroButton_Create(parent, data)
	local texture, texcoord, method, tooltip = unpack(data)

	local bu = CreateFrame("Frame", nil, parent)
	tinsert(buttonList, bu)
	bu:SetSize(22, 22)

	local icon = bu:CreateTexture(nil, "ARTWORK")
	S:MicroButton_SetupTexture(icon, texcoord, texture)

	if type(method) == "string" then
		local button = _G[method]
		button:SetHitRectInsets(0, 0, 0, 0)
		button:SetParent(bu)
		button:ClearAllPoints(bu)
		button:SetAllPoints(bu)
		if not NDuiDB["Actionbar"]["Enable"] then button.SetPoint = B.Dummy end
		button:UnregisterAllEvents()
		button:SetNormalTexture(nil)
		button:SetPushedTexture(nil)
		button:SetDisabledTexture(nil)
		if tooltip then B.AddTooltip(button, "ANCHOR_RIGHT", tooltip) end

		local hl = button:GetHighlightTexture()
		S:MicroButton_SetupTexture(hl, texcoord, texture)

		local flash = button.Flash
		S:MicroButton_SetupTexture(flash, texcoord, texture)
	else
		bu:SetScript("OnMouseUp", method)
		B.AddTooltip(bu, "ANCHOR_TOP", tooltip)

		local hl = bu:CreateTexture(nil, "HIGHLIGHT")
		S:MicroButton_SetupTexture(hl, texcoord, texture)
	end
end

function S:MicroMenu()
	if not NDuiDB["Skins"]["MicroMenu"] then return end

	cr, cg, cb = DB.r, DB.g, DB.b
	alpha = NDuiDB["Extras"]["SkinAlpha"]
	color = NDuiDB["Extras"]["SkinColor"]
	if not NDuiDB["Skins"]["ClassLine"] then cr, cg, cb = color.r, color.g, color.b end

	local menubar = CreateFrame("Frame", nil, UIParent)
	menubar:SetSize(319, 22)
	B.Mover(menubar, L["Menubar"], "Menubar", C.Skins.MicroMenuPos)

	-- Generate Buttons
	local buttonInfo = {
		{"player", {51/256, 141/256, 86/256, 173/256}, "CharacterMicroButton"},
		{"spellbook", {83/256, 173/256, 86/256, 173/256}, "SpellbookMicroButton"},
		{"talents", {83/256, 173/256, 86/256, 173/256}, "TalentMicroButton"},
		{"achievements", {83/256, 173/256, 83/256, 173/256}, "AchievementMicroButton"},
		{"quests", {83/256, 173/256, 80/256, 167/256}, "QuestLogMicroButton"},
		{"guild", {83/256, 173/256, 80/256, 167/256}, "GuildMicroButton"},
		{"lfd", {83/256, 173/256, 83/256, 173/256}, "LFDMicroButton"},
		{"encounter", {83/256, 173/256, 83/256, 173/256}, "EJMicroButton"},
		{"pets", {83/256, 173/256, 83/256, 173/256}, "CollectionsMicroButton"},
		{"store", {83/256, 173/256, 83/256, 173/256}, "StoreMicroButton"},
		{"settings", {83/256, 173/256, 83/256, 173/256}, "MainMenuMicroButton", MicroButtonTooltipText(MAINMENU_BUTTON, "TOGGLEGAMEMENU")},
		{"bags", {47/256, 137/256, 83/256, 173/256}, ToggleAllBags, MicroButtonTooltipText(BAGSLOT, "OPENALLBAGS")},
	}
	for _, info in pairs(buttonInfo) do
		S:MicroButton_Create(menubar, info)
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
	MainMenuMicroButton:SetScript("OnUpdate", nil)

	CharacterMicroButtonAlert:EnableMouse(false)
	B.HideOption(CharacterMicroButtonAlert)

	-- Menu Line
	if NDuiDB["Skins"]["MenuLine"] then
		local MenuL = CreateFrame("Frame", nil, UIParent)
		MenuL:SetPoint("TOPRIGHT", menubar, "BOTTOM")
		B.CreateGF(MenuL, 200, C.mult*2, "Horizontal", cr, cg, cb, 0, alpha)
		local MenuR = CreateFrame("Frame", nil, UIParent)
		MenuR:SetPoint("TOPLEFT", menubar, "BOTTOM")
		B.CreateGF(MenuR, 200, C.mult*2, "Horizontal", cr, cg, cb, alpha, 0)
	end
end