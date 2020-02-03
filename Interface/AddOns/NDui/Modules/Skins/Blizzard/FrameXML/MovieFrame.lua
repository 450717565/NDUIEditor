local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	local CloseDialog = MovieFrame.CloseDialog
	CloseDialog:HookScript("OnShow", function(self)
		self:SetScale(UIParent:GetScale())
	end)

	B.ReskinFrame(CloseDialog)
	B.ReskinButton(CloseDialog.ConfirmButton)
	B.ReskinButton(CloseDialog.ResumeButton)
end)