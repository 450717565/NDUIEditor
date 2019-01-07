local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	LevelUpDisplaySide:HookScript("OnShow", function(self)
		for i = 1, #self.unlockList do
			local f = _G["LevelUpDisplaySideUnlockFrame"..i]

			if not f.styled then
				F.ReskinIcon(f.icon, true)

				f.styled = true
			end
		end
	end)
end)