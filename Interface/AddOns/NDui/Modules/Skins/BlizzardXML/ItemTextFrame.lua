local _, ns = ...
local B, C, L, DB = unpack(ns)

local function Reskin_TextColor(self, r, g, b)
	if r ~= 1 or g ~= 1 or b ~= 1 then
		B.ReskinText(self, 1, 1, 1)
	end
end

tinsert(C.XMLThemes, function()
	B.ReskinFrame(ItemTextFrame)
	B.ReskinScroll(ItemTextScrollFrameScrollBar)
	B.ReskinArrow(ItemTextPrevPageButton, "left")
	B.ReskinArrow(ItemTextNextPageButton, "right")

	hooksecurefunc(ItemTextPageText, "SetTextColor", Reskin_TextColor)
end)