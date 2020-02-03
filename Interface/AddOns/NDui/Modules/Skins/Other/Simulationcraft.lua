local B, C, L, DB = unpack(select(2, ...))
local S = B:GetModule("Skins")

function S:Simulationcraft()
	if not NDuiDB["Skins"]["BlizzardSkins"] then return end
	if not IsAddOnLoaded("Simulationcraft") then return end

	B.ReskinFrame(SimcCopyFrame)
	B.ReskinButton(SimcCopyFrameButton)
	B.ReskinScroll(SimcCopyFrameScrollScrollBar)
end