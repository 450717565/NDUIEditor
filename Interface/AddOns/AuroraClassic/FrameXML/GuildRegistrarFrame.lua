local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.StripTextures(GuildRegistrarFrameEditBox, true)

	GuildRegistrarFrameEditBox:SetHeight(20)
	AvailableServicesText:SetTextColor(1, 1, 1)
	AvailableServicesText:SetShadowColor(0, 0, 0)

	F.ReskinFrame(GuildRegistrarFrame)
	F.CreateBDFrame(GuildRegistrarFrameEditBox, .25)
	F.ReskinButton(GuildRegistrarFrameGoodbyeButton)
	F.ReskinButton(GuildRegistrarFramePurchaseButton)
	F.ReskinButton(GuildRegistrarFrameCancelButton)
end)