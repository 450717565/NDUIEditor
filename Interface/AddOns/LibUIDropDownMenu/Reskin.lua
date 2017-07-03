if not IsAddOnLoaded("Aurora") then return end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function()
	f:UnregisterEvent("PLAYER_ENTERING_WORLD")
	local F = unpack(Aurora)
	for i=1, L_UIDROPDOWNMENU_MAXLEVELS do
		F.CreateBD(_G["L_DropDownList"..i.."MenuBackdrop"])
		F.CreateSD(_G["L_DropDownList"..i.."MenuBackdrop"])
	end
end)