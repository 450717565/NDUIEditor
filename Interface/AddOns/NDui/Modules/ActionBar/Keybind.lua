local _, ns = ...
local B, C, L, DB = unpack(ns)
local AB = B:GetModule("ActionBar")

local _G = _G
local pairs, tonumber, print, strfind, strupper = pairs, tonumber, print, strfind, strupper
local InCombatLockdown = InCombatLockdown
local GetSpellBookItemName, GetMacroInfo = GetSpellBookItemName, GetMacroInfo
local IsAltKeyDown, IsControlKeyDown, IsShiftKeyDown = IsAltKeyDown, IsControlKeyDown, IsShiftKeyDown
local GetBindingKey, GetBindingName, SetBinding, SaveBindings, LoadBindings = GetBindingKey, GetBindingName, SetBinding, SaveBindings, LoadBindings
local MAX_ACCOUNT_MACROS = MAX_ACCOUNT_MACROS
local NOT_BOUND, PRESS_KEY_TO_BIND, QUICK_KEYBIND_DESCRIPTION = NOT_BOUND, PRESS_KEY_TO_BIND, QUICK_KEYBIND_DESCRIPTION
local cr, cg, cb = DB.cr, DB.cg, DB.cb

-- Button types
local function hookActionButton(self)
	local pet = self.commandName and strfind(self.commandName, "^BONUSACTION") and "PET"
	local stance = self.commandName and strfind(self.commandName, "^SHAPESHIFT") and "STANCE"
	AB:Bind_Update(self, pet or stance or nil)
end
local function hookMacroButton(self)
	AB:Bind_Update(self, "MACRO")
end
local function hookSpellButton(self)
	AB:Bind_Update(self, "SPELL")
end

function AB:Bind_RegisterButton(button)
	if button.IsProtected and button.IsObjectType and button:IsObjectType("CheckButton") and button:IsProtected() then
		button:HookScript("OnEnter", hookActionButton)
	end
end

function AB:Bind_RegisterMacro()
	if self ~= "Blizzard_MacroUI" then return end

	for i = 1, MAX_ACCOUNT_MACROS do
		local button = _G["MacroButton"..i]
		button:HookScript("OnEnter", hookMacroButton)
	end
end

function AB:Bind_Create()
	if AB.keybindFrame then return end

	local frame = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
	frame:SetFrameStrata("DIALOG")
	frame:EnableMouse(true)
	frame:EnableKeyboard(true)
	frame:EnableMouseWheel(true)
	B.CreateBD(frame)
	frame:SetBackdropColor(cr, cg, cb, .5)
	frame:SetBackdropBorderColor(cr, cg, cb)
	frame:Hide()

	frame:SetScript("OnEnter", function()
		GameTooltip:SetOwner(frame, "ANCHOR_NONE")
		GameTooltip:SetPoint("BOTTOM", frame, "TOP", 0, 2)
		GameTooltip:AddLine(frame.tipName or frame.name, .6,.8,1)

		if #frame.bindings == 0 then
			GameTooltip:AddLine(NOT_BOUND, 1,0,0)
			GameTooltip:AddLine(PRESS_KEY_TO_BIND)
		else
			GameTooltip:AddDoubleLine(L["KeyIndex"], L["KeyBinding"], .6,.6,.6, .6,.6,.6)
			for i = 1, #frame.bindings do
				GameTooltip:AddDoubleLine(i, frame.bindings[i], 1,1,1, 0,1,0)
			end
			GameTooltip:AddLine(L["UnbindTip"], 1,.8,0, 1)
		end
		GameTooltip:Show()
	end)
	frame:SetScript("OnLeave", AB.Bind_HideFrame)
	frame:SetScript("OnKeyUp", function(_, key) AB:Bind_Listener(key) end)
	frame:SetScript("OnMouseUp", function(_, key) AB:Bind_Listener(key) end)
	frame:SetScript("OnMouseWheel", function(_, delta)
		if delta > 0 then
			AB:Bind_Listener("MOUSEWHEELUP")
		else
			AB:Bind_Listener("MOUSEWHEELDOWN")
		end
	end)

	for _, button in pairs(AB.buttons) do
		AB:Bind_RegisterButton(button)
	end

	for i = 1, 12 do
		local button = _G["SpellButton"..i]
		button:HookScript("OnEnter", hookSpellButton)
	end

	if not IsAddOnLoaded("Blizzard_MacroUI") then
		hooksecurefunc("LoadAddOn", AB.Bind_RegisterMacro)
	else
		AB.Bind_RegisterMacro("Blizzard_MacroUI")
	end

	AB.keybindFrame = frame
