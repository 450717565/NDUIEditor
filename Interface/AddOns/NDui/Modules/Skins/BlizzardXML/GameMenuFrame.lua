local _, ns = ...
local B, C, L, DB = unpack(ns)

tinsert(C.XMLThemes, function()
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