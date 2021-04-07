local _, ns = ...
local B, C, L, DB = unpack(ns)
local Skins = B:RegisterModule("Skins")

local pairs, wipe = pairs, wipe
local IsAddOnLoaded = IsAddOnLoaded

C.XMLThemes = {}
C.LUAThemes = {}

function Skins:LoadDefaultSkins()
	if IsAddOnLoaded("AuroraClassic") or IsAddOnLoaded("Aurora") then return end
	if not C.db["Skins"]["BlizzardSkins"] then return end

	-- Reskin Blizzard UIs
	for _, func in pairs(C.XMLThemes) do
		func()
	end
	wipe(C.XMLThemes)

	for addonName, func in pairs(C.LUAThemes) do
		local isLoaded, isFinished = IsAddOnLoaded(addonName)
		if isLoaded and isFinished then
			func()
			C.LUAThemes[addonName] = nil
		end
	end

	B:RegisterEvent("ADDON_LOADED", function(_, addonName)
		local func = C.LUAThemes[addonName]
		if func then
			func()
			C.LUAThemes[addonName] = nil
		end
	end)
end

function Skins:OnLogin()
	self:Fonts()
	self:LoadDefaultSkins()

	-- Add Skins
	self:BigWigs()
	self:DeadlyBossMods()
	self:Skada()

	self:Other()

	if C.db["Skins"]["BlizzardSkins"] then
		self:Ace3()
		self:BaudErrorFrame()
		self:BuyEmAll()
		self:ClassicQuestLog()
		self:CompactVendor()
		self:CompactVendorFilter()
		self:DungeonWatchDog()
		self:ExtVendor()
		self:HandyNotes()
		self:Immersion()
		self:ls_Toasts()
		self:MeetingStone()
		self:MogPartialSets()
		self:Myslot()
		self:MythicDungeonTools()
		self:Postal()
		self:PremadeGroupsFilter()
		self:Rematch()
		self:TomeOfTeleportation()
		self:TransmogWishList()
		self:WhisperPop()
		self:WorldQuestsList()
		self:WorldQuestTab()
	end
	-- Register skin
	local media = LibStub and LibStub("LibSharedMedia-3.0", true)
	if media then
		media:Register("statusbar", "normTex", DB.normTex)
	end
end

function Skins.GetToggleDirection()
	local direc = C.db["Skins"]["ToggleDirection"]
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
	B.ReskinButton(bu, true)

	return bu
end

function Skins:CreateToggle()
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

	Skins.SetToggleDirection(self)
	tinsert(toggleFrames, self)

	return open, close
end

function Skins:SetToggleDirection()
	local str1, str2, rel1, rel2, x, y, width, height = Skins.GetToggleDirection()
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

	if C.db["Skins"]["ToggleDirection"] == 5 then
		close:SetAlpha(0)
		close:EnableMouse(false)
		open:SetAlpha(0)
		open:EnableMouse(false)
	else
		close:SetAlpha(1)
		close:EnableMouse(true)
		open:SetAlpha(1)
		open:EnableMouse(true)
	end
end

function Skins.RefreshToggleDirection()
	for _, frame in pairs(toggleFrames) do
		Skins.SetToggleDirection(frame)
	end
end

function Skins.LoadWithAddOn(addonName, value, func)
	local function loadFunc(event, addon)
		if not C.db["Skins"][value] then return end

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