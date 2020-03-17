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

	local function reskinButton(button, i)
		local bu = _G[button..i]
		local ic = _G[button..i.."Icon"]

		if bu and ic then
			B.StripTextures(bu)

			local icbg = B.ReskinIcon(ic)
			B.ReskinChecked(bu, icbg)
			B.ReskinHighlight(bu, icbg)
		end
	end

	for i = 1, MAX_ACCOUNT_MACROS do
		reskinButton("MacroButton", i)
	end

	MacroPopupFrame:HookScript("OnShow", function(self)
		if not self.styled then
			for i = 1, NUM_MACRO_ICONS_SHOWN do
				reskinButton("MacroPopupButton", i)
			end

			self:ClearAllPoints()
			self:SetPoint("TOPLEFT", MacroFrame, "TOPRIGHT", 3, 0)

			self.styled = true
		end
	end)
end