local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	hooksecurefunc("LossOfControlFrame_SetUpDisplay", function(self)
		if not self.styled then
			B.ReskinIcon(self.Icon)

			self.styled = true
		end
	end)
end)