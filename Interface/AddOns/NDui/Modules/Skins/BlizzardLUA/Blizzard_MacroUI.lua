local _, ns = ...
local B, C, L, DB = unpack(ns)

local function Reskin_Button(self)
	if self and not self.styled then
		B.StripTextures(self)

		local icon = B.GetObject(self, "Icon")
		local icbg = B.ReskinIcon(icon)
		B.ReskinCPTex(self, icbg)
		B.ReskinHLTex(self, icbg)

		self.styled = true
	end
end

local function Reskin_MacroPopupFrame(self)
	for i = 1, NUM_MACRO_ICONS_SHOWN do
		Reskin_Button(_G["MacroPopupButton"..i])
	end

	self:ClearAllPoints()
	self:SetPoint("TOPLEFT", MacroFrame, "TOPRIGHT", 3, 0)
end

C.LUAThemes["Blizzard_MacroUI"] = function()
	B.ReskinFrame(MacroFrame)
	B.ReskinFrame(MacroPopupFrame)

	MacroPopupFrame:SetHeight(525)
	MacroNewButton:ClearAllPoints()
	MacroNewButton:SetPoint("RIGHT", MacroExitButton, "LEFT", -1, 0)

	local lists = {
		MacroFrameTab1,
		MacroFrameTab2,
		MacroFrameTextBackground,
	}
	for _, list in pairs(lists) do
		B.StripTextures(list)
	end

	local scrolls = {
		MacroButtonScrollFrameScrollBar,
		MacroFrameScrollFrameScrollBar,
		MacroPopupScrollFrameScrollBar,
	}
	for _, scroll in pairs(scrolls) do
		B.ReskinScroll(scroll)
	end

	local buttons = {
		MacroCancelButton,
		MacroDeleteButton,
		MacroEditButton,
		MacroExitButton,
		MacroNewButton,
		MacroPopupFrame.BorderBox.CancelButton,
		MacroPopupFrame.BorderBox.OkayButton,
		MacroSaveButton,
	}
	for _, button in pairs(buttons) do
		B.ReskinButton(button)
	end

	B.CreateBDFrame(MacroFrameScrollFrame)
	B.ReskinInput(MacroPopupEditBox)

	local bu = MacroFrameSelectedMacroButton
	B.StripTextures(bu)

	local ic = MacroFrameSelectedMacroButtonIcon
	ic:ClearAllPoints()
	ic:SetPoint("BOTTOMRIGHT", MacroEditButton, "BOTTOMLEFT", -5, C.mult)

	local bg = B.ReskinIcon(ic)
	B.ReskinHLTex(bu, bg)

	for i = 1, MAX_ACCOUNT_MACROS do
		Reskin_Button(_G["MacroButton"..i])
	end

	MacroPopupFrame:HookScript("OnShow", Reskin_MacroPopupFrame)
end