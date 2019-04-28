local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.ReskinFrame(ScrollOfResurrectionSelectionFrame)
	F.ReskinFrame(ScrollOfResurrectionFrame)

	if not C.isNewPatch then
		ScrollOfResurrectionSelectionFrameBackground:Hide()
	end

	F.ReskinScroll(ScrollOfResurrectionSelectionFrameListScrollFrameScrollBar)
	F.ReskinInput(ScrollOfResurrectionSelectionFrameTargetEditBox)
	F.ReskinInput(ScrollOfResurrectionFrameNoteFrame)
	F.ReskinButton(ScrollOfResurrectionSelectionFrameAcceptButton)
	F.ReskinButton(ScrollOfResurrectionSelectionFrameCancelButton)
	F.ReskinButton(ScrollOfResurrectionFrameAcceptButton)
	F.ReskinButton(ScrollOfResurrectionFrameCancelButton)
	F.CreateBDFrame(ScrollOfResurrectionSelectionFrameList, 0)
end)