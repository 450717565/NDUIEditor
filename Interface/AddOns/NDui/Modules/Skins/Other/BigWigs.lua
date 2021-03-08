local _, ns = ...
local B, C, L, DB = unpack(ns)
local Skins = B:GetModule("Skins")

local function Update_StartCountdown(self, _, module, key, text, time)
	TimerTracker_OnEvent(TimerTracker, "START_TIMER", 3, time, time)
end

local function Update_StopCountdown(self)
	for _, timer in pairs(TimerTracker.timerList) do
		if not timer.isFree then
			if timer.type == 3 then
				FreeTimerTrackerTimer(timer)
			end
		end
	end
end

local function Reskin_Countdown()
	local plugin = BigWigs:GetPlugin("Countdown")
	if not plugin then return end

	hooksecurefunc(plugin, "BigWigs_StartCountdown", Update_StartCountdown)
	hooksecurefunc(plugin, "BigWigs_StopCountdown", Update_StopCountdown)
end

local function Remove_Style(self)
	B.StripTextures(self)

	local height = self:Get("bigwigs:restoreheight")
	if height then self:SetHeight(height) end

	local tex = self:Get("bigwigs:restoreicon")
	if tex then
		self:SetIcon(tex)
		self:Set("bigwigs:restoreicon", nil)
	end

	local timer = self.candyBarDuration
	timer:SetJustifyH("RIGHT")
	timer:ClearAllPoints()
	timer:SetPoint("TOPLEFT", self.candyBarBar, "TOPLEFT", 2, 8)
	timer:SetPoint("BOTTOMRIGHT", self.candyBarBar, "BOTTOMRIGHT", -2, 8)

	local label = self.candyBarLabel
	label:SetJustifyH("LEFT")
	label:ClearAllPoints()
	label:SetPoint("TOPLEFT", self.candyBarBar, "TOPLEFT", 2, 8)
	label:SetPoint("BOTTOMRIGHT", self.candyBarBar, "BOTTOMRIGHT", -2, 8)
end

local function Reskin_Style(self)
	B.StripTextures(self)

	local height = self:GetHeight()
	self:Set("bigwigs:restoreheight", height)
	self:SetHeight(height/2)
	self:SetTexture(DB.normTex)

	if not self.styled then
		B.CreateBDFrame(self, 0, -C.mult)

		self.styled = true
	end

	local tex = self:GetIcon()
	if tex then
		self:SetIcon(nil)
		self:Set("bigwigs:restoreicon", tex)

		local icon = self.candyBarIconFrame
		icon:Show()
		icon:SetTexture(tex)
		icon:SetSize(height, height)

		icon:ClearAllPoints()
		if self.iconPosition == "RIGHT" then
			icon:SetPoint("BOTTOMLEFT", self, "BOTTOMRIGHT", C.margin, 0)
		else
			icon:SetPoint("BOTTOMRIGHT", self, "BOTTOMLEFT", -C.margin, 0)
		end

		if not icon.styled then
			B.CreateBDFrame(icon, 0, -C.mult)

			icon.styled = true
		end
	end

	local timer = self.candyBarDuration
	timer:SetJustifyH("RIGHT")
	timer:ClearAllPoints()
	timer:SetPoint("TOPLEFT", self.candyBarBar, "TOPLEFT", 2, 8)
	timer:SetPoint("BOTTOMRIGHT", self.candyBarBar, "BOTTOMRIGHT", -2, 8)

	local label = self.candyBarLabel
	label:SetJustifyH("LEFT")
	label:ClearAllPoints()
	label:SetPoint("TOPLEFT", self.candyBarBar, "TOPLEFT", 2, 8)
	label:SetPoint("BOTTOMRIGHT", self.candyBarBar, "BOTTOMRIGHT", -2, 8)
end

local function Set_Style(self, style)
	if style ~= "NDui" then
		self:SetBarStyle("NDui")
	end
end

local function Register_Style()
	if not BigWigsAPI then return end
	BigWigsAPI:RegisterBarStyle("NDui", {
		apiVersion = 1,
		version = 3,
		GetSpacing = function(bar) return bar:GetHeight()+5 end,
		ApplyStyle = Reskin_Style,
		BarStopped = Remove_Style,
		fontSizeNormal = 13,
		fontSizeEmphasized = 14,
		fontOutline = "OUTLINE",
		GetStyleName = function() return "NDui" end,
	})

	local bars = BigWigs:GetPlugin("Bars", true)
	hooksecurefunc(bars, "SetBarStyle", Set_Style)
end

function Skins:BigWigs()
	if not C.db["Skins"]["Bigwigs"] then return end
	if not IsAddOnLoaded("BigWigs") then return end
	if not BigWigs3DB then return end

	if IsAddOnLoaded("BigWigs_Plugins") then
		Register_Style()
		Reskin_Countdown()
	else
		local function loadStyle(event, addon)
			if addon == "BigWigs_Plugins" then
				Register_Style()
				Reskin_Countdown()
				B:UnregisterEvent(event, loadStyle)
			end
		end
		B:RegisterEvent("ADDON_LOADED", loadStyle)
	end
end