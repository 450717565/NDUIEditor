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

	MacroPopupFrame:SetHeight(525)
	F.StripTextures(MacroPopupFrame, true)
	F.StripTextures(MacroPopupFrame.BorderBox, true)
	F.CreateBD(MacroPopupFrame)
	F.CreateSD(MacroPopupFrame)

	local function reskinButton(button, i)
		local bu = _G[button..i]
		local ic = _G[button..i.."Icon"]

		if bu and ic then
			F.StripTextures(bu)

			bu:SetCheckedTexture(C.media.checked)
			ic:SetAllPoints()
			ic:SetTexCoord(.08, .92, .08, .92)

			local bg = F.CreateBDFrame(bu, .25)
			F.ReskinTexture(bu, false, bg)
		end
	end

	for i = 1, MAX_ACCOUNT_MACROS do
		reskinButton("MacroButton", i)
	end

	local styled = false
	MacroPopupFrame:HookScript("OnShow", function()
		if not styled then
			for i = 1, NUM_MACRO_ICONS_SHOWN do
				reskinButton("MacroPopupButton", i)
			end

			styled = true
		end
	end)

	local frames = {MacroFrameScrollFrame, MacroPopupEditBox}
	for _, frame in next, frames do
		F.StripTextures(frame)
		F.CreateBDFrame(frame, .25)
	end

	local buttons = {MacroDeleteButton, MacroNewButton, MacroExitButton, MacroEditButton, MacroPopupFrame.BorderBox.OkayButton, MacroPopupFrame.BorderBox.CancelButton, MacroSaveButton, MacroCancelButton}
	for _, button in next, buttons do
		F.Reskin(button)
	end

	local selectedbt = MacroFrameSelectedMacroButton
	F.StripTextures(selectedbt)
	selectedbt:ClearAllPoints()
	selectedbt:SetPoint("BOTTOMRIGHT", MacroEditButton, "BOTTOMLEFT", -7, C.mult)

	local selectedic = MacroFrameSelectedMacroButtonIcon
	selectedic:SetAllPoints()
	selectedic:SetTexCoord(.08, .92, .08, .92)

	local selectedbg = F.CreateBDFrame(selectedbt, .25)
	F.ReskinTexture(selectedbt, false, selectedbg)

	MacroNewButton:ClearAllPoints()
	MacroNewButton:SetPoint("RIGHT", MacroExitButton, "LEFT", -2, 0)
end