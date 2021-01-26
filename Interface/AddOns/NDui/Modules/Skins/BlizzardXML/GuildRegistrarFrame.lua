local _, ns = ...
local B, C, L, DB = unpack(ns)

tinsert(C.XMLThemes, function()
	B.ReskinFrame(GuildRegistrarFrame)
	B.ReskinInput(GuildRegistrarFrameEditBox, 20)
	B.ReskinText(AvailableServicesText, 1, .8, 0)

	local buttons = {
		GuildRegistrarFrameGoodbyeButton,
		GuildRegistrarFramePurchaseButton,
		GuildRegistrarFrameCancelButton,
	}
	for _, button in pairs(buttons) do
		B.ReskinButton(button)
	end
end)