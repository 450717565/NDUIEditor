local B, C, L, DB = unpack(select(2, ...))

C.themes["Blizzard_MacroUI"] = function()
	B.ReskinFrame(MacroFrame)
	B.ReskinFrame(MacroPopupFrame)

	MacroPopupFrame:SetHeight(525)
	MacroNewButton:ClearAllPoints()
	MacroNewButton:SetPoint("RIGHT", MacroExitButton, "LEFT", -1, 0)

	local lists = {MacroFrameTab1, MacroFrameTab2, MacroFrameTextBackground}
	for _, list in pairs(lists) do
		B.StripTextures(list)
	end

	local scrolls = {MacroButtonScrollFrameScrollBar, MacroFrameScrollFrameScrollBar, MacroPopupScrollFrameScrollBar}
	for _, scroll in pairs(scrolls) do
		B.ReskinScroll(scroll)
	end

	local buttons = {MacroDeleteButton, MacroNewButton, MacroExitButton, MacroEditButton, MacroPopupFrame.BorderBox.OkayButton, MacroPopupFrame.BorderBox.CancelButton, MacroSaveButton, MacroCancelButton}
	for _, button in pairs(buttons) do
		B.ReskinButton(button)
	end

	B.CreateBDFrame(MacroFrameScrollFrame, 0)
	B.ReskinInput(MacroPopupEditBox)

	local selectedbu = MacroFrameSelectedMacroButton
	B.StripTextures(selectedbu)

	local selectedic = MacroFrameSelectedMacroButtonIcon
	local selectedbg = B.ReskinIcon(selectedic)
	B.ReskinHighlight(selectedbu, selectedbg)

	local function reskinButton(button)
		if button.styled then return end

		B.StripTextures(button)
		local frameName = button:GetDebugName()
		local icon = _G[frameName.."Icon"]

		local icbg = B.ReskinIcon(icon)
		B.ReskinChecked(button, icbg)
		B.ReskinHighlight(button, icbg)

		button.styled = true
	end

	for i = 1, MAX_ACCOUNT_MACROS do
		reskinButton(_G["MacroButton"..i])
	end

	MacroPopupFrame:HookScript("OnShow", function(self)
		for i = 1, NUM_MACRO_ICONS_SHOWN do
			reskinButton(_G["MacroPopupButton"..i])
		end

		self:ClearAllPoints()
		self:SetPoint("TOPLEFT", MacroFrame, "TOPRIGHT", 3, 0)
	end)
end