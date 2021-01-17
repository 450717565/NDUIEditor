local _, ns = ...
local B, C, L, DB, P = unpack(ns)
local Skins = B:GetModule("Skins")

function Skins:HandyNotes()
	if IsAddOnLoaded("HandyNotes_Shadowlands") then
		B.ReskinSlider(HandyNotes_ShadowlandsAlphaMenuSliderOption.Slider)
		B.ReskinSlider(HandyNotes_ShadowlandsScaleMenuSliderOption.Slider)
	end
end