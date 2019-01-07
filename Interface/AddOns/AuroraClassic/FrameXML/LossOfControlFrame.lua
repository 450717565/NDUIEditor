local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	hooksecurefunc("LossOfControlFrame_SetUpDisplay", function(self)
		if not self.styled then
			F.ReskinIcon(self.Icon, true)

			self.styled = true
		end
	end)
end)