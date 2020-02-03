local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	B.ReskinFrame(ItemTextFrame)
	B.ReskinScroll(ItemTextScrollFrameScrollBar)
	B.ReskinArrow(ItemTextPrevPageButton, "left")
	B.ReskinArrow(ItemTextNextPageButton, "right")

	hooksecurefunc(ItemTextPageText, "SetTextColor", function(self, r, g, b)
		if r ~= 1 or g ~= 1 or b ~= 1 then
			self:SetTextColor(1, 1, 1)
		end
	end)
end)