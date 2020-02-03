local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	B.ReskinFrame(GuildRegistrarFrame)
	B.ReskinInput(GuildRegistrarFrameEditBox, 20)

	AvailableServicesText:SetTextColor(1, .8, 0)

	local buttons = {GuildRegistrarFrameGoodbyeButton, GuildRegistrarFramePurchaseButton, GuildRegistrarFrameCancelButton}
	for _, button in pairs(buttons) do
		B.ReskinButton(button)
	end
end)