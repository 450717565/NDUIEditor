local _, ns = ...
local B, C, L, DB = unpack(ns)

C.LUAThemes["Blizzard_WeeklyRewards"] = function()
	B.ReskinFrame(WeeklyRewardsFrame)

	local Text = WeeklyRewardsFrame.HeaderFrame.Text
	Text:SetFontObject(SystemFont_Huge1)
	B.ReskinText(Text, 1, .8, 0)
end