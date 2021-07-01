local _, ns = ...
local B, C, L, DB, P = unpack(ns)
local Skins = B:GetModule("Skins")

local Buttons = {
	"ClearPresetButton",
	"LinkToChatButton",
	"LiveSessionButton",
	"MDIButton",
	"sidePanelDeleteButton",
	"sidePanelExportButton",
	"sidePanelImportButton",
	"sidePanelNewButton",
	"sidePanelRenameButton",
}

local styled
local function Reskin_ShowInterface(self)
	if not styled then
		local frame = self.main_frame
		frame.HelpButton.Ring:Hide()

		B.ReskinMinMax(frame.maximizeButton)
		B.ReskinClose(frame.closeButton, frame.sidePanel, -7, -7)
		B.ReskinStatusBar(frame.sidePanel.ProgressBar.Bar, true)

		for _, v in pairs(Buttons) do
			local button = frame[v] and frame[v].frame
			if button and button.bgTex then
				B.Hook_OnEnter(button)
				B.Hook_OnLeave(button)
			end
		end

		styled = true
	end
end

function Skins:MythicDungeonTools()
	if not IsAddOnLoaded("MythicDungeonTools") then return end

	local MDT = _G.MDT
	hooksecurefunc(MDT, "ShowInterface", Reskin_ShowInterface)

	function MDT:FormatEnemyHealth(amount)
		amount = tonumber(amount)
		if amount then return B.FormatNumb(amount) end
	end
end

C.OnLoginThemes["MythicDungeonTools"] = Skins.MythicDungeonTools