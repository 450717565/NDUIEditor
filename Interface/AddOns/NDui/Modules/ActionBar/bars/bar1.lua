local _, ns = ...
local B, C, L, DB = unpack(ns)
local AB = B:RegisterModule("ActionBar")

local _G = _G
local tinsert, next = tinsert, next
local GetActionTexture = GetActionTexture
local cfg = C.Bars.bar1
local margin, padding = C.Bars.margin, C.Bars.padding

local function UpdateActionbarScale(bar)
	local frame = _G["NDui_Action"..bar]
	if not frame then return end

	local size = frame.buttonSize * C.db["ActionBar"]["BarScale"]
	frame:SetFrameSize(size)
	for _, button in pairs(frame.buttonList) do
		button:SetSize(size, size)
		button.Name:SetScale(C.db["ActionBar"]["BarScale"])
		button.Count:SetScale(C.db["ActionBar"]["BarScale"])
		button.HotKey:SetScale(C.db["ActionBar"]["BarScale"])
	end
end

function AB:UpdateAllScale()
	if not C.db["ActionBar"]["Enable"] then return end

	UpdateActionbarScale("Bar1")
	UpdateActionbarScale("Bar2")
	UpdateActionbarScale("Bar3")
	UpdateActionbarScale("Bar4")
	UpdateActionbarScale("Bar5")

	UpdateActionbarScale("BarExit")
	UpdateActionbarScale("BarPet")
	UpdateActionbarScale("BarStance")
end

local function SetFrameSize(frame, size, num)
	size = size or frame.buttonSize
	num = num or frame.numButtons

	frame:SetWidth(num*size + (num-1)*margin + 2*padding)
	frame:SetHeight(size + 2*padding)
	if not frame.mover then
		frame.mover = B.Mover(frame, L["Main ActionBar"], "Bar1", frame.Pos)
	else
		frame.mover:SetSize(frame:GetSize())
	end

	if not frame.SetFrameSize then
		frame.buttonSize = size
		frame.numButtons = num
		frame.SetFrameSize = SetFrameSize
	end
end

function AB:CreateBar1()
	local num = NUM_ACTIONBAR_BUTTONS
	local buttonList = {}
	local layout = C.db["ActionBar"]["BarStyle"]

	local frame = CreateFrame("Frame", "NDui_ActionBar1", UIParent, "SecureHandlerStateTemplate")
	if layout == 5 then
		frame.Pos = {"BOTTOM", UIParent, "BOTTOM", -108, 27}
	else
		frame.Pos = {"BOTTOM", UIParent, "BOTTOM", 0, 27}
	end

	for i = 1, num do
		local button = _G["ActionButton"..i]
		tinsert(buttonList, button)
		tinsert(AB.buttons, button)
		button:SetParent(frame)

		if i == 1 then
			B.UpdatePoint(button, "BOTTOMLEFT", frame, "BOTTOMLEFT", padding, padding)
		else
			B.UpdatePoint(button, "LEFT", _G["ActionButton"..i-1], "RIGHT", margin, 0)
		end
	end

	frame.buttonList = buttonList
	SetFrameSize(frame, cfg.size, num)

	frame.frameVisibility = "[petbattle] hide; show"
	RegisterStateDriver(frame, "visibility", frame.frameVisibility)

	if cfg.fader then
		AB.CreateButtonFrameFader(frame, buttonList, cfg.fader)
	end

	local actionPage = "[bar:6]6;[bar:5]5;[bar:4]4;[bar:3]3;[bar:2]2;[overridebar]14;[shapeshift]13;[vehicleui]12;[possessbar]12;[bonusbar:5]11;[bonusbar:4]10;[bonusbar:3]9;[bonusbar:2]8;[bonusbar:1]7;1"
	local buttonName = "ActionButton"
	for i, button in pairs(buttonList) do
		frame:SetFrameRef(buttonName..i, button)
	end

	frame:Execute(([[
		buttons = table.new()
		for i = 1, %d do
			tinsert(buttons, self:GetFrameRef("%s"..i))
		end
	]]):format(num, buttonName))

	frame:SetAttribute("_onstate-page", [[
		for _, button in pairs(buttons) do
			button:SetAttribute("actionpage", newstate)
		end
	]])
	RegisterStateDriver(frame, "page", actionPage)

	-- Fix button texture
	local function FixActionBarTexture()
		for _, button in pairs(buttonList) do
			local action = button.action
			if action < 120 then break end

			local icon = button.icon
			local texture = GetActionTexture(action)
			if texture then
				icon:SetTexture(texture)
				icon:Show()
			else
				icon:Hide()
			end
			AB.UpdateButtonStatus(button)
		end
	end
	B:RegisterEvent("SPELL_UPDATE_ICON", FixActionBarTexture)
	B:RegisterEvent("UPDATE_VEHICLE_ACTIONBAR", FixActionBarTexture)
	B:RegisterEvent("UPDATE_OVERRIDE_ACTIONBAR", FixActionBarTexture)
end

function AB:OnLogin()
	AB.buttons = {}

	if not C.db["ActionBar"]["Enable"] then return end

	AB:CreateBar1()
	AB:CreateBar2()
	AB:CreateBar3()
	AB:CreateBar4()
	AB:CreateBar5()
	AB:CustomBar()
	AB:CreateExtrabar()
	AB:CreateLeaveVehicle()
	AB:CreatePetBar()
	AB:CreateStanceBar()
	AB:HideBlizz()
	AB:ReskinBars()
	AB:UpdateAllScale()
	AB:MicroMenu()
end