local F, C = unpack(select(2, ...))

C.themes["!BaudErrorFrame"] = function()
	F.ReskinScroll(BaudErrorFrameListScrollBoxScrollBarScrollBar)
	F.ReskinScroll(BaudErrorFrameDetailScrollFrameScrollBar)
end