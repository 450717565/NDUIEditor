local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function()
	f:UnregisterEvent("PLAYER_ENTERING_WORLD")
	if IsAddOnLoaded("Aurora") then
		local F = unpack(Aurora)
		F.CreateBD(BuyEmAllFrame)
		F.CreateSD(BuyEmAllFrame)
		F.Reskin(BuyEmAllOkayButton)
		F.Reskin(BuyEmAllCancelButton)
		F.Reskin(BuyEmAllStackButton)
		F.Reskin(BuyEmAllMaxButton)
		F.ReskinArrow(BuyEmAllLeftButton, "left")
		F.ReskinArrow(BuyEmAllRightButton, "right")
		for i = 1, 3 do
			select(i, BuyEmAllFrame:GetRegions()):Hide()
		end
	elseif IsAddOnLoaded("NDui") then
		local B = unpack(NDui)
		B.CreateBD(BuyEmAllFrame)
		B.CreateTex(BuyEmAllFrame)
		for i = 1, 3 do
			select(i, BuyEmAllFrame:GetRegions()):Hide()
		end
	end
end)