local _, ns = ...
local B, C, L, DB = unpack(ns)

local function Reskin_LossOfControlFrame(self)
	if not self.styled then
		B.ReskinIcon(self.Icon)

		self.styled = true
	end
end

tinsert(C.XMLThemes, function()
	hooksecurefunc("LossOfControlFrame_SetUpDisplay", Reskin_LossOfControlFrame)
end)