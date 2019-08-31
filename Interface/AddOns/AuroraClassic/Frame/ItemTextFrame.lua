local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.ReskinFrame(ItemTextFrame)
	F.ReskinScroll(ItemTextScrollFrameScrollBar)
	F.ReskinArrow(ItemTextPrevPageButton, "left")
	F.ReskinArrow(ItemTextNextPageButton, "right")

	hooksecurefunc(ItemTextPageText, "SetTextColor", function(self, r, g, b)
		if r ~= 1 or g ~= 1 or b ~= 1 then
			self:SetTextColor(1, 1, 1)
		end
	end)
end)