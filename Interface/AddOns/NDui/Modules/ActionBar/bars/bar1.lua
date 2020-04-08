local _, ns = ...
local B, C, L, DB = unpack(ns)
local Bar = B:RegisterModule("Actionbar")
local cfg = C.bars.bar1

local function UpdateActionbarScale(bar)
	local frame = _G["NDui_Action"..bar]
	frame:SetScale(NDuiDB["Actionbar"]["Scale"])
	frame.mover:SetScale(NDuiDB["Actionbar"]["Scale"])
end

function Bar:UpdateAllScale()
	if not NDuiDB["Actionbar"]["Enable"] then return end

	UpdateActionbarScale("Bar1")
	UpdateActionbarScale("Bar2")
	UpdateActionbarScale("Bar3")
	UpdateActionbarScale("Bar4")
	UpdateActionbarScale("Bar5")

	UpdateActionbarScale("BarExtra")
	UpdateActionbarScale("BarZone")
	UpdateActionbarScale("BarExit")
	UpdateActionbarScale("BarPet")
	UpdateActionbarScale("BarStance")
end

function Bar:OnLogin()
	if not NDuiDB["Actionbar"]["Enable"] then return end

	local padding, margin = 2, 2
	local num = NUM_ACTIONBAR_BUTTONS
	local buttonList = {}
	local layout = NDuiDB["Actionbar"]["Style"]

	--create the frame to hold the buttons
	local frame = CreateFrame("Frame", "NDui_ActionBar1", UIParent, "SecureHandlerStateTemplate")
	frame:SetWidth(num*cfg.size + (num-1)*margin + 2*padding)
	frame:SetHeight(cfg.size + 2*padding)
	if layout == 5 then
		frame.Pos = {"BOTTOM", UIParent, "BOTTOM", -108, 27}
	else
		frame.Pos = {"BOTTOM", UIParent, "BOTTOM", 0, 27}
	end

	for i = 1, num do
		local button = _G["ActionButton"..i]
		table.insert(buttonList, button) --add the button object to the list
		button:SetParent(frame)
		button:SetSize(cfg.size, cfg.size)
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint("LEFT", frame, padding, 0)
		else
			local previous = _G["ActionButton"..i-1]
			button:SetPoint("LEFT", previous, "RIGHT", margin, 0)
		end
	end

	--show/hide the frame on a given state driver
	frame.frameVisibility = "[petbattle] hide; show"
	RegisterStateDriver(frame, "visibility", frame.frameVisibility)

	--create drag frame and drag functionality
	if C.bars.userplaced then
		frame.mover = B.Mover(frame, L["Main Actionbar"], "Bar1", frame.Pos)
	end

	--create the mouseover functionality
	if cfg.fader then
		Bar.CreateButtonFrameFader(frame, buttonList, cfg.fader)
	end

	--_onstate-page state driver
	local actionPage = "[bar:6]6;[bar:5]5;[bar:4]4;[bar:3]3;[bar:2]2;[overridebar]14;[shapeshift]13;[vehicleui]12;[possessbar]12;[bonusbar:5]11;[bonusbar:4]10;[bonusbar:3]9;[bonusbar:2]8;[bonusbar:1]7;1"
	local buttonName = "ActionButton"
	for i, button in next, buttonList do
		frame:SetFrameRef(buttonName..i, button)
	end

	frame:Execute(([[
		buttons = table.new()
		for i = 1, %d do
			table.insert(buttons, self:GetFrameRef("%s"..i))
		end
	]]):format(num, buttonName))

	frame:SetAttribute("_onstate-page", [[
		for _, button in next, buttons do
			button:SetAttribute("actionpage", newstate)
		end
	]])
	RegisterStateDriver(frame, "page", actionPage)

	--add elements
	self:CreateBar2()
	self:CreateBar3()
	self:CreateBar4()
	self:CreateBar5()
	self:CreateExtrabar()
	self:CreateLeaveVehicle()
	self:CreatePetbar()
	self:CreateStancebar()
	self:HideBlizz()
	self:ReskinBars()
	self:UpdateAllScale()
	self:CreateBackground()
	self:MicroMenu()

	--vehicle fix
	local function getActionTexture(button)
		return GetActionTexture(button.action)
	end

	B:RegisterEvent("UPDATE_VEHICLE_ACTIONBAR", function()
		for _, button in next, buttonList do
			local icon = button.icon
			local texture = getActionTexture(button)
			if texture then
				icon:SetTexture(texture)
				icon:Show()
			else
				icon:Hide()
			end
		end
	end)
end

function Bar:CreateBackground()
	if not NDuiDB["Skins"]["BarLine"] then return end
	if NDuiDB["Actionbar"]["Style"] == 5 then return end

	local color = NDuiDB["Skins"]["LineColor"]
	local cr, cg, cb = DB.r, DB.g, DB.b
	if not NDuiDB["Skins"]["ClassLine"] then cr, cg, cb = color.r, color.g, color.b end

	local relativeTo = NDui_ActionBar2
	if NDuiDB["Actionbar"]["Style"] == 4 then relativeTo = NDui_ActionBar3 end

	-- ACTIONBAR
	local ActionBarL = CreateFrame("Frame", nil, UIParent)
	ActionBarL:SetPoint("BOTTOMRIGHT", relativeTo, "TOP")
	B.CreateGA(ActionBarL, 260, C.mult*2, "Horizontal", cr, cg, cb, 0, DB.Alpha)
	RegisterStateDriver(ActionBarL, "visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; show")
	local ActionBarR = CreateFrame("Frame", nil, UIParent)
	ActionBarR:SetPoint("BOTTOMLEFT", relativeTo, "TOP")
	B.CreateGA(ActionBarR, 260, C.mult*2, "Horizontal", cr, cg, cb, DB.Alpha, 0)
	RegisterStateDriver(ActionBarR, "visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; show")

	-- OVERRIDEBAR
	local OverBarL = CreateFrame("Frame", nil, UIParent)
	OverBarL:SetPoint("BOTTOMRIGHT", NDui_ActionBar1, "TOP")
	B.CreateGA(OverBarL, 260, C.mult*2, "Horizontal", cr, cg, cb, 0, DB.Alpha)
	RegisterStateDriver(OverBarL, "visibility", "[petbattle] hide; [overridebar][vehicleui][possessbar,@vehicle,exists] show; hide")
	local OverBarR = CreateFrame("Frame", nil, UIParent)
	OverBarR:SetPoint("BOTTOMLEFT", NDui_ActionBar1, "TOP")
	B.CreateGA(OverBarR, 260, C.mult*2, "Horizontal", cr, cg, cb, DB.Alpha, 0)
	RegisterStateDriver(OverBarR, "visibility", "[petbattle] hide; [overridebar][vehicleui][possessbar,@vehicle,exists] show; hide")

	-- BOTTOMLINE
	local BarLineL = CreateFrame("Frame", nil, UIParent)
	BarLineL:SetPoint("TOPRIGHT", NDui_ActionBar1, "BOTTOM")
	B.CreateGA(BarLineL, 260, C.mult*2, "Horizontal", cr, cg, cb, 0, DB.Alpha)
	local BarLineR = CreateFrame("Frame", nil, UIParent)
	BarLineR:SetPoint("TOPLEFT", NDui_ActionBar1, "BOTTOM")
	B.CreateGA(BarLineR, 260, C.mult*2, "Horizontal", cr, cg, cb, DB.Alpha, 0)
end