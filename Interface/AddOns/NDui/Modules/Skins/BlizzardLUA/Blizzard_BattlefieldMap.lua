local _, ns = ...
local B, C, L, DB = unpack(ns)

C.LUAThemes["Blizzard_BattlefieldMap"] = function()
	local BorderFrame = BattlefieldMapFrame.BorderFrame

	local bg = B.ReskinFrame(BorderFrame)
	bg:SetParent(BattlefieldMapFrame)
	bg:SetOutside(BattlefieldMapFrame.ScrollContainer)

	B.ReskinTab(BattlefieldMapTab)
	B.ReskinFrame(OpacityFrame)
	B.ReskinSlider(OpacityFrameSlider, true)
end