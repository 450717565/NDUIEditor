local _, ns = ...
local B, C, L, DB = unpack(ns)

local function Reskin_LevelUpDisplaySide(self)
	for i = 1, #self.unlockList do
		local frame = _G["LevelUpDisplaySideUnlockFrame"..i]

		if not frame.styled then
			B.ReskinIcon(frame.icon)

			frame.styled = true
		end
	end
end

tinsert(C.XMLThemes, function()
	if DB.isNewPatch then return end

	LevelUpDisplaySide:HookScript("OnShow", Reskin_LevelUpDisplaySide)
end)