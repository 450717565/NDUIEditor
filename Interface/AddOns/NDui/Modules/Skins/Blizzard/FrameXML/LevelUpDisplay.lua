local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	LevelUpDisplaySide:HookScript("OnShow", function(self)
		for i = 1, #self.unlockList do
			local f = _G["LevelUpDisplaySideUnlockFrame"..i]

			if not f.styled then
				B.ReskinIcon(f.icon)

				f.styled = true
			end
		end
	end)
end)