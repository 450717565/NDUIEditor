local B, C, L, DB = unpack(select(2, ...))
local Skins = B:GetModule("Skins")

function Skins:Simulationcraft()
	if not IsAddOnLoaded("Simulationcraft") then return end

	B.ReskinFrame(SimcCopyFrame)
	B.ReskinButton(SimcCopyFrameButton)
	B.ReskinScroll(SimcCopyFrameScrollScrollBar)
end