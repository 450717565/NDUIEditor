local _, ns = ...
local B, C, L, DB = unpack(ns)
local S = B:RegisterModule("Skins")

function S:OnLogin()
	local alpha = NDuiDB["Extras"]["SkinAlpha"]
	local color = NDuiDB["Extras"]["SkinColor"]
	local cr, cg, cb = DB.r, DB.g, DB.b
	if not NDuiDB["Skins"]["ClassLine"] then cr, cg, cb = color.r, color.g, color.b end

	-- ACTIONBAR
	if NDuiDB["Actionbar"]["Enable"] and  NDuiDB["Skins"]["BarLine"] and NDuiDB["Actionbar"]["Style"] ~= 5 then
		local relativeTo = NDui_ActionBar2
		if NDuiDB["Actionbar"]["Style"] == 4 then relativeTo = NDui_ActionBar3 end

		-- ACTIONBAR
		local ActionBarL = CreateFrame("Frame", nil, UIParent)
		ActionBarL:SetPoint("BOTTOMRIGHT", relativeTo, "TOP")
		B.CreateGF(ActionBarL, 260, C.mult*2, "Horizontal", cr, cg, cb, 0, alpha)
		RegisterStateDriver(ActionBarL, "visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; show")
		local ActionBarR = CreateFrame("Frame", nil, UIParent)
		ActionBarR:SetPoint("BOTTOMLEFT", relativeTo, "TOP")
		B.CreateGF(ActionBarR, 260, C.mult*2, "Horizontal", cr, cg, cb, alpha, 0)
		RegisterStateDriver(ActionBarR, "visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; show")

		-- OVERRIDEBAR
		local OverBarL = CreateFrame("Frame", nil, UIParent)
		OverBarL:SetPoint("BOTTOMRIGHT", NDui_ActionBar1, "TOP")
		B.CreateGF(OverBarL, 260, C.mult*2, "Horizontal", cr, cg, cb, 0, alpha)
		RegisterStateDriver(OverBarL, "visibility", "[petbattle] hide; [overridebar][vehicleui][possessbar,@vehicle,exists] show; hide")
		local OverBarR = CreateFrame("Frame", nil, UIParent)
		OverBarR:SetPoint("BOTTOMLEFT", NDui_ActionBar1, "TOP")
		B.CreateGF(OverBarR, 260, C.mult*2, "Horizontal", cr, cg, cb, alpha, 0)
		RegisterStateDriver(OverBarR, "visibility", "[petbattle] hide; [overridebar][vehicleui][possessbar,@vehicle,exists] show; hide")

		-- BOTTOMLINE
		local BarLineL = CreateFrame("Frame", nil, UIParent)
		BarLineL:SetPoint("TOPRIGHT", NDui_ActionBar1, "BOTTOM")
		B.CreateGF(BarLineL, 260, C.mult*2, "Horizontal", cr, cg, cb, 0, alpha)
		local BarLineR = CreateFrame("Frame", nil, UIParent)
		BarLineR:SetPoint("TOPLEFT", NDui_ActionBar1, "BOTTOM")
		B.CreateGF(BarLineR, 260, C.mult*2, "Horizontal", cr, cg, cb, alpha, 0)
	end

	-- Add Skins
	self:MicroMenu()
	self:CreateRM()
	self:QuestTracker()
	self:PetBattleUI()

	self:DBMSkin()
	self:SkadaSkin()
	self:BigWigsSkin()

	-- Register skin
	local media = LibStub and LibStub("LibSharedMedia-3.0", true)
	if media then
		media:Register("statusbar", "Altz01", [[Interface\AddOns\NDui\Media\StatusBar\Altz01]])
		media:Register("statusbar", "Altz02", [[Interface\AddOns\NDui\Media\StatusBar\Altz02]])
		media:Register("statusbar", "Altz03", [[Interface\AddOns\NDui\Media\StatusBar\Altz03]])
		media:Register("statusbar", "Altz04", [[Interface\AddOns\NDui\Media\StatusBar\Altz04]])
		media:Register("statusbar", "MaoR", [[Interface\AddOns\NDui\Media\StatusBar\MaoR]])
		media:Register("statusbar", "NDui", [[Interface\TargetingFrame\UI-TargetingFrame-BarFill]])
		media:Register("statusbar", "Ray01", [[Interface\AddOns\NDui\Media\StatusBar\Ray01]])
		media:Register("statusbar", "Ray02", [[Interface\AddOns\NDui\Media\StatusBar\Ray02]])
		media:Register("statusbar", "Ray03", [[Interface\AddOns\NDui\Media\StatusBar\Ray03]])
		media:Register("statusbar", "Ray04", [[Interface\AddOns\NDui\Media\StatusBar\Ray04]])
		media:Register("statusbar", "Ya01", [[Interface\AddOns\NDui\Media\StatusBar\Ya01]])
		media:Register("statusbar", "Ya02", [[Interface\AddOns\NDui\Media\StatusBar\Ya02]])
		media:Register("statusbar", "Ya03", [[Interface\AddOns\NDui\Media\StatusBar\Ya03]])
		media:Register("statusbar", "Ya04", [[Interface\AddOns\NDui\Media\StatusBar\Ya04]])
		media:Register("statusbar", "Ya05", [[Interface\AddOns\NDui\Media\StatusBar\Ya05]])
	end
end

function S:CreateToggle(frame)
	local close = B.CreateButton(frame, 20, 80, ">", 18)
	close:SetPoint("RIGHT", frame.bg, "LEFT", -2, 0)
	B.CreateTex(close)

	local open = B.CreateButton(UIParent, 20, 80, "<", 18)
	open:SetPoint("RIGHT", frame.bg, "RIGHT", 2, 0)
	B.CreateTex(open)
	open:Hide()

	open:SetScript("OnClick", function()
		open:Hide()
	end)
	close:SetScript("OnClick", function()
		open:Show()
	end)

	return open, close
end

function S:LoadWithAddOn(addonName, value, func)
	local function loadFunc(event, addon)
		if not NDuiDB["Skins"][value] then return end

		if event == "PLAYER_ENTERING_WORLD" then
			B:UnregisterEvent(event, loadFunc)
			if IsAddOnLoaded(addonName) then
				func()
				B:UnregisterEvent("ADDON_LOADED", loadFunc)
			end
		elseif event == "ADDON_LOADED" and addon == addonName then
			func()
			B:UnregisterEvent(event, loadFunc)
		end
	end

	B:RegisterEvent("PLAYER_ENTERING_WORLD", loadFunc)
	B:RegisterEvent("ADDON_LOADED", loadFunc)
end