end

function AB:Bind_Update(button, spellmacro)
	local frame = AB.keybindFrame
	if not frame.enabled or InCombatLockdown() then return end

	frame.button = button
	frame.spellmacro = spellmacro
	frame:ClearAllPoints()
	frame:SetAllPoints(button)
	frame:Show()

	if spellmacro == "SPELL" then
		frame.id = SpellBook_GetSpellBookSlot(frame.button)
		frame.name = GetSpellBookItemName(frame.id, SpellBookFrame.bookType)
		frame.bindings = {GetBindingKey(spellmacro.." "..frame.name)}
	elseif spellmacro == "MACRO" then
		frame.id = frame.button:GetID()
		local colorIndex = B.Round(select(2, MacroFrameTab1Text:GetTextColor()), 1)
		if colorIndex == .8 then frame.id = frame.id + MAX_ACCOUNT_MACROS end
		frame.name = GetMacroInfo(frame.id)
		frame.bindings = {GetBindingKey(spellmacro.." "..frame.name)}
	elseif spellmacro == "STANCE" or spellmacro == "PET" then
		frame.name = button:GetDebugName()
		if not frame.name then return end
		frame.tipName = button.commandName and GetBindingName(button.commandName)

		frame.id = tonumber(button:GetID())
		if not frame.id or frame.id < 1 or frame.id > (spellmacro == "STANCE" and 10 or 12) then
			frame.bindstring = "CLICK "..frame.name..":LeftButton"
		else
			frame.bindstring = (spellmacro=="STANCE" and "SHAPESHIFTBUTTON" or "BONUSACTIONBUTTON")..frame.id
		end
		frame.bindings = {GetBindingKey(frame.bindstring)}
	else
		frame.name = button:GetDebugName()
		if not frame.name then return end
		frame.tipName = button.commandName and GetBindingName(button.commandName)

		frame.action = tonumber(button.action)
		if button.isCustomButton or not frame.action or frame.action < 1 or frame.action > 168 then
			frame.bindstring = "CLICK "..frame.name..":LeftButton"
		else
			local modact = 1+(frame.action-1)%12
			if frame.name == "ExtraActionButton1" then
				frame.bindstring = "EXTRAACTIONBUTTON1"
			elseif frame.action < 25 or frame.action > 72 then
				frame.bindstring = "ACTIONBUTTON"..modact
			elseif frame.action < 73 and frame.action > 60 then
				frame.bindstring = "MULTIACTIONBAR1BUTTON"..modact
			elseif frame.action < 61 and frame.action > 48 then
				frame.bindstring = "MULTIACTIONBAR2BUTTON"..modact
			elseif frame.action < 49 and frame.action > 36 then
				frame.bindstring = "MULTIACTIONBAR4BUTTON"..modact
			elseif frame.action < 37 and frame.action > 24 then
				frame.bindstring = "MULTIACTIONBAR3BUTTON"..modact
			end
		end
		frame.bindings = {GetBindingKey(frame.bindstring)}
	end

	-- Refresh tooltip
	frame:GetScript("OnEnter")(self)
end

local ignoreKeys = {
	["LALT"] = true,
	["RALT"] = true,
	["LCTRL"] = true,
	["RCTRL"] = true,
	["LSHIFT"] = true,
	["RSHIFT"] = true,
	["UNKNOWN"] = true,
	["LeftButton"] = true,
}

