local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.ReskinPortraitFrame(RecruitAFriendFrame, true)
	F.Reskin(RecruitAFriendFrame.SendButton)
	F.ReskinInput(RecruitAFriendNameEditBox)

	F.StripTextures(RecruitAFriendFrame.NoteFrame, true)
	F.CreateBDFrame(RecruitAFriendFrame.NoteFrame, .25)

	F.ReskinPortraitFrame(RecruitAFriendSentFrame, true)
	F.Reskin(RecruitAFriendSentFrame.OKButton)
end)