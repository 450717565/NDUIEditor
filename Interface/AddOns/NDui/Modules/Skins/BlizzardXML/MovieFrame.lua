local _, ns = ...
local B, C, L, DB = unpack(ns)

local function Reskin_CloseDialog(frame)
	local dialog = B.GetKeyWord(frame, "CloseDialog")
	dialog:HookScript("OnShow", function(self)
		self:SetScale(UIParent:GetScale())
	end)

	local bg = B.ReskinFrame(dialog)
	bg:SetFrameLevel(dialog:GetFrameLevel()+1)

	local confirmButton = B.GetKeyWord(dialog, "ConfirmButton")
	B.ReskinButton(confirmButton)

	local resumeButton = B.GetKeyWord(dialog, "ResumeButton")
	B.ReskinButton(resumeButton)
end

tinsert(C.XMLThemes, function()
	Reskin_CloseDialog(CinematicFrame)
	Reskin_CloseDialog(MovieFrame)
end)