function AB:Bind_Listener(key)
	local frame = AB.keybindFrame
	if key == "ESCAPE" or key == "RightButton" then
		if frame.bindings then
			for i = 1, #frame.bindings do
				SetBinding(frame.bindings[i])
			end
		end
		print(format(L["Clear binds"], frame.tipName or frame.name))

		AB:Bind_Update(frame.button, frame.spellmacro)
		return
	end

	local isKeyIgnore = ignoreKeys[key]
	if isKeyIgnore then return end

	if key == "MiddleButton" then key = "BUTTON3" end
	if strfind(key, "Button%d") then key = strupper(key) end

	local alt = IsAltKeyDown() and "ALT-" or ""
	local ctrl = IsControlKeyDown() and "CTRL-" or ""
	local shift = IsShiftKeyDown() and "SHIFT-" or ""

	if not frame.spellmacro or frame.spellmacro == "PET" or frame.spellmacro == "STANCE" then
		SetBinding(alt..ctrl..shift..key, frame.bindstring)
	else
		SetBinding(alt..ctrl..shift..key, frame.spellmacro.." "..frame.name)
	end
	print((frame.tipName or frame.name).." |cff00ff00"..L["KeyBoundTo"].."|r "..alt..ctrl..shift..key)

	AB:Bind_Update(frame.button, frame.spellmacro)
end

function AB:Bind_HideFrame()
	local frame = AB.keybindFrame
	frame:ClearAllPoints()
	frame:Hide()
	if not GameTooltip:IsForbidden() then GameTooltip:Hide() end
end

function AB:Bind_Activate()
	AB.keybindFrame.enabled = true
	B:RegisterEvent("PLAYER_REGEN_DISABLED", AB.Bind_Deactivate)
end

function AB:Bind_Deactivate(save)
	if save == true then
		SaveBindings(C.db["ActionBar"]["BindType"])
		print(DB.NDuiString.." |cff00ff00"..L["Save keybinds"].."|r")
	else
		LoadBindings(C.db["ActionBar"]["BindType"])
		print(DB.NDuiString.." |cffffff00"..L["Discard keybinds"].."|r")
	end

	AB:Bind_HideFrame()
	AB.keybindFrame.enabled = false
	B:UnregisterEvent("PLAYER_REGEN_DISABLED", AB.Bind_Deactivate)
	AB.keybindDialog:Hide()
end

function AB:Bind_CreateDialog()
	local dialog = AB.keybindDialog
	if dialog then dialog:Show() return end

	local frame = CreateFrame("Frame", nil, UIParent)
	frame:SetSize(320, 100)
	frame:SetPoint("TOP", 0, -135)
	B.CreateBG(frame)
	B.CreateFS(frame, 16, QUICK_KEYBIND_MODE, false, "TOP", 0, -10)

	local helpInfo = B.CreateHelpInfo(frame, "|n"..QUICK_KEYBIND_DESCRIPTION)
	helpInfo:SetPoint("TOPRIGHT", 2, -2)

	local text = B.CreateFS(frame, 14, CHARACTER_SPECIFIC_KEYBINDINGS, "system", "TOP", 0, -40)
	local box = B.CreateCheckBox(frame)
	box:SetChecked(C.db["ActionBar"]["BindType"] == 2)
	box:SetPoint("RIGHT", text, "LEFT", -5, -0)
	box:SetScript("OnClick", function(self)
		C.db["ActionBar"]["BindType"] = self:GetChecked() and 2 or 1
	end)

	local button1 = B.CreateButton(frame, 120, 25, APPLY, 14)
	button1:SetPoint("BOTTOMLEFT", 25, 10)
	button1:SetScript("OnClick", function()
		AB:Bind_Deactivate(true)
	end)
	local button2 = B.CreateButton(frame, 120, 25, CANCEL, 14)
	button2:SetPoint("BOTTOMRIGHT", -25, 10)
	button2:SetScript("OnClick", function()
		AB:Bind_Deactivate()
	end)

	AB.keybindDialog = frame
end

SlashCmdList["NDUI_KEYBIND"] = function()
	--if InCombatLockdown() then UIErrorsFrame:AddMessage(DB.InfoColor..ERR_NOT_IN_COMBAT) return end -- fix by LibShowUIPanel

	AB:Bind_Create()
	AB:Bind_Activate()
	AB:Bind_CreateDialog()
end
SLASH_NDUI_KEYBIND1 = "/bb"