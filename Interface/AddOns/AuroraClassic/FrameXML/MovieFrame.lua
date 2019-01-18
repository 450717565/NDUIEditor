local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	local CloseDialog = MovieFrame.CloseDialog
	CloseDialog:HookScript("OnShow", function(self)
		self:SetScale(UIParent:GetScale())
	end)

	F.ReskinFrame(CloseDialog)
	F.ReskinButton(CloseDialog.ConfirmButton)
	F.ReskinButton(CloseDialog.ResumeButton)
end)