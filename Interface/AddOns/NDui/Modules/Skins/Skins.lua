local _, ns = ...
local B, C, L, DB = unpack(ns)
local S = B:RegisterModule("Skins")

local pairs, wipe = pairs, wipe
local IsAddOnLoaded = IsAddOnLoaded

C.defaultThemes = {}
C.themes = {}

StaticPopupDialogs["AURORA_CLASSIC_WARNING"] = {
	text = L["AuroraClassic warning"],
	button1 = DISABLE,
	hideOnEscape = false,
	whileDead = 1,
	OnAccept = function()
		DisableAddOn("Aurora", true)
		DisableAddOn("AuroraClassic", true)
		ReloadUI()
	end,
}
function S:DetectAurora()
	if DB.isDeveloper then return end

	if IsAddOnLoaded("AuroraClassic") or IsAddOnLoaded("Aurora") then
		StaticPopup_Show("AURORA_CLASSIC_WARNING")
	end
end

function S:LoadDefaultSkins()
	if IsAddOnLoaded("AuroraClassic") or IsAddOnLoaded("Aurora") then return end
	if not NDuiDB["Skins"]["BlizzardSkins"] then return end

	-- Reskin Blizzard UIs
	for _, func in pairs(C.defaultThemes) do
		func()
	end
	wipe(C.defaultThemes)

	for addonName, func in pairs(C.themes) do
		local isLoaded, isFinished = IsAddOnLoaded(addonName)
		if isLoaded and isFinished then
			func()
			C.themes[addonName] = nil
		end
	end

	B:RegisterEvent("ADDON_LOADED", function(_, addonName)
		local func = C.themes[addonName]
		if func then
			func()
			C.themes[addonName] = nil
		end
	end)
end

function S:OnLogin()
	self:DetectAurora()
	self:LoadDefaultSkins()

	-- Add Skins
	self:BigWigs()
	self:DeadlyBossMods()
	self:Skada()

	self:Other()

	if NDuiDB["Skins"]["BlizzardSkins"] then
		self:Ace3()
		self:BaudErrorFrame()
		self:BuyEmAll()
		self:ClassicQuestLog()
		self:DungeonWatchDog()
		self:ExtVendor()
		self:Immersion()
		self:ls_Toasts()
		self:MogPartialSets()
		self:Postal()
		self:PremadeGroupsFilter()
		self:Rematch()
		self:Simulationcraft()
		self:TransmogWishList()
		self:WhisperPop()
		self:WorldQuestTab()
	end

	-- Register skin
	local media = LibStub and LibStub("LibSharedMedia-3.0", true)
	if media then
		for i = 1, 7 do
			media:Register("statusbar", "BarTex_"..i, "Interface\\Addons\\NDui\\Media\\StatusBar\\barTex_"..i)
		end
		for k = 1, 13 do
			media:Register("statusbar", "Texture_"..k, "Interface\\Addons\\NDui\\Media\\Texture\\texture_"..k)
		end
	end
end

function S.GetToggleDirection()
	local direc = NDuiDB["Skins"]["ToggleDirection"]
	if direc == 1 then
		return "|", "|", "RIGHT", "LEFT", -2, 0, 20, 80
	elseif direc == 2 then
		return "|", "|", "LEFT", "RIGHT", 2, 0, 20, 80
	elseif direc == 3 then
		return "—", "—", "BOTTOM", "TOP", 0, 2, 80, 20
	else
		return "—", "—", "TOP", "BOTTOM", 0, -2, 80, 20
	end
end

local toggleFrames = {}

local function CreateToggleButton(parent)
	local bu = CreateFrame("Button", nil, parent)
	bu:SetSize(20, 80)
	bu.text = B.CreateFS(bu, 18, nil, true)
	B.ReskinButton(bu)

	return bu
end

function S:CreateToggle()
	local close = CreateToggleButton(self)
	self.closeButton = close

	local open = CreateToggleButton(UIParent)
	open:Hide()
	self.openButton = open

	open:SetScript("OnClick", function()
		open:Hide()
	end)
	close:SetScript("OnClick", function()
		open:Show()
	end)

	S.SetToggleDirection(self)
	tinsert(toggleFrames, self)

	return open, close
end

function S:SetToggleDirection()
	local str1, str2, rel1, rel2, x, y, width, height = S.GetToggleDirection()
	local parent = self.bg
	local close = self.closeButton
	local open = self.openButton
	close:ClearAllPoints()
	close:SetPoint(rel1, parent, rel2, x, y)
	close:SetSize(width, height)
	close.text:SetText(str1)
	open:ClearAllPoints()
	open:SetPoint(rel1, parent, rel1, -x, -y)
	open:SetSize(width, height)
	open.text:SetText(str2)
end

function S.RefreshToggleDirection()
	for _, frame in pairs(toggleFrames) do
		S.SetToggleDirection(frame)
	end
end

function S.LoadWithAddOn(addonName, value, func)
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