local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.ReskinFrame(ReadyCheckFrame)
	ReadyCheckPortrait:SetAlpha(0)
	select(2, ReadyCheckListenerFrame:GetRegions()):Hide()

	ReadyCheckFrame:HookScript("OnShow", function(self)
		if UnitIsUnit("player", self.initiator) then
			self:Hide()
		end
	end)

	F.ReskinButton(ReadyCheckFrameYesButton)
	F.ReskinButton(ReadyCheckFrameNoButton)
end)