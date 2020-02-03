local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	ScriptErrorsFrame:SetScale(UIParent:GetScale())
	ScriptErrorsFrame:SetSize(386, 274)

	B.ReskinFrame(ScriptErrorsFrame)
	B.ReskinClose(ScriptErrorsFrameClose)
	B.ReskinButton(ScriptErrorsFrame.Reload)
	B.ReskinButton(ScriptErrorsFrame.Close)
	B.ReskinArrow(ScriptErrorsFrame.PreviousError, "left")
	B.ReskinArrow(ScriptErrorsFrame.NextError, "right")
	B.ReskinScroll(ScriptErrorsFrameScrollBar)
end)