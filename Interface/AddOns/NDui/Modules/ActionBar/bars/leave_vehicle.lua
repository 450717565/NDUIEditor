local _, ns = ...
local B, C, L, DB = unpack(ns)
local Bar = B:GetModule("Actionbar")
local cfg = C.bars.leave_vehicle

function Bar:CreateLeaveVehicle()
	local buttonList = {}
	local layout = NDuiDB["Actionbar"]["Style"]

	--create the frame to hold the buttons
	local frame = CreateFrame("Frame", "NDui_ActionBarExit", UIParent, "SecureHandlerStateTemplate")
	frame:SetSize(cfg.size, cfg.size)
	if layout ~= 4 then
		frame.Pos = {"BOTTOMLEFT", UIParent, "BOTTOM", 288, 108}
	else
		frame.Pos = {"BOTTOMLEFT", UIParent, "BOTTOM", 220, 102}
	end

	--the button
	local button = CreateFrame("CheckButton", "NDui_LeaveVehicleButton", frame, "ActionButtonTemplate, SecureHandlerClickTemplate")
	table.insert(buttonList, button) --add the button object to the list
	button:SetSize(cfg.size, cfg.size)
	button:SetPoint("BOTTOMLEFT", frame, padding, padding)
	button:RegisterForClicks("AnyUp")
	button.icon:SetTexture("INTERFACE\\VEHICLES\\UI-Vehicles-Button-Exit-Up")
	button.icon:SetTexCoord(.25, .80, .22, .78)
	button:SetNormalTexture(nil)
	button:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
	button:GetPushedTexture():SetTexture(DB.textures.pushed)
	B.CreateBGFrame(button)

	local function onClick(self)
		if UnitOnTaxi("player") then TaxiRequestEarlyLanding() else VehicleExit() end
		self:SetChecked(false)
	end
	button:SetScript("OnClick", onClick)
	button:SetScript("OnEnter", MainMenuBarVehicleLeaveButton_OnEnter)
	button:SetScript("OnLeave", B.HideTooltip)

	--frame visibility
	frame.frameVisibility = "[canexitvehicle]c;[mounted]m;n"
	RegisterStateDriver(frame, "exit", frame.frameVisibility)

	frame:SetAttribute("_onstate-exit", [[ if CanExitVehicle() then self:Show() else self:Hide() end ]])
	if not CanExitVehicle() then frame:Hide() end

	--create drag frame and drag functionality
	if C.bars.userplaced then
		frame.mover = B.Mover(frame, L["LeaveVehicle"], "LeaveVehicle", frame.Pos)
	end

	--create the mouseover functionality
	if cfg.fader then
		Bar.CreateButtonFrameFader(frame, buttonList, cfg.fader)
	end
end