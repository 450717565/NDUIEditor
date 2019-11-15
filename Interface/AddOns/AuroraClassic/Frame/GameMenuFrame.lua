local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.ReskinFrame(GameMenuFrame)
	F.ReskinHeader(GameMenuFrame)

	local buttons = {
		GameMenuButtonAddons,
		GameMenuButtonContinue,
		GameMenuButtonHelp,
		GameMenuButtonKeybindings,
		GameMenuButtonLogout,
		GameMenuButtonMacros,
		GameMenuButtonOptions,
		GameMenuButtonQuit,
		GameMenuButtonStore,
		GameMenuButtonUIOptions,
		GameMenuButtonWhatsNew,
	}

	for _, button in pairs(buttons) do
		F.ReskinButton(button)
	end
end)