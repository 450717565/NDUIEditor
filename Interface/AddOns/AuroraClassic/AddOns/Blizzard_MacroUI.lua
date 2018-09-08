local F, C = unpack(select(2, ...))

C.themes["Blizzard_MacroUI"] = function()
	F.ReskinPortraitFrame(MacroFrame, true)

	F.StripTextures(MacroButtonScrollFrame, true)
	F.StripTextures(MacroPopupScrollFrame, true)
	F.ReskinScroll(MacroButtonScrollFrameScrollBar)
	F.ReskinScroll(MacroFrameScrollFrameScrollBar)
	F.ReskinScroll(MacroPopupScrollFrameScrollBar)

	F.StripTextures(MacroFrameTab1, true)
	F.StripTextures(MacroFrameTab2, true)
	F.StripTextures(MacroFrameTextBackground, true)

	F.StripTextures(MacroPopupFrame, true)
	F.StripTextures(MacroPopupFrame.BorderBox, true)
	F.CreateBD(MacroPopupFrame)
	F.CreateSD(MacroPopupFrame)

	local selectedbt = MacroFrameSelectedMacroButton
	selectedbt:ClearAllPoints()
	selectedbt:SetPoint("BOTTOMRIGHT", MacroEditButton, "BOTTOMLEFT", -7, 1)

	local selectedic = MacroFrameSelectedMacroButtonIcon
	selectedic:SetAllPoints()
	selectedic:SetTexCoord(.08, .92, .08, .92)

	for i = 1, MAX_ACCOUNT_MACROS do
		local bu = _G["MacroButton"..i]
		bu:SetCheckedTexture(C.media.checked)
		select(2, bu:GetRegions()):Hide()

		bu:SetHighlightTexture(C.media.backdrop)
		local hl = bu:GetHighlightTexture()
		hl:SetAllPoints()
		hl:SetVertexColor(1, 1, 1, .25)

		local ic = _G["MacroButton"..i.."Icon"]
		ic:SetAllPoints()
		ic:SetTexCoord(.08, .92, .08, .92)

		F.CreateBDFrame(bu, .25)
	end

	MacroPopupFrame:HookScript("OnShow", function()
		for i = 1, NUM_MACRO_ICONS_SHOWN do
			local bu = _G["MacroPopupButton"..i]
			local ic = _G["MacroPopupButton"..i.."Icon"]

			if not bu.styled then
				bu:SetCheckedTexture(C.media.checked)
				select(2, bu:GetRegions()):Hide()

				bu:SetHighlightTexture(C.media.backdrop)
				local hl = bu:GetHighlightTexture()
				hl:SetAllPoints()
				hl:SetVertexColor(1, 1, 1, .25)

				ic:SetAllPoints()
				ic:SetTexCoord(.08, .92, .08, .92)

				F.CreateBDFrame(bu, .25)

				bu.styled = true
			end
		end
	end)

	local frames = {MacroFrameScrollFrame, MacroPopupEditBox, MacroFrameSelectedMacroButton}
	for _, frame in next, frames do
		F.StripTextures(frame)
		F.CreateBDFrame(frame, .25)
	end

	local buttons = {MacroDeleteButton, MacroNewButton, MacroExitButton, MacroEditButton, MacroPopupFrame.BorderBox.OkayButton, MacroPopupFrame.BorderBox.CancelButton, MacroSaveButton, MacroCancelButton}
	for _, button in next, buttons do
		F.Reskin(button)
	end
end