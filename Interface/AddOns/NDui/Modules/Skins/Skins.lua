local _, ns = ...
local B, C, L, DB = unpack(ns)
local module = B:RegisterModule("Skins")

function module:OnLogin()
	local alpha = NDuiDB["Extras"]["SkinColorA"]
	local cr = NDuiDB["Extras"]["SkinColorR"]
	local cg = NDuiDB["Extras"]["SkinColorG"]
	local cb = NDuiDB["Extras"]["SkinColorB"]
	if NDuiDB["Skins"]["ClassLine"] then cr, cg, cb = DB.CC.r, DB.CC.g, DB.CC.b end

	local overLP = {"BOTTOMRIGHT", NDui_ActionBar1, "TOP"}
	local overRP = {"BOTTOMLEFT", NDui_ActionBar1, "TOP"}
	local topLP = {"BOTTOMRIGHT", NDui_ActionBar2, "TOP"}
	local topRP = {"BOTTOMLEFT", NDui_ActionBar2, "TOP"}
	local botLP = {"TOPRIGHT", NDui_ActionBar1, "BOTTOM"}
	local botRP = {"TOPLEFT", NDui_ActionBar1, "BOTTOM"}

	if NDuiDB["Actionbar"]["Style"] == 4 then
		topLP = {"BOTTOMRIGHT", NDui_ActionBar3, "TOP"}
		topRP = {"BOTTOMLEFT", NDui_ActionBar3, "TOP"}
	elseif NDuiDB["Actionbar"]["Style"] == 5 then
		overLP = {"BOTTOMRIGHT", ActionButton9, "TOPRIGHT", 1 , 2}
		overRP = {"BOTTOMLEFT", ActionButton10, "TOPLEFT", -1 , 2}
		topLP = {"BOTTOMRIGHT", MultiBarBottomLeftButton9, "TOPRIGHT", 1 , 2}
		topRP = {"BOTTOMLEFT", MultiBarBottomLeftButton10, "TOPLEFT", -1 , 2}
		botLP = {"TOPRIGHT", ActionButton9, "BOTTOMRIGHT", 1 , -2}
		botRP = {"TOPLEFT", ActionButton10, "BOTTOMLEFT", -1 , -2}
	end

	-- TOPLEFT
	if NDuiDB["Skins"]["InfobarLine"] then
		local InfobarLineTL = CreateFrame("Frame", nil, UIParent)
		InfobarLineTL:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, -5)
		B.CreateGF(InfobarLineTL, 600, 18, "Horizontal", 0, 0, 0, .5, 0)
		local InfobarLineTL1 = CreateFrame("Frame", nil, InfobarLineTL)
		InfobarLineTL1:SetPoint("BOTTOM", InfobarLineTL, "TOP")
		B.CreateGF(InfobarLineTL1, 600, 3, "Horizontal", cr, cg, cb, alpha, 0)
		local InfobarLineTL2 = CreateFrame("Frame", nil, InfobarLineTL)
		InfobarLineTL2:SetPoint("TOP", InfobarLineTL, "BOTTOM")
		B.CreateGF(InfobarLineTL2, 600, 3, "Horizontal", cr, cg, cb, alpha, 0)
	end

	-- BOTTOMLEFT
	if NDuiDB["Skins"]["ChatLine"] then
		local ChatLine = CreateFrame("Frame", nil, UIParent)
		ChatLine:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 0, 5)
		B.CreateGF(ChatLine, 450, ChatFrame1:GetHeight() + 26, "Horizontal", 0, 0, 0, .5, 0)
		local ChatLine1 = CreateFrame("Frame", nil, ChatLine)
		ChatLine1:SetPoint("BOTTOM", ChatLine, "TOP")
		B.CreateGF(ChatLine1, 450, 3, "Horizontal", cr, cg, cb, alpha, 0)
		local ChatLine2 = CreateFrame("Frame", nil, ChatLine)
		ChatLine2:SetPoint("BOTTOM", ChatLine, "BOTTOM", 0, 18)
		B.CreateGF(ChatLine2, 450, 3, "Horizontal", cr, cg, cb, alpha, 0)
		local ChatLine3 = CreateFrame("Frame", nil, ChatLine)
		ChatLine3:SetPoint("TOP", ChatLine, "BOTTOM")
		B.CreateGF(ChatLine3, 450, 3, "Horizontal", cr, cg, cb, alpha, 0)
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
		B.CreateGF(InfobarLineBR1, 450, 3, "Horizontal", cr, cg, cb, 0, alpha)
		local InfobarLineBR2 = CreateFrame("Frame", nil, InfobarLineBR)
		InfobarLineBR2:SetPoint("TOP", InfobarLineBR, "BOTTOM")
		B.CreateGF(InfobarLineBR2, 450, 3, "Horizontal", cr, cg, cb, 0, alpha)
	end

	-- ACTIONBAR
	if NDuiDB["Actionbar"]["Enable"] then
		if NDuiDB["Skins"]["BarLine"] then
			local barWidth = NDui_ActionBar1:GetWidth() * .6

			-- ACTIONBAR
			local ActionBarL = CreateFrame("Frame", nil, UIParent)
			ActionBarL:SetPoint(unpack(topLP))
			B.CreateGF(ActionBarL, barWidth, 3, "Horizontal", cr, cg, cb, 0, alpha)
			RegisterStateDriver(ActionBarL, "visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; show")
			local ActionBarR = CreateFrame("Frame", nil, UIParent)
			ActionBarR:SetPoint(unpack(topRP))
			B.CreateGF(ActionBarR, barWidth, 3, "Horizontal", cr, cg, cb, alpha, 0)
			RegisterStateDriver(ActionBarR, "visibility", "[petbattle][overridebar][vehicleui][possessbar,@vehicle,exists] hide; show")

			-- OVERRIDEBAR
			local OverBarL = CreateFrame("Frame", nil, UIParent)
			OverBarL:SetPoint(unpack(overLP))
			B.CreateGF(OverBarL, barWidth, 3, "Horizontal", cr, cg, cb, 0, alpha)
			RegisterStateDriver(OverBarL, "visibility", "[petbattle]hide; [overridebar][vehicleui][possessbar,@vehicle,exists] show; hide")
			local OverBarR = CreateFrame("Frame", nil, UIParent)
			OverBarR:SetPoint(unpack(overRP))
			B.CreateGF(OverBarR, barWidth, 3, "Horizontal", cr, cg, cb, alpha, 0)
			RegisterStateDriver(OverBarR, "visibility", "[petbattle]hide; [overridebar][vehicleui][possessbar,@vehicle,exists] show; hide")

			-- BOTTOMLINE
			local BarLineL = CreateFrame("Frame", nil, UIParent)
			BarLineL:SetPoint(unpack(botLP))
			B.CreateGF(BarLineL, barWidth, 3, "Horizontal", cr, cg, cb, 0, alpha)
			local BarLineR = CreateFrame("Frame", nil, UIParent)
			BarLineR:SetPoint(unpack(botRP))
			B.CreateGF(BarLineR, barWidth, 3, "Horizontal", cr, cg, cb, alpha, 0)
		end
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
	self:BigWigsSkin()
end

function module:LoadWithAddOn(addonName, value, func)
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