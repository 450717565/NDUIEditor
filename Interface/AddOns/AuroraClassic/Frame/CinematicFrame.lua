local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	CinematicFrameCloseDialog:HookScript("OnShow", function(self)
		self:SetScale(UIParent:GetScale())
	end)

	F.ReskinFrame(CinematicFrameCloseDialog)
	F.ReskinButton(CinematicFrameCloseDialogConfirmButton)
	F.ReskinButton(CinematicFrameCloseDialogResumeButton)
end)