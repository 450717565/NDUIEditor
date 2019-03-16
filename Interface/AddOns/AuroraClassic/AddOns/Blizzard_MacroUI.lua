local F, C = unpack(select(2, ...))

C.themes["Blizzard_MacroUI"] = function()
	F.ReskinFrame(MacroFrame)
	F.ReskinFrame(MacroPopupFrame)

	MacroPopupFrame:SetHeight(525)
	MacroNewButton:ClearAllPoints()
	MacroNewButton:SetPoint("RIGHT", MacroExitButton, "LEFT", -1, 0)

	local lists = {MacroButtonScrollFrame, MacroPopupScrollFrame, MacroFrameScrollFrame, MacroFrameTab1, MacroFrameTab2, MacroFrameTextBackground}
	for _, list in pairs(lists) do
		F.StripTextures(list)
	end

	local scrolls = {MacroButtonScrollFrameScrollBar, MacroFrameScrollFrameScrollBar, MacroPopupScrollFrameScrollBar}
	for _, scroll in pairs(scrolls) do
		F.ReskinScroll(scroll)
	end

	local buttons = {MacroDeleteButton, MacroNewButton, MacroExitButton, MacroEditButton, MacroPopupFrame.BorderBox.OkayButton, MacroPopupFrame.BorderBox.CancelButton, MacroSaveButton, MacroCancelButton}
	for _, button in pairs(buttons) do
		F.ReskinButton(button)
	end

	F.CreateBDFrame(MacroFrameScrollFrame, 0)
	F.ReskinInput(MacroPopupEditBox, true)

	local selectedbu = MacroFrameSelectedMacroButton
	F.StripTextures(selectedbu)

	local selectedic = MacroFrameSelectedMacroButtonIcon
	local selectedbg = F.ReskinIcon(selectedic)
	F.ReskinTexture(selectedbu, selectedbg, false)

	local function reskinButton(button, i)
		local bu = _G[button..i]
		local ic = _G[button..i.."Icon"]

		if bu and ic then
			F.StripTextures(bu)

			local icbg = F.ReskinIcon(ic)
			F.ReskinTexed(bu, icbg)
			F.ReskinTexture(bu, icbg, false)
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

			self.styled = true
		end
	end)
end