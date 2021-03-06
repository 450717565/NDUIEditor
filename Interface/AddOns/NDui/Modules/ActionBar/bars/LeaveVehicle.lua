local _, ns = ...
local B, C, L, DB = unpack(ns)
local AB = B:GetModule("ActionBar")

local _G = _G
local tinsert = tinsert
local cfg = C.Bars.leave_vehicle
local margin, padding = C.Bars.margin, C.Bars.padding

local function SetFrameSize(frame, size, num)
	size = size or frame.buttonSize
	num = num or frame.numButtons

	frame:SetWidth(num*size + (num-1)*margin + 2*padding)
	frame:SetHeight(size + 2*padding)
	if not frame.mover then
		frame.mover = B.Mover(frame, L["LeaveVehicle"], "LeaveVehicle", frame.Pos)
	else
		frame.mover:SetSize(frame:GetSize())
	end

	if not frame.SetFrameSize then
		frame.buttonSize = size
		frame.numButtons = num
		frame.SetFrameSize = SetFrameSize
	end
end

function AB:CreateLeaveVehicle()
	local num = 1
	local buttonList = {}
	local layout = C.db["ActionBar"]["BarStyle"]

	local frame = CreateFrame("Frame", "NDui_ActionBarExit", UIParent, "SecureHandlerStateTemplate")
	if layout == 4 then
		frame.Pos = {"BOTTOMLEFT", _G.ActionButton12, "BOTTOMRIGHT", 0, -margin}
	else
		frame.Pos = {"BOTTOMRIGHT", _G.MultiBarBottomRightButton9, "TOPRIGHT", margin, 0}
	end

	local button = CreateFrame("CheckButton", "NDui_LeaveVehicleButton", frame, "ActionButtonTemplate, SecureHandlerClickTemplate")
	tinsert(buttonList, button)
	button:SetPoint("BOTTOMLEFT", frame, padding, padding)
	button:RegisterForClicks("AnyUp")
	button.icon:SetTexture("INTERFACE\\VEHICLES\\UI-Vehicles-Button-Exit-Up")
	button.icon:SetTexCoord(.216, .784, .216, .784)
	button.icon.__lockdown = true

	button:SetScript("OnEnter", MainMenuBarVehicleLeaveButton_OnEnter)
	button:SetScript("OnLeave", B.HideTooltip)
	button:SetScript("OnClick", function(self)
		if UnitOnTaxi("player") then TaxiRequestEarlyLanding() else VehicleExit() end
		self:SetChecked(true)
	end)
	button:SetScript("OnShow", function(self)
		self:SetChecked(false)
	end)

	frame.buttonList = buttonList
	SetFrameSize(frame, cfg.size, num)

	frame.frameVisibility = "[canexitvehicle]c;[mounted]m;n"
	RegisterStateDriver(frame, "exit", frame.frameVisibility)

	frame:SetAttribute("_onstate-exit", [[ if CanExitVehicle() then self:Show() else self:Hide() end ]])
	if not CanExitVehicle() then frame:Hide() end

	if cfg.fader then
		AB.CreateButtonFrameFader(frame, buttonList, cfg.fader)
	end
end