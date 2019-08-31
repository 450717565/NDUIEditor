local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.ReskinFrame(RecruitAFriendFrame)
	F.ReskinButton(RecruitAFriendFrame.SendButton)
	F.ReskinInput(RecruitAFriendNameEditBox)

	F.StripTextures(RecruitAFriendFrame.NoteFrame, true)
	F.CreateBDFrame(RecruitAFriendFrame.NoteFrame, 0)

	F.ReskinFrame(RecruitAFriendSentFrame)
	F.ReskinButton(RecruitAFriendSentFrame.OKButton)
end)