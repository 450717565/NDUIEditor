local _, ns = ...
local B, C, L, DB = unpack(ns)

local function Reskin_HelpTips(self)
	for frame in self.framePool:EnumerateActive() do
		if frame and not frame.styled then
			if frame.OkayButton then B.ReskinButton(frame.OkayButton) end
			if frame.CloseButton then B.ReskinClose(frame.CloseButton) end

			frame.styled = true
		end
	end
end

tinsert(C.XMLThemes, function()
	Reskin_HelpTips(HelpTip)
	hooksecurefunc(HelpTip, "Show", Reskin_HelpTips)
end)