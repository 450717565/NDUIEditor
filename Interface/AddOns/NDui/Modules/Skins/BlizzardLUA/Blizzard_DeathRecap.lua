local _, ns = ...
local B, C, L, DB = unpack(ns)

C.LUAThemes["Blizzard_DeathRecap"] = function()
	B.StripTextures(DeathRecapFrame)
	B.CreateBG(DeathRecapFrame)
	B.ReskinButton(DeathRecapFrame.CloseButton)
	B.ReskinClose(DeathRecapFrame.CloseXButton)

	for i = 1, NUM_DEATH_RECAP_EVENTS do
		local SpellInfo = DeathRecapFrame["Recap"..i].SpellInfo
		SpellInfo.IconBorder:Hide()
		B.ReskinIcon(SpellInfo.Icon)
	end
end