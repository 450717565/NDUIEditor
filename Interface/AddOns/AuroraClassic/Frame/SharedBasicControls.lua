local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	ScriptErrorsFrame:SetScale(UIParent:GetScale())
	ScriptErrorsFrame:SetSize(386, 274)

	F.ReskinFrame(ScriptErrorsFrame)
	F.ReskinClose(ScriptErrorsFrameClose)
	F.ReskinButton(ScriptErrorsFrame.Reload)
	F.ReskinButton(ScriptErrorsFrame.Close)
	F.ReskinArrow(ScriptErrorsFrame.PreviousError, "left")
	F.ReskinArrow(ScriptErrorsFrame.NextError, "right")
	F.ReskinScroll(ScriptErrorsFrameScrollBar)
end)