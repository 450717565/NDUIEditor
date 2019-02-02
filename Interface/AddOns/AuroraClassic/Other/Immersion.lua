local F, C = unpack(select(2, ...))

C.themes["Immersion"] = function()
	local talkbox = ImmersionFrame.TalkBox.MainFrame
	F.ReskinClose(talkbox.CloseButton, "TOPRIGHT", talkbox, "TOPRIGHT", -20, -20)
end