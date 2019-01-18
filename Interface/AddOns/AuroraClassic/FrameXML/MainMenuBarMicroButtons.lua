local F, C = unpack(select(2, ...))

tinsert(C.themes["AuroraClassic"], function()
	local microButtons = {TalentMicroButtonAlert, CollectionsMicroButtonAlert, EJMicroButtonAlert}
		for _, button in pairs(microButtons) do
		button.Arrow:Hide()

		F.ReskinFrame(button)
	end
end)