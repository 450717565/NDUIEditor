local B, C, L, DB = unpack(select(2, ...))

tinsert(C.defaultThemes, function()
	B.ReskinFrame(BNToastFrame)
	B.ReskinFrame(BNToastFrame.TooltipFrame)

	hooksecurefunc(BNToastFrame, "ShowToast", function(self)
		self:ClearAllPoints()
		self:SetPoint("BOTTOMLEFT", QuickJoinToastButton, "TOPRIGHT", 0, 0)
	end)

	local frame, send, cancel = BattleTagInviteFrame:GetChildren()
	B.ReskinFrame(frame)
	B.ReskinButton(send)
	B.ReskinButton(cancel)
end)