local F, C = unpack(select(2, ...))

C.login["!BaudErrorFrame"] = function()
	F.ReskinScroll(BaudErrorFrameListScrollBoxScrollBarScrollBar)
	F.ReskinScroll(BaudErrorFrameDetailScrollFrameScrollBar)
end