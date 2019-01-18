local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	GameMenuFrameHeader:SetAlpha(0)
	GameMenuFrameHeader:ClearAllPoints()
	GameMenuFrameHeader:SetPoint("TOP", 0, 7)
	F.ReskinFrame(GameMenuFrame)

	local buttons = {
		GameMenuButtonHelp,
		GameMenuButtonWhatsNew,
		GameMenuButtonStore,
		GameMenuButtonOptions,
		GameMenuButtonUIOptions,
		GameMenuButtonKeybindings,
		GameMenuButtonMacros,
		GameMenuButtonAddons,
		GameMenuButtonLogout,
		GameMenuButtonQuit,
		GameMenuButtonContinue
	}

	for _, button in next, buttons do
		F.ReskinButton(button)
	end
end)