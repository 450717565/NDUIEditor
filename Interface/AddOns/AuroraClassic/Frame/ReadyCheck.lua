local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	F.ReskinFrame(ReadyCheckFrame)
	F.ReskinButton(ReadyCheckFrameYesButton)
	F.ReskinButton(ReadyCheckFrameNoButton)
	F.StripTextures(ReadyCheckListenerFrame)

	ReadyCheckPortrait:SetAlpha(0)

	ReadyCheckFrame:HookScript("OnShow", function(self)
		if self.initiator and UnitIsUnit("player", self.initiator) then
			self:Hide()
		end
	end)
end)