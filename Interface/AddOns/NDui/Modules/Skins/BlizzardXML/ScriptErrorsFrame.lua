local _, ns = ...
local B, C, L, DB = unpack(ns)

tinsert(C.XMLThemes, function()
	ScriptErrorsFrame:SetScale(UIParent:GetScale())

	B.StripTextures(ScriptErrorsFrame)
	B.CreateBG(ScriptErrorsFrame)
	B.ReskinClose(ScriptErrorsFrameClose)
	B.ReskinButton(ScriptErrorsFrame.Reload)
	B.ReskinButton(ScriptErrorsFrame.Close)
	B.ReskinArrow(ScriptErrorsFrame.PreviousError, "left")
	B.ReskinArrow(ScriptErrorsFrame.NextError, "right")
	B.ReskinScroll(ScriptErrorsFrameScrollBar)
end)