local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.Reskin(SplashFrame.BottomCloseButton)
	F.ReskinClose(SplashFrame.TopCloseButton, "TOPRIGHT", SplashFrame, "TOPRIGHT", -18, -18)

	SplashFrame.Label:SetTextColor(1, .8, 0)
end)