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

local function Reskin_QueueTimer(_, frame, name)
	if name == "QueueTimer" and not frame.styled then
		B.ReskinStatusBar(frame, true)

		frame.styled = true
	end
end

local function Remove_Style(self)
	B.StripTextures(self)
	B.StripTextures(self.candyBarBar)

	local height = self:Get("bigwigs:restoreheight")
	if height then self:SetHeight(height) end

	local tex = self:Get("bigwigs:restoreicon")
	if tex then self:SetIcon(tex) end

	local timer = self.candyBarDuration
	timer:SetJustifyH("RIGHT")
	B.UpdatePoint(timer, "RIGHT", self.candyBarBar, "RIGHT", -C.margin, 0)

	local label = self.candyBarLabel
	label:SetJustifyH("LEFT")
	B.UpdatePoint(label, "LEFT", self.candyBarBar, "LEFT", C.margin, 0)
end

local function Reskin_Style(self)
	B.StripTextures(self)
	B.StripTextures(self.candyBarBar)

	local height = self:GetHeight()
	self:Set("bigwigs:restoreheight", height/2)
	self:SetHeight(height/2)
	self:SetTexture(DB.normTex)

	if not self.styled then
		B.CreateBDFrame(self.candyBarBar, 0, -C.mult)

		self.styled = true
	end

	local tex = self:GetIcon()
	if tex then
		self:Set("bigwigs:restoreicon", tex)
		self:SetIcon(tex)

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
	B.UpdatePoint(timer, "RIGHT", self.candyBarBar, "RIGHT", -C.margin, 0)

	local label = self.candyBarLabel
	label:SetJustifyH("LEFT")
	B.UpdatePoint(label, "LEFT", self.candyBarBar, "LEFT", C.margin, 0)
end

local styleData = {
	apiVersion = 1,
	version = 3,
	GetSpacing = function(bar) return bar:GetHeight()+C.margin end,
	ApplyStyle = Reskin_Style,
	BarStopped = Remove_Style,
	fontSizeNormal = 13,
	fontSizeEmphasized = 14,
	fontOutline = "OUTLINE",
	GetStyleName = function() return "NDui" end,
}

local function Register_Style()
	if not BigWigsAPI then return end

	BigWigsAPI:RegisterBarStyle("NDui", styleData)
	-- Force to use NDui style
	local pending = true
	hooksecurefunc(BigWigsAPI, "GetBarStyle", function(_, key)
		if pending then
			BigWigsAPI.GetBarStyle = function() return styleData end
			pending = nil
		end
	end)
end

function Skins:BigWigs()
	if not C.db["Skins"]["Bigwigs"] or not IsAddOnLoaded("BigWigs") then return end
	if not BigWigs3DB then return end

	if BigWigsLoader and BigWigsLoader.RegisterMessage then
		BigWigsLoader.RegisterMessage(_, "BigWigs_FrameCreated", Reskin_QueueTimer)
	end

	B.LoadWithAddOn("BigWigs_Plugins", Register_Style)
	B.LoadWithAddOn("BigWigs_Plugins", Reskin_Countdown)
end