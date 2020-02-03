local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	B.ReskinFrame(GameMenuFrame)

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
		B.ReskinButton(button)
	end
end)