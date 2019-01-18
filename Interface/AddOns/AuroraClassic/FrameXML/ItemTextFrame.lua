local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.ReskinFrame(ItemTextFrame)
	F.StripTextures(ItemTextScrollFrame, true)
	F.StripTextures(ItemTextPrevPageButton, true)
	F.StripTextures(ItemTextNextPageButton, true)
	F.ReskinScroll(ItemTextScrollFrameScrollBar)
	F.ReskinArrow(ItemTextPrevPageButton, "left")
	F.ReskinArrow(ItemTextNextPageButton, "right")

	ItemTextPageText:SetTextColor(1, 1, 1)
	ItemTextPageText.SetTextColor = F.dummy
end)