local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	CinematicFrameCloseDialog:HookScript("OnShow", function(self)
		self:SetScale(UIParent:GetScale())
	end)

	B.ReskinFrame(CinematicFrameCloseDialog)
	B.ReskinButton(CinematicFrameCloseDialogConfirmButton)
	B.ReskinButton(CinematicFrameCloseDialogResumeButton)
end)