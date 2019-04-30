local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.ReskinFrame(ItemTextFrame)
	F.ReskinScroll(ItemTextScrollFrameScrollBar)
	F.ReskinArrow(ItemTextPrevPageButton, "left")
	F.ReskinArrow(ItemTextNextPageButton, "right")

	hooksecurefunc("ItemTextFrame_OnEvent", function(self, event)
		if event == "ITEM_TEXT_BEGIN" then
			textColor[1], textColor[2], textColor[3] = 1, 1, 1
			titleColor[1], titleColor[2], titleColor[3] = 1, 1, 1
		end
	end)
end)