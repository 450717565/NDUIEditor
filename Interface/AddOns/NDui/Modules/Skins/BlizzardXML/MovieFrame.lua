local _, ns = ...
local B, C, L, DB = unpack(ns)

local function Reskin_CloseDialog(frame)
	local frameName = frame:GetDebugName()
	local dialog = frame.CloseDialog or (frameName and _G[frameName.."CloseDialog"])
	dialog:HookScript("OnShow", function(self)
		self:SetScale(UIParent:GetScale())
	end)

	local bg = B.ReskinFrame(dialog)
	bg:SetFrameLevel(dialog:GetFrameLevel()+1)

	local dialogName = dialog:GetDebugName()
	local confirmButton = dialog.ConfirmButton or (dialogName and _G[dialogName.."ConfirmButton"])
	B.ReskinButton(confirmButton)

	local resumeButton = dialog.ResumeButton or (dialogName and _G[dialogName.."ResumeButton"])
	B.ReskinButton(resumeButton)
end

tinsert(C.XMLThemes, function()
	Reskin_CloseDialog(CinematicFrame)
	Reskin_CloseDialog(MovieFrame)
end)