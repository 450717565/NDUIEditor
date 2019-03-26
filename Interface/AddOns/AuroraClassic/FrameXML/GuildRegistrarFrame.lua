local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.ReskinFrame(GuildRegistrarFrame)
	F.ReskinInput(GuildRegistrarFrameEditBox, 20)

	AvailableServicesText:SetTextColor(1, .8, 0)

	local buttons = {GuildRegistrarFrameGoodbyeButton, GuildRegistrarFramePurchaseButton, GuildRegistrarFrameCancelButton}
	for _, button in pairs(buttons) do
		F.ReskinButton(button)
	end
end)