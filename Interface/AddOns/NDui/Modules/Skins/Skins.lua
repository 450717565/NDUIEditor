local B, C, L, DB = unpack(select(2, ...))
local module = NDui:RegisterModule("Skins")

function module:OnLogin()
	local cr, cg, cb = 0, 0, 0
	if NDuiDB["Skins"]["ClassLine"] then cr, cg, cb = DB.ClassColor.r, DB.ClassColor.g, DB.ClassColor.b end

	local basicW, basicH = 0, 0
	if NDuiDB["Actionbar"]["Style"] == 2 then
		basicW, basicH = 450, 97
	elseif NDuiDB["Actionbar"]["Style"] == 3 then
		basicW, basicH = 325, 97
	elseif NDuiDB["Actionbar"]["Style"] == 4 then
		basicW, basicH = 250, 133
	else
		basicW, basicH = 350, 97
	end

	-- TOPLEFT
	if NDuiDB["Skins"]["InfobarLine"] then
		local InfobarLineTL = CreateFrame("Frame", nil, UIParent)
		InfobarLineTL:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, -5)
		B.CreateGF(InfobarLineTL, 600, 18, "Horizontal", 0, 0, 0, .5, 0)
		local InfobarLineTL1 = CreateFrame("Frame", nil, InfobarLineTL)
		InfobarLineTL1:SetPoint("BOTTOM", InfobarLineTL, "TOP")
		B.CreateGF(InfobarLineTL1, 600, 3, "Horizontal", cr, cg, cb, .7, 0)
		local InfobarLineTL2 = CreateFrame("Frame", nil, InfobarLineTL)
		InfobarLineTL2:SetPoint("TOP", InfobarLineTL, "BOTTOM")
		B.CreateGF(InfobarLineTL2, 600, 3, "Horizontal", cr, cg, cb, .7, 0)
	end

	-- BOTTOMLEFT
	if NDuiDB["Skins"]["ChatLine"] then
		local ChatLine = CreateFrame("Frame", nil, UIParent)
		ChatLine:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 0, 5)
		B.CreateGF(ChatLine, 450, ChatFrame1:GetHeight() + 26, "Horizontal", 0, 0, 0, .5, 0)
		local ChatLine1 = CreateFrame("Frame", nil, ChatLine)
		ChatLine1:SetPoint("BOTTOM", ChatLine, "TOP")
		B.CreateGF(ChatLine1, 450, 3, "Horizontal", cr, cg, cb, .7, 0)
		local ChatLine2 = CreateFrame("Frame", nil, ChatLine)
		ChatLine2:SetPoint("BOTTOM", ChatLine, "BOTTOM", 0, 18)
		B.CreateGF(ChatLine2, 450, 3, "Horizontal", cr, cg, cb, .7, 0)
		local ChatLine3 = CreateFrame("Frame", nil, ChatLine)
		ChatLine3:SetPoint("TOP", ChatLine, "BOTTOM")
		B.CreateGF(ChatLine3, 450, 3, "Horizontal", cr, cg, cb, .7, 0)
		ChatFrame1Tab:HookScript("OnMouseUp", function(_, btn)
			if btn == "LeftButton" then
				ChatLine:SetHeight(ChatFrame1:GetHeight() + 26)
			end
		end)
	end

	-- BOTTOMRIGHT
	if NDuiDB["Skins"]["InfobarLine"] then
		local InfobarLineBR = CreateFrame("Frame", nil, UIParent)
		InfobarLineBR:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 5)
		B.CreateGF(InfobarLineBR, 450, 18, "Horizontal", 0, 0, 0, 0, .5)
		local InfobarLineBR1 = CreateFrame("Frame", nil, InfobarLineBR)
		InfobarLineBR1:SetPoint("BOTTOM", InfobarLineBR, "TOP")
		B.CreateGF(InfobarLineBR1, 450, 3, "Horizontal", cr, cg, cb, 0, .7)
		local InfobarLineBR2 = CreateFrame("Frame", nil, InfobarLineBR)
		InfobarLineBR2:SetPoint("TOP", InfobarLineBR, "BOTTOM")
		B.CreateGF(InfobarLineBR2, 450, 3, "Horizontal", cr, cg, cb, 0, .7)
	end

	-- MICROMENU
	if NDuiDB["Skins"]["MenuLine"] then
		local MenuLineL = CreateFrame("Frame", nil, UIParent)
		MenuLineL:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOM", 0, 22)
		B.CreateGF(MenuLineL, basicW, 3, "Horizontal", cr, cg, cb, 0, .7)
		local MenuLineR = CreateFrame("Frame", nil, UIParent)
		MenuLineR:SetPoint("BOTTOMLEFT", UIParent, "BOTTOM", 0, 22)
		B.CreateGF(MenuLineR, basicW, 3, "Horizontal", cr, cg, cb, .7, 0)
	end

	-- ACTIONBAR
	if NDuiDB["Skins"]["BarLine"] then
		local ActionBarL = CreateFrame("Frame", nil, UIParent)
		ActionBarL:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOM", 0, 0)
		B.CreateGF(ActionBarL, basicW, basicH, "Horizontal", 0, 0, 0, 0, .5)
		local ActionBarL1 = CreateFrame("Frame", nil, ActionBarL)
		ActionBarL1:SetPoint("BOTTOMRIGHT", ActionBarL, "TOPRIGHT")
		B.CreateGF(ActionBarL1, basicW, 3, "Horizontal", cr, cg, cb, 0, .7)
		RegisterStateDriver(ActionBarL, "visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; show")

		local ActionBarR = CreateFrame("Frame", nil, UIParent)
		ActionBarR:SetPoint("BOTTOMLEFT", UIParent, "BOTTOM", 0, 0)
		B.CreateGF(ActionBarR, basicW, basicH, "Horizontal", 0, 0, 0, .5, 0)
		local ActionBarR1 = CreateFrame("Frame", nil, ActionBarR)
		ActionBarR1:SetPoint("BOTTOMLEFT", ActionBarR, "TOPLEFT")
		B.CreateGF(ActionBarR1, basicW, 3, "Horizontal", cr, cg, cb, .7, 0)
		RegisterStateDriver(ActionBarR, "visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; show")

		-- OVERRIDEBAR
		local OverBarL = CreateFrame("Frame", nil, UIParent)
		OverBarL:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOM", 0, 0)
		B.CreateGF(OverBarL, 250, 61, "Horizontal", 0, 0, 0, 0, .5)
		local OverBarL1 = CreateFrame("Frame", nil, OverBarL)
		OverBarL1:SetPoint("BOTTOMRIGHT", OverBarL, "TOPRIGHT")
		B.CreateGF(OverBarL1, 250, 3, "Horizontal", cr, cg, cb, 0, .7)
		RegisterStateDriver(OverBarL, "visibility", "[petbattle]hide; [overridebar][vehicleui][possessbar,@vehicle,exists] show; hide")

		local OverBarR = CreateFrame("Frame", nil, UIParent)
		OverBarR:SetPoint("BOTTOMLEFT", UIParent, "BOTTOM", 0, 0)
		B.CreateGF(OverBarR, 250, 61, "Horizontal", 0, 0, 0, .5, 0)
		local OverBarR1 = CreateFrame("Frame", nil, OverBarR)
		OverBarR1:SetPoint("BOTTOMLEFT", OverBarR, "TOPLEFT")
		B.CreateGF(OverBarR1, 250, 3, "Horizontal", cr, cg, cb, .7, 0)
		RegisterStateDriver(OverBarR, "visibility", "[petbattle]hide; [overridebar][vehicleui][possessbar,@vehicle,exists] show; hide")
	end

	-- Add Skins
	self:MicroMenu()
	self:CreateRM()
	self:FontStyle()
	self:QuestTracker()
	self:PetBattleUI()

	self:DBMSkin()
	self:ExtraCDSkin()
	self:RCLootCoucil()
	self:SkadaSkin()
end

function module:LoadWithAddOn(addonName, value, func)
	NDui:EventFrame{"ADDON_LOADED", "PLAYER_ENTERING_WORLD"}:SetScript("OnEvent", function(self, event, addon)
		if not NDuiDB["Skins"][value] then
			self:UnregisterAllEvents()
			return
		end

		if event == "PLAYER_ENTERING_WORLD" then
			if not IsAddOnLoaded(addonName) then
				self:UnregisterAllEvents()
				return
			end
			func()
			self:UnregisterEvent(event)
		elseif event == "ADDON_LOADED" and addon == addonName then
			func()
			self:UnregisterAllEvents()
		end
	end)